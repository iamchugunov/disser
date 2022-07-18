function [x] = solver_analytical_2D_3_posts(toa, posts)
    
    MASTER = 1;
    
    d = toa - toa(MASTER);
    ref_post = posts(:,MASTER);
    posts = posts - ref_post;
    
    d(MASTER) = [];
    posts(:,MASTER) = [];
    
    d1 = d(1);
    d2 = d(2);
    
    X1 = posts(1,1);
    Y1 = posts(2,1);
    
    X2 = posts(1,2);
    Y2 = posts(2,2);
        
    a1 = X1*X1 + Y1*Y1;
	a2 = X2*X2 + Y2*Y2;
    
	b1 = 0.5 * (a1 - d1 * d1);
	b2 = 0.5 * (a2 - d2 * d2);
    
    delta = X1*Y2 - Y1*X2;
    
    
	alphaX = (b1 * Y2 - b2 * Y1) / delta;
	betaX  = (d2 * Y1 - d1 * Y2) / delta;
    
    alphaY = (b2 * X1 - b1 * X2) / delta;
    betaY = (d1 * X2 - d2 * X1) / delta;
    
	a = betaX*betaX + betaY*betaY - 1;
	b = alphaX*betaX + alphaY*betaY;
	c = alphaX*alphaX + alphaY*alphaY;
	D4 = b*b - a * c; 
    if D4 > 0
     	r_plus  = (-b + sqrt(D4)) / a;
     	r_minus = (-b - sqrt(D4)) / a;
        N = 2;
        x(1,1) = alphaX + betaX*r_plus;
        x(2,1) = alphaY + betaY*r_plus;
        x(1,2) = alphaX + betaX*r_minus;
        x(2,2) = alphaY + betaY*r_minus;
        x = x + ref_post(1:2);
    elseif D4 == 0
        r_one = -b / a;
        N = 1;
        x(1,1) = alphaX + betaX*r_one;
        x(2,1) = alphaY + betaY*r_one;
        x = x + ref_post(1:2);
    else 
        N = 0;
        x = [];
    end

end





