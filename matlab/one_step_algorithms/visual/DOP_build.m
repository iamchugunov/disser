function [] = DOP_build(method, config)
%{
max_x_y = 10;
rad_dist = 3;
ang = pi/3;

SatPos = [max_x_y/2 - rad_dist/sqrt(2)        max_x_y/2        max_x_y/2 + rad_dist/sqrt(2);
          max_x_y/2 - rad_dist/sqrt(2)  max_x_y/2 + rad_dist   max_x_y/2 - rad_dist/sqrt(2)];
        
Sat_2 = [max_x_y/2; max_x_y/2 + rad_dist];
r_btw_anc = sqrt(2*rad_dist^2 - 2*rad_dist^2*cos(ang));

Sat_1 = [Sat_2(1)-(max_x_y/2)*cos(ang); Sat_2(2)-(max_x_y/2)*sin(ang)];
Sat_3 = [Sat_2(1)+(max_x_y/2)*cos(ang); Sat_2(2)-(max_x_y/2)*sin(ang)];

SatPos = [Sat_1 Sat_2 Sat_3];
%}

SatPos = config.posts;
SatPos(3,:) = [];
SatPos(:,4) = [];

          
X = -400e3:10e3:400e3;
Y = -400e3:10e3:400e3;

% X = -30e3:1e3:30e3;
% Y = -30e3:1e3:30e3;

