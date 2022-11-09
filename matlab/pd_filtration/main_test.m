traj_params.X0 = [50000;-150000];
% traj_params.X0 = [-3000;3000];
traj_params.V = 200;
traj_params.kurs = 2;
traj_params.h_geo = 10000;
traj_params.time_interval = [0 1500];
[track] = make_geo_track_v2(traj_params.X0, traj_params.V, traj_params.kurs, traj_params.h_geo, traj_params.time_interval, config);
show_track(track, config)
%%
config.sigma_n_ns = 10;
[track] = make_measurements_for_track(track, config);
[toa] = toa_analysis(track.poits);
%%
k = 0;
X = [];
ToT = [];
for i = 1:length(track.poits)
    pd = track.poits(i).ToA * config.c_ns;
    [x, dop, nev, flag] = coord_solver3D(pd, config.posts, [0;0;5000;0]);
    if flag
        k = k + 1;
        X(:,k) = x;
        ToT(k) = track.poits(i).Frame + X(4,k)/config.c;
    end
end