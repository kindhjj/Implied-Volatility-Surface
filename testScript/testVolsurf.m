function testVolsurf()

    [spot, lag, days, domdfs, fordfs, vols, cps, deltas] = getMarket();

    tau = lag / 365; % spot rule lag

    % time to maturities in years
    Ts = days / 365;

    % construct market objects
    domCurve = makeDepoCurve(Ts, domdfs);
    forCurve = makeDepoCurve(Ts, fordfs);
    fwdCurve = makeFwdCurve(domCurve, forCurve, spot, tau);
    
    % test makeVolSurface
    function testingNegative(msg, f, varargin)
        try
            disp(msg)
            f(varargin{:});
            warning('Test failed!')
        catch e
            fprintf('%s\n\n',e.message)
        end
    end

    function testingPositive(msg, f, varargin)
        try
            disp(msg)
            [y,z]=f(varargin{:})
        catch e
            warning('Test failed!')
        end
    end

    function testmakeVolSurface()
        testTs=Ts;
        testTs(3)=-1;
        testingNegative('Test negative Ts.',@makeVolSurface,fwdCurve ,testTs , cps , deltas , vols);
        testingNegative('Test invalid cps',@makeVolSurface,fwdCurve , Ts , [-1, -1, 0, 1, 1] , deltas , vols);
        testingNegative('Test invalid cps',@makeVolSurface,fwdCurve , Ts , [-1, -1, 2, 1, 1] , deltas , vols);
        testingNegative('Test invalid deltas',@makeVolSurface,fwdCurve , Ts , cps , [0.1, 0.25, 0.5, 0.25, -0.1] , vols);
        testingNegative('Test invalid deltas',@makeVolSurface,fwdCurve , Ts , cps , [0.1, 0.25, 0.5, 2.5, 0.1] , vols);
        testvols=vols;
        testvols(2,3)=-32;
        testingNegative('Test invalid vols',@makeVolSurface,fwdCurve , Ts , cps , deltas , testvols);
        testingNegative('Test inconsistent dimensions.',@makeVolSurface,fwdCurve ,Ts(1:(end-1)) , cps , deltas , vols);
        testingNegative('Test inconsistent dimensions.',@makeVolSurface,fwdCurve ,Ts , cps(1:(end-1)) , deltas , vols);
        testingNegative('Test inconsistent dimensions.',@makeVolSurface,fwdCurve ,Ts , cps , deltas(1:(end-1)) , vols);
        testingNegative('Test inconsistent dimensions.',@makeVolSurface,fwdCurve ,reshape(Ts,[2,5]) , cps , deltas , vols);
        testingNegative('Test inconsistent dimensions.',@makeVolSurface,fwdCurve ,Ts , cps , deltas , reshape(vols,[5,10]));
        testingNegative('Test inconsistent dimensions.',@makeVolSurface,fwdCurve ,Ts , cps , deltas , ones(11,5));
        testingNegative('Test inconsistent dimensions.',@makeVolSurface,fwdCurve ,Ts , cps , deltas , ones(10,6));
        %testvols=vols;
        testTs=Ts;
        testTs(10)=0.1;
        testingNegative('Test calendar no-arbitrage constraint.',@makeVolSurface,fwdCurve ,testTs , cps , deltas , vols);
    end

    % test getVol function
    function testgetVol()
        volcurve=makeVolSurface(fwdCurve ,Ts , cps , deltas , vols);
        testvolcurve1=rmfield(volcurve,'Ts');
        testvolcurve2=testvolcurve1;
        testvolcurve2.newvar=zeros(3,1);
        testingNegative('Test incomplete volcurve.',@getVol,testvolcurve1,12,[12 20]);
        testingNegative('Test incomplete volcurve.',@getVol,testvolcurve2,12,[12 20]);
        testingNegative('Test invalid T.',@getVol,volcurve,100,[12 20]);
        testingNegative('Test invalid T.',@getVol,volcurve,[0.1,0.5],[12 20]);
        testingNegative('Test invalid Ks.',@getVol,volcurve,0.5,[-12 20]);
        testingPositive('Test scalar K.',@getVol,volcurve,0.5,20)
        testingPositive('Positive standalone test.',@getVol, volcurve,1,volcurve.spots(1:2))
    end
    testmakeVolSurface();
    testgetVol();
end