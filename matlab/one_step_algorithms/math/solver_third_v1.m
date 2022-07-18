function [x1, x2] = solver_third_v1(toa, posts, config)
    z1 = 0;
    z2 = 0;
    [x] = solver_analytical_2D_3_posts_h(toa, posts, z1);
        
    x1 = x;
    x2 = x;
    if ~isempty(x)
        if size(x,2) == 1
            x1 = [];
            x2 = [];
            return;
        else
            if norm(x(:,1)) > 500e3 || norm(x(:,2)) > 500e3
                x1 = [];
                x2 = [];
                return;
            end
%             [b1, l1, h1] = enu2geodetic(x(1,1), x(2,1), 0, config.BLHref(1), config.BLHref(2), config.BLHref(3), wgs84Ellipsoid);
%             [b2, l2, h2] = enu2geodetic(x(1,2), x(2,2), 0, config.BLHref(1), config.BLHref(2), config.BLHref(3), wgs84Ellipsoid);
%             [h1 h2]
%             h = 10000;
%             [x0, y0, z0] = geodetic2enu(b1, l1, h, config.BLHref(1), config.BLHref(2), config.BLHref(3), wgs84Ellipsoid);
%             [x] = solver_analytical_2D_3_posts_h(toa, posts, z0);
%             [b1, l1, h1] = enu2geodetic(x(1,1), x(2,1), 0, config.BLHref(1), config.BLHref(2), config.BLHref(3), wgs84Ellipsoid);
%             [b2, l2, h2] = enu2geodetic(x(1,2), x(2,2), 0, config.BLHref(1), config.BLHref(2), config.BLHref(3), wgs84Ellipsoid);
%             [h1 h2]
%             [x0, y0, z0] = geodetic2enu(b2, l2, h, config.BLHref(1), config.BLHref(2), config.BLHref(3), wgs84Ellipsoid);
%             [x] = solver_analytical_2D_3_posts_h(toa, posts, z0);
%             [b1, l1, h1] = enu2geodetic(x(1,1), x(2,1), 0, config.BLHref(1), config.BLHref(2), config.BLHref(3), wgs84Ellipsoid);
%             [b2, l2, h2] = enu2geodetic(x(1,2), x(2,2), 0, config.BLHref(1), config.BLHref(2), config.BLHref(3), wgs84Ellipsoid);
%             [h1 h2]
                for i = 1:10
                    
                    [b1, l1, h1] = enu2geodetic(x1(1,1), x1(2,1), z1, config.BLHref(1), config.BLHref(2), config.BLHref(3), wgs84Ellipsoid);
                    [x0, y0, z1] = geodetic2enu(b1, l1, 10000, config.BLHref(1), config.BLHref(2), config.BLHref(3), wgs84Ellipsoid);
                    [x1] = solver_analytical_2D_3_posts_h(toa, posts, z1);
                    if isempty(x1)
                        x1 = [];
                        x2 = [];
                        return;
                    end
                    
                    
                    [b2, l2, h2] = enu2geodetic(x2(1,2), x2(2,2), z2, config.BLHref(1), config.BLHref(2), config.BLHref(3), wgs84Ellipsoid);
                    [x0, y0, z2] = geodetic2enu(b2, l2, 10000, config.BLHref(1), config.BLHref(2), config.BLHref(3), wgs84Ellipsoid);
                    [x2] = solver_analytical_2D_3_posts_h(toa, posts, z2);
                    if isempty(x2)
                        x1 = [];
                        x2 = [];
                        return;
                    end
                    [h1 h2]
                    
                    
                end
                x1(3,:) = z1;
                x2(3,:) = z2;
        end
    else
        x1 = [];
        x2 = [];
        return;
        
    end
end

