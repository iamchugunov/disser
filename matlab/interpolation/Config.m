function [ config ] = Config( )
    addpath('D:\MATLAB\ПЕРЕСЧЕТ КООРДИНАТ');
    addpath('D:\github\disser\matlab\interpolation\math')
    
    % common parameters
    config.c = 299792458;
    config.c_ns = config.c/1e9;
    
    % posts parameters
    %     vor
    PostsBLH(:,1) = [51.400773; 39.035690; 172.5];
    PostsBLH(:,2) = [51.535456; 39.286083; 119.0];
    PostsBLH(:,3) = [51.552025; 38.989821; 196.4];
    PostsBLH(:,4) = [51.504039; 39.108616; 124.4];
%     arm
%     PostsBLH(:,1) = [40.106749; 44.325077; 851.2];
%     PostsBLH(:,2) = [40.221671; 44.518625; 1250.4];
%     PostsBLH(:,3) = [40.376235; 44.255345; 2034.1];
%     PostsBLH(:,4) = [40.204856; 44.376949; 1002.0];

    BLHref = mean(PostsBLH');
    BLHref(3) = 0;
    for i = 1:size(PostsBLH,2)
        PostsENU(:,i) = BLH2ENU(PostsBLH(:,i),BLHref);
    end
    config.BLHref = BLHref;
    config.PostsBLH = PostsBLH;
    config.posts = PostsENU;
    
    % trajectory parameters
    config.hei = 1*10e3;
    config.max_coord = 100e3;
    config.V = 200;
    config.max_V = 600;
    config.max_acc = 10;
    config.period_sec = 0.005; %sec
    config.n_periods = 100; % count of skipped periods (non constant period mode)
    config.lifetime = 600; %sec
    
    % measurements parameters
    config.frame_length_sec = 0.01;
    config.sigma_n_ns = 30;
    config.sigma_n_sec = config.sigma_n_ns /1e9;
    config.sigma_n_m = config.sigma_n_sec * config.c;
    
    % estimation parameters
    config.ranges.r21 = norm(PostsENU(:,2) - PostsENU(:,1));
    config.ranges.r31 = norm(PostsENU(:,3) - PostsENU(:,1));
    config.ranges.r41 = norm(PostsENU(:,4) - PostsENU(:,1));
    config.ranges.r32 = norm(PostsENU(:,3) - PostsENU(:,2));
    config.ranges.r42 = norm(PostsENU(:,4) - PostsENU(:,2));
    config.ranges.r43 = norm(PostsENU(:,4) - PostsENU(:,3));
    
    config.zav_T_kill = 30;
    config.T_kill = 60;
    config.T_nak = 30;
    config.T_est = 5;


end

