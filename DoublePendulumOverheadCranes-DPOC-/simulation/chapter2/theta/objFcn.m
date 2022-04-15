function cost = objFcn(c,expTime,expY,tSpan,z0)
global F m_c m_h m_p g

len = length(expY);
simY = zeros(len,6);
% z = zeros(6,1);
% z = z0;


for i = 2:len
    F = expY(i,7);
    [~,x_next]= ode45(@(t,z)updateStates(t,z,c), [expTime(i-1) expTime(i)], z0);
    z0 = x_next(end,:)';
    simY(i,:) = x_next(end,:)';
end

% ODE_Sol = ode45(@(t,z)updateStates(t,z,x), tSpan, z0);
% simY = (deval(ODE_Sol, expTime))';


ex = simY(:,1)-expY(:,1);
etheta_h = simY(:,3)-expY(:,3);
etheta_p = simY(:,5)-expY(:,5);

% sumex = ex'*ex;
sumetheta_h = 1*etheta_h'*etheta_h;
sumetheta_p = 1*etheta_p'*etheta_p;

cost = sumetheta_h+sumetheta_p;
% c
% cost 
end