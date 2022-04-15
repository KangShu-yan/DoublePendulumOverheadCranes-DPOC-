# uncertain kinematic and dynamic

考虑误差约束的二级摆自适应控制<sup><a href = "#ref1">[1]</a></sup>

$$
\begin{align}
&

F_x = -\lambda\frac{e_xN^2}{(N^2-e^2_x)^2}+Y^T\hat w-k_pe_x-k_d\dot e_x
\\
& \dot {\hat w}=-\phi Y\dot e_x\\
& e_x=x-x_d\\
& Y = \left[ \begin{matrix}
	\dot x&	\dot \theta_h	&	\dot \theta_p	&\ddot x_d		&	tanh(\frac{\dot x}{\varepsilon})	&		-|\dot x|\dot x\\
\end{matrix} \right] ^T\\
& w = \left[ \begin{matrix}
	d_x &	d_{\theta_h}l_h	&	d_{\theta_p}l_p	&m_c+m_h+m_p		&	f_{rx}	&		k_{rx}\\
\end{matrix} \right]
\\
& 
x_r(t) = \frac{p_d}{2}+\frac{k^2_v}{4k_a}\ln(\frac{cosh(\frac{2k_at}{k_v}-\epsilon)}{cosh(\frac{2k_at}{k_v}-\epsilon-2p_d\frac{k_a}{k^2_v})})\\
& \dot x_r(t)=k_v\frac{tanh(2k_at/k_v-\epsilon)-tanh(2k_a t/k_v-\epsilon-2p_dk_a/k_v^2)}{2}\\
& \ddot x_r(t) = k_a(\frac{1}{cosh^2(2k_at/kv-\epsilon)}-\frac{1}{cosh^2(2k_at/kv-\epsilon-2p_dk_a/k^2_v)})
\end{align}
$$
$N$是跟踪误差$e_x$的上限，



# 参考文献

<a name="ref1"><font color='black'>[1]</font></a>张梦华.欠驱动单级摆及二级摆型桥式吊车非线性控制策略研究[D].山东大学,2018.

Zhang,,Menghua等.Adaptive tracking control for double-pendulum overhead cranes subject to tracking error limitation, parametric uncertainties and external disturbances[J].MECHANICAL SYSTEMS AND SIGNAL PROCESSING,2016,76-77:15-32.
