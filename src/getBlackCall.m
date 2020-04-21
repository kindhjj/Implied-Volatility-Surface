% Inputs :
% f: forward spot for time T, i.e. E[S(T)]
% T: time to expiry of the option
% Ks: vector of strikes
% Vs: vector of implied Black volatilities
% Output :
% u: vector of call options undiscounted prices
function u = getBlackCall (f, T, Ks , Vs)
    getBlackCallInputCheck(f, T, Ks,Vs,'Invalid Input');
    tmp = Vs.*sqrt(T);
    d1 = log(f./Ks)./tmp + 0.5 .* tmp;
    d2 = d1 - tmp;
    u = f* normcdf(d1) - Ks.*normcdf(d2);
end

function getBlackCallInputCheck(f, T, Ks, Vs,msg)
     if  f<=0
         errID = 'Error:InvaildValue';
         baseException = MException(errID,msg);
         causeException = MException('Error:InvaildValue','Forward spot should be positive!');
         
         baseException = addCause(baseException,causeException);
         throw(baseException);
         
     elseif T < 0
         errID = 'Error:InvaildValue';
         baseException = MException(errID,msg);
         causeException = MException('Error:InvalidValue','Time to expiry should be non-negative!');
         
         baseException = addCause(baseException,causeException);
         throw(baseException);
     elseif length(Ks)~=length(Vs)
         errID = 'Error:InvaildValue';
         baseException = MException(errID,msg);
         causeException = MException('Error:InvalidValue','Length of strike price and volatlites should be the same!');

         
         baseException = addCause(baseException,causeException);
         throw(baseException);
         
     elseif any(Ks<=0)~=0
         errID = 'Error:InvaildValue';
         baseException = MException(errID,msg);
         causeException = MException('Error:InvalidValue','Strike Prive should be positive!');
         
         baseException = addCause(baseException,causeException);
         throw(baseException);
         
     elseif any(Vs<=0)~=0
         errID = 'Error:InvaildValue';
         baseException = MException(errID,msg);
         causeException = MException('Error:InvalidValue','Implied Black volatilities should be positive!');
           
         baseException = addCause(baseException,causeException);
         throw(baseException);
    
     end    
end

    
