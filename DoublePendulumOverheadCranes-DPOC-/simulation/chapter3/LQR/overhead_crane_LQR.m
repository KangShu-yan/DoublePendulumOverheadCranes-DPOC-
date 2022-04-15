% dual pendulum overhead crane Control 
% 2021.12.17 sk

close all; clear;
addpath ../
global m_c m_h m_p l_h l_p g F f_rx k_rx varepsilon d_h d_p
%% pendulum parameters
m_c   = 1.3551;       % [kg]
m_h   = 0.164;     % [kg]
m_p   = 0.08;       % [kg]
g   = 9.7898;   % [m/s^2]
F   = 0;      % [N]
l_h = 1;         % [m]
l_p = 0.5;       % [m]
% f_rx = 180.0; %2
% k_rx = -20.5;   %0.5 

f_rx =1.0; %2
k_rx = -0.5;   %0.5 
varepsilon = 0.01;
d_h = 0.03; d_p = 0.03;
T_final = 20;   % [s]
Ts = 0.01;      % control step time [s]
video_flag = 0; % choose 1 if you want to save a video file of plot animation
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
F_f =zeros(T_final/Ts+1,1);
X_Adaptive(1,:) = X';  %
count = 2;
% kp=23;kd=30;ks = 0.1;alpha=15; %
% kp=3;kd=11;ks = 1;alpha=0.1;
% 无摩擦时
% Q = [80 0 0 0 0  0;
%      0 1 0 0 0 0 ;
%      0 0 1 0 0 0;
%      0 0 0 1 0 0 ;
%      0 0 0 0 12.5 0;
%      0 0 0 0 0 2.5];
 
%  Q = [1000000 0 0 0 0  0;
%      0 280 0 0 0 0 ;
%      0 0 1 0 0 0;
%      0 0 0 10 0 0 ;
%      0 0 0 0 12.5 0;
%      0 0 0 0 0 2.5];
 
  Q = [200 0 0 0 0  0;
     0 280 0 0 0 0 ;
     0 0 1 0 0 0;
     0 0 0 10 0 0 ;
     0 0 0 0 12.5 0;
     0 0 0 0 0 2.5];
R =1;

A = [0, 1,                                                                                                  0,                                                0,                                                          0,                                                0;
0, 0,                                                                  (g*l_h*m_h + g*l_h*m_p)/(l_h*m_c),                                    d_h/(l_h*m_c),                                                          0,                                                0;
0, 0,                                                                                                  0,                                                1,                                                          0,                                                0;
0, 0, -(g*l_h*l_p*m_h^2 + g*l_h*l_p*m_c*m_h + g*l_h*l_p*m_c*m_p + g*l_h*l_p*m_h*m_p)/(l_h^2*l_p*m_c*m_h), -(d_h*l_p*m_c + d_h*l_p*m_h)/(l_h^2*l_p*m_c*m_h),                                          (g*m_p)/(l_h*m_h),                                d_p/(l_h*l_p*m_h);
0, 0,                                                                                                  0,                                                0,                                                          0,                                                1;
0, 0,                                          (g*l_h*l_p*m_p^2 + g*l_h*l_p*m_h*m_p)/(l_h*l_p^2*m_h*m_p),                                d_h/(l_h*l_p*m_h), -(g*l_h*l_p*m_p^2 + g*l_h*l_p*m_h*m_p)/(l_h*l_p^2*m_h*m_p), -(d_p*l_h*m_h + d_p*l_h*m_p)/(l_h*l_p^2*m_h*m_p)];

B = [ 0;1/m_c;0;-1/(l_h*m_c); 0;0];


[k,P,eig] =lqr(A,B,Q,R);

for time=Ts:Ts:T_final
    x = X(1);dotx=X(2);
    theta_h=X(3);dottheta_h=X(4);
    theta_p = X(5);dottheta_p=X(6);
    e = [x-x_d;dotx;theta_h;dottheta_h;theta_p;dottheta_p];
    F = -k*e;

    [T, X_next] = ode45(@diffDualPendulum, [0, Ts], X);    %[t,y] = ode45(odefun,tspan,y0)
    X = X_next(end,:)'; %更新X，取X_next的最后一行数据，也是最新一组数据
    X_Adaptive(count,:) = X';
    time_Adaptive(count) = time;
    F_save(count) = F;
    F_f(count) = f_rx*tanh(dotx/varepsilon)-k_rx*abs(dotx)*dotx;
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


%% Plot

X_result = X_Adaptive;
Time_result = time_Adaptive;
if video_flag == 1
    animation(X_result,Time_result,'LQR',x_d,l_h,l_p,Ts);
end



