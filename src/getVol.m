function [vols, fwd] = getVol(volSurface, T, Ks)
%GETVOL Given volatility surface struct, time to expiry and strikes,
%calculate volatilities and forward spot
%   input: 
%   volSurface: volatility surface data
%   T: time to expiry of the option
%   Ks: vector of strikes
%   ouput:
%   vols: volatilities
%   fwd: forward spot price

% check inputs
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
    
    fwd=getFwdSpot(volSurface.fwdCurve,T);
    tempKs=Ks;
    if size(Ks,2)>1
        tempKs=reshape(Ks,[],1);
    end
    Kf_ratio=tempKs/fwd;
    if T<=volSurface.Ts
        K1=volSurface.spots(1)*Kf_ratio;
        vols=arrayfun(@(K) getSmileVol(volSurface.smiles(1),K),K1);
    else
        j=sum(T>volSurface.Ts);
        Kis=[Kf_ratio.*volSurface.spots(j) Kf_ratio.*volSurface.spots(j+1)];
        if (volSurface.Ts(end)<T)
            error('Error. T larger than Tn.')
        end
        cumulateVol=(volSurface.Ts(j+1)-T)*volSurface.slopes(j)*getSmileVol(volSurface.smiles(j),Kis(:,1)).^2*volSurface.Ts(j)+(T-volSurface.Ts(j))*volSurface.slopes(j)*getSmileVol(volSurface.smiles(j+1),Kis(:,2)).^2*volSurface.Ts(j+1);
        vols=sqrt(cumulateVol./T)';
    end
    if size(Ks,2)>1
        vols=reshape(vols,size(Ks));
    end
end

