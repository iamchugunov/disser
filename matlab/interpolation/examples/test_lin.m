a = 1;
b = 1;
Sn = 0.1;
t = 0.1:0.1:10;
x = a * t + b;
y = x + normrnd(0, Sn,[1 length(t)]);
% plot(t,y)
% hold on
% plot(t,x)


a = 0.9:0.01:1.1;
a = 1;
b = 0.9:0.01:1.1;
% b = 1;
po = zeros(length(a), length(b));
for j = 1:length(a)
    for k = 1:length(b)
        for i = 1:length(t)
            po(j,k) = po(j,k) + 1/(Sn^2) * y(i) * (a(j) * t(i) + b(k)) - 1/(2 * Sn^2) * ( a(j) * t(i) + b(k) )^2;
        end
    end
end