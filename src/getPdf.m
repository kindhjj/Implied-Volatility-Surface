function pdf = getPdf(volSurf, T, Ks)
%% Check inputs.
if ~all(isfield(volSurf,{'spots','fwdCurve','Ts','slopes','smiles'}))
    error('Error. volSurface input error: the struct is not complete.')
end
if length(T)>1
    error('Error. length of T larger than 1.')
end
if T<0||T>volSurf.Ts(end)
    error('Error. Invalid T value.')
end
if any(Ks<0)
    error('Error. K smaller than zero.')
end
%% Transform the data from volatility to option price space.
% We begin by converting the (K, sigma) pairs into (K, C) space.
h = 0.0001;
pdf = NaN(size(Ks));

fineK_matrix = [Ks-h;Ks;Ks+h];
dK = [h; h];

for k = 1:length(Ks)
    fineK = fineK_matrix(:,k);
    [Vs, fwd] = getVol(volSurf, T, fineK);
    Cs = getBlackCall(fwd, T, fineK, Vs);
    %% Estimate the implied densities by approximating derivatives.
    % Approximate the first derivative, at each distinct expiry time.
    % We use the discrete approximation to the first derivative.
    d1 = diff(Cs) ./ dK;
    % Approximate the second derivatives.
    pdf(k) = diff(d1) ./ h;
end
end