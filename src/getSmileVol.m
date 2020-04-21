
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

% Outputs:
%   vols: Predicted Vol
    
    N = length(Ks);
    K1 = curve.pp.breaks(1);
    KN = curve.pp.breaks(end);
    
    
    left = Ks(Ks < K1);
    inter = Ks((Ks >= K1) & (Ks <= KN));
    right = Ks(Ks > KN);
    
    vol_left = ppval(curve.pp, K1) + ...
        curve.AL * tanh(curve.BL * (K1 - left));
    vol_inter = ppval(curve.pp, inter);
    vol_right = ppval(curve.pp, KN) + ...
        curve.AR * tanh(curve.BR * (right - KN));
    
    vols = [vol_left;vol_inter;vol_right]';

end



