function [track] = make_geo_track_circle(X0, V, R, h, time_interval, config)
    % X0 = [x0;y0] - m, circle center
    % V m/s constant speed
    % R - circle radius
    % h - geo heigth
    % time_interval sec [t0; tend];
    
    [x0(1,1), x0(2,1), x0(3,1)] = enu2geodetic(X0(1),X0(2),0,config.BLHref(1),config.BLHref(2),config.BLHref(3),wgs84Ellipsoid);
    
    t = time_interval(1):1:time_interval(end);
    
    alpha_h = V/R;
    
    alpha = 0;
    for i = 1:length(t)
        X(1,i) = X0(1) + R * cos(alpha);
        X(2,i) = X0(2) + R * sin(alpha);
        alpha = alpha + alpha_h;
    end
    X(3,:) = 0;
    
    track1 = [];
    for i = 1:length(X)
        [track1(1,i), track1(2,i), track1(3,i)] = enu2geodetic(X(1,i),X(2,i),X(3,i),config.BLHref(1),config.BLHref(2),config.BLHref(3),wgs84Ellipsoid);
    end
    
    coords = [];
    for i = 1:length(track1)
        [coords(1,i), coords(2,i), coords(3,i)] = geodetic2enu(track1(1,i),track1(2,i),h,config.BLHref(1),config.BLHref(2),config.BLHref(3),wgs84Ellipsoid);
    end
    
    track.t = t;
    track.coords = coords;
    V = [diff(coords(1,:))./diff(t); diff(coords(2,:))./diff(t); diff(coords(3,:))./diff(t);];
    V(:,end + 1) = V(:,end);
    a = [diff(V(1,:))./diff(t); diff(V(2,:))./diff(t); diff(V(3,:))./diff(t);];
    a(:,end) = a(:,end-1);
    a(:,end + 1) = a(:,end-1);
    track.V = V;
    track.a = a;
    
    
end



