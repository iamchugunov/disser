function [traj] = traj_new(poit, config)
    
    traj.mode = 0; % 0 - завязка, 1 - траектория
    
    traj.p_count = 1; % число отметок траектории
    traj.lifetime = 0; % время жизни траектории
    traj.t0 = poit.Frame; % время начала траектории
    traj.ID = poit.Smode; % ID траектории
    traj.poits = poit; % список отметок
    traj.e_count = 0; % число решений
    traj.t_current = poit.Frame; % время кадра последней метки
    traj.t_last = poit.Frame; % время последнего решения
    traj.T_nak = config.T_nak; % время накопления
    traj.T_est = config.T_est; % темп отрешивания
    traj.freq = poit.freq; % массив частот
    traj.modes_count = 0;
    if poit.freq == 1090
       traj.modes_count = traj.modes_count + 1;  % число модесов
    end 
    traj.modes_percent = round(traj.modes_count/traj.p_count,2) * 100;% процент модесов
    
    if poit.count == 4
        traj.last_4 = poit; % последняя четверка
        traj.last_4_flag = 1; % флаг последней четверки
    else
        traj.last_4 = [];
        traj.last_4_flag = 0;
    end
    
    if poit.xy_valid
        traj.xy_valid = 1;
    else
        traj.xy_valid = 0;
    end
    
    traj.SV_approx = []; % массив ВС аппроксимаций
    traj.SV_interp = []; % массив ВС интерполяций
    traj.current_SV_approx = []; % текущий ВС аппроксимации
    traj.current_SV_interp = []; % текущий ВС интерполяций
    traj.timestamps = []; % времена решений
    
    
end

