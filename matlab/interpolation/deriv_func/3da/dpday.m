function [f] = dpday(y,x,t,i,j, config)
    f = dpdy(y,x,t,i,j, config) * t^2/2;
end

