# uncertain kinematic and dynamic

考虑误差约束的二级摆自适应控制<sup><a href = "#ref1">[1]</a></sup>

$$
\begin{align}
& u = -k_pe_x-k_d\dot x-\frac{k_\chi e_x}{(x_d+\chi-x)^2}-\frac{k_\chi e^2_x}{(x_d+\chi-x)^3}-k_\theta\dot\theta^2_h\dot x+\phi^T\hat w\\
&\dot {\hat w}= - \Gamma\phi\dot x 
\\
&w = \left[ \begin{matrix}
	f_{rx}&		k_{rx}\\
\end{matrix} \right] ^T, \ \ \phi = \left[ \begin{matrix}
	\tan\text{h}\left( \frac{\dot{x}}{\varepsilon} \right)&		|\dot{x}|\dot{x}\\
\end{matrix} \right] ^T

\end{align}
$$
其中$\chi$是位置上限

![image-20220116214658931](C:\Users\Thinkpad\AppData\Roaming\Typora\typora-user-images\image-20220116214658931.png)

弱点：

对变位移的运动敏感

# 参考文献

<a name="ref1"><font color='black'>[1]</font></a>张梦华.欠驱动单级摆及二级摆型桥式吊车非线性控制策略研究[D].山东大学,2018.

Sun,,Ning等.Nonlinear Antiswing Control for Crane Systems with Double-Pendulum Swing Effects and Uncertain Parameters: Design and Experiments[J].IEEE TRANSACTIONS ON AUTOMATION SCIENCE AND ENGINEERING,2018,15(3):1413-1422.

