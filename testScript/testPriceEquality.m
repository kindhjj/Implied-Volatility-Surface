function testPriceEquality(volSurface, T, eps)
%% Test if a call option forward price obtained with Black formula or by numerical integration can match.
u1 = getEuropean(volSurface, T, @(x)max(x-fwd,0));
[Vs, ~] = getVol(volSurface, T, fwd);
u2 = getBlackCall(fwd, T, fwd, Vs);
if abs(u1 - u2) > eps
    error('A call option forward price obtained by numerical integration is %0.4f, while the price obtained with Black formula is %0.4f.', u1, u2)
end
disp('Pass')
end