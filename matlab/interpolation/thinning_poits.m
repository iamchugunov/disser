function [poits1] = thinning_poits(poits)
    for i = 1:length(poits)
        rand_number = rand;
        if rand_number > 0.75
            
        elseif rand_number > 0.4
           poits(i).ToA(randi([1 4])) = 0;
        else
           poits(i).ToA(randi([1 4])) = 0;
           poits(i).ToA(randi([1 4])) = 0;
        end
        poits(i).count = length(find(poits(i).ToA));
    end
    poits1 = poits;
end

