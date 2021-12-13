function f = dpdxdx(y,x,t,i,j,config)
    Sn = config.sigma_n;
    X = config.posts(:,i);
    f = (1/Sn^2) * ( y * ( R_t(x, t, X, config) - (x_t(x,t) - X(1))^2/R_t(x, t, X, config) )/R_t(x, t, X, config)^2  - 1 );
end
