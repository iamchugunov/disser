function [RD] = get_rd_from_poits(poits)
    k1 = 0;
    k2 = 0;
    k3 = 0;
    k4 = 0;
    k5 = 0;
    k6 = 0;
    
    t1 = [];
    t2 = [];
    t3 = [];
    t4 = [];
    t5 = [];
    t6 = [];
    
    rd1 = [];
    rd2 = [];
    rd3 = [];
    rd4 = [];
    rd5 = [];
    rd6 = [];
    
    t0 = poits(1).Frame;
%     t0 = 0;
    for i = 1:length(poits)
        if poits(i).ToA(4) > 0 && poits(i).ToA(1) > 0
            k1 = k1 + 1;
            t1(k1) = poits(i).Frame;
            rd1(k1) = poits(i).ToA(4) - poits(i).ToA(1);
        end
        if poits(i).ToA(4) > 0 && poits(i).ToA(2) > 0
            k2 = k2 + 1;
            rd2(k2) = poits(i).ToA(4) - poits(i).ToA(2);
            t2(k2) = poits(i).Frame;
        end
        if poits(i).ToA(4) > 0 && poits(i).ToA(3) > 0
            k3 = k3 + 1;
            rd3(k3) = poits(i).ToA(4) - poits(i).ToA(3);
            t3(k3) = poits(i).Frame;
        end
        if poits(i).ToA(3) > 0 && poits(i).ToA(1) > 0
            k4 = k4 + 1;
            rd4(k4) = poits(i).ToA(3) - poits(i).ToA(1);
            t4(k4) = poits(i).Frame;
        end
        if poits(i).ToA(3) > 0 && poits(i).ToA(2) > 0
            k5 = k5 + 1;
            rd5(k5) = poits(i).ToA(3) - poits(i).ToA(2);
            t5(k5) = poits(i).Frame;
        end
        if poits(i).ToA(2) > 0 && poits(i).ToA(1) > 0
            k6 = k6 + 1;
            rd6(k6) = poits(i).ToA(2) - poits(i).ToA(1);
            t6(k6) = poits(i).Frame;
        end
    end
%     figure
    hold on
    sym = '.';
    plot(t1-t0,rd1*0.299792458000000,sym)
    plot(t2-t0,rd2*0.299792458000000,sym)
    plot(t3-t0,rd3*0.299792458000000,sym)
    plot(t4-t0,rd4*0.299792458000000,sym)
    plot(t5-t0,rd5*0.299792458000000,sym)
    plot(t6-t0,rd6*0.299792458000000,sym)
    legend('4-1','4-2','4-3','3-1','3-2','2-1')
    grid on
    
    RD = [];
    RD(1).rd = rd1*0.299792458000000;
    RD(1).t = t1;
    RD(2).rd = rd2*0.299792458000000;
    RD(2).t = t2;
    RD(3).rd = rd3*0.299792458000000;
    RD(3).t = t3;
    RD(4).rd = rd4*0.299792458000000;
    RD(4).t = t4;
    RD(5).rd = rd5*0.299792458000000;
    RD(5).t = t5;
    RD(6).rd = rd6*0.299792458000000;
    RD(6).t = t6;
end

