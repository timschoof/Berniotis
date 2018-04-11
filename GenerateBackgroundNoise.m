function Nz = GenerateBackgroundNoise(p)

if p.LongMaskerNoise<=0 % if maskers are pulsed
    NzSamples=samplify(p.NoiseDuration,p.SampFreq);
    duration = (3*p.NoiseDuration + 2*p.ISI);
else
    NzSamples=samplify(p.LongMaskerNoise,p.SampFreq);
    duration = (p.LongMaskerNoise);
end
ISIsamples=samplify(p.ISI,p.SampFreq);
if p.BackNzLevel>0
    % generate the noise though ifft
    f=[p.BackNzHiPass  p.BackNzHiPass+1  p.BackNzLoPass  p.BackNzLoPass+1];
    l=[0   100   100   0];
    [Nz, ~]=noise(f,l,p.SampFreq,duration/1000);
    % adjust to the appopriate rms level
    Nz =  adjustRMS(Nz', p.BackNzLevel);
    % window in the appropriate way by constructing an envelope
    if p.BackNzPulsed
        ISI=zeros(ISIsamples,1);
        NzEnv = ones(NzSamples,1);
        NzEnv=taper(NzEnv, p.RiseFall, p.RiseFall, p.SampFreq);
        Env=vertcat(NzEnv,ISI,NzEnv,ISI,NzEnv);
    elseif p.LongMaskerNoise<=0
        Env = ones(3*NzSamples+2*ISIsamples,1);
        Env=taper(Env, p.RiseFall, p.RiseFall, p.SampFreq);
    else % long masker noise
        Env = ones(NzSamples,1);
        Env=taper(Env, p.RiseFall, p.RiseFall, p.SampFreq);
    end
    % need to shorten noise (typically)
    start = randi(length(Nz)-length(Env));
    Nz = Nz(start:start+length(Env)-1) .* Env;
else
    Nz = zeros(3*NzSamples+2*ISIsamples,1);
end
% p.addParameter('BackNzLevel',0, @isnumeric); % in absolute rms
% p.addParameter('BackNzLoPass',0, @isnumeric);
% p.addParameter('BackNzHiPass',50, @isnumeric);

function y = adjustRMS(x, RMS)
y = RMS*x/rms(x);
if max(abs(y))>=1
    error('Clipping from adjustRMS');
end