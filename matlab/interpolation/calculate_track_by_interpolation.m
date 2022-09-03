function [indata] = calculate_track_by_interpolation(track, config, T_est, T_nak)
    k = 0;
    X0 = [];
    X = [];
    Xtrue = [];
    R = [];
    t = [];
    
    t_last = -1e9;
    
    nums = find([track.poits.Frame] > track.poits(end).Frame - T_nak);
    n_end = nums(1);
    for i = 1:n_end
        if track.poits(i).Frame - t_last < T_est
            continue
        end
        t_last = track.poits(i).Frame;
        n1 = i;
        nums = find([track.poits.Frame] < track.poits(n1).Frame + T_nak);
        n2 = nums(end);
        poits = track.poits(n1:n2);
        %     poits = thinning_poits(poits);
%         [length(find([poits.count]==2)) length(find([poits.count]==3)) length(find([poits.count]==4))]
        xtrue([1 3 5],1) = track.coords(:,i);
        xtrue([2 4 6],1) = track.V(:,i);
        [flag, X0_, X_, x, K_, R_] = process_poits(poits, config, xtrue);
        if isreal(R_) && flag
            k = k + 1;
            X0(:,k) = X0_;
            X(:,k) = X_;
            R(:,k) = R_;
            t(:,k) = track.poits(n1).Frame;
            Xtrue([1 3 5],k) = track.coords(:,i);
            Xtrue([2 4 6],k) = track.V(:,i);
        end

    end
    indata.t = t;
    indata.X = X;
    indata.X0 = X0;
    indata.Xtrue = Xtrue;
    indata.errX = X - Xtrue;
    indata.errX0 = X0 - Xtrue;
    
    rd = [];
    for i = 1:length(X)
        R = [];
        for j = 1:4
            R(j) = norm(X([1 3 5],i) - config.posts(:,j));
        end
        rd(:,i) = [R(4) - R(1);
            R(4) - R(2);
            R(4) - R(3);
            R(3) - R(1);
            R(3) - R(2);
            R(2) - R(1)];
    end
    indata.rd = rd;
    
    rd0 = [];
    for i = 1:length(X0)
        R = [];
        for j = 1:4
            R(j) = norm(X0([1 3 5],i) - config.posts(:,j));
        end
        rd0(:,i) = [R(4) - R(1);
            R(4) - R(2);
            R(4) - R(3);
            R(3) - R(1);
            R(3) - R(2);
            R(2) - R(1)];
    end
    indata.rd0 = rd0;
    
    rd_true = [];
    for i = 1:length(Xtrue)
        R = [];
        for j = 1:4
            R(j) = norm( Xtrue([1 3 5],i) - config.posts(:,j));
        end
        rd_true(:,i) = [R(4) - R(1);
            R(4) - R(2);
            R(4) - R(3);
            R(3) - R(1);
            R(3) - R(2);
            R(2) - R(1);];
    end
    indata.rd_true = rd_true;
    
    indata.rd_err = rd - rd_true;
    indata.rd_err0 = rd0 - rd_true;
%     [std([X0 - Xtrue]')' std([X - Xtrue]')' std([X0 - Xtrue]')'./std([X - Xtrue]')']
%     plot3(config.PostsENU(1,:),config.PostsENU(2,:),config.PostsENU(3,:),'v')
%     hold on
%     plot3(Xtrue(1,:),Xtrue(3,:),Xtrue(5,:),'k.-')
%     plot3(X(1,:),X(3,:),X(5,:),'r.-')
%     plot3(X0(1,:),X0(3,:),X0(5,:),'b.-')
%     view(2)
end

