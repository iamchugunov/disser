function [poits1] = thinning_poits(poits)
    for i = 1:length(poits)
        rand_number = rand;
        if rand_number > 0.75
            
        elseif rand_number > 0.4
           poits(i).ToA(randi([1 4])) = 0;
        else
           N1 = randi([1 4]);
           N2 = randi([1 4]);
           while N1 == N2
               N2 = randi([1 4]);
           end
           
           poits(i).ToA([N1 N2]) = 0;
           
        end
        poits(i).count = length(find(poits(i).ToA));
    end
    poits1 = poits;
end

