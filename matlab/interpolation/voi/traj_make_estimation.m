function [traj] = traj_make_estimation(traj, config)
    disp("============")
    % берем из траектории точки соответствующие моменту накопления 
    %(от current_t - T_nak до current_t
    [poits] = traj_get_poits(traj); 
    
    k = length(poits);
    current_t0 = poits(1).Frame;
    current_tend = poits(end).Frame;
    timestamp = current_t0;
    
    % заполняем наблюдения y и вектор координат для аппроксимации
    y = zeros(4,k);
    cord = zeros(4,k);
    k1 = 0;
    
    for i = 1:k
        for j = 1:4
            if poits(i).ToA(j) > 0
                y(j,i) = (poits(i).Frame - poits(1).Frame) * 1e9 + poits(i).ToA(j);
            end
        end
        if poits(i).xy_valid
            k1 = k1 + 1;
            cord(:,k1) = poits(i).coords;
            cord(4,k1) = cord(4,k1) + (poits(i).Frame - current_t0) * config.c;
        end
    end
    
    cord = cord(:,1:k1);
    
    % аппроксимируем, если координат больше или равно 3
    
    [approx_flag, extrap_flag, X_appr, X_extr] = traj_make_initial(traj, cord, current_t0, config);
    
    if traj.mode == 0 && approx_flag == 0 && extrap_flag == 0
        disp("WARNING :: Завязка не получилась")
        return;
    end
      
    if approx_flag
        traj.approx_timestamp = timestamp;
        traj.approx_count = traj.approx_count + 1;
        traj.SV_approx(:,traj.approx_count) = X_appr;
    end
    
    flag = 0;
    if extrap_flag
        disp("WARNING :: Пробуем по экстраполяции")
        [flag, X, R] = traj_interpolation(traj, poits, y, config, X_extr);
    end
    if flag == 0
        if approx_flag
            disp("WARNING :: Пробуем по аппроксимации")
            [flag, X, R] = traj_interpolation(traj, poits, y, config, X_appr);
        end
    end
        
    
        
    
    if flag == 0
        if traj.mode == 0
            traj.T_nak = traj.T_nak + 10;
            disp("WARNING :: Завязка не получилась: flag = 0")
        else
            traj.t_last = current_tend;
            if k1 < 50
                traj.T_nak = traj.T_nak + traj.T_nak_default;
            else
                traj.T_nak = traj.T_nak_default;
            end
            disp("WARNING :: Решение не получилось: flag = 0")
        end
                
        interp_flag = 0;
    else
        if traj.mode == 0
            traj.mode = 1;
        end
        traj.T_nak = traj.T_nak_default;
        interp_flag = 1;
        
        traj.e_count = traj.e_count + 1;
        traj.t_last = current_tend;
        
        traj.timestamps(traj.e_count) = timestamp;
        traj.SV_interp(:,traj.e_count) = X;
        traj.Dn(:,traj.e_count) = sqrt(diag(R));
        
        X2 = traj_extrapolation(X, current_tend - current_t0);
        traj.timestamps1(traj.e_count) = current_tend;
        traj.SV_interp1(:,traj.e_count) = X2; 
        
        traj.dops(traj.e_count) = mean([poits.dop]);
    end
    
    
    
    
    timestamp = current_tend;
    if interp_flag
        X = X2;
        if isempty(traj.fil)
            traj.fil = filter_new(X, timestamp);
        else
            if traj.fil.skipped > 3
                traj.fil = filter_reset(traj.fil, X, timestamp);
            else
                traj.fil = filter_one_step(traj.fil, X, timestamp, diag(diag(R)));
            end
            
        end
    else
%         if approx_flag && ~isempty(traj.fil)
%             X1 = traj_extrapolation(X_appr, current_tend - current_t0);
%             R = eye(6);
%             R(1,1) = 10^2;
%             R(3,3) = 10^2;
%             R(5,5) = 10^2;
%             R(2,2) = 0.5^2;
%             R(4,4) = 0.5^2;
%             R(6,6) = 0.5^2;
%             if traj.fil.skipped > 3
%                 traj.fil = filter_reset(traj.fil, X1, timestamp);
%             else
%                 traj.fil = filter_one_step(traj.fil, X1, timestamp, R);
%             end
%             
%         end
    end
    
   
    
    
     
    
end

