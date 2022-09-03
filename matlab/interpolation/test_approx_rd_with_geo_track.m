%%
addpath("D:\Projects\disser\matlab\track_imitation")
[ config ] = Config( );
config.PostsENU = config.posts;
config.sigma_n_ns = 30;
traj_params.X0 = [250000;-150000];
% traj_params.X0 = [-50000;0];
traj_params.V = 200;
traj_params.R = 20e3;
traj_params.kurs = 2;
traj_params.h_geo = 10000;
traj_params.time_interval = [0 3000];
[track] = make_geo_track(traj_params.X0, traj_params.V, traj_params.kurs, traj_params.h_geo, traj_params.time_interval, config);
% [track] = make_geo_track_circle(traj_params.X0, traj_params.V, traj_params.R, traj_params.h_geo, traj_params.time_interval, config);
show_track(track, config)
%% генерация измерений
[track] = make_measurements_for_track(track, config);
get_rd_from_poits(track.poits)
%%
n1 = 1;
n2 = 3000;
Xtrue = zeros(6,n2-n1 + 1);
Xtrue([1 3 5],:) = track.coords(:,n1:n2);
Xtrue([2 4 6],:) = track.V(:,n1:n2);
poits = track.poits(n1:n2);
plot3(config.posts(1,:),config.posts(2,:),config.posts(3,:),'v')
hold on
plot3(Xtrue(1,:),Xtrue(3,:),Xtrue(5,:),'k.-')
grid on
%%
[flag, X0, X, x, k, R] = process_poits(poits, config, Xtrue(:,1));
t = [poits.Frame] - poits(1).Frame;
Xest = X;
Xini = X0;
for i = 2:length(poits)
    dt = t(i) - t(i-1);
    Xest(1,i) = Xest(1,i-1) + Xest(2,i-1) * dt;
    Xest(2,i) = Xest(2,i-1);
    Xest(3,i) = Xest(3,i-1) + Xest(4,i-1) * dt;
    Xest(4,i) = Xest(4,i-1);
    Xest(5,i) = Xest(5,i-1) + Xest(6,i-1) * dt;
    Xest(6,i) = Xest(6,i-1);
    
    Xini(1,i) = Xini(1,i-1) + Xini(2,i-1) * dt;
    Xini(2,i) = Xini(2,i-1);
    Xini(3,i) = Xini(3,i-1) + Xini(4,i-1) * dt;
    Xini(4,i) = Xini(4,i-1);
    Xini(5,i) = Xini(5,i-1) + Xini(6,i-1) * dt;
    Xini(6,i) = Xini(6,i-1);
end

figure(1)
plot3(config.PostsENU(1,:),config.PostsENU(2,:),config.PostsENU(3,:),'v')
hold on
plot3(x(1,:),x(2,:),x(3,:),'.m')
plot3(Xtrue(1,:),Xtrue(3,:),Xtrue(5,:),'k.-')
plot3(Xest(1,:),Xest(3,:),Xest(5,:),'r.-')
plot3(Xini(1,:),Xini(3,:),Xini(5,:),'b.-')
grid on
daspect([1 1 1])
%%
n1 = 1;+2000;
n2 = 60;+2000;
Xtrue = zeros(6,n2-n1 + 1);
Xtrue([1 3 5],:) = track.coords(:,n1:n2);
Xtrue([2 4 6],:) = track.V(:,n1:n2);
N = 100;
X_ = [];
R_ = [];
k = 0;
for i = 1:N
    i
    [track] = make_measurements_for_track(track, config);
    poits = track.poits(n1:n2);
    [flag, X0, X, x, ~, R] = process_poits(poits, config, Xtrue(:,1));
    if isreal(R) && flag
        k = k + 1;
    	X_(:,k) = X;
        R_(:,k) = R;
    end
end
%%
%%
k = 0;
X0 = [];
X = [];
Xtrue = [];
R = [];
t = [];
for i = 1:30:length(track.poits)-61
%     k = k + 1
    n1 = i;
    n2 = i+60;
    poits = track.poits(n1:n2);
%     poits = thinning_poits(poits);
%     [length(find([poits.count]==2)) length(find([poits.count]==3)) length(find([poits.count]==4))]
    xtrue([1 3 5],1) = track.coords(:,i);
    xtrue([2 4 6],1) = track.V(:,i);
    [flag, X0_, X_, x, K_, R_] = process_poits(poits, config, xtrue);
    if isreal(R_) && flag
        k = k + 1;
        X0(:,k) = X0_;
        X(:,k) = X_;
        R(:,k) = R_;
        t(:,k) = track.poits(n1).Frame;
        Xtrue([1 3 5],k) = track.coords(:,i);
        Xtrue([2 4 6],k) = track.V(:,i);
    end
    
end
[std([X0 - Xtrue]')' std([X - Xtrue]')' std([X0 - Xtrue]')'./std([X - Xtrue]')']
plot3(config.PostsENU(1,:),config.PostsENU(2,:),config.PostsENU(3,:),'v')
hold on
plot3(Xtrue(1,:),Xtrue(3,:),Xtrue(5,:),'k.-')
plot3(X(1,:),X(3,:),X(5,:),'r.-')
plot3(X0(1,:),X0(3,:),X0(5,:),'b.-')
view(2)
%%
s_ksi = 0.1;
X_true = [];
X_true([1 4 7],:) = [track.coords];
X_true([2 5 8],:) = [track.V];
X_true([3 6 9],:) = 0;
X_true(:,end) = [];
% KF = RDKalmanFilter3D(track.poits, config, X_true([1 2 4 5 7 8],1),s_ksi);
KF = RDKalmanFilter3D(track.poits, config, X0(:,1),s_ksi);
std([KF.X - X_true]')'
plot3(KF.X(1,:),KF.X(4,:),KF.X(7,:),'.-')
% figure
rd_true = [];
for i = 1:length(track.poits)
    R = [];
    for j = 1:4
        R(j) = norm(track.poits(i).true_coords([1 3 5]) - config.posts(:,j));
    end
    rd_true(:,i) = [R(4) - R(1); 
        R(4) - R(2);
        R(4) - R(3);
        R(3) - R(1);
        R(3) - R(2);
        R(2) - R(1);];
end

% plot(KF.rd' - rd_true')
% ylim([-30 30])
% std(KF.rd' - rd_true')'
%%
T_nak = [10:10:60];
s_ksi = [0 0.01 0.05 0.1 0.5 1 5 10 100];
for i = 1:length(T_nak)
    indata(i) = calculate_track_by_interpolation(track, config, 10, T_nak(i));
end
X_true = [];
X_true([1 3 5],:) = [track.coords];
X_true([2 4 6],:) = [track.V];
for i = 1:length(s_ksi)
    KF(i) = RDKalmanFilter3D(track, config, X_true(:,1), s_ksi(i));
end