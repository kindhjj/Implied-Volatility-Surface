function pdf = getPdf(volSurf, T, Ks)
% Check inputs.
InputChecking.checkvolsurface(volSurf);
InputChecking.checkT(T);
InputChecking.checkKs(Ks);

% Transform the data from volatility to option price space.
% We begin by converting the (K, sigma) pairs into (K, C) space.
h = 0.0001;
pdf = NaN(size(Ks));

fineK_matrix = [Ks-h;Ks;Ks+h];
dK = [h; h];

for k = 1:length(Ks)
    fineK = fineK_matrix(:,k);
    if fineK(1) < 0
        pdf(k) = 0;
    else
        [Vs, fwd] = getVol(volSurf, T, fineK);
        Cs = getBlackCall(fwd, T, fineK, Vs);
        % Estimate the implied densities by approximating derivatives.
        % Approximate the first derivative, at each distinct expiry time.
        % We use the discrete approximation to the first derivative.
        d1 = diff(Cs) ./ dK;
        % Approximate the second derivatives.
        pdf(k) = diff(d1) / h;
    end
end
end