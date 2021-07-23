function [f] = dpdaxdT(y,x,t,i,j, config)
    f = dpdxdT(y,x,t,i,j, config) * t^2/2;
end

