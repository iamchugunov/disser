function f = R_t(x, t, X, config)
    f = sqrt((x_t(x,t) - X(1))^2 + (y_t(x,t) - X(2))^2 + (config.hei - X(3))^2);
end

