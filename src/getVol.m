function [vols, fwd] = getVol(volSurface, T, Ks)
%GETVOL Given volatility surface struct,  time to expiry and strikes, 
%calculate volatilities and forward spot
%   input: 
%   volSurface: volatility surface data
%   T: time to expiry of the option
%   Ks: vector of strikes
%   ouput:
%   vols: volatilities
%   fwd: forward spot price

% check inputs
    InputChecking.checkvolsurface(volSurface);
    InputChecking.checkT(T);
    InputChecking.checkKs(Ks);
    
% calculate foward price
    fwd = getFwdSpot(volSurface.fwdCurve, T);
    tempKs = Ks;
    if size(Ks, 2) > 1
        tempKs = reshape(Ks, [], 1);
    end
    Kf_ratio = tempKs / fwd;
% case when T < T1
    if T <= volSurface.Ts
        K1 = volSurface.spots(1)*Kf_ratio;
        vols = arrayfun(@(K) getSmileVol(volSurface.smiles(1), K), K1);
    else
% case when T1 < T < TN
        if (volSurface.Ts(end) < T)
            error('Error. T larger than Tn.')
        end
        j = sum(T > volSurface.Ts);
        Kis = [Kf_ratio .* volSurface.spots(j) Kf_ratio .* volSurface.spots(j + 1)];
        cumulateVol = (volSurface.Ts(j + 1) - T) * volSurface.slopes(j) * getSmileVol(volSurface.smiles(j), Kis(:, 1)) .^ 2 * volSurface.Ts(j) + (T - volSurface.Ts(j)) * volSurface.slopes(j) * getSmileVol(volSurface.smiles(j + 1), Kis(:, 2)) .^ 2 * volSurface.Ts(j + 1);
        vols = sqrt(cumulateVol ./ T)';
    end
    if size(Ks, 2) > 1
        vols = reshape(vols, size(Ks));
    end
end

