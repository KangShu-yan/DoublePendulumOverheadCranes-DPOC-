% dual pendulum overhead crane Control 
% 2021.12.03 sk

close all; clear; 
global psi_1upper psi_1lower m_1 x_0upper x_0lower T x_0 x_T x_1upper x_1lower x_2upper x_2lower m_c m_h m_p d_h d_p l_h l_p g 
flag  = 1;
m_c   = 1.3551;       % [kg]
m_h   = 0.164;     % [kg]
m_p   = 0.08;       % [kg]
g   = 9.7898;   % [m/s^2]
% F   = 0;      % [N]
l_h =1;         % [m]
l_p = 0.5;       % [m]
d_h = 0.03;d_p = 0.03;


x_0 = 0;x_T = 1; x_d = x_T;ka = 1;kv = 1;epsilon =5;
T =6;  % 5s
Ts = 0.01;
N = T/Ts;    % 点数
% N = 500;
% [xi_1 xi_2 theta_h dottheta_h theta_p dottheta_p]
% guess = [0.1;0;0;0;0;0]; % 满足边界条件的常数初始猜测值
guess = [10e-6;10e-6;10e-6;10e-6;10e-6;10e-6];
% guess = ones(6,1);
xmesh = linspace(0.001,T,N);    % 0-1内找5个点
params = [0;0;0;0;0;0]; % p = 0 
% params = [1;1;1;1;1;1;1;1];

x_0upper = 5;
x_0lower =-x_0upper ;    % [-0.5,0.5] m

psi_1upper = x_0upper;
psi_1lower = -psi_1upper;
m_1 = 4/(psi_1upper-psi_1lower);
x_1upper =1 ;x_1lower =-x_1upper ;    % [-0.4,0.4] m/s
x_2upper =1;x_2lower =-x_2upper ;      % [-1, 1] m/s^2 	0.26m/s

%% 计算主体
solinit = bvpinit(xmesh, guess,params);
% S = [0 0; 0 -2];
% options = bvpset('SingularTerm',S);
% sol = bvp4c(@emdenode, @emdenbc, solinit, options);
sol = bvp5c(@emdenode, @emdenbc, solinit);
% x = linspace(0,T);
len = length(sol.y);
x = zeros(7,len);
x_r = zeros(1,len); dotx_r = zeros(1,len);ddotx_r = zeros(1,len);
varphisave = zeros(1,len);
% figure 
% ph = plot(0,0);
% ax = gca;
% set(ax,'XLim',[0,T]);
% set(ax,'YLim',[-10,10]);
params = sol.parameters;
vmax = 0; amax = 0;
for i = 1:length(sol.y) 
    t = sol.x(i);
    x(1,i) =x_0upper-(x_0upper-x_0lower)/ (1+exp(m_1*sol.y(1,i))); 
    xi_1 = sol.y(1,i);
    dotpsi_1 = 4*exp(m_1*xi_1)/(exp(m_1*xi_1)+1)^2;
    psi_2upper = x_1upper/dotpsi_1;
    psi_2lower = -psi_2upper ;
    m_2 = 4/(psi_2upper-psi_2lower);
    xi_2 = sol.y(2,i);
    psi_2 = psi_2upper-(psi_2upper-psi_2lower)/(1+exp(m_2*xi_2));
    x(2,i) = dotpsi_1*psi_2;
    if x(2,i)>vmax
        vmax = x(2,i);
    end
    ddotpsi_1 = 4*m_1*exp(m_1*xi_1)*(1-exp(m_1*xi_1))/(exp(m_1*xi_1)+1)^3;
    
    dotpsi_2 = 4*exp(m_2*xi_2)/(exp(m_2*xi_2)+1)^2;
    dotpsi2upperxi1 = x_1upper/4*m_1*(exp(m_1*xi_1)-exp(-m_1*xi_1));
    dotpsi2lowerxi1 = -dotpsi2upperxi1;
    dotpsi2xi1 = dotpsi2upperxi1-(dotpsi2upperxi1-dotpsi2lowerxi1)/(1+exp(m_2*xi_2))...
            +4*xi_2*exp(m_2*xi_2)*(dotpsi2upperxi1-dotpsi2lowerxi1)/(1+exp(m_2*xi_2))/(psi_2upper-psi_2lower);

    psi_3upper = (x_2upper-ddotpsi_1*psi_2^2-dotpsi_1*dotpsi2xi1*psi_2)*(dotpsi_1*dotpsi_2)^(-1);
    psi_3lower = (x_2lower-ddotpsi_1*psi_2^2-dotpsi_1*dotpsi2xi1*psi_2)*(dotpsi_1*dotpsi_2)^(-1);
