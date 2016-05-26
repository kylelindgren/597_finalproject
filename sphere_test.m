clear all; close all;

x = randi(100,10,3);
[r,c,Xb]=ExactMinBoundSphere3D(x);
scatter3(x(:,1),x(:,2),x(:,3));
hold on
scatter3(c(1),c(2),c(3));
[xx,y,z] = sphere;
% surf(xx*+a,y+b,z+c);
surf(xx*r+c(1), y*r+c(2), z*r+c(3),'FaceAlpha',0.1,'FaceColor','none');
axis equal

