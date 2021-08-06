function [] = svfig( figureid, name )

    p1 = ['D:\Synology\Мои статьи\2021 - радиотехника\картинки\fig\' name '.fig'];
    p2 = ['D:\Synology\Мои статьи\2021 - радиотехника\картинки\png\' name '.png'];
    
    saveas(figureid, p1);
    saveas(figureid, p2);

end

