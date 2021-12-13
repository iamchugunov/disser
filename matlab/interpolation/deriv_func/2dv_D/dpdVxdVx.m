function f = dpdVxdVx(y,x,t,i,j,config)
    f = dpdxdx(y,x,t,i,j,config) * t^2;
end

