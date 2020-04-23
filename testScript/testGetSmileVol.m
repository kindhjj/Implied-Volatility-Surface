function testGetSmileVol()
% Author = 'Luo Jiarong'
% 1. check invalid inputs;
% 2. check whether the plot of a smile curve look smooth;
% 3. check 1st deriv(continuous) and 2nd deriv(natural) at K1 and KN.
    
    [spot, lag, days, domdfs, fordfs, vols, cps, deltas] = getMarket();

    tau = lag / 365; % spot rule lag

    % Time to maturities in years
    Ts = days / 365;

    % Construct market objects
    domCurve = makeDepoCurve(Ts, domdfs);
    forCurve = makeDepoCurve(Ts, fordfs);
    fwdCurve = makeFwdCurve(domCurve, forCurve, spot, tau);
    
    smile = makeSmile(fwdCurve, Ts(end), cps, deltas, vols(end,:));
    
    % 2nd check
    testPlotVolcurveK2D();
    
    K1 = smile.pp.breaks(1);
    KN = smile.pp.breaks(end);
    KN_1 = smile.pp.breaks(end - 1);
    
    % 3rd check (1st derivative at K1, KN, continuous)
    sigma1_1_left = -smile.AL * smile.BL
    sigma1_1_right = smile.pp.coefs(1, 3)
    sigma1_N_left = smile.pp.coefs(end, 3) + ...
        2 * smile.pp.coefs(end, 2) * (KN - KN_1) + ...
        3 * smile.pp.coefs(end, 1) * (KN - KN_1)^2
    sigma1_N_right = smile.AR * smile.BR  
    % 3rd check (2nd derivative at K1, KN, natural boundaries)
    sigma2_1_right = 2 * smile.pp.coefs(1, 2)
    sigma2_N_left = 2 * smile.pp.coefs(end, 2) + ...
        6 * smile.pp.coefs(end, 1) * (KN - KN_1)

    % 1st check
    vol = getSmileVol(smile, -1)    % K < 0, error
end