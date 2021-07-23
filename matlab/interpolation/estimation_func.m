function [X_aprox,X_interp, timestamp] = estimation_func(track, config)
    
    for i = 1:length(track.poits)
        track.poits(i) = poit_calc(track.poits(i), zeros(4,1), config);
    end

    t0_global = track.poits(1).Frame;
    k = 1;
    while track.poits(k).Frame - t0_global < config.T_nak && k < 200
        k = k + 1;
    end
    
    count = 1;
    [current_t0, current_tend, cord, X1, X, R, x_aprox, x_interp] = one_estimation(track.poits(1:k),config);
    
    X_aprox(:,count) = X1;
    X_interp(:,count) = X;
    timestamp(count) = current_t0;
%     plot3(config.posts(1,:),config.posts(2,:),config.posts(3,:),'v')
%     hold on
%     grid on
%     plot3(track.SV(1,:),track.SV(4,:),track.SV(7,:),'.')
%     plot3(cord(1,:),cord(2,:),cord(3,:),'.')
%     plot3(x_aprox(1,:),x_aprox(2,:),x_aprox(3,:),'.-')
%     plot3(x_interp(1,:),x_interp(2,:),x_interp(3,:),'.-')

      plot(config.posts(1,:),config.posts(2,:),'v')
      hold on
      grid on
      
      plot(track.SV(1,:),track.SV(4,:),'.k')
      plot(cord(1,:),cord(2,:),'.g')
      plot(x_aprox(1,:),x_aprox(2,:),'r.-')
      plot(x_interp(1,:),x_interp(2,:),'b.-')
        
      try
          while 1
              nums = find([track.poits.Frame] > current_tend);
              k1 = nums(1);
              k2 = 0;
              while track.poits(k1+k2).Frame - track.poits(k1).Frame < config.T_nak && k2 < 200
                  k2 = k2 + 1;
              end
              [current_t0, current_tend, cord, X1, X, R, x_aprox, x_interp] = one_estimation(track.poits(k1:k1+k2),config);
              plot(cord(1,:),cord(2,:),'.g')
              plot(x_aprox(1,:),x_aprox(2,:),'r.-')
              plot(x_interp(1,:),x_interp(2,:),'b.-')
              count = count + 1;
              X_aprox(:,count) = X1;
              X_interp(:,count) = X;
              timestamp(count) = current_t0;
          end
      catch
          
      end

    
    
    
    
end

