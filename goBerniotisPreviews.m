%% 125 Hz transposed stimuli in and out of phase
function goBerniotisPreviews(listener,InterauralTonePhase,inQuiet)
% InterauralTonePhase=pi or 0;
% inQuiet = 1 or 0;

if inQuiet == 1
    starting_SNR = -40;
else
    starting_SNR = -99;
end
ToneFreq=125;
TranspositionFreq = 4000;
NoiseBandWidth=100;
%BackNzLevel=0.035565588/2;

preSilence=300;

NumSignalPulses= 3;
ToneDuration=200;
WithinPulseISI=50;
ISI=300;
signalInterval = 100+ NumSignalPulses*ToneDuration + (NumSignalPulses-1) * WithinPulseISI;
NoiseDuration=signalInterval;
LongMaskerNoise= 0; % 600 + 3 * NoiseDuration + 2 * ISI;
RiseFall=20;

Berniotis(listener,'fixed','noise','NoiseBandWidth',NoiseBandWidth,...
    'InterauralTonePhase', InterauralTonePhase, 'TranspositionFreq', TranspositionFreq,'ToneFreq', ToneFreq, ...
    'RiseFall', RiseFall, 'inQuiet', inQuiet, ...
    'VolumeSettingsFile', 'VolumeSettings4kHz.txt', ...
    'NumSignalPulses', NumSignalPulses,'ToneDuration', ToneDuration, 'WithinPulseISI', WithinPulseISI,...
    'NoiseDuration', NoiseDuration,'ISI', ISI, 'preSilence', preSilence, ...
    'BackNzPulsed', 0, 'BackNzLoPass', 1300, 'BackNzHiPass', 50,  ...
    'LongMaskerNoise', LongMaskerNoise, ...
    'starting_SNR',starting_SNR,...
    'PlotTrackFile', 1, 'outputAllWavs', 1, 'DEBUG',0);
