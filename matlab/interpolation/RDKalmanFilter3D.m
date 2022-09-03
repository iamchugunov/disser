function [KFilter] = RDKalmanFilter3D(track, config, X0, s_ksi)
    addpath("D:\Projects\disser\matlab\interpolation\math")
    poits = track.poits;
    s_n = config.c_ns * config.sigma_n_ns;
%     s_ksi = 1;
    D_ksi = eye(3) * s_ksi^2;
    X_prev = [X0(1); X0(2); 0; X0(3); X0(4); 0; X0(5); X0(6);0];
    Dx = eye(9);
    X = X_prev;
    for i = 2:length(poits)
        dt = poits(i).Frame - poits(i-1).Frame;
        nums = find(poits(i).rd);
        D_n = eye(length(nums)) * s_n^2;
        [X(:,i), Dx, discr] = Kalman_step_3Drd(poits(i).rd, X(:,i-1), Dx, dt, D_n, D_ksi, config);    
    end
    KFilter.t = [poits.Frame];
    KFilter.X = X;
    X_true = [];
    X_true([1 4 7],:) = [track.coords];
    X_true([2 5 8],:) = [track.V];
    X_true([3 6 9],:) = 0;
    X_true(:,end) = [];
    KFilter.err = X - X_true;

    rd = [];
    for i = 1:length(X)
        R = [];
        for j = 1:4
            R(j) = norm(X([1 4 7],i) - config.posts(:,j));
        end
        rd(:,i) = [R(4) - R(1);
            R(4) - R(2);
            R(4) - R(3);
            R(3) - R(1);
            R(3) - R(2);
            R(2) - R(1)];
    end
    KFilter.rd = rd;
    
    rd_true = [];
    for i = 1:length(track.poits)
        R = [];
        for j = 1:4
            R(j) = norm(track.poits(i).true_coords([1 3 5]) - config.posts(:,j));
        end
        rd_true(:,i) = [R(4) - R(1);
            R(4) - R(2);
            R(4) - R(3);
            R(3) - R(1);
            R(3) - R(2);
            R(2) - R(1);];
    end
    
    KFilter.rd_err = rd - rd_true;
end

