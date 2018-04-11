clear
close all
p=BerniotisParseArgs('L27', 'NumSignalPulses', 3, 'starting_SNR',-20,...
    'InterauralTonePhase', pi, 'ISI', 300, ...
    'preSilence', 0, ...
    'ToneDuration', 250, 'WithinPulseISI', 100, 'NoiseDuration', 1000, ...
    'TranspositionFreq', 4000, 'LongMaskerNoise', 00, 'fixed', 'noise','BackNzLevel', .005);
% LMN 3400
p.trial = 1;
p.Order=1;

% 

w=GenerateSxNxTonalTriple(p);
% function [OutWave, flag] = no_clip(InWave,message)
[w, flag] = NoClipStereo(w);
audiowrite('demoSxNxTriple.wav',w,p.SampFreq)
w= vertcat(zeros(p.SampFreq*100/1000,2),w);
playEm = audioplayer(w,p.SampFreq);
pwelch(w(:,1),[],[],[],p.SampFreq)
play(playEm);
% sound(w,p.SampFreq)
return
pwelch(w(:,1),[],[],[],p.SampFreq)
return

plot(w)
sound(w,p.SampFreq)