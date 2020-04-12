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
    Kf_ratio=Ks/fwd;
    vols=zeros([length(Ks) 1]);
    if T<=volSurface.Ts
        K1=volSurface.spots(1)*Kf_ratio;
        vols=getSmileVol(volSurface.smiles(1),K1(K1));
    else
        Kis=Kf_ratio'.*volSurface.spots;
        for i=1:length(Ks)
            if (Kis(end,i)<Ks(i))
                error('Error. T larger than Tn.')
            end
            j=discretize(Ks(i),[-inf;Kis(:,i)+eps();inf]);
            vols(i)=(volSurface.Ts(j+1)-T)*volSurface.slopes(j)*getSmileVol(volSurface.smiles(j),Kis(j)).^2*volSurface.Ts(j)-(T-volSurface.Ts(j))*volSurface.slopes(j)*getSmileVol(volSurface.smiles(j+1),Kis(j+1)).^2*volSurface.Ts(j+1);
        end
    end
        
                

end

