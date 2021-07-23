function [f] = dpdydT(y,x,t,i,j, config)
    Sn = config.sigma_n_ns;
    X = config.posts;
    f = - 1/Sn^2 * 1/config.c_ns * (y_t(x,t) - X(2,i))/R_t(x, t, X(:,i));
end

