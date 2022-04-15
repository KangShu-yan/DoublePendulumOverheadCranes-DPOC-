% plot friction model 

i=1;
y = zeros(100,1);
yy = zeros(100,1);
xsave = zeros(100,1);
frx= 101.6894;epsilonx = 0.0069;krx = 122.8917;

for x = -1:0.02:1
  y(i) =frx*tanh(x/epsilonx)+krx*abs(x)*x;
%   yy(i) =  
  xsave(i)=x; 
  i=i+1; 
end
figure
plot(xsave,y);
params = sprintf('$frx:%2.4f,epsilonx:%2.4f,krx:%f$',frx,epsilonx,krx);
    title(params,'interpreter','latex','FontSize',9);
print(gcf,'-dpng','refFriction.png','-r500');