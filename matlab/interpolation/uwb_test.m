[ config ] = Config( );
addpath('voi')
h_p = 100;
x = 100;
config.posts(:,1) = [-x/2;-x/2;h_p];
config.posts(:,2) = [-x/2;x/2;h_p];
config.posts(:,3) = [x/2;-x/2;h_p];
config.posts(:,4) = [x/2;x/2;h_p];

% config.posts(:,1) = [-x/2;-x/2;h_p];
% config.posts(:,2) = [-x/2;x/2;h_p];
% config.posts(:,3) = [0;x/2;h_p];
% config.posts(:,4) = [0.1;0.1;100];

config.hei = 2;
config.V = 15;
config.frame_length_sec = 0.0013;
config.period_sec = 0.1; 
config.n_periods = 0; 
config.lifetime = x/config.V; 
config.sigma_n_ns = 0.13;
config.T_nak = 1;
config.T_est = 0.1;
[track] = make_track(config, x);
[traj] = one_track_voi(track.poits, config);

for i =1 : length(traj.poits)
    coords(:,i) = traj.poits(i).coords(1:3);
end

[err,t] = error_calc(traj, track);
figure
plot(err(1,:))
hold on
plot(err(3,:))
plot(err(5,:))

figure
plot(coords(1,:),coords(2,:),'-')
hold on
axis([-x x -x x])
hold on
plot(traj.SV_interp(1,:),traj.SV_interp(4,:),'.-')

std(err([1 3 5],2:end)')