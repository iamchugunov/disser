function [] = show_dop(x,y,dop, lines, interval, config)
    figure
    contourf(x/1000,y/1000,dop,lines,'ShowText','on')
    colormap(jet)
    hold on
    plot(config.posts(1,:)/1000,config.posts(2,:)/1000,'kv','MarkerSize',10,'linewidth',2)
%     xlim([-0.5e5 0.5e5]/1000)
%     ylim([-0.5e5 0.5e5]/1000)
    xlabel('x, км')
    ylabel('y, км')
%     title('DOP')
    set(gca,'FontSize',14)
    set(gca,'FontName','Times')
    colorbar
    caxis(interval)
    daspect([1 1 1])
    grid on
end

