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
    error('Error. Length of T larger than 1.')
end
if T<0||T>volSurface.Ts(end)
    error('Error. Invalid T value.')
end
if isa(payoff,'function_handle')
    error('Error. Invalid payoff function.')
end
if ~isempty(ints)
    if length(ints) < 2
        error('Error. The number of elements in integration interval is smaller than 2.')
    end
    if ~all(ints >= 0)
        error('Error. Invalid integration interval.')
    end
end

% main body
if (nargin < 4) || isequal(ints, [0,+Inf])
     f = @(x) (getPdf(volSurface, T, x) .* payoff(x));
     u = integral(@(x) f(x), 0.005, Inf);
else
     f = @(x)(getPdf(volSurface, T, x) .* payoff(x));
     u1 = integral(@(x) f(x), max(ints(1), 0.005), ints(2));
     u2 = integral(@(x) f(x), ints(2), Inf);
     u = u1 + u2;
end
end




