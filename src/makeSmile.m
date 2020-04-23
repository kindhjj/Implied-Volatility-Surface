function [curve] = makeSmile(fwdCurve, T, cps, deltas, vols)
% Author = 'Luo Jiarong'
% Inputs:
%   fwdCurve: forward curve data
%	T: time to expiry of the option
%	cps: vetor if 1 for call, -1 for put
%	deltas: vector of delta in absolute value
%   vols: Implied Vol [1 * n]

% Outputs:
%   curve.pp:
%       struct in interpolation
%   curve.AL, curve.BL, curve.AR, curve.BR:
%       coefs in extrapolation
    
    fwd = getFwdSpot(fwdCurve, T);
    
    N = length(deltas);
    N2 = length(vols);

    % check inputs
    InputChecking.checkDeltasVolsdim(deltas, vols);
    InputChecking.checkNodes(N);
    InputChecking.checkT(T);
    InputChecking.checkVolsVec(vols);
     
    K = zeros(1,N);
    C = zeros(1,N);
    
    for n = 1:N
       K(n) = getStrikeFromDelta(fwd, T, cps(n), vols(n), deltas(n));
       C(n) = getBlackCall(fwd, T, K(n), vols(n));       
    end    

    K1 = [0, K];    % Add a dummy strike
    C1 = [fwd, C];  % Add a dummy option price
    
    % check arbitrages
    if any(C <= 0)
        error('Error. Call price <= 0.');
    end
    
    arbitrage1 = diff(C1)./diff(K1);  
    if ~(all((arbitrage1(:) > -1) & (arbitrage1(:) < 0)))    
        error('Error, arbitrage in constraints 1');
    end
    
    arbitrage2 = diff(arbitrage1);
    if ~(all(arbitrage2(:) > 0))    
       error('Error, arbitrage in constraints 2');
    end
    
    %Calculation of Spline Coefficients
    curve.pp = csape(K, vols, 'variational');
    
    %Calculation of Extrapolation Coefficients
    KL = K(1) * K (1) / K(2);
    KR = K(N) * K(N) / K(N-1);
    curve.BR = atanh(sqrt(1/2)) / (KR - K(N));
    curve.BL = atanh(sqrt(1/2)) / (K(1) - KL);
    
    sigma_1 = curve.pp.coefs(1, 3);
    sigma_N = curve.pp.coefs(end, 3) + ...
        2 * curve.pp.coefs(end, 2) * (K(N) - K(N-1)) + ...
        3 * curve.pp.coefs(end, 1) * (K(N) - K(N-1))^2;

    curve.AR = sigma_N / curve.BR;
    curve.AL = -sigma_1 / curve.BL;
end