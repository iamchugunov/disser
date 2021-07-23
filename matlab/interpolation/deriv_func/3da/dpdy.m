function [f] = dpdy(y,x,t,i,j, config)
    Sn = config.sigma_n_ns;
    X = config.posts;
    f = 1/Sn^2 * y * 1/config.c_ns * (y_t(x, t) - X(2,i))/R_t(x, t, X(:,i)) - 1/Sn^2 * S_t(x, t, i, j, config) * 1/config.c_ns * (y_t(x, t) - X(2,i))/R_t(x, t, X(:,i));
end

