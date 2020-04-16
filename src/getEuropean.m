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
if ~all(isfield(volSurf,{'spots','fwdCurve','Ts','slopes','smiles'}))
    error('Error. volSurface input error: the struct is not complete.')
end
if length(T)>1
    error('Error. length of T larger than 1.')
end
if T<0||T>volSurface.Ts(end)
    error('Error. Invalid T value.')
end
% Use Trapzoid rule to solve the integral.
h = 0.05;
if (nargin < 4) || isempty(ints)
    x = 0 : h : 1000;
else
    x = min(ints) : h : max(ints);
end
y = getPdf(volSurface, T, x) .* payoff(x);
u = h * trapz(y);
end




