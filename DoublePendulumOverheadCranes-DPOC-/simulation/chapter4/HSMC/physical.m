
clc ;
clear;
close all;
printName = 'release20220320172124';
file = strcat(printName,'.csv');

% printName = 'physicalRobust';
result = csvread(file,1,0);
len = length(result(:,1));
endpoint = len-0;
Ts = (result(endpoint,1)-result(1,1))/endpoint;
% start = 3159;   %  release20220319092521
start = 1;
otime = result(start,1)*ones(endpoint-start+1,1);
setx = 0.302; left=0;right = 0.35;
thetadown = -4;thetaup =4;
xd = setx*ones(endpoint-start+1,1);
Time_result = result(start:endpoint,1)-otime;
X_result = result(start:endpoint,2:8);
h2 = figure;
set(h2,'position',[50 50 400 400]);
LineWidth = 0.7;
LineColor = [0 0 0.7];
xdColor = [0.7 0 0 ];
subplot(4,1,1)
plot(Time_result(1:end), X_result(1:end,1),'LineWidth',LineWidth,'Color',LineColor)
hold on 
plot(Time_result(1:end), xd,'LineWidth',LineWidth,'Color',xdColor,'LineStyle','-.');
% plot(Time_result, X_result(:,1:2))
grid off
xlabel('Time [s]','interpreter','latex')
ylabel('x[m]','interpreter','latex')
xlim([0,20]);
ylim([left,right])
% legend('cart position [m]', 'cart velocity [m/s]')

subplot(4,1,2)
plot(Time_result(1:end), X_result(1:end,3)*180/pi,'LineWidth',LineWidth,'Color',LineColor)
% plot(Time_result, X_result(:,3:4)*180/pi)
grid off
xlabel('Time [s]','interpreter','latex')
ylabel('$\theta_h[\deg]$','interpreter','latex')
xlim([0,20]);
ylim([thetadown thetaup])


subplot(4,1,3)
plot(Time_result(1:end), X_result(1:end,5)*180/pi,'LineWidth',LineWidth,'Color',LineColor)
% plot(Time_result, X_result(:,3:4)*180/pi)
grid off
xlabel('Time [s]','interpreter','latex')
ylabel('$\theta_p[\deg]$','interpreter','latex')
xlim([0,20]);
ylim([thetadown thetaup])
% legend('pendulum angle [deg]', 'pendulum velocity [deg/s]')

subplot(4,1,4)
plot(Time_result(1:end), X_result(1:end,7),'LineWidth',LineWidth,'Color',LineColor)
% hold on
% plot(Time_result, u_save(:,1),'r')
% plot(Time_result, u_save(:,2),'c')
grid off
xlabel('Time [s]','interpreter','latex')
ylabel('F [N]','interpreter','latex')
xlim([0,20]);
ylim('auto')
print(gcf,'-dpng',printName,'-r600');
