# quasi pid for dual pendulum overhead crane

二级摆控制律为<sup><a href = "#ref1">[1-3]</a></sup>
$$
\begin{align}
&F_{x} = -k_ptanh(e)-k_dtanh(\dot x)-k_{\theta_h}tanh^2(\dot\theta_h)tanh(\dot x)
\\& \ \ \ \ \ -k_{\theta_p}tanh^2(\dot \theta_p)tanh(\dot x)-k_itanh(\lambda^2 e+\lambda\int^t_0tanh(e)dt) \\
& e=x-x_d, 
\end{align}
$$

![image-20220116154313253](C:\Users\Thinkpad\AppData\Roaming\Typora\typora-user-images\image-20220116154313253.png)

不易于整定，

# 参考文献

<a name="ref1"><font color='black'>[1]</font></a>张梦华.欠驱动单级摆及二级摆型桥式吊车非线性控制策略研究[D].山东大学,2018.

Sun,,Ning等.Transportation control of double-pendulum cranes with a nonlinear quasi-pid scheme: Design and experiments[J].IEEE TRANSACTIONS ON SYSTEMS, MAN, AND CYBERNETICS: SYSTEMS,2019,49(7):1408-1418.

