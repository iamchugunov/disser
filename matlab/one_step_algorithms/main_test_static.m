% создание трассы
[ config ] = Config( );
config.sigma_n_ns = 30;
X = -400e3:50e3:400e3;
Y = X;
tracks = struct("t",[],"coords",[],"V",[],"poits",[],'a',[]);
k = 0;
for i = 1:length(X)
    for j = 1:length(Y)
        traj_params.X0 = [X(i);Y(j)];
        traj_params.V = 0;
        traj_params.kurs = 0;
        traj_params.h_geo = 10000;
        traj_params.time_interval = [0 100];
        k = k + 1;
        track = make_geo_track(traj_params.X0, traj_params.V, traj_params.kurs, traj_params.h_geo, traj_params.time_interval, config);
        track = make_measurements_for_track(track, config);
        tracks(k) = track;
    end
end
for i = 1:k
    show_track(tracks(i), config)
end
%% проверка аналитического решения для четверок
X_an1 = {};
t_an1 = {};
k1 = 0;
X_an2 = {};
t_an2 = {};
k2 = 0;
for j = 1:length(tracks)
    k1 = 0;
    k2 = 0;
    for i = 1:length(tracks(j).poits)
        [x] = solver_analytical_3D_4_posts(tracks(j).poits(i).ToA * config.c_ns, config.posts);
        if ~isempty(x)
            if size(x,2) == 1
                k1 = k1 + 1;
                X_an1{j}(:,k1) = x(:,1);
                t_an1{j}(k1) = tracks(j).poits(i).Frame;
            else
                k1 = k1 + 1;
                X_an1{j}(:,k1) = x(:,1);
                t_an1{j}(k1) = tracks(j).poits(i).Frame;
                k2 = k2 + 1;
                X_an2{j}(:,k2) = x(:,2);
                t_an2{j}(k2) = tracks(j).poits(i).Frame;
            end
        end
    end
end
%% проверка МНК по четверкам
X_mnk1 = {};
t_mnk1 = {};
k1 = 0;
X_mnk2 = {};
t_mnk2 = {};
k2 = 0;
X_mnk3 = {};
t_mnk3 = {};
k3 = 0;
for j = 1:length(tracks)
    k1 = 0;
    k2 = 0;
    k3 = 0;
    for i = 1:length(tracks(j).poits)
        [x, flag, dop, nev] = NavSolverRDinvh(tracks(j).poits(i).rd, config.posts, [1000;1000;0], 0);
        if flag
            k1 = k1 + 1;
            X_mnk1{j}(:,k1) = x;
            t_mnk1{j}(k1) = tracks(j).poits(i).Frame;
        end
        [x, flag, dop, nev] = NavSolverRDinvh(tracks(j).poits(i).rd, config.posts, [1000;1000;-10000], 0);
        if flag
            k2 = k2 + 1;
            X_mnk2{j}(:,k2) = x;
            t_mnk2{j}(k2) = tracks(j).poits(i).Frame;
        end
        [x, flag, dop, nev] = NavSolverRDinvh(tracks(j).poits(i).rd, config.posts, [1000;1000;10000], 0);
        if flag
            k3 = k3 + 1;
            X_mnk3{j}(:,k3) = x;
            t_mnk3{j}(k3) = tracks(j).poits(i).Frame;
        end
    end
end
%% проверка МНК по четверкам
X_s = [];
t_s = [];
k1 = 0;
for i = 1:length(track.poits)
    [X, flag, dop, nev] = NavSolverRDgeo_h_4(track.poits(i).rd, config.posts, [1000;0], config, 10000);
    if flag
        k1 = k1 + 1;
        X_s(:,k1) = X;
        t_s(k1) = track.poits(i).Frame;
    else
        a = 5;
    end
end
%%
