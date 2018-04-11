function [OutWave, flag] = NoClipStereo(InWave,message)
%
%	no_clip - correct for any possible sample overloads in a stereo wave
%   typically many row by 2 columns
%
%	[OutWave, flag] = no_clip(InWave, message)
%
%	flag = TRUE (1) if clipping has occurred, 0 otherwise

if (nargin<2)
    message = '';
end

max_sample = max(max(abs(InWave)));
if max_sample > 0.99	% ---- !! OVERLOAD !! -----
	% figure out degree of attenuation necessary
	ratio = 0.99/max_sample;
	OutWave = InWave * ratio;
	fprintf('!! WARNING -- OVERLOAD !! %s wave scaled by %f = %f dB\n', ...
        message, ratio, 20*log10(ratio));
	flag = 1;   
else 
   flag = 0;
   OutWave = InWave;
end
