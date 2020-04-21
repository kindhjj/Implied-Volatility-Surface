% Inputs:
%   curve: pre-computed fwd curve data
%   T: forward spot date
% Output:
%   fwdSpot: E[S(t) | S(0)]

function fwdSpot = getFwdSpot(curve, T)
    getFwdSpotCheck(curve, T)
    
    last_ts_index = find(curve.ts <= T, 1, 'last');
    last_fwd = curve.fwd(last_ts_index);
    fwdir = curve.fwdir(last_ts_index);
    
    fwdSpot = last_fwd * exp(fwdir * (T - curve.ts(last_ts_index)));
end
    
function getFwdSpotCheck(curve, T)
    if ~all(isfield(curve,{'fwd', 'ts', 'fwdir'}))
        error('Error. curve input error: the struct is not complete.') 
    elseif (length(curve.fwd) ~= length(curve.ts)) || (length(curve.fwdir) ~= length(curve.ts))
        error('Error. curve dimension not match.')
    elseif (length(curve.fwd) * length(curve.ts) * length(curve.fwdir)) == 0
        error('Error. empty curve.')
    elseif sum(curve.ts < 0) > 0
        error('Error. curve.ts should not be negative.')
    elseif sum(curve.fwd < 0) > 0
        error('Error. curve.fwd should not be negative.')
    elseif length(T)>1
        error('Error. length of T larger than 1.')
    elseif T < 0
        error('Error. T should not be negative.')
    end
end