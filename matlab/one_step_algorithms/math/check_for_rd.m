function [flag] = check_for_rd(x, toa, posts)
    R = [];
    for j = 1:length(toa)
        R(j) = norm(x - posts(:,j));
    end

    for j = 1:length(toa)-1
        rd1(j,1) = R(j) - R(end);
        rd2(j,1) = toa(j) - toa(end);
    end
%     [rd1 rd2]
    flag = norm(rd1 - rd2) < 1000
end

