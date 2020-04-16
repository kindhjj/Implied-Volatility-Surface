[spot, lag, days, domdfs, fordfs, vols, cps, deltas] = getMarket();

tau = lag / 365; % spot rule lag

% time to maturities in years
Ts = days / 365;

% construct market objects
domCurve = makeDepoCurve(Ts, domdfs);
forCurve = makeDepoCurve(Ts, fordfs);
fwdCurve = makeFwdCurve(domCurve, forCurve, spot, tau);

% pls change these params
T=5;
v=3;
% plotting
smile = makeSmile(fwdCurve, T, cps, deltas, vols(v,:));

X=zeros(Nv,M);
Y=zeros(Nv,M);
K=zeros(Nv,1);
fwd= getFwdSpot(fwdCurve, T);
for n = 1:Nv
   K(n) = getStrikeFromDelta(fwd, T, cps(n), vols(v), deltas(n));
end
X(1,:)=linspace(0.0001,K(1),M);
Y(1,:)=getSmileVol(smile, X(1,:));
for n=1:Nv-1
    X(n+1,:)=linspace(K(n),K(n+1),M);
    Y(n+1,:)=getSmileVol(smile, X(n+1,:));
end
X(Nv+1,:)=linspace(K(Nv),max(K(Nv)+1,3),M);
Y(Nv+1,:)=getSmileVol(smile, X(Nv+1,:));

% Graph of cubic spline (N-1 cubic curves)
hold on;
k=1;
for n=1:Nv+1
    if k==12     %Colors repeat after every multiple of 11 colors
        k=1;
    end
    plot(X(n,:),Y(n,:),'LineWidth',2);
    k=k+1;
end
plot(K,getSmileVol(smile, K),'o','MarkerEdgeColor','k','MarkerFaceColor','r','MarkerSize',8);
text(4,65,'Cubic Spline','FontName','Times New Roman','FontSize',18,'Color',[1 1 1]);
set(gca,'Color',[.3,0.5,.7],'FontSize',12); % graph's background color
box on;
hold off;