function testPutCallParity()
    addpath(genpath([pwd '\src\']));

    [spot, lag, days, domdfs, fordfs, vols, cps, deltas] = getMarket();
    tau = lag / 365; % spot rule lag

    % time to maturities in years
    Ts = days / 365;
    % construct market objects
    domCurve = makeDepoCurve(Ts, domdfs);
    forCurve = makeDepoCurve(Ts, fordfs);
    fwdCurve = makeFwdCurve(domCurve, forCurve, spot, tau);

    N = length(deltas);
    Nt = length(Ts);   
    K = zeros(Nt,N);
    C = zeros(Nt,N);
    fwd = zeros(Nt,1);

    for m =1:Nt
        fwd(m,1) = getFwdSpot(fwdCurve, Ts(m));
        for n = 1:N
            K(m,n) = getStrikeFromDelta(fwd(m), Ts(m), cps(n), vols(m,n), deltas(n));
        end
        C(m,:) = getBlackCall(fwd(m), Ts(m), K(m,:),vols(m,:));
        P(m,:) = getBlackPut(fwd(m),Ts(m),K(m,:),vols(m,:));
        if abs(C(m,:) + K(m,:) - P(m,:) - fwd(m))>1e-15
           error( 'Put Call Parity test failed!' );
        end 
    end

    display('Put Call parity test passed!');

    function u = getBlackPut (f, T, Ks , Vs)
        getBlackCallInputCheck(f, T, Ks,Vs);
        tmp = Vs.*sqrt(T);
        d1 = log(f./Ks)./tmp + 0.5 .* tmp;
        d2 = d1 - tmp;
        if sum(Ks==0)~=0
            u = -f* normcdf(-d1) + Ks.*normcdf(-d2);
            u(Ks==0) = 0;
        else
            u = -f* normcdf(-d1) + Ks.*normcdf(-d2);
        end
    end

    function getBlackCallInputCheck(f, T, Ks, Vs)
        if f <= 0
            error('Error. Forward spot should be positive.')
        elseif T < 0
            error('Error. Time to expiry should be non-negative.')
        elseif length(Ks)~=length(Vs)
            error('Error. Dimension of strike price and volatlites should be the same.')
        elseif any(Ks<0)
            error('Error. Strike Prive should be nonnegative!')
        elseif any(Vs<=0)
            error('Error.Implied Black volatilities should be positive!')
        end
    end
end



