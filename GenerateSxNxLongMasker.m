function [w, Nz, Tone]=GenerateSxNxLongMasker(TonePresent, p)

% generate a complete trial with the masker running through the entire
% triple of observation intervals


%% Insist that the duration of the noise is long enough for the entire trial
totalSignalDuration = p.NumSignalPulses*p.ToneDuration + (p.NumSignalPulses-1)*p.WithinPulseISI;
totalTrialDuration = 3*totalSignalDuration + 2*p.ISI;

if p.LongMaskerNoise < totalTrialDuration
    error('Long masker moise must extend through entire trial: Nz=%d Sig=%d', ...
        p.LongMaskerNoise,totalTrialDuration);
end

NzSamples=samplify(p.LongMaskerNoise,p.SampFreq);
WithinPulseISIsamples=samplify(p.WithinPulseISI,p.SampFreq);
OneTonePulseSamples=samplify(p.ToneDuration,p.SampFreq);
ToneSamples=p.NumSignalPulses*OneTonePulseSamples + ...
    (p.NumSignalPulses-1)*WithinPulseISIsamples;
t=(0:(OneTonePulseSamples-1))/p.SampFreq;

Tone = []; % zeros(1,ToneSamples);
Noise =  zeros(1,NzSamples);

% generate the noise and tone
f=[p.NoiseBandLimits(1)  p.NoiseBandLimits(1)+1  p.NoiseBandLimits(2)  p.NoiseBandLimits(2)+1];
l=[0   100   100   0];
[Nz, spect_length]=noise(f,l,p.SampFreq,p.NoiseDuration/1000);
% Shorten the noise to the appropriate length
Nz = Nz(1:NzSamples);

Tn = sin(2*pi*p.ToneFreq*t);

% calculate the multiplicative factor for the signal-to-noise ratio
SNR = 10^(p.SNR_dB/20);
if strcmp(p.fixed, 'noise') % fix the noise level and scale the signal
    Nz = p.rms2use * Nz/rms(Nz);
    Tn = Tn * (SNR*p.rms2use)/rms(Tn);
elseif strcmp(p.fixed, 'signal') % fix the signal level and scale the noise
    Nz = Nz * p.rms2use/(SNR * rms(Nz));
    Tn = Tn * p.rms2use/rms(Tn);
end

% put rises and falls on the sound pulses,
% and pad out Tone to appropriate length
% function s=taper(wave, rise, fall, p.SampFreq, type)
Nz=taper(Nz, p.RiseFall, p.RiseFall, p.SampFreq)';
Tn=taper(Tn, p.RiseFall, p.RiseFall, p.SampFreq)';
Tone=Tn;
if p.NumSignalPulses>1
    % generate an appropriate trial with multiple sound pulses
    for n=1:p.NumSignalPulses-1
        Tone = vertcat(Tone, zeros(WithinPulseISIsamples,1), Tn);
    end
end
if ToneSamples<NzSamples
    pre = round((NzSamples-ToneSamples)/2);
    post = (NzSamples-ToneSamples) - pre;
    Tone = vertcat(zeros(pre,1), Tone, zeros(post,1));
end
% plot(t,Tn)

if ~TonePresent
    Tone=Tone*0;
end
w1=Nz+Tone;
if p.InterauralTonePhase==pi
    w2=Nz-Tone;
elseif p.InterauralTonePhase==0
    w2=w1;
else
    error('InteruralTonePhase can only be 0 or pi')
end
w=horzcat(w1,w2);




