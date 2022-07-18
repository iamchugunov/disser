function [track] = make_measurements_for_track(track, config)
%     period_sec = 0.04;
%     n_periods = 20;
    period_sec = 1;
    n_periods = 0;
    
    t = track.t;
    current_t = t(1);
    k = 0;
    while current_t < t(end)
        k = k + 1;
        ToT(k) = current_t + period_sec * ( 1 + randi([0 n_periods]) );
        current_t = ToT(k);
    end
    
    poits = [];
    posts = config.posts;
    for k = 1:length(ToT)
        nums = find(t < ToT(k));
        coords = track.coords(:,nums(end));
        V = track.V(:,nums(end));
        dt = ToT(k) - t(nums(end));
        
        SV(:,k) = [ coords(1,:) + V(1,:) * dt; V(1,:);
            coords(2,:) + V(2,:) * dt; V(2,:);
            coords(3,:) + V(3,:) * dt; V(3,:);];
        
        poit = [];
        poit.Frame = t(nums(end));
        
        Ranges = [];
        ToA = [];
        for i = 1:length(posts)
            Ranges(i,1) = norm(posts(:,i) - SV([1 3 5],k));
            ToA(i,1) = Ranges(i,1)/config.c + ToT(k);
        end
        ToA = mod(ToA,0.01);
        ToA = ToA * 1e9;
        ToA = ToA + normrnd(0, config.sigma_n_ns, [4, 1]);
        ToA = round(ToA);
        rd = [];
        rd(1,1) = (ToA(4) - ToA(1))*config.c_ns;
        rd(2,1) = (ToA(4) - ToA(2))*config.c_ns;
        rd(3,1) = (ToA(4) - ToA(3))*config.c_ns;
        rd(4,1) = (ToA(3) - ToA(1))*config.c_ns;
        rd(5,1) = (ToA(3) - ToA(2))*config.c_ns;
        rd(6,1) = (ToA(2) - ToA(1))*config.c_ns;
        poit.ToA = ToA;
        poit.Ranges = Ranges;
        poit.rd = rd;
        poit.rd_flag = ones(6,1);
        poit.count = 4;
        poit.ToT = ToT(k);
        poit.true_coords = SV(:,k);
        poits = [poits poit];
    end
    track.poits = poits;
end

