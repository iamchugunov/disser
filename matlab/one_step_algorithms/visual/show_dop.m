function [] = show_dop(x,y,dop, config)
    figure
    contourf(x/1000,y/1000,dop,[1 2 5 10 20 30 40 50 60 100 150 200 300:100:1000 2000:1000:10000],'ShowText','on')
    colormap(jet)
    hold on
    plot(config.posts(1,:)/1000,config.posts(2,:)/1000,'kv','MarkerSize',10,'linewidth',2)
%     xlim([-0.5e5 0.5e5]/1000)
%     ylim([-0.5e5 0.5e5]/1000)
    xlabel('x, km')
    ylabel('y, km')
    title('DOP')
    set(gca,'FontSize',14)
    colorbar
    daspect([1 1 1])
    grid on
end

