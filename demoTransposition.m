% function w=GenerateSxNxTonalTriple(Order, ToneFreq, InterauralTonePhase, NoiseBandLimits, fixed, rms2use, SNR, SampFreq)
%
% ToneFreq=500;
% InterauralTonePhase=0;
% %InterauralTonePhase=pi;
% NoiseBandLimits=[200 800];
% fixed='noise';
% %fixed='signal';
% rms2use=0.05;
% SNR=8;
% SampFreq=44100;

% p.Order=2;
clear
TonePresent=1;
p=BerniotisParseArgs('L27', 'starting_SNR',100,'rms2use', 0.07,'fixed', 'signal',...
    'ToneFreq', 125,'NoiseBandWidth', 100, 'TranspositionFreq', 4000 ,'InterauralTonePhase', pi);
[w, Nz, Tn, flatNz, flatTn] = GenerateSxNxTonalSound(TonePresent, p);
20*log10(rms(flatTn)/rms(flatNz))
w=GenerateSxNxTonalTriple(p);
plot(w)
figure
pwelch(w(:,1),[],[],[],p.SampFreq);
return
plot([w(:,1) w(:,2)])

return
%% look at the spectra of the rectified sinusoid
t=(1/p.SampFreq)*(0:(1*p.SampFreq)-1)';
s=sin(2*pi*p.ToneFreq*t);
sRect=(abs(s)+s)/2;
sRectLo=filtfilt(blo,alo,sRect);
pxx = pwelch([sRect sRectLo],[],[],[],p.SampFreq);
plot(10*log10(pxx))
figure
plot([sRect sRectLo])

return


plot([r(:,1) w(:,1)])

pwelch(r(:,1),[],[],[],p.SampFreq)

% function [OutWave, flag] = no_clip(InWave,message)
[w, flag] = NoClipStereo(w);
figure
plot(w)
sound(w,p.SampFreq)