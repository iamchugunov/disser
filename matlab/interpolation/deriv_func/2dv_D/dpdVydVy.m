function f = dpdVydVy(y,x,t,i,j,config)
    f = dpdydy(y,x,t,i,j,config) * t^2;
end

