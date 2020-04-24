classdef InputChecking
    %InputChecking Class to check inputs
    
    methods(Static)
        
        function checkfwd(fwd)
            if  fwd <= 0
                error('Error: Forward spot should be positive!');
            end
            if length(fwd) > 1
                error('Error: Forward spot length should be no larger than 1.');
            end
        end
        
        function checkT(T)
            if length(T) > 1
                error('Error: Time to expiry length should be no larger than 1.');
            end
            if T < 0
                error('Error: Time to expiry should be non-negative!');
            end
        end
        
        function checkKs(Ks)
            if any(Ks <= 0)
                error('Error: Strike Price should be positive!');
            end
        end
        
        function checkVolsVec(vols)
            if any(vols < 0)
                error('Error: vol smaller than 0.');
            end
        end
        
        function checkKVolsDim(Ks, Vols)
            InputChecking.checkKs(Ks);
            InputChecking.checkVolsVec(Vols);
            if length(Ks) ~= length(Vols)
                error('Error: Length of strike price and volatlites should be the same!');
            end
        end
        
        function checkMoneyCurve(curve)
            if ~all(isfield(curve,{'domCurve', 'forCurve', 'X0', 'tau'}))
                error('Error. curve input error: the struct is not complete.') 
            elseif curve.X0 < 0
                error('Error. curve.X0 should not be negative.')
            elseif curve.tau < 0
                error('Error. curve.tau should not be negative.')
            end
            InputChecking.checkIntCurve(curve.domCurve);
            InputChecking.checkIntCurve(curve.forCurve);
        end
        
        function checkcp(cp)
            if length(cp) > 1
                error('Error: cp length should be no larger than 1.');
            elseif cp ~= 1 && cp ~= -1
                error('Error: Position flag should be 1 for call, -1 for put!');
            end
        end
        
        function checkvol(vol)
            if length(vol) > 1
                error('Error: vol length should be no larger than 1.');
            elseif vol < 0
                error('Error: Vol should be positive!');
            end
        end
        
        function checkdelta(delta)
            if length(delta) > 1
                error('Error: vol length should be no larger than 1.');
            elseif delta < 0
                error('Error: Delta should be absolute value!');
            end
        end
        
        function checkvolsurface(volSurface)
            if ~all(isfield(volSurface, {'spots', 'fwdCurve', 'Ts', 'slopes', 'smiles'}))
                error('Error. volSurface input error: the struct is not complete.');
            end
        end
        
        function checkTvolsurface(T, volSurface)
            InputChecking.checkvolsurface(volSurface);
            if T < 0 || T > volSurface.Ts(end)
                error('Error. Invalid T value.');
            end
        end
        
        function checkTs(Ts)
            if (size(Ts, 2) > 1)
                error('Error. Ts not a column vector.');
            end
            if any(Ts <= 0)
                error('Error. Ts not larger than 0.');
            end
        end
        
        function checkcps(cps)
            if (size(cps, 1) > 1) || (size(deltas, 1) > 1)
                error('Error. cps or deltas not a row vector.');
            end
        end
        
        function checkcpsdeltasTsvols(cps, deltas, vols, Ts)
            if any(size(cps) ~= size(deltas)) || (size(cps, 2) ~= size(vols, 2)) || (size(vols, 1) ~= size(Ts, 1))
                error('Error. Dimensions of inputs not matched.');
            end
            if any(Ts <= 0)
                error('Error. Ts not larger than 0.');
            end
            if ~all(ismember(cps, [-1 1]))
                error('Error. cps not equal 1 or -1.');
            end
            if any(deltas <= 0 | deltas >= 1)
                error('Error. deltas not between 0 and 1.');
            end
            if any(any(vols < 0))
                error('Error. vol smaller than 0.');
            end
            if any(size(cps) ~= size(deltas)) || (size(cps, 2) ~= size(vols, 2)) || (size(vols, 1) ~= size(Ts, 1))
                error('Error. Dimensions of inputs not matched.');
            end
        end
        
        function checkDepoCurve(ts, dfs)
            if length(ts) ~= length(dfs)
                error('Error. dimension not match.');
            elseif any(ts <= 0) || any(dfs <= 0)
                error('Error. input should be positive.');
            elseif (length(ts) * length(dfs)) == 0
                error('Error. empty input.');
            end
        end
        
        function checkIntCurve(curve)
            if ~all(isfield(curve, {'ts', 'ir'}))
                error('Error. curve input error: the struct is not complete.');
            elseif length(curve.ts) ~= length(curve.ir)
                error('Error. curve dimension not match.');
            elseif (length(curve.ts) * length(curve.ir)) == 0
                error('Error. empty curve.')
            elseif any(curve.ts <= 0)
                error('Error. curve.ts should be positive.');
            end
        end
        
        function checkFwdCurve(domCurve, forCurve, spot, tau)

            InputChecking.checkIntCurve(domCurve);
            InputChecking.checkIntCurve(forCurve);
            
            if length(domCurve.ts) ~= length(forCurve.ts)
                error('Error. domCurve and forCurve dimension not match.');
            elseif spot <= 0
                error('Error. spot should be positive.');
            elseif tau < 0
                error('Error. tau should not be negative');
            end
        end
        
        function checkFun(payoffFun)
            if ~isa(payoffFun,'function_handle')
                error('Error. Invalid payoff function.');
            end
        end
        
        function checkInts(ints)
            if length(ints) < 2
                error('Error. The number of elements in integration interval is smaller than 2.');
            end
            if ~all(ints >= 0)
                error('Error. Invalid integration interval.');
            end
        end
        
        function checkVolSmile(smile)
            if ~all(isfield(smile, {'pp', 'BR', 'BL', 'AR', 'AL'}))
                error('Error. vol curve input error: the struct is not complete.');
            elseif ~all(isfield(smile.pp, {'form', 'breaks', 'coefs', 'pieces', 'order', 'dim'}))
                error('Error. vol curve input error: the struct is not complete.');
            end
        end
        
        function checkDeltasVolsdim(deltas, vols)
            if length(deltas) ~= length(vols)
                error('Error. Size of deltas and Vols must be the same');
            end
        end
        
        function checkNodes(N)
            if N < 4
                error('Error. Number of Nodes must not be less than 4');
            end
        end
        
    end
end

