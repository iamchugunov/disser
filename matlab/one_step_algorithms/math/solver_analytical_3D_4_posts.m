function [x] = solver_analytical_3D_4_posts(toa, posts)
    
    MASTER = 4;
    
    d = toa - toa(MASTER);
    ref_post = posts(:,MASTER);
    posts = posts - ref_post;
    
    d(MASTER) = [];
    posts(:,MASTER) = [];
    
    d1 = d(1);
    d2 = d(2);
    d3 = d(3);
    
    X1 = posts(1,1);
    Y1 = posts(2,1);
    Z1 = posts(3,1);
    
    X2 = posts(1,2);
    Y2 = posts(2,2);
    Z2 = posts(3,2);
    
    X3 = posts(1,3);
    Y3 = posts(2,3);
    Z3 = posts(3,3);
    
    
%             d1 = toa(2,1) - toa(1,1);
%             d2 = toa(3,1) - toa(1,1);
%             d3 = toa(4,1) - toa(1,1);
% 
%             X1 = posts(1,2) - posts(1,1);
%             Y1 = posts(2,2) - posts(2,1);
%             Z1 = posts(3,2) - posts(3,1);
% 
%             X2 = posts(1,3) - posts(1,1);
%             Y2 = posts(2,3) - posts(2,1);
%             Z2 = posts(3,3) - posts(3,1);
% 
%             X3 = posts(1,4) - posts(1,1);
%             Y3 = posts(2,4) - posts(2,1);
%             Z3 = posts(3,4) - posts(3,1);

%     d1 = toa(1,1) - toa(4,1);
%     d2 = toa(2,1) - toa(4,1);
%     d3 = toa(3,1) - toa(4,1);
%     
%     X1 = posts(1,1);
%     Y1 = posts(2,1);
%     Z1 = posts(3,1);
%     
%     X2 = posts(1,2);
%     Y2 = posts(2,2);
%     Z2 = posts(3,2);
%     
%     X3 = posts(1,3);
%     Y3 = posts(2,3);
%     Z3 = posts(3,3);
    
    a1 = X1*X1 + Y1*Y1 + Z1*Z1;
	a2 = X2*X2 + Y2*Y2 + Z2*Z2;
	a3 = X3*X3 + Y3*Y3 + Z3*Z3;
	b1 = 0.5 * (a1 - d1 * d1);
	b2 = 0.5 * (a2 - d2 * d2);
	b3 = 0.5 * (a3 - d3 * d3);
	delta = X1*(Y2*Z3 - Y3*Z2) + Y1*(X3*Z2 - X2*Z3) + Z1*(X2*Y3 - X3*Y2);
	alphaX = ( b1 * (Y2*Z3 - Y3*Z2) - b2 * (Y1*Z3 - Y3*Z1) + b3 * (Y1*Z2 - Y2*Z1) ) / delta;
	betaX  = ( d1 * (Y2*Z3 - Y3*Z2) - d2 * (Y1*Z3 - Y3*Z1) + d3 * (Y1*Z2 - Y2*Z1) ) / delta;
	alphaY = ( b1 * (X3*Z2 - X2*Z3) - b2 * (X3*Z1 - X1*Z3) + b3 * (X2*Z1 - X1*Z2) ) / delta;
	betaY  = ( d1 * (X3*Z2 - X2*Z3) - d2 * (X3*Z1 - X1*Z3) + d3 * (X2*Z1 - X1*Z2) ) / delta;
	alphaZ = ( b1 * (X2*Y3 - X3*Y2) - b2 * (X1*Y3 - X3*Y1) + b3 * (X1*Y2 - X2*Y1) ) / delta;
	betaZ  = ( d1 * (X2*Y3 - X3*Y2) - d2 * (X1*Y3 - X3*Y1) + d3 * (X1*Y2 - X2*Y1) ) / delta;
	a = betaX*betaX + betaY*betaY + betaZ*betaZ - 1;
	b = alphaX*betaX + alphaY*betaY + alphaZ*betaZ;
	c = alphaX*alphaX + alphaY*alphaY + alphaZ*alphaZ;
	D4 = b*b - a * c; 
    if D4 > 0
     	r_plus  = (-b + sqrt(D4)) / a;
     	r_minus = (-b - sqrt(D4)) / a;
%         if sign(r_plus*r_minus) < 0
%             if r_plus > 0
%                 r_one = r_plus;
%             else
%                 r_one = r_minus;
%             end
%             N = 1;
%             x(1,1) = alphaX + betaX*r_one;
%             x(2,1) = alphaY + betaY*r_one;
%             x(3,1) = alphaZ + betaZ*r_one;
%             x = x + ref_post;
%         else
            N = 2;
            x(1,1) = alphaX + betaX*r_plus;
            x(2,1) = alphaY + betaY*r_plus;
            x(3,1) = alphaZ + betaZ*r_plus;
            x(1,2) = alphaX + betaX*r_minus;
            x(2,2) = alphaY + betaY*r_minus;
            x(3,2) = alphaZ + betaZ*r_minus;
%         end
        
        x = x + ref_post;
    else if D4 == 0
        r_one = -b / a;
        N = 1;
        x(1,1) = alphaX + betaX*r_one;
        x(2,1) = alphaY + betaY*r_one;
        x(3,1) = alphaZ + betaZ*r_one;
        x = x + ref_post;
    else 
        N = 0;
        x = [];
    end

end



