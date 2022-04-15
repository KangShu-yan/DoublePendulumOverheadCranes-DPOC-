% clc
clear;
close all;
% addpath ./identifyFriction

tarDir = './identifyFriction';
addpath(tarDir);

list = dir(tarDir);
len = length(list);
saveForce =zeros(len,1);
savedotx = zeros(len,1);
startId = 8;
M = zeros(len-startId+1,2);
% M(1,:) = ['cartVelocity(m/s)' 'Friction(N)'];
result_name='friction.csv'; 

start = 4;
avgForceStartTime = 10; 
avgForceEndTime = 20;
for j = startId:len
    a = csvread(list(j).name,1,0);
    F = 0;
    averageForce = 0;
    averagedotx = 0;
    forceCnt = 0;
    p_cte = a(start:end,:);
    wholelen = length(p_cte(:,1));
    endpoint = wholelen-0;
    len = endpoint-start+1;
    Ts = (p_cte(end,1)-p_cte(start,1)+1)/wholelen;
    otime = p_cte(start,1)*ones(len,1);
    time = p_cte(start:endpoint,1)-otime;
    y = zeros(len,1);

    x = zeros(len,1);
    mddotx = zeros(len,1);
    mdotx = zeros(len,1);
    mx = zeros(len,1);
    ma = zeros(len,1);
    xvector = [p_cte(start-3,2) p_cte(start-2,2) p_cte(start-1,2)];
    % x = zeros(len,2);
    S= zeros(len,2);
    % S= zeros(len,1);
    for i =start:1:len
        x = p_cte(i,2);

        dotx = p_cte(i,3);
    %     dotx = (3*x-4*xvector(2)+xvector(1))/Ts/2;
    %     ddotx = (2*x-5*xvector(3)+4*xvector(2)-xvector(1))/Ts/Ts;
        ddotx = p_cte(i,9);
        mx(i)=x;
        mdotx(i) = dotx;
        mddotx(i) = ddotx;
        F = p_cte(i,8);
    %     m_c+m_h+m_p = 1.5791;
        ma(i)=ddotx*1.5791;
        y(i) = F-ma(i);
        S(i,:) = [tanh(dotx/0.01) -abs(dotx)*dotx];
    %     S(i,:) = abs(dotx)*dotx;
    %     S(i,:) = tanh(dotx/0.01);
        xvector(1) =xvector(2);
        xvector(2)=xvector(3);
        xvector(3) = x;

        if time(i)>avgForceStartTime&&time(i)<avgForceEndTime
           forceCnt=forceCnt+1;
           averageForce=averageForce+ p_cte(i,8);
           averagedotx = averagedotx+dotx;
        end
        if time(end)<avgForceStartTime&&time(i)>2.5
            forceCnt=forceCnt+1;
           averageForce=averageForce+ p_cte(i,8);
           averagedotx = averagedotx+dotx;
        end
    end

    averagedotx = averagedotx/forceCnt;
    averageForce = averageForce/forceCnt;
    M(j-startId+1,:) = [averagedotx averageForce];
    saveForce(j-startId+1)=averageForce;
    savedotx(j-startId+1)=averagedotx;


    % ext = '.csv';
%     src ='.\identifyFriction\crane.csv';
%     name = strcat('.\identifyFriction\crane',num2str(averagedotx),'-',num2str(averageForce));
%     dst = strcat(name,'.csv');
%     if exist(src,'file')
%         movefile(src,dst);
%     end
        legendFontSize = 7;
    set(figure(1),'Position',[100,200,400,400])
    subplot(411)
    plot(time,mx,'b','LineWidth',1.5);
    params = sprintf('$Ff:%2.4f,v:%2.4f,FStartTime:%f,FEndTime:%f,start:%2.5f$',averageForce,averagedotx,avgForceStartTime,avgForceEndTime,start);
    title(params,'interpreter','latex','FontSize',9);
    ylabel('$x/(m)$','interpreter','latex');
    xlabel('$Time(s)$','interpreter','latex');
    subplot(412)
    plot(time,mdotx,'b','LineWidth',1.5);
    ylabel('$\dot x/(m/s)$','interpreter','latex');
    xlabel('$Time(s)$','interpreter','latex');
    subplot(413)
    plot(mdotx,y,'b','LineWidth',1.5);
    ylabel('$F_f(N)$','interpreter','latex');
    xlabel('$\dot x/(m/s)$','interpreter','latex');
    subplot(414)
    plot(time,p_cte(start:endpoint,8),'b','LineWidth',1.5);
    ylabel('$F(N)$','interpreter','latex');
    xlabel('$Time(s)$','interpreter','latex');
    name = strsplit(list(j).name,'.');
    image = strcat(tarDir,'/images/',char(name(1)),'.png');
    print(gcf,'-dpng',image,'-r500');

end

csvwrite(result_name,M);

figure 
plot(savedotx,saveForce,'ro');
xlabel('$\dot x/(m/s)$','interpreter','latex');
ylabel('$F_f(N)$','interpreter','latex');
image = strcat(tarDir,'/images/','res.png');
print(gcf,'-dpng',image,'-r500');