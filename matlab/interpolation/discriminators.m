function [] = discriminators(X, poits, config)
    y = [];
    for i = 1:length(poits)
        t(i) = poits(i).Frame;
        y(:,i) = poits(i).rd;
    end
    N = size(y,2); 
    rds = [4 1;
           4 2;
           4 3;
           3 1;
           3 2;
           2 1;];
       
    x_ = -400e3:1e3:400e3;
    y_ = -400e3:1e3:400e3;
    z_ = -5e3:500:15e3;
    vx = -300:10:300;
    vy = -300:10:300;
    vz = -50:5:50;
    
    dx = zeros(1,length(x_));
    dy = zeros(1,length(y_));
    dz = zeros(1,length(z_));
    dvx = zeros(1,length(vx));
    dvy = zeros(1,length(vy));
    dvz = zeros(1,length(vz));
                    
    for k = 1:length(x_)
        X_6 = X;
        X_6(1) = x_(k);
        for j = 1:N
            for i = 1:size(y,1)
                if y(i,j) ~= 0
                    t_k = t(j)-t(1);
                    dx(k) = dx(k) + (df_tdx(y(i,j),X_6,t_k,rds(i,1),rds(i,2), config));
                end
            end
        end
    end
    
    for k = 1:length(y_)
        X_6 = X;
        X_6(3) = y_(k);
        for j = 1:N
            for i = 1:size(y,1)
                if y(i,j) ~= 0
                    t_k = t(j)-t(1);
                    dy(k) = dy(k) + df_tdy(y(i,j),X_6,t_k,rds(i,1),rds(i,2), config);
                end
            end
        end
    end
    
    for k = 1:length(z_)
        X_6 = X;
        X_6(5) = z_(k);
        for j = 1:N
            for i = 1:size(y,1)
                if y(i,j) ~= 0
                    t_k = t(j)-t(1);
                    dz(k) = dz(k) + df_tdz(y(i,j),X_6,t_k,rds(i,1),rds(i,2), config);
                end
            end
        end
    end
    
    for k = 1:length(vx)
        X_6 = X;
        X_6(2) = vx(k);
        for j = 1:N
            for i = 1:size(y,1)
                if y(i,j) ~= 0
                    t_k = t(j)-t(1);
                    dvx(k) = dvx(k) + df_tdVx(y(i,j),X_6,t_k,rds(i,1),rds(i,2), config);
                end
            end
        end
    end
    
    for k = 1:length(vy)
        X_6 = X;
        X_6(4) = vy(k);
        for j = 1:N
            for i = 1:size(y,1)
                if y(i,j) ~= 0
                    t_k = t(j)-t(1);
                    dvy(k) = dvy(k) + df_tdVy(y(i,j),X_6,t_k,rds(i,1),rds(i,2), config);
                end
            end
        end
    end
    
    for k = 1:length(vz)
        X_6 = X;
        X_6(6) = vz(k);
        for j = 1:N
            for i = 1:size(y,1)
                if y(i,j) ~= 0
                    t_k = t(j)-t(1);
                    dvz(k) = dvz(k) + df_tdVz(y(i,j),X_6,t_k,rds(i,1),rds(i,2), config);
                end
            end
        end
    end
    
    figure
    subplot(321)
    plot(x_/1000,dx,'.-')
    grid on
    hold on
    plot([X(1) X(1)]/1000,[min(dx) max(dx)],'-g')
    plot([x_(1) x_(end)]/1000,[0 0],'-g')
    subplot(322)
    plot(vx,dvx,'.-')
    grid on
    hold on
    plot([X(2) X(2)],[min(dvx) max(dvx)],'-g')
    plot([vx(1) vx(end)],[0 0],'-g')
    subplot(323)
    plot(y_/1000,dy,'.-')
    grid on
    hold on
    plot([X(3) X(3)]/1000,[min(dy) max(dy)],'-g')
    plot([y_(1) y_(end)]/1000,[0 0],'-g')
    subplot(324)
    plot(vy,dvy,'.-')
    grid on
    hold on
    plot([X(4) X(4)],[min(dvy) max(dvy)],'-g')
    plot([vy(1) vy(end)],[0 0],'-g')
    subplot(325)
    plot(z_/1000,dz,'.-')
    grid on
    hold on
    plot([X(5) X(5)]/1000,[min(dz) max(dz)],'-g')
    plot([z_(1) z_(end)]/1000,[0 0],'-g')
    subplot(326)
    plot(vz,dvz,'.-')
    grid on
    hold on
    plot([X(6) X(6)],[min(dvz) max(dvz)],'-g')
    plot([vz(1) vz(end)],[0 0],'-g')
end

