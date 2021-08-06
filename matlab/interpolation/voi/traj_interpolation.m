function [flag, X, R] = traj_interpolation(traj, poits, y, config, X1)
    
    k = size(y,2);
    % пробуем без двоек
    nums34 = find([poits.count] > 2);
    nums4 = find([poits.count] > 3);
   
    % если отметок меньше двухста - юзаем все отметки
    % если отметок больше то пробуем сначала только по четверкам (если их
    % больше 6, потом по тройкам и четверкам
    if k > 200
        disp("WARNING:: k > 200")
        disp("По четверкам:")
        [X, R, flag] = traj_make_interp_3dv(y(:,nums4), config, X1);
        if flag
            flag = traj_is_ok(traj, X);
        end
        
        if flag == 0 && length(nums34) < 200
            disp("По четверкам и тройкам:")
            [X, R, flag] = traj_make_interp_3dv(y(:,nums34), config, X1);
            if flag
                flag = traj_is_ok(traj, X);
            end
        end
    else
        disp("По всем:")
        [X, R, flag] = traj_make_interp_3dv(y, config, X1);
        if flag
            flag = traj_is_ok(traj, X);
        end
        if flag == 0
            disp("По четверкам:")
            [X, R, flag] = traj_make_interp_3dv(y(:,nums4), config, X1);
            if flag
                flag = traj_is_ok(traj, X);
            end
        end
        if flag == 0
            disp("По четверкам и тройкам:")
            [X, R, flag] = traj_make_interp_3dv(y(:,nums34), config, X1);
            if flag
                flag = traj_is_ok(traj, X);
            end
        end
    end
end

