function [f] = dpdT(y,x,t,i,j, config)
    Sn = config.sigma_n_ns;
    f = 1/Sn^2 * y - 1/Sn^2 * S_t(x, t, i, j, config);
end

