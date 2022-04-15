% dual pendulum overhead crane Control 
% 2021.12.27 sk

% close all; clear;
addpath ../
global m_c m_h m_p l_h l_p g F_ax f_rx k_rx varepsilon d_h d_p
%% pendulum parameters
m_c   = 20;       % [kg]
m_h   = 1;     % [kg]
m_p   = 5;       % [kg]
g   = 9.8;   % [m/s^2]
F_ax   = 0;      % [N]
l_h = 2;         % [m]
l_p = 0.4;       % [m]
f_rx = 1.0;
k_rx = -0.5;
d_h = 0.03;d_p = 0.03;
varepsilon = 0.01;
F=0;
T_final = 30;   % [s]
Ts = 0.01;      % control step time [s]
video_flag = 0; % choose 1 if you want to save a video file of plot animation
dim = 6;
disturbance_flag=0;

%% initial condition
X   = zeros(dim,1);
x_d = 0.4;
%% adaptive Control
% data save
X_Adaptive = zeros(T_final/Ts+1,dim);
time_Adaptive = zeros(T_final/Ts+1,1);
F_save = zeros(T_final/Ts+1,1);
hatWsave=zeros(T_final/Ts+1,5);
X_Adaptive(1,:) = X';  %
count = 2;
dotthidex = 0;
ki = 1;
kp = 1;kd = 30;lambda_x =1.2;lambda_h =1;lambda_p = 1;
% varGamma=[3 0 0 0 0 ;
%             0 3 0 0 0 ;
%             0 0 3 0 0  ;
%             0 0 0 3 0 ;
%             0 0 0 0 3];
varGamma = eye(5,5)*5;
Y = zeros(5,1);
sumtildex = 0; hatw = zeros(5,1);
for time=Ts:Ts:T_final
    x = X(1);
    dotx=X(2);
    theta_h=X(3);
    dottheta_h=X(4);
    theta_p = X(5);
    dottheta_p=X(6);
    Y(1) = -tanh(dotx/varepsilon);
    Y(2) = abs(dotx)*dotx;
    
%     tildex = x-x_d-lambda_h*theta_h-lambda_p*theta_p;
     tildex = x-x_d;
%     Y(3) = lambda_x*(dotx+lambda_x*tildex-lambda_h*dottheta_h-lambda_p*dottheta_p);
    Y(3) = lambda_x*(dotx+lambda_x*tildex-lambda_h*dottheta_h-lambda_p*dottheta_p);
    Y(4) = lambda_x*cos(theta_h)*dottheta_h;
    Y(5) = lambda_x*cos(theta_p)*dottheta_p;
    
%     Y(3) = (lambda_x*tildex-lambda_h*dottheta_h-lambda_p*dottheta_p);
%     Y(4) = cos(theta_h)*dottheta_h;
%     Y(5) = cos(theta_p)*dottheta_p;
%     Y = Y';
    sumtildex = sumtildex+tildex*Ts;
   
    hatWsave(count,:)=hatw';
%      F = -ki*(x-x_d+lambda_x*sumtildex)-kd*(dotx+lambda_x*tildex)-kp*(tildex+lambda_h*theta_h+lambda_p*theta_p)-Y'*hatw;
%     F = -kd*(dotx+lambda_x*tildex)-kp*(tildex+lambda_h*theta_h+lambda_p*theta_p)-Y'*hatw;
%     F =-kp*(x+lambda_x*sumtildex) -kd*(dotx+lambda_x*tildex)-kp*(tildex+lambda_h*theta_h+lambda_p*theta_p)-Y'*hatw;
     F = -kp*(x-x_d+lambda_x*sumtildex)-kd*(dotx+lambda_x*tildex)-Y'*hatw;
