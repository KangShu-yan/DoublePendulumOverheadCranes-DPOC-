% rampfunction
clc;
close all;

t = 0:0.01:10;
len = length(t);
torque = zeros(len,1);
c = -200;b = 10;a = 0;
for i = 1:len
    torque(i)= c+b*t(i)+a*t(i)*t(i);
end
figure
plot(t,torque);
params = sprintf('$y =%2.4f*t^2+%2.4f*t+%2.4f$',a,b,c);
title(params,'interpreter','latex','FontSize',10);
image = strcat('rampTorque','_a',num2str(a),'b',num2str(b),'c',num2str(c));
print(gcf,'-dpng',image,'-r500');