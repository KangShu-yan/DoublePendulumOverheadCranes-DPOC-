function x = animation(X_result,Time_result,name,x_d,l_h,l_p,Ts)
% Make video comment 1
% Video file open
makeVideo = VideoWriter(name);   %创建一个视频文件
% Frame Rate - Frames per second
makeVideo.FrameRate = 100;
% Quality - 侩樊苞 包访 凳 (0 ~ 100)
makeVideo.Quality = 80;
open(makeVideo);

axis_limit_x = x_d*1.5; axis_limit_y = l_h+l_p; 
grid off % 消除网格线
set(figure(1),'Color','w'); % 设置figure背景色为白色
set(figure(1),'Position',[700,200,230,200]);   % 设置图窗在pc界面显示的位置及大小

interval=25; % 每interval个点采一次
linewidthRate=0.2;
edge_x = 1.2;edge_y = 0.03;
step=150;
angleAmplify=5;
RGBVal=0.7;
cart_position_y = 0.05;
p_xsave = zeros(int16(size(X_result,1)/interval),0);
p_ysave = zeros(int16(size(X_result,1)/interval),0);
cnt = 1;
lastTime = 0;


for i=1:interval:size(X_result,1)    
    
    cart_position_x = X_result(i,1);
    pend_position_x = X_result(i,1) - l_h*sin(X_result(i,3)*angleAmplify);
    pend_position_y = l_h*cos(X_result(i,3)*angleAmplify);
    p_x = pend_position_x-l_p*sin(X_result(i,5)*angleAmplify);
    p_y = pend_position_y+l_p*cos(X_result(i,5)*angleAmplify);
    p_xsave(cnt) = p_x;
    p_ysave(cnt)=p_y;
    cnt=cnt+1;
   
    colorVal=RGBVal-mod(i-1,step)/interval*(RGBVal/step*interval);    % 0.9是RGB的初值
     if  mod(i-1,step)==0
        image_name=strcat('./withTimeImages/',num2str(i),'png');
        left = lastTime/Ts;
        right = Time_result(i)/Ts;
%         sim_status = sprintf('$Time: [%4.0fT_s, %4.0fT_s]$',left,right);
%          sim_status = sprintf('$[s]$',left,right);
%         title(sim_status,'interpreter','latex','FontSize',7);
        print(gcf, '-dpng',image_name, '-r500' );
        
        lastTime = Time_result(i);
        hold off;
    else
        hold on;
    end 
    
    plot(linspace(-0.2,edge_x+0.2,2), linspace(-edge_y,-edge_y,2), 'k', 'LineWidth', 0.5); %底座
%     hold on
%     plot(linspace(-0.2,edge_x+0.2,2), linspace(-edge_y-0.01,-edge_y-0.01,2), 'k', 'LineWidth', 0.5); %底座
    hold on
    plot(pend_position_x, -pend_position_y, 'ok', 'MarkerSize', 3,'MarkerEdgeColor',[colorVal colorVal colorVal],'MarkerFaceColor',[colorVal colorVal colorVal])   % pendulum
    hold on
     plot(p_x, -p_y, 'ok', 'MarkerSize', 3,'MarkerEdgeColor',[colorVal colorVal colorVal],'MarkerFaceColor',[colorVal colorVal colorVal])   % pendulum
    hold on
    
    plot(cart_position_x-0.065, 0, 'ok', 'MarkerSize', 3,'MarkerEdgeColor',[colorVal colorVal colorVal])   % wheel
    hold on
    plot(cart_position_x+0.065, 0, 'ok', 'MarkerSize', 3,'MarkerEdgeColor',[colorVal colorVal colorVal])   % wheel
    hold on 
    cx = [cart_position_x-0.15,cart_position_x+0.15,cart_position_x+0.15,cart_position_x-0.15,cart_position_x-0.15];
    cy = [cart_position_y-0.05,cart_position_y-0.05,cart_position_y+0.05,cart_position_y+0.05,cart_position_y-0.05];
    
%     plot(cx,cy,'MarkerEdgeColor',[colorVal colorVal colorVal]);
    plot(cx,cy,'Color',[colorVal colorVal colorVal]);
%     plot(cart_position_x+0.045, 0.06, 'sk', 'MarkerSize', 25,'MarkerEdgeColor',[colorVal colorVal colorVal])    % cart
%     hold on 
%     plot(cart_position_x-0.045, 0.06, 'sk', 'MarkerSize', 25,'MarkerEdgeColor',[colorVal colorVal colorVal])    % cart
    hold on    
    %创建一个由区间 [cart_position_x,pend_position_x] 中的 7 个等距点组成的向量。
%     if cart_position_x > pend_position_x
       
    plot(linspace(cart_position_x,pend_position_x,2), linspace(0.05,-pend_position_y,2), 'k', 'LineWidth', 1.5,'Color',[colorVal colorVal colorVal])   % rod between cart and hook
    hold on
    plot(linspace(pend_position_x,p_x,2), linspace(-pend_position_y,-p_y,2), 'k', 'LineWidth', 1.5,'Color',[colorVal colorVal colorVal]); % [colorVal colorVal colorVal]
    grid off
    xlabel('[m]','interpreter','latex')
    ylabel('[m]','interpreter','latex')
    axis([-0.3 axis_limit_x -axis_limit_y-0.3 0.5])
%   sim_status = sprintf('Simulation time: %5.2f s, states : [%f %f %f %f %f %f]',Time_result(i),cart_position_x,dotx,theta_h,dottheta_h,theta_p,dottheta_p);
   
    if rem(Time_result(i),0.01) == 0
        frame = getframe(gcf);  %当前图窗的句柄
        writeVideo(makeVideo,frame);    %将视频数据写到文件
    end
    
    pause(Ts);  %暂时停止执行 MATLAB
end
    close(makeVideo);
     hold on;
    plot(p_xsave,-p_ysave,'Color','r','LineWidth',1.5);
    
end