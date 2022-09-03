function [koef, sko, RD] = mnk_step(t, rd, order)
    b = zeros(order+1,1);
    A = zeros(order+1,order+1);
    for j = 1:(order+1)
        for i = 1:length(t)
            b(j) = b(j) + rd(i) * t(i)^(j - 1);
        end
        
        for k = 1:(order+1)
            for i = 1:length(t)
                A(j,k) = A(j,k) + t(i)^(j + k - 2);
            end
        end
    end
    
    koef = inv(A) * b;
    
    RD = zeros(length(t),1);
    for i = 1:length(t)
        for j = 1:length(koef)
            RD(i,1) = RD(i,1) + koef(j) * t(i)^(j - 1);
        end
    end
    
    sko = 0;
    for i = 1:length(t)
        sko = sko + (RD(i) - rd(i))^2;
    end
    sko = sqrt(sko/length(t));
    
end



