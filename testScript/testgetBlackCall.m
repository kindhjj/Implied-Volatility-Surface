function testgetBlackCall()
    addpath(genpath([pwd '\src\']));

    fwd = 50;
    T = 1;
    Ks = [48;52];
    Vs = [0.22;0.3];
    
    display('Input Check Test');
    testCase('Test forward spot', @getBlackCall,-2,T,Ks,Vs);
    testCase('Test non-negative T', @getBlackCall,fwd,-1,Ks,Vs);
    testCase('Test dimension of Ks and Vs',@getBlackCall,fwd,T,[48],Vs);
    testCase('Test non-negative K',@getBlackCall,fwd,T,[-2;52],Vs);
    testCase('Test positive Implied Volatility',@getBlackCall,fwd,T,Ks,[-0.22;0.22]);
    
end

function testCase(msg, f, varargin)
    try
        disp(msg)
        f(varargin{:});
        warning('Test failed!')
    catch e
        fprintf('%s\n\n',e.message)
    end
end