function [track] = make_geo_track_v2(X0, V, kurs, h, time_interval, config)
    
    t = time_interval(1):1:time_interval(end);
    
    Vx = V * cos(kurs);
    Vy = V * sin(kurs);
    
    X = [X0;h_geo_calc(X0(1),X0(2),h)];
    for i = 2:length(t)
        X(1,i) = X(1,i-1) + Vx * (t(i) - t(i-1));
        X(2,i) = X(2,i-1) + Vy * (t(i) - t(i-1));
        X(3,i) = h_geo_calc(X(1,i),X(2,i),h);
    end
    
    track.t = t;
    track.coords = X;
    coords = X;
    V = [diff(coords(1,:))./diff(t); diff(coords(2,:))./diff(t); diff(coords(3,:))./diff(t);];
    V(:,end + 1) = V(:,end);
    a = [diff(V(1,:))./diff(t); diff(V(2,:))./diff(t); diff(V(3,:))./diff(t);];
    a(:,end) = a(:,end-1);
    a(:,end + 1) = a(:,end-1);
    track.V = V;
    track.a = a;
    
end

function z = h_geo_calc(x,y,h)
    Rz = 6371e3;
    z = -Rz + sqrt((Rz + h)^2 - (x^2 + y^2));
end

