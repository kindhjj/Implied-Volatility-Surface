% Inputs:
%   domCurve: domestic IR curve data
%   forCurve: foreign IR curve data
%   spot: spot exchange rate
%   tau: lag between spot and settlement
% Output:
%   curve: a struct containing data needed by getFwdSpot

function curve = makeFwdCurve(domCurve, forCurve, spot, tau)
    
    makeFwdCurveCheck(domCurve, forCurve, spot, tau)
    
    curve.fwd = spot.* exp((domCurve.ir - forCurve.ir) .* (forCurve.ts +tau));
    curve.fwd = [[spot]; curve.fwd];
    
    curve.ts = [[0]; forCurve.ts];
    
%     used for the calculation of fwd between T_i and T_i+1
    curve.fwdir = log(curve.fwd(2:end) ./ curve.fwd(1:end-1)) ./ diff(curve.ts);
    curve.fwdir = [curve.fwdir; [domCurve.ir(end) - forCurve.ir(end)]];
    
end

function makeFwdCurveCheck(domCurve, forCurve, spot, tau)
    CurveCheck(domCurve);
    CurveCheck(forCurve);
    
    if length(domCurve.ts) ~= length(forCurve.ts)
        error('Error. domCurve and forCurve dimension not match.')
    elseif spot <= 0
        error('Error. spot should be positive.')
    elseif tau < 0
        error('Error. tau should not be negative')
    end
end

function CurveCheck(curve)
    if ~all(isfield(curve,{'ts','ir'}))
        error('Error. curve input error: the struct is not complete.')
    elseif length(curve.ts) ~= length(curve.ir)
        error('Error. curve dimension not match.')
    elseif (length(curve.ts) * length(curve.ir)) == 0
        error('Error. empty curve.')
    elseif sum(curve.ts <= 0) > 0
        error('Error. curve.ts should be positive.')
    end
end