a = 1;
b = 1;
Sn = 0.1;
t = 0.1:0.1:10;
x = a * log(b*t);
y = x + normrnd(0, Sn,[1 length(t)]);
% plot(t,y)
% hold on
% plot(t,x)


a = 0.9:0.01:1.1;
% a = 4;
b = 0.9:0.01:1.1;
% b = 0.1;
po = zeros(length(a), length(b));
for j = 1:length(a)
    for k = 1:length(b)
        for i = 1:length(t)
            po(j,k) = po(j,k) + 1/(Sn^2) * y(i) * a(j)*log(b(k) * t(i)) - 1/(2 * Sn^2) * (a(j)*log(b(k) * t(i)))^2;
        end
    end
end