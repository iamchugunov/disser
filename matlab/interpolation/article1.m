tnak = 5:5:45;
config.T_est = 1;
for i = 1:length(tnak)
    config.T_nak = tnak(i);
    [traj] = one_track_voi(track.poits, config);
    [err,t] = error_calc(traj, track);
    figure(1)
    hold on
    grid on
    plot(t,(sqrt(err(1,:).^2 + err(3,:).^2)./(traj.dops * config.sigma_n_m)))
    
    STD(:,i) = std(sqrt(err(1,:).^2 + err(3,:).^2)./(traj.dops * config.sigma_n_m));
        
end
    