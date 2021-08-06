function [err,t] = error_calc(traj, track)
    sv_true = track.SV;
    t_true = track.ToT;
    
    sv_est = traj.SV_interp;
    t_est = traj.timestamps;
    
    sv(1,:) = interp1(t_true,sv_true(1,:),t_est);
    sv(2,:) = interp1(t_true,sv_true(2,:),t_est);
    sv(3,:) = interp1(t_true,sv_true(4,:),t_est);
    sv(4,:) = interp1(t_true,sv_true(5,:),t_est);
    sv(5,:) = interp1(t_true,sv_true(7,:),t_est);
    sv(6,:) = interp1(t_true,sv_true(8,:),t_est);
    
    err = sv_est([1 2 4 5 7 8],:) - sv;
    t = t_est;
    
end

