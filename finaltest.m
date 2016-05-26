function [x_,y_] = finaltest(x0,L,N,dt)
    j = 1; n = size(L,1);
    x_(:,j) = x0(:,1);
    y_(:,j) = x0(:,2);
    while j < N-1
        x_(:,j+1) = 0; y_(:,j+1) = 0; 
        for i=1:n
            for k=1:n
                if L(i,k) < 0 % connected
                    x_(i,j+1) = x_(i,j+1) + x_(k,j) - x_(i,j);
                    y_(i,j+1) = y_(i,j+1) + y_(k,j) - y_(i,j);
                end
            end
        end
        x_(:,j+1) = x_(:,j) + dt*x_(:,j+1);
        y_(:,j+1) = y_(:,j) + dt*y_(:,j+1);
        j = j+1;
    end
end