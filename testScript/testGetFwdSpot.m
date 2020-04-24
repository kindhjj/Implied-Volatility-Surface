function testGetFwdSpot()
    
    function testInputCheck()
        fprintf('Input Check Test\n');
        
        wrong_fwdCurve = rmfield(fwdCurve, 'X0');
        testCase('Test curve complete', @getFwdSpot, wrong_fwdCurve , 0.8);
        
        wrong_fwdCurve = fwdCurve;
        wrong_fwdCurve.X0 = -1;
        testCase('Test curve.X0', @getFwdSpot, wrong_fwdCurve , 0.8);
        
        wrong_fwdCurve = fwdCurve;
        wrong_fwdCurve.tau = -2;
        testCase('Test curve.tau', @getFwdSpot, wrong_fwdCurve , 0.8);
        
        wrong_fwdCurve.domCurve = rmfield(fwdCurve.domCurve, 'ir');
        testCase('Test curve.domcurve complete', @getFwdSpot, wrong_fwdCurve , 0.8);
        
        wrong_fwdCurve = fwdCurve;
        wrong_fwdCurve.domCurve.ir = wrong_fwdCurve.domCurve.ir(1:end-1);
        testCase('Test curve.domcurve dimension', @getFwdSpot, wrong_fwdCurve , 0.8);
        
        wrong_fwdCurve.domCurve.ir = [];
        testCase('Test empty curve.domcurve', @getFwdSpot, wrong_fwdCurve , 0.8);
        
        wrong_fwdCurve = fwdCurve;
        wrong_fwdCurve.domCurve.ts(1) = -1;
        testCase('Test negative curve.domcurve.ts', @getFwdSpot, wrong_fwdCurve , 0.8);
        
        wrong_fwdCurve.domCurve.ts(1) = 0;
        testCase('Test zero curve.domcurve.ts', @getFwdSpot, wrong_fwdCurve , 0.8);
        
        testCase('Test length of T', @getFwdSpot, fwdCurve , [0.2, 0.6]);
        testCase('Test negative T', @getFwdSpot, fwdCurve , -0.5);
    end

    % test integral should be linear and continuous.
    function testIntegralLinear()
        ts = [];
        scatter_list = [];
        FwdSpotList = [];
        n = 200;
        
        for i=1:(length(fwdCurve.domCurve.ts))
            if i < length(fwdCurve.domCurve.ts)
                T_list = linspace(fwdCurve.domCurve.ts(i), fwdCurve.domCurve.ts(i+1), n);
            else
                T_list = linspace(fwdCurve.domCurve.ts(i), fwdCurve.domCurve.ts(i)+1, n);
            end
            
            ts = [ts, T_list(1:end-1)];
            
            for T=T_list(1:end-1)
                FwdSpotList(end+1) = getFwdSpot(fwdCurve, T);
            end
        end
        
        for i=1:length(fwdCurve.domCurve.ts)
            scatter_list(end+1) = getFwdSpot(fwdCurve, fwdCurve.domCurve.ts(i));
        end

        hold on;
        scatter(fwdCurve.domCurve.ts, scatter_list);
        plot(ts, FwdSpotList);
        xlabel('ts');
        ylabel('Forward Spot Price');
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