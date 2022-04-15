% dual pendulum overhead crane Control 
% 2021.12.03 sk

close all; clear;
addpath ../
global m_c m_h m_p l_h l_p g F f_rx k_rx varepsilon d_h d_p
%% pendulum parameters
% m_c   = 20;       % [kg]
% m_h   = 1;     % [kg]
% m_p   = 5;       % [kg]
% g   = 9.8;   % [m/s^2]
% F_ax   = 0;      % [N]
% l_h = 2;         % [m]
% l_p = 0.4;       % [m]

m_c   = 1.3551;       % [kg]
m_h   = 0.164;     % [kg]
m_p   = 0.08;       % [kg]
g   = 9.7898;   % [m/s^2]
F   = 0;      % [N]
l_h = 1;         % [m]
l_p = 0.5;       % [m]

% m_c   = 50;       % [kg]
% m_h   = 2;     % [kg]
% m_p   = 10;       % [kg]
% g   = 9.81;   % [m/s^2]
% F_ax   = 0;      % [N]
% l_h = 3;         % [m]
% l_p = 0.3;       % [m]

f_rx = 1.0;k_rx = -0.5;
% f_rx =0; k_rx = 0;
d_h  = 0.03;d_p = 0.03;
varepsilon = 0.01;

T_final = 20;   % [s]
Ts = 0.01;      % control step time [s]
video_flag = 1; % choose 1 if you want to save a video file of plot animation
% 外界扰动 测试 
disturbance_flag = 0; 
dim = 6;
% 最终位置 最大吊钩摆角 最大负载摆角 吊钩残余摆角 负载残作摆角 运输时间 最大驱动力
res = zeros(8,1);
flag=0;
%% initial condition
X   = zeros(dim,1);
x_d = 1;
%% adaptive Control
% data save
X_Adaptive = zeros(T_final/Ts+1,dim);
time_Adaptive = zeros(T_final/Ts+1,1);
F_save = zeros(T_final/Ts+1,1);
X_Adaptive(1,:) = X';  %
count = 2;
ddottheta_h = 0;ddottheta_p = 0;ldottheta_h = 0;ldottheta_p = 0;
% kp = 145;kd = 4;lambda1 = -28;lambda2 = -20; % 21 
% kp = 175;kd = 5.2;lambda1 = -28;lambda2 = -21; % 21 
kp = 2;kd = 5.2;lambda1 = -2;lambda2 = -1; % 21 
% lambda2 会抬高x，lambda1会拉低x
for time=Ts:Ts:T_final
    x = X(1);
    dotx=X(2);
    theta_h=X(3);
    dottheta_h=X(4);
    theta_p = X(5);
    dottheta_p=X(6);
    
     xiX = x-x_d+lambda1*sin(theta_h)+lambda2*sin(theta_p);
     dotxiX = dotx+lambda1*dottheta_h*cos(theta_h)+lambda2*dottheta_p*cos(theta_p);
     F_fx = f_rx*tanh(dotx/varepsilon)-k_rx*abs(dotx)*dotx;
     F = F_fx-kp*tanh(xiX)-kd*dotxiX;

    [T, X_next] = ode45(@diffDualPendulum, [0, Ts], X);    %[t,y] = ode45(odefun,tspan,y0)
    X = X_next(end,:)'; %更新X，取X_next的最后一行数据，也是最新一组数据
    X_Adaptive(count,:) = X';
    time_Adaptive(count) = time;
    F_save(count) = F;
    count = count + 1;   

    if disturbance_flag==1
         if time>9&&time<10
            X(3)=0.02*sin(time-9);
            X(5)=0.02*sin(time-9);
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


%% Free fall (No control)
%[T, Z_ode] = ode45(@diff_pendulum, [0, T_final], X);

% Make video comment 1

%% Plot
X_result = X_Adaptive;
Time_result = time_Adaptive;
if video_flag == 1
    animation(X_result,Time_result,'EnergyCouplingTakingInitialConstraint',x_d,l_h,l_p,Ts);
end


figure(2)
subplot(4,1,1)
plot(Time_result(1:end-1), X_result(1:end-1,1),'LineWidth',1.5)
% kp = 175;kd = 5.2;lambda1 = -28;lambda2 = -21; % 21 
if video_flag==1
cQ = sprintf('$kp:%2.2f, kd:%2.2f, lambda1:%2.2f, lambda2:%2.2f$',kp,kd,lambda1,lambda2);
params = sprintf('$m_c:%2.4f,m_h:%2.3f,m_p:%2.3f,l_h:%2.2f,l_p:%2.2f,d_h:%2.3f,d_p:%2.3f$',m_c,m_h,m_p,l_h,l_p,d_h,d_p);
results  = sprintf('$x_f:%2.3f,h_{max}:%2.3f,p_{max}:%2.3f,h_{res}:%2.3f,p_{res}:%2.3f,t_s:%2.3f,F_{max}:%2.3f,W:%2.3f$',res(1),res(2),res(3),res(4),res(5),res(6),res(7),res(8));
title({cQ;params;results},'interpreter','latex','FontSize',9);
end
grid off
xlabel('Time [s]')
ylabel('x[m]','interpreter','latex')
% legend('cart position [m]', 'cart velocity [m/s]')

subplot(4,1,2)
plot(Time_result(1:end-1), X_result(1:end-1,3)*180/pi,'LineWidth',1.5)
% plot(Time_result, X_result(:,3:4)*180/pi)
grid off
xlabel('Time [s]')
ylabel('$\theta_h[\deg]$','interpreter','latex')
% legend('pendulum angle [deg]', 'pendulum velocity [deg/s]')

subplot(4,1,3)
plot(Time_result(1:end-1), X_result(1:end-1,5)*180/pi,'LineWidth',1.5)
% plot(Time_result, X_result(:,3:4)*180/pi)
grid off
xlabel('Time [s]')
ylabel('$\theta_p[\deg]$','interpreter','latex')
% legend('pendulum angle [deg]', 'pendulum velocity [deg/s]')

subplot(4,1,4)
plot(Time_result(1:end-1), F_save(1:end-1),'LineWidth',1.5)
% hold on
% plot(Time_result, u_save(:,1),'r')
% plot(Time_result, u_save(:,2),'c')
grid off
xlabel('Time [s]')
ylabel('$F [N]$','interpreter','latex')
% legend('Input force', 'u_x', 'u_q')
