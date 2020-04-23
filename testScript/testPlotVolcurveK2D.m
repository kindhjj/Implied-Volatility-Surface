function testPlotVolcurveK2D()
% Author = 'Luo Jiarong'
% Plot Smile Curve in Q2.5
    [spot, lag, days, domdfs, fordfs, vols, cps, deltas] = getMarket();

    tau = lag / 365; % spot rule lag

    % Time to maturities in years
    Ts = days / 365;

    % Construct market objects
    domCurve = makeDepoCurve(Ts, domdfs);
    forCurve = makeDepoCurve(Ts, fordfs);
    fwdCurve = makeFwdCurve(domCurve, forCurve, spot, tau);

    % Nv: # of strikes we have in interpolation
    % M: # of interpolation in each interval
    % T: Time to expiry of the option
    % v: Row index in vols, when T = 2, v = 10 (last row)
    Nv=5;
    M=50;
    T=2;
    v=10;

    % Calculate smile curve
    smile = makeSmile(fwdCurve, T, cps, deltas, vols(v,:));

    X=zeros(Nv + 1,M);
    Y=zeros(Nv + 1,M);
    K=zeros(Nv,1);
    fwd= getFwdSpot(fwdCurve, T);

    for n = 1:Nv
       K(n) = getStrikeFromDelta(fwd, T, cps(n), vols(v), deltas(n));
    end

    X(1,:) = linspace(0.0001,K(1),M);
    Y(1,:) = getSmileVol(smile, X(1,:));

    for n=1:Nv-1
        X(n+1,:)=linspace(K(n),K(n+1),M);
        Y(n+1,:)=getSmileVol(smile, X(n+1,:));
    end

    X(Nv+1,:)=linspace(K(Nv),max(K(Nv)+1,3),M);
    Y(Nv+1,:)=getSmileVol(smile, X(Nv+1,:));

    % Graph of cubic spline
    hold on;
    for n=1:Nv+1
        plot(X(n,:),Y(n,:),'LineWidth',2);
    end
    plot(K,getSmileVol(smile, K),'o','MarkerEdgeColor','k','MarkerFaceColor','r','MarkerSize',8);
    xlabel('Strike');
    ylabel('Vol');
    set(gca,'Color',[.3,0.5,.7],'FontSize',12); % Graph's background color
    box on;
    hold off;
end