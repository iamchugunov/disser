%% формируем координаты постов
R = 10e3; %% расстояние между постами
posts = [];
hp = 15;
alphap = [30 150 270]*pi/180;
for i = 1:3
    posts(:,i) = [R * cos(alphap(i)); R * sin(alphap(i)); hp];
end
posts(:,4) = [0;0;hp];
% posts = posts + normrnd(0, 3, [3 4]);
% posts(:,4) = [];
config.posts = posts;
plot(config.posts(1,:),config.posts(2,:),'vk','linewidth',2)
daspect([1 1 1])
%%
h = [];
hdop = [];
pdop = [];
zdop = [];
h = 0:1:100;
for i = 1:length(h)
    DOP = get_dop_value(config, 1e3, 1e3, h(i), 'ToA');
    hdop(i) = DOP.HDOP;
    pdop(i) = DOP.PDOP;
    zdop(i) = DOP.ZDOP;
end
plot(h,hdop)
hold on
plot(h,pdop)
plot(h,zdop)
%%
xdop = [];
ydop = [];
zdop = [];
hdop = [];
% tdop = [];
mesh_points = [];
R = [];
X = -50e3:1e3:50e3;
Y = X;
h_geo = 10000;
k = 0;
for i = 1:length(X)
    for j = 1:length(Y)
        point = calculate_geo_heigth(config, X(i), Y(j), h_geo);
%         point = [X(i);Y(j);10000];
        if point(3) > 0
            k = k + 1;
            mesh_points(:,k) = point;
            R(k) = norm(point(1:2));
            dop = get_dop_value(config, mesh_points(1,k), mesh_points(2,k), mesh_points(3,k), 'ToA2D');
            xdop(j,i) = dop.XDOP;
            ydop(j,i) = dop.YDOP;
%             zdop(j,i) = dop.ZDOP;
            tdop(j,i) = dop.TDOP;
            hdop(j,i) = dop.HDOP;
        else
            xdop(j,i) = NaN;
            ydop(j,i) = NaN;
%             zdop(j,i) = NaN;
            tdop(j,i) = NaN;
            hdop(j,i) = NaN;
        end
    end
end
% plot3(mesh_points(1,:),mesh_points(2,:),mesh_points(3,:),'.')
figure
% contourf(Y/1000,X/1000,hdop,10:20:200,'ShowText','on')
% contourf(Y,X,DOP,[100 300 1000 2000 3000 5000],'ShowText','on')
contourf(X/1000,Y/1000,tdop,[1 2 5 10 20 30 40 50 60 100 150 200 300:100:1000 2000:1000:10000],'ShowText','on')
colormap(jet)
hold on
plot(posts(1,:)/1000,posts(2,:)/1000,'kv','MarkerSize',10,'linewidth',2)
% xlim([-0.5e5 0.5e5]/1000)
% ylim([-0.5e5 0.5e5]/1000)
xlabel('x, km')
ylabel('y, km')
% title('DOP')
set(gca,'FontSize',14)
%colorbar
daspect([1 1 1])
grid on
%%

X = [190e3; 190e3; 10000];
X = calculate_geo_heigth(config, X(1), X(2), 10000);
R = [];
for i = 1:4
    R(i,1) = norm(X - config.posts(:,i));
end

RD = [R(4) - R(1); R(4) - R(2); R(4) - R(3); R(3) - R(1); R(3) - R(2); R(2) - R(1)];

sigma_n = 1;
X3Dtoa = [];
k_3D = 0;
X2Dtoa = [];
k_2D = 0;
Xa1 = [];
Xa2 = [];
k_a = 0;
for i = 1:5000
    toa = R + normrnd(0,sigma_n,[4 1]);
%     rd = RD + normrnd(0,sqrt(2)*sigma_n,[6 1]);
    rd = [toa(4) - toa(1); toa(4) - toa(2); toa(4) - toa(3); toa(3) - toa(1); toa(3) - toa(2); toa(2) - toa(1)];

    [x, ~, ~, flag] = coord_solver3D(toa, config.posts, [X; R(1)]);
