% Inputs:
%   curve: pre-computed data about an interest rate curve
%   t: time
% Output:
%   integ: integral of the local rate function from 0 to t

function integ = getRateIntegral(curve, t)
    Lomo_Before_Check(curve.ir, curve.ts, 'Unable to get rate integral.');
    
    try
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
    
    catch
        Lomo_After_Check(curve.ir, curve.ts, 'Unable to get rate integral.');
    end
end