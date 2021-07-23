function [current_t0, current_tend, cord, X1, X, R, x_aprox, x_interp] = one_estimation(poits,config)
    
    k = length(poits);
    current_t0 = poits(1).Frame;
    current_tend = poits(end).Frame;
    
    y = zeros(4,k);
    cord = zeros(4,k);
    k1 = 0;
    
    for i = 1:k
        for j = 1:4
            if poits(i).ToA(j) > 0
                y(j,i) = (poits(i).Frame - poits(1).Frame) * 1e9 + poits(i).ToA(j);
            end
        end
        if poits(i).xy_valid
            k1 = k1 + 1;
            cord(:,k1) = poits(i).coords;
            cord(4,k1) = cord(4,k1) + (poits(i).Frame - current_t0) * config.c;
        end
    end
    
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
    X1 = [ax(1);ax(2); 0; ay(1);ay(2); 0; az(1); az(2); 0];
    
    for i = 1:length(y(1,:))
        rand_number = rand;
        if rand_number > 0.75
            
        elseif rand_number > 0.4
           y(randi([1 4]),i) = 0;
        else
           y(randi([1 4]),i) = 0;
           y(randi([1 4]),i) = 0;
        end
    end
%     y(1:2,2:end-1) = 0;
    [X, R] = max_likelyhood3dv(y, config, X1);
    
    dt = poits(end).Frame - current_t0;
    
    x_aprox = [X1(1,1) X1(1,1) + X1(2,1) * dt + X1(3,1) * dt^2/2;
            X1(4,1) X1(4,1) + X1(5,1) * dt + X1(6,1) * dt^2/2;
            X1(7,1) X1(7,1) + X1(8,1) * dt + X1(9,1) * dt^2/2;];
    x_interp = [X(1,1) X(1,1) + X(2,1) * dt + X(3,1) * dt^2/2;
            X(4,1) X(4,1) + X(5,1) * dt + X(6,1) * dt^2/2;
            X(7,1) X(7,1) + X(8,1) * dt + X(9,1) * dt^2/2;];   
    
        
    
    
    
end

