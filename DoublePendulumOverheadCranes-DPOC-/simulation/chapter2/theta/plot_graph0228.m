% clc
addpath('./dhdp');
clear;
flag = 1;
a = csvread('release20220315152332.csv',1,0);
p_cte = a(2:end,:);
colum_num=length(p_cte);
otime = (p_cte(1,1)*ones(1,colum_num))';

legendFontSize = 7;
% p_cte(800:colum_num,4)=smooth(p_cte(800:colum_num,4),20);
figure
if flag==0
% subplot(411)
% plot(p_cte(1:colum_num,1)-otime,medfilt1(p_cte(1:colum_num,2),1),'b','LineWidth',1.5);
% ylabel('$x/(m)$','interpreter','latex');
% xlabel('$Time(s)$','interpreter','latex');
% 
% subplot(412)
% plot(p_cte(1:colum_num,1)-otime,medfilt1(p_cte(1:colum_num,4),5),'b','LineWidth',1.5);
% ylabel('$\theta_h/(\deg)$','interpreter','latex');
% xlabel('$Time(s)$','interpreter','latex');
% 
% subplot(413)
% plot(p_cte(1:colum_num,1)-otime,medfilt1(p_cte(1:colum_num,6),5),'b','LineWidth',1.5);
% ylabel('$\theta_p/(\deg)$','interpreter','latex');
% xlabel('$Time(s)$','interpreter','latex');
% 
% subplot(414)
% plot(p_cte(1:colum_num,1)-otime,medfilt1(p_cte(1:colum_num,8),1),'b','LineWidth',1.5);
% ylabel('$F(N)$','interpreter','latex');
% xlabel('$Times(s)$','interpreter','latex');

%   figure(2)
subplot(411)
plot(p_cte(1:colum_num,1)-otime,smooth(p_cte(1:colum_num,2),1),'b','LineWidth',1.5);
ylabel('$x/(m)$','interpreter','latex');
xlabel('$Time(s)$','interpreter','latex');

subplot(412)
plot(p_cte(1:colum_num,1)-otime,smooth(p_cte(1:colum_num,4),1),'b','LineWidth',1.5);
ylabel('$\theta_h/(\deg)$','interpreter','latex');
xlabel('$Time(s)$','interpreter','latex');

subplot(413)
plot(p_cte(1:colum_num,1)-otime,smooth(p_cte(1:colum_num,6),1),'b','LineWidth',1.5);
ylabel('$\theta_p/(\deg)$','interpreter','latex');
xlabel('$Time(s)$','interpreter','latex');

subplot(414)
plot(p_cte(1:colum_num,1)-otime,smooth(p_cte(1:colum_num,8),1),'b','LineWidth',1.5);
ylabel('$F(N)$','interpreter','latex');
xlabel('$Times(s)$','interpreter','latex');

elseif flag==1
% 
subplot(4,2,1)
plot(p_cte(1:colum_num,1)-otime,smooth(p_cte(1:colum_num,2),1),'b','LineWidth',1.5);
ylabel('$ x/(m)$','interpreter','latex');
xlabel('$Time(s)$','interpreter','latex');

subplot(4,2,2)
plot(p_cte(1:colum_num,1)-otime,smooth(p_cte(1:colum_num,3),1),'b','LineWidth',1.5);
ylabel('$\dot x/(m/s)$','interpreter','latex');
xlabel('$Time(s)$','interpreter','latex');

subplot(4,2,3)
plot(p_cte(1:colum_num,1)-otime,smooth(p_cte(1:colum_num,4),1),'b','LineWidth',1.5);
ylabel('$\theta_h/(\deg)$','interpreter','latex');
xlabel('$Time(s)$','interpreter','latex');

subplot(4,2,4)
plot(p_cte(1:colum_num,1)-otime,smooth(p_cte(1:colum_num,5),1),'b','LineWidth',1.5);
ylabel('$\theta_h/(\deg/s)$','interpreter','latex');
xlabel('$Time(s)$','interpreter','latex');

subplot(4,2,5)
plot(p_cte(1:colum_num,1)-otime(1:colum_num),smooth(p_cte(1:colum_num,6),1),'b','LineWidth',1.5);
ylabel('$\theta_p/(\deg)$','interpreter','latex');
xlabel('$Time(s)$','interpreter','latex');

subplot(4,2,6)
plot(p_cte(1:colum_num,1)-otime,smooth(p_cte(1:colum_num,7),1),'b','LineWidth',1.5);
ylabel('$\theta_p/(\deg/s)$','interpreter','latex');
xlabel('$Time(s)$','interpreter','latex');
%  横向合并用 7：8 纵向合并用[7 8 ]
subplot(4,2,7:8)
plot(p_cte(1:colum_num,1)-otime,smooth(p_cte(1:colum_num,8),1),'b','LineWidth',1.5);
ylabel('$F(N)$','interpreter','latex');
xlabel('$Times(s)$','interpreter','latex'); 


end
