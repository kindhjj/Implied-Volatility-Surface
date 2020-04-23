% Inputs:
%   curve: pre-computed fwd curve data
%   T: forward spot date
% Output:
%   fwdSpot: E[S(t) | S(0)]

function fwdSpot = getFwdSpot(curve, T)
    InputChecking.checkMoneyCurve(curve);
    InputChecking.checkT(T);
    
    last_ts_index = find(curve.ts <= T, 1, 'last');
    last_fwd = curve.fwd(last_ts_index);
    fwdir = curve.fwdir(last_ts_index);
    
    fwdSpot = last_fwd * exp(fwdir * (T - curve.ts(last_ts_index)));
end