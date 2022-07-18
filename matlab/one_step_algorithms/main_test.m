% создание трассы
[ config ] = Config( );
config.sigma_n_ns = 30;
traj_params.X0 = [250000;-150000];
% traj_params.X0 = [-3000;3000];
traj_params.V = 200;
traj_params.kurs = 2;
traj_params.h_geo = 10000;
traj_params.time_interval = [0 3000];
[track] = make_geo_track(traj_params.X0, traj_params.V, traj_params.kurs, traj_params.h_geo, traj_params.time_interval, config);
show_track(track, config)
%% генерация измерений
[track] = make_measurements_for_track(track, config);
get_rd_from_poits(track.poits)
%% проверка аналитического решения для четверок
X_an1 = [];
t_an1 = [];
k1 = 0;
X_an2 = [];
t_an2 = [];
k2 = 0;
for i = 1:length(track.poits)
    cur_toa = track.poits(i).ToA * config.c_ns;
    posts = config.posts;
    [x] = solver_analytical_3D_4_posts(cur_toa, posts);
    if ~isempty(x)
        if size(x,2) == 1
            k1 = k1 + 1;
            X_an1(:,k1) = x(:,1);
            t_an1(k1) = track.poits(i).Frame;
        else
            two_solutions_check(x, cur_toa, posts);
            k1 = k1 + 1;
            X_an1(:,k1) = x(:,1);
            t_an1(k1) = track.poits(i).Frame;
            k2 = k2 + 1;
            X_an2(:,k2) = x(:,2);
            t_an2(k2) = track.poits(i).Frame;
        end
    end
end
%% проверка МНК по четверкам
X_mnk1 = [];
t_mnk1 = [];
k1 = 0;
X_mnk2 = [];
t_mnk2 = [];
k2 = 0;
err2  = [];
X_mnk3 = [];
t_mnk3 = [];
k3 = 0;
for i = 1:length(track.poits)
    [x, flag, dop, nev] = NavSolverRDinvh(track.poits(i).rd, config.posts, [1000;1000;track.coords(3,i)*0], 0);
    if flag
        k1 = k1 + 1;
        X_mnk1(:,k1) = x;
        t_mnk1(k1) = track.poits(i).Frame;
    else
        [x, flag, dop, nev] = initial_test2(track.poits(i), config);
    end
    [x, flag, dop, nev] = NavSolverRDinvh(track.poits(i).rd, config.posts, [1000;1000;-10000], 0);
    if flag
        k2 = k2 + 1;
        X_mnk2(:,k2) = x;
        t_mnk2(k2) = track.poits(i).Frame;
        err2(:,k2) = x - track.poits(i).true_coords([1 3 5]);
    else
        [x, flag, dop, nev] = initial_test2(track.poits(i), config);
    end
    [x, flag, dop, nev] = NavSolverRDinvh(track.poits(i).rd, config.posts, [1000;1000;10000], 0);
    if flag
        k3 = k3 + 1;
        X_mnk3(:,k3) = x;
        t_mnk3(k3) = track.poits(i).Frame;
    end
end
%% проверка МНК по четверкам
X_s = [];
t_s = [];
k1 = 0;
NEV = [];
err_geo = [];
for i = 1:length(track.poits)
    if track.poits(i).count < 4
        continue
    end
%     [x, flag, dop, nev] = NavSolverRDgeo_h_4_1(track.poits(i).rd, config.posts, [1000;1000], config, 10000);
    [x, flag, dop, nev] = NavSolverRDgeo_h_4_1(track.poits(i).rd, config.posts, [1000;1000], config, 10000);
    NEV(i) = nev;
    if flag
        k1 = k1 + 1;
        X_s(:,k1) = x;
        t_s(k1) = track.poits(i).Frame;
        err_geo(:,k1) = x - track.poits(i).true_coords([1 3 5]);
    else
        a = 5;
    end
