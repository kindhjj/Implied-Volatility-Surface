% Computes the price of a European payoff by integration
% Input :
% volSurface : volatility surface data
% T : time to maturity of the option
% payoff : payoff function
% ints : optional , repartition of integration intervals e.g. [0, 3, +Inf]
% Output :
% u : forward price of the option ( undiscounted price )
function u = getEuropean ( volSurface, T, payoff, ints )
% Check inputs.
if ~all(isfield(volSurface,{'spots','fwdCurve','Ts','slopes','smiles'}))
    error('Error. volSurface input error: the struct is not complete.')
end
if length(T)>1
    error('Error. length of T larger than 1.')
end
if T<0||T>volSurface.Ts(end)
    error('Error. Invalid T value.')
end
% Use Trapzoid rule to solve the integral.
h = 0.0001;
if (nargin < 4) || isequal(ints, [0,+Inf])
    x = 0.0005 : h : 10;
    y = getPdf(volSurface, T, x) .* payoff(x);
    u = h * trapz(y);
else
    x1 = 0.0005 : h : ints(2);
    y1 = getPdf(volSurface, T, x1) .* payoff(x1);
    u1 = h * trapz(y1);
    x2 = ints(2) : h : 10;
    y2 = getPdf(volSurface, T, x2) .* payoff(x2);
    u2 = h * trapz(y2);
    u = u1 + u2;
end
end