%     psi_3upper = (x_2upper-ddotpsi_1*psi_2^2)*(dotpsi_1*dotpsi_2)^(-1);
%     psi_3lower = (x_2lower-ddotpsi_1*psi_2^2)*(dotpsi_1*dotpsi_2)^(-1);
    varphi =params(1)*sin(pi*t/T)+params(2)*sin(2*pi*t/T)+params(3)*sin(3*pi*t/T)...
    +params(4)*sin(4*pi*t/T)+params(5)*sin(5*pi*t/T)+params(6)*sin(6*pi*t/T);
    varphisave(i) = varphi;
    if varphi>=psi_3lower & varphi<=psi_3upper
        psi_3 = varphi;
    elseif varphi<psi_3lower
        psi_3 = psi_3lower;
    else 
        psi_3 = psi_3upper;    
    end
      x(3,i) = ddotpsi_1*psi_2^2+dotpsi_1*dotpsi_2*psi_3;
      if x(3,i)>amax
        amax = x(3,i);
      end
      
    x_r(i) = x_d/2+kv^2/4/ka*log(cosh(2*ka*t/kv-epsilon)/cosh(2*ka*t/kv-epsilon-2*x_d*ka/kv^2));
	dotx_r(i) = kv*(tanh(2*ka*t/kv-epsilon)-tanh(2*ka*t/kv-epsilon-2*x_d*ka/kv^2))/2;
	ddotx_r(i) = ka*(1/(cosh(2*ka*t/kv-epsilon)^2)-1/(cosh(2*ka*t/kv-epsilon-2*x_d*ka/kv^2)^2));  
   
%     set(ph,'XData',t);
%     set(ph,'YData',varphi);
%     hold on;
%     plot(t,varphi);
%     drawnow;
end
x(4,:)=sol.y(3,:);x(5,:)=sol.y(4,:);
x(6,:)=sol.y(5,:);x(7,:)=sol.y(6,:);
theta_hmax = max(sol.y(3,:)*57.2958);
dottheta_hmax = max(sol.y(4,:)*57.2958);
theta_pmax = max(sol.y(5,:)*57.2958);
dottheta_pmax = max(sol.y(6,:)*57.2958);
theta_hmin = min(sol.y(3,:)*57.2958);
dottheta_hmin = min(sol.y(4,:)*57.2958);
theta_pmin = min(sol.y(5,:)*57.2958);
dottheta_pmin = min(sol.y(6,:)*57.2958);


% figure 
% plot(sol.x,varphisave);

linewidth = 0.7;
figurewidth = 400;
figureheight = 400;
LineColor = [0 0 0.7];
% Color = [0.85,0.33,0.10];
Color = [1,0,0];
xlimit = [0 x_d+0.2];
dotxlimit = [0 1];
xilimit = [0 x_d+0.2];
vlimit = [-0.35 0.35];
thetalimit = [-3 3];
dotthetalimit = [-6 6];
tar = './bvpRes/'; 
printx = 'x';
printxi = 'xi';
printtheta = 'theta';

printx = strcat(tar,printx,num2str(x_d),'m');
printxi = strcat(tar,printxi,num2str(x_d),'m');
printtheta = strcat(tar,printtheta,num2str(x_d),'m');

h = figure(1);

set(h,'position',[50 50 figurewidth figureheight]);
subplot(311)
% plot(sol.x,sol.y(1,:),'ro');
plot(sol.x,x(1,:),'LineWidth',linewidth,'Color',LineColor);
marks = sprintf('$m_c,m_h,m_p,d_h,d_p,x_T = [%2.4f, %2.3f, %2.3f, %2.3f, %2.3f, %2.3f]$',m_c,m_h,m_p,d_h,d_p,x_T);
% title(marks,'interpreter','latex','FontSize',9)
hold on ;
plot(sol.x,x_r,'--','LineWidth',linewidth,'Color',Color);
ylim(xlimit);

xlabel('Time [s]','interpreter','latex');
ylabel('$x[m]$','interpreter','latex');