end
%% проверка МНК по четверкам
X_s1 = [];
t_s1 = [];
k1 = 0;
NEV = [];
for i = 1:length(track.poits)
    [x, dop, nev, flag] = coord_solver3D(track.poits(i).ToA * config.c_ns, config.posts, [1000;1000;-10000;max(track.poits(i).ToA) * config.c_ns]);
    NEV(i) = nev;
    if flag
        k1 = k1 + 1;
        X_s1(:,k1) = x;
        t_s1(k1) = track.poits(i).Frame;
    else
        a = 5;
    end
end
%% проверка аналитики по тройкам
nums = [1 2 4];
X_an34_1 = [];
t_an34_1 = [];
k1 = 0;
X_an34_2 = [];
t_an34_2 = [];
k2 = 0;
for i = 1:length(track.poits)
    [x] = solver_analytical_2D_3_posts(track.poits(i).ToA([1 2 4]) * config.c_ns, config.posts(:,[1 2 4]));
%     [x] = solver_analytical_2D_3_posts_h(track.poits(i).ToA([1 2 4]) * config.c_ns, config.posts(:,[1 2 4]), track.coords(3,i));
    if ~isempty(x)
        if size(x,2) == 1
            k1 = k1 + 1;
            X_an34_1(:,k1) = [x(:,1);0];
            t_an34_1(k1) = track.poits(i).Frame;
            [b1, l1, h1] = enu2geodetic(x(1,1), x(2,1), 0, config.BLHref(1), config.BLHref(2), config.BLHref(3), wgs84Ellipsoid);
            X_an34_1(3,k1) = h1;
        else
            k1 = k1 + 1;
            X_an34_1(:,k1) = [x(:,1);0];
            t_an34_1(k1) = track.poits(i).Frame;
            [b1, l1, h1] = enu2geodetic(x(1,1), x(2,1), 0, config.BLHref(1), config.BLHref(2), config.BLHref(3), wgs84Ellipsoid);
            X_an34_1(3,k1) = h1;
            k2 = k2 + 1;
            X_an34_2(:,k2) = [x(:,2);0];
            t_an34_2(k2) = track.poits(i).Frame;
            [b1, l1, h1] = enu2geodetic(x(1,2), x(2,2), 0, config.BLHref(1), config.BLHref(2), config.BLHref(3), wgs84Ellipsoid);
            X_an34_2(3,k1) = h1;
        end
    end
end
%% проверка МНК по тройкам
X_3 = [];
t_3 = [];
k1 = 0;
for i = 1:length(track.poits)
    cur_rd = track.poits(i).rd;
    cur_rd(1:3) = 0;
    [x, flag, dop, nev] = NavSolverRDinvh(cur_rd, config.posts, [1000;0;0]);
    if flag
        k1 = k1 + 1;
        X_3(:,k1) = x;
        t_3(k1) = track.poits(i).Frame;
    else
        a = 5;
    end
end
%% тройка аналитика + МНК
k = 0;
X_3 = [];
for i = 1:length(track.poits)
    cur_toa = track.poits(i).ToA * config.c_ns;
    posts = config.posts;
    rd = track.poits(i).rd;
    posts(:,4) = [];
    cur_toa(4) = [];
    rd(1:3) = 0;
    
    [x] = solver_analytical_2D_3_posts(cur_toa, posts);
    
    if ~isempty(x)
        if size(x,2) == 1
%             [X1, flag, dop, nev] = NavSolverRDinvh(y, config.posts, [x; 10000], 0);
            [X1, dop, nev, flag] = coord_solver3D(cur_toa, posts, [x; 10000;0]);
            if flag
                k = k + 1;
                X_3(:,k) = X1;
            end
        else
            [X1, dop, nev, flag] = coord_solver3D(cur_toa, posts, [x(:,1); 10000;0]);
            [X2, dop, nev, flag] = coord_solver3D(cur_toa, posts, [x(:,2); 10000;0]);
        end
    end
