# PD sliding mode control for dual pendulum overhead crane

$$
\begin{align}
&F_{ax} = -k_pe-k_d\dot e-k_stanh(s)\\
&e = x-x_d+l_h\theta_h+l_p\theta_p\\
&\dot e = \dot x +l_h\dot \theta+l_p\dot \theta_p\\
& s = e+\alpha \dot e
\end{align}
$$

模型参数为
$$
m_c = 8kg,\ m_h = 0.5kg,\ m_p = 1kg,\ l_h = 1m,\ l_p = 0.5m,\\ \ x_d = 2m,\ frx = 4.6,\ \varepsilon_x = 0.01, krx = -0.5;
$$
选取增益为
$$
k_p = 200,\ k_d = 10, \ k_s = 30, \alpha = 2;
$$

# 实验

kp=5;kd=6;ks = 0.1;alpha=0.1.由模型1求出,此时，lambda = -1;



# 参考文献

张梦华.欠驱动单级摆及二级摆型桥式吊车非线性控制策略研究[D].山东大学,2018.