subplot(312)
plot(sol.x,x(2,:),'LineWidth',linewidth,'Color',LineColor);
hold on ;
plot(sol.x,dotx_r,'--','LineWidth',linewidth,'Color',Color);
xlabel('Time [s]','interpreter','latex');
ylabel('$\dot x[m/s]$','interpreter','latex');
ylim(dotxlimit);


subplot(313)
plot(sol.x,x(3,:),'LineWidth',linewidth,'Color',LineColor);
hold on ;
plot(sol.x,ddotx_r,'--','LineWidth',linewidth,'Color',Color);
xlabel('Time [s]','interpreter','latex');
ylabel('$\ddot x[m/s^2]$','interpreter','latex');
% print(gcf,'-dpng',printddotx, '-r600');
print(gcf,'-dpng',printx, '-r600');

if flag
h = figure(2);
set(h,'position',[50 50 figurewidth figureheight]);
subplot(311)
% plot(sol.x,sol.y(1,:),'ro');
plot(sol.x,sol.y(1,:),'LineWidth',linewidth,'Color',Color);
marks = sprintf('$m_c,m_h,m_p,d_h,d_p,x_T = [%2.4f, %2.3f, %2.3f, %2.3f, %2.3f, %2.3f]$',m_c,m_h,m_p,d_h,d_p,x_T);
% title(marks,'interpreter','latex','FontSize',9)
% title('dual pendulum with BVP.')
% legend('Computed');
xlabel('Time [s]','interpreter','latex');
ylabel('$\xi_1$','interpreter','latex');
ylim(xilimit);



subplot(312)
plot(sol.x,sol.y(2,:),'LineWidth',linewidth,'Color',LineColor);
xlabel('Time [s]','interpreter','latex');
ylabel('$\xi_2$','interpreter','latex');


subplot(313)

t = sol.x;
plot(t, params(1)*sin(pi*t/T)+params(2)*sin(2*pi*t/T)+params(3)*sin(3*pi*t/T)...
    +params(4)*sin(4*pi*t/T)++params(5)*sin(5*pi*t/T)+params(6)*sin(6*pi*t/T),'LineWidth',linewidth,'Color',LineColor);
xlabel('Time [s]','interpreter','latex');
ylabel('$v $','interpreter','latex');
ylim(vlimit);
print(gcf,'-dpng',printxi, '-r600');

h = figure(3);
set(h,'position',[50 50 figurewidth figureheight]);
subplot(411)
plot(sol.x,sol.y(3,:)*57.2958,'LineWidth',linewidth,'Color',Color);
marks = sprintf('$m_c,m_h,m_p,d_h,d_p,x_T = [%2.4f, %2.3f, %2.3f, %2.3f, %2.3f, %2.3f]$',m_c,m_h,m_p,d_h,d_p,x_T);
% title(marks,'interpreter','latex','FontSize',9)
xlabel('Time [s]','interpreter','latex');
ylabel('$\theta_h [{deg}]$','interpreter','latex');
ylim(thetalimit);


subplot(412)
plot(sol.x,sol.y(4,:)*57.2958,'LineWidth',linewidth,'Color',LineColor);
xlabel('Time [s]','interpreter','latex');
ylabel('$\dot\theta_h [deg/s]$','interpreter','latex');
ylim(dotthetalimit);



subplot(413)
plot(sol.x,sol.y(5,:)*57.2958,'LineWidth',linewidth,'Color',Color);
xlabel('Time [s]','interpreter','latex');
ylabel('$\theta_p [{deg}]$','interpreter','latex');
ylim(thetalimit);


subplot(414)
plot(sol.x,sol.y(6,:)*57.2958,'LineWidth',linewidth,'Color',LineColor);
xlabel('Time [s]','interpreter','latex');
ylabel('$\dot \theta_p [deg/s]$','interpreter','latex');
ylim(dotthetalimit);
print(gcf,'-dpng',printtheta, '-r600');

end 

% figure
% subplot(411)
% plot(sol.x,sol.y(3,:),'o');
% xlabel('$Time(s)$','interpreter','latex');
% ylabel('$\theta_h (rad)$','interpreter','latex');
% subplot(412)
% plot(sol.x,sol.y(4,:),'o');
% xlabel('$Time(s)$','interpreter','latex');
% ylabel('$\dot\theta_h (rad/s)$','interpreter','latex');
% subplot(413)
% plot(sol.x,sol.y(5,:),'o');
% xlabel('$Time(s)$','interpreter','latex');
% ylabel('$\theta_p (rad)$','interpreter','latex');
% subplot(414)
% plot(sol.x,sol.y(6,:),'o');
% xlabel('$Time(s)$','interpreter','latex');
% ylabel('$\dot \theta_p (\deg)$','interpreter','latex');



