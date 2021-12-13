function f = dpdVx(y,x,t,i,j,config)
    f = dpdx(y,x,t,i,j,config) * t;
end



