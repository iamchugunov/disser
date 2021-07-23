function [f] = dpdax(y,x,t,i,j, config)
    f = dpdx(y,x,t,i,j, config) * t^2/2;
end

