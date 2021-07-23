function [f] = dpdVy(y,x,t,i,j, config)
    f = dpdy(y,x,t,i,j, config) * t;
end

