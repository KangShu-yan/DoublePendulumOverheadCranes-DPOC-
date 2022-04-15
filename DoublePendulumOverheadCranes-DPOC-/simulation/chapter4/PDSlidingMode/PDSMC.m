% dual pendulum overhead crane Control 
% 2021.12.03 sk

% close all; 
clear;
addpath ../
global m_c m_h m_p l_h l_p g F f_rx k_rx varepsilon d_h d_p
%% pendulum parameters
m_c   = 1.3551;       % [kg]
m_h   = 0.071;     % [kg]
m_p   = 0.16;       % [kg]
g   = 9.7898;   % [m/s^2]
F   = 0;      % [N]
l_h = 0.35;         % [m]
l_p = 0.3;       % [m]
f_rx = 94.0286;
k_rx = -316.1468;
d_h = 0.0173;d_p = 0.0141;
varepsilon = 0.01;

T_final = 20;   % [s]
Ts = 0.01;      % control step time [s]
video_flag = 0; % choose 1 if you want to save a video file of plot animation
dim = 6;
disturbance_flag = 0;
% 最终位置 最大吊钩摆角 最大负载摆角 吊钩残余摆角 负载残作摆角 运输时间 最大驱动力
res = zeros(8,1);
flag=0;

%% initial condition
X   = zeros(dim,1);
x_d = 0.3;
%% adaptive Control
% data save
X_Adaptive = zeros(T_final/Ts+1,dim);
time_Adaptive = zeros(T_final/Ts+1,1);
F_save = zeros(T_final/Ts+1,1);
X_Adaptive(1,:) = X';  %
count = 2;
% kp=23;kd=30;ks = 0.1;alpha=15; %
kp=6;kd=1;ks =3;alpha=3;
% kp=1100;kd=100;ks =5;alpha=15;
% kp=1100;kd=100;ks =5;alpha=15;
for time=Ts:Ts:T_final
    x = X(1);
    dotx=X(2);
    theta_h=X(3);
    dottheta_h=X(4);
    theta_p = X(5);
    dottheta_p=X(6);
    lambda = -1;
    e = x-x_d+l_h*theta_h*lambda+l_p*theta_p*lambda;
    dote = dotx+l_h*dottheta_h*lambda+l_p*dottheta_p*lambda;
    s = e+alpha*dote;
    F_f = (f_rx-0.3)*tanh(dotx/varepsilon)-k_rx*abs(dotx)*dotx;
    F = -kp*e-kd*dote-ks*tanh(s)+F_f;
    
    [T, X_next] = ode45(@diffDualPendulum, [0, Ts], X);    %[t,y] = ode45(odefun,tspan,y0)
    X = X_next(end,:)'; %更新X，取X_next的最后一行数据，也是最新一组数据
    X_Adaptive(count,:) = X';
    time_Adaptive(count) = time;
    F_save(count) = F;
    count = count + 1;   
    
     if disturbance_flag==1
        if time>10&&time<11
            X(3)=0.1*sin(time-10);
            X(5)=0.1*sin(time-10);
        end
    end
    
      %     最大吊钩摆角
    if abs(X(3)*57.3)>abs(res(2))    
        res(2)=X(3)*57.3;
    end
%     最大负载摆角
    if abs(X(5)*57.3)>abs(res(3))
        res(3)=X(5)*57.3;
    end
    % if flag==0&&abs(X(1)-x_d)<0.05&&abs(X(2))<0.004
        % flag = 1;
        % res(1)=X(1);
        % res(6) = time;
    % end
	if flag==0&&abs(theta_h)*57.3<=0.5&&abs(theta_p)*57.3<=0.5&&abs(x-x_d)<=0.011&&abs(dotx)<=0.004
        flag = 1;
        res(6) = time;
    end
    res(1)=X(1);
    if flag&&time>=res(6)
        if res(4)<abs(X(3)*57.3)
            res(4) = abs(X(3)*57.3);
        end
        if res(5)<abs(X(5)*57.3)
            res(5) = abs(X(5)*57.3);
        end
     end
     res(8) = res(8)+Ts*F*F;
%     最大驱动力
    if abs(F)>abs(res(7))
        res(7)=F;
    end
end

%% Plot
X_result = X_Adaptive;
Time_result = time_Adaptive;
if video_flag == 1
    animation(X_result,Time_result,'PDSlidingMode',x_d,l_h,l_p,Ts);
end


printName = 'simulation';
setx = x_d; left=0;right = 0.35;
% thetadown = -4;thetaup =4;
xd = setx*ones(length(Time_result)-1,1);
h2 = figure;
position = [50 50 400 400];
set(h2,'position',position);
LineWidth = 1;
LineColor = [0 0 0.7];
xdColor = [0.7 0 0 ];
subplot(4,1,1)
plot(Time_result(1:end-1), X_result(1:end-1,1),'LineWidth',LineWidth,'Color',LineColor)
if video_flag==1
cQ = sprintf('$kp:%2.2f, kd:%2.2f, ks:%2.2f, alpha:%2.2f$',kp,kd,ks,alpha);
params = sprintf('$m_c:%2.4f,m_h:%2.3f,m_p:%2.3f,l_h:%2.2f,l_p:%2.2f,d_h:%2.3f,d_p:%2.3f$',m_c,m_h,m_p,l_h,l_p,d_h,d_p);
results  = sprintf('$x_f:%2.3f,h_{max}:%2.3f,p_{max}:%2.3f,h_{res}:%2.3f,p_{res}:%2.3f,t_s:%2.3f,F_{max}:%2.3f,W:%2.3f$',res(1),res(2),res(3),res(4),res(5),res(6),res(7),res(8));
title({cQ;params;results},'interpreter','latex','FontSize',9);
end
hold on 
plot(Time_result(1:end-1), xd,'LineWidth',LineWidth,'Color',xdColor,'LineStyle','-.');
grid off
xlabel('Time [s]','interpreter','latex')
ylabel('x[m]','interpreter','latex')
% xlim([0,20]);
% ylim([left,right])

subplot(4,1,2)
plot(Time_result(1:end-1), X_result(1:end-1,3)*180/pi,'LineWidth',LineWidth,'Color',LineColor)
% plot(Time_result, X_result(:,3:4)*180/pi)
grid off
xlabel('Time [s]','interpreter','latex')
ylabel('$\theta_h[\deg]$','interpreter','latex')
% xlim([0,20]);
% ylim([thetadown thetaup])

subplot(4,1,3)
plot(Time_result(1:end-1), X_result(1:end-1,5)*180/pi,'LineWidth',LineWidth,'Color',LineColor)
% plot(Time_result, X_result(:,3:4)*180/pi)
grid off
xlabel('Time [s]','interpreter','latex')
ylabel('$\theta_p[\deg]$','interpreter','latex')
% legend('pendulum angle [deg]', 'pendulum velocity [deg/s]')
% xlim([0,20]);
% ylim([thetadown thetaup])

subplot(4,1,4)
plot(Time_result(1:end-1), F_save(1:end-1),'LineWidth',LineWidth,'Color',LineColor)
grid off
xlabel('Time [s]','interpreter','latex')
ylabel('F [N]','interpreter','latex')
print(gcf,'-dpng',printName,'-r600');
