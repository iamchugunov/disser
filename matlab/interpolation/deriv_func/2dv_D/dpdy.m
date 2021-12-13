function f = dpdy(y,x,t,i,j,config)
    Sn = config.sigma_n;
    X = config.posts(:,i);
    f = (1/Sn^2) * (y_t(x,t) - X(2)) * ( y/R_t(x, t, X, config) - 1 );
end



