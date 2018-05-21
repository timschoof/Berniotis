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

%% Transpose, if necessary
if p.TranspositionFreq>0
    % function y = TransposeSounds(w,p)
    w = TransposeSounds(w,p);
end

%% add in background noise, allowing for longer background noise
if p.BackNzLevel>0
    Nz=GenerateBackgroundNoise(p);
    % centre targets in background noise asymmetricaly if necessary 
    xtra = length(Nz)-length(w);
    xtraFront = ceil(p.propLongBackNzPreTarget*xtra);
    if xtra>0
        w=vertcat(zeros(xtraFront,2),w, zeros(xtra-xtraFront,2));
    end
    w = w + Nz;
end
% note that GenerateBackgroundNoise() generates 1 x n column vector
% although w is a 2 x n vector (being stereo), Matlab addes the
% 1-dimensional vector into each column of the multidimensional vector 

% prepend silence to wave if necessary
w= vertcat(zeros(samplify(p.preSilence,p.SampFreq),2),w);


