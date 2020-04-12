% Inputs:
%   domCurve: domestic IR curve data
%   forCurve: foreign IR curve data
%   spot: spot exchange rate
%   tau: lag between spot and settlement
% Output:
%   curve: a struct containing data needed by getFwdSpot

function curve = makeFwdCurve(domCurve, forCurve, spot, tau)
    
    Lomo_Before_Check(domCurve.ir, forCurve.ir, 'Unable to get forward curve.');
    Lomo_Before_Check(domCurve.ts, forCurve.ts, 'Unable to get forward curve.');
    Lomo_Before_Check(domCurve.ir, domCurve.ts, 'Unable to get forward curve.');
    
    if (spot <= 0) || (tau < 0)
        errID = 'Error:BadInput';
        baseException = MException(errID,'Unable to get forward curve.');
        
        if spot <= 0
            causeException = MException('Error:BadValue','spot should be positive!');
        else
            causeException = MException('Error:BadValue','tau should not be negative!');
        end
        
        baseException = addCause(baseException,causeException);
        throw(baseException);
    end
    
    try
        curve.fwd = spot.* exp((domCurve.ir - forCurve.ir) .* (forCurve.ts +tau));
        curve.fwd = [[spot]; curve.fwd];
        
        curve.ts = [[0]; forCurve.ts];
        
        curve.fwdir = log(curve.fwd(2:end) ./ curve.fwd(1:end-1)) ./ diff(curve.ts);
        curve.fwdir = [[0]; curve.fwdir];
        
        curve.delta_ir_end = domCurve.ir(end) - forCurve.ir(end);
        
    catch
        Lomo_After_Check(forCurve.ir, forCurve.ts, 'Unable to get forward curve.');
    end
end