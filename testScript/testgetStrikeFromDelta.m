function testgetStrikeFromDelta()
    addpath(genpath([pwd '\src\']));
    fwd = 1.5117;
    T = 0.0192;
    cp = 1;
    sigma = 0.2020;
    delta = 0.1;

    display('Input Check Test');
    testCase('Test positive forward spot', @getStrikeFromDelta,-2,T,cp,sigma,delta);
    testCase('Test positive T', @getStrikeFromDelta,fwd,-1,cp,sigma,delta);
    testCase('Test call put flag',@getStrikeFromDelta,fwd,T,0,sigma,delta);
    testCase('Test positive Implied Volatility',@getStrikeFromDelta,fwd,T,cp,-0.22,delta);
    testCase('Test absolute delta',@getStrikeFromDelta,fwd,T,cp,sigma,-0.1);

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