function f = dpdxdy(y,x,t,i,j,config)
    Sn = config.sigma_n;
    X = config.posts(:,i);
    f = -(1/Sn^2) * y * (x_t(x,t) - X(1)) * (y_t(x,t) - X(2))/R_t(x, t, X, config)^3;
end