function dydx = emdenode(x,y,params) % equation being solved 
% fprintf("%4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f %4.2f \n",params);
global psi_1upper psi_1lower m_1  x_0upper x_0lower T x_1upper x_1lower x_2upper x_2lower m_c m_h m_p d_h d_p l_h l_p g
t = x;
xi_1 = y(1);
xi_2 = y(2);
theta_h = y(3);
dottheta_h = y(4);
theta_p = y(5);
dottheta_p=y(6);
% m_1 = 4/(psi_1upper-psi_1lower);
% T = 5; 



dotpsi_1 = 4*exp(m_1*xi_1)/(exp(m_1*xi_1)+1)^2;
ddotpsi_1 = 4*m_1*exp(m_1*xi_1)*(1-exp(m_1*xi_1))/(exp(m_1*xi_1)+1)^3;
psi_2upper = x_1upper/dotpsi_1;
psi_2lower = -psi_2upper ;
m_2 = 4/(psi_2upper-psi_2lower);

psi_2 = psi_2upper-(psi_2upper-psi_2lower)/(1+exp(m_2*xi_2));
dotpsi_2 = 4*exp(m_2*xi_2)/(exp(m_2*xi_2)+1)^2;
dotpsi2upperxi1 = x_1upper/4*m_1*(exp(m_1*xi_1)-exp(-m_1*xi_1));
dotpsi2lowerxi1 = -dotpsi2upperxi1;
dotpsi2xi1 = dotpsi2upperxi1-(dotpsi2upperxi1-dotpsi2lowerxi1)/(1+exp(m_2*xi_2))...
            +4*xi_2*exp(m_2*xi_2)*(dotpsi2upperxi1-dotpsi2lowerxi1)/(1+exp(m_2*xi_2))/(psi_2upper-psi_2lower);

        
psi_3upper = (x_2upper-ddotpsi_1*psi_2^2-dotpsi_1*dotpsi2xi1*psi_2)*(dotpsi_1*dotpsi_2)^(-1);
psi_3lower = (x_2lower-ddotpsi_1*psi_2^2-dotpsi_1*dotpsi2xi1*psi_2)*(dotpsi_1*dotpsi_2)^(-1);
varphi =params(1)*sin(pi*t/T)+params(2)*sin(2*pi*t/T)+params(3)*sin(3*pi*t/T)...
    +params(4)*sin(4*pi*t/T)+params(5)*sin(5*pi*t/T)+params(6)*sin(6*pi*t/T);

if varphi>=psi_3lower & varphi<=psi_3upper
    psi_3 = varphi;
elseif varphi<psi_3lower
    psi_3 = psi_3lower;
else 
    psi_3 = psi_3upper;    
end

v = ddotpsi_1*psi_2^2+dotpsi_1*dotpsi_2*psi_3;
% ustar = v;
D = - l_h^2*l_p^2*m_p^2*cos(theta_h - theta_p)^2 + l_h^2*l_p^2*m_p^2 + m_h*l_h^2*l_p^2*m_p;
% Mtheta = [(m_h+m_p)*l_h^2 m_p*l_p*cos(theta_h-theta_p);
%             m_p*l_p*cos(theta_h-theta_p) m_p*l_p^2 ];
% invMTheta = inv(Mtheta);
invMTheta = 1/D*[m_p*l_p^2 -m_p*l_h*l_p*cos(theta_h-theta_p);
        -m_p*l_h*l_p*cos(theta_h-theta_p) (m_h+m_p)*l_h^2];
C_theta = [d_h m_p*l_h*l_p*sin(theta_h-theta_p*dottheta_p);
            -m_p*l_h*l_p*sin(theta_h-theta_p)*dottheta_h d_p];    
G_theta = [(m_h+m_p)*g*l_h*sin(theta_h);m_p*g*l_p*sin(theta_p)];
B_theta = [-(m_h+m_p)*l_h*cos(theta_h);-m_p*l_p*cos(theta_p)];
dottheta=[dottheta_h;dottheta_p];
% ddtheta = zeros(2,1);
ddtheta = invMTheta*(-C_theta*dottheta-G_theta+B_theta*v);



