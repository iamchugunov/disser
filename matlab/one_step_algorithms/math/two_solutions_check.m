function [out] = two_solutions_check(x, toa, posts)
    out = [];
    for i = 1:2
        x1 = x(:,i);
        R = [];
        for j = 1:length(toa)
            R(j) = norm(x1 - posts(:,j));
        end
        
        for j = 1:length(toa)-1
            rd1(j,1) = R(j) - R(end);
            rd2(j,1) = toa(j) - toa(end);
        end
        out(:,i) = rd1 - rd2;
    end
%     [rd1 rd2]
    out
end

