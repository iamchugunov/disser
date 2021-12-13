function f = dpdx(y,x,t,i,j,config)
    Sn = config.sigma_n;
    X = config.posts(:,i);
    f = (1/Sn^2) * (x_t(x,t) - X(1)) * ( y/R_t(x, t, X, config) - 1 );
end