% f_1 = (l_p*cos(theta_h - theta_p)*(d_p*theta_p + g*l_p*m_p*sin(theta_p) - dottheta_h*l_h*l_p*m_p*theta_h*sin(theta_h - theta_p)))/(l_h^3*m_h + l_h^3*m_p - l_h*l_p^2*m_p*cos(theta_h - theta_p)^2) ...
%     - (d_h*theta_h  + g*l_h*sin(theta_h)*(m_h + m_p) + dottheta_p*l_h*l_p*m_p*theta_p*sin(theta_h - theta_p))/(l_h^2*m_h + l_h^2*m_p - l_p^2*m_p*cos(theta_h - theta_p)^2);
% f_2 = (l_p*cos(theta_h - theta_p)*(d_h*theta_h + g*l_h*sin(theta_h)*(m_h + m_p) + dottheta_p*l_h*l_p*m_p*theta_p*sin(theta_h - theta_p)))/(l_h^3*m_h + l_h^3*m_p - l_h*l_p^2*m_p*cos(theta_h - theta_p)^2) ...
%     - ((m_h + m_p)*(d_p*theta_p + g*l_p*m_p*sin(theta_p) - dottheta_h*l_h*l_p*m_p*theta_h*sin(theta_h - theta_p)))/(l_h^2*m_p^2 + m_h*l_h^2*m_p - l_p^2*m_p^2*cos(theta_h - theta_p)^2);
% b_1 =l_p*cos(theta_h - theta_p)*l_p*m_p*v*cos(theta_p)/(l_h^3*m_h + l_h^3*m_p - l_h*l_p^2*m_p*cos(theta_h - theta_p)^2) - l_h*v*cos(theta_h)*(m_h + m_p)/(l_h^2*m_h + l_h^2*m_p - l_p^2*m_p*cos(theta_h - theta_p)^2) ;
% b_2 = l_p*cos(theta_h - theta_p)*(l_h*v*cos(theta_h)*(m_h + m_p) )/(l_h^3*m_h + l_h^3*m_p - l_h*l_p^2*m_p*cos(theta_h - theta_p)^2) - (m_h + m_p)*(l_p*m_p*v*cos(theta_p))/(l_h^2*m_p^2 + m_h*l_h^2*m_p - l_p^2*m_p^2*cos(theta_h - theta_p)^2); 

dydx = [psi_2
        psi_3
        y(4)
       ddtheta(1)
        y(6)
       ddtheta(2)];
end

%-边界条件
function res = emdenbc(ya,yb,params) % boundary conditions [a,b]->[0,T]
global psi_1upper psi_1lower m_1  x_0upper x_0lower T x_0 x_T  
%% 轨迹起与止
t = 0;
   
xi_10 = 1/m_1*log((psi_1lower-x_0)/(x_0-psi_1upper) );
xi_1T = 1/m_1*log((psi_1lower-x_T)/(x_T-psi_1upper));

res(1) = ya(1)-xi_10;
res(2) = ya(2)- 0;
res(3) = ya(3)-0;
res(4) = ya(4)-0;
res(5) = ya(5)-0;
res(6) = ya(6)-0;

res(7) = yb(1)-xi_1T;
res(8) = yb(2)-0;
res(9) = yb(3)-0;
res(10) = yb(4)-0;
res(11) = yb(5)-0;
res(12) = yb(6)-0;
% t = 0;
% res(13) = ya(2)+T/pi*(params(1)*cos(pi*t/T)+1/2*params(2)*cos(2*pi*t/T)+1/3*params(3)*cos(3*pi*t/T)...
%     +1/4*params(4)*cos(4*pi*t/T)+1/5*params(5)*cos(5*pi*t/T)+1/6*params(6)*cos(6*pi*t/T);
% t = T;
% res(14) =yb(2)+T/pi*(params(1)*cos(pi*t/T)+1/2*params(2)*cos(2*pi*t/T)+1/3*params(3)*cos(3*pi*t/T)...
%     +1/4*params(4)*cos(4*pi*t/T)+1/5*params(5)*cos(5*pi*t/T)+1/6*params(6)*cos(6*pi*t/T);

% yb(2)-(params(1)*sin(pi*t/T)+params(2)*sin(2*pi*t/T)+params(3)*sin(3*pi*t/T)...
%     +params(4)*sin(4*pi*t/T)++params(5)*sin(5*pi*t/T)+params(6)*sin(6*pi*t/T)...
%     +params(7)*sin(7*pi*t/T)+params(8)*sin(8*pi*t/T));
res = res'; 
end

