% Inputs :
% fwd: forward spot for time T, i.e. E[S(T)]
% T: time to expiry of the option
% cp: 1 for call , -1 for put
% sigma : implied Black volatility of the option
% delta : delta in absolute value (e.g. 0.25)
% Output :
% K: strike of the option
function K = getStrikeFromDelta (fwd , T, cp , sigma , delta)
    getStrikeFromDeltaInputCheck(fwd , T, cp , sigma , delta,'Invalid Input');
    f = @(K) (OptionDelta(fwd,T,K,sigma,cp)-delta);
%     [K,~] = secant(f,fwd/2,fwd*1.5,1e-6,4000);
%     K = fsolve(f,fwd*0.1);
    
    try 
%         [K,~] = bisection(f, fwd*0.001, fwd*1000, 1e-6);
        [K,~] = secant(f,fwd/2,fwd*1.5,1e-6,4000);
%          K = fsolve(f,fwd*0.1);
    catch
        disp('Fail to calculate strike price.Please Check')
    end
end


function delta = OptionDelta(fwd,T,K,sigma,cp)
    d1 = log(fwd/K)/(sigma*sqrt(T)) + 0.5*sigma*sqrt(T);
    if(cp)
        delta = normcdf(d1);
    else
        delta = -normcdf(-d1);
    end
end

function [x1,h] = secant( f, x0, x1, xAcc, nIter )
    
	fx0 = f( x0 );

	found = 0; h=[];

	for i = 1:nIter  % the limit on nIter is a guard for infinite loops
		 x1Old = x1;
		 fx1   = f( x1 );
		 x1 = x1 - fx1 * ( x1  - x0 ) / ( fx1 - fx0 ); % update x1
		 h(i,:)=[i, x1]; % unnecessary, just for display

		 if ( abs( x1 - x1Old ) < xAcc ) % exit criteria
			found = 1;
			break;
		 end

		 x0  = x1Old;  % update x0
		 fx0 = fx1;    % update fx0
	end

	if( ~found ), error( 'Maximum number of iterations exceeded ' ); end
end

function [c,x] = bisection( f, a, b, eps )
	fa = f(a);
	fb = f(b);
	i  = 1; x = [];
	if (fa*fb >= 0 ), error( 'f(a)f(b)>=0' ); end
	while (b-a > eps)
		c  = (a+b)/2;
		fc = f(c);
		x(i,:)=[i, c, a, b, b-a]; i=i+1;
		if (fc*fa<0)
		   b = c;
		   fb = fc;
		elseif fc == 0
		   return
		else
		   a = c;
		   fa = fc;
        end
    end
end