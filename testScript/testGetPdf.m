function testGetPdf()
    %% Test invalid inputs.
    function testInputCheck()
        wrong_volSurface = rmfield(volSurface, 'spots');
        testCase('Test incomplete volSurface.', @getPdf, wrong_volSurface, 0.8, [fwd, fwd]);
        
        testCase('Test vectorial T.', @getPdf, volSurface, [0.8,0.8], [fwd, fwd]);
        
        testCase('Test negative T.', @getPdf, volSurface, -0.25, [fwd, fwd]);
        
        testCase('Test negative Ks.',@getPdf, volSurface, -0.25, [-fwd, fwd]);
    end
    %% Test if the integral of the pdf function is 1.
    function testPdf1()
        u = getEuropean(volSurface, 0.8, @(x)1);    
        if abs(u - 1) > 0.00001
            error('The integral of the pdf function is %0.4f, not equal to 1.', u)
        end
    end
    %% Test if the mean of the pdf function is the forward.
    function testPdf2()
        u = getEuropean(volSurface, 0.8, @(x)x);
        if abs(u - fwd) > 0.00001
            error('The mean of the pdf function is %0.4f, while the forward is %0.4f.', u, fwd)
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
    testPdf1();
    testPdf2();
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
    
    