% figure
% set(figure(2),'Position',[500,50,800,600]);
% 
% subplot(4,2,1)
% plot(Time_result(1:end-1), X_result(1:end-1,1),'LineWidth',1.5)
% % plot(Time_result, X_result(:,1:2))
% cQ = sprintf('               $Q:[%2.2f, %2.2f, %2.2f, %2.2f, %2.2f, %2.2f]$',Q(1,1),Q(2,2),Q(3,3),Q(4,4),Q(5,5),Q(6,6));
% params = sprintf('$m_c:%2.4f,m_h:%2.3f,m_p:%2.3f,l_h:%2.2f,l_p:%2.2f,d_h:%2.3f,d_p:%2.3f$',m_c,m_h,m_p,l_h,l_p,d_h,d_p);
% results  = sprintf('$x_f:%2.3f,h_{max}:%2.3f,p_{max}:%2.3f,h_{res}:%2.3f,p_{res}:%2.3f,t_s:%2.3f,F_{max}:%2.3f$',res(1),res(2),res(3),res(4),res(5),res(6),res(7));
% title({cQ;params;results},'interpreter','latex','FontSize',9);
% grid on
% xlabel('Time [s]')
% ylabel('x[m]','interpreter','latex')
% % legend('cart position [m]', 'cart velocity [m/s]')
% 
% subplot(4,2,2)
% plot(Time_result(1:end-1), X_result(1:end-1,3)*180/pi,'LineWidth',1.5)
% % plot(Time_result, X_result(:,3:4)*180/pi)
% grid on
% xlabel('Time [s]')
% ylabel('$\theta_h[\deg]$','interpreter','latex')
% % legend('pendulum angle [deg]', 'pendulum velocity [deg/s]')
% 
% subplot(4,2,3)
% plot(Time_result(1:end-1), X_result(1:end-1,5)*180/pi,'LineWidth',1.5)
% % plot(Time_result, X_result(:,3:4)*180/pi)
% grid on
% xlabel('Time [s]')
% ylabel('$\theta_p[\deg]$','interpreter','latex')
% % legend('pendulum angle [deg]', 'pendulum velocity [deg/s]')
% 
% 
% 
% subplot(4,2,4)
% plot(Time_result(1:end-1), F_save(1:end-1),'LineWidth',1.5)
% % hold on
% % plot(Time_result, u_save(:,1),'r')
% % plot(Time_result, u_save(:,2),'c')
% grid on
% xlabel('Time [s]')
% ylabel('F [N]','interpreter','latex')
% subplot(4,2,5)
% plot(Time_result(1:end-1), X_result(1:end-1,2),'LineWidth',1.5)
% grid on
% xlabel('Time [s]')
% ylabel('$\dot x$','interpreter','latex')
% 
% 
% subplot(4,2,6)
% plot(Time_result(1:end-1), X_result(1:end-1,4),'LineWidth',1.5)
% grid on
% xlabel('Time [s]')
% ylabel('$\dot \theta_h$','interpreter','latex')
% 
% subplot(4,2,7:8)
% plot(Time_result(1:end-1), X_result(1:end-1,6),'LineWidth',1.5)
% grid on
% xlabel('Time [s]')
% ylabel('$\dot \theta_p$','interpreter','latex')
figure(2)
% set(figure(2),'Position',[700,100,600,550]);
subplot(4,1,1)
plot(Time_result(1:end-1), X_result(1:end-1,1),'LineWidth',1.5)
% plot(Time_result, X_result(:,1:2))
if video_flag == 1
cQ = sprintf('               $Q:[%2.2f, %2.2f, %2.2f, %2.2f, %2.2f, %2.2f]$',Q(1,1),Q(2,2),Q(3,3),Q(4,4),Q(5,5),Q(6,6));
params = sprintf('$m_c:%2.4f,m_h:%2.3f,m_p:%2.3f,l_h:%2.2f,l_p:%2.2f,d_h:%2.3f,d_p:%2.3f$',m_c,m_h,m_p,l_h,l_p,d_h,d_p);
results  = sprintf('$x_f:%2.3f,h_{max}:%2.3f,p_{max}:%2.3f,h_{res}:%2.3f,p_{res}:%2.3f,t_s:%2.3f,F_{max}:%2.3f,W:%2.3f$',res(1),res(2),res(3),res(4),res(5),res(6),res(7),res(8));
title({cQ;params;results},'interpreter','latex','FontSize',9);
end
grid on
xlabel('Time [s]')
ylabel('x[m]','interpreter','latex')
% legend('cart position [m]', 'cart velocity [m/s]')

subplot(4,1,2)
plot(Time_result(1:end-1), X_result(1:end-1,3)*180/pi,'LineWidth',1.5)
% plot(Time_result, X_result(:,3:4)*180/pi)
grid on
xlabel('Time [s]')
ylabel('$\theta_h[\deg]$','interpreter','latex')
% legend('pendulum angle [deg]', 'pendulum velocity [deg/s]')

subplot(4,1,3)
plot(Time_result(1:end-1), X_result(1:end-1,5)*180/pi,'LineWidth',1.5)
% plot(Time_result, X_result(:,3:4)*180/pi)
grid on
xlabel('Time [s]')
ylabel('$\theta_p[\deg]$','interpreter','latex')
% legend('pendulum angle [deg]', 'pendulum velocity [deg/s]')

subplot(4,1,4)
plot(Time_result(1:end-1), F_save(1:end-1),'LineWidth',1.5)
% hold on
% plot(Time_result, u_save(:,1),'r')
% plot(Time_result, u_save(:,2),'c')
grid on
xlabel('Time [s]')
ylabel('F [N]','interpreter','latex')

figure(3)
subplot(3,1,1)
plot(Time_result(1:end-1), X_result(1:end-1,2),'LineWidth',1.5)
% plot(Time_result, X_result(:,3:4)*180/pi)
grid on
xlabel('Time [s]')
ylabel('$\dot x[m/s]$','interpreter','latex')
% legend('pendulum angle [deg]', 'pendulum velocity [deg/s]')

subplot(3,1,2)
plot(Time_result(1:end-1), X_result(1:end-1,4)*180/pi,'LineWidth',1.5)
% plot(Time_result, X_result(:,3:4)*180/pi)
grid on
xlabel('Time [s]')
ylabel('$\dot \theta_h[\deg/s]$','interpreter','latex')

subplot(3,1,3)
plot(Time_result(1:end-1), X_result(1:end-1,6)*180/pi,'LineWidth',1.5)
% plot(Time_result, X_result(:,3:4)*180/pi)
grid on
xlabel('Time [s]')
ylabel('$\dot \theta_p[\deg/s]$','interpreter','latex')

% figure 
% plot(Time_result(1:end-1), F_f(1:end-1),'LineWidth',1.5)