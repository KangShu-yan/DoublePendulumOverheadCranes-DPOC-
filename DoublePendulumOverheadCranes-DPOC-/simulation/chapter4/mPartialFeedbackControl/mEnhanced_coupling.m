% dual pendulum overhead crane Control 
% 2021.12.27 sk

close all; 
clear;
addpath ../
global m_c m_h m_p l_h l_p g F f_rx k_rx varepsilon d_h d_p
%% pendulum parameters

g   = 9.7898;   % [m/s^2]
F   = 0;      % [N]
m_c   = 1.3551;       % [kg]
m_h   = 0.164;     % [kg]
m_p   = 0.08;       % [kg]
l_h = 1;         % [m]
l_p = 0.5;       % [m]
f_rx = 1.0;
k_rx = -0.5;
% f_rx = 94;    
% k_rx = -316;
d_h = 0.03;d_p = 0.03;
varepsilon = 0.01;

% m_c   = 1.3551;       % [kg]
% m_h   = 0.071;     % [kg]
% m_p   = 0.16;       % [kg]
% g   = 9.7898;   % [m/s^2]
% F   = 0;      % [N]
% l_h = 0.35;         % [m]
% l_p = 0.3;       % [m]
% f_rx = 94;  
% k_rx = -316;
% d_h = 0.03;d_p = 0.03;
% varepsilon = 0.01;

F=0;
Ts = 0.01;      % control step t [s]
ref = 'trajectory20220121';
x_d = 1;
printName = strcat(ref,string(x_d),'m');
xx = load(strcat(ref,'.mat')); %trajectory0-30cm
len = size(xx.x,2);
T_final = 20;   % [s]
pTs = len*Ts;
disturbance_flag = 0;
print_flag =0;
comment_flag=1;
video_flag = 0; % choose 1 if you want to save a video file of plot animation
dim = 6;
% 最终位置 最大吊钩摆角 最大负载摆角 吊钩残余摆角 负载残作摆角 运输时间 最大驱动力
res = zeros(8,1);
flag=0;
%% initial condition
X = zeros(dim,1);

%% adaptive Control
% data save
X_Adaptive = zeros(T_final/Ts+1,dim);
time_Adaptive = zeros(T_final/Ts+1,1);
F_save = zeros(T_final/Ts+1,1);
F_fsave = zeros(T_final/Ts+1,1);
x_rsave = zeros(T_final/Ts+1,dim);

X_Adaptive(1,:) = X';  %
count = 2;

% 大摩擦补偿
% kp = 9;
% kd = 8;

% lambda_h = 0.3;lambda_p = 1;
kf = 1;
% lambda =1;
% 大摩擦
% kp = 2.6;
% kd = 4;
% lambda_h = 2;lambda_p = 3;
% 小摩擦
kp = 1;
kd = 1.8;
lambda_h =1.5;lambda_p = 1.5;
kxi = 1;
% regulate kxi, lambda_h,lambda_p firstly, then kd
M_xtheta = zeros(1,2);
M_theta = zeros(2,2);
C_theta = zeros(2,2);
G_theta = zeros(2,1);M_x = zeros(2,1);
F_rx = 0; h = 0;sumtheta_h = 0;sumtheta_p = 0;
for t=Ts:Ts:T_final
    
    if t<=pTs
        xstar = xx.x(:,int16(t/Ts));
    else
        xstar = [x_d;0;0;0;0;0;0];
    end
    xxstar= xstar(1);dotxstar = xstar(2);u = xstar(3);
