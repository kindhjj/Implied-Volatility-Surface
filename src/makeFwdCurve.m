% Inputs:
%   domCurve: domestic IR curve data
%   forCurve: foreign IR curve data
%   spot: spot exchange rate
%   tau: lag between spot and settlement
% Output:
%   curve: a struct containing data needed by getFwdSpot

function curve = makeFwdCurve(domCurve, forCurve, spot, tau)
    
    InputChecking.checkFwdCurve(domCurve, forCurve, spot, tau)
    
    % save these variable, which is used for the calculation of forward spot price
    curve.domCurve = domCurve;
    curve.forCurve = forCurve;
    % X0 is the cash spot price
    curve.X0 = spot / exp(getRateIntegral(domCurve, tau) - getRateIntegral(forCurve, tau));
    % tau is the settlement day
    curve.tau = tau;
    
%     old method, which has precision problem
%     curve.fwd = spot.* exp((domCurve.ir - forCurve.ir) .* forCurve.ts);
%     curve.fwd = [[spot]; curve.fwd];
    
%     curve.ts = [[0]; forCurve.ts];
    
% %     used for the calculation of fwd between T_i and T_i+1
%     curve.fwdir = log(curve.fwd(2:end) ./ curve.fwd(1:end-1)) ./ diff(curve.ts);
%     curve.fwdir = [curve.fwdir; [domCurve.ir(end) - forCurve.ir(end)]];
    
end