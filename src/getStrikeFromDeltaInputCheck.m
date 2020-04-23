function [] = getStrikeFromDeltaInputCheck(fwd, T, cp , sigma , delta)

     if fwd <= 0
         error('Error.Forward spot should be positive.')
         
     elseif T <= 0
         error('Error.Time to expiry should be positive.');
         
     elseif cp ~= 1 && cp~= -1
        error('Error.Position flag should be 1 for call, -1 for put.');
         
     elseif sigma <= 0
        error('Error.Implied Black volatilities should be positive.');
        
     elseif delta <= 0
        error('Error.Delta should be absolute value.');
     end    
     
end

