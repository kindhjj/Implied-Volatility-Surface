% Inputs:
%   ts: array of size N containing times to settlement in years
%   dfs: array of size N discount factors
% Outputs:
%   curve: a struct containing data needed by get RateIntegral

function curve = makeDepoCurve(ts , dfs)
    Lomo_Before_Check(ts, dfs, 'Unable to make depo curve.');
    
    try
        curve.ir = log(1 ./ dfs) ./ ts;
        curve.ts = ts;
        
    catch
        Lomo_After_Check(ts, dfs, 'Unable to make depo curve.')
    end
end