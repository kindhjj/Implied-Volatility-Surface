% Inputs :
% f: forward spot for time T, i.e. E[S(T)]
% T: time to expiry of the option
% Ks: vector of strikes
% Vs: vector of implied Black volatilities
% Output :
% u: vector of call options undiscounted prices
function u = getBlackCall (f, T, Ks, Vs)
    getBlackCallInputCheck(f, T, Ks,Vs);
    tmp = Vs.*sqrt(T);
    d1 = log(f./Ks)./tmp + 0.5 .* tmp;
    d2 = d1 - tmp;
    if T == 0
        dim = size(Ks);
        u =  zeros(dim(1),dim(2));
        u =  max(f - Ks,0);
    elseif sum(Ks==0)~=0
        u = f* normcdf(d1) - Ks.*normcdf(d2);
        u(Ks==0) = f;
    else
        u = f* normcdf(d1) - Ks.*normcdf(d2);
    end
end

function getBlackCallInputCheck(f, T, Ks, Vs)
    if f < 0
        error('Error. Forward spot should be non-negative.')
    elseif T < 0
        error('Error. Time to expiry should be non-negative.')
    elseif length(Ks)~=length(Vs)
        error('Error. Dimension of strike price and volatlites should be the same.')
    elseif any(Ks<0)
        error('Error. Strike Price should be nonnegative.')
    elseif any(Vs<=0)
        error('Error.Implied Black volatilities should be positive.')
    end
end

    
