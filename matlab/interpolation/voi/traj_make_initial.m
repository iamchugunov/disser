function [approx_flag, extrap_flag, X_appr, X_extr] = traj_make_initial(traj, cord, current_t0, config)
    k1 = size(cord, 2);
    
    if k1 < 3
        approx_flag = 0;
        X_appr = zeros(9,1);
    else
        X1 = traj_make_approx(cord, config);
        if traj_is_ok(traj, X1)
            approx_flag = 1;
            X_appr = X1;
        else
            approx_flag = 0;
            X_appr = zeros(9,1);
        end
    end
    
    if traj.mode == 0
        extrap_flag = 0;
        X_extr = zeros(9,1);
    else
        X1 = traj_extrapolation(traj.SV_interp(:,end),current_t0 - traj.timestamps(end));
        if traj_is_ok(traj, X1)
            extrap_flag = 1;
            X_extr = X1;
        else
            extrap_flag = 0;
            X_extr = zeros(9,1);
        end
    end
%     extrap_flag = 0;
    
end

