function [X, flag, dop, nev] = NavSolverRDgeo_h_4(rd, posts, X0, config, h)
    X = [];
    flag = 0;
    dop = [];
    nev = [];
    [X1, flag1, dop, nev] = NavSolverRDinvh(rd, posts, [X0; -10000], 0);
    if flag1
    [b1, l1, h1] = enu2geodetic(X1(1,end), X1(2,end), 0, config.BLHref(1), config.BLHref(2), config.BLHref(3), wgs84Ellipsoid);
    
  [x0, y0, z0] = geodetic2enu(b1, l1, h, config.BLHref(1), config.BLHref(2), config.BLHref(3), wgs84Ellipsoid);
%   [X, flag, dop, nev] = NavSolverRDinvh(rd, posts, [x0;y0;z0], 0);
%   [X, flag, dop, nev] = NavSolverRDinv(rd, posts, [x0;y0], z0);
%   X(3) = z0;
%   [b2, l2, h2] = enu2geodetic(X1(1,end), X1(2,end), X1(3,end), config.BLHref(1), config.BLHref(2), config.BLHref(3), wgs84Ellipsoid);
%   if flag
%       [b1 b2; l1 l2; h h2]
%   end
                  X = [x0;y0;z0];
                flag = 1;
    end
%     if flag1
%         [b1, l1, h1] = enu2geodetic(X1(1,end), X1(2,end), X1(3,end), config.BLHref(1), config.BLHref(2), config.BLHref(3), wgs84Ellipsoid);
%         if nargin == 4
%             h = 3000:1000:13000;
%         end
%         X2 = [];
%         nev = [];
%         for j = 1:length(h)
%             [x0, y0, z0] = geodetic2enu(b1, l1, h(j), config.BLHref(1), config.BLHref(2), config.BLHref(3), wgs84Ellipsoid);
%             [X1, dop1, nev1, flag2] = NavSolverRDinv(rd, posts, X0, z0);
%             if flag2
%                 X2(:,j) = X1;
%                 nev(j) = nev1;
%                 dop(j) = dop1;
%                 flag = 1;
%             else
%                 nev(j) = 100000000;
%             end
%         end
%         if flag
%             [~, n] = min(nev);
%             X = X2(:,n);
%             X(3) = z0;
%             nev = nev(n);
%             dop = dop(n);
%         end
%     else
%         return
%     end
    
    
end

