function [x_,y_,j,L] = final3dsim(x0,L,N,sigma,V,e,se,ce)
    j = 1; n = size(L,1);
    x_(:,j) = x0(:,1);
    y_(:,j) = x0(:,2);
    done = 0; % flag for when all nodes stop moving
    while j < N-1 && ~done
        x_(:,j+1) = 0; y_(:,j+1) = 0;
        for i=1:n
            circle_pts = zeros(n,2);
            circle_pts(i,:) = [x_(i,j) y_(i,j)];
            % update L with visibility constraints
            for w=1:n % cycle through possible neighbors of i in view
                obstructed = 0;
                if w ~= i 
                    distw = norm([x_(i,j)-x_(w,j), y_(i,j)-y_(w,j)]);
                    if distw <= V
                        thetaiw  = atan2(y_(w,j)-y_(i,j), x_(w,j)-x_(i,j));
                        thetaiwp = thetaiw + 0.5*pi;
                        thetaiwm = thetaiw - 0.5*pi;                    
                        A = [x_(i,j) y_(i,j)] + 0.5*[cos(thetaiwp),sin(thetaiwp)];
                        B = [x_(i,j) y_(i,j)] + 0.5*[cos(thetaiwm),sin(thetaiwm)];
                        C = [x_(w,j) y_(w,j)] + [cos(thetaiwm),sin(thetaiwm)];
                        D = [x_(w,j) y_(w,j)] + [cos(thetaiwp),sin(thetaiwp)];
                        thetabc = atan2(C(2)-B(2), C(1)-B(1));
                        thetaad = atan2(D(2)-A(2), D(1)-A(1));
                        for q=1:n % check all other nodes less than w dist from i
                            if q~=w && q~=i && ~obstructed
                                distq = norm([x_(i,j)-x_(q,j), y_(i,j)-y_(q,j)]);
                                if distq < distw
                                    thetabq = atan2(y_(q,j)-B(2), x_(q,j)-B(1));
                                    thetaaq = atan2(y_(q,j)-A(2), x_(q,j)-A(1));
                                    if thetabc > 0.5*pi && thetabq < -0.5*pi
                                        thetabq = thetabq + 2*pi;
                                    elseif thetabc < -0.5*pi && thetabq > 0.5*pi
                                        thetabc = thetabc + 2*pi;
                                    end
                                    if thetaad > 0.5*pi && thetaaq < -0.5*pi
                                        thetaaq = thetaaq + 2*pi;
                                    elseif thetaad < -0.5*pi && thetaaq > 0.5*pi
                                        thetaad = thetaad + 2*pi;
                                    end
                                    if thetabq > thetabc && thetaaq < thetaad
                                        obstructed = 1;
                                    end
                                end
                            end
                        end
                        if ~obstructed
                            L(i,w) = -1;
                        else
                            L(i,w) = 0;
                        end    
                    end
                end
            end
            for p=1:n
                L(p,p) = abs(sum(L(p,:)<0,2));
            end
            for k=1:n
                if L(i,k) < 0 % connected
                    ndist  = norm([x_(i,j)-x_(k,j), y_(i,j)-y_(k,j)]);
                    ntheta = atan2(y_(k,j)-y_(i,j), x_(k,j)-x_(i,j));
                    if se % add sensing error
                        derr   = -e + 2*e*rand(1); 
                        terr   = (-e + 2*e*rand(1))*pi/180; % theta error in radians
                        ndist  = (1+0.01*derr)*ndist;
                        ntheta = terr + ntheta;
                    end
                    circle_pts(k,:) = ndist.*[cos(ntheta) sin(ntheta)] + [x_(i,j) y_(i,j)];
                end
            end
            circle_pts(~any(circle_pts,2),:) = []; % remove zero rows
            [center,radius] = minboundcircle(circle_pts(:,1),circle_pts(:,2));
            goal_step = [(center(1,1)-x_(i,j)) (center(1,2)-y_(i,j))];
            if norm(goal_step) == 0 % divide by zero check
                norm_step = [0 0];
            else
                norm_step = goal_step/norm(goal_step);
            end
            min = V/2;
            if radius < 3*sqrt(n/2)
                min = 0;
            else
                for s=1:size(circle_pts,1)
                    dist = norm([(x_(i,j)-circle_pts(s,1)) (y_(i,j)-circle_pts(s,2))]);
                    length = 0.5*dist*norm_step(1,1) + sqrt((0.5*V)^2 - (0.5*dist*norm_step(1,2))^2);
                    if length < min
                        min = length;
                    end
                end
            end
            limit_step = min*norm_step; % = 0 if radius < 3*sqrt(n/2)
            sig_step = sigma*norm_step; % vector in direction of center with length sigma
            % choose min step
            if norm(goal_step) < sigma && norm(goal_step) < norm(limit_step)
                step = goal_step;
            elseif norm(limit_step) < sigma && norm(limit_step) < norm(goal_step)
                step = limit_step;
            else
                step = sig_step;
            end  
            % check for collision (no error added yet)
            x_(i,j+1) = x_(i,j) + step(1);
            y_(i,j+1) = y_(i,j) + step(2);
            swerve = 0; % flag to only swerve once
            for r=1:n
                if r ~= i && ~swerve 
                    if norm([x_(i,j+1)-x_(r,j), y_(i,j+1)-y_(r,j)]) <= 1
                        swerve = 1; % swerve right, decrease speed by 0.5
                        theta = atan2(step(2),step(1)) - 0.5*pi;
                        dist  = norm(step)*0.5*sigma;
                        step  = dist.*[cos(theta) sin(theta)];
                    end
                end
            end
            cdist  = norm(step);
            ctheta = atan2(step(2),step(1));
            if ce % add control error
                derr   = -e + 2*e*rand(1); 
                terr   = (-e + 2*e*rand(1))*pi/180; % theta error in radians
                cdist  = (1+0.01*derr)*cdist;
                ctheta = terr + ctheta;
            end
            step = cdist.*[cos(ctheta) sin(ctheta)];

            x_(i,j+1) = x_(i,j) + step(1);
            y_(i,j+1) = y_(i,j) + step(2);
        end
        if prod(round(100*(x_(:,j+1)-x_(:,j))) == zeros(n,1)) && prod(round(100*(y_(:,j+1)-y_(:,j))) == zeros(n,1))
            done = 1; j = j-1; % finished one iteration ago
        end
        j = j+1;
    end
end