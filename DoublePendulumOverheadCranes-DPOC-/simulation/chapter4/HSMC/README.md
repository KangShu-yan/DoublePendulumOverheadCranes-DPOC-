# HSMC for dual pendulum overhead crane

小车位移
$$
\begin{align}
&\ddot x = \frac{(l_hsin(\theta_h)(m_h + m_p)\dot\theta_h^2 + l_pm_psin(\theta_p)\dot\theta_p^2 + F_a - \ddot\theta_hl_hcos(\theta_h)(m_h + m_p) - \ddot\theta_pl_pm_pcos(\theta_p))}{(m_c + m_h + m_p)}
\\&\ \ = \frac{a+F_a}{m_c+m_h+m_p}
 

\end{align}
$$


吊钩为
$$
\begin{align}
&\ddot\theta_h =
 
-\frac{(d_h\dot\theta_h + gl_hsin(\theta_h)(m_h + m_p) + \ddot\theta_pl_hl_pm_pcos(\theta_h - \theta_p) + \dot\theta_p^2l_hl_pm_psin(\theta_h - \theta_p) 
)

}{((m_h + m_p)l_h^2 + \frac{(cos(\theta_h)(m_h + m_p)l_h)}{(m_c + m_h + m_p))}}
\\&
\ \ \ \ -\frac{

 l_hcos(\theta_h)(m_h + m_p)(l_hsin(\theta_h)(m_h + m_p)\dot\theta_h^2 + l_pm_psin(\theta_p)\dot\theta_p^2 + F_a - \ddot\theta_pl_pm_pcos(\theta_p))

}{(m_c + m_h + m_p)(m_h + m_p)l_h^2 + (cos(\theta_h)(m_h + m_p)l_h)}
 \\&
 \ \ \ =b_1-\frac{b_2+F_a}{b_3}
 \end{align}
$$
负载
$$
\begin{align}
&
 
 
\ddot\theta_p =
 
-\frac{((m_c + m_h + m_p)(d_h\dot\theta_p + gl_pm_psin(\theta_p) + \ddot\theta_hl_hl_pm_pcos(\theta_h - \theta_p) - \dot\theta_h^2l_hl_pm_psin(\theta_h - \theta_p) 
 )
}{(l_pm_p(cos(\theta_p) + l_pm_c + l_pm_h + l_pm_p))}
\\&
\ \  \ -\frac{(l_pm_pcos(\theta_p)(l_hsin(\theta_h)(m_h + m_p)\dot\theta_h^2 + l_pm_psin(\theta_p)\dot\theta_p^2 + F_a - \ddot\theta_hl_hcos(\theta_h)(m_h + m_p))))
}{(l_pm_p(m_c + m_h + m_p)(cos(\theta_p) + l_pm_c + l_pm_h + l_pm_p))}
 \\&
 \ \ \ =c_1-\frac{c_2+F_a}{c_3}

 
 \end{align}
$$
最终有
$$
\begin{align}
& -KS-\eta sgn(S)= A+BF_a

\\& S = \mu_1s_1+\mu_2s_2+\mu_3s_3
\\&
s_1 = \dot x+\lambda_1(x-x_d), \ s_2 = \dot\theta_h+\lambda_2\theta_h,\ s_3 = \dot\theta_p+\lambda_3\theta_p
\end{align}
$$
其中
$$
\begin{align}
& A+BF_a = \frac{a}{m_c+m_h+m_p}\mu_1+(b_1-\frac{b_2}{b_3})\mu_2+(c_1-\frac{c_2}{c_3})\mu_3
\\&
\ \ \ \ \ \ \ \ \ \ \ \ \ \  \ +(\frac{\mu_1}{m_c+m_h+m_p}-\frac{\mu_2}{b_3}-\frac{\mu_3}{c_3})F_a
\\&

\end{align}
$$

