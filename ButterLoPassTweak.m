function cutoff=ButterLoPassTweak(dBgain, f, order)
%   find the cutoff frequency for a low pass Butterworth filter that leads
%   to a given gain (in dB) at a specified frequency

g=10.^(dBgain./10);
cutoff=f*(1./(((1-g)./g).^(1/(2*order))));

% By using 10.^(dBgain./10), we lose the square in the denominator  
