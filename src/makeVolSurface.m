function volSurface = makeVolSurface(fwdCurve , Ts , cps , deltas , vols)
%GETVOL Calculate a vol surface struct w.r.t. Ks and Ts
% Input:
% fwdCurve : forward curve data
% Ts: vector of expiry times
% cps: vetor if 1 for call , -1 for put
% deltas : vector of delta in absolute value (e.g. 0.25)
% vols : matrix of volatilities
% Output:
% volSurf: a struct containing data needed in getVol

% check inputs
    if (size(Ts,2)>1)
        error('Error. Ts not a column vector.')
    end
    if (size(cps,1)>1)||(size(deltas,1)>1)
        error('Error. cps or deltas not a row vector.')
    end
    if any(size(cps)~=size(deltas))||(size(cps,2)~=size(vols,2))||(size(vols,1)~=size(Ts,1))
        error('Error. Dimensions of inputs not matched.')
    end
    if any(Ts<=0)
        error('Error. Ts not larger than 0.')
    end
    if ~all(ismember(cps,[-1 1]))
        error('Error. cps not equal 1 or -1.')
    end
    if any(deltas<=0|deltas>=1)
        error('Error. deltas not between 0 and 1.')
    end
    if any(any(vols <0))
        error('Error. vol smaller than 0.')
    end
    
    temp=sortrows([Ts vols],1);
    volSurface.Ts=temp(:,1);
    temp_vol=temp(:,2:end);
    volSurface.spots=arrayfun(@(T) getFwdSpot(fwdCurve,T),Ts);
    volSurface.fwdCurve=fwdCurve;
    volSurface.slopes=1./diff(volSurface.Ts);
% store all smile curve at Ts in the struct
    for t = (1:length(volSurface.Ts))
        volSurface.smiles(t) = makeSmile(fwdCurve, volSurface.Ts(t), cps, deltas, temp_vol(t,:));
    end
    
% check arbitrage
    for t=(1:length(volSurface.Ts)-1)
        c1=getBlackCall(volSurface.spots(t),volSurface.Ts(t),volSurface.spots(t),getSmileVol (volSurface.smiles(t) , volSurface.spots(t)));
        c2=getBlackCall(volSurface.spots(t+1),volSurface.Ts(t+1),volSurface.spots(t+1),getSmileVol (volSurface.smiles(t+1) , volSurface.spots(t+1)));
        if c2<=c1
            error('Error. Violation of no-arbitrage constraints detected.')
        end
    end
end

