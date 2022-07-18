function [] = show_track(track, config)
    plot3(config.posts(1,:),config.posts(2,:),config.posts(3,:),'vk','linewidth',2)
    hold on
    plot3(track.coords(1,:),track.coords(2,:),track.coords(3,:),'.-')
    plot3(track.coords(1,1),track.coords(2,1),track.coords(3,1),'v')
    grid on
    axis([-400e3 400e3 -400e3 400e3 -20000 20000])
end

