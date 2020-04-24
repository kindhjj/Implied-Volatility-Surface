function testMakeSmile()
% Author = 'Luo Jiarong'
% 1. check invalid inputs;
% 2. check arbitrage constraints

    [spot, lag, days, domdfs, fordfs, vols, cps, deltas] = getMarket();

    tau = lag / 365; % spot rule lag

    % Time to maturities in years
    Ts = days / 365;

    % Construct market objects
    domCurve = makeDepoCurve(Ts, domdfs);
    forCurve = makeDepoCurve(Ts, fordfs);
    fwdCurve = makeFwdCurve(domCurve, forCurve, spot, tau);
    
    % 1st check in invalid input
    try
        disp('Test invalid input.');
        makeSmile(fwdCurve, Ts(end), cps, [deltas 1], vols(end,:));
    catch e
        fprintf('%s\n\n',e.message);
    end

    try
        disp('Test invalid input.');
        makeSmile(fwdCurve, Ts(end), cps, deltas, [-1 0.5 0.5 0.5 0.5]);
    catch e
        fprintf('%s\n\n',e.message);
    end
    
    try
        disp('Test invalid input.');
        makeSmile(fwdCurve, Ts(end), cps(1:3), deltas(1:3), vols(end,1:3));
    catch e
        fprintf('%s\n\n',e.message);
    end
    
    % 2nd check in arbitrage constraints
    try
        disp('Test arbitrage constraints.');
        makeSmile(fwdCurve, Ts(end), cps, deltas, [0.7 0.5 0.5 0.5 0.1]);
    catch e
        fprintf('%s\n\n',e.message);
    end

end