function vols = getSmileVol(curve, Ks)
% Author = 'Luo Jiarong'
% Inputs:
%   curve: pre-computed smile data
%   Ks: Strike

% Outputs:
%   vols: IV at strikes Ks
    
    Ks = reshape(Ks, [], 1);
    % check inputs
    InputChecking.checkKs(Ks);
    InputChecking.checkVolSmile(curve);

    K1 = curve.pp.breaks(1);
    KN = curve.pp.breaks(end);
    
    left = Ks(Ks < K1);
    inter = Ks((Ks >= K1) & (Ks <= KN));
    right = Ks(Ks > KN);
    
    %interpolation and extrapolation
    vol_left = ppval(curve.pp, K1) + ...
        curve.AL * tanh(curve.BL * (K1 - left));
    vol_inter = ppval(curve.pp, inter);
    vol_right = ppval(curve.pp, KN) + ...
        curve.AR * tanh(curve.BR * (right - KN));
    
    vols = [vol_left;vol_inter;vol_right]';
end



