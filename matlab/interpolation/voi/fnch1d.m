function [out] = fnch1d(in, alpha)
    out = in;
    for i = 2:length(in)
        out(i) = (1 - alpha) * in(i) + alpha * out(i-1);
    end
end

