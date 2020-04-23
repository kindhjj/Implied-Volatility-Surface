% Inputs:
%   curve: pre-computed data about an interest rate curve
%   t: time
% Output:
%   integ: integral of the local rate function from 0 to t

function integ = getRateIntegral(curve, t)
    InputChecking.checkIntCurve(curve);
    InputChecking.checkT(t);
    
    if (curve.ts(1) < t) && (t < curve.ts(end))
        last_ts_index = find(curve.ts <= t, 1, 'last');
        
        integ = curve.integ(last_ts_index) + curve.fwdir(last_ts_index) * (t-curve.ts(last_ts_index));
        
    elseif t <= curve.ts(1)
        integ = curve.ir(1) * t;
            
    else
        integ = curve.ir(end) * t;
    end
end