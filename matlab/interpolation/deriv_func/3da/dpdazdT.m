function [f] = dpdazdT(y,x,t,i,j, config)
    f = dpdzdT(y,x,t,i,j, config) * t^2/2;
end

