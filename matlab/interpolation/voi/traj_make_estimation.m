function [traj] = traj_make_estimation(traj, config)
    
    [poits] = traj_get_poits(traj);
    
    k = length(poits);
    current_t0 = poits(1).Frame;
    current_tend = poits(end).Frame;
    
    y = zeros(4,k);
    cord = zeros(4,k);
    k1 = 0;
    
    for i = 1:k
        for j = 1:4
            if poits(i).ToA(j) > 0
                y(j,i) = (poits(i).Frame - poits(1).Frame) * 1e9 + poits(i).ToA(j);
            end
        end
        if poits(i).xy_valid
            k1 = k1 + 1;
            cord(:,k1) = poits(i).coords;
            cord(4,k1) = cord(4,k1) + (poits(i).Frame - current_t0) * config.c;
        end
    end
    
    if k1 < 5
        a = 5;
    end
    
    cord = cord(:,1:k1);
    
    X1 = traj_make_approx(cord, config);
    
    if k > 200
        nums1 = find([poits.count] > 2);
        nums2 = find([poits.count] > 3);
        if length(nums2 > 30)
            y = y(:,nums2);
        else
            y = y(:,nums1);
        end
    end
    
    if k < 15
       a = 5; 
    end
        
    [X, R] = traj_make_interp_3dv(y, config, X1);
    
%     dt = poits(end).Frame - current_t0;
%     
%     F1 = [1 dt dt^2/2;
%           0 1 dt;
%           0 0 1];
%     E = zeros(3);
%     F = [F1 E E; E F1 E; E E F1];
%     current_t0 = poits(end).Frame;
%         
%     X1 = F * X1;
%     X = F * X;
    
    traj.e_count = traj.e_count + 1;
    traj.t_last = current_tend;
    
    traj.timestamps(traj.e_count) = current_t0; 
    traj.SV_approx(:,traj.e_count) = X1; 
    traj.SV_interp(:,traj.e_count) = X; 
    traj.current_SV_approx = X1; 
    traj.current_SV_interp = X; 
    
     
    
end

