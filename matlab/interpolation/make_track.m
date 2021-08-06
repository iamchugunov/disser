function [track] = make_track(config)
      
    current_t = 0;
    k = 0;
    while current_t < config.lifetime
        k = k + 1;
        ToT(k) = current_t + config.period_sec * ( 1 + randi([0 config.n_periods]) );
        current_t = ToT(k);
    end
    
    N = length(ToT);
    SV = zeros(9,N);
    
    % initialization
    SV(1,1) = randi([-config.max_coord config.max_coord]);
    SV(4,1) = randi([-config.max_coord config.max_coord]);
    SV(7,1) = config.hei;
    angle = randi([0 2*314])/100;
    SV(2,1) = config.V * cos(angle);
    SV(3,1) = 0;
    SV(5,1) = config.V * sin(angle);
    SV(6,1) = 0;
    SV(8,1) = 0;
    SV(9,1) = 0;
    
    SV(1,1) = -50e3;
    SV(4,1)  =-50e3;
    SV(2,1) = 150;
    SV(5,1) = 150;
    
    for i = 2:N
        dt = ToT(i) - ToT(i-1);
        F1 = [1 dt dt^2/2;
              0  1  dt;
              0  0   1];
        F0 = zeros(3,3);
        F = [F1 F0 F0;
             F0 F1 F0;
             F0 F0 F1];
        SV(:,i) = F * SV(:,i-1);
    end
    
    poit = struct('Frame', 0,'ToA', zeros(size(config.posts,2),1),'coords', zeros(4,1),'xy_valid',0,'valid_to_traj',0,'dop',0,'count',0,'freq',0,'Smode',1);
    poits = repmat(poit,1,N);
    
    for i = 1:N
        poits(i).Frame = config.frame_length_sec * floor(ToT(i)/config.frame_length_sec);
        for j = 1:size(config.posts,2)
            poits(i).ToA(j) =  (ToT(i) - poits(i).Frame)*1e9 + norm(SV([1 4 7],i) - config.posts(:,j)) /config.c_ns + normrnd(0,config.sigma_n_ns);
        end
        poits(i).count = 4;
    end
        
    track.SV = SV;
    track.ToT = ToT;
    track.poits = poits;
    
end

