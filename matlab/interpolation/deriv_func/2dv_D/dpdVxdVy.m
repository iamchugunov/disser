function f = dpdVxdVy(y,x,t,i,j,config)
    f = dpdxdy(y,x,t,i,j,config) * t^2;
end

