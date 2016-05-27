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
[L,iter,x0] = genConnectLap3d(n,bounds,V);
%% 
se = 1; ce = 0; % bools for sensor, control error existence
[x_,y_,z_,phases,L] = finalsim3d(x0,L,N,sigma,V,e,se,ce);
for i=1:n
    distance = distance + norm([x_(i,1)-x_(i,end) y_(i,1)-y_(i,end)]);
end
% csvwrite('fig5_phases_se5_n10_x.csv',x_',1,1);
% csvwrite('fig5_phases_se5_n10_y.csv',y_',1,1);

%plot(x_,y_)
scatter3(x0(:,1),x0(:,2),x0(:,3),'ko','LineWidth',2,'MarkerSize',10)
hold on
scatter3(x_(:,end),y_(:,end),z_(:,end),'ro','LineWidth',2,'MarkerSize',5)
axis([0 bounds 0 bounds]);

% 
% B = 1.0;
% [x1_,t_] = sim92(t,x0,L,B);
% B = 0.6;
% [x2_,t_] = sim92(t,x0,L,B);
% B = 0.4;
% [x3_,t_] = sim92(t,x0,L,B);
% 
% subplot(3,1,1)
% hold on
% %Plot to end
% plot(st,x1_);
% legend('p1 pos', 'p2 pos', 'p3 pos', 'p4 pos', 'p5 pos','location', 'southeast');
% %Plot initial positions
% plot(0,x0(:,1),'ko','LineWidth',2,'MarkerSize',10)
% title('hw7 problem 9.2: Star Graph Max-Protocol with Beta = 1.0');
% ylabel('position');
% 
% subplot(3,1,2)
% hold on
% plot(st,x2_);
% plot(0,x0(:,1),'ko','LineWidth',2,'MarkerSize',10)
% title('Beta = 0.6');
% ylabel('position');
% 
% subplot(3,1,3)
% hold on
% plot(st,x3_);
% plot(0,x0(:,1),'ko','LineWidth',2,'MarkerSize',10)
% title('Beta = 0.4');
% xlabel('time');
% ylabel('position');