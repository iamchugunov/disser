function [poits1] = thinning_poits2(poits)
    for i = 1:length(poits)
        N1 = randi([1 4]);
        N2 = randi([1 4]);
        while N1 == N2
            N2 = randi([1 4]);
        end
        
        poits(i).ToA([N1 N2]) = 0;
        poits(i).count = length(find(poits(i).ToA));
        
        poits(i).rd = zeros(6,1);
        
        if poits(i).ToA(4) ~= 0 && poits(i).ToA(1) ~= 0
            poits(i).rd(1,1) = poits(i).ToA(4) - poits(i).ToA(1);
        end
        
        if poits(i).ToA(4) ~= 0 && poits(i).ToA(2) ~= 0
            poits(i).rd(2,1) = poits(i).ToA(4) - poits(i).ToA(2);
        end
        
        if poits(i).ToA(4) ~= 0 && poits(i).ToA(3) ~= 0
            poits(i).rd(3,1) = poits(i).ToA(4) - poits(i).ToA(3);
        end
        
        if poits(i).ToA(3) ~= 0 && poits(i).ToA(1) ~= 0
            poits(i).rd(4,1) = poits(i).ToA(3) - poits(i).ToA(1);
        end
        
        if poits(i).ToA(3) ~= 0 && poits(i).ToA(2) ~= 0
            poits(i).rd(5,1) = poits(i).ToA(3) - poits(i).ToA(2);
        end
        
        if poits(i).ToA(2) ~= 0 && poits(i).ToA(1) ~= 0
            poits(i).rd(6,1) = poits(i).ToA(2) - poits(i).ToA(1);
        end
        poits(i).rd = poits(i).rd * 0.299792458000000;
    end
    poits1 = poits;
end



