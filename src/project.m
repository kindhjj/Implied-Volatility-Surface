% This program provides the skeleton for the project
function project()

    [spot, lag, days, domdfs, fordfs, vols, cps, deltas] = getMarket();

    tau = lag / 365; % spot rule lag

    % time to maturities in years
    Ts = days / 365;

    % construct market objects
    domCurve = makeDepoCurve(Ts, domdfs);
    forCurve = makeDepoCurve(Ts, fordfs);
    fwdCurve = makeFwdCurve(domCurve, forCurve, spot, tau);
    volSurface = makeVolSurface(fwdCurve, Ts, cps, deltas, vols);

    % compute a discount factor
    domRate = exp(-getRateIntegral(domCurve, 0.8))

    % compute a forward spot rate G_0(0.8)
    fwd = getFwdSpot(fwdCurve, 0.8)

    % build ans use a smile
    smile = makeSmile(fwdCurve, Ts(end), cps, deltas, vols(end,:));
    atmfvol = getSmileVol(smile, getFwdSpot(fwdCurve, Ts(end)));

    % get some vol
    [vol, f] = getVol(volSurface, 0.8, [fwd, fwd])

    % get cdf
    cdf = getCdf(volSurface, 0.8, [fwd, fwd])

    % get pdf
    pdf = getPdf(volSurface, 0.8, [fwd, fwd])

    % european
    u = getEuropean(volSurface, 0.8, @(x)max(x-fwd,0))
    
    % european
    u = getEuropean(volSurface, 0.8, @(x)max(x-fwd,0), [0, +Inf])