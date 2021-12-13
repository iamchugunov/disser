function [X, R, flag] = traj_make_interp_3dv(y, config, X0)
    addpath("D:\github\disser\matlab\interpolation\deriv_func\3da")   
    N = size(y,2);
    if N < 4
        flag = 0;
        X = [];
        R = [];
        return
    end
    if N > 200
        y = y(:,end-200:end);
    end
    N = size(y,2);
    t0 = 0;
    
    X = zeros(6 + N,1);
    X(1:6) = X0([1 2 4 5 7 8]);
    
    for i = 1:size(y,2)
        cord = X0([1 4 7]) + X0([2 5 8]) * max(y(:,i))*1e-9;
        delta = [norm(config.posts(:,1) - cord);
                    norm(config.posts(:,2) - cord);
                    norm(config.posts(:,3) - cord);
                    norm(config.posts(:,4) - cord);] / config.c_ns;
        nums = find(y(:,i));
        X(6+i) = mean(y(nums,i) - delta(nums));
    end
    X(7:end) = max(y);
    
    
    
    k = 0;
    while 1
        dpdX = zeros(6 + N, 1);
        dp2d2X = zeros(6 + N, 6 + N);
        for j = 1:N
            for i = 1:size(y,1)
                if y(i,j)
                    t_k = (y(i,j) - t0)*1e-9;
                    X_9 = zeros(9,1);
                    X_9(1) = X(1);
                    X_9(2) = X(2);
                    X_9(4) = X(3);
                    X_9(5) = X(4);
                    X_9(7) = X(5);
                    X_9(8) = X(6);
                    X_9(10:9+N) = X(7:end);
                    
                    d = [ dpdx(y(i,j),X_9,t_k,i,j, config);
                         dpdVx(y(i,j),X_9,t_k,i,j, config);
                         dpdy(y(i,j),X_9,t_k,i,j, config);
                         dpdVy(y(i,j),X_9,t_k,i,j, config);
                         dpdz(y(i,j),X_9,t_k,i,j, config);
                         dpdVz(y(i,j),X_9,t_k,i,j, config);];
                    dpdX(1:6) = dpdX(1:6) + d;
                    dpdX(6 + j) = dpdX(6 + j) +  dpdT(y(i,j),X_9,t_k,i,j, config);

                    dd = zeros(6 + N, 6 + N);

                    dd(1,1) = dpdxdx(y(i,j),X_9,t_k,i,j, config);
                    dd(1,2) = dpdxdVx(y(i,j),X_9,t_k,i,j, config);
                    dd(2,1) = dd(1,2);
                    dd(1,3) = dpdxdy(y(i,j),X_9,t_k,i,j, config);
                    dd(3,1) = dd(1,3);
                    dd(1,4) = dpdxdVy(y(i,j),X_9,t_k,i,j, config);
                    dd(4,1) = dd(1,4);
                    dd(1,5) = dpdxdz(y(i,j),X_9,t_k,i,j, config);
                    dd(5,1) = dd(1,5);
                    dd(1,6) = dpdxdVz(y(i,j),X_9,t_k,i,j, config);
                    dd(6,1) = dd(1,6);
                    dd(1,6 + j) = dpdxdT(y(i,j),X_9,t_k,i,j, config);
                    dd(6 + j, 1) = dd(1,6 + j);

                    dd(2,2) = dpdVxdVx(y(i,j),X_9,t_k,i,j, config);
                    dd(2,3) = dpdydVx(y(i,j),X_9,t_k,i,j, config);
                    dd(3,2) = dd(2,3);
                    dd(2,4) = dpdVxdVy(y(i,j),X_9,t_k,i,j, config);
                    dd(4,2) = dd(2,4);
                    dd(2,5) = dpdzdVx(y(i,j),X_9,t_k,i,j, config);
                    dd(5,2) = dd(2,5);
                    dd(2,6) = dpdVxdVz(y(i,j),X_9,t_k,i,j, config);
                    dd(6,2) = dd(2,6);
                    dd(2,6 + j) = dpdVxdT(y(i,j),X_9,t_k,i,j, config);
                    dd(6 + j, 2) = dd(2,6 + j);

                    
                    dd(3,3) = dpdydy(y(i,j),X_9,t_k,i,j, config);
                    dd(3,4) = dpdydVy(y(i,j),X_9,t_k,i,j, config);
                    dd(4,3) = dd(3,4);
                    dd(3,5) = dpdydz(y(i,j),X_9,t_k,i,j, config);
                    dd(5,3) = dd(3,5);
                    dd(3,6) = dpdydVz(y(i,j),X_9,t_k,i,j, config);
                    dd(6,3) = dd(3,6);
                    dd(3,6 + j) = dpdydT(y(i,j),X_9,t_k,i,j, config);
                    dd(6 + j, 3) = dd(3, 6 + j);

                    dd(4,4) = dpdVydVy(y(i,j),X_9,t_k,i,j, config);
                    dd(4,5) = dpdzdVy(y(i,j),X_9,t_k,i,j, config);
                    dd(5,4) = dd(4,5);
                    dd(4,6) = dpdVydVz(y(i,j),X_9,t_k,i,j, config);
                    dd(6,4) = dd(4,6);
                    dd(4,6 + j) = dpdVydT(y(i,j),X_9,t_k,i,j, config);
                    dd(6 + j, 4) = dd(4,6 + j);

                    dd(5,5) = dpdzdz(y(i,j),X_9,t_k,i,j, config);
                    dd(5,6) = dpdzdVz(y(i,j),X_9,t_k,i,j, config);
                    dd(6,5) = dd(5,6);
                    dd(5,6 + j) = dpdzdT(y(i,j),X_9,t_k,i,j, config);
                    dd(6 + j, 5) = dd(5,6 + j);

                    dd(6,6) = dpdVzdVz(y(i,j),X_9,t_k,i,j, config);
                    dd(6,6 + j) = dpdVzdT(y(i,j),X_9,t_k,i,j, config);
                    dd(6 + j, 6) = dd(6,6 + j);

                    dd(6 + j,6 + j) = dpdTdT(y(i,j),X_9,t_k,i,j, config);

                    dp2d2X = dp2d2X + dd;

                end
            end
        end
        X_prev = X;
        X = X - inv(dp2d2X) * dpdX;
        k = k + 1;
        if norm(X - X_prev) < 0.5 || k > 10
            disp(num2str([norm(X - X_prev) norm(X(1:6) - X0([1 2 4 5 7 8])) k N]))
            if norm(X - X_prev) < 10
                flag = 1;
            else
                flag = 0;
            end
            X_out = zeros(9,1);
            X_out([1 2 4 5 7 8]) = X(1:6);
            X = X_out;
            R = dp2d2X;
            D = inv(-R);
            R = sqrt(abs(D(1:6,1:6)));
            break;
        end
        
    end
    
    
end





