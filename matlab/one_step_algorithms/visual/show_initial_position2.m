function [] = show_initial_position2(toa, posts)
    X = -400e3:10e3:400e3;
    Y = X;
    
    nev = [];
    X0 = [];
    for i = 1:length(Y)
        for j = 1:length(X)
            X0 = [X(j);Y(i);0];
            nev(i,j) = check_for_rd(X0, toa, posts);            
        end
    end
    
    surf(X,Y, nev)
    shading interp
    hold on
%     plot3(X0(1),X0(2),1e8,'x')
end

