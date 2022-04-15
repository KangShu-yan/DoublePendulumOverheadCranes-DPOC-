
clear;
clc;
% close all;
global F 
%% 
% measuredata = csvread('crane-180.csv',1,0); 
printName = 'friction';
measuredata = csvread('friction.csv',1,0); 

% theta0=[87  -15];
theta0=[87 0.01 -15];
xdata = measuredata(:,1)*0.395;
ydata = measuredata(:,2);
[thetahat,~] = lsqcurvefit(@myfun,theta0,xdata,ydata);
len = length(measuredata);

i=1;
x = -0.37:0.01:0.37;
fitFriction = zeros(length(x),1);
fitFriction2 = zeros(length(x),1);
for i=1:length(x)
%     fitFriction(i)=thetahat(1)*tanh(x(i)/0.05)-thetahat(2)*abs(x(i))*x(i);
   fitFriction(i)=thetahat(1)*tanh(x(i)/thetahat(2))-thetahat(3)*abs(x(i))*x(i);
   fitFriction2(i)=80*tanh(x(i)/thetahat(2))-thetahat(3)/2*abs(x(i))*x(i);
%    fitFriction(i)=thetahat(1)*(tanh(thetahat(2)*x(i))-tanh(thetahat(3)*x(i)))+thetahat(4)*tanh(thetahat(5)*x(i))+thetahat(6)*x(i);
%    i=i+1;
end

figure 
plot(xdata,ydata,'ro','MarkerFaceColor','r','MarkerSize',3);
params = sprintf('$f_{rx}:%2.4f,epsilonx:%2.4f,k_{rx}:%f$',thetahat(1),thetahat(2),thetahat(3));
% params = sprintf('$f_{rx}:%2.4f,k_{rx}:%f$',thetahat(1),thetahat(2));
    
title(params,'interpreter','latex','FontSize',9);
hold on
plot(x,fitFriction,'b','LineWidth',1);
xlabel('$\dot x/(m/s)$','interpreter','latex');
ylabel('$F_f(N)$','interpreter','latex');
hold on
plot(x,fitFriction2,'g--');
% image = './res.png';
print(gcf,'-dpng',printName,'-r500');




