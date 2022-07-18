function o = lla2ecef1(i)
    a = 6378136.6;
    f = 1/298.257223563;
    B = i(1)*pi/180;
    L = i(2)*pi/180;
    H = i(3);
    e2 = f*(2-f);
    x = (a/sqrt(1-e2*sin(B)^2)+H)*cos(B)*cos(L);
    y = (a/sqrt(1-e2*sin(B)^2)+H)*cos(B)*sin(L);
    z = (a*(1-e2)/sqrt(1-e2*sin(B)^2)+H)*sin(B);
    o(1,1) = x;
    o(2,1) = y;
    o(3,1) = z;
end

