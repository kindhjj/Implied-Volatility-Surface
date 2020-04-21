% Inputs:
%   curve: pre-computed data about an interest rate curve
%   t: time
% Output:
%   integ: integral of the local rate function from 0 to t

function integ = getRateIntegral(curve, t)
    getRateIntegralCheck(curve, t);
    
    if (curve.ts(1) < t) && (t < curve.ts(end))
        last_ts_index = find(curve.ts <= t, 1, 'last');
        integ = curve.ir(last_ts_index) * curve.ts(last_ts_index);
        
        forward_rate = (curve.ir(last_ts_index+1) * curve.ts(last_ts_index+1)...
            - integ) / (curve.ts(last_ts_index+1)-curve.ts(last_ts_index));
        
        integ = integ + forward_rate * (t-curve.ts(last_ts_index));
        
    elseif t <= curve.ts(1)
        integ = curve.ir(1) * t;
            
    else
        integ = curve.ir(end) * t;
    end
end

function getRateIntegralCheck(curve, t)
    if ~all(isfield(curve,{'ts','ir'}))
        error('Error. curve input error: the struct is not complete.')
    elseif length(curve.ts) ~= length(curve.ir)
        error('Error. curve dimension not match.')
    elseif (length(curve.ts) * length(curve.ir)) == 0
        error('Error. empty curve.')
    elseif sum(curve.ts <= 0) > 0
        error('Error. curve.ts should be positive.')
    elseif length(t)>1
        error('Error. length of t larger than 1.')
    elseif t < 0
        error('Error. negative input t.')
    end
end