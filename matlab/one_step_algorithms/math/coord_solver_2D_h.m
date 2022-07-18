function [X, flag, dop, nev, hei_geo] = coord_solver_2D_h(y, posts, X0, h, config)
    min_i = 0;
    min_nev = 1e20;
    min_hei_geo = 0;
    for i = 1:length(h)
        [X(:,i), dop(i), nev(i), flag] = coord_solver2D(y, posts, X0, h(i));
        [b,l,hei] = enu2geodetic(X(1,i),X(2,i),h(i),config.BLHref(1),config.BLHref(2),config.BLHref(3),wgs84Ellipsoid);
%         if hei < 1000 || hei > 7000
        if hei < 500 || hei > 15000   
            flag = 0;
        end
        if (nev(i) < min_nev) && flag
            min_i = i;
            min_nev = nev(i);
            min_hei_geo = hei;
        end
    end
    if min_i == 0
        flag = 0;
        X = 0;
        dop = 0;
        nev = 0;
        hei_geo = 0;
    else
        flag = 1;
        X = [X(1,min_i); X(2,min_i); h(min_i); X(3,min_i)];
        dop = dop(min_i);
        nev = min_nev;
        hei_geo = min_hei_geo;
    end
end



