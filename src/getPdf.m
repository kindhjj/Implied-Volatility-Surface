function pdf = getPdf(volSurf, T, Ks)
%% Check inputs.
if ~all(isfield(volSurf,{'spots','fwdCurve','Ts','slopes','smiles'}))
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
[Vs, fwd] = getVol(volSurf, T, fineK);
Cs = getBlackCall(fwd, T, Ks, Vs);
%% Estimate the implied densities by approximating derivatives.
% Approximate the first derivative, at each distinct expiry time.
% We use the discrete approximation to the first derivative.
dK = diff(Ks);
d1 = diff(Cs) ./ dK;
% Approximate the second derivatives.
d2K = dK(2:end);
pdf = diff(d1) ./ d2K;
end