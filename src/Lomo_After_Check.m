% Check inputs when there is any errors in calculation
function [] = Lomo_After_Check(a,b,msg)
    errID = 'Error:BadInput';
    baseException = MException(errID,msg);
    
%         shape not match
    if sum(size(a) ~= size(b)) > 0
        causeException = MException('Error:BadSize','inputs should have the same size!');
        baseException = addCause(baseException,causeException);
        throw(baseException);
        
%         unknown error
    else
        causeException = MException('Error:Unknown','dk');
        baseException = addCause(baseException,causeException);
        throw(baseException);
    end
end