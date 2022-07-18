function [nev, X0] = show_initial_position(poit, config)
    X = -50e3:1e3:50e3;
    Y = X;
    rd = poit.rd;
    nev = [];
    min_nev = 1e10;
    X0 = [];
    for i = 1:length(Y)
        for j = 1:length(X)
            RD = [];
            R = [];
            for k = 1:4
                R(k) = norm([X(j);Y(i);0] - config.posts(:,k));
            end
            RD = [R(4) - R(1);
                R(4) - R(2);
                R(4) - R(3);
                R(3) - R(1);
                R(3) - R(2);
                R(2) - R(1);];
            nev(i,j) = norm(rd - RD);
            if nev(i,j) < min_nev
                min_nev = nev(i,j);
                X0 = [X(j);Y(i)];
            end
        end
    end
    
    surf(X,Y, nev)
    shading interp
    hold on
%     plot3(X0(1),X0(2),1e8,'x')
end

