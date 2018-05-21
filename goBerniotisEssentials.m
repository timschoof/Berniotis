%% 125 Hz transposed stimuli in and out of phase
Berniotis('TS', 'PlotTrackFile', 1, 'outputAllWavs', 1, 'DEBUG',0, ...
    'InterauralTonePhase', 'pi', 'BackNzLevel',0, ...
    'usePlayrec', 0, 'RMEslider', 'FALSE','preSilence', 00);
        
return
.035,...
ToneFreq=125;
TranspositionFreq = 4000;
NoiseBandWidth=100;
BackNzLevel=0.035565588;
inQuiet=0;
preSilence=300;

NumSignalPulses= 1;
ToneDuration=300;
WithinPulseISI=300;
ISI=300;
% signalInterval = NumSignalPulses*ToneDuration + (NumSignalPulses-1) * WithinPulseISI;
NoiseDuration=ToneDuration; % signalInterval;
LongMaskerNoise= 0; % 600 + 3 * NoiseDuration + 2 * ISI;
RiseFall=20;

InterauralTonePhase='pi';
Berniotis('TS','fixed','noise','rms2use', 0.25,'NoiseBandWidth',NoiseBandWidth,...
    'usePlayrec', 0, 'RMEslider', 'FALSE','preSilence', 100,...
    'InterauralTonePhase', InterauralTonePhase, 'TranspositionFreq', TranspositionFreq,'ToneFreq', ToneFreq, ...
    'RiseFall', RiseFall, 'inQuiet', inQuiet, ...
    'VolumeSettingsFile', 'VolumeSettings4kHz.txt', ...
    'NumSignalPulses', NumSignalPulses,'ToneDuration', ToneDuration, 'WithinPulseISI', WithinPulseISI,...
    'NoiseDuration', NoiseDuration,'ISI', ISI, 'preSilence', preSilence, ...
    'starting_SNR',9,...
    'BackNzPulsed', 0, 'BackNzLoPass', 1300, 'BackNzHiPass', 50, 'BackNzLevel', BackNzLevel, ...
    'LongMaskerNoise', LongMaskerNoise, ...
    'PlotTrackFile', 1, 'outputAllWavs', 1, 'DEBUG',0);
%return
InterauralTonePhase=0;
Berniotis('TS','fixed','noise','rms2use', 0.07,'NoiseBandWidth',NoiseBandWidth,...
    'InterauralTonePhase', InterauralTonePhase, 'TranspositionFreq', TranspositionFreq,'ToneFreq', ToneFreq, ...
    'RiseFall', RiseFall, 'inQuiet', inQuiet, ...
    'VolumeSettingsFile', 'VolumeSettings4kHz.txt', ...
    'NumSignalPulses', NumSignalPulses,'ToneDuration', ToneDuration, 'WithinPulseISI', WithinPulseISI,...
    'NoiseDuration', NoiseDuration,'ISI', ISI, 'preSilence', preSilence, ...
    'starting_SNR',18,...
    'BackNzPulsed', 0, 'BackNzLoPass', 1300, 'BackNzHiPass', 50, 'BackNzLevel', BackNzLevel, ...
    'LongMaskerNoise', LongMaskerNoise, ...
    'PlotTrackFile', 1, 'outputAllWavs', 1, 'DEBUG',0);
return