%     [x, ~, ~, flag] = coord_solver3D(toa, config.posts, [0;0;100;R(1)]);
    if flag
        k_3D = k_3D + 1;
        X3Dtoa(:,k_3D) = x;
    end
    [x, ~, ~, flag] = coord_solver2D(toa, config.posts, [X(1:2); R(1)],X(3));
    if flag
        k_2D = k_2D + 1;
        X2Dtoa(:,k_2D) = x;
    end
    [x] = solver_analytical_3D_4_posts(toa, config.posts);
    if x
        k_a = k_a + 1;
        Xa1(:,k_a) = x(:,1);
        Xa2(:,k_a) = x(:,2);
    end
%     [X3Dtdoa(:,i)] = NavSolverRDinvh(rd, config.posts, X);
%     [X3DtdoaD(:,i)] = NavSolverRDinvhDn(rd, config.posts, X, sigma_n);
end
dop3Dtoa = get_dop_value(config, X(1), X(2), X(3), 'ToA');
dop2Dtoa = get_dop_value(config, X(1), X(2), X(3), 'ToA2D');
% dop3Dtdoa = get_dop_value(config, X(1), X(2), X(3), 'TDoA');
% dop3DtdoaD = get_dop_value(config, X(1), X(2), X(3), 'TDoA3D_Dn');
% dop2DtdoaD = get_dop_value(config, X(1), X(2), X(3), 'TDoA2D_Dn');
[std(X3Dtoa(1,:))/sigma_n dop3Dtoa.XDOP;
    std(X3Dtoa(2,:))/sigma_n dop3Dtoa.YDOP;
    std(X3Dtoa(3,:))/sigma_n dop3Dtoa.ZDOP;
    std(X3Dtoa(4,:))/sigma_n dop3Dtoa.TDOP;
    norm([std(X3Dtoa(1,:)) std(X3Dtoa(2,:))])/sigma_n dop3Dtoa.HDOP]
[std(X2Dtoa(1,:))/sigma_n dop2Dtoa.XDOP;
    std(X2Dtoa(2,:))/sigma_n dop2Dtoa.YDOP;
    std(X2Dtoa(3,:))/sigma_n dop2Dtoa.TDOP]
