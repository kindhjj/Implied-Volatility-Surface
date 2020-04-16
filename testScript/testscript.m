[spot, lag, days, domdfs, fordfs, vols, cps, deltas] = getMarket();

tau = lag / 365; % spot rule lag

% time to maturities in years
Ts = days / 365;

% construct market objects
domCurve = makeDepoCurve(Ts, domdfs);
forCurve = makeDepoCurve(Ts, fordfs);
fwdCurve = makeFwdCurve(domCurve, forCurve, spot, tau);
%fwd = getFwdSpot(fwdCurve, 0.8);

% build ans use a smile
smile = makeSmile(fwdCurve, Ts(end), cps, deltas, vols(end,:));
atmfvol = getSmileVol(smile, getFwdSpot(fwdCurve, Ts(end)));
getSmileVol(smile, 0.004)

volcurve=makeVolSurface(fwdCurve ,Ts , cps , deltas , vols);
getVol(volcurve,0.001,volcurve.spots(6))
getVol(volcurve,0.05,0.001)
