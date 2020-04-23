function testPdf(volSurface, T, eps)
%% Test if the integral of the pdf function is 1.
u1 = getEuropean(volSurface, T, @(x)1);
if abs(u1 - 1) > eps
    error('The integral of the pdf function is %0.4f, not equal to 1.', u1)
end
%% Test if the mean of the pdf function is the forward.
u2 = getEuropean(volSurface, T, @(x)x);
fwd=getFwdSpot(volSurface.fwdCurve,T);
if abs(u2 - fwd) > eps
    error('The mean of the pdf function is %0.4f, while the forward is %0.4f.', u2, fwd)
end
disp('Pass')
end


    