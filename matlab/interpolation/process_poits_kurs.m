function [X0, X, x, k, R] = process_poits_kurs(poits, config, X_0)  
    addpath('D:\Projects\max-likehood')
    k = 0;
    x = [];
    t = [];
    for i = 1:length(poits)
        if poits(i).count == 4
            [X, flag, dop, nev] = NavSolverRDinvh(poits(i).rd, config.posts, [1000;0;10000], 0);
            if flag
                k = k + 1;
                x(:,k) = X;
                t(k) = poits(i).Frame;
            end
        end
    end
    
    T = t - poits(1).Frame;
    if (k > 10)
        [koef1, sko1, Xa(1,:)] = mnk_step(T, x(1,:), 1);
        [koef2, sko2, Xa(2,:)] = mnk_step(T, x(2,:), 1);
        
        X0(1,1) = koef1(1);
        X0(2,1) = koef1(2);
        X0(3,1) = koef2(1);
        X0(4,1) = koef2(2);
        X0(5,1) = 10000;
        X0(6,1) = 0;
    else
        X0 = zeros(6,1);
        x = zeros(3,1);
    end
    
    y = x(1:2,:);
    X1 = X0;
    X0 = [X0(1,1);X0(3,1);norm([X0([2 4],:)]); atan2(X0(3,1),X0(1,1))];
    X_0 = X0;
%     [X, R, nev, add] = max_likelyhood_2dv_kurs(y,t, config,X_0);
    [X, R, nev, add] = max_likelyhood_2dv_kurs_v_const(y,t, config,X_0);
    X = [X(1,1);X(3,1) * cos(X(4,1));X(2,1);X(3,1) * sin(X(4,1));10000;0];
    X0 = X1;
    R = sqrt(diag(inv(R)));
    range = norm(X([1 3]));
    V = norm(X([2 4]));
    if range > 1e6 || V > 1000
        disp('aaa')
    end
end



