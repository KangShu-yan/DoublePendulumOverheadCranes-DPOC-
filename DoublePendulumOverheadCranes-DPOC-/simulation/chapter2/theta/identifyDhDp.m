
clear;
close all;
global F m_c m_h m_p g

% plan = 'planB';
tarDir = './dhdp';
addpath(tarDir);
list = dir(tarDir);
len = length(list);
% 两个个参数待辨识
saveParams = zeros(len,5);
startId =9;
endId = 9;
M = zeros(endId-startId+1,7);
% M(1,:) = ['cartVelocity(m/s)' 'Friction(N)'];
result_name=strcat(tarDir,'dhdp.csv'); 


%     m_c = 1.3351;
%     m_h = 0.154;    % 0.08
%     m_p = 0.164;g=9.8;
%     l_h = 0.4018;l_p = 0.22;
    %% Initial guess
    % First guess at parameter value
%     d_h0 = 0.01621;
%     d_p0 = 0.0049;
%     d_h0 = 0.01;
%     d_p0 = 0.01;
%     d_h0 = 0.01;
%     d_p0 = 0.01;
    m_c = 1.3351;
    m_h = 0.071;    % 0.08
    m_p = 0.16;g=9.8;
    l_h = 0.35;
    l_p = 0.2;
    d_h0 = 0.01068;
    d_p0 =0.01163;
    f_rx0 = 94.0286;
    epsilonx  = 0.01;
    k_rx0 = 316.1468;
%     f_rx0 = 102.8113;   %109
%     epsilonx  = 0.0069;
%     k_rx0 = 822.8917;
    
    
for j = startId:endId
    %% 
    % measuredata = csvread('crane-180.csv',1,0); 
    measuredata = csvread(list(j).name,1,0);
    % F = 180;
    start=3;
    len = length(measuredata(start:end,1));
    otime = measuredata(start,1)*ones(len,1);
    endT = measuredata(end,1)-otime(1,1);
    Ts = endT/len;
    % expTime = 0:Ts:endT;
     expTime = measuredata(start:end,1)-otime(:);
    % backtime = mesuredata(:,1);
    % for i=1:1:len
    %     expTime = measuredata(:,1)-backtime(:,);
    % end
    flag = 1;
    expY = measuredata(start:end,2:8);
    smoothwindow = 1;
    %% ODE Information
    tSpan = [0 endT];
   % Initial values for the state
%     z0=zeros(6,1);
    z0 = expY(1,1:6)';
 
    c0=[d_h0 d_p0 f_rx0 epsilonx k_rx0 l_h l_p];
   
    simY = zeros(len,6);
    simY(1,:) = z0;
    for i = 2:len
        F = expY(i,7);
        [~,x_next]= ode45(@(t,z)updateStates(t,z,c0), [expTime(i-1) expTime(i)], z0);
        z0 = x_next(end,:)';
        simY(i,:) = x_next(end,:)';
    end
    if flag==1
    figure
    subplot(321)
    plot(expTime, simY(:,1),'r');
    hold on
      plot(expTime, expY(:,1),'b');
    subplot(322)
    plot(expTime, simY(:,2),'r');
       hold on
     plot(expTime, expY(:,2));
    subplot(323)
    plot(expTime, (simY(:,3)*180/pi),'r');
       hold on
     plot(expTime, (expY(:,3)*180/pi),'b');
    subplot(324)
    plot(expTime, (simY(:,4)*180/pi),'r');
       hold on
     plot(expTime, expY(:,4)*180/pi,'b');
    subplot(325)
    plot(expTime, (simY(:,5)*180/pi),'r');
       hold on
     plot(expTime, (expY(:,5)*180/pi),'b');
    subplot(326)
    plot(expTime, simY(:,6)*180/pi,'r');
       hold on
     plot(expTime, expY(:,6)*180/pi,'b');
    end
    %% Set up optimization
    myObjective = @(c) objFcn(c, expTime, expY,tSpan,z0);

    lb = [0.0003;0.0003;0;0;0;0.1;0.1];
    ub = [0.1;0.1;Inf;1;Inf;0.5;0.5];
    nonlcon = @(x)nonlicon(c,expTime,expY,tSpan,Ts,z0);
    % nonlcon = @(x)nonlicon(x,expTime,simY,tSpan,Ts,z0);
%     'interior-point'
    options = optimoptions('fmincon','Algorithm','interior-point','Display', 'iter','PlotFcn','optimplotfval');
    options.MaxIter =20;
%     options = optimoptions(@lsqnonlin,'Algorithm','levenberg-marquardt','Display', 'iter','PlotFcn','optimplotfval');
%    options = optimoptions(@lsqnonlin,'Display', 'iter','PlotFcn','optimplotfval');
%     bestc = lsqnonlin(myObjective, c0, [], [],options);
    % bestc = fmincon(myObjective, c0,[],[],[],[], lb, [],nonlcon,options);
    bestc = fmincon(myObjective, c0,[],[],[],[], lb, ub,[],options);
    
     M(j-startId+1,:) = bestc;
    %% Plot best result
    % ODE_Sol = ode45(@(t,z)updateStates(t,z,bestc), tSpan, z0);
    % bestY = deval(ODE_Sol, expTime)';

    bestY = zeros(len,6);
%     z0 = zeros(6,1);
    z0 = expY(1,1:6)';
    % z = z0;
    bestY(1,:) = z0;
    for i = 2:len
        F = expY(i,7);
        [~,xx_next]= ode45(@(t,z)updateStates(t,z,bestc), [expTime(i-1) expTime(i)], z0);
        z0 = xx_next(end,:)';
        bestY(i,:) = xx_next(end,:)';
    end

%     if flag==1
%     figure(4)
%     subplot(321)
%     plot(expTime, bestY(:,1));
%     subplot(322)
%     plot(expTime, bestY(:,2));
%     subplot(323)
%     plot(expTime, (bestY(:,3)*180/pi));
%     subplot(324)
%     plot(expTime, (bestY(:,4)*180/pi));
%     subplot(325)
%     plot(expTime, (bestY(:,5)*180/pi));
%     subplot(326)
%     plot(expTime, (bestY(:,6)*180/pi));
%     end
    % legend('Exp Data','Initial Param','Best Param');
    % bestY = bestY';
    figure(5)
    subplot(311);
    % x
    plot(expTime, expY(:,1),'b');
    params = sprintf('$d_h:%2.5f,d_p:%2.5f$',bestc(1),bestc(2));
    title(params,'interpreter','latex','FontSize',9);
    hold on
    plot(expTime, simY(:,1),'r');
    hold on
    plot(expTime, bestY(:,1),'k');
    legend('exp','sim','best');
  
    subplot(312);
    % theta_h
    plot(expTime, (expY(:,3)*180/pi),'b');
    hold on
    plot(expTime, (simY(:,3)*180/pi),'r');
    hold on
    plot(expTime, (bestY(:,3)*180/pi),'k');
    subplot(313);
    % theta_p
    plot(expTime, (expY(:,5)*180/pi),'b');
    hold on
    plot(expTime, (simY(:,5)*180/pi),'r');
    hold on
    plot(expTime, (bestY(:,5)*180/pi),'k');
    name = strsplit(list(j).name,'.');
    image = strcat(tarDir,'/images/',char(name(1)),'.png');
    print(gcf,'-dpng',image,'-r500');
    
end 
csvwrite(result_name,M);
figure 
bar(M');
x = ['d_h' 'd_p'];
% set(gca,'xTickLabel',x); % ,'interpreter','latex'
image =strcat(tarDir,'/res.png');
print(gcf,'-dpng',image,'-r500');

