function [out] = make_hyperb(X1, X2, RD, z)
%     RD = R1 - R2
%     R1 = 0.1:0.001:60;
    R1 = 0:10:400000;
    out = [];
    for i = 1:length(R1)
        R2 = R1(i) - RD;
        out = [out circles_intersec(X1, X2, R1(i), R2, z)];
    end
end

