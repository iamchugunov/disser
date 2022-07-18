function [X1] = initial_test(poit, config)
    X = -30e3:1e3:30e3;
    Y = X;
    rd = poit.rd;
    nev = [];
    X1 = [];
    k = 0;
    for i = 1:length(Y)
        for j = 1:length(X)
            [x, flag, dop, nev1] = NavSolverRDinvh(rd, config.posts, [X(j); Y(i); -10000], 0);
            if flag
                nev(i,j) = nev1;
                k = k + 1;
                X1(:,k) = x;
            else
                nev(i,j) = NaN;
            end
        end
    end
    
    surf(X,Y, nev)
    shading interp
    hold on
end