end
%% тройки аналитика проверка высоты
k1 = 0;
k2 = 0;
h = 10000;
x_11 = [];
x_12 = [];
x_21 = [];
x_22 = [];
k = 0;
x4 = [];
for i = 1:length(track.poits)
    cur_toa = track.poits(i).ToA * config.c_ns;
    posts = config.posts;
    rd = track.poits(i).rd;
    posts(:,1) = [];
    cur_toa(1) = [];
    rd(1:3) = 0;
%     [x] = solver_analytical_2D_3_posts_h(cur_toa, posts, h);
    [x] = solver_analytical_2D_3_posts_h(cur_toa, posts, track.coords(3,i));
    if i == 1146
       a = 0; 
    end
%     [x1, x2] = solver_third_v1(cur_toa, posts, config);
%     if x1
%     k = k + 1;
%     x_11(:,k) = x1(:,1);
%     x_12(:,k) = x1(:,2);
%     x_21(:,k) = x2(:,1);
%     x_22(:,k) = x2(:,2);
%     end
    x3 = solver_third_v2(cur_toa, posts, config);
    x4 = [x4 x3];
%     plot3(x3(1,:),x3(2,:),x3(3,:),'v')
    
%     text(x3(1,:),x3(2,:),x3(3,:),["1" "2" "3" "4"])
%     if ~isempty(x)
%         if size(x,2) == 1
%             k1 = k1 + 1;
%             X_an34_1(:,k1) = [x(:,1);0;0];
%             t_an34_1(k1) = track.poits(i).Frame;
%             [b1, l1, h1] = enu2geodetic(x(1,1), x(2,1), 0, config.BLHref(1), config.BLHref(2), config.BLHref(3), wgs84Ellipsoid);
%             X_an34_1(3,k1) = h1;
%             [b1, l1, h1] = enu2geodetic(x(1,1), x(2,1), h, config.BLHref(1), config.BLHref(2), config.BLHref(3), wgs84Ellipsoid);
%             X_an34_1(4,k1) = h1;
%         else
%             x(3,:) = h;
%             two_solutions_check(x, cur_toa, posts);
%             k1 = k1 + 1;
%             X_an34_1(:,k1) = [x(:,1);0;0];
%             t_an34_1(k1) = track.poits(i).Frame;
%             [b1, l1, h1] = enu2geodetic(x(1,1), x(2,1), 0, config.BLHref(1), config.BLHref(2), config.BLHref(3), wgs84Ellipsoid);
%             X_an34_1(3,k1) = h1;
%             [b1, l1, h1] = enu2geodetic(x(1,1), x(2,1), h, config.BLHref(1), config.BLHref(2), config.BLHref(3), wgs84Ellipsoid);
%             X_an34_1(4,k1) = h1;
%             k2 = k2 + 1;
%             X_an34_2(:,k2) = [x(:,2);0;0];
%             t_an34_2(k2) = track.poits(i).Frame;
%             [b1, l1, h1] = enu2geodetic(x(1,2), x(2,2), 0, config.BLHref(1), config.BLHref(2), config.BLHref(3), wgs84Ellipsoid);
%             X_an34_2(3,k1) = h1;
%             [b1, l1, h1] = enu2geodetic(x(1,2), x(2,2), h, config.BLHref(1), config.BLHref(2), config.BLHref(3), wgs84Ellipsoid);
%             X_an34_2(4,k2) = h1;
%         end
%     end
end
% plot(posts(1,:),posts(2,:),'v')
% hold on
% show_hyperbols(cur_toa, posts, track.coords(3,1), 1)
% hold on
% plot(track.coords(1,1),track.coords(2,1),'o')
% plot(X_an34_1(1,:),X_an34_1(2,:),'.')
% plot(X_an34_2(1,:),X_an34_2(2,:),'.')
% figure
% plot(X_an34_1(3,:),'.-r')
% hold on
% plot(X_an34_2(3,:),'.-b')
% plot(X_an34_1(4,:),'o-r')
% plot(X_an34_2(4,:),'o-b')