function [ config ] = Config( )
    
    % common parameters
    config.c = 299792458;
    config.c_ns = config.c/1e9;
    
    % posts parameters
    config.posts = [-5076.25700228714 12312.9342219411 -8241.14728795100 -1.11097161563963;-11487.2777145567 3509.94201846127 5345.24999149516 -0.445039107080202;160.134190817221 106.173298698501 188.845909395533 124.399999890768];
    
    % trajectory parameters
    config.hei = 1*10e3;
    config.max_coord = 100e3;
    config.V = 200;
    config.max_V = 600;
    config.max_acc = 10;
    config.period_sec = 0.1; %sec
    config.n_periods = 10; % count of skipped periods (non constant period mode)
    config.lifetime = 600; %sec
    
    % measurements parameters
    config.frame_length_sec = 0.01;
    config.sigma_n_ns = 10;
    config.sigma_n_sec = config.sigma_n_ns /1e9;
    config.sigma_n_m = config.sigma_n_sec * config.c;
    
    % estimation parameters
    config.T_nak = 10; %sec
    config.T_est = 10; %sec


end

