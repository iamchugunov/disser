function [X, R] = max_likelyhood2dv_D(y, t, config, X0)
    addpath("D:\Projects\disser\matlab\interpolation\deriv_func\2dv_D")   
    N = size(y,2);
    t0 = t(1);
    
    X = zeros(4);
    X = X0;
        
    k = 0;
    while 1
        dpdX = zeros(4, 1);
        dp2d2X = zeros(4, 4);
        for j = 1:N
            for i = 1:size(y,1)
                if y(i,j)
                    t_k = (t(j) - t0);
                    
                    d = [ dpdx(y(i,j),X,t_k,i,j, config);
                         dpdVx(y(i,j),X,t_k,i,j, config);
                         dpdy(y(i,j),X,t_k,i,j, config);
                         dpdVy(y(i,j),X,t_k,i,j, config);];
                    dpdX = dpdX + d;
                    
                    dd = zeros(4, 4);

                    dd(1,1) = dpdxdx(y(i,j),X,t_k,i,j, config);
                    dd(1,2) = dpdxdVx(y(i,j),X,t_k,i,j, config);
                    dd(2,1) = dd(1,2);
                    dd(1,3) = dpdxdy(y(i,j),X,t_k,i,j, config);
                    dd(3,1) = dd(1,3);
                    dd(1,4) = dpdxdVy(y(i,j),X,t_k,i,j, config);
                    dd(4,1) = dd(1,4);

                    dd(2,2) = dpdVxdVx(y(i,j),X,t_k,i,j, config);
                    dd(2,3) = dpdydVx(y(i,j),X,t_k,i,j, config);
                    dd(3,2) = dd(2,3);
                    dd(2,4) = dpdVxdVy(y(i,j),X,t_k,i,j, config);
                    dd(4,2) = dd(2,4);

                    dd(3,3) = dpdydy(y(i,j),X,t_k,i,j, config);
                    dd(3,4) = dpdydVy(y(i,j),X,t_k,i,j, config);
                    dd(4,3) = dd(3,4);

                    dd(4,4) = dpdVydVy(y(i,j),X,t_k,i,j, config);
                    
                    dp2d2X = dp2d2X + dd;

                end
            end
        end
        X_prev = X;
        X = X - inv(dp2d2X) * dpdX;
        k = k + 1;
        if norm(X - X_prev) < 0.00005 || k > 10
            [norm(X - X_prev) k N]
            R = dp2d2X;
            D = inv(-R);
            R = sqrt(abs(D));
            break;
        end
        
    end
    
    
end





