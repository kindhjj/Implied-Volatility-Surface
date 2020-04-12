X=[0.1 1.1  1.6  2.4  2.5  4.1  5.2  6.1  6.6  7.1  8.2  9.1];
Y=[1.9 7.9 24.9 24.9 34.9 42.7 29.7 49.8 36.1 23.7 13.0 20.5];

curve = cal_coefs(X, Y);
vols = getSmileVol(curve, [0.1 1.1  1.6  2.4  2.5  4.1  5.2  6.1  6.6  7.1  8.2  9.09999999999])

syms x
% f(x) = curve.d(11) + curve.c(11)*(x-8.2) + curve.b(11)*(x-8.2)^2 + curve.a(11)*(x-8.2)^3

function curve = cal_coefs(K, vols)
% Inputs:
%   K: Strike
%   vols: Implied Vol

% Outputs:
%   curve,K: Strike used in interpolation
%   curve.a, curve.b, curve.c, curve.d:
%       coefs in interpolation
%   curve.AL, curve.BL, curve.AR, curve.BR:
%       coefs in extrapolation
   

    N = length(K);
    N2 = length(vols);

    if(N ~= N2)
        errordlg('Size of K and Vols must be the same');
       return;
    end
    
    if(N < 4)
        errordlg('Number of Nodes must not be less than 4');
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

function vols = getSmileVol(curve, Ks)
% Inputs:
%   curve: A struct
%   K: Strike
%   Assume that Ks vector is disordered,
%   if it is order, algo will be quicker.


% Outputs:
%   vols: Predicted Vol
    
    N = length(Ks);
    vols = zeros(1, N);
    
    loc = discretize(Ks, [-Inf curve.K Inf]);
    
    for n = 1:N
        t = loc(n);
        if (t > 1) && (t <= length(curve.K))
            vols(n) = curve.d(t-1) + ...
                curve.c(t-1) * (Ks(n) - curve.K(t-1)) + ...
                curve.b(t-1) * (Ks(n) - curve.K(t-1))^2 + ...
                curve.a(t-1) * (Ks(n) - curve.K(t-1))^3;        
        end    
    end
end



