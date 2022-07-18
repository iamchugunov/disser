function [track] = make_geo_track(X0, V, kurs, h, time_interval, config)
    % X0 = [x0;y0] - m, initial point 2D
    % V m/s constant speed
    % kurs - rad
    % h - geo heigth
    % time_interval sec [t0; tend];
    
    [x0(1,1), x0(2,1), x0(3,1)] = enu2geodetic(X0(1),X0(2),0,config.BLHref(1),config.BLHref(2),config.BLHref(3),wgs84Ellipsoid);
    
    t = time_interval(1):1:time_interval(end);
    
    Vx = V * cos(kurs);
    Vy = V * sin(kurs);
    
    X = [X0;0];
    for i = 2:length(t)
        X(1,i) = X(1,i-1) + Vx * (t(i) - t(i-1));
        X(2,i) = X(2,i-1) + Vy * (t(i) - t(i-1));
    end
    
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
    track.V = V;
    
    
end

