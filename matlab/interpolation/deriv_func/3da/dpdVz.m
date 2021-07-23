function [f] = dpdVz(y,x,t,i,j, config)
    f = dpdz(y,x,t,i,j, config) * t;
end

