close all;
x1 = [1; 2; 3; 4];
x2 = [0.3; 1.9; 3; 4.6];
x3 = [1.7; 2.1; 2.6; 3.2];
x4 = [1; 2; 3; 4];
y1 = [1; 1; 1; 1];
y2 = [2; 2; 2; 2];
y3 = [3; 3; 3; 3];
y4 = [4; 4; 4; 4];

figure
subplot(1,4,1)
hold on
plot(x1(1),y1(1),'ko','LineWidth',2,'MarkerSize',10);
plot(x2(1),y2(1),'ko','LineWidth',2,'MarkerSize',10);
plot(x3(1),y3(1),'ko','LineWidth',2,'MarkerSize',10);
plot(x4(1),y4(1),'ko','LineWidth',2,'MarkerSize',10);
line([x1(1);x4(1)],[y1(1);y4(1)],'Color','m','LineWidth',2);
line([x1(1);x2(1);x3(1);x4(1)],[y1(1);y2(1);y3(1);y4(1)],'Color','m','LineWidth',2);
line([x1(1);x3(1)],[y1(1);y3(1)],'Color','m','LineWidth',2);
line([x2(1);x4(1)],[y2(1);y4(1)],'Color','m','LineWidth',2);
axis([0 2 0 5]);

subplot(1,4,2)
hold on
plot(x1(2),y1(2),'ko','LineWidth',2,'MarkerSize',10);
plot(x2(2),y2(2),'ko','LineWidth',2,'MarkerSize',10);
plot(x3(2),y3(2),'ko','LineWidth',2,'MarkerSize',10);
plot(x4(2),y4(2),'ko','LineWidth',2,'MarkerSize',10);
line([x1(2);x2(2);x3(2);x4(2)],[y1(2);y2(2);y3(2);y4(2)],'Color','m','LineWidth',2);
axis([1 3 0 5]);
%title('Connectivity Loss Through Obstruction');

subplot(1,4,3)
hold on
plot(x1(3),y1(3),'ko','LineWidth',2,'MarkerSize',10);
plot(x2(3),y2(3),'ko','LineWidth',2,'MarkerSize',10);
plot(x3(3),y3(3),'ko','LineWidth',2,'MarkerSize',10);
plot(x4(3),y4(3),'ko','LineWidth',2,'MarkerSize',10);
line([x1(3);x2(3);x4(3)],[y1(3);y2(3);y4(3)],'Color','m','LineWidth',2);
line([x2(3);x3(3);x4(3)],[y2(3);y3(3);y4(3)],'Color','m','LineWidth',2);
axis([2 4 0 5]);

subplot(1,4,4)
hold on
plot(x1(4),y1(4),'ko','LineWidth',2,'MarkerSize',10);
plot(x2(4),y2(4),'ko','LineWidth',2,'MarkerSize',10);
plot(x3(4),y3(4),'ko','LineWidth',2,'MarkerSize',10);
plot(x4(4),y4(4),'ko','LineWidth',2,'MarkerSize',10);
line([x1(4);x4(4)],[y1(4);y4(4)],'Color','m','LineWidth',2);
line([x1(4);x3(4)],[y1(4);y3(4)],'Color','m','LineWidth',2);
line([x2(4);x4(4)],[y2(4);y4(4)],'Color','m','LineWidth',2);
line([x1(4);x2(4);x3(4);x4(4)],[y1(4);y2(4);y3(4);y4(4)],'Color','m','LineWidth',2);
axis([3 5 0 5]);
