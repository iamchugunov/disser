function [traj] = one_track_voi(poits, config)
    
    if poits(1).count == 4
        X0 = zeros(4,1);
        X0(3) = max(poits(1).ToA) * config.c_ns;
        poits(1) = poit_calc(poits(1), X0, config);
    end
    
    [traj] = traj_new(poits(1), config);
    
    for i = 2:length(poits)
%         i
        
        if poits(i).freq > 9000 %|| poits(i).count < 3
            continue
        end
        
        if poits(i).count == 4
            X0 = zeros(4,1);
            X0(3) = max(poits(i).ToA) * config.c_ns;
            poits(i) = poit_calc(poits(i), X0, config);
        end
        
        if traj.xy_valid && poits(i).count == 3
            X0 = traj_get_x0(traj);
            X0(4) = max(poits(i).ToA) * config.c_ns;
            poits(i) = poit_calc(poits(i), X0, config);
        end
        [ready_flag, traj] = traj_add_poit(traj, poits(i));
        if ready_flag
            traj = traj_make_estimation(traj, config);
            
        end
        
        
    end
end

