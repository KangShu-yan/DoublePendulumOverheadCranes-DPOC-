
clc ;
clear;
close all;
%% init 
start = 1;
setx = 0.3; xmin=0;xmax = 0.35;
thetahMin = -5;thetahMax = 5;
thetapMin = -5;thetapMax = 5;
neg = 1;
%% process
printName = 'general202203251953';
file = strcat(printName,'.csv');
result = csvread(file,1,0);
len = length(result(:,1));
endpoint = len-0;
Ts = (result(endpoint,1)-result(1,1))/endpoint;
otime = result(start,1)*ones(endpoint-start+1,1);

xd = setx*ones(endpoint-start+1,1);
Time_result = result(start:endpoint,1)-otime;
X_result = result(start:endpoint,2:8);
if neg ==1
    X_result = -X_result;
end

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
ylim([xmin,xmax])


subplot(4,1,2)
plot(Time_result(1:end), X_result(1:end,3)*180/pi,'LineWidth',LineWidth,'Color',LineColor)
grid off
xlabel('Time [s]','interpreter','latex')
ylabel('$\theta_h[\deg]$','interpreter','latex')
xlim([0,20]);
ylim('auto')
ylim([thetahMin,thetahMax])

subplot(4,1,3)
plot(Time_result(1:end), X_result(1:end,5)*180/pi,'LineWidth',LineWidth,'Color',LineColor)
grid off
xlabel('Time [s]','interpreter','latex')
ylabel('$\theta_p[\deg]$','interpreter','latex')
xlim([0,20]);
ylim('auto')
ylim([thetapMin,thetapMax])

subplot(4,1,4)
plot(Time_result(1:end), X_result(1:end,7),'LineWidth',LineWidth,'Color',LineColor)
grid off
xlabel('Time [s]','interpreter','latex')
ylabel('F [N]','interpreter','latex')
xlim([0,20]);
ylim([-50 300])

print(gcf,'-dpng',printName,'-r600');
