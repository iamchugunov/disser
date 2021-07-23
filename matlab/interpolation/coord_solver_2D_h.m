function [X, flag, dop] = coord_solver_2D_h(y, posts, X0, h)
    min_i = 0;
    min_nev = 1e20;
    for i = 1:length(h)
        [X(:,i), dop(i), nev(i), flag] = coord_solver2D(y, posts, X0, h(i));
        if nev(i) < min_nev && flag
            min_i = i;
            min_nev = nev(i);
        end
    end
    if min_i == 0
        flag = 0;
        X = 0;
        dop = 0;
    else
        flag = 1;
        X = [X(1,min_i); X(2,min_i); h(min_i); X(3,min_i)];
        dop = dop(min_i);
    end
end

