% function Nz = GenerateBackgroundNoise(p)
clear
close all
p=BerniotisParseArgs('L01', 'NumSignalPulses', 1, 'starting_SNR',0, ...
    'usePlayrec', 0, 'RMEslider', 'FALSE');
p.trial = 1;

Nz = GenerateBackgroundNoise(p);
pwelch(Nz,[],[],512,p.SampFreq);
t=(0:(length(Nz)-1))/p.SampFreq;
figure, plot(t,Nz)
return



p=BerniotisParseArgs('L01', 'NumSignalPulses', 1, 'starting_SNR',20,...
    'ToneDuration', 100, 'WithinPulseISI', 100, 'NoiseDuration', 600, ...
    'fixed', 'signal', 'BackNzPulsed', 0, ...
    'BackNzLoPass', 1300, 'BackNzHiPass', 50, 'BackNzLevel', .005);
p.trial = 1;

Nz = GenerateBackgroundNoise(p);
pwelch(Nz,[],[],512,p.SampFreq);
figure, plot(Nz)
return

p.addParameter('BackNzLevel',0, @isnumeric); % in absolute rms
p.addParameter('BackNzLoPass',0, @isnumeric);
p.addParameter('BackNzHiPass',50, @isnumeric);