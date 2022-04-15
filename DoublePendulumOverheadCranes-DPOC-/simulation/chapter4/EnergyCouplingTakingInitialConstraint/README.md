# Energy coupling for dual pendulum overhead crane 

考虑初始约束的二级摆控制律为<sup><a href = "#ref1">[1]</a></sup>
$$
\begin{align}
&F_{x} = F_{rx}-k_ptanh(\xi_x)-k_d\dot \xi_x\\
& \xi_x = x-x_d+\lambda_1sin\theta_h+\lambda_2sin\theta_p\\
& \dot \xi_x = \dot x +\lambda_1\dot \theta_hcos\theta_h+\lambda_2\dot \theta_pcos\theta_p
\end{align}
$$

模型参数为
$$
m_c = 8kg,\ m_h = 0.5kg,\ m_p = 1kg,\ l_h = 1m,\ l_p = 0.5m,\\ \ x_d = 2m,\ frx = 4.6,\ \varepsilon_x = 0.01, krx = -0.5;
$$
选取增益为
$$
k_p =12 ,\ k_d = 30,\ \lambda_1 = -6,\ \lambda_2= -1
$$



# 参考文献

<a name="ref1"><font color='black'>[1]</font></a>张梦华.欠驱动单级摆及二级摆型桥式吊车非线性控制策略研究[D].山东大学,2018.

