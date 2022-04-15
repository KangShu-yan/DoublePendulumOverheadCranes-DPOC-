function dX = diffDual_pendulum(~, X)
global m_c m_h m_p l_h l_p g F f_rx k_rx varepsilon d_h d_p
dX = zeros(6,1);

%
x = X(1);
dotx = X(2);
theta_h = X(3);
dottheta_h = X(4);
theta_p = X(5);
dottheta_p = X(6);
Ff = f_rx*tanh(dotx/varepsilon)-k_rx*abs(dotx)*dotx;
% Ff = 0;
F_a = F-Ff; 
% d_h = 0.03;d_p = 0.03;
% d_h = 0.0;d_p = 0.0;
% Ftheta_h = -d_h*dottheta_h;
% Ftheta_p = -d_p*dottheta_p;
% Ftheta_h = 0;
% Ftheta_p = 0;
% Lagrangian equation 
% model one 负载位移大于台车

dX(1) = X(2);
dX(2) = (2*F_a*l_h*l_p*m_h + F_a*l_h*l_p*m_p - d_h*dottheta_h*l_p*m_p*cos(theta_h - 2*theta_p) + 2*dottheta_h^2*l_h^2*l_p*m_h^2*sin(theta_h) - F_a*l_h*l_p*m_p*cos(2*theta_h - 2*theta_p) - d_p*dottheta_p*l_h*m_h*cos(2*theta_h - theta_p) - d_p*dottheta_p*l_h*m_p*cos(2*theta_h - theta_p) + g*l_h*l_p*m_h^2*sin(2*theta_h) + 2*d_h*dottheta_h*l_p*m_h*cos(theta_h) + d_p*dottheta_p*l_h*m_h*cos(theta_p) + d_h*dottheta_h*l_p*m_p*cos(theta_h) + d_p*dottheta_p*l_h*m_p*cos(theta_p) + 2*dottheta_h^2*l_h^2*l_p*m_h*m_p*sin(theta_h) + dottheta_p^2*l_h*l_p^2*m_h*m_p*sin(theta_p) + dottheta_p^2*l_h*l_p^2*m_h*m_p*sin(2*theta_h - theta_p) + g*l_h*l_p*m_h*m_p*sin(2*theta_h))/(l_h*l_p*(2*m_c*m_h + m_c*m_p + m_h*m_p - m_h^2*cos(2*theta_h) + m_h^2 - m_h*m_p*cos(2*theta_h) - m_c*m_p*cos(2*theta_h - 2*theta_p)));
 
dX(3) = X(4);
dX(4) = -(2*d_h*dottheta_h*l_p*m_c + 2*d_h*dottheta_h*l_p*m_h + d_h*dottheta_h*l_p*m_p - 2*d_p*dottheta_p*l_h*m_c*cos(theta_h - theta_p) - d_p*dottheta_p*l_h*m_h*cos(theta_h - theta_p) - d_p*dottheta_p*l_h*m_p*cos(theta_h - theta_p) - d_h*dottheta_h*l_p*m_p*cos(2*theta_p) + 2*g*l_h*l_p*m_h^2*sin(theta_h) + dottheta_h^2*l_h^2*l_p*m_h^2*sin(2*theta_h) + d_p*dottheta_p*l_h*m_h*cos(theta_h + theta_p) + d_p*dottheta_p*l_h*m_p*cos(theta_h + theta_p) + 2*F_a*l_h*l_p*m_h*cos(theta_h) + F_a*l_h*l_p*m_p*cos(theta_h) - F_a*l_h*l_p*m_p*cos(theta_h - 2*theta_p) + 2*dottheta_p^2*l_h*l_p^2*m_c*m_p*sin(theta_h - theta_p) + dottheta_p^2*l_h*l_p^2*m_h*m_p*sin(theta_h - theta_p) + 2*g*l_h*l_p*m_c*m_h*sin(theta_h) + g*l_h*l_p*m_c*m_p*sin(theta_h) + 2*g*l_h*l_p*m_h*m_p*sin(theta_h) + dottheta_h^2*l_h^2*l_p*m_h*m_p*sin(2*theta_h) + g*l_h*l_p*m_c*m_p*sin(theta_h - 2*theta_p) + dottheta_h^2*l_h^2*l_p*m_c*m_p*sin(2*theta_h - 2*theta_p) + dottheta_p^2*l_h*l_p^2*m_h*m_p*sin(theta_h + theta_p))/(l_h^2*l_p*(2*m_c*m_h + m_c*m_p + m_h*m_p - m_h^2*cos(2*theta_h) + m_h^2 - m_h*m_p*cos(2*theta_h) - m_c*m_p*cos(2*theta_h - 2*theta_p)));
 

