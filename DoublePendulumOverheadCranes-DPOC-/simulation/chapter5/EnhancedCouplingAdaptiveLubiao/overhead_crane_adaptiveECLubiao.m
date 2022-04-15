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

% d_h = 0.03;d_p = 0.03;
d_h = 0.03;d_p = 0.03;
varepsilon = 0.01;
F=0;
T_final = 20;   % [s]
Ts = 0.01;      % control step time [s]
dim = 6;
video_flag = 0; % choose 1 if you want to save a video file of plot animation
disturbance_flag=1;
print_flag = 0;
comment_flag =0;

wdim = 1;
% ����λ�� �������ڽ� ����ذڽ� ��������ڽ� ���ز����ڽ� ����ʱ�� ���������
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
hatm_2psave=zeros(T_final/Ts+1,wdim);
X_Adaptive(1,:) = X';  %
% x_rsave = zeros(T_final/Ts+1,3);
count = 2;

% k =1;kalpha = 3.6;kbeta = 2.8; kdelta = 1;
k =1;kalpha = 6;kbeta =15; kdelta = 30;
hatm_2p = 0;

for time=Ts:Ts:T_final
    x = X(1);
    dotx=X(2);
    theta_h=X(3);
    dottheta_h=X(4);
    theta_p = X(5);
    dottheta_p=X(6);
% 
%     Y(1) = tanh(dotx/varepsilon);
% 	Y(2) = dotx*abs(dotx);
    e_x = x-x_d;
    
    hatlambda_1 = k*(m_h+hatm_2p);
    hatlambda_2 = k*hatm_2p;
    H = dotx-hatlambda_1*(l_h*sin(theta_h)-l_h*cos(theta_h)*dottheta_h)...
        -hatlambda_2*l_p*cos(theta_p)*dottheta_p;
    hate = e_x-hatlambda_1*sin(theta_h)-hatlambda_2*sin(theta_p);
     F_f = f_rx*tanh(dotx/varepsilon)-k_rx*abs(dotx)*dotx;
    F = -k*kalpha*hate-k*kbeta*H+F_f; %+F_f
    E=l_h*sin(theta_h)+l_p*sin(theta_p);
    dotE = l_h*cos(theta_h)*dottheta_h+l_p*cos(theta_p)*dottheta_p;
    hatm_2psave(count) = hatm_2p;
    [T, X_next] = ode45(@diffDualPendulum, [0, Ts], X);    %[t,y] = ode45(odefun,tspan,y0)
%      hatw = hatw - Gamma*Y*dotx*Ts;
     hatm_2p = hatm_2p-(k*(kalpha*E-kbeta*dotE))/(kdelta-kalpha*k*k*E*E)*Ts;
    X = X_next(end,:)'; %����X��ȡX_next�����һ�����ݣ�Ҳ������һ������
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
 %     �������ڽ�
    if abs(X(3)*57.3)>abs(res(2))    
        res(2)=X(3)*57.3;
    end
%     ����ذڽ�
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
    if flag&&time>=res(6)
        if res(4)<abs(X(3)*57.3)
            res(4) = abs(X(3)*57.3);
        end
        if res(5)<abs(X(5)*57.3)
            res(5) = abs(X(5)*57.3);
        end
     end
     res(8) = res(8)+Ts*F*F;
    
%     ���������
    if abs(F)>abs(res(7))
        res(7)=F;
    end
end
res(1)=X(1);

%% Free fall (No control)
%[T, Z_ode] = ode45(@diff_pendulum, [0, T_final], X);

% Make video comment 1


%% Plot
X_result = X_Adaptive;
Time_result = time_Adaptive;
if video_flag == 1
    animation(X_result,Time_result,'EnhancedCouplingAdaptiveLubiao',x_d,l_h,l_p,Ts);
end
printName = 'ECAdaptive';
if disturbance_flag==1
    printName = strcat(printName,'disturbance');
end
posylimit = [0 1.2];
h2=figure(2);
set(h2,'position',[50 50 400 400]);
LineWidth = 0.7;
LineColor = [0 0 0.7];
setx = ones(length(Time_result(1:end-1)))*x_d;
subplot(4,1,1)
plot(Time_result(1:end-1), X_result(1:end-1,1),'LineWidth',LineWidth,'Color',LineColor)
hold on
plot(Time_result(1:end-1),setx,'LineWidth',LineWidth,'Color',[0.7 0 0 ],'LineStyle','-.');
ylim(posylimit);
if comment_flag==1
cQ = sprintf('$k:%2.3f, kalpha:%2.3f, kbeta:%2.3f, kdelta:%2.3f$',k,kalpha,kbeta,kdelta);
params = sprintf('$m_c:%2.4f,m_h:%2.3f,m_p:%2.3f,l_h:%2.2f,l_p:%2.2f,d_h:%2.3f,d_p:%2.3f$',m_c,m_h,m_p,l_h,l_p,d_h,d_p);
results  = sprintf('$x_f:%2.3f,h_{max}:%2.3f,p_{max}:%2.3f,h_{res}:%2.3f,p_{res}:%2.3f,t_s:%2.3f,F_{max}:%2.3f,W:%2.3f$',res(1),res(2),res(3),res(4),res(5),res(6),res(7),res(8));
title({cQ;params;results},'interpreter','latex','FontSize',9);
end
grid off
xlabel('Time [s]','interpreter','latex')
ylabel('x[m]','interpreter','latex')


subplot(4,1,2)
plot(Time_result(1:end-1), X_result(1:end-1,3)*180/pi,'LineWidth',LineWidth,'Color',LineColor)
grid off
xlabel('Time [s]','interpreter','latex')
ylabel('$\theta_h[\deg]$','interpreter','latex')


subplot(4,1,3)
plot(Time_result(1:end-1), X_result(1:end-1,5)*180/pi,'LineWidth',LineWidth,'Color',LineColor)

grid off
xlabel('Time [s]','interpreter','latex')
ylabel('$\theta_p[\deg]$','interpreter','latex')


subplot(4,1,4)
plot(Time_result(1:end-1), F_save(1:end-1),'LineWidth',LineWidth,'Color',LineColor)
grid off
xlabel('Time [s]','interpreter','latex')
ylabel('F [N]','interpreter','latex')
% legend('Input force', 'u_x', 'u_q')
if print_flag==1
print(gcf,'-dpng',printName,'-r600');
end
% print(gcf,'-dpng',printName, '-r500');
% figure(3) 
% subplot(211)
% plot(Time_result(1:end-1), hatm_2psave(1:end-1),'LineWidth',1.5)
% subplot(212)
% plot(Time_result(1:end-1), hatWsave(1:end-1,2),'LineWidth',1.5)



