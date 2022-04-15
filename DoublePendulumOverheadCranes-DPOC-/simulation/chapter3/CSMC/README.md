# CSMC for dual pendulum overhead crane

二级摆控制律为<sup><a href = "#ref1">[1-3]</a></sup>
$$
\begin{align}
&F_{x} = -(m_h+m_p)l_h(cos\theta_h\ddot \theta_h-\dot \theta_h^2sin\theta_h)-m_pl_p\ddot \theta_pcos\theta_p+m_pl_p\dot \theta_p^2sin\theta_p\\
&\ \ \ \ \  \ \ \ \ \ -(m_c+m_h+m_p)(\lambda\dot x+\alpha\dot \theta_h+\beta\dot \theta_p)-ktanh(s) \\
& s = \dot x+\lambda(x-x_d)+\alpha\theta_h+\beta\theta_p
\end{align}
$$

模型参数为
$$
m_c = 8kg,\ m_h = 0.5kg,\ m_p = 1kg,\ l_h = 1m,\ l_p = 0.5m,\\ \ x_d = 2m,\ frx = 4.6,\ \varepsilon_x = 0.01, krx = -0.5;
$$
选取增益为
$$
\lambda = 0.5,\ \alpha= 17, \ \beta = -11, k = 90;
$$



# 参考文献

<a name="ref1"><font color='black'>[1]</font></a>张梦华.欠驱动单级摆及二级摆型桥式吊车非线性控制策略研究[D].山东大学,2018.

<a name="ref2"><font color='black'>[2]</font></a>Almutairi,,Naif等.Sliding mode control of a three-dimensional overhead crane[J].JVC/JOURNAL OF VIBRATION AND CONTROL,2009,15(11):1679-1730.

<a name="ref3"><font color='black'>[3]</font></a>Tuan,,Le等.Sliding mode controls of double-pendulum crane systems[J].JOURNAL OF MECHANICAL SCIENCE AND TECHNOLOGY,2013,27(6):1863-1873.

