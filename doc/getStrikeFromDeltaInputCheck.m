function [] = getStrikeFromDeltaInputCheck(fwd, T, cp , sigma , delta,msg)

     if fwd<=0
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
         
     elseif cp ~= 1 && cp~= -1
          errID = 'Error:InvaildValue';
         baseException = MException(errID,msg);
         causeException = MException('Error:InvalidValue','Position flag should be 1 for call, -1 for put!');
         
         baseException = addCause(baseException,causeException);
         throw(baseException);
         
     elseif sigma<0
         errID = 'Error:InvaildValue';
         baseException = MException(errID,msg);
         causeException = MException('Error:InvalidValue','Implied Black volatilities should be positive!');
           
         baseException = addCause(baseException,causeException);
         throw(baseException);
         
     elseif delta<= 0
         errID = 'Error:InvaildValue';
         baseException = MException(errID,msg);
         causeException = MException('Error:InvalidValue','Delta should be absolute value!');
         
         baseException = addCause(baseException,causeException);
         throw(baseException);
         
     end    
end

