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
%     smile = makeSmile(fwdCurve, Ts(end), cps, [deltas 1], vols(end,:));        % vector dimension do not match, error
%     smile = makeSmile(fwdCurve, Ts(end), cps, deltas, [-1 0.5 0.5 0.5 0.5]);   % IV negative, error
%     smile = makeSmile(fwdCurve, Ts(end), cps(1:3), deltas(1:3), vols(end,1:3));  % input length must be longer than 4 to interpolation, error
    
    % 2nd check in arbitrage constraints
    smile = makeSmile(fwdCurve, Ts(end), cps, deltas, [0.7 0.5 0.5 0.5 0.1]);


end