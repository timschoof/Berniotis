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
p=BerniotisParseArgs('L27', 'starting_SNR',100,'rms2use', 0.07,'fixed', 'signal',...
    'ToneFreq', 125,'NoiseBandWidth', 100, 'TranspositionFreq', 000 ,'InterauralTonePhase', pi);

w=GenerateSxNxTonalTriple(p);
% half-wave rectify
r = (abs(w)+w)/2;
% lowpass filter forwards/backwards near 1.5 kHz
loPassCutoff=1500;
SmoothingFilterOrder=4;
TranspositionFreq=4000;
[blo,alo]=butter(SmoothingFilterOrder/2, ...
     ButterLoPassTweak(-1.5, loPassCutoff, SmoothingFilterOrder/2)/(p.SampFreq/2));
rLo=filtfilt(blo,alo,r(:,1));
% plot([r(:,1) rLo]) % rectified alone, and rectified, smoothed
% create the modulator
t=((0:(length(r)-1))/p.SampFreq)';
sMod = sin(2*pi*TranspositionFreq*t);
rTrans = sMod.*rLo;
plot([rTrans rLo w(:,1)])
figure
pwelch(rTrans,[],[],[],p.SampFreq);
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