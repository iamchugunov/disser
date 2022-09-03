%%

addpath('D:\Projects\voi-matlab')
[ config ] = Config( );
config.PostsENU = config.posts;
%%
[track] = make_track(config);
for i = 1:length(track.poits)
    track.poits(i).rd(1,1) = track.poits(i).ToA(4) - track.poits(i).ToA(1);
    track.poits(i).rd(2,1) = track.poits(i).ToA(4) - track.poits(i).ToA(2);
    track.poits(i).rd(3,1) = track.poits(i).ToA(4) - track.poits(i).ToA(3);
    track.poits(i).rd(4,1) = track.poits(i).ToA(3) - track.poits(i).ToA(1);
    track.poits(i).rd(5,1) = track.poits(i).ToA(3) - track.poits(i).ToA(2);
    track.poits(i).rd(6,1) = track.poits(i).ToA(2) - track.poits(i).ToA(1);
    track.poits(i).rd = track.poits(i).rd * config.c_ns;
end
%%
n1 = 1;
n2 = 232;
Xtrue = track.SV([1 2 4 5 7 8],n1:n2);
poits = track.poits(n1:n2);
% poits = thinning_poits2(poits);
plot(config.PostsENU(1,:),config.PostsENU(2,:),'v')
hold on
plot(Xtrue(1,:),Xtrue(3,:),'k.-')
%%
[X0, X, x, k, R] = process_poits(poits, config, Xtrue(:,1));
t = [poits.Frame] - poits(1).Frame;
Xest = X;
Xini = X0;
for i = 2:length(poits)
    dt = t(i) - t(i-1);
    Xest(1,i) = Xest(1,i-1) + Xest(2,i-1) * dt;
    Xest(2,i) = Xest(2,i-1);
    Xest(3,i) = Xest(3,i-1) + Xest(4,i-1) * dt;
    Xest(4,i) = Xest(4,i-1);
    Xest(5,i) = Xest(5,i-1) + Xest(6,i-1) * dt;
    Xest(6,i) = Xest(6,i-1);
    
    Xini(1,i) = Xini(1,i-1) + Xini(2,i-1) * dt;
    Xini(2,i) = Xini(2,i-1);
    Xini(3,i) = Xini(3,i-1) + Xini(4,i-1) * dt;
    Xini(4,i) = Xini(4,i-1);
    Xini(5,i) = Xini(5,i-1) + Xini(6,i-1) * dt;
    Xini(6,i) = Xini(6,i-1);
end

figure(1)
plot(config.PostsENU(1,:),config.PostsENU(2,:),'v')
hold on
plot(x(1,:),x(2,:),'.m')
plot(Xtrue(1,:),Xtrue(3,:),'k.-')
plot(Xest(1,:),Xest(3,:),'r.-')
plot(Xini(1,:),Xini(3,:),'b.-')
grid on
daspect([1 1 1])
%%
rd = [];
for i = 1:length(poits)
    r = [];
    for j = 1:4
        r(j,1) = norm(Xest([1 3 5],i) - config.posts(:,j));
    end
    
    rd(:,i) = [r(4) - r(1);
        r(4) - r(2);
        r(4) - r(3);
        r(3) - r(1);
        r(3) - r(2);
        r(2) - r(1);];
end
figure
get_rd_from_poits(poits)
hold on
plot(t,rd'/1000)
%%
k = 0;
X0 = [];
X = [];
Xtrue = [];
R = [];
for i = 1:5:length(track.poits)-101
    k = k + 1
    n1 = i;
    n2 = i+100;
    poits = track.poits(n1:n2);
%     poits = thinning_poits(poits);
    [X0(:,k), X(:,k), x, K(k), R(:,k)] = process_poits(poits, config, track.SV([1 2 4 5 7 8],i));
    Xtrue(:,k) = track.SV([1 2 4 5 7 8],i);
end

