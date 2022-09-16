function [X] = calculate_geo_heigth(config, x, y, h)
    Rz = 6371e3;
    c = x^2 + y^2 - 2*h*Rz - h^2;
    D = 4*Rz^2 - 4* c;
    Z = -Rz + sqrt(D)/2;
    X = [x;y;Z];
end

