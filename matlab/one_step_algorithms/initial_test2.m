function [X, flag, dop, nev] = initial_test2(poit, config)
    R = 100e3;
    a = 0:pi/16:2*pi;
    
    X0 = [];
    for i = 1:length(a)
        X0(1,i) = R * cos(a(i));
        X0(2,i) = R * sin(a(i));
        X0(3,i) = 10000;
    end
    X0(:,end+1) = [1000; 0; 10000];
    
%     for i = 1:length(X0)
%         [X(:,i), flag(i), dop1, nev(i)] = NavSolverRDinvh(poit.rd, config.posts, X0(:,i), 0);
%     end
    min_nev = 1e9;
    X_0 = [];
    for i = 1:length(X0)
        RD = [];
        R = [];
        for k = 1:4
            R(k) = norm(X0(:,i) - config.posts(:,k));
        end
        RD = [R(4) - R(1);
            R(4) - R(2);
            R(4) - R(3);
            R(3) - R(1);
            R(3) - R(2);
            R(2) - R(1);];
        nev(i) = norm(poit.rd - RD);
        if nev(i) < min_nev
            min_nev = nev(i);
            X_0 = X0(:,i);
        end
    end
    
    [X, flag, dop, nev] = NavSolverRDinvh(poit.rd, config.posts, X_0, 0);
    if ~flag
        [X, flag, dop, nev] = NavSolverRDinvh(poit.rd, config.posts, [1000; 0; 10000], 0);
    end
    
end

