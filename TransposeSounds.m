function y = TransposeSounds(w,p)

%% Transpose, if necessary
if p.TranspositionFreq>0
    % half-wave rectify
    w = (abs(w)+w)/2;
    % lowpass filter forwards/backwards 
    w=filtfilt(p.blo,p.alo,w);
    % create the modulator
    t=((0:(length(w)-1))/p.SampFreq)';
    sMod = sin(2*pi*p.TranspositionFreq*t);
    y = sMod.*w;
end