[ config ] = Config( );
addpath('D:\Projects\disser\matlab\interpolation\math')
addpath("D:\Projects\disser\matlab\interpolation\deriv_func\2dv_D")   

config.posts(:,1) = [0;0; 5];
config.posts(:,2) = [10;0; 5];
config.posts(:,3) = [0;10; 5];
config.posts(:,4) = [10;10; 5];

config.sigma_n = 0.3;
config.sigma_n_ns = 0;
config.hei = 2;
config.V = 0.5;
config.n_periods = 0;
config.period_sec = 0.1;
config.lifetime = 10;

config.max_coord = 10;

[track] = make_track(config);

plot3(config.posts(1,:),config.posts(2,:),config.posts(3,:),'vk')
hold on
plot3(track.SV(1,:),track.SV(4,:),track.SV(7,:),'.-')
grid on
view(2)
zlim([0 5])

for i = 1:length(track.ToT)
    r(:,i) = config.c*(track.poits(i).Frame + track.poits(i).ToA/1e9 - track.ToT(i));
    t(i) = track.ToT(i);
end

% r = r(:,1:10);
% t = t(:,1:10);

% y = r;
% X0 = track.SV([1 2 4 5],1);
% x0 = -20:0.1:20;
% v
% discr_x = zeros(1,length(x0));
% X = X0;
% % X(2) = X(2);
% for k = 1:length(x0)
%     X(1) = x0(k);
%     for j = 1:size(y,2)
%             for i = 1:size(y,1)
%                 if y(i,j)
%                     t_k = t(j) - t(1);
%                     discr_x(k) = discr_x(k) + dpdVx(y(i,j),X,t_k,i,j, config);
%                 end
%             end
%     end
% end
% 
% plot(x0,discr_x)
% grid on
% hold on
% plot(X0(1),0,'x')

% X0 = track.SV([1 2 4 5],1);
% vx0 = -5:0.05:5;
% discr_Vx = zeros(1,length(vx0));
% X = X0;
% for k = 1:length(vx0)
%     X(2) = vx0(k);
%     for j = 1:size(y,2)
%             for i = 1:size(y,1)
%                 if y(i,j)
%                     t_k = t(j);
%                     discr_Vx(k) = discr_Vx(k) + dpdVx(y(i,j),X,t_k,i,j, config);
%                 end
%             end
%     end
% end
% 
% plot(vx0,discr_Vx)
% grid on
% hold on
% plot(X0(2),0,'x')

y = r + normrnd(0, config.sigma_n, [4, size(r,2)]);   
for j = 1:size(y,2)
    [Xmnk(:,j), dop] = NavSolver_D(y(:,j), config.posts, [0;0], config.hei);
end
plot(Xmnk(1,:),Xmnk(2,:),'.')
X0 = track.SV([1 2 4 5],1);
for i = 1:100
    y = r + normrnd(0, config.sigma_n, [4, size(r,2)]);
    X0(2) = normrnd(0,100);
    X0(4) = normrnd(0,100);
    [X, R] = max_likelyhood2dv_D(y, t, config, X0);
    plot([X(1) X(1) + X(2) * (t(end) - t(1))],[X(3) X(3) + X(4) * (t(end) - t(1))],'-')
    plot(X(1),X(3),'o')
    [X0 X]
    X1(:,i) = X;
    D(:,i) = diag(R);
end

% plot(y')
% hold on