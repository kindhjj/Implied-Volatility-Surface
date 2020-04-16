
% X=[0.1 1.1  1.6  2.4  2.5  4.1  5.2  6.1  6.6  7.1  8.2  9.1];
% Y=[1.9 7.9 24.9 24.9 34.9 42.7 29.7 49.8 36.1 23.7 13.0 20.5];

% curve = cal_coefs(X, Y);
% vols = getSmileVol(curve, [0.1 1.1  1.6  2.4  2.5  4.1  5.2  6.1  6.6  7.1  8.2  9.09999999999])

% syms x
% f(x) = curve.d(11) + curve.c(11)*(x-8.2) + curve.b(11)*(x-8.2)^2 + curve.a(11)*(x-8.2)^3


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
        
        if t == 1
            vols(n) = curve.d(t) + curve.AL * tanh(curve.BL * (curve.K(t) - Ks(n)));
        end
        
        if t == length(curve.K) + 1
            vols(n) = curve.d(t-2) + ...
                curve.c(t-2) * (curve.K(t-2) - curve.K(t-3)) + ...
                curve.b(t-2) * (curve.K(t-2) - curve.K(t-3))^2 + ...
                curve.a(t-2) * (curve.K(t-2) - curve.K(t-3))^3;
            %vols(n) = curve.d(t-1) + curve.AR * tanh(curve.BR * (Ks(n) - curve.K(t-1)));
        end
        
    end
end



