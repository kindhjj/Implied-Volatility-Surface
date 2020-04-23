% Inputs:
%   ts: array of size N containing times to settlement in years
%   dfs: array of size N discount factors
% Outputs:
%   curve: a struct containing data needed by get RateIntegral

function curve = makeDepoCurve(ts , dfs)
    
    InputChecking.checkDepoCurve(ts, dfs);
            
    curve.ir = -log(dfs) ./ ts;
    curve.ts = ts;
    curve.integ = curve.ir .* curve.ts;

    curve.fwdir = (curve.ir(2:end) .* curve.ts(2:end)...
    - curve.integ(1:end-1)) ./ (curve.ts(2:end)-curve.ts(1:end-1));
end