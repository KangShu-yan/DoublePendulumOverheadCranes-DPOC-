function f = updateStates(t, X,c)
global  F m_c m_h m_p  g
% global  F  g
dX = zeros(6,1);

d_h = c(1);d_p = c(2);
f_rx = c(3);
varepsilon = c(4);
k_rx = c(5);
l_h = c(6);
l_p  = c(7);
% m_c = c(8);
% m_h = c(9);
% m_p = c(10);
% f_rx = 0;
% k_rx = 0;
% varepsilon = 0.01;
%    f_rx = 109.8534;
%     varepsilon  = 0.0091;
%     k_rx = 608.272469;
x = X(1);
dotx = X(2);
theta_h = X(3);
dottheta_h = X(4);
theta_p = X(5);
dottheta_p = X(6);

Ff = f_rx*tanh(dotx/varepsilon)+k_rx*abs(dotx)*dotx;
% 180是施加的外力
F_a = F-Ff;   
dX(1) = X(2);
dX(2) = (2*F_a*l_h*l_p*m_h + F_a*l_h*l_p*m_p - d_h*dottheta_h*l_p*m_p*cos(theta_h - 2*theta_p) + 2*dottheta_h^2*l_h^2*l_p*m_h^2*sin(theta_h) - F_a*l_h*l_p*m_p*cos(2*theta_h - 2*theta_p) - d_p*dottheta_p*l_h*m_h*cos(2*theta_h - theta_p) - d_p*dottheta_p*l_h*m_p*cos(2*theta_h - theta_p) + g*l_h*l_p*m_h^2*sin(2*theta_h) + 2*d_h*dottheta_h*l_p*m_h*cos(theta_h) + d_p*dottheta_p*l_h*m_h*cos(theta_p) + d_h*dottheta_h*l_p*m_p*cos(theta_h) + d_p*dottheta_p*l_h*m_p*cos(theta_p) + 2*dottheta_h^2*l_h^2*l_p*m_h*m_p*sin(theta_h) + dottheta_p^2*l_h*l_p^2*m_h*m_p*sin(theta_p) + dottheta_p^2*l_h*l_p^2*m_h*m_p*sin(2*theta_h - theta_p) + g*l_h*l_p*m_h*m_p*sin(2*theta_h))/(l_h*l_p*(2*m_c*m_h + m_c*m_p + m_h*m_p - m_h^2*cos(2*theta_h) + m_h^2 - m_h*m_p*cos(2*theta_h) - m_c*m_p*cos(2*theta_h - 2*theta_p)));
dX(3) = X(4);
dX(4) = -(2*d_h*dottheta_h*l_p*m_c + 2*d_h*dottheta_h*l_p*m_h + d_h*dottheta_h*l_p*m_p - 2*d_p*dottheta_p*l_h*m_c*cos(theta_h - theta_p) - d_p*dottheta_p*l_h*m_h*cos(theta_h - theta_p) - d_p*dottheta_p*l_h*m_p*cos(theta_h - theta_p) - d_h*dottheta_h*l_p*m_p*cos(2*theta_p) + 2*g*l_h*l_p*m_h^2*sin(theta_h) + dottheta_h^2*l_h^2*l_p*m_h^2*sin(2*theta_h) + d_p*dottheta_p*l_h*m_h*cos(theta_h + theta_p) + d_p*dottheta_p*l_h*m_p*cos(theta_h + theta_p) + 2*F_a*l_h*l_p*m_h*cos(theta_h) + F_a*l_h*l_p*m_p*cos(theta_h) - F_a*l_h*l_p*m_p*cos(theta_h - 2*theta_p) + 2*dottheta_p^2*l_h*l_p^2*m_c*m_p*sin(theta_h - theta_p) + dottheta_p^2*l_h*l_p^2*m_h*m_p*sin(theta_h - theta_p) + 2*g*l_h*l_p*m_c*m_h*sin(theta_h) + g*l_h*l_p*m_c*m_p*sin(theta_h) + 2*g*l_h*l_p*m_h*m_p*sin(theta_h) + dottheta_h^2*l_h^2*l_p*m_h*m_p*sin(2*theta_h) + g*l_h*l_p*m_c*m_p*sin(theta_h - 2*theta_p) + dottheta_h^2*l_h^2*l_p*m_c*m_p*sin(2*theta_h - 2*theta_p) + dottheta_p^2*l_h*l_p^2*m_h*m_p*sin(theta_h + theta_p))/(l_h^2*l_p*(2*m_c*m_h + m_c*m_p + m_h*m_p - m_h^2*cos(2*theta_h) + m_h^2 - m_h*m_p*cos(2*theta_h) - m_c*m_p*cos(2*theta_h - 2*theta_p)));
dX(5) = X(6);
dX(6) =(d_h*dottheta_h*l_p*m_p^2*cos(theta_h - theta_p) - d_p*dottheta_p*l_h*m_p^2 - d_h*dottheta_h*l_p*m_p^2*cos(theta_h + theta_p) - F_a*l_h*l_p*m_p^2*cos(theta_p) - d_p*dottheta_p*l_h*m_h^2 - 2*d_p*dottheta_p*l_h*m_c*m_h - 2*d_p*dottheta_p*l_h*m_c*m_p - 2*d_p*dottheta_p*l_h*m_h*m_p + d_p*dottheta_p*l_h*m_h^2*cos(2*theta_h) + d_p*dottheta_p*l_h*m_p^2*cos(2*theta_h) + F_a*l_h*l_p*m_p^2*cos(2*theta_h - theta_p) + dottheta_p^2*l_h*l_p^2*m_c*m_p^2*sin(2*theta_h - 2*theta_p) - d_h*dottheta_h*l_p*m_h*m_p*cos(theta_h + theta_p) - F_a*l_h*l_p*m_h*m_p*cos(theta_p) + g*l_h*l_p*m_c*m_p^2*sin(2*theta_h - theta_p) + 2*d_h*dottheta_h*l_p*m_c*m_p*cos(theta_h - theta_p) + d_h*dottheta_h*l_p*m_h*m_p*cos(theta_h - theta_p) + 2*d_p*dottheta_p*l_h*m_h*m_p*cos(2*theta_h) + 2*dottheta_h^2*l_h^2*l_p*m_c*m_p^2*sin(theta_h - theta_p) - g*l_h*l_p*m_c*m_p^2*sin(theta_p) + F_a*l_h*l_p*m_h*m_p*cos(2*theta_h - theta_p) + g*l_h*l_p*m_c*m_h*m_p*sin(2*theta_h - theta_p) + 2*dottheta_h^2*l_h^2*l_p*m_c*m_h*m_p*sin(theta_h - theta_p) - g*l_h*l_p*m_c*m_h*m_p*sin(theta_p))/(l_h*l_p^2*m_p*(2*m_c*m_h + m_c*m_p + m_h*m_p - m_h^2*cos(2*theta_h) + m_h^2 - m_h*m_p*cos(2*theta_h) - m_c*m_p*cos(2*theta_h - 2*theta_p)));
f = dX;

end