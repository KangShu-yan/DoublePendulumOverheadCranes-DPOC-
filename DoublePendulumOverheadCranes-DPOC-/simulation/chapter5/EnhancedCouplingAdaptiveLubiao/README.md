# Enhanced coupling  control for dual pendulum overhead crane

$$
\begin{align}
&F_{x} = -kk_{\alpha1}\hat e_\xi-kk_{\beta1}H\\
&H = \dot x-\hat \lambda_1(l_h sin\theta_h-l_hcos(\theta_h)\dot \theta_h)-\hat \lambda_2l_pcos\theta_p\dot \theta_p \\ 
& \hat \lambda_1= k(m_h+\hat m_{2p}),\  \hat \lambda_2=k\hat m_{2p} \\
&\hat e_\xi = e_x-\hat \lambda_1 sin\theta_h-\hat \lambda_2sin\theta_p \\
& e_x = x-x_d
\\
& \varXi = l_hsin\theta_h+l_psin\theta_p, \ e_1 = l_h-l_{hd}\\
& \dot \varXi = l_hcos\theta_h\dot \theta_h+l_pcos\theta_p\dot \theta_p
\\
& \dot {\hat m}_{2p} = -\frac{k(k_{\alpha1} \varXi-k_{\beta1}\dot {\varXi})-g\dot e_1}{k_\sigma-k_{\alpha1}k^2\varXi^2} \\

\end{align}
$$

论文中

![image-20220117102718801](C:\Users\Thinkpad\AppData\Roaming\Typora\typora-user-images\image-20220117102718801.png)

弱点：

需要知道绳长

# 参考文献

Lu,,Biao et.Enhanced-coupling adaptive control for double-pendulum overhead cranes with payload hoisting and lowering[J].AUTOMATICA,2019,101:241-251.

Shah,,Umer等.Input shaping control of a nuclear power plant's fuel transport system[J].NONLINEAR DYNAMICS,2014,77(4):1737-1748.
