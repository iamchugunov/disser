function [flag] = traj_is_ok(traj, X)
    flag = 1;
    if norm([X(2) X(5)]) > 600
        flag = 0;
    end
    if norm([X(3) X(6)]) > 50
        flag = 0;
    end
    if X(7) < 0 && X(7) > 20000
        flag = 0;
    end
    if abs(X(8)) > 200
        flag = 0;
    end
    if flag == 0
        disp("WARNING :: Проверка не пройдена")
    end
%     if abs(X(9)) > 5
%         flag = 0;
%     end
end

