function [toa] = toa_analysis(poits)
    t = [];
    toa = [];

    t0 = poits(1).Frame;
    
    for i = 1:length(poits)
        for j = 1:4
            if poits(i).ToA(j) > 0
                toa(j,i) = poits(i).Frame - t0 + poits(i).ToA(j)/1e9;
            else
                toa(j,i) = NaN;
            end
        end
    end
%     figure
%     hold on
%     grid on
%     for i = 1:4
%         plot(toa(i,:), i*ones(length(toa),1),'.')
%     end
end