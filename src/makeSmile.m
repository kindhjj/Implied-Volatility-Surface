function [curve] = makeSmile(fwdCurve, T, cps, deltas, vols)
% Inputs:
%   fwdCurve: forward curve data
%   vols: Implied Vol [1 * n]

% Outputs:
%   curve,K: Strike used in interpolation
%   curve.a, curve.b, curve.c, curve.d:
%       coefs in interpolation
%   curve.AL, curve.BL, curve.AR, curve.BR:
%       coefs in extrapolation
    
    fwd = getFwdSpot(fwdCurve, T);
    
    N = length(deltas);
    N2 = length(vols);

    if(N ~= N2)
        errordlg('Size of deltas and Vols must be the same');
        return;
    end
    
    if(N < 4)
        errordlg('Number of Nodes must not be less than 4');
        return;
    end
    
    K = zeros(1,N);
    C = zeros(1,N);
    
    for n = 1:N
       K(n) = getStrikeFromDelta(fwd, T, cps(n), vols(n), deltas(n));
       C(n) = getBlackCall(fwd, T, K(n), vols(n));       
    end    

    
    % K1 = [0, K];    % Add a dummy strike
    % C1 = [fwd, C];  % Add a dummy option price
    
    % Still need to deploy arbitrage3 check and dummy C£¡£¡£¡£¡£¡£¡£¡£¡£¡£¡£¡£¡£¡£¡£¡
    
    arbitrage1 = diff(C)./diff(K);  
    if ~(all((arbitrage1(:) > -1) & (arbitrage1(:) < 0)))    
        errordlg('Error, arbitrage in constraints 1');
        return;
    end
    
    arbitrage2 = diff(arbitrage1);
    if ~(all(arbitrage2(:) > 0))    
       errordlg('Error, arbitrage in constraints 2');
       return;
    end
    
        
      
    
    
    curve.K = K;
    
    % Data Definitions and initionalization
    hMat = zeros(N-2);
    S = zeros(N,1);
    
    h = diff(K);
    hMat(1,1) = 2*(h(1)+h(2)); hMat(1,2) = h(2);
    for n = 2:N-3
        hMat(n,n-1) = h(n); hMat(n,n) = 2*(h(n)+h(n+1)); hMat(n,n+1) = h(n+1);
    end
    hMat(n+1,n-1) = h(n+1); hMat(n+1,n+1) = 2*(h(n+1)+h(n+2));

    %Calculates divided Differences in a Column Matrix 'S'
    divdif = diff(vols)./diff(K);
    dMat = 6*(diff(divdif))';
    S(2:N-1) = hMat\dMat;
    
    %Calculation of (N-1) Cubic curves' Coefficients
    curve.a = zeros(1,N-1);
    curve.b = zeros(1,N-1);
    curve.c = zeros(1,N-1);
    curve.d = zeros(1,N-1);
    for n = 1:N-1
        curve.a(n) = (S(n+1)-S(n))/(6*h(n));
        curve.b(n) = S(n)/2;
        curve.c(n) = (vols(n+1)-vols(n))/h(n) - (2*h(n)*S(n)+h(n)*S(n+1))/6;
        curve.d(n) = vols(n);
    end
   
    
    
    %Calculation of Extrapolation Coefficients
    KL = K(1) * K (1) / K(2);
    KR = K(N) * K(N) / K(N-1);
    curve.BR = atanh(sqrt(1/2)) / (KR - K(N));
    curve.BL = atanh(sqrt(1/2)) / (K(1) - KL);
    
    syms x
    f(x) = curve.d(N-1) + curve.c(N-1)*(x-K(N-1)) + curve.b(N-1)*(x-K(N-1))^2 + curve.a(N-1)*(x-K(N-1))^3;
    g(x) = curve.d(1) + curve.c(1)*(x-K(1)) + curve.b(1)*(x-K(1))^2 + curve.a(1)*(x-K(1))^3;
    f1 = diff(f,1); g1 = diff(g,1);
    curve.AR = double(f1(K(N)) / curve.BR);
    curve.AL = double(-g1(K(1)) / curve.BL);
   
    
end