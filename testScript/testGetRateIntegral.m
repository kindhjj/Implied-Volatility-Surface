function testGetRateIntegral()
    
    function testInputCheck()
        fprintf('Input Check Test\n');
        
        wrong_domCurve = rmfield(domCurve, 'ir');
        testCase('Test curve complete', @getRateIntegral, wrong_domCurve , 0.8);
        
        wrong_domCurve = domCurve;
        wrong_domCurve.ir = wrong_domCurve.ir(1:end-1);
        testCase('Test curve dimension', @getRateIntegral, wrong_domCurve , 0.8);
        
        wrong_domCurve.ir = [];
        testCase('Test empty curve', @getRateIntegral, wrong_domCurve , 0.8);
        
        wrong_domCurve = domCurve;
        wrong_domCurve.ts(1) = -1;
        testCase('Test negative curve.ts', @getRateIntegral, wrong_domCurve , 0.8);
        
        wrong_domCurve.ts(1) = 0;
        testCase('Test zero curve.ts', @getRateIntegral, wrong_domCurve , 0.8);
        
        testCase('Test length of T', @getRateIntegral, domCurve , [0.2, 0.6]);
        testCase('Test negative T', @getRateIntegral, domCurve , -0.5);
    end

    % test the return of original point
    function testOriginalPoint()
        fprintf('Original Point Test\n');
        for i = 1:length(domCurve.ts)
            original_point_rate = domdfs(i);
            return_rate = exp(-getRateIntegral(domCurve, domCurve.ts(i)));
            if original_point_rate == return_rate
                fprintf('T=%f Pass.\n', domCurve.ts(i));
            else
                fprintf('T=%f Fail.\tOriginal Point = %.20f,\t Return Rate = %.20f\n', domCurve.ts(i), original_point_rate, return_rate);
            end
        end
    end
    
    % test integral should be linear and continuous.
    function testIntegralLinear()
        ts = [];
        Integral = [];
        n = 200;
        
        for i=1:(length(domCurve.ts))
            if i < length(domCurve.ts)
                T_list = linspace(domCurve.ts(i), domCurve.ts(i+1), n);
            else
                T_list = linspace(domCurve.ts(i), domCurve.ts(i)+1, n);
            end
            
            ts = [ts, T_list(1:end-1)];
            
            for T=T_list(1:end-1)
                Integral(end+1) = getRateIntegral(domCurve, T);
            end
        end
        hold on;
        
        plot(ts, Integral);
        scatter(domCurve.ts, domCurve.integ);
        xlabel('ts');
        ylabel('rateIntegral');
        hold off;
    end
    
    [spot, lag, days, domdfs, fordfs, vols, cps, deltas] = getMarket();

    tau = lag / 365; % spot rule lag

    % time to maturities in years
    Ts = days / 365;

    % construct market objects
    domCurve = makeDepoCurve(Ts, domdfs);
    
    testInputCheck();
    
    testOriginalPoint();
    
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