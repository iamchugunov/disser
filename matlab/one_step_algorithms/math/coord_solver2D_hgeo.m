function [X, dop, nev, flag] = coord_solver2D_hgeo(y, posts, X0, h)

    epsilon = 0.001;
    max_iter = 20;
    
    Rz = 6371e3;

    N = size(posts,2);
    Y = zeros(N, 1);
    H = zeros(N, 3);
    X = X0;
    
    iter = 0;
    
while 1
    
    iter = iter + 1;
    
    for i = 1:N
        z = -Rz + sqrt((Rz + h)^2 - X(1,1)^2 - X(2,1)^2);
        d = sqrt((X(1,1) - posts(1,i))^2 + (X(2,1) - posts(2,i))^2 + (z - posts(3,i))^2);
        Y(i, 1) = d + X(3,1);
        dzdx = -X(1,1)/sqrt((Rz + h)^2 - X(1,1)^2 - X(2,1)^2);
        H(i, 1) = 1/d * (X(1,1) - posts(1,i) + (z - posts(3,i))*dzdx );
        dzdy = -X(2,1)/sqrt((Rz + h)^2 - X(1,1)^2 - X(2,1)^2);
        H(i, 2) = 1/d * (X(2,1) - posts(2,i) + (z - posts(3,i))*dzdy );
        H(i, 3) = 1;
    end
    
    X_prev = X;
    X = X + (H'*H)^(-1)*(H')*(y-Y);
%     X
%     X - X_prev
    nev = norm(X - X_prev);
    
    if (nev < epsilon) || (iter > max_iter) 
        
        X = [X(1:2); z; X(3)];
        if nev > 1e8 || norm(X(1:2)) > 6.e5
            flag = 0;
            dop = 0;
        else
            flag = 1;
            invHH = inv(H'*H);
            DOPx = sqrt(abs(invHH(1,1)));
            DOPy = sqrt(abs(invHH(2,2)));
            DOPt = sqrt(abs(invHH(3,3)));
            dop = norm([DOPx DOPy]);
            nev = norm(y - Y);
            if nev > 10000
                flag = 0;
            else
                flag = 1;
            end
        end
        break
    end
end

end

