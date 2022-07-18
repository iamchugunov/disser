function [out] = circles_intersec(X1, X2, R1, R2, z)

%     alpha = 0:0.01:2*pi;
%     for i = 1:length(alpha)
%         x1(i) = R1 * cos(alpha(i)) + X1(1);
%         y1(i) = R1 * sin(alpha(i)) + X1(2);
%         x2(i) = R2 * cos(alpha(i)) + X2(1);
%         y2(i) = R2 * sin(alpha(i)) + X2(2);
%     end
%     
%     figure
%     hold on
%     grid on
%     plot(x1,y1)
%     plot(x2,y2)
    
    x1 = X1(1);
    y1 = X1(2);
    z1 = X1(3);
    C1 = R1^2 - x1^2 - y1^2 - (z - z1)^2;
    x2 = X2(1);
    y2 = X2(2);
    z2 = X2(3);
    C2 = R2^2 - x2^2 - y2^2 - (z - z2)^2;
    
    if y2 ~= y1
        A = (x1 - x2)/(y2 - y1);
        B = 0.5*(C1 - C2)/(y2 - y1);

        a = 1 + A^2;
        b = 2*A*B - 2*x1 - 2*A*y1;
        c = B^2 - 2*B*y1 - C1;

        D = (b^2 - 4*a*c);

        out = [];
        if D > 0
            out(1,1) = (-b + sqrt(D))/(2*a);
            out(2,1) = A * out(1,1) + B;
            out(3,1) = z;
            out(1,2) = (-b - sqrt(D))/(2*a);
            out(2,2) = A * out(1,2) + B;
            out(3,2) = z;
        elseif D == 0
            out(1,1) = -b/(2*a);
            out(2,1) = A * out(1,1) + B;
            out(3,1) = z;
        end
    else
        x = 0.5*(C1 - C2)/(x2 - x1);
        a = 1;
        b = -2*y1;
        c = x^2 - 2*x1*x -C1;
        D = (b^2 - 4*a*c);

        out = [];
        if D > 0
            out(1,1) = x;
            out(2,1) = (-b + sqrt(D))/(2*a);
            out(3,1) = z;
            out(1,2) = x;
            out(2,2) = (-b - sqrt(D))/(2*a);
            out(3,2) = z;
        elseif D == 0
            out(1,1) = x;
            out(2,1) = -b/(2*a);
            out(3,1) = z;
        end
    end
%     plot(out(1,:),out(2,:),'kx')
end

