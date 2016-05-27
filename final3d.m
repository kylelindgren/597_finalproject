clear all; close all;

t = 25;
dt = 1e-2; 
st = 0:dt:t;
N = length(st);
%n = cast(10,'int64');
n = 10;
V = 50;
e = 5; % error
sigma = 1;
distance = 0;
bounds = 200; % 200x200
%[L,iter,x0] = genConnectLap3d(n,bounds,V); % approx 350k iterations so do
% once and save 
x0 = csvread('final3d_x0.csv');
L  = csvread('final3d_L.csv');
se = 0; ce = 0; % bools for sensor, control error existence
[x_,y_,z_,phases,L] = final3dsim(x0,L,N,sigma,V,e,se,ce);
for i=1:n
    distance = distance + norm([x_(i,1)-x_(i,end) y_(i,1)-y_(i,end) z_(i,1)-z_(i,end)]);
end
pt1 = round(0.25*phases); pt2 = round(0.5*phases); pt3 = round(0.75*phases);
scatter3(x0(:,1),x0(:,2),x0(:,3),'ko','LineWidth',2)
hold on
scatter3(x_(:,pt1),y_(:,pt1),z_(:,pt1),'b*','LineWidth',2)
scatter3(x_(:,pt2),y_(:,pt2),z_(:,pt2),'g+','LineWidth',2)
scatter3(x_(:,pt3),y_(:,pt3),z_(:,pt3),'mx','LineWidth',2)
scatter3(x_(:,end),y_(:,end),z_(:,end),'ro','LineWidth',2)
axis([0 bounds 0 bounds 0 bounds]);
