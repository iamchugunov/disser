function [DOP] = get_dop_value(config, x, y, z, method)
    DOP = [];
    posts = config.posts;
    switch method    
        case 'ToA'
            for i = 1:size(posts,2)
                D = norm([x;y;z] - posts(:,i));
                H(i,:) = [ (x - posts(1,i))/D, (y - posts(2,i))/D, (z - posts(3,i))/D, 1];
            end
            invHH = inv(H'*H);
            DOP.XDOP = sqrt(abs(invHH(1,1)));
            DOP.YDOP = sqrt(abs(invHH(2,2)));
            DOP.ZDOP = sqrt(abs(invHH(3,3)));
            DOP.TDOP = sqrt(abs(invHH(4,4)));
            DOP.HDOP = norm([DOP.XDOP DOP.YDOP]);
            DOP.PDOP = norm([DOP.XDOP DOP.YDOP DOP.ZDOP]);
            DOP.DOP1 = norm([DOP.XDOP DOP.YDOP DOP.ZDOP DOP.TDOP]);
            DOP.DOP2 = sqrt(trace(invHH));
        case 'ToA2D'
            for i = 1:size(posts,2)
                D = norm([x;y;z] - posts(:,i));
                H(i,:) = [ (x - posts(1,i))/D, (y - posts(2,i))/D, 1];
            end
            invHH = inv(H'*H);
            DOP.XDOP = sqrt(abs(invHH(1,1)));
            DOP.YDOP = sqrt(abs(invHH(2,2)));
%             DOP.ZDOP = sqrt(abs(invHH(3,3)));
            DOP.TDOP = sqrt(abs(invHH(3,3)));
            DOP.HDOP = norm([DOP.XDOP DOP.YDOP]);
            DOP.PDOP = norm([DOP.XDOP DOP.YDOP]);
%             DOP.DOP1 = norm([DOP.XDOP DOP.YDOP DOP.ZDOP DOP.TDOP]);
            DOP.DOP2 = sqrt(trace(invHH));
        case 'ToF'
            for i = 1:size(posts,2)
                D = norm([x;y;z] - posts(:,i));
                H(i,:) = [ (x - posts(1,i))/D (y - posts(2,i))/D (z - posts(3,i))/D];
            end
            invHH = inv(H'*H);
            DOP.XDOP = sqrt(abs(invHH(1,1)));
            DOP.YDOP = sqrt(abs(invHH(2,2)));
            DOP.ZDOP = sqrt(abs(invHH(3,3)));
            DOP.HDOP = norm([DOP.XDOP DOP.YDOP]);
            DOP.PDOP = norm([DOP.XDOP DOP.YDOP DOP.ZDOP]);
            DOP.DOP = sqrt(trace(invHH));
        case 'TDoA'
            k = 0;
            for i = 1:6
                
                switch i
                    case 1
                        n1 = 4;
                        n2 = 1;
                    case 2
                        n1 = 4;
                        n2 = 2;
                    case 3
                        n1 = 4;
                        n2 = 3;
                    case 4
                        n1 = 3;
                        n2 = 1;
                    case 5
                        n1 = 3;
                        n2 = 2;
                    case 6
                        n1 = 2;
                        n2 = 1;
                end
                
                d1 = sqrt((x - posts(1,n1))^2 + (y - posts(2,n1))^2 + (z - posts(3,n1))^2);
                d2 = sqrt((x - posts(1,n2))^2 + (y - posts(2,n2))^2 + (z - posts(3,n2))^2);
                
                H(i, 1) = (x - posts(1,n1))/d1 - (x - posts(1,n2))/d2;
                H(i, 2) = (y - posts(2,n1))/d1 - (y - posts(2,n2))/d2;
                H(i, 3) = (z - posts(3,n1))/d1 - (z - posts(3,n2))/d2;
            end
            invHH = inv(H'*H);
            DOP.XDOP = sqrt(abs(invHH(1,1)));
            DOP.YDOP = sqrt(abs(invHH(2,2)));
            DOP.ZDOP = sqrt(abs(invHH(3,3)));
            DOP.HDOP = norm([DOP.XDOP DOP.YDOP]);
            DOP.PDOP = norm([DOP.XDOP DOP.YDOP DOP.ZDOP]);
            DOP.DOP = sqrt(trace(invHH));
            
           case 'TDoA3D_Dn'
               N = size(config.posts,2);
               H = zeros(N-1,N);
               H(:,1) = 1;
               for i = 1:N-1
                   H(i,i+1) = -1;
               end
               F = [];
               for i = 1:N
                   X = [x;y;z];
                   D = norm(X - posts(:,i));
                   F(i,:) = (X - posts(:,i))'/D;
               end
               invHH = inv(F'*H'*inv(H*H')*H*F);
               DOP.XDOP = sqrt(abs(invHH(1,1)));
               DOP.YDOP = sqrt(abs(invHH(2,2)));
               DOP.ZDOP = sqrt(abs(invHH(3,3)));
               DOP.HDOP = norm([DOP.XDOP DOP.YDOP]);
               DOP.PDOP = norm([DOP.XDOP DOP.YDOP DOP.ZDOP]);
               DOP.DOP = sqrt(trace(invHH));
           case 'TDoA2D_Dn'
               N = size(config.posts,2);
               H = zeros(N-1,N);
               H(:,1) = 1;
               for i = 1:N-1
                   H(i,i+1) = -1;
               end
               F = [];
               for i = 1:N
                   X = [x;y;z];
                   D = norm(X - posts(:,i));
                   F(i,:) = (X(1:2) - posts(1:2,i))'/D;
               end
               invHH = inv(F'*H'*inv(H*H')*H*F);
               DOP.XDOP = sqrt(abs(invHH(1,1)));
               DOP.YDOP = sqrt(abs(invHH(2,2)));
%                DOP.ZDOP = sqrt(abs(invHH(3,3)));
               DOP.HDOP = norm([DOP.XDOP DOP.YDOP]);
%                DOP.PDOP = norm([DOP.XDOP DOP.YDOP DOP.ZDOP]);
               DOP.DOP = sqrt(trace(invHH));
    end
    
end

