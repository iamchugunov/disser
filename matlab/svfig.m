function [] = svfig( figureid, name )

    p1 = ['D:\github\disser\pisc\fig\' name '.fig'];
    p2 = ['D:\github\disser\pisc\png\' name '.png'];
    
    saveas(figureid, p1);
    saveas(figureid, p2);

end

