% Inputs:
%   ts: array of size N containing times to settlement in years
%   dfs: array of size N discount factors
% Outputs:
%   curve: a struct containing data needed by get RateIntegral

function curve = makeDepoCurve(ts , dfs)
    
    makeDepoCurveCheck(ts , dfs);
            
    curve.ir = -log(dfs) ./ ts;
    curve.ts = ts;
    curve.integ = curve.ir .* curve.ts;

    curve.fwdir = (curve.ir(2:end) .* curve.ts(2:end)...
    - curve.integ(1:end-1)) ./ (curve.ts(2:end)-curve.ts(1:end-1));
end

function makeDepoCurveCheck(ts , dfs)
    if length(ts) ~= length(dfs)
        error('Error. dimension not match.')
    elseif any(ts <= 0) || any(dfs <= 0)
        error('Error. input should be positive.')
    elseif (length(ts) * length(dfs)) == 0
        error('Error. empty input.')
    end
end