%      F = -kp*(x-x_d)-kd*(dotx-lambda_x*tildex-lambda_h*theta_h-lambda_p*theta_p)-Y'*hatw;
    F_ax = F;
    [T, X_next] = ode45(@diffDualPendulum, [0, Ts], X);    %[t,y] = ode45(odefun,tspan,y0)
     hatw = hatw + varGamma*Y*(dotx+lambda_x*tildex)*Ts;
    X = X_next(end,:)'; %更新X，取X_next的最后一行数据，也是最新一组数据
    X_Adaptive(count,:) = X';
    time_Adaptive(count) = time;
    F_save(count) = F;
    count = count + 1;   
end


%% Free fall (No control)
%[T, Z_ode] = ode45(@diff_pendulum, [0, T_final], X);

% Make video comment 1
% if video_flag == 1  
%     % Video file open
%     makeVideo = VideoWriter('IPC_Fuzzy');   %创建一个视频文件
%     % Frame Rate - Frames per second
%     makeVideo.FrameRate = 100;
%     % Quality - 侩樊苞 包访 凳 (0 ~ 100)
%     makeVideo.Quality = 80;
%     open(makeVideo);
% end

%% Plot
X_result = X_Adaptive;
Time_result = time_Adaptive;
%  comment 2
% figure(1)
% grid off  % 取消网格线
% axis_limit = 0.8;
% for i=1:size(X_result,1)    
%     cart_position_x = X_result(i,1);
%     pend_position_x = X_result(i,1) - l*sin(X_result(i,3));
%     pend_position_y = l*cos(X_result(i,3));
%     x_dot = X_result(i,2);
%     theta = X_result(i,3);
%     theta_dot = X_result(i,4);
%     hold off
%     plot(pend_position_x, -pend_position_y, 'ok', 'MarkerSize', 25, 'MarkerFaceColor',[1 0.2 0.2])   % pendulum
%     hold on
%     plot(cart_position_x-0.06, 0, 'ok', 'MarkerSize', 10, 'MarkerFaceColor',[1 0.9 0.2])   % wheel
%     hold on
%     plot(cart_position_x+0.06, 0, 'ok', 'MarkerSize', 10, 'MarkerFaceColor',[1 0.9 0.2])   % wheel
%     hold on 
%     plot(cart_position_x+0.045, 0.06, 'sk', 'MarkerSize', 25, 'MarkerFaceColor',[0.4 0.4 0.7])    % cart
%     hold on 
%     plot(cart_position_x-0.045, 0.06, 'sk', 'MarkerSize', 25, 'MarkerFaceColor',[0.4 0.4 0.8])    % cart
%     hold on    
%     %创建一个由区间 [cart_position_x,pend_position_x] 中的 7 个等距点组成的向量。
%     if cart_position_x > pend_position_x
%         plot(linspace(cart_position_x,pend_position_x,2), linspace(0.05,-pend_position_y,2), 'k', 'LineWidth', 1)   % rod
%     else
%         plot(linspace(cart_position_x,pend_position_x,2), linspace(0.05,-pend_position_y,2), 'r', 'LineWidth', 1)   % rod
%     end
%     grid on
%     xlabel('[m]')
%     ylabel('[m]')
%     axis([-axis_limit axis_limit -0.5 0.5])
%     sim_status = sprintf('Simulation time: %5.2f s, states : [%f %f %f %f]',Time_result(i),cart_position_x,x_dot,theta,theta_dot);
%     title(sim_status,'FontSize',9)
%     
%     if video_flag == 1 && rem(Time_result(i),0.01) == 0
%         frame = getframe(gcf);  %当前图窗的句柄
%         writeVideo(makeVideo,frame);    %将视频数据写到文件
%     end
%     
%     pause(Ts);  %暂时停止执行 MATLAB
% end
% 
% if video_flag == 1
%     close(makeVideo);
% end

figure
subplot(4,1,1)
plot(Time_result(1:end-1), X_result(1:end-1,1),'LineWidth',1.5)
% plot(Time_result, X_result(:,1:2))
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
% legend('Input force', 'u_x', 'u_q')
