function pdf = getPdf(volSurf, T, Ks)
%% Check inputs.
if ~all(isfield(volSurface,{'spots','fwdCurve','Ts','slopes','smiles'}))
    error('Error. volSurface input error: the struct is not complete.')
end
if length(T)>1
    error('Error. length of T larger than 1.')
end
if T<0||T>volSurface.Ts(end)
    error('Error. Invalid T value.')
end
if any(Ks<0)
    error('Error. K smaller than zero.')
end
%% Transform the data from volatility to option price space.
% After interpolation in (K, sigma) space, either via cubic splines, SABR
% interpolation, or some other method, we obtain enough data points to
% estimate the implied strike price density functions at each expiry time.
% We begin by converting the (K, sigma) pairs into (K, C) (respectively,
% (K, P)) space.
% Define sample strike prices for the interpolation of pdf.
extrapThresh = 0.01;
fineK = linspace(min(Ks)-extrapThresh, max(Ks)+extrapThresh, 500)';
[Vs, fwd] = getVol(volSurf, T, fineK);
f = getFwdSpot(volSurface.fwdCurve, T);
Cs = getBlackCall(f, T, fineK, Vs);
%% Estimate the implied densities by approximating derivatives.
% Approximate the first derivative, at each distinct expiry time.
% We use the discrete approximation to the first derivative.
dK = diff(fineK);
d1 = diff(Cs) ./ dK;
% Approximate the second derivatives.
d2K = dK(2:end);
d2 = diff(d1) ./ d2K;
% Interpolation of pdf
pdf = fit(fineK(3:end), d2, 'poly2');
%% Tests
% Check whether the area under the curve is 1.
x = linspace(min(Ks)-5, max(Ks)+5, 5000)';
y = pdf(x);
A = trapz(x, y);
tol = 0.0000001;
if abs(A-1) > tol
    error('The area under the pdf is not equal to 1.')
end
end