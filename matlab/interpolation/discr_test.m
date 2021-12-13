[ config ] = Config( );
addpath('voi')
addpath('math')
addpath("D:\github\disser\matlab\interpolation\deriv_func\3da") 
config.period_sec = 0.1; 
config.n_periods = 0;
config.lifetime = 10;
config.frame_length_sec = 10;
config.sigma_n_ns = 0;
config.sigma_n_sec = config.sigma_n_ns /1e9;
config.sigma_n_m = config.sigma_n_sec * config.c;
[track] = make_track(config);
y = [];
N = 10;
for i = 1:N
    y(:,i) = track.poits(i).ToA;
end

subplot(121)
plot(config.posts(1,:),config.posts(2,:),'v')
hold on
plot(track.SV(1,1:N),track.SV(4,1:N),'.-k')
daspect([1 1 1])
subplot(122)
plot(track.SV(1,1:N),track.SV(4,1:N),'.-k')
hold on
config.sigma_n_ns = 30;
config.sigma_n_sec = config.sigma_n_ns /1e9;
config.sigma_n_m = config.sigma_n_sec * config.c;


PD = y(:,1) * config.c_ns;
[cord, dop, nev, flag] = coord_solver2D(PD, config.posts, [0;0;0], config.hei);
cord(3) = config.hei;
delta = [norm(cord - config.posts(:,1)); norm(cord - config.posts(:,2)); norm(cord - config.posts(:,3)); norm(cord - config.posts(:,4));];
delta = delta/config.c_ns;


T0 = track.ToT(1:N) * 1e9 + normrnd(-10000*0, config.sigma_n_ns*0, [1 N]);
% X0(1) = X0(1) + 10000;
for i = 1:100
    X0 = track.SV(:,1);
X0(1) = X0(1) + normrnd(0,1000);
X0(4) = X0(4) + normrnd(0,1000);
X0(7) = X0(7) + normrnd(0,1000);
X0(2) = X0(2) + normrnd(0,30);
X0(5) = X0(5) + normrnd(0,30);
X0(8) = X0(8) + normrnd(0,30);
    Y = y + normrnd(0, config.sigma_n_ns, [4 N]);
    [X, R] = max_likelyhood3dv(Y, config, X0, T0);
    err(:,i) = X([1 2 4 5 7 8])-track.SV([1 2 4 5 7 8],1);
    RR(:,i) = diag(R);
    [X([1 2 4 5 7 8])-X0([1 2 4 5 7 8]) diag(R)]
end

X1 = track.SV(1,1)-10000:1000:track.SV(1,1)+10000;
% X1 = -1000:1:1000;
for k = 1:length(X1)
    X0(1) = X1(k);
    t0 = 0;
    dd(k) = 0;
        for j = 1:N
            for i = 1:size(y,1)
                if y(i,j)
                    t_k = (y(i,j) - t0)*1e-9;
                    X_9 = X0;
                    X_9(10:9+N) = track.ToT(1:N)*1e9 + normrnd(-10000,config.sigma_n_ns,[1 N]);
%                     X_9(10:9+N) = max(y)-delta;
%                     X_9(10)  = X1(k);
%                     X_9(10:9+N) = y(1,:) - delta(1);
                    
                    dd(k) = dd(k) +  dpdx(y(i,j),X_9,t_k,i,j, config);
                end
            end
        end
end
plot(X1,dd)
grid on
hold on
plot(track.SV(1,1),0,'x')