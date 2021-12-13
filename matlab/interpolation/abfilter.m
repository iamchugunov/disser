function [Xf] = abfilter(X)
a = 0.9;
b = 0.5;

Xf(:,1) = X(:,1);
for i = 2:length(X)
    Xf(1,i) = (1 - a) * X(1,i) + a * ( Xf(1,i-1) + Xf(2,i-1) * 5 );
    Xf(2,i) = (1 - b) * X(2,i) + b * Xf(2,i-1);
end

end

