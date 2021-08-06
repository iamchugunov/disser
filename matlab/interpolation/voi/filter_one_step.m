function [fil] = filter_one_step(fil, X, t, Dn)
    dt = t - fil.t_last;
    if dt < 0
        return
    end
    [Xnew, Dxnew, discr] = Kalman_step_3D(X([1 2 4 5 7 8],:), fil.cur_SV, fil.Dx, dt, Dn, fil.Dksi);
    if norm(discr([1 3 5])) > 1e4 
        fil.skipped = fil.skipped + 1;
    else
        fil.skipped = 0;
        fil.count = fil.count + 1;
        fil.cur_SV = Xnew;
        fil.Dx = Dxnew;
        fil.SV(:,fil.count) = Xnew;
        fil.nev(:,fil.count) = discr;
        fil.nev_all(:,fil.count) = norm(discr);
        fil.nev_coords(:,fil.count) = norm(discr([1 3 5]));
        fil.t_last = t;
        fil.timestamps(:,fil.count) = t;
    end
end

