% dual pendulum overhead crane Control 
% 2021.12.27 sk

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


f_rx = 1; % 2
k_rx = -0.5;   %   -0.5

d_h = 0.03;d_p = 0.03;
varepsilon = 0.01;
F=0;
T_final = 20;   % [s]
Ts = 0.01;      % control step time [s]
video_flag = 0; % choose 1 if you want to save a video file of plot animation
dim = 6;
disturbance_flag =0;
wdim = 2;
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
hatWsave=zeros(T_final/Ts+1,wdim);
X_Adaptive(1,:) = X';  %
% x_rsave = zeros(T_final/Ts+1,3);
count = 2;

kp =22;kd = 28;kth = 2; kchi = 0.1;
Gamma = eye(wdim,wdim)*1;   % 23 
Y = zeros(wdim,1);
sumtildex = 0; hatw = zeros(wdim,1);
N = 0.005;  % no more than x_d+N

for time=Ts:Ts:T_final
    x = X(1);
    dotx=X(2);
    theta_h=X(3);
    dottheta_h=X(4);
    theta_p = X(5);
    dottheta_p=X(6);

    Y(1) = tanh(dotx/varepsilon);
	Y(2) = dotx*abs(dotx);
   
    e_x = x-x_d;
    hatWsave(count,:)=hatw';
    F = Y'*hatw-kchi*e_x/(x_d-x+N)^2-kchi*e_x*e_x/(x_d-x+N)^3-kp*e_x-kd*dotx-kth*dottheta_h^2*dotx;

    [T, X_next] = ode45(@diffDualPendulum, [0, Ts], X);    %[t,y] = ode45(odefun,tspan,y0)
     hatw = hatw - Gamma*Y*dotx*Ts;
     
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
%     if flag==0&&abs(X(1)-x_d)<0.05&&abs(X(2))<0.004
    % if flag==0&&abs(X(1)-x_d)<0.03&&abs(X(2))<0.04&&abs(X(3)*57.3)<0.2&&abs(X(5)*57.3)<0.2
        % flag = 1;
        % res(6) = time;
    % end
	if flag==0&&abs(theta_h)*57.3<=0.5&&abs(theta_p)*57.3<=0.5&&abs(x-x_d)<=0.011&&abs(dotx)<=0.004
        flag = 1;
        res(6) = time;
    end
    res(1)=X(1);
	
    if flag==1&&time>=res(6)
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
 res(1)=X(1);

%% Free fall (No control)
%[T, Z_ode] = ode45(@diff_pendulum, [0, T_final], X);


%% Plot
X_result = X_Adaptive;
Time_result = time_Adaptive;
if video_flag == 1
    animation(X_result,Time_result,'adaptiveSunNing',x_d,l_h,l_p,Ts);
end


h2=figure(2)
set(h2,'position',[50 50 500 500]);
LineWidth = 1;
LineColor = [0 0 0.7];
subplot(4,1,1)

plot(Time_result(1:end-1), X_result(1:end-1,1),'LineWidth',LineWidth,'Color',LineColor)
if video_flag==1
cQ = sprintf('$kp:%2.3f, kd:%2.3f, kth:%2.3f, kchi:%2.3f,gamma_1:%2.3f,gamma_2:%2.3f$',kp,kd,kth,kchi,Gamma(1,1),Gamma(2,2));
params = sprintf('$m_c:%2.4f,m_h:%2.3f,m_p:%2.3f,l_h:%2.2f,l_p:%2.2f,d_h:%2.3f,d_p:%2.3f$',m_c,m_h,m_p,l_h,l_p,d_h,d_p);
results  = sprintf('$x_f:%2.6f,h_{max}:%2.3f,p_{max}:%2.3f,h_{res}:%2.3f,p_{res}:%2.3f,t_s:%2.3f,F_{max}:%2.3f,W:%2.3f$',res(1),res(2),res(3),res(4),res(5),res(6),res(7),res(8));
title({cQ;params;results},'interpreter','latex','FontSize',9);
end

grid off
xlabel('Time [s]')
ylabel('x[m]','interpreter','latex')
% legend('cart position [m]', 'cart velocity [m/s]')

subplot(4,1,2)
plot(Time_result(1:end-1), X_result(1:end-1,3)*180/pi,'LineWidth',LineWidth,'Color',LineColor)
% plot(Time_result, X_result(:,3:4)*180/pi)
% [hup,hlow] = envelope(X_result(1:end-1,3)*180/pi,400);
% hold on 
% plot(Time_result(1:end-1),hup,'-',Time_result(1:end-1),hlow,'-');
grid off
xlabel('Time [s]')
ylabel('$\theta_h[\deg]$','interpreter','latex')
% legend('pendulum angle [deg]', 'pendulum velocity [deg/s]')

subplot(4,1,3)
plot(Time_result(1:end-1), X_result(1:end-1,5)*180/pi,'LineWidth',LineWidth,'Color',LineColor)
% plot(Time_result, X_result(:,3:4)*180/pi)
% [pup,plow] = envelope(X_result(1:end-1,5)*180/pi,400);
% hold on 
% plot(Time_result(1:end-1),pup,'-',Time_result(1:end-1),plow,'-');
grid off
xlabel('Time [s]')
ylabel('$\theta_p[\deg]$','interpreter','latex')
% legend('pendulum angle [deg]', 'pendulum velocity [deg/s]')

subplot(4,1,4)
plot(Time_result(1:end-1), F_save(1:end-1),'LineWidth',LineWidth,'Color',LineColor)
% hold on
% plot(Time_result, u_save(:,1),'r')
% plot(Time_result, u_save(:,2),'c')
grid off
xlabel('Time [s]')
ylabel('F [N]','interpreter','latex')
% legend('Input force', 'u_x', 'u_q')
print(gcf,'-dpng','robustness','-r600');

figure 
subplot(211)
plot(Time_result(1:end-1), hatWsave(1:end-1,1),'LineWidth',1.5)
subplot(212)
plot(Time_result(1:end-1), hatWsave(1:end-1,2),'LineWidth',1.5)



