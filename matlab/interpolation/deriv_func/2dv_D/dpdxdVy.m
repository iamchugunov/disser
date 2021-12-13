function f = dpdxdVy(y,x,t,i,j,config)
    f = dpdxdy(y,x,t,i,j,config) * t;
end







