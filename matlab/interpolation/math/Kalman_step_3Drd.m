function [X, Dx, discr] = Kalman_step_3Drd(y, X_prev, Dx, dt, D_n, D_ksi, config)
            
            nums = find(y ~= 0);

            D_n = eye(length(nums)) * D_n;

            F1 = [1 dt dt^2/2; 0 1 dt; 0 0 1];
            F = zeros(9,9);
            F(1:3,1:3) = F1;
            F(4:6,4:6) = F1;
            F(7:9,7:9) = F1;
            
            G = zeros(9,3);
            G(3,1) = dt;
            G(6,2) = dt;
            G(9,3) = dt;
            
            
            
            X_ext = F * X_prev;
            D_x_ext = F * Dx * F' + G * D_ksi * G';
            dS = make_dS(y, X_ext, config.posts);
            S = make_S(y, X_ext, config.posts);
            K = D_x_ext * dS' * inv(dS*D_x_ext*dS' + D_n);
            Dx = D_x_ext - K * dS * D_x_ext;
            discr = y(nums) - S;
            X = X_ext + K*(discr);
end

function dS = make_dS(y, X, posts)
    
    k = 0;
    for i = 1:6
        
        switch i
            case 1
                n1 = 4;
                n2 = 1;
            case 2
                n1 = 4;
                n2 = 2;
            case 3
                n1 = 4;
                n2 = 3;
            case 4
                n1 = 3;
                n2 = 1;
            case 5
                n1 = 3;
                n2 = 2;
            case 6
                n1 = 2;
                n2 = 1;
        end
        
        if y(i) ~= 0
            k = k + 1;
            d1 = sqrt((X(1,1) - posts(1,n1))^2 + (X(4,1) - posts(2,n1))^2 + (X(7,1) - posts(3,n1))^2);
            d2 = sqrt((X(1,1) - posts(1,n2))^2 + (X(4,1) - posts(2,n2))^2 + (X(7,1) - posts(3,n2))^2);
            dS(k,1) = (X(1,1) - posts(1,n1))/d1 - (X(1,1) - posts(1,n2))/d2;
            dS(k,2) = 0.;
            dS(k,3) = 0.;
            dS(k,4) = (X(4,1) - posts(2,n1))/d1 - (X(4,1) - posts(2,n2))/d2;
            dS(k,5) = 0;
            dS(k,6) = 0;
            dS(k,7) = (X(7,1) - posts(3,n1))/d1 - (X(7,1) - posts(3,n2))/d2;
            dS(k,8) = 0;
            dS(k,9) = 0;
        end
    end
end

function S = make_S(y, X, posts)
    
    k = 0;
    for i = 1:6
        
        switch i
            case 1
                n1 = 4;
                n2 = 1;
            case 2
                n1 = 4;
                n2 = 2;
            case 3
                n1 = 4;
                n2 = 3;
            case 4
                n1 = 3;
                n2 = 1;
            case 5
                n1 = 3;
                n2 = 2;
            case 6
                n1 = 2;
                n2 = 1;
        end
        
        if y(i) ~= 0
            k = k + 1;
            d1 = sqrt((X(1,1) - posts(1,n1))^2 + (X(4,1) - posts(2,n1))^2 + (X(7,1) - posts(3,n1))^2);
            d2 = sqrt((X(1,1) - posts(1,n2))^2 + (X(4,1) - posts(2,n2))^2 + (X(7,1) - posts(3,n2))^2);
            S(k, 1) = d1 - d2;
        end
    end
end

