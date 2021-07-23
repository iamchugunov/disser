function [f] = dpdaz(y,x,t,i,j, config)
    f = dpdz(y,x,t,i,j, config) * t^2/2;
end

