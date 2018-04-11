function y = ran_sign(n)
%
% function y = ran_sign()
%
% return +/-1 randomly for the size of the array n
y = 2*(rand(size(n))>0.5)-1;

