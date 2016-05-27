function [L,iter,x0] = genConnectLap3d(n,bounds,V)
    iter = 0; % attempts to find connected x0 that satisfies V and obstruction constraints
    no_connect = 1;
    while no_connect
        x0 = bounds*rand(n,3); % random initial conditions 
        L = zeros(n);
        for i=1:n
            % update L with visibility constraints
            for w=1:n % cycle through possible neighbors of i in view
                obstructed = 0;
                if w ~= i 
                    distw = norm([x0(i,1)-x0(w,1), x0(i,2)-x0(w,2), x0(i,3)-x0(w,3)]);
                    if distw <= V 
                        %% bookmark
                        thetaiw  = atan2(x0(w,2)-x0(i,2), x0(w,1)-x0(i,1));
                        thetaiwp = thetaiw + 0.5*pi;
                        thetaiwm = thetaiw - 0.5*pi;                    
                        A = [x0(i,1) x0(i,2)] + 0.5*[cos(thetaiwp),sin(thetaiwp)];
                        B = [x0(i,1) x0(i,2)] + 0.5*[cos(thetaiwm),sin(thetaiwm)];
                        C = [x0(w,1) x0(w,2)] + [cos(thetaiwm),sin(thetaiwm)];
                        D = [x0(w,1) x0(w,2)] + [cos(thetaiwp),sin(thetaiwp)];
                        thetabc = atan2(C(2)-B(2), C(1)-B(1));
                        thetaad = atan2(D(2)-A(2), D(1)-A(1));
                        for q=1:n % check all other nodes less than w dist from i
                            if q~=w && q~=i && ~obstructed
                                distq = norm([x0(i,1)-x0(q,1), x0(i,2)-x0(q,2)]);
                                if distq < distw
                                    thetabq = atan2(x0(q,2)-B(2), x0(q,1)-B(1));
                                    thetaaq = atan2(x0(q,2)-A(2), x0(q,1)-A(1));
                                    % alter angles if close to bounds,
                                    % atan2 returns [-pi,pi]
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
                            L(i,w) = 0; % w may have become disconnected
                        end    
                    end
                end
            end
        end
        no_connect = 0;
        for j=1:n
            L(j,j) = abs(sum(L(j,:),2));
        end
        eigvals = sort(eig(L));
        if round(eigvals(2)*1000) <= 0 % connected if 2nd smallest eig > 0
            no_connect = 1;
            iter = iter+1;
        end
    end
end