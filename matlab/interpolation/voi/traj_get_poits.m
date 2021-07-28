function [poits] = traj_get_poits(traj)
    
    T_nak = traj.T_nak;
    
    t_1 = traj.t_current - T_nak;
    
    k = traj.p_count;
    while k > 0
        if traj.poits(k).Frame < t_1
            break
        end
        k = k - 1;
    end
    
    poits = traj.poits(k:end);
    
    while length(poits) < 30
        T_nak = T_nak + 10;
    
        t_1 = traj.t_current - T_nak;
        k = traj.p_count;
        while k > 0
            if traj.poits(k).Frame < t_1
                break
            end
            k = k - 1;
        end
        poits = traj.poits(k:end);
    end
    
end

