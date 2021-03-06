clear all; close all;

t = 25;
dt = 1e-2; 
st = 0:dt:t;
N = length(st);
n = 20;
V = 50;
e = 5; % error
sigma = 1;
distance = 0;
bounds = 200; % 200x200
% [L,iter,x0] = genConnectLap3d(n,bounds,V); % approx 350k iterations (n=10) 
% and 5M (n=20!) so do once and save 
% csvwrite('final3d_x0_n10.csv',x0);
% csvwrite('final3d_L_n10.csv',L);
x0 = csvread('final3d_x0_n20.csv');
L  = csvread('final3d_L_n20.csv');
se = 0; ce = 0; % bools for sensor, control error existence
[x_,y_,z_,phases,L] = final3dsim(x0,L,N,sigma,V,e,se,ce);
for i=1:n
    distance = distance + norm([x_(i,1)-x_(i,end) y_(i,1)-y_(i,end) z_(i,1)-z_(i,end)]);
end
%phases = 0.1*phases;
pt1 = round(0.25*phases); pt2 = round(0.5*phases); pt3 = round(0.75*phases);
% scatter3(x0(:,1),x0(:,2),x0(:,3),'ko','LineWidth',2)
% hold on
% scatter3(x_(:,pt1),y_(:,pt1),z_(:,pt1),'b*','LineWidth',2)
% scatter3(x_(:,pt2),y_(:,pt2),z_(:,pt2),'g+','LineWidth',2)
% scatter3(x_(:,pt3),y_(:,pt3),z_(:,pt3),'mx','LineWidth',2)
% scatter3(x_(:,end),y_(:,end),z_(:,end),'ro','LineWidth',2)
% axis([0 bounds 0 bounds 0 bounds]);
figure
scatter3(x0(:,1),x0(:,2),x0(:,3),'ko','LineWidth',2)
hold on
scatter3(x_(:,end),y_(:,end),z_(:,end),'ro','LineWidth',2)
for i=1:n
    pts = [x0(i,1),x0(i,2),x0(i,3);
           x_(i,pt1),y_(i,pt1),z_(i,pt1);
           x_(i,pt2),y_(i,pt2),z_(i,pt2);
           x_(i,pt3),y_(i,pt3),z_(i,pt3);
           x_(i,end),y_(i,end),z_(i,end)];
    scatter3(pts(:,1),pts(:,2),pts(:,3),'b*','LineWidth',0.1);
    line(pts(:,1),pts(:,2),pts(:,3));
    hold on
end
axis([0 bounds 0 bounds 0 bounds]);
title('Circumcenter Algorithm 3D with n=20');
ylabel('y position');
xlabel('x position');
zlabel('z position');

