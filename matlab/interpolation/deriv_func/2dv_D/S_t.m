function [f] = S_t(x, t, i, j, config)
    X = config.posts(:,i);
    f = R_t(x, t, X, config);
end