dX(5) = X(6);
dX(6) =(d_h*dottheta_h*l_p*m_p^2*cos(theta_h - theta_p) - d_p*dottheta_p*l_h*m_p^2 - d_h*dottheta_h*l_p*m_p^2*cos(theta_h + theta_p) - F_a*l_h*l_p*m_p^2*cos(theta_p) - d_p*dottheta_p*l_h*m_h^2 - 2*d_p*dottheta_p*l_h*m_c*m_h - 2*d_p*dottheta_p*l_h*m_c*m_p - 2*d_p*dottheta_p*l_h*m_h*m_p + d_p*dottheta_p*l_h*m_h^2*cos(2*theta_h) + d_p*dottheta_p*l_h*m_p^2*cos(2*theta_h) + F_a*l_h*l_p*m_p^2*cos(2*theta_h - theta_p) + dottheta_p^2*l_h*l_p^2*m_c*m_p^2*sin(2*theta_h - 2*theta_p) - d_h*dottheta_h*l_p*m_h*m_p*cos(theta_h + theta_p) - F_a*l_h*l_p*m_h*m_p*cos(theta_p) + g*l_h*l_p*m_c*m_p^2*sin(2*theta_h - theta_p) + 2*d_h*dottheta_h*l_p*m_c*m_p*cos(theta_h - theta_p) + d_h*dottheta_h*l_p*m_h*m_p*cos(theta_h - theta_p) + 2*d_p*dottheta_p*l_h*m_h*m_p*cos(2*theta_h) + 2*dottheta_h^2*l_h^2*l_p*m_c*m_p^2*sin(theta_h - theta_p) - g*l_h*l_p*m_c*m_p^2*sin(theta_p) + F_a*l_h*l_p*m_h*m_p*cos(2*theta_h - theta_p) + g*l_h*l_p*m_c*m_h*m_p*sin(2*theta_h - theta_p) + 2*dottheta_h^2*l_h^2*l_p*m_c*m_h*m_p*sin(theta_h - theta_p) - g*l_h*l_p*m_c*m_h*m_p*sin(theta_p))/(l_h*l_p^2*m_p*(2*m_c*m_h + m_c*m_p + m_h*m_p - m_h^2*cos(2*theta_h) + m_h^2 - m_h*m_p*cos(2*theta_h) - m_c*m_p*cos(2*theta_h - 2*theta_p)));
  




