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
InputChecking.checkvolsurface(volSurface);
InputChecking.checkT(T);
InputChecking.checkTvolsurface(T, volSurface);
InputChecking.checkFun(payoff);
if (nargin > 3) && ~isempty(ints)
    InputChecking.checkInts(ints);
end

% main body
f = @(x) (getPdf(volSurface, T, x) .* payoff(x));
if (nargin < 4) || isequal(ints, [0,+Inf])
     u = integral(@(x) f(x), 0, Inf);
else
     u1 = integral(@(x) f(x), max(ints(1), 0), ints(2));
     u2 = integral(@(x) f(x), ints(2), Inf);
     u = u1 + u2;
end
end




