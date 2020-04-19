function testPdf(eps)
h = 0.0001;
x = 0.0002 : h : 10;
y = getPdf(volSurface, T, x);
u = h * trapz(y);
if abs(u-1) > eps
    error('The integral of the pdf function is not 1')
end
end
    