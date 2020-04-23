function testGetEuropean()
    %% Test invalid inputs.
    function testInputCheck()
        wrong_volSurface = rmfield(volSurface, 'spots');
        testCase('Test incomplete volSurface.', @getEuropean, wrong_volSurface, 0.8, @(x)max(x-fwd,0));
        
        testCase('Test vectorial T.', @getEuropean, volSurface, [0.8,0.8], @(x)max(x-fwd,0));
        
        testCase('Test negative T.', @getEuropean, volSurface, -0.25, @(x)max(x-fwd,0));
        
        testCase('Test invalid payoff function.', @getEuropean, volSurface, -0.25, 1);
        
        testCase('Test invalid integration interval', @getEuropean, volSurface, -0.25, @(x)max(x-fwd,0), 3);
        
        testCase('Test nagative integration interval', @getEuropean, volSurface, -0.25, @(x)max(x-fwd,0), [0, -3, +Inf]);
    end
    %% Test if a call option forward price obtained with Black formula or by numerical integration can match.
    function testPriceEquality()    
        u1 = getEuropean(volSurface, 0.8, @(x)max(x-fwd,0));
        [vol, ~] = getVol(volSurface, 0.8, fwd);
        u2 = getBlackCall(fwd, 0.8, fwd, vol);
        if abs(u1 - u2) > 0.00001
            error('A call option forward price obtained by numerical integration is %0.4f, while the price obtained with Black formula is %0.4f.', u1, u2)
        end
    end
    %% Main body
    [spot, lag, days, domdfs, fordfs, vols, cps, deltas] = getMarket();

    tau = lag / 365; % spot rule lag

    % time to maturities in years
    Ts = days / 365;

    % construct market objects
    domCurve = makeDepoCurve(Ts, domdfs);
    forCurve = makeDepoCurve(Ts, fordfs);
    fwdCurve = makeFwdCurve(domCurve, forCurve, spot, tau);
    volSurface = makeVolSurface(fwdCurve, Ts, cps, deltas, vols);

    % compute a forward spot rate G_0(0.8)
    fwd = getFwdSpot(fwdCurve, 0.8);
    
    testInputCheck();
    testPriceEquality();
end

function testCase(msg, f, varargin)
    try
        disp(msg)
        f(varargin{:});
        warning('Test failed!')
    catch e
        fprintf('%s\n\n',e.message)
    end
end
    
    



