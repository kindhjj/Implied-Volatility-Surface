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
    
    try 
%       K = bisection(f, fwd*0.001, fwd*1000, 1e-6);
%         K = secant(f,fwd/2,fwd*1.5,1e-6,4000);
%          K = fsolve(f,fwd*0.5);
        K = zeroin(f,fwd*0.01,fwd*100);   
    catch
        disp('Fail to calculate strike price.Please Check');
    end
end


function delta = OptionDelta(fwd,T,K,sigma,cp)
    d1 = log(fwd/K)/(sigma*sqrt(T)) + 0.5*sigma*sqrt(T);
    if cp == 1
        delta = normcdf(d1);
    else
        delta = normcdf(-d1);
    end
%     display(delta);
end

function x1 = secant( f, x0, x1, xAcc, nIter )
    
	fx0 = f( x0 );

	found = 0; 

	for i = 1:nIter  % the limit on nIter is a guard for infinite loops
		 x1Old = x1;
		 fx1   = f( x1 );
		 x1 = x1 - fx1 * ( x1  - x0 ) / ( fx1 - fx0 ); % update x1
		
		 if ( abs( x1 - x1Old ) < xAcc ) % exit criteria
			found = 1;
			break;
		 end

		 x0  = x1Old;  % update x0
		 fx0 = fx1;    % update fx0
	end

	if( ~found ), error( 'Maximum number of iterations exceeded ' ); end
end

function c = bisection( f, a, b, eps )
	fa = f(a);
	fb = f(b);
	if (fa*fb >= 0 ), error( 'f(a)f(b)>=0' ); end
	while (b-a > eps)
		c  = (a+b)/2;
		fc = f(c);
		
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

function b = zeroin(f,a,b)
    fa = f(a);
    fb = f(b);
    if (fa*fb > 0 ), error( 'f(a)f(b)>=0' ); end
    
    c = a;
    fc = fa;
    d = b-c;
    e = d;
    while fb~=0
        % Rearrange a,b and c to satisfy:
        %   f(x) changes sign between a and b.
        %   abs(f(b)<abs(f(a).
        %   c = previous b. 
        % The next point is decided by:
        %   Bisection point, (a+b)/2.
        %   Secant point determined by b and c.
        %   Inverse quadratic interpolation point determined by a, b and c 
        
        if (fa*fb > 0 )
            a = c; fa = fc;
            d = b-c; e = d;
        end
        if abs(fa) < abs(fb)
            c = b; b = a; a = c;
            fc = fb; fb = fa; fa = fc;
        end
        
        %judge if convergence
        m = 0.5 * (a-b);
        tol = 2.0 * eps * max(abs(b),1.0);
        if (abs(m) <= tol) || (fb == 0.0)
            break
        end
        
        % choose next point among the three methods
        if (abs(e) < tol || abs(fc) <= abs(fb))
            %bisection
            d = m;
            e = m;
        else
            %Interpation
            s = fb/fc;
            if (a==c)
                p = 2.0*m*s;
                q = 1.0 - s;
            else
                q = fc/fa;
                r = fb/fa;
                p = s*(2.0*m*q*(q-r) - (b-c)*(r-1.0));
                q = (q - 1.0)*(r - 1.0)*(s - 1.0);
            end
            if p > 0
                q = -q;
            else
                p = -p;
            end
            if (2.0*p < 3.0*m*q - abs(tol*q))&&(p<abs(0.5*e*q))
                e = d;
                d = p/q;
            else
                d = m;
                e = m;
            end
        end
        
        %next point
        c = b;
        fc = fb;
        if abs(d) > tol
            b = b+d;
        else
            b = b-sign(b-a)*tol;
        end
        fb = f(b);
    end
end