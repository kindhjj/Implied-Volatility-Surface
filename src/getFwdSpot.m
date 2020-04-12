% Inputs:
%   curve: pre-computed fwd curve data
%   T: forward spot date
% Output:
%   fwdSpot: E[S(t) | S(0)]

function fwdSpot = getFwdSpot(curve, T)
    Lomo_Before_Check(curve.fwd(2:end), curve.ts(2:end), 'Unable to get forward spot.');
    
    try
        if (curve.ts(1) <= T) && (T < curve.ts(end))
            last_ts_index = find(curve.ts <= T, 1, 'last');
            last_fwd = curve.fwd(last_ts_index);
            fwdir = curve.fwdir(last_ts_index);
            
            fwdSpot = last_fwd * exp(fwdir * (T - curve.ts(last_ts_index)));
            
        elseif T >= curve.ts(end)
            last_fwd = curve.fwd(end);
            fwdir = curve.delta_ir_end;
            
            fwdSpot = last_fwd * exp(fwdir * (T - curve.ts(end)));
                
        else
            warning('It is unbelivable to run this code!');
        end
    
    catch
        Lomo_After_Check(curve.ir, curve.ts, 'Unable to get rate integral.');
    end
end