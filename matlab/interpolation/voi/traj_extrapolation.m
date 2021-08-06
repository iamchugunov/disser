function [X1] = traj_extrapolation(X, dt)
    F1 = [1 dt dt^2/2;
        0 1 dt;
        0 0 1];
    E = zeros(3);
    F = [F1 E E; E F1 E; E E F1];
    X1 = F * X;
end

