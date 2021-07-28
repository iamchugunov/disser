function [X0] = traj_get_x0(traj)
    k = length(traj.poits);
    while k > 0
        if traj.poits(k).xy_valid
            X0 = traj.poits(k).coords;
            break
        end
        k = k - 1;
    end
end

