function testGetFwdSpot()
    
    function testInputCheck()
        fprintf('Input Check Test\n');
        
        wrong_fwdCurve = rmfield(fwdCurve, 'fwd');
        testCase('Test curve complete', @getFwdSpot, wrong_fwdCurve , 0.8);
        
        wrong_fwdCurve = fwdCurve;
        wrong_fwdCurve.fwd = wrong_fwdCurve.fwd(1:end-1);
        testCase('Test curve dimension', @getFwdSpot, wrong_fwdCurve , 0.8);
        
        wrong_fwdCurve.fwd = [];
        testCase('Test empty curve', @getFwdSpot, wrong_fwdCurve , 0.8);
        
        wrong_fwdCurve = fwdCurve;
        wrong_fwdCurve.ts(1) = -1;
        testCase('Test negative curve.ts', @getFwdSpot, wrong_fwdCurve , 0.8);
        
        wrong_fwdCurve = fwdCurve;
        wrong_fwdCurve.fwd(1) = -1;
        testCase('Test negative curve.fwd', @getFwdSpot, wrong_fwdCurve , 0.8);
        
        testCase('Test length of T', @getFwdSpot, wrong_fwdCurve , [0.2, 0.6]);
        testCase('Test negative T', @getFwdSpot, wrong_fwdCurve , -0.5);
    end

    % test integral should be linear and continuous.
    function testIntegralLinear()
        ts = [];
        FwdSpotList = [];
        n = 200;
        
        for i=1:(length(fwdCurve.ts))
            if i < length(fwdCurve.ts)
                T_list = linspace(fwdCurve.ts(i), fwdCurve.ts(i+1), n);
            else
                T_list = linspace(fwdCurve.ts(i), fwdCurve.ts(i)+1, n);
            end
            
            ts = [ts, T_list(1:end-1)];
            
            for T=T_list(1:end-1)
                FwdSpotList(end+1) = getFwdSpot(fwdCurve, T);
            end
        end
        
        plot(ts, FwdSpotList);
    end
    
    [spot, lag, days, domdfs, fordfs, vols, cps, deltas] = getMarket();

    tau = lag / 365; % spot rule lag

    % time to maturities in years
    Ts = days / 365;

    % construct market objects
    domCurve = makeDepoCurve(Ts, domdfs);
    forCurve = makeDepoCurve(Ts, fordfs);
    fwdCurve = makeFwdCurve(domCurve, forCurve, spot, tau);

    testInputCheck();
    testIntegralLinear();
end

% test the input check function
function testCase(msg, f, varargin)
    try
        disp(msg)
        f(varargin{:});
        warning('Test failed!')
    catch e
        fprintf('%s\n\n',e.message)
    end
end