% dual pendulum overhead crane Control 
% 2021.12.03 sk

close all; clear;
addpath ../
global m_c m_h m_p l_h l_p g F f_rx k_rx varepsilon d_h d_p
%% pendulum parameters


m_c   = 1.3551;       % [kg]
m_h   = 0.164;     % [kg]
m_p   = 0.08;       % [kg]
% m_h   = 0.08;     % [kg]
% m_p   = 0.164;       % [kg]
g   = 9.7898;   % [m/s^2]
F   = 0;      % [N]
l_h = 1;         % [m]
l_p = 0.5;       % [m]
% f_rx = 1.0;
% k_rx = -0.5;
f_rx = 94.0286;  
k_rx = -316.1468;
d_h = 0.03;d_p = 0.03;
varepsilon = 0.01;

% xx = load('referenceTrajectory.mat');
xx = load('trajectory20220121.mat');
% xx = load('trajectory20220216.mat');
if exist('referenceTrajectory.csv','file')==1
    delete('referenceTrajectory.csv');
end
% csvwrite('referenceTrajectory.csv',xx.x');

Ts = 0.01;      % control step time [s]
len = size(xx.x,2);
T_final = 20;   % [s]
pTs = len*Ts;

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
x_rsave = zeros(T_final/Ts+1,dim);
X_Adaptive(1,:) = X';  %
count = 2;
ddtheta_h = 0;ddtheta_p = 0;
% k = zeros(6);
subA = zeros(8); subB = zeros(2);

xstar = zeros(dim,1);
% x dotx theta_h dottheta_h theta_p dottheta_p
Q = [1.5 0 0 0 0 0 0;
     0 1 0 0 0 0 0 ;
     0 0 1 0 0 0 0;
     0 0 0 1 0 0  0;
     0 0 0 0 1 0 0;
     0 0 0 0 0 1 0;
     0 0 0 0 0 0  0.01];
 R = 1;
 eI = 0;
for t=Ts:Ts:T_final
    if t<=pTs
        xstar = xx.x(:,int16(t/Ts));
    else
        xstar = [x_d;0;0;0;0;0;0];
    end
    x= xstar(1);dotx = xstar(2); u = xstar(3);
    theta_h = xstar(4);dottheta_h = xstar(5);
    theta_p = xstar(6);dottheta_p = xstar(7);
    x_r = [x;dotx;theta_h;dottheta_h;theta_p;dottheta_p];
    
    mx = X(1);mdotx=X(2);   % m indicates measure
    mtheta_h=X(3);mdottheta_h=X(4);
    mtheta_p = X(5);mdottheta_p=X(6);
    
    subA(1) = (2*m_p*cos(theta_h - theta_p)*sin(theta_h - theta_p)*(d_h*theta_h + l_h*u*cos(theta_h)*(m_h + m_p) + g*l_h*sin(theta_h)*(m_h + m_p) + dottheta_p*l_h*l_p*m_p*theta_p*sin(theta_h - theta_p)))/(l_h^2*(- m_p*cos(theta_h - theta_p)^2 + m_h + m_p)^2) - (sin(theta_h - theta_p)*(d_p*theta_p + l_p*m_p*u*cos(theta_p) + g*l_p*m_p*sin(theta_p) - dottheta_h*l_h*l_p*m_p*theta_h*sin(theta_h - theta_p)))/(l_h*l_p*(- m_p*cos(theta_h - theta_p)^2 + m_h + m_p)) - (dottheta_h*m_p*cos(theta_h - theta_p)*(sin(theta_h - theta_p) + theta_h*cos(theta_h - theta_p)))/(- m_p*cos(theta_h - theta_p)^2 + m_h + m_p) - (d_h + g*l_h*cos(theta_h)*(m_h + m_p) - l_h*u*sin(theta_h)*(m_h + m_p) + dottheta_p*l_h*l_p*m_p*theta_p*cos(theta_h - theta_p))/(l_h^2*(- m_p*cos(theta_h - theta_p)^2 + m_h + m_p)) - (2*m_p*cos(theta_h - theta_p)^2*sin(theta_h - theta_p)*(d_p*theta_p + l_p*m_p*u*cos(theta_p) + g*l_p*m_p*sin(theta_p) - dottheta_h*l_h*l_p*m_p*theta_h*sin(theta_h - theta_p)))/(l_h*l_p*(- m_p*cos(theta_h - theta_p)^2 + m_h + m_p)^2);
    subA(2)= -(m_p*theta_h*cos(theta_h - theta_p)*sin(theta_h - theta_p))/(- m_p*cos(theta_h - theta_p)^2 + m_h + m_p);
    subA(3) = (sin(theta_h - theta_p)*(d_p*theta_p + l_p*m_p*u*cos(theta_p) + g*l_p*m_p*sin(theta_p) - dottheta_h*l_h*l_p*m_p*theta_h*sin(theta_h - theta_p)))/(l_h*l_p*(- m_p*cos(theta_h - theta_p)^2 + m_h + m_p)) + (cos(theta_h - theta_p)*(d_p + g*l_p*m_p*cos(theta_p) - l_p*m_p*u*sin(theta_p) + dottheta_h*l_h*l_p*m_p*theta_h*cos(theta_h - theta_p)))/(l_h*l_p*(- m_p*cos(theta_h - theta_p)^2 + m_h + m_p)) - (2*m_p*cos(theta_h - theta_p)*sin(theta_h - theta_p)*(d_h*theta_h + l_h*u*cos(theta_h)*(m_h + m_p) + g*l_h*sin(theta_h)*(m_h + m_p) + dottheta_p*l_h*l_p*m_p*theta_p*sin(theta_h - theta_p)))/(l_h^2*(- m_p*cos(theta_h - theta_p)^2 + m_h + m_p)^2) - (dottheta_p*l_p*m_p*(sin(theta_h - theta_p) - theta_p*cos(theta_h - theta_p)))/(l_h*(- m_p*cos(theta_h - theta_p)^2 + m_h + m_p)) + (2*m_p*cos(theta_h - theta_p)^2*sin(theta_h - theta_p)*(d_p*theta_p + l_p*m_p*u*cos(theta_p) + g*l_p*m_p*sin(theta_p) - dottheta_h*l_h*l_p*m_p*theta_h*sin(theta_h - theta_p)))/(l_h*l_p*(- m_p*cos(theta_h - theta_p)^2 + m_h + m_p)^2);
    subA(4) = -(l_p*m_p*theta_p*sin(theta_h - theta_p))/(l_h*(m_p*sin(theta_h - theta_p)^2 + m_h));
    
    subA(5) = (cos(theta_h - theta_p)*(d_h + g*l_h*cos(theta_h)*(m_h + m_p) - l_h*u*sin(theta_h)*(m_h + m_p) + dottheta_p*l_h*l_p*m_p*theta_p*cos(theta_h - theta_p)))/(l_h*l_p*(- m_p*cos(theta_h - theta_p)^2 + m_h + m_p)) - (sin(theta_h - theta_p)*(d_h*theta_h + l_h*u*cos(theta_h)*(m_h + m_p) + g*l_h*sin(theta_h)*(m_h + m_p) + dottheta_p*l_h*l_p*m_p*theta_p*sin(theta_h - theta_p)))/(l_h*l_p*(- m_p*cos(theta_h - theta_p)^2 + m_h + m_p)) + (dottheta_h*l_h*(m_h + m_p)*(sin(theta_h - theta_p) + theta_h*cos(theta_h - theta_p)))/(l_p*(- m_p*cos(theta_h - theta_p)^2 + m_h + m_p)) + (2*cos(theta_h - theta_p)*sin(theta_h - theta_p)*(m_h + m_p)*(d_p*theta_p + l_p*m_p*u*cos(theta_p) + g*l_p*m_p*sin(theta_p) - dottheta_h*l_h*l_p*m_p*theta_h*sin(theta_h - theta_p)))/(l_p^2*(- m_p*cos(theta_h - theta_p)^2 + m_h + m_p)^2) - (2*m_p*cos(theta_h - theta_p)^2*sin(theta_h - theta_p)*(d_h*theta_h + l_h*u*cos(theta_h)*(m_h + m_p) + g*l_h*sin(theta_h)*(m_h + m_p) + dottheta_p*l_h*l_p*m_p*theta_p*sin(theta_h - theta_p)))/(l_h*l_p*(- m_p*cos(theta_h - theta_p)^2 + m_h + m_p)^2);
    subA(6) = (l_h*theta_h*sin(theta_h - theta_p)*(m_h + m_p))/(l_p*(m_p*sin(theta_h - theta_p)^2 + m_h));
    subA(7) = (dottheta_p*m_p*cos(theta_h - theta_p)*(sin(theta_h - theta_p) - theta_p*cos(theta_h - theta_p)))/(- m_p*cos(theta_h - theta_p)^2 + m_h + m_p) - ((m_h + m_p)*(d_p + g*l_p*m_p*cos(theta_p) - l_p*m_p*u*sin(theta_p) + dottheta_h*l_h*l_p*m_p*theta_h*cos(theta_h - theta_p)))/(l_p^2*m_p*(- m_p*cos(theta_h - theta_p)^2 + m_h + m_p)) + (sin(theta_h - theta_p)*(d_h*theta_h + l_h*u*cos(theta_h)*(m_h + m_p) + g*l_h*sin(theta_h)*(m_h + m_p) + dottheta_p*l_h*l_p*m_p*theta_p*sin(theta_h - theta_p)))/(l_h*l_p*(- m_p*cos(theta_h - theta_p)^2 + m_h + m_p)) - (2*cos(theta_h - theta_p)*sin(theta_h - theta_p)*(m_h + m_p)*(d_p*theta_p + l_p*m_p*u*cos(theta_p) + g*l_p*m_p*sin(theta_p) - dottheta_h*l_h*l_p*m_p*theta_h*sin(theta_h - theta_p)))/(l_p^2*(- m_p*cos(theta_h - theta_p)^2 + m_h + m_p)^2) + (2*m_p*cos(theta_h - theta_p)^2*sin(theta_h - theta_p)*(d_h*theta_h + l_h*u*cos(theta_h)*(m_h + m_p) + g*l_h*sin(theta_h)*(m_h + m_p) + dottheta_p*l_h*l_p*m_p*theta_p*sin(theta_h - theta_p)))/(l_h*l_p*(- m_p*cos(theta_h - theta_p)^2 + m_h + m_p)^2);
    subA(8) = (m_p*theta_p*cos(theta_h - theta_p)*sin(theta_h - theta_p))/(- m_p*cos(theta_h - theta_p)^2 + m_h + m_p);
   
    subB(1)=-(2*m_h*cos(theta_h) + m_p*cos(theta_h) - m_p*cos(theta_h - 2*theta_p))/(l_h*(2*m_h + m_p - m_p*cos(2*theta_h - 2*theta_p)));
    subB(2)=((cos(2*theta_h - theta_p) - cos(theta_p))*(m_h + m_p))/(l_p*(2*m_h + m_p - m_p*cos(2*theta_h - 2*theta_p)));
    A = [0,1,0,0,0,0;
        0,0,0,0,0,0;
        0,0,0,1,0,0;
        0,0,subA(1),subA(2),subA(3),subA(4);
        0,0,0,0,0,1;
        0,0,subA(5),subA(6),subA(7),subA(8)];
    B = [0;1;0;subB(1);0;subB(2)];
    C = [1 1 1 1 1 1]';
    tildeA = [eye(dim,dim)+Ts*A, zeros(6,1);C',1];
    tildeB = [Ts*B;0];
%      tildeA = [A, zeros(6,1);C',1];
%     tildeB = [B;0];
    [K,S,e] = dlqr(tildeA,tildeB,Q,R);
    eI = eI+C'*(X-x_r);
    deltax = [X-x_r;eI];
    u = u-K*deltax;
    deltaM_theta = - l_h^2*l_p^2*m_p^2*cos(mtheta_h - mtheta_p)^2 + l_h^2*l_p^2*m_p^2 + m_h*l_h^2*l_p^2*m_p;
    invM_theta= 1/deltaM_theta*[ m_p*l_p^2 -m_p*l_h*l_p*cos(mtheta_h-mtheta_p);
        -m_p*l_h*l_p*cos(mtheta_h-mtheta_p) (m_h+m_p)*l_h^2];
    M_xtheta = [(m_h+m_p)*l_h*cos(mtheta_h) m_p*l_p*cos(mtheta_p)];
    M_x = [(m_h+m_p)*l_h*cos(mtheta_h);m_p*l_p*cos(mtheta_p)];
    M = m_c+m_h+m_p-M_xtheta*invM_theta*M_x;
    mdottheta = [mdottheta_h;mdottheta_p];
    C_theta = [d_h m_p*l_h*l_p*sin(mtheta_h-mtheta_p)*mdottheta_p;
        -m_p*l_h*l_p*cos(mtheta_h-mtheta_p)*mdottheta_h d_p];
    G_theta = [(m_h+m_p)*g*l_h*sin(mtheta_h); m_p*g*l_p*sin(mtheta_p)];
    H = -M_xtheta*invM_theta*(G_theta+C_theta*mdottheta)...
        -(m_h+m_p)*l_h*mdottheta_h^2*sin(mtheta_h)-m_p*l_p*mdottheta_p^2*sin(mtheta_p);
    F_f = f_rx*tanh(mdotx/varepsilon)-k_rx*abs(mdotx)*mdotx;
    F = F_f+M*u+H;
%     F_ax = F;
    
    [T, X_next] = ode45(@diffDualPendulum, [0, Ts], X);    %[t,y] = ode45(odefun,tspan,y0)
    X = X_next(end,:)'; %更新X，取X_next的最后一行数据，也是最新一组数据
    X_Adaptive(count,:) = X';
    x_rsave(count,:) = [xstar(1),xstar(2),xstar(4),xstar(5),xstar(6),xstar(7)];
    time_Adaptive(count) = t;
    F_save(count) = F;
    count = count + 1;   
    if disturbance_flag==1
        if t>10&&t<11
            X(3)=0.02*sin(t-10);
            X(5)=0.02*sin(t-10);
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
%         flag = 1;
%         res(1)=X(1);
% %         res(4) = X(3)*57.3;
% %         res(5)=X(5)*57.3;
%         res(6) = t;
%     end
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
%%



%% Plot
X_result = X_Adaptive;
Time_result = time_Adaptive;
% 是否显示动画并存为视频
if video_flag == 1
    animation(X_result,Time_result,'mBVPFeedforwardFeedback',x_d,l_h,l_p,Ts);
end

h = figure(2)
set(h,'position',[50 50 400 400]);
linewidth = 0.6;
Color = [0 0 0.7];
LineStyle = '-';
% figure('position',[550,100,500,500])

subplot(4,1,1)
plot(Time_result(1:end-1), X_result(1:end-1,1),'Color',Color,'LineStyle',LineStyle,'LineWidth',linewidth)
if video_flag==1
cQ = sprintf('               $Q:[%d, %d, %d, %d, %d, %d]$',Q(1,1),Q(2,2),Q(3,3),Q(4,4),Q(5,5),Q(6,6));
params = sprintf('$m_c:%2.3f,m_h:%2.3f,m_p:%2.3f,d_h:%2.3f,d_p:%2.3f$',m_c,m_h,m_p,d_h,d_p);
results  = sprintf('$x_f:%2.3f,h_{max}:%2.3f,p_{max}:%2.3f,h_{res}:%2.3f,p_{res}:%2.3f,t_s:%2.3f,F_{max}:%2.3f,W:%2.3f$',res(1),res(2),res(3),res(4),res(5),res(6),res(7),res(8));
title({cQ;params;results},'interpreter','latex','FontSize',9);
end
% title('Q is [',num2str(Q(1,1)),',',num2str(Q(2,2)),',',num2str(Q(3,3)),',',num2str(Q(4,4)),',',num2str(Q(5,5)),',',num2str(Q(6,6)),']');
% plot(Time_result, X_result(:,1:2))
hold on ;
plot(Time_result(1:end-1),x_rsave(1:end-1,1),'--','LineWidth',linewidth);
grid off
xlabel('Time [s]')
ylabel('x[m]','interpreter','latex')
% legend('cart position [m]', 'cart velocity [m/s]')

subplot(4,1,2)
plot(Time_result(1:end-1), X_result(1:end-1,3)*180/pi,'Color',Color,'LineStyle',LineStyle,'LineWidth',linewidth)
% plot(Time_result, X_result(:,3:4)*180/pi)
hold on ;
plot(Time_result(1:end-1),x_rsave(1:end-1,3)*180/pi,'--','LineWidth',linewidth);
grid off
xlabel('Time [s]')
ylabel('$\theta_h[\deg]$','interpreter','latex')
% legend('pendulum angle [deg]', 'pendulum velocity [deg/s]')

subplot(4,1,3)
plot(Time_result(1:end-1), X_result(1:end-1,5)*180/pi,'Color',Color,'LineStyle',LineStyle,'LineWidth',linewidth)
% plot(Time_result, X_result(:,3:4)*180/pi)
hold on ;
plot(Time_result(1:end-1),x_rsave(1:end-1,5)*180/pi,'--','LineWidth',linewidth);
grid off
xlabel('Time [s]')
ylabel('$\theta_p[\deg]$','interpreter','latex')
% legend('pendulum angle [deg]', 'pendulum velocity [deg/s]')

subplot(4,1,4)
plot(Time_result(1:end-1), F_save(1:end-1),'Color',Color,'LineStyle',LineStyle,'LineWidth',linewidth)
% hold on
% plot(Time_result, u_save(:,1),'r')
% plot(Time_result, u_save(:,2),'c')
grid off
xlabel('Time [s]')
ylabel('F [N]','interpreter','latex')
% legend('Input force', 'u_x', 'u_q')