% [std(X3Dtdoa(1,:))/(sigma_n*sqrt(2)) dop3Dtdoa.XDOP;
%     std(X3Dtdoa(2,:))/(sigma_n*sqrt(2)) dop3Dtdoa.YDOP;
%     std(X3Dtdoa(3,:))/(sigma_n*sqrt(2)) dop3Dtdoa.ZDOP;]
% [std(X3Dtdoa(1,:))/(sigma_n*sqrt(2)) std(X3DtdoaD(1,:))/(sigma_n*sqrt(2));
%     std(X3Dtdoa(2,:))/(sigma_n*sqrt(2)) std(X3DtdoaD(2,:))/(sigma_n*sqrt(2));
%     std(X3Dtdoa(3,:))/(sigma_n*sqrt(2)) std(X3DtdoaD(3,:))/(sigma_n*sqrt(2));]
% [dop3DtdoaD.XDOP dop3Dtoa.XDOP;
%     dop3DtdoaD.YDOP dop3Dtoa.YDOP;
%     dop3DtdoaD.ZDOP dop3Dtoa.ZDOP;]
% [dop2DtdoaD.XDOP dop2Dtoa.XDOP;
%     dop2DtdoaD.YDOP dop2Dtoa.YDOP;]
[X mean(X3Dtoa(1:3,:)')' mean(X2Dtoa')']
[mean(Xa1')' std(Xa1')'/sigma_n mean(Xa2')' std(Xa2')'/sigma_n]
%% 2D распределение ГФ
xdop = [];
ydop = [];
zdop = [];
hdop = [];
tdop = [];
pdop = [];
Z = [];
mesh_points = [];
R = [];
X = -100e3:1e3:100e3;
Y = X;
h_geo = 10000;
k = 0;
for i = 1:length(X)
    for j = 1:length(Y)
        point = calculate_geo_heigth(config, X(i), Y(j), h_geo);
%          point = [X(i);Y(j);10000];
        Z(j,i) = point(3);
        if point(3) > hp
            k = k + 1;
            mesh_points(:,k) = point;
            R(k) = norm(point);
            dop = get_dop_value(config, mesh_points(1,k), mesh_points(2,k), mesh_points(3,k), 'ToA2D');
            xdop(j,i) = dop.XDOP;%/R(k);
            ydop(j,i) = dop.YDOP;%/R(k);
%             zdop(j,i) = dop.ZDOP;
            tdop(j,i) = dop.TDOP;%/R(k);
            hdop(j,i) = dop.HDOP;%/R(k);
            pdop(j,i) = dop.PDOP;%/R(k);
        else
            xdop(j,i) = NaN;
            ydop(j,i) = NaN;
            zdop(j,i) = NaN;
            tdop(j,i) = NaN;
            hdop(j,i) = NaN;
            pdop(j,i) = NaN;
        end
    end
end
show_dop(X,Y,hdop,[1 10 30 50 100 300 700 1000:1000:3000],[1 2000],config)
%% 1D РАСПРЕДЕЛЕНИЕ ВДОЛЬ РАДИАЛЬНЫХ ЛИНИЙ 
alpha = (-90:30:90)*(pi)/180;
figure(1)
hold on
grid on
figure(2)
hold on
grid on

for j = 1:length(alpha)
    r = 0:1e3:200e3;
    X = r * cos(alpha(j));
    Y = r * sin(alpha(j));
    h_geo = 10000;
    R = [];
    zdop = [];
    tdop =[];
    hdop = [];
    pdop = [];
    mesh_points = [];
    k = 0;
    for i = 1:length(X)
        point = calculate_geo_heigth(config, X(i), Y(i), h_geo);
%             point = [X(i); Y(i); h_geo];
        if point(3) > hp
            k = k + 1;
            mesh_points(:,k) = point;
            R(k) = norm(point(1:2));
            dop = get_dop_value(config, point(1), point(2), point(3), 'ToA');
            zdop(k) = dop.ZDOP;%/R(k);
            tdop(k) = dop.TDOP;%/R(k);
            hdop(k) = dop.HDOP;%/R(k);
            pdop(k) = dop.PDOP;%/R(k);
        end
    end
    dops{j} = hdop;
    figure(1)
    plot(R,hdop)
    figure(2)
    plot3(mesh_points(1,:),mesh_points(2,:),mesh_points(3,:),'.-')
end
figure(1)
legend()
figure(2)
legend
plot3(config.posts(1,:),config.posts(2,:),config.posts(3,:),'v')
%% 1D распредеелние по радиусу
R = 50e3;
alpha = 0:0.01:2*pi;
X = R * cos(alpha);
Y = R * sin(alpha);
h_geo = 10e3;
zdop = [];
tdop =[];
hdop = [];
hdop2D = [];
pdop = [];
k = 0;
for i = 1:length(X)
    point = calculate_geo_heigth(config, X(i), Y(i), h_geo);
    %     point = [X(i); Y(i); h_geo];
    if point(3) > hp
        k = k + 1;
        mesh_points(:,k) = point;
        R(k) = norm(point(1:2));
        dop = get_dop_value(config, point(1), point(2), point(3), 'ToA');
        zdop(k) = dop.ZDOP;%/R(k);
        tdop(k) = dop.TDOP;%/R(k);
        hdop(k) = dop.HDOP;%/R(k);
        pdop(k) = dop.PDOP;%/R(k);
        dop = get_dop_value(config, point(1), point(2), point(3), 'ToA2D');
        hdop2D(k) = dop.HDOP;%/R(k);
    end
end
figure
plot(alpha*180/pi,hdop,'-r','linewidth',2)
hold on
plot(alpha*180/pi,pdop,'-g','linewidth',2)
plot(alpha*180/pi,zdop,'-b','linewidth',2)
plot(alpha*180/pi,hdop2D,'-c','linewidth',2)
% plot(alpha*180/pi,tdop)
plot([alphap(1) alphap(1)]*180/pi, [min([pdop zdop])-1000 max([pdop zdop])+100],'k--','linewidth',1)
text([alphap(1)]*180/pi,50,'ПП1')
plot([alphap(2) alphap(2)]*180/pi, [min([pdop zdop])-1000 max([pdop zdop])+100],'k--','linewidth',1)
text([alphap(2)]*180/pi,50,'ПП2')
plot([alphap(3) alphap(3)]*180/pi, [min([pdop zdop])-1000 max([pdop zdop])+100],'k--','linewidth',1)
text([alphap(3)]*180/pi,50,'ПП3')
grid on
legend('HDOP 3D','PDOP 3D','ZDOP 3D','HDOP 2D')
set(gca,'FontSize',14)
set(gca,'FontName','Times')
ylim([0 550])
xlim([0 360])
xlabel('θ, град')
% daspect([1 1 1])
[max(hdop) - min(hdop) (max(hdop) - min(hdop))/mean(hdop)*100]
[max(pdop) - min(pdop) (max(pdop) - min(pdop))/mean(pdop)*100]
[max(zdop) - min(zdop) (max(zdop) - min(zdop))/mean(zdop)*100]
[max(hdop2D) - min(hdop2D) (max(hdop2D) - min(hdop2D))/mean(hdop2D)*100]
%%
%% 1D зависимость ГФ от дальности
R = 20e3:1e3:250e3;
alpha = 0:0.01:2*pi;
h_geo = 10e3;
ZDOP = [];
TDOP = [];
HDOP = [];
HDOP2D = [];
PDOP = [];
for j = 1:length(R)
    X = R(j) * cos(alpha);
    Y = R(j) * sin(alpha);
    zdop = [];
    tdop =[];
    hdop = [];
    hdop2D = [];
    pdop = [];
    k = 0;
    for i = 1:length(X)
        point = calculate_geo_heigth(config, X(i), Y(i), h_geo);
        %     point = [X(i); Y(i); h_geo];
        if point(3) > hp
            k = k + 1;
            mesh_points(:,k) = point;
%             R(k) = norm(point(1:2));
            dop = get_dop_value(config, point(1), point(2), point(3), 'ToA');
            zdop(k) = dop.ZDOP;%/R(k);
            tdop(k) = dop.TDOP;%/R(k);
            hdop(k) = dop.HDOP;%/R(k);
            pdop(k) = dop.PDOP;%/R(k);
            dop = get_dop_value(config, point(1), point(2), point(3), 'ToA2D');
            hdop2D(k) = dop.HDOP;%/R(k);
        end
    end
    ZDOP(:,j) = [min(zdop); max(zdop)];
    TDOP(:,j) = [min(tdop); max(tdop)];
    HDOP(:,j) = [min(hdop); max(hdop)];
    PDOP(:,j) = [min(pdop); max(pdop)];
    HDOP2D(:,j) = [min(hdop2D); max(hdop2D)];
    j
end
figure
hold on
patch([R/1000 fliplr(R/1000)], [HDOP(1,:) fliplr(HDOP(2,:))], 'r','FaceAlpha',0.3)
% patch([R/1000 fliplr(R/1000)], [ZDOP(1,:) fliplr(ZDOP(2,:))], 'g','FaceAlpha',0.3)
patch([R/1000 fliplr(R/1000)], [PDOP(1,:) fliplr(PDOP(2,:))], 'b','FaceAlpha',0.3)
patch([R/1000 fliplr(R/1000)], [HDOP2D(1,:) fliplr(HDOP2D(2,:))], 'c','FaceAlpha',0.3)
legend('HDOP 3D','PDOP 3D','HDOP 2D')
set(gca,'FontSize',14)
set(gca,'FontName','Times')
grid on
% ylim([0 550])
% xlim([0 360])
xlabel('R, км')
%%
%% 1D зависимость ГФ от высоты ИРИ
R = 100e3;
alpha = 0:0.01:2*pi;
h_geo = 2e3:100:15e3;
ZDOP = [];
TDOP = [];
HDOP = [];
HDOP2D = [];
PDOP = [];
for j = 1:length(h_geo)
    X = R * cos(alpha);
    Y = R * sin(alpha);
    zdop = [];
    tdop =[];
    hdop = [];
    hdop2D = [];
    pdop = [];
    k = 0;
    for i = 1:length(X)
        point = calculate_geo_heigth(config, X(i), Y(i), h_geo(j));
        %     point = [X(i); Y(i); h_geo];
        if point(3) > hp
            k = k + 1;
            mesh_points(:,k) = point;
%             R(k) = norm(point(1:2));
            dop = get_dop_value(config, point(1), point(2), point(3), 'ToA');
            zdop(k) = dop.ZDOP;%/R(k);
            tdop(k) = dop.TDOP;%/R(k);
            hdop(k) = dop.HDOP;%/R(k);
            pdop(k) = dop.PDOP;%/R(k);
            dop = get_dop_value(config, point(1), point(2), point(3), 'ToA2D');
            hdop2D(k) = dop.HDOP;%/R(k);
        end
    end
    ZDOP(:,j) = [min(zdop); max(zdop)];
    TDOP(:,j) = [min(tdop); max(tdop)];
    HDOP(:,j) = [min(hdop); max(hdop)];
    PDOP(:,j) = [min(pdop); max(pdop)];
    HDOP2D(:,j) = [min(hdop2D); max(hdop2D)];
    j
end
figure
hold on
patch([h_geo/1000 fliplr(h_geo/1000)], [HDOP(1,:) fliplr(HDOP(2,:))], 'r','FaceAlpha',0.3)
% patch([h_geo/1000 fliplr(h_geo/1000)], [ZDOP(1,:) fliplr(ZDOP(2,:))], 'g','FaceAlpha',0.3)
patch([h_geo/1000 fliplr(h_geo/1000)], [PDOP(1,:) fliplr(PDOP(2,:))], 'b','FaceAlpha',0.3)
patch([h_geo/1000 fliplr(h_geo/1000)], [HDOP2D(1,:) fliplr(HDOP2D(2,:))], 'c','FaceAlpha',0.3)
legend('HDOP 3D','PDOP 3D','HDOP 2D')
set(gca,'FontSize',14)
set(gca,'FontName','Times')
grid on
% ylim([0 550])
% xlim([0 360])
xlabel('h, км')
xlim([h_geo(1)/1000 h_geo(end)/1000])
%%
h_geo = 10e3;
Rp = 3e3:0.5e3:15e3; %% расстояние между постами
R = 150e3;
hp = 15;
alphap = [30 150 270]*pi/180;

ZDOP = [];
TDOP = [];
HDOP = [];
HDOP2D = [];
PDOP = [];
for j = 1:length(Rp)
    posts = [];
    for i = 1:3
        posts(:,i) = [Rp(j) * cos(alphap(i)); Rp(j) * sin(alphap(i)); hp];
    end
    posts(:,4) = [0;0;hp];
    % posts = posts + normrnd(0, 3, [3 4]);
    % posts(:,3) = [];
    config.posts = posts;
    X = R * cos(alpha);
    Y = R * sin(alpha);
    zdop = [];
    tdop =[];
    hdop = [];
    hdop2D = [];
    pdop = [];
    k = 0;
    for i = 1:length(X)
        point = calculate_geo_heigth(config, X(i), Y(i), h_geo);
        %     point = [X(i); Y(i); h_geo];
        if point(3) > hp
            k = k + 1;
            mesh_points(:,k) = point;
%             R(k) = norm(point(1:2));
            dop = get_dop_value(config, point(1), point(2), point(3), 'ToA');
            zdop(k) = dop.ZDOP;%/R(k);
            tdop(k) = dop.TDOP;%/R(k);
            hdop(k) = dop.HDOP;%/R(k);
            pdop(k) = dop.PDOP;%/R(k);
            dop = get_dop_value(config, point(1), point(2), point(3), 'ToA2D');
            hdop2D(k) = dop.HDOP;%/R(k);
        end
    end
    ZDOP(:,j) = [min(zdop); max(zdop)];
    TDOP(:,j) = [min(tdop); max(tdop)];
    HDOP(:,j) = [min(hdop); max(hdop)];
    PDOP(:,j) = [min(pdop); max(pdop)];
    HDOP2D(:,j) = [min(hdop2D); max(hdop2D)];
    j
end
figure
hold on
patch([Rp/1000 fliplr(Rp/1000)], [HDOP(1,:) fliplr(HDOP(2,:))], 'r','FaceAlpha',0.3)
% patch([h_geo/1000 fliplr(h_geo/1000)], [ZDOP(1,:) fliplr(ZDOP(2,:))], 'g','FaceAlpha',0.3)
patch([Rp/1000 fliplr(Rp/1000)], [PDOP(1,:) fliplr(PDOP(2,:))], 'b','FaceAlpha',0.3)
patch([Rp/1000 fliplr(Rp/1000)], [HDOP2D(1,:) fliplr(HDOP2D(2,:))], 'c','FaceAlpha',0.3)
legend('HDOP 3D','PDOP 3D','HDOP 2D')
set(gca,'FontSize',14)
set(gca,'FontName','Times')
grid on
% ylim([0 550])
% xlim([0 360])
xlabel('R_{п}, км')
xlim([Rp(1)/1000 Rp(end)/1000])
%%
%% 1D распредеелние по радиусу для троек
R = 150e3;
alpha = 0:0.01:2*pi;
X = R * cos(alpha);
Y = R * sin(alpha);
h_geo = 10e3;
zdop = [];
tdop =[];
hdop = [];
hdop2D = [];
pdop = [];
k = 0;
for i = 1:length(X)
    point = calculate_geo_heigth(config, X(i), Y(i), h_geo);
    %     point = [X(i); Y(i); h_geo];
    if point(3) > hp
        k = k + 1;
        mesh_points(:,k) = point;
        R(k) = norm(point(1:2));
%         dop = get_dop_value(config, point(1), point(2), point(3), 'ToA');
%         zdop(k) = dop.ZDOP;%/R(k);
%         tdop(k) = dop.TDOP;%/R(k);
%         hdop(k) = dop.HDOP;%/R(k);
%         pdop(k) = dop.PDOP;%/R(k);
        dop = get_dop_value(config, point(1), point(2), point(3), 'ToA2D');
        hdop2D(k) = dop.HDOP;%/R(k);
    end
end
% figure
% plot(alpha*180/pi,hdop,'-r','linewidth',2)
hold on
% plot(alpha*180/pi,pdop,'-g','linewidth',2)
% plot(alpha*180/pi,zdop,'-b','linewidth',2)
plot(alpha*180/pi,hdop2D,'-c','linewidth',2)
% plot(alpha*180/pi,tdop)
plot([alphap(1) alphap(1)]*180/pi, [min([hdop2D hdop2D])-1000 max([hdop2D hdop2D])+100],'k--','linewidth',1)
text([alphap(1)]*180/pi,50,'ПП1')
plot([alphap(2) alphap(2)]*180/pi, [min([hdop2D hdop2D])-1000 max([hdop2D hdop2D])+100],'k--','linewidth',1)
text([alphap(2)]*180/pi,50,'ПП2')
plot([alphap(3) alphap(3)]*180/pi, [min([hdop2D hdop2D])-1000 max([hdop2D hdop2D])+100],'k--','linewidth',1)
text([alphap(3)]*180/pi,50,'ПП3')
grid on
% legend('HDOP 3D','PDOP 3D','ZDOP 3D','HDOP 2D')
set(gca,'FontSize',14)
set(gca,'FontName','Times')
% ylim([0 550])
% xlim([0 360])
xlabel('θ, град')
% daspect([1 1 1])
% [max(hdop) - min(hdop) (max(hdop) - min(hdop))/mean(hdop)*100]
% [max(pdop) - min(pdop) (max(pdop) - min(pdop))/mean(pdop)*100]
% [max(zdop) - min(zdop) (max(zdop) - min(zdop))/mean(zdop)*100]
% [max(hdop2D) - min(hdop2D) (max(hdop2D) - min(hdop2D))/mean(hdop2D)*100]