%     theta_hstar = xstar(4);dottheta_hstar = xstar(5);
%     theta_pstar = xstar(6);dottheta_pstar = xstar(7);
    x_rsave(count,:) = [xstar(1),xstar(2),xstar(4),xstar(5),xstar(6),xstar(7)];
    x = X(1);
    dotx=X(2);
    theta_h=X(3);
    dottheta_h=X(4);
    theta_p = X(5);
    dottheta_p=X(6);
    theta = [theta_h;theta_p];
    dottheta = [dottheta_h;dottheta_p];
    
    M_xtheta = [(m_h+m_p)*l_h*cos(theta_h) m_p*l_p*cos(theta_p)];
    M_theta = [(m_h+m_p)*l_h^2 m_p*l_h*l_p*cos(theta_h-theta_p);
        m_p*l_h*l_p*cos(theta_h-theta_p) m_p*l_p^2];
    C_theta = [0  m_p*l_h*l_p*sin(theta_h-theta_p)*dottheta_p;
        -m_p*l_h*l_p*sin(theta_h-theta_p)*dottheta_h 0];
    G_theta = [(m_h+m_p)*g*l_h*sin(theta_h); m_p*g*l_p*sin(theta_p)];
    h = -M_xtheta*inv(M_theta)*(G_theta+C_theta*dottheta)...
        -(m_h+m_p)*l_h*sin(theta_h)*dottheta_h^2-m_p*l_p*sin(theta_p)*dottheta_p^2;
    
    M_x = [(m_h+m_p)*l_h*cos(theta_h); m_p*l_p*cos(theta_p)];
    sumtheta_h = sumtheta_h+sin(theta_h)*Ts;
    sumtheta_p = sumtheta_p+sin(theta_p)*Ts;
    
    xi = x-xxstar-(lambda_h*(m_h+m_p)*l_h*sumtheta_h+lambda_p*m_p*l_p*sumtheta_p);
    dotxi = dotx-dotxstar-(lambda_h*(m_h+m_p)*l_h*sin(theta_h)+lambda_p*m_p*l_p*sin(theta_p));
    ddotxi = -kp*(kxi*xi-(lambda_h*(m_h+m_p)*l_h*sin(theta_h)+lambda_p*m_p*l_p*sin(theta_p)))...
        -kd*(kxi*dotxi-dottheta'*[lambda_h 0;0 lambda_p]*M_x);
    ddotx = ddotxi+dottheta'*[lambda_h 0;0 lambda_p]*M_x+u;
    F_f = f_rx*tanh(dotx/varepsilon)-k_rx*abs(dotx)*dotx;
     F =kf*F_f+(m_c+m_h+m_p-M_xtheta*inv(M_theta)*M_x)*ddotx+h;
%       F =(m_c+m_h+m_p-M_xtheta*inv(M_theta)*M_x)*ddotx+h;
%     F_ax = F;
    [T, X_next] = ode45(@diffDualPendulum, [0, Ts], X);    %[t,y] = ode45(odefun,tspan,y0)

    X = X_next(end,:)'; %更新X，取X_next的最后一行数据，也是最新一组数据
    X_Adaptive(count,:) = X';
    time_Adaptive(count) = t;
    F_save(count) = F;
    F_fsave(count) = F_f;
    count = count + 1;   
    
    if disturbance_flag==1
        if t>9&&t<10
            X(3)=0.02*sin(t-9);
            X(5)=0.02*sin(t-9);
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
        % res(6) = t;
    % end
	if flag==0&&abs(theta_h)*57.3<=0.5&&abs(theta_p)*57.3<=0.5&&abs(x-x_d)<=0.011&&abs(dotx)<=0.004
        flag = 1;
        res(6) = t;
    end
    res(1)=X(1);
      if flag&&t>=res(6)
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
% 是否显示动画并存为视频
if video_flag == 1
    animation(X_result,Time_result,'mPartialFeedbackControl',x_d,l_h,l_p,Ts);
end

h = figure;
set(h,'position',[50 50 400 400]);
linewidth = 0.6;
Color = [0 0 0.7];
LineStyle = '-';
if x_d>0
    xlimit = [ 0 x_d+0.2];
else
    xlimit = [x_d-0.2 0];
end

% grid off
subplot(4,1,1)
plot(Time_result(1:end-1), X_result(1:end-1,1),'Color',Color,'LineStyle',LineStyle,'LineWidth',linewidth)
if comment_flag==1
cQ = sprintf('               $kp:%2.3f, kd:%2.3f,lambda_h:%2.3f,lambda_p:%2.3f $',kp,kd,lambda_h,lambda_p);
params = sprintf('$m_c:%2.3f,m_h:%2.3f,m_p:%2.3f,d_h:%2.3f,d_p:%2.3f$',m_c,m_h,m_p,d_h,d_p);
results  = sprintf('$x_f:%2.3f,h_{max}:%2.3f,p_{max}:%2.3f,h_{res}:%2.3f,p_{res}:%2.3f,t_s:%2.3f,F_{max}:%2.3f,W:%2.3f$',res(1),res(2),res(3),res(4),res(5),res(6),res(7),res(8));
title({cQ;params;results},'interpreter','latex','FontSize',9);
grid off
end
hold on ;
plot(Time_result(1:end-1),x_rsave(1:end-1,1),'--','LineWidth',linewidth);
xlabel('Time [s]','interpreter','latex')
ylabel('x[m]','interpreter','latex')
ylim(xlimit);
% legend('cart position [m]', 'cart velocity [m/s]')

subplot(4,1,2)
plot(Time_result(1:end-1), X_result(1:end-1,3)*180/pi,'Color',Color,'LineStyle',LineStyle,'LineWidth',linewidth)
% plot(Time_result, X_result(:,3:4)*180/pi)
grid off
xlabel('Time [s]','interpreter','latex')
ylabel('$\theta_h[\deg]$','interpreter','latex')
ylim([-4 4]);

subplot(4,1,3)
plot(Time_result(1:end-1), X_result(1:end-1,5)*180/pi,'Color',Color,'LineStyle',LineStyle,'LineWidth',linewidth)
% plot(Time_result, X_result(:,3:4)*180/pi)
grid off
xlabel('Time [s]','interpreter','latex')
ylabel('$\theta_p[\deg]$','interpreter','latex')
ylim([-4 4]);
% legend('pendulum angle [deg]', 'pendulum velocity [deg/s]')

subplot(4,1,4)
plot(Time_result(1:end-1), F_save(1:end-1),'Color',Color,'LineStyle',LineStyle,'LineWidth',linewidth)
% hold on
% plot(Time_result, u_save(:,1),'r')
% plot(Time_result, u_save(:,2),'c')
grid off
xlabel('Time [s]','interpreter','latex')
ylabel('F [N]','interpreter','latex')
ylim([-2 3]);
% legend('Input force', 'u_x', 'u_q')
if print_flag ==1
print(gcf,'-dpng',printName, '-r600');
end
% figure
% plot(Time_result(1:end-1), X_result(1:end-1,2),'LineWidth',1.5)

% figure 
% plot(Time_result(1:10:end-1), F_fsave(1:10:end-1),'-ro','LineWidth',0.5)
% grid off
% xlabel('t [s]')
% ylabel('$F_f [N]$','interpreter','latex')
