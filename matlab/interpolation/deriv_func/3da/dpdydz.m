function [f] = dpdydz(y,x,t,i,j, config)
    Sn = config.sigma_n_ns;
    X = config.posts;
    % производная частного (первое слагаемое в dp/dx
    f1 = - 1/Sn^2 * y * 1/config.c_ns * (y_t(x,t) - X(2,i))*(z_t(x,t) - X(3,i))/R_t(x, t, X(:,i))^3/2;
    % производная произведения (второе слагаемое слагаемое в dp/dx
    % сначала произодная частного во втором множителе
    f3 = - (y_t(x,t) - X(2,i))*(z_t(x,t) - X(3,i))/R_t(x, t, X(:,i))^3/2;
    f2 = 1/Sn^2 * 1/config.c_ns * ( 1/config.c_ns * (z_t(x,t) - X(3,i))/R_t(x, t, X(:,i)) * (y_t(x,t) - X(2,i))/R_t(x, t, X(:,i)) + S_t(x, t, i, j, config) * f3);
    f = f1 - f2;
end

