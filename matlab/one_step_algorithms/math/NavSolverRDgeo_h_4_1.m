function [X, flag, dop, nev] = NavSolverRDgeo_h_4_1(rd, posts, X0, config, h)
    X = [];
    flag = 0;
    dop = [];
    nev = [];
    
    geo = [];
    enu = [];
    k = 0;
    [X1, flag1, dop1, nev1] = NavSolverRDinvh(rd, posts, [X0; -10000], 0);
    X = X1;
    dop = dop1;
    nev = nev1;
    if flag1
        for i = 1:3
            k = k + 1;
            [geo(1,k), geo(2,k), geo(3,k)] = enu2geodetic(X1(1), X1(2), X1(3), config.BLHref(1), config.BLHref(2), config.BLHref(3), wgs84Ellipsoid);
            enu(:,k) = X1;
            [flag, X1, dop1, nev1] = correct_h_for_enu_point(rd, X1, h, config);
            if ~flag
                flag = flag1;
                break
            end
        end
        X = X1;
        dop = dop1;
        nev = nev1;
%         figure
%         plot(geo(3,:))
%         hold on
%         plot(enu(3,:))
%         close
    end
    
end

