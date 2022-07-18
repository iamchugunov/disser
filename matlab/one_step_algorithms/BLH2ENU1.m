function [ c ] = BLH2ENU1( a, b )
    x_op = lla2ecef1(b);
    x = lla2ecef1(a);
    B = b(1)*pi/180;
    L = b(2)*pi/180;
    h = b(3);
    R = [-sin(L) cos(L) 0;
        -sin(B)*cos(L) -sin(B)*sin(L) cos(B);
        cos(B)*cos(L) cos(B)*sin(L) sin(B);];
    c = R * (x - x_op);
end



