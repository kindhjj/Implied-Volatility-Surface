[spot, lag, days, domdfs, fordfs, vols, cps, deltas] = getMarket();

tau = lag / 365; % spot rule lag

% time to maturities in years
Ts = days / 365;

% construct market objects
domCurve = makeDepoCurve(Ts, domdfs);
forCurve = makeDepoCurve(Ts, fordfs);
fwdCurve = makeFwdCurve(domCurve, forCurve, spot, tau);

% X=T,Y=K
M=50;
Nt=10;
Nv=5;

X_f=zeros((Nt-1)*M,Nv-1,M);

K=zeros(Nv,1);

volcurve=makeVolSurface(fwdCurve ,Ts , cps , deltas , vols);



X=zeros(Nt*M,1);
Y=zeros(Nv*M,1);
X(1:M)=linspace(0.001,Ts(1),M);
for nt=1:Nt-1
    X(nt*M+1:(nt+1)*M)=linspace(Ts(nt),Ts(nt+1),M);
end

Y(1:M)=linspace(0.001,0.5,M);
for nv=1:Nv-1
    Y(nv*M+1:(nv+1)*M)=linspace(0.5*nv,0.5*(nv+1),M);
end

[xx,yy]=meshgrid(X,Y);
Z=zeros(size(xx));
for c=1:size(xx,2)
    [Z(:,c), ~]=getVol(volcurve,xx(1,c),yy(:,c));
end

mesh(xx,yy,Z);

