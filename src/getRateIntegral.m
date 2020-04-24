% Inputs:
%   curve: pre-computed data about an interest rate curve
%   t: time
% Output:
%   integ: integral of the local rate function from 0 to t

function integ = getRateIntegral(curve, t)
    InputChecking.checkIntCurve(curve);
    InputChecking.checkT(t);
    
    % t_1 < t < t_n
    if (curve.ts(1) < t) && (t < curve.ts(end))
        last_ts_index = find(curve.ts <= t, 1, 'last');
        
        integ = curve.integ(last_ts_index) + curve.fwdir(last_ts_index) * (t-curve.ts(last_ts_index));
    % 0 <= t <= t_1
    elseif t <= curve.ts(1)
        integ = curve.ir(1) * t;
    % t >= t_n
    else
        integ = curve.integ(end-1) + curve.fwdir(end) * (t-curve.ts(end-1));
    end
end