% dX(1) = X(2);
% dX(2) = -(F*l_h^3*m_h + F*l_h^3*m_p + dottheta_h^2*l_h^4*m_h^2*sin(theta_h) + dottheta_h^2*l_h^4*m_p^2*sin(theta_h) - Ftheta_h*l_h^2*m_h*cos(theta_h) - Ftheta_h*l_h^2*m_p*cos(theta_h) + dottheta_p^2*l_h^3*l_p*m_p^2*sin(theta_p) + g*l_h^3*m_h^2*cos(theta_h)*sin(theta_h) + g*l_h^3*m_p^2*cos(theta_h)*sin(theta_h) + 2*dottheta_h^2*l_h^4*m_h*m_p*sin(theta_h) - F*l_h*l_p^2*m_p*cos(theta_h - theta_p)^2 + Ftheta_h*l_p^2*m_p*cos(theta_h - theta_p)*cos(theta_p) - Ftheta_p*l_h*l_p*m_h*cos(theta_p) - Ftheta_p*l_h*l_p*m_p*cos(theta_p) + dottheta_p^2*l_h^3*l_p*m_p^2*sin(theta_h - theta_p)*cos(theta_h) + dottheta_p^2*l_h^3*l_p*m_h*m_p*sin(theta_p) + 2*g*l_h^3*m_h*m_p*cos(theta_h)*sin(theta_h) - dottheta_h^2*l_h^2*l_p^2*m_p^2*sin(theta_h - theta_p)*cos(theta_p) - dottheta_p^2*l_h*l_p^3*m_p^2*cos(theta_h - theta_p)^2*sin(theta_p) + g*l_h*l_p^2*m_p^2*cos(theta_p)*sin(theta_p) + Ftheta_p*l_h*l_p*m_h*cos(theta_h - theta_p)*cos(theta_h) + Ftheta_p*l_h*l_p*m_p*cos(theta_h - theta_p)*cos(theta_h) - dottheta_h^2*l_h^2*l_p^2*m_p^2*cos(theta_h - theta_p)^2*sin(theta_h) - dottheta_p^2*l_h*l_p^3*m_p^2*cos(theta_h - theta_p)*sin(theta_h - theta_p)*cos(theta_p) + dottheta_p^2*l_h^3*l_p*m_h*m_p*sin(theta_h - theta_p)*cos(theta_h) + dottheta_h^2*l_h^2*l_p^2*m_p^2*cos(theta_h - theta_p)*sin(theta_h - theta_p)*cos(theta_h) - dottheta_h^2*l_h^2*l_p^2*m_h*m_p*sin(theta_h - theta_p)*cos(theta_p) - g*l_h*l_p^2*m_p^2*cos(theta_h - theta_p)*cos(theta_h)*sin(theta_p) - g*l_h*l_p^2*m_p^2*cos(theta_h - theta_p)*cos(theta_p)*sin(theta_h) + g*l_h*l_p^2*m_h*m_p*cos(theta_p)*sin(theta_p) - dottheta_h^2*l_h^2*l_p^2*m_h*m_p*cos(theta_h - theta_p)^2*sin(theta_h) + dottheta_h^2*l_h^2*l_p^2*m_h*m_p*cos(theta_h - theta_p)*sin(theta_h - theta_p)*cos(theta_h) - g*l_h*l_p^2*m_h*m_p*cos(theta_h - theta_p)*cos(theta_h)*sin(theta_p) - g*l_h*l_p^2*m_h*m_p*cos(theta_h - theta_p)*cos(theta_p)*sin(theta_h))/(l_h*(l_h^2*m_h^2*cos(theta_h)^2 - l_h^2*m_p^2 - l_h^2*m_c*m_h - l_h^2*m_c*m_p - 2*l_h^2*m_h*m_p - l_h^2*m_h^2 + l_h^2*m_p^2*cos(theta_h)^2 + l_p^2*m_p^2*cos(theta_p)^2 + l_p^2*m_p^2*cos(theta_h - theta_p)^2 + 2*l_h^2*m_h*m_p*cos(theta_h)^2 + l_p^2*m_h*m_p*cos(theta_p)^2 + l_p^2*m_c*m_p*cos(theta_h - theta_p)^2 + l_p^2*m_h*m_p*cos(theta_h - theta_p)^2 - 2*l_p^2*m_p^2*cos(theta_h - theta_p)*cos(theta_h)*cos(theta_p) - 2*l_p^2*m_h*m_p*cos(theta_h - theta_p)*cos(theta_h)*cos(theta_p)));
% dX(3) = X(4);
% dX(4) = (Ftheta_h*l_p^2*m_p*cos(theta_p)^2 - Ftheta_h*l_h^2*m_h - Ftheta_h*l_h^2*m_p - Ftheta_h*l_h^2*m_c + g*l_h^3*m_h^2*sin(theta_h) + g*l_h^3*m_p^2*sin(theta_h) + F*l_h^3*m_h*cos(theta_h) + F*l_h^3*m_p*cos(theta_h) + dottheta_p^2*l_h^3*l_p*m_p^2*sin(theta_h - theta_p) + g*l_h^3*m_c*m_h*sin(theta_h) + g*l_h^3*m_c*m_p*sin(theta_h) + 2*g*l_h^3*m_h*m_p*sin(theta_h) + dottheta_h^2*l_h^4*m_h^2*cos(theta_h)*sin(theta_h) + dottheta_h^2*l_h^4*m_p^2*cos(theta_h)*sin(theta_h) + Ftheta_p*l_h*l_p*m_c*cos(theta_h - theta_p) + Ftheta_p*l_h*l_p*m_h*cos(theta_h - theta_p) + Ftheta_p*l_h*l_p*m_p*cos(theta_h - theta_p) - F*l_h*l_p^2*m_p*cos(theta_h - theta_p)*cos(theta_p) + dottheta_p^2*l_h^3*l_p*m_c*m_p*sin(theta_h - theta_p) + dottheta_p^2*l_h^3*l_p*m_h*m_p*sin(theta_h - theta_p) - dottheta_p^2*l_h*l_p^3*m_p^2*sin(theta_h - theta_p)*cos(theta_p)^2 + 2*dottheta_h^2*l_h^4*m_h*m_p*cos(theta_h)*sin(theta_h) - Ftheta_p*l_h*l_p*m_h*cos(theta_h)*cos(theta_p) - Ftheta_p*l_h*l_p*m_p*cos(theta_h)*cos(theta_p) + dottheta_h^2*l_h^2*l_p^2*m_p^2*cos(theta_h - theta_p)*sin(theta_h - theta_p) - g*l_h*l_p^2*m_p^2*cos(theta_h - theta_p)*sin(theta_p) + dottheta_p^2*l_h^3*l_p*m_p^2*cos(theta_h)*sin(theta_p) - g*l_h*l_p^2*m_p^2*cos(theta_p)^2*sin(theta_h) - dottheta_h^2*l_h^2*l_p^2*m_p^2*cos(theta_h - theta_p)*cos(theta_p)*sin(theta_h) - dottheta_h^2*l_h^2*l_p^2*m_p^2*sin(theta_h - theta_p)*cos(theta_h)*cos(theta_p) + g*l_h*l_p^2*m_p^2*cos(theta_h)*cos(theta_p)*sin(theta_p) + dottheta_h^2*l_h^2*l_p^2*m_c*m_p*cos(theta_h - theta_p)*sin(theta_h - theta_p) + dottheta_h^2*l_h^2*l_p^2*m_h*m_p*cos(theta_h - theta_p)*sin(theta_h - theta_p) - g*l_h*l_p^2*m_c*m_p*cos(theta_h - theta_p)*sin(theta_p) - g*l_h*l_p^2*m_h*m_p*cos(theta_h - theta_p)*sin(theta_p) - dottheta_p^2*l_h*l_p^3*m_p^2*cos(theta_h - theta_p)*cos(theta_p)*sin(theta_p) + dottheta_p^2*l_h^3*l_p*m_h*m_p*cos(theta_h)*sin(theta_p) - g*l_h*l_p^2*m_h*m_p*cos(theta_p)^2*sin(theta_h) - dottheta_h^2*l_h^2*l_p^2*m_h*m_p*cos(theta_h - theta_p)*cos(theta_p)*sin(theta_h) - dottheta_h^2*l_h^2*l_p^2*m_h*m_p*sin(theta_h - theta_p)*cos(theta_h)*cos(theta_p) + g*l_h*l_p^2*m_h*m_p*cos(theta_h)*cos(theta_p)*sin(theta_p))/(l_h^2*(l_h^2*m_h^2*cos(theta_h)^2 - l_h^2*m_p^2 - l_h^2*m_c*m_h - l_h^2*m_c*m_p - 2*l_h^2*m_h*m_p - l_h^2*m_h^2 + l_h^2*m_p^2*cos(theta_h)^2 + l_p^2*m_p^2*cos(theta_p)^2 + l_p^2*m_p^2*cos(theta_h - theta_p)^2 + 2*l_h^2*m_h*m_p*cos(theta_h)^2 + l_p^2*m_h*m_p*cos(theta_p)^2 + l_p^2*m_c*m_p*cos(theta_h - theta_p)^2 + l_p^2*m_h*m_p*cos(theta_h - theta_p)^2 - 2*l_p^2*m_p^2*cos(theta_h - theta_p)*cos(theta_h)*cos(theta_p) - 2*l_p^2*m_h*m_p*cos(theta_h - theta_p)*cos(theta_h)*cos(theta_p)));
% dX(5) = X(6);
% dX(6) = -(Ftheta_p*l_h*m_h^2 + Ftheta_p*l_h*m_p^2 - Ftheta_p*l_h*m_h^2*cos(theta_h)^2 - Ftheta_p*l_h*m_p^2*cos(theta_h)^2 - Ftheta_h*l_p*m_p^2*cos(theta_h - theta_p) + Ftheta_p*l_h*m_c*m_h + Ftheta_p*l_h*m_c*m_p + 2*Ftheta_p*l_h*m_h*m_p - F*l_h*l_p*m_p^2*cos(theta_p) - 2*Ftheta_p*l_h*m_h*m_p*cos(theta_h)^2 + dottheta_h^2*l_h^2*l_p*m_p^3*sin(theta_h - theta_p) - g*l_h*l_p*m_p^3*sin(theta_p) + Ftheta_h*l_p*m_p^2*cos(theta_h)*cos(theta_p) - Ftheta_h*l_p*m_c*m_p*cos(theta_h - theta_p) - Ftheta_h*l_p*m_h*m_p*cos(theta_h - theta_p) + F*l_h*l_p*m_p^2*cos(theta_h - theta_p)*cos(theta_h) - F*l_h*l_p*m_h*m_p*cos(theta_p) + dottheta_p^2*l_h*l_p^2*m_p^3*cos(theta_h - theta_p)*sin(theta_h - theta_p) + g*l_h*l_p*m_p^3*cos(theta_h - theta_p)*sin(theta_h) - dottheta_h^2*l_h^2*l_p*m_p^3*sin(theta_h - theta_p)*cos(theta_h)^2 + g*l_h*l_p*m_p^3*cos(theta_h)^2*sin(theta_p) + Ftheta_h*l_p*m_h*m_p*cos(theta_h)*cos(theta_p) + dottheta_h^2*l_h^2*l_p*m_c*m_p^2*sin(theta_h - theta_p) + 2*dottheta_h^2*l_h^2*l_p*m_h*m_p^2*sin(theta_h - theta_p) + dottheta_h^2*l_h^2*l_p*m_h^2*m_p*sin(theta_h - theta_p) - g*l_h*l_p*m_c*m_p^2*sin(theta_p) - 2*g*l_h*l_p*m_h*m_p^2*sin(theta_p) - g*l_h*l_p*m_h^2*m_p*sin(theta_p) - dottheta_h^2*l_h^2*l_p*m_p^3*cos(theta_p)*sin(theta_h) - dottheta_p^2*l_h*l_p^2*m_p^3*cos(theta_p)*sin(theta_p) - g*l_h*l_p*m_p^3*cos(theta_h)*cos(theta_p)*sin(theta_h) + F*l_h*l_p*m_h*m_p*cos(theta_h - theta_p)*cos(theta_h) - 2*dottheta_h^2*l_h^2*l_p*m_h*m_p^2*cos(theta_p)*sin(theta_h) - dottheta_h^2*l_h^2*l_p*m_h^2*m_p*cos(theta_p)*sin(theta_h) - dottheta_p^2*l_h*l_p^2*m_h*m_p^2*cos(theta_p)*sin(theta_p) + dottheta_p^2*l_h*l_p^2*m_c*m_p^2*cos(theta_h - theta_p)*sin(theta_h - theta_p) + dottheta_p^2*l_h*l_p^2*m_h*m_p^2*cos(theta_h - theta_p)*sin(theta_h - theta_p) + dottheta_h^2*l_h^2*l_p*m_c*m_h*m_p*sin(theta_h - theta_p) + g*l_h*l_p*m_c*m_p^2*cos(theta_h - theta_p)*sin(theta_h) + 2*g*l_h*l_p*m_h*m_p^2*cos(theta_h - theta_p)*sin(theta_h) + g*l_h*l_p*m_h^2*m_p*cos(theta_h - theta_p)*sin(theta_h) - g*l_h*l_p*m_c*m_h*m_p*sin(theta_p) - 2*dottheta_h^2*l_h^2*l_p*m_h*m_p^2*sin(theta_h - theta_p)*cos(theta_h)^2 - dottheta_h^2*l_h^2*l_p*m_h^2*m_p*sin(theta_h - theta_p)*cos(theta_h)^2 + dottheta_h^2*l_h^2*l_p*m_p^3*cos(theta_h - theta_p)*cos(theta_h)*sin(theta_h) + dottheta_p^2*l_h*l_p^2*m_p^3*cos(theta_h - theta_p)*cos(theta_h)*sin(theta_p) - dottheta_p^2*l_h*l_p^2*m_p^3*sin(theta_h - theta_p)*cos(theta_h)*cos(theta_p) + 2*g*l_h*l_p*m_h*m_p^2*cos(theta_h)^2*sin(theta_p) + g*l_h*l_p*m_h^2*m_p*cos(theta_h)^2*sin(theta_p) + 2*dottheta_h^2*l_h^2*l_p*m_h*m_p^2*cos(theta_h - theta_p)*cos(theta_h)*sin(theta_h) + dottheta_h^2*l_h^2*l_p*m_h^2*m_p*cos(theta_h - theta_p)*cos(theta_h)*sin(theta_h) + dottheta_p^2*l_h*l_p^2*m_h*m_p^2*cos(theta_h - theta_p)*cos(theta_h)*sin(theta_p) - dottheta_p^2*l_h*l_p^2*m_h*m_p^2*sin(theta_h - theta_p)*cos(theta_h)*cos(theta_p) - 2*g*l_h*l_p*m_h*m_p^2*cos(theta_h)*cos(theta_p)*sin(theta_h) - g*l_h*l_p*m_h^2*m_p*cos(theta_h)*cos(theta_p)*sin(theta_h) + g*l_h*l_p*m_c*m_h*m_p*cos(theta_h - theta_p)*sin(theta_h))/(l_h*m_p*(l_h^2*m_h^2*cos(theta_h)^2 - l_h^2*m_p^2 - l_h^2*m_c*m_h - l_h^2*m_c*m_p - 2*l_h^2*m_h*m_p - l_h^2*m_h^2 + l_h^2*m_p^2*cos(theta_h)^2 + l_p^2*m_p^2*cos(theta_p)^2 + l_p^2*m_p^2*cos(theta_h - theta_p)^2 + 2*l_h^2*m_h*m_p*cos(theta_h)^2 + l_p^2*m_h*m_p*cos(theta_p)^2 + l_p^2*m_c*m_p*cos(theta_h - theta_p)^2 + l_p^2*m_h*m_p*cos(theta_h - theta_p)^2 - 2*l_p^2*m_p^2*cos(theta_h - theta_p)*cos(theta_h)*cos(theta_p) - 2*l_p^2*m_h*m_p*cos(theta_h - theta_p)*cos(theta_h)*cos(theta_p)));

