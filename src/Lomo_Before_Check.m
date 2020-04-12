% Check inputs before calculation
function [] = Lomo_Before_Check(a,b,msg)
%         illegal value
    if (sum(a <= 0) > 0) || (sum(b <= 0) > 0)
        errID = 'Error:BadInput';
        baseException = MException(errID,msg);
        
        causeException = MException('Error:BadValue','inputs should be positive!');
        baseException = addCause(baseException,causeException);
        throw(baseException);

%         empty input
    elseif (length(a) * length(b)) == 0
        errID = 'Error:BadInput';
        baseException = MException(errID,msg);
        
        causeException = MException('Error:BadSize','inputs should not empty!');
        baseException = addCause(baseException,causeException);
        throw(baseException);
        
    end
end