$$
\begin{align}
&\ddot{x}=\frac{\left( l_hsin\left( \theta _h \right) \left( m_h+m_p \right) \dot{\theta}_{h}^{2}+l_pm_psin\left( \theta _p \right) \dot{\theta}_{p}^{2}+F_a-\ddot{\theta}_hl_hcos\left( \theta _h \right) \left( m_h+m_p \right) -\ddot{\theta}_pl_pm_pcos\left( \theta _p \right) \right)}{\left( m_c+m_h+m_p \right)}
\\
&\ddot{\theta}_h=-\frac{\left( d_h\dot{\theta}_h+gl_hsin\left( \theta _h \right) \left( m_h+m_p \right) +\ddot{\theta}_pl_hl_pm_pcos\left( \theta _h-\theta _p \right) +\dot{\theta}_{p}^{2}l_hl_pm_psin\left( \theta _h-\theta _p \right) +\frac{\left( l_hcos\left( \theta _h \right) \left( m_h+m_p \right) \left( l_hsin\left( \theta _h \right) \left( m_h+m_p \right) \dot{\theta}_{h}^{2}+l_pm_psin\left( \theta _p \right) \dot{\theta}_{p}^{2}+F_a-\ddot{\theta}_pl_pm_pcos\left( \theta _p \right) \right) \right)}{\left( m_c+m_h+m_p \right)} \right)}{\left( \left( m_h+m_p \right) l_{h}^{2}+\frac{\left( cos\left( \theta _h \right) \left( m_h+m_p \right) l_h \right)}{\left( m_c+m_h+m_p \right)} \right)}
\\
&\ddot{\theta}_p=-\frac{\left( \left( m_c+m_h+m_p \right) \left( d_h\dot{\theta}_p+gl_pm_psin\left( \theta _p \right) +\ddot{\theta}_hl_hl_pm_pcos\left( \theta _h-\theta _p \right) -\dot{\theta}_{h}^{2}l_hl_pm_psin\left( \theta _h-\theta _p \right) +\frac{\left( l_pm_pcos\left( \theta _p \right) \left( l_hsin\left( \theta _h \right) \left( m_h+m_p \right) \dot{\theta}_{h}^{2}+l_pm_psin\left( \theta _p \right) \dot{\theta}_{p}^{2}+F_a-\ddot{\theta}_hl_hcos\left( \theta _h \right) \left( m_h+m_p \right) \right) \right)}{\left( m_c+m_h+m_p \right)} \right) \right)}{\left( l_pm_p\left( cos\left( \theta _p \right) +l_pm_c+l_pm_h+l_pm_p \right) \right)}

\end{align}
$$
得到
$$
\begin{align}
&\ddot{x}=\frac{\left( l_hsin\left( \theta _h \right) \left( m_h+m_p \right) \dot{\theta}_{h}^{2}+l_pm_psin\left( \theta _p \right) \dot{\theta}_{p}^{2}+F_a-\ddot{\theta}_hl_hcos\left( \theta _h \right) \left( m_h+m_p \right) -\ddot{\theta}_pl_pm_pcos\left( \theta _p \right) \right)}{ m_c+m_h+m_p }
\\& = \frac{a_1+F_a}{a_2}
\\
&\ddot{\theta}_h=-\frac{ \left(d_h\dot{\theta}_h+gl_hsin\left( \theta _h \right) \left( m_h+m_p \right) +\ddot{\theta}_pl_hl_pm_pcos\left( \theta _h-\theta _p \right) +\dot{\theta}_{p}^{2}l_hl_pm_psin\left( \theta _h-\theta _p \right) \right)\left( m_c+m_h+m_p \right)+l_hcos\left( \theta _h \right) \left( m_h+m_p \right) 

\left( l_hsin\left( \theta _h \right) \left( m_h+m_p \right) \dot{\theta}_{h}^{2}+l_pm_psin\left( \theta _p \right) \dot{\theta}_{p}^{2}+F_a-\ddot{\theta}_pl_pm_pcos\left( \theta _p \right) \right) }{ \left( m_h+m_p \right) l_{h}^{2}\left( m_c+m_h+m_p \right)+ cos\left( \theta _h \right) \left( m_h+m_p \right) l_h  }

\\&=\frac{b_1+b_2F_a}{b_3}
\\
&\ddot{\theta}_p=-\frac{ \left( m_c+m_h+m_p \right) \left( d_p\dot{\theta}_p+gl_pm_psin\left( \theta _p \right) +\ddot{\theta}_hl_hl_pm_pcos\left( \theta _h-\theta _p \right) -\dot{\theta}_{h}^{2}l_hl_pm_psin\left( \theta _h-\theta _p \right) \right)

+ l_pm_pcos\left( \theta _p \right) \left( l_hsin\left( \theta _h \right) \left( m_h+m_p \right) \dot{\theta}_{h}^{2}+l_pm_psin\left( \theta _p \right) \dot{\theta}_{p}^{2}+F_a-\ddot{\theta}_hl_hcos\left( \theta _h \right) \left( m_h+m_p \right) \right) }{l_pm_p\left( cos\left( \theta _p \right) +l_pm_c+l_pm_h+l_pm_p \right) }

\\
&  = \frac{c_1+c_2F_a}{c_3}
\end{align}
$$
最终的控制量为



![image-20220116203140267](C:\Users\Thinkpad\AppData\Roaming\Typora\typora-user-images\image-20220116203140267.png)

# 参考文献

<a name="ref1"><font color='black'>[1]</font></a>张梦华.欠驱动单级摆及二级摆型桥式吊车非线性控制策略研究[D].山东大学,2018.

<a name="ref2"><font color='black'>[2]</font></a>Almutairi,,Naif等.Sliding mode control of a three-dimensional overhead crane[J].JVC/JOURNAL OF VIBRATION AND CONTROL,2009,15(11):1679-1730.

<a name="ref3"><font color='black'>[3]</font></a>Tuan,,Le等.Sliding mode controls of double-pendulum crane systems[J].JOURNAL OF MECHANICAL SCIENCE AND TECHNOLOGY,2013,27(6):1863-1873.

