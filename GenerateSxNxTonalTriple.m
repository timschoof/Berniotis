function [w, Nz, Tn]=GenerateSxNxTonalTriple(p)
ISIsamples=samplify(p.ISI,p.SampFreq);
ISIwave=zeros(ISIsamples,2);

w=[];
Nz=[];
Tn=[];
if p.LongMaskerNoise<=0
    for i=1:3
        [x, xNz, xTn]=GenerateSxNxTonalSound((p.Order==i), p);
        w=vertcat(w,x);
        Nz=vertcat(Nz,xNz);
        Tn=vertcat(Tn,xTn);
        if i<3
            w=vertcat(w,ISIwave);
            Nz=vertcat(Nz,ISIwave(:,1));
            Tn=vertcat(Tn,ISIwave);
        end
    end
else % long masker
    % generate the tone pulse(s) and the long noise
    % [w, Nz, Tone, flatNz, flatTn] =
    [~, Nz, Tone]=GenerateSxNxTonalSound(1, p);
    % construct the 3 intervals with ISIs
    for i=1:3
        if (p.Order==i) k=1;
        else k=0;
        end
        Tn=vertcat(Tn,k*Tone);
        if i<3
            Tn=vertcat(Tn,ISIwave);
        end
    end
    % pad out Tone to appropriate length
    ToneSamples=length(Tn);
    NzSamples=length(Nz);
    if ToneSamples<NzSamples
        pre = round((NzSamples-ToneSamples)/2);
        post = (NzSamples-ToneSamples) - pre;
        Tn = vertcat(zeros(pre,2), Tn, zeros(post,2));
    end
    % Make the masker stereo & add it to the tone
    Nz=horzcat(Nz,Nz);
    if ~p.inQuiet
        w = Tn + Nz;
    end
end

% prepend silence to wave if necessary
w= vertcat(zeros(p.SampFreq*p.preSilence/1000,2),w);

%% Transpose, if necessary
if p.TranspositionFreq>0
    % function y = TransposeSounds(w,p)
    w = TransposeSounds(w,p);
end

%% add in background noise
if p.BackNzLevel>0
    w = w + vertcat(zeros(p.SampFreq*p.preSilence/1000,1),GenerateBackgroundNoise(p));
end
% note that GenerateBackgroundNoise() generates 1 x n column vector
% although w is a 2 x n vector (being stereo), Matlab addes the
% 1-dimensional vector into each column of the multidimensional vector 