switch method    
    case 'ToF'
         for k = 1:length(X)
            for m = 1:length(Y)
                for q = 1:size(SatPos,2)         
                    H(q,:) = [(X(1,k)-SatPos(1,q))/norm([X(1,k);Y(1,m)]-SatPos(:,q)),(Y(1,m)-SatPos(2,q))/norm([X(1,k);Y(1,m)]-SatPos(:,q))];
                end
                DOP(m,k) = sqrt(trace((H'*H)^-1));
            end
         end       
    case 'TDoA'
         for k = 1:length(X)
            for m = 1:length(Y)
                for q = 1:size(SatPos,2)-1
                      H(q,:) = [(X(1,k)-SatPos(1,q + 1))/norm([X(1,k);Y(1,m)]-SatPos(:,q + 1)) - (X(1,k)-SatPos(1,1))/norm([X(1,k);Y(1,m)]-SatPos(:,1)), (Y(1,m)-SatPos(2,q + 1))/norm([X(1,k);Y(1,m)]-SatPos(:,q + 1)) - (Y(1,m)-SatPos(2,1))/norm([X(1,k);Y(1,m)]-SatPos(:,1))];
                end
                DOP(m,k) = sqrt(trace((H'*H)^-1));
                if DOP(m,k) > 5000
                    DOP(m,k) = NaN;
                end
            end
         end 
    case 'TSoA'
         for k = 1:length(X)
            for m = 1:length(Y)
                for q = 1:size(SatPos,2)-1
                      H(q,:) = [(X(1,k)-SatPos(1,q + 1))/norm([X(1,k);Y(1,m)]-SatPos(:,q + 1)) + (X(1,k)-SatPos(1,1))/norm([X(1,k);Y(1,m)]-SatPos(:,1)), (Y(1,m)-SatPos(2,q + 1))/norm([X(1,k);Y(1,m)]-SatPos(:,q + 1)) + (Y(1,m)-SatPos(2,1))/norm([X(1,k);Y(1,m)]-SatPos(:,1))];
                end
                DOP(m,k) = sqrt(trace((H'*H)^-1));
            end
         end 
    case 'AoA'
         for k = 1:length(X)
            for m = 1:length(Y)
                for q = 1:size(SatPos,2)         
                    H(q,:) = [-(Y(1,m)-SatPos(2,q))/((X(1,k)-SatPos(1,q))^2 + (Y(1,m)-SatPos(2,q))^2),(X(1,k)-SatPos(1,q))/((X(1,k)-SatPos(1,q))^2 + (Y(1,m)-SatPos(2,q))^2)];
                end
                DOP(m,k) = sqrt(trace((H'*H)^-1));
            end
         end                                
    case 'AoA-ToF'
         for k = 1:length(X)
            for m = 1:length(Y)
                for q = 1:size(SatPos,2)         
                    H((q-1)*2+1:(q-1)*2+2,:) = [(X(1,k)-SatPos(1,q))/norm([X(1,k);Y(1,m)]-SatPos(:,q)),   (Y(1,m)-SatPos(2,q))/norm([X(1,k);Y(1,m)]-SatPos(:,q));  
                                                -(Y(1,m)-SatPos(2,q))/((X(1,k)-SatPos(1,q))^2 + (Y(1,m)-SatPos(2,q))^2),  (X(1,k)-SatPos(1,q))/((X(1,k)-SatPos(1,q))^2 + (Y(1,m)-SatPos(2,q))^2)];
                end
                DOP(m,k) = sqrt(trace((H'*H)^-1));
            end
         end                                
    case 'AoA-TDoA'
         for k = 1:length(X)
            for m = 1:length(Y)
                for q = 1:size(SatPos,2)-1
                      H((q-1)*2+1:(q-1)*2+2,:) = [(X(1,k)-SatPos(1,q + 1))/norm([X(1,k);Y(1,m)]-SatPos(:,q + 1)) - (X(1,k)-SatPos(1,1))/norm([X(1,k);Y(1,m)]-SatPos(:,1)), (Y(1,m)-SatPos(2,q + 1))/norm([X(1,k);Y(1,m)]-SatPos(:,q + 1)) - (Y(1,m)-SatPos(2,1))/norm([X(1,k);Y(1,m)]-SatPos(:,1));
                                                  -(Y(1,m)-SatPos(2,q + 1))/((X(1,k)-SatPos(1,q+1))^2 + (Y(1,m)-SatPos(2,q+1))^2), (X(1,k)-SatPos(1,q+1))/((X(1,k)-SatPos(1,q+1))^2 + (Y(1,m)-SatPos(2,q+1))^2)];
                end
                DOP(m,k) = sqrt(trace((H'*H)^-1));
            end
         end
    case 'AoA-TSoA'
         for k = 1:length(X)
            for m = 1:length(Y)
                for q = 1:size(SatPos,2)-1
                      H((q-1)*2+1:(q-1)*2+2,:) = [(X(1,k)-SatPos(1,q + 1))/norm([X(1,k);Y(1,m)]-SatPos(:,q + 1)) + (X(1,k)-SatPos(1,1))/norm([X(1,k);Y(1,m)]-SatPos(:,1)), (Y(1,m)-SatPos(2,q + 1))/norm([X(1,k);Y(1,m)]-SatPos(:,q + 1)) + (Y(1,m)-SatPos(2,1))/norm([X(1,k);Y(1,m)]-SatPos(:,1));
                                                  -(Y(1,m)-SatPos(2,q + 1))/((X(1,k)-SatPos(1,q+1))^2 + (Y(1,m)-SatPos(2,q+1))^2), (X(1,k)-SatPos(1,q+1))/((X(1,k)-SatPos(1,q+1))^2 + (Y(1,m)-SatPos(2,q+1))^2)];
                end
                DOP(m,k) = sqrt(trace((H'*H)^-1));
            end
         end          
    otherwise
        disp('unidentified method')
end

figure(1)
contourf(Y,X,DOP,'ShowText','on')
hold on
plot(SatPos(1,:),SatPos(2,:),'r^','MarkerSize',10)
% xlim([0 10])
% ylim([0 10])
xlabel('x')
ylabel('y')
title('DOP')
set(gca,'FontSize',18)
%colorbar
daspect([1 1 1])
grid on

figure(2)
hist(reshape(DOP,1,[]),250)
title('DOP distribution histogram')
set(gca,'FontSize',18)
%daspect([1 1 1])
grid on


end