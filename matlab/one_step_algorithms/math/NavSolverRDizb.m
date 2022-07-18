function [X, dop] = NavSolverRDizb(y, posts, X0, h)

    epsilon = 0.001;
    max_iter = 7;
    
    N = length(y);
    Y = zeros(N, 1);
    H = zeros(N, 2);
    X = X0;
    
    % 4 - 1
    % 4 - 2
    % 4 - 3
    % 3 - 1
    % 3 - 2
    % 2 - 1
    
    iter = 0;
    
while 1
    
    iter = iter + 1;
    
    for i = 1:N
        
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
        
        d1 = sqrt((X(1,1) - posts(1,n1))^2 + (X(2,1) - posts(2,n1))^2 + (h - posts(3,n1))^2);
        d2 = sqrt((X(1,1) - posts(1,n2))^2 + (X(2,1) - posts(2,n2))^2 + (h - posts(3,n2))^2);
        Y(i, 1) = d1 - d2;
        H(i, 1) = (X(1,1) - posts(1,n1))/d1 - (X(1,1) - posts(1,n2))/d2;
        H(i, 2) = (X(2,1) - posts(2,n1))/d1 - (X(2,1) - posts(2,n2))/d2;        
    end
    
    X_prev = X;
    X = X + (H'*H)^(-1)*(H')*(y-Y);
    
    if (norm(X - X_prev) < epsilon) || (iter > max_iter)
        invHH = inv(H'*H);
        DOPx = abs(invHH(1,1));
        DOPy = abs(invHH(2,2));
        dop = sqrt([DOPx DOPy])';
        break
    end
end

end

