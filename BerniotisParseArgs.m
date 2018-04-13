function sArgs=BerniotisParseArgs(ListenerName,varargin)

% get arguments for Berniotis

% ToneFreq in Hz
% InteruralTonePhase = 0 or pi
% NoiseBandLimits = 2 element vector
% fixed =  'noise' or 'signal'
% rms2use
% SNR
% SampFreq  

p = inputParser;
p.addRequired('ListenerName', @ischar);

p.addParameter('ToneFreq', 500, @isnumeric);
p.addParameter('NumSignalPulses',  1, @isnumeric);
% the number of distinct pulses in the target
p.addParameter('ToneDuration', 400, @isnumeric);  
p.addParameter('WithinPulseISI', 100, @isnumeric);  
p.addParameter('NoiseDuration', 500, @isnumeric);
% the duration of the masker pulse. If longer than the probe, the probe is
% centred in it. Only relevant if LongMaskerNoise=0
p.addParameter('LongMaskerNoise', 0, @isnumeric);
% if 0, masker noise is pulsed along with target intervals
% if >0 = continuous through triple at given duration (ms)
p.addParameter('preSilence', 100, @isnumeric);
% an interval of silence prepended to the wavr to try to avoid sound glitches in Windows
p.addParameter('InterauralTonePhase', 0, @isnumeric);
p.addParameter('TranspositionFreq', 0, @isnumeric);
p.addParameter('TranspositionLoPassCutoff', 1500, @isnumeric);
p.addParameter('TranspositionSmoothingFilterOrder', 4, @isnumeric);  
p.addParameter('rms2use',0.15, @isnumeric);
p.addParameter('NoiseBandWidth', 100, @isnumeric); % always centred on the probe  
p.addParameter('RiseFall', 50, @isnumeric);  
p.addParameter('ISI', 400, @isnumeric);  
p.addParameter('fixed', 'noise',  @(x)any(strcmpi(x,{'noise','signal'})));
p.addParameter('dBSPL', 70, @isnumeric);
% the nominal level of the fixed signal or noise - not yet used

%% parameters concerned with tracking and the task
p.addParameter('inQuiet',0, @isnumeric); 
% present tones in quiet in order to find absolute threshold without the
% masker present. Only makes sense for foxed masker
p.addParameter('starting_SNR',20, @isnumeric);
p.addParameter('START_change_dB', 5, @isnumeric);
p.addParameter('MIN_change_dB', 2, @isnumeric);
p.addParameter('LevittsK', 2, @isnumeric);
p.addParameter('INITIAL_TURNS', 3, @isnumeric);
p.addParameter('FINAL_TURNS', 4, @isnumeric); 
p.addParameter('InitialDescentMinimum', -22, @isnumeric); 
p.addParameter('TaskFormat', '3I-3AFC', @(x)any(strcmpi(x,{'3I-3AFC','3I-2AFC'})));
p.addParameter('Order', 2, @isnumeric);
p.addParameter('FeedBack', 'Corrective', @ischar);
p.addParameter('MAX_TRIALS', 30, @isnumeric);
p.addParameter('FacePixDir', 'Bears', @ischar);
%% parameters concerned with background noise
p.addParameter('BackNzLevel',0.035, @isnumeric); % in absolute rms
p.addParameter('BackNzLoPass',1500, @isnumeric);
p.addParameter('BackNzHiPass',50, @isnumeric);
p.addParameter('BackNzPulsed',0, @isnumeric); % 0 = continuous through triple
%% parameters concerned with debugging
p.addParameter('PlotTrackFile', 0, @isnumeric);
p.addParameter('DEBUG', 0, @isnumeric);    
p.addParameter('outputAllWavs', 0, @isnumeric); % for debugging purposes 
p.addParameter('MAX_SNR_dB', 22, @isnumeric);    
p.addParameter('IgnoreTrials', 3, @isnumeric); % number of initial trials to ignore errors on
p.addParameter('OutputDir','results', @ischar);
p.addParameter('StartMessage', 'none', @ischar);
p.addParameter('MaxBumps', 3, @isnumeric);   
p.addParameter('SampFreq', 44100, @isnumeric);    
p.addParameter('VolumeSettingsFile', 'VolumeSettings.txt', @ischar);

% p.addParamValue('PresentInQuiet', 0, @(x)x==0 || x==1);

p.parse(ListenerName, varargin{:});
sArgs=p.Results;
sArgs.SNR_dB = sArgs.starting_SNR; % current level
sArgs.NoiseBandLimits=[sArgs.ToneFreq-sArgs.NoiseBandWidth/2 sArgs.ToneFreq+sArgs.NoiseBandWidth/2];

if sArgs.TranspositionFreq>0
% lowpass filter for forwards/backwards
[sArgs.blo,sArgs.alo]=butter(sArgs.TranspositionSmoothingFilterOrder/2, ...
    ButterLoPassTweak(-1.5, sArgs.TranspositionLoPassCutoff, sArgs.TranspositionSmoothingFilterOrder/2)/(sArgs.SampFreq/2));
else
    sArgs.blo=0;sArgs.alo=0;
end

% if masker is fixed, calculate relative spectrum level of masker and
% background noise
if strcmp(sArgs.fixed, 'noise') && sArgs.BackNzLevel>0
    masker_dBperHz = 20*log10(sArgs.rms2use)-10*log10(sArgs.NoiseBandWidth);
    backgroundNz_dBperHz = 20*log10(sArgs.BackNzLevel)-10*log10(sArgs.BackNzLoPass-sArgs.BackNzHiPass);
    sArgs.BackNzdB_re_Msk =  backgroundNz_dBperHz-masker_dBperHz;
    fprintf('BackNzdB_re_Msk= %3.1f\n', sArgs.BackNzdB_re_Msk);
end

% calculate initialDelay, the time before the 1st signal interval can occur
signalInterval = sArgs.NumSignalPulses*sArgs.ToneDuration + (sArgs.NumSignalPulses-1) * sArgs.WithinPulseISI;
if sArgs.LongMaskerNoise<=0 % if maskers are pulsed
    sArgs.initialDelay = (sArgs.NoiseDuration-signalInterval)/2;
else
    sArgs.initialDelay = (sArgs.LongMaskerNoise - (3*signalInterval+2*sArgs.ISI))/2;
end
sArgs.initialDelay = sArgs.initialDelay + sArgs.preSilence;

% throw error for trying to obtain a threshold for the signal with the
% signal level fixed
if sArgs.inQuiet && strcmp(sArgs.fixed, 'signal')
    error('Noise must be fixed to do test in quiet');
end

%     [ListenerName,TargetsFile,MaskerFile,starting_SNR,START_change_dB,MIN_change_dB,...
%         MAX_TRIALS,LevittsK,ResponseChoices,PresentInQuiet,HRTF,TargetAz,MaskerAz,CatchTrials, Ear]...
%         =SpecifyTestOrders;