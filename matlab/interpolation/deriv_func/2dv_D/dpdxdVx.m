function f = dpdxdVx(y,x,t,i,j,config)
    f = dpdxdx(y,x,t,i,j,config) * t;
end





