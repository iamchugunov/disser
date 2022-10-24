function [] = svfig( figureid, name )
    
    path = 'D:\magicfolder\Аспирантура\Диссертация\картинки для главы ГФ';
    p1 = [path '\fig\' name '.fig'];
    p2 = [path '\png\' name '.png'];
    
    saveas(figureid, p1);
    saveas(figureid, p2);

end

