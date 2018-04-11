% function GenerateSxNxTonalSound(ToneFreq, InterauralTonePhase, NoiseBandLimits, fixed, rms2use, SNR, SampFreq)

clear
close all
p=BerniotisParseArgs('L01', 'NumSignalPulses', 1, 'starting_SNR',0,...
    'ToneDuration', 500, 'WithinPulseISI', 100, 'NoiseDuration', 500, ...
    'LongMaskerNoise', 00, 'fixed', 'signal');
p.trial = 1;
TonePresent=1;


[w, Nz, Tn, flatNz, flatTn] = GenerateSxNxTonalSound(TonePresent, p);
20*log10(rms(flatTn)/rms(flatNz))

return
w=Nz; % for long noise

pwelch(w,[],[],[],p.SampFreq)
figure
plot([w])
plot(Tn)

size(w)
plot(w)
sound(w,p.SampFreq)
audiowrite('demoSxNx.wav',w,p.SampFreq)
%w(:,2)=0;



