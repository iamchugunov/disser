function [] = show_hyperbols(toa, posts, z, Master)
    colors = ['r' 'g' 'b' 'm' 'c' 'y' 'k']'; 
    for j = 1:size(toa,1)-1
        out{j} = [];
    end
    for j = 1:size(toa,2)
        RD = toa(:,j) - toa(Master,j);
        nums = 1:length(posts);
        RD(Master) = [];
        nums(Master) = [];
          
        for i = 1:length(nums)
            out{i} = [ out{i} make_hyperb(posts(:,nums(i)), posts(:,Master), RD(i), z)];
        end
    
    end
    for i = 1:length(nums)
        plot(out{i}(1,:),out{i}(2,:),['.' colors(i)])
    end
    legend('1','2','3','4','5')
end