% model second 负载位移小于台车
% dX(1) = X(2);
% dX(2) = (dottheta_h^2*l_h^4*m_h^2*sin(theta_h) - F*l_h^3*m_p - F*l_h^3*m_h + dottheta_h^2*l_h^4*m_p^2*sin(theta_h) - Ftheta_h*l_h^2*m_h*cos(theta_h) - Ftheta_h*l_h^2*m_p*cos(theta_h) + dottheta_p^2*l_h^3*l_p*m_p^2*sin(theta_p) + g*l_h^3*m_h^2*cos(theta_h)*sin(theta_h) + g*l_h^3*m_p^2*cos(theta_h)*sin(theta_h) + 2*dottheta_h^2*l_h^4*m_h*m_p*sin(theta_h) + F*l_h*l_p^2*m_p*cos(theta_h - theta_p)^2 + Ftheta_h*l_p^2*m_p*cos(theta_h - theta_p)*cos(theta_p) - Ftheta_p*l_h*l_p*m_h*cos(theta_p) - Ftheta_p*l_h*l_p*m_p*cos(theta_p) + dottheta_p^2*l_h^3*l_p*m_p^2*sin(theta_h - theta_p)*cos(theta_h) + dottheta_p^2*l_h^3*l_p*m_h*m_p*sin(theta_p) + 2*g*l_h^3*m_h*m_p*cos(theta_h)*sin(theta_h) - dottheta_h^2*l_h^2*l_p^2*m_p^2*sin(theta_h - theta_p)*cos(theta_p) - dottheta_p^2*l_h*l_p^3*m_p^2*cos(theta_h - theta_p)^2*sin(theta_p) + g*l_h*l_p^2*m_p^2*cos(theta_p)*sin(theta_p) + Ftheta_p*l_h*l_p*m_h*cos(theta_h - theta_p)*cos(theta_h) + Ftheta_p*l_h*l_p*m_p*cos(theta_h - theta_p)*cos(theta_h) - dottheta_h^2*l_h^2*l_p^2*m_p^2*cos(theta_h - theta_p)^2*sin(theta_h) - dottheta_p^2*l_h*l_p^3*m_p^2*cos(theta_h - theta_p)*sin(theta_h - theta_p)*cos(theta_p) + dottheta_p^2*l_h^3*l_p*m_h*m_p*sin(theta_h - theta_p)*cos(theta_h) + dottheta_h^2*l_h^2*l_p^2*m_p^2*cos(theta_h - theta_p)*sin(theta_h - theta_p)*cos(theta_h) - dottheta_h^2*l_h^2*l_p^2*m_h*m_p*sin(theta_h - theta_p)*cos(theta_p) - g*l_h*l_p^2*m_p^2*cos(theta_h - theta_p)*cos(theta_h)*sin(theta_p) - g*l_h*l_p^2*m_p^2*cos(theta_h - theta_p)*cos(theta_p)*sin(theta_h) + g*l_h*l_p^2*m_h*m_p*cos(theta_p)*sin(theta_p) - dottheta_h^2*l_h^2*l_p^2*m_h*m_p*cos(theta_h - theta_p)^2*sin(theta_h) + dottheta_h^2*l_h^2*l_p^2*m_h*m_p*cos(theta_h - theta_p)*sin(theta_h - theta_p)*cos(theta_h) - g*l_h*l_p^2*m_h*m_p*cos(theta_h - theta_p)*cos(theta_h)*sin(theta_p) - g*l_h*l_p^2*m_h*m_p*cos(theta_h - theta_p)*cos(theta_p)*sin(theta_h))/(l_h*(l_h^2*m_h^2*cos(theta_h)^2 - l_h^2*m_p^2 - l_h^2*m_c*m_h - l_h^2*m_c*m_p - 2*l_h^2*m_h*m_p - l_h^2*m_h^2 + l_h^2*m_p^2*cos(theta_h)^2 + l_p^2*m_p^2*cos(theta_p)^2 + l_p^2*m_p^2*cos(theta_h - theta_p)^2 + 2*l_h^2*m_h*m_p*cos(theta_h)^2 + l_p^2*m_h*m_p*cos(theta_p)^2 + l_p^2*m_c*m_p*cos(theta_h - theta_p)^2 + l_p^2*m_h*m_p*cos(theta_h - theta_p)^2 - 2*l_p^2*m_p^2*cos(theta_h - theta_p)*cos(theta_h)*cos(theta_p) - 2*l_p^2*m_h*m_p*cos(theta_h - theta_p)*cos(theta_h)*cos(theta_p)));
% dX(3) = X(4);
% dX(4) =(Ftheta_h*l_p^2*m_p*cos(theta_p)^2 - Ftheta_h*l_h^2*m_h - Ftheta_h*l_h^2*m_p - Ftheta_h*l_h^2*m_c + g*l_h^3*m_h^2*sin(theta_h) + g*l_h^3*m_p^2*sin(theta_h) - F*l_h^3*m_h*cos(theta_h) - F*l_h^3*m_p*cos(theta_h) + dottheta_p^2*l_h^3*l_p*m_p^2*sin(theta_h - theta_p) + g*l_h^3*m_c*m_h*sin(theta_h) + g*l_h^3*m_c*m_p*sin(theta_h) + 2*g*l_h^3*m_h*m_p*sin(theta_h) + dottheta_h^2*l_h^4*m_h^2*cos(theta_h)*sin(theta_h) + dottheta_h^2*l_h^4*m_p^2*cos(theta_h)*sin(theta_h) + Ftheta_p*l_h*l_p*m_c*cos(theta_h - theta_p) + Ftheta_p*l_h*l_p*m_h*cos(theta_h - theta_p) + Ftheta_p*l_h*l_p*m_p*cos(theta_h - theta_p) + F*l_h*l_p^2*m_p*cos(theta_h - theta_p)*cos(theta_p) + dottheta_p^2*l_h^3*l_p*m_c*m_p*sin(theta_h - theta_p) + dottheta_p^2*l_h^3*l_p*m_h*m_p*sin(theta_h - theta_p) - dottheta_p^2*l_h*l_p^3*m_p^2*sin(theta_h - theta_p)*cos(theta_p)^2 + 2*dottheta_h^2*l_h^4*m_h*m_p*cos(theta_h)*sin(theta_h) - Ftheta_p*l_h*l_p*m_h*cos(theta_h)*cos(theta_p) - Ftheta_p*l_h*l_p*m_p*cos(theta_h)*cos(theta_p) + dottheta_h^2*l_h^2*l_p^2*m_p^2*cos(theta_h - theta_p)*sin(theta_h - theta_p) - g*l_h*l_p^2*m_p^2*cos(theta_h - theta_p)*sin(theta_p) + dottheta_p^2*l_h^3*l_p*m_p^2*cos(theta_h)*sin(theta_p) - g*l_h*l_p^2*m_p^2*cos(theta_p)^2*sin(theta_h) - dottheta_h^2*l_h^2*l_p^2*m_p^2*cos(theta_h - theta_p)*cos(theta_p)*sin(theta_h) - dottheta_h^2*l_h^2*l_p^2*m_p^2*sin(theta_h - theta_p)*cos(theta_h)*cos(theta_p) + g*l_h*l_p^2*m_p^2*cos(theta_h)*cos(theta_p)*sin(theta_p) + dottheta_h^2*l_h^2*l_p^2*m_c*m_p*cos(theta_h - theta_p)*sin(theta_h - theta_p) + dottheta_h^2*l_h^2*l_p^2*m_h*m_p*cos(theta_h - theta_p)*sin(theta_h - theta_p) - g*l_h*l_p^2*m_c*m_p*cos(theta_h - theta_p)*sin(theta_p) - g*l_h*l_p^2*m_h*m_p*cos(theta_h - theta_p)*sin(theta_p) - dottheta_p^2*l_h*l_p^3*m_p^2*cos(theta_h - theta_p)*cos(theta_p)*sin(theta_p) + dottheta_p^2*l_h^3*l_p*m_h*m_p*cos(theta_h)*sin(theta_p) - g*l_h*l_p^2*m_h*m_p*cos(theta_p)^2*sin(theta_h) - dottheta_h^2*l_h^2*l_p^2*m_h*m_p*cos(theta_h - theta_p)*cos(theta_p)*sin(theta_h) - dottheta_h^2*l_h^2*l_p^2*m_h*m_p*sin(theta_h - theta_p)*cos(theta_h)*cos(theta_p) + g*l_h*l_p^2*m_h*m_p*cos(theta_h)*cos(theta_p)*sin(theta_p))/(l_h^2*(l_h^2*m_h^2*cos(theta_h)^2 - l_h^2*m_p^2 - l_h^2*m_c*m_h - l_h^2*m_c*m_p - 2*l_h^2*m_h*m_p - l_h^2*m_h^2 + l_h^2*m_p^2*cos(theta_h)^2 + l_p^2*m_p^2*cos(theta_p)^2 + l_p^2*m_p^2*cos(theta_h - theta_p)^2 + 2*l_h^2*m_h*m_p*cos(theta_h)^2 + l_p^2*m_h*m_p*cos(theta_p)^2 + l_p^2*m_c*m_p*cos(theta_h - theta_p)^2 + l_p^2*m_h*m_p*cos(theta_h - theta_p)^2 - 2*l_p^2*m_p^2*cos(theta_h - theta_p)*cos(theta_h)*cos(theta_p) - 2*l_p^2*m_h*m_p*cos(theta_h - theta_p)*cos(theta_h)*cos(theta_p)));
% dX(5) = X(6);
% dX(6)=-(Ftheta_p*l_h*m_h^2 + Ftheta_p*l_h*m_p^2 - Ftheta_p*l_h*m_h^2*cos(theta_h)^2 - Ftheta_p*l_h*m_p^2*cos(theta_h)^2 - Ftheta_h*l_p*m_p^2*cos(theta_h - theta_p) + Ftheta_p*l_h*m_c*m_h + Ftheta_p*l_h*m_c*m_p + 2*Ftheta_p*l_h*m_h*m_p + F*l_h*l_p*m_p^2*cos(theta_p) - 2*Ftheta_p*l_h*m_h*m_p*cos(theta_h)^2 + dottheta_h^2*l_h^2*l_p*m_p^3*sin(theta_h - theta_p) - g*l_h*l_p*m_p^3*sin(theta_p) + Ftheta_h*l_p*m_p^2*cos(theta_h)*cos(theta_p) - Ftheta_h*l_p*m_c*m_p*cos(theta_h - theta_p) - Ftheta_h*l_p*m_h*m_p*cos(theta_h - theta_p) - F*l_h*l_p*m_p^2*cos(theta_h - theta_p)*cos(theta_h) + F*l_h*l_p*m_h*m_p*cos(theta_p) + dottheta_p^2*l_h*l_p^2*m_p^3*cos(theta_h - theta_p)*sin(theta_h - theta_p) + g*l_h*l_p*m_p^3*cos(theta_h - theta_p)*sin(theta_h) - dottheta_h^2*l_h^2*l_p*m_p^3*sin(theta_h - theta_p)*cos(theta_h)^2 + g*l_h*l_p*m_p^3*cos(theta_h)^2*sin(theta_p) + Ftheta_h*l_p*m_h*m_p*cos(theta_h)*cos(theta_p) + dottheta_h^2*l_h^2*l_p*m_c*m_p^2*sin(theta_h - theta_p) + 2*dottheta_h^2*l_h^2*l_p*m_h*m_p^2*sin(theta_h - theta_p) + dottheta_h^2*l_h^2*l_p*m_h^2*m_p*sin(theta_h - theta_p) - g*l_h*l_p*m_c*m_p^2*sin(theta_p) - 2*g*l_h*l_p*m_h*m_p^2*sin(theta_p) - g*l_h*l_p*m_h^2*m_p*sin(theta_p) - dottheta_h^2*l_h^2*l_p*m_p^3*cos(theta_p)*sin(theta_h) - dottheta_p^2*l_h*l_p^2*m_p^3*cos(theta_p)*sin(theta_p) - g*l_h*l_p*m_p^3*cos(theta_h)*cos(theta_p)*sin(theta_h) - F*l_h*l_p*m_h*m_p*cos(theta_h - theta_p)*cos(theta_h) - 2*dottheta_h^2*l_h^2*l_p*m_h*m_p^2*cos(theta_p)*sin(theta_h) - dottheta_h^2*l_h^2*l_p*m_h^2*m_p*cos(theta_p)*sin(theta_h) - dottheta_p^2*l_h*l_p^2*m_h*m_p^2*cos(theta_p)*sin(theta_p) + dottheta_p^2*l_h*l_p^2*m_c*m_p^2*cos(theta_h - theta_p)*sin(theta_h - theta_p) + dottheta_p^2*l_h*l_p^2*m_h*m_p^2*cos(theta_h - theta_p)*sin(theta_h - theta_p) + dottheta_h^2*l_h^2*l_p*m_c*m_h*m_p*sin(theta_h - theta_p) + g*l_h*l_p*m_c*m_p^2*cos(theta_h - theta_p)*sin(theta_h) + 2*g*l_h*l_p*m_h*m_p^2*cos(theta_h - theta_p)*sin(theta_h) + g*l_h*l_p*m_h^2*m_p*cos(theta_h - theta_p)*sin(theta_h) - g*l_h*l_p*m_c*m_h*m_p*sin(theta_p) - 2*dottheta_h^2*l_h^2*l_p*m_h*m_p^2*sin(theta_h - theta_p)*cos(theta_h)^2 - dottheta_h^2*l_h^2*l_p*m_h^2*m_p*sin(theta_h - theta_p)*cos(theta_h)^2 + dottheta_h^2*l_h^2*l_p*m_p^3*cos(theta_h - theta_p)*cos(theta_h)*sin(theta_h) + dottheta_p^2*l_h*l_p^2*m_p^3*cos(theta_h - theta_p)*cos(theta_h)*sin(theta_p) - dottheta_p^2*l_h*l_p^2*m_p^3*sin(theta_h - theta_p)*cos(theta_h)*cos(theta_p) + 2*g*l_h*l_p*m_h*m_p^2*cos(theta_h)^2*sin(theta_p) + g*l_h*l_p*m_h^2*m_p*cos(theta_h)^2*sin(theta_p) + 2*dottheta_h^2*l_h^2*l_p*m_h*m_p^2*cos(theta_h - theta_p)*cos(theta_h)*sin(theta_h) + dottheta_h^2*l_h^2*l_p*m_h^2*m_p*cos(theta_h - theta_p)*cos(theta_h)*sin(theta_h) + dottheta_p^2*l_h*l_p^2*m_h*m_p^2*cos(theta_h - theta_p)*cos(theta_h)*sin(theta_p) - dottheta_p^2*l_h*l_p^2*m_h*m_p^2*sin(theta_h - theta_p)*cos(theta_h)*cos(theta_p) - 2*g*l_h*l_p*m_h*m_p^2*cos(theta_h)*cos(theta_p)*sin(theta_h) - g*l_h*l_p*m_h^2*m_p*cos(theta_h)*cos(theta_p)*sin(theta_h) + g*l_h*l_p*m_c*m_h*m_p*cos(theta_h - theta_p)*sin(theta_h))/(l_h*m_p*(l_h^2*m_h^2*cos(theta_h)^2 - l_h^2*m_p^2 - l_h^2*m_c*m_h - l_h^2*m_c*m_p - 2*l_h^2*m_h*m_p - l_h^2*m_h^2 + l_h^2*m_p^2*cos(theta_h)^2 + l_p^2*m_p^2*cos(theta_p)^2 + l_p^2*m_p^2*cos(theta_h - theta_p)^2 + 2*l_h^2*m_h*m_p*cos(theta_h)^2 + l_p^2*m_h*m_p*cos(theta_p)^2 + l_p^2*m_c*m_p*cos(theta_h - theta_p)^2 + l_p^2*m_h*m_p*cos(theta_h - theta_p)^2 - 2*l_p^2*m_p^2*cos(theta_h - theta_p)*cos(theta_h)*cos(theta_p) - 2*l_p^2*m_h*m_p*cos(theta_h - theta_p)*cos(theta_h)*cos(theta_p)));
end