function [x4] = solver_third_v2(toa, posts, config) 
    
    z = 0;
    h = 10000;
    
%     figure()
%     plot(posts(1,:),posts(2,:),'v')
%     axis([-400e3 400e3 -400e3 400e3])
%     hold on
%     show_hyperbols(toa, posts, z, 1)
    
    [x] = solver_analytical_2D_3_posts_h(toa, posts, z);
    x4 = [];
    if ~isempty(x)
        x(3,:) = z;
        for i = 1:size(x,2)
            if check_for_rd(x(:,i), toa, posts)
%                 plot(x(1,i),x(2,i),'o')
%                 text(x(1,i),x(2,i),num2str(i))
                [b1, l1, h1] = enu2geodetic(x(1,i), x(2,i), 0, config.BLHref(1), config.BLHref(2), config.BLHref(3), wgs84Ellipsoid);
                [x0, y0, z0] = geodetic2enu(b1, l1, h, config.BLHref(1), config.BLHref(2), config.BLHref(3), wgs84Ellipsoid);
                [x_] = solver_analytical_2D_3_posts_h(toa, posts, z0);
                if ~isempty(x_)
                    x_(3,:) = z0;
                    for j = 1:size(x_,2)
                        [b1, l1, h1] = enu2geodetic(x_(1,j), x_(2,j), x_(3,j), config.BLHref(1), config.BLHref(2), config.BLHref(3), wgs84Ellipsoid);
                        if abs(h1 - h) < 2000
                            x4 = [x4 x_(:,j)];
                        end
                    end
                end
                
%                 plot(x_(1,:),x_(2,:),'x')
%                 x4 = [x4 x_];
            end
        end
    end
    Rmax = 0;
    n_max = 0;
    if ~isempty(x4)
        for i = 1:size(x4,2)
            if norm(x4(1:2,i)) > Rmax
                n_max = i;
                Rmax = norm(x4(1:2,i));
            end
        end
        x4 = x4(:,n_max);
    end
    x4
    return    
    check_for_rd(x(:,1), toa, posts);
    check_for_rd(x(:,2), toa, posts);
    [out] = two_solutions_check(x, toa, posts);
    
    figure()
    plot(posts(1,:),posts(2,:),'v')
    axis([-400e3 400e3 -400e3 400e3])
    hold on
    show_hyperbols(toa, posts, z, 1)
    plot(x(1,:),x(2,:),'x')
    text(x(1,:),x(2,:),["1" "2"])
    close
        
%     x1 = x;
%     x2 = x;
%     if ~isempty(x)
%         if size(x,2) == 1
%             x1 = [];
%             x2 = [];
%             return;
%         else
%             if norm(x(:,1)) > 500e3 || norm(x(:,2)) > 500e3
%                 x1 = [];
%                 x2 = [];
%                 return;
%             end
% %             [b1, l1, h1] = enu2geodetic(x(1,1), x(2,1), 0, config.BLHref(1), config.BLHref(2), config.BLHref(3), wgs84Ellipsoid);
% %             [b2, l2, h2] = enu2geodetic(x(1,2), x(2,2), 0, config.BLHref(1), config.BLHref(2), config.BLHref(3), wgs84Ellipsoid);
% %             [h1 h2]
% %             h = 10000;
% %             [x0, y0, z0] = geodetic2enu(b1, l1, h, config.BLHref(1), config.BLHref(2), config.BLHref(3), wgs84Ellipsoid);
% %             [x] = solver_analytical_2D_3_posts_h(toa, posts, z0);
% %             [b1, l1, h1] = enu2geodetic(x(1,1), x(2,1), 0, config.BLHref(1), config.BLHref(2), config.BLHref(3), wgs84Ellipsoid);
% %             [b2, l2, h2] = enu2geodetic(x(1,2), x(2,2), 0, config.BLHref(1), config.BLHref(2), config.BLHref(3), wgs84Ellipsoid);
% %             [h1 h2]
% %             [x0, y0, z0] = geodetic2enu(b2, l2, h, config.BLHref(1), config.BLHref(2), config.BLHref(3), wgs84Ellipsoid);
% %             [x] = solver_analytical_2D_3_posts_h(toa, posts, z0);
% %             [b1, l1, h1] = enu2geodetic(x(1,1), x(2,1), 0, config.BLHref(1), config.BLHref(2), config.BLHref(3), wgs84Ellipsoid);
% %             [b2, l2, h2] = enu2geodetic(x(1,2), x(2,2), 0, config.BLHref(1), config.BLHref(2), config.BLHref(3), wgs84Ellipsoid);
% %             [h1 h2]
%                 for i = 1:10
%                     
%                     [b1, l1, h1] = enu2geodetic(x1(1,1), x1(2,1), z1, config.BLHref(1), config.BLHref(2), config.BLHref(3), wgs84Ellipsoid);
%                     [x0, y0, z1] = geodetic2enu(b1, l1, 10000, config.BLHref(1), config.BLHref(2), config.BLHref(3), wgs84Ellipsoid);
%                     [x1] = solver_analytical_2D_3_posts_h(toa, posts, z1);
%                     if isempty(x1)
%                         x1 = [];
%                         x2 = [];
%                         return;
%                     end
%                     
%                     
%                     [b2, l2, h2] = enu2geodetic(x2(1,2), x2(2,2), z2, config.BLHref(1), config.BLHref(2), config.BLHref(3), wgs84Ellipsoid);
%                     [x0, y0, z2] = geodetic2enu(b2, l2, 10000, config.BLHref(1), config.BLHref(2), config.BLHref(3), wgs84Ellipsoid);
%                     [x2] = solver_analytical_2D_3_posts_h(toa, posts, z2);
%                     if isempty(x2)
%                         x1 = [];
%                         x2 = [];
%                         return;
%                     end
%                     [h1 h2]
%                     
%                     
%                 end
%                 x1(3,:) = z1;
%                 x2(3,:) = z2;
%         end
%     else
%         x1 = [];
%         x2 = [];
%         return;
%         
%     end
end



