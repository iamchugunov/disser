function [X] = traj_make_approx(cord, config)
    
    k1 = size(cord,2);
    
    T = cord(4,1:k1)/config.c;
    X = cord(1,1:k1);
    Y = cord(2,1:k1);
    Z = cord(3,1:k1);
    
    A(1,1) = k1;
    A(1,2) = 0;
    A(2,2) = 0;
    for i = 1:k1
        A(1,2) = A(1,2) + T(i);
        A(2,2) = A(2,2) + T(i)^2;
    end
    A(2,1) = A(1,2);
    
    bx = [0;0];
    by = [0;0];
    bz = [0;0];
    for i = 1:k1
        bx(1) = bx(1) + X(i);
        bx(2) = bx(2) + T(i)*X(i);
        by(1) = by(1) + Y(i);
        by(2) = by(2) + T(i)*Y(i);
        bz(1) = bz(1) + Z(i);
        bz(2) = bz(2) + T(i)*Z(i);
    end
    ax = A\bx;
    ay = A\by;
    az = A\bz;
    X = [ax(1);ax(2); 0; ay(1);ay(2); 0; az(1); az(2); 0];
end

