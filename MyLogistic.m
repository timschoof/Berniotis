function l = MyLogistic(x, mu, slope)

y = exp(slope*x+mu);
l = y./(1+y);

