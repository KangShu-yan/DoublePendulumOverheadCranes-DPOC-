# uncertain kinematic and dynamic

考虑初始约束的二级摆控制律为<sup><a href = "#ref1">[1]</a></sup>



# 二级摆

## 尝试1

$$
\dot {\tilde x} = \dot x+\lambda_x\tilde x-\lambda_h\dot \theta_h-\lambda_p\dot \theta_p
$$



$$
\begin{align}
&P=U-G-H \\
&= \left[ \begin{array}{c}
	u - F_{rx} +  \lambda_x (m_c + m_h + m_p) (\dot x +  \lambda_x  \tilde x -  \lambda_h \dot { \tilde \theta}_h -  \lambda_p  \dot {\tilde  \theta}_p)\\
	 l_h \lambda_x cos( \theta_h) (m_h + m_p) (\dot x +\lambda_x\tilde x-  \lambda_h  \dot{\tilde \theta}_h -  \lambda_p  \dot {\tilde\theta}_p) - g l_h sin( \theta_h) (m_h + m_p) - d_h \dot \theta_h\\
	l_p \ \lambda_x m_p cos(\theta_p) ( \dot x +  \lambda_x  \tilde x -  \lambda_h  \dot {\tilde\theta}_h -  \lambda_p  \dot {\tilde \theta}_p) - g l_p m_p sin(\theta_p) - d_p  \dot \theta_p\\
\end{array} \right] 
\end{align}
$$

$$
\begin{align}
&\chi^T P = (\dot x + \lambda_x \tilde x) (F_{ax} + \lambda_x (m_c + m_h + m_p) (\dot x+ \lambda_x \tilde x - \lambda_h \tilde \theta_h - \lambda_p \tilde \theta_p))+ \dot \theta_h (F_{\theta_h} - g l_h sin(\theta_h) (m_h + m_p) \\
& \ \ \ \ \ \ \ \ \ \ \ + l_h \lambda_x cos(\theta_h) (m_h + m_p) (\dot x + \lambda_x \tilde x - \lambda_h \dot {\tilde \theta}_h - \lambda_p\dot { \tilde \theta}_p))+ \dot \theta_p (F_{\theta_p} - g l_p m_p sin(\theta_p) \\
&\ \ \  \ \ \ \ \ \ \ \ + l_p \lambda_x m_p cos(\theta_p) (\dot x + \lambda_x \tilde x - \lambda_h \dot {\tilde \theta}_h - \lambda_p \dot {\tilde \theta}_p))

\end{align}
$$

取能量函数
$$
V_1 = \frac{1}{2}\chi^TM\chi +(m_h+m_p)l_hg(1-cos(\theta_h))+m_pgl_p(1-cos(\theta_p))
$$
对其求导有
$$
\begin{align}
&\dot V_1 = \chi^T(U-G-H)+(m_h+m_p)gl_hsin(\theta_h)\dot \theta_h+m_pgl_psin(\theta_p)\dot \theta_p\\
&\ \ \ \  =(\dot x + \lambda_x \tilde x) (F_{ax} + l_h \lambda_x cos(\theta_h) (m_h + m_p) (\dot x + \lambda_x \tilde x - \lambda_h \dot {\tilde\theta}_h - \lambda_p \dot {\tilde \theta}_p))\\
& \ \ \ \ \ \ \ \ \ + \dot \theta_h (F_{\theta_h} + l_h \lambda_x cos(\theta_h) (m_h + m_p) (\dot x + \lambda_x \tilde x - \lambda_h \dot {\tilde\theta}_h - \lambda_p \dot {\tilde \theta}_p))\\
&\ \ \ \ \ \ \ \ \ + \dot \theta_p (F_{\theta_p}  + l_p \lambda_x m_p cos(\theta_p) (\dot x + \lambda_x \tilde x - \lambda_h \dot {\tilde\theta_h} - \lambda_p \dot {\tilde \theta_p}))\\
&\ \ \ \ =(\dot x + \lambda_x \tilde x)[F_{ax} + \lambda_x (m_c + m_h + m_p) (\dot x+ \lambda_x \tilde x - \lambda_h \dot {\tilde\theta}_h - \lambda_p \dot {\tilde \theta}_p)\\
&\ \ \ \ \ \ \ \ \ + l_h \lambda_x cos(\theta_h) (m_h + m_p)\dot \theta_h+  l_p \lambda_x m_p cos(\theta_p) ]\\
&\ \ \ \ \ \ \ \ \ +\dot \theta_h(-d_h\dot \theta_h+ l_h \lambda_x cos(\theta_h) (m_h + m_p) (- \lambda_h \dot {\tilde\theta}_h - \lambda_p \dot {\tilde \theta}_p))\\
&\ \ \ \ \ \ \ \ \ +\dot \theta_p (-d_p\dot \theta_p  + l_p \lambda_x m_p cos(\theta_p) (- \lambda_h \dot {\tilde\theta}_h - \lambda_p \dot {\tilde \theta}_p))
\end{align}
$$
由$\dot{\tilde{\theta}}_h = \dot \theta_h,\ \dot{\tilde{\theta}}_p = \dot \theta_p $,有
$$
\begin{align}
&\dot V_1 = (\dot x + \lambda_x \tilde x)[F_{ax} + \lambda_x (m_c + m_h + m_p) (\dot x+ \lambda_x \tilde x - \lambda_h \dot {\tilde\theta}_h - \lambda_p \dot {\tilde \theta}_p)\\
&\ \ \ \ \ \ \ \ \ + l_h \lambda_x cos(\theta_h) (m_h + m_p)\dot \theta_h+  l_p \lambda_x m_p cos(\theta_p)\dot \theta_p ]\\
&\ \ \ \ \ \ \ \ \ -\dot \theta_h^2(d_h+ l_h \lambda_x\lambda_h cos(\theta_h) (m_h + m_p) ) -l_h \lambda_x \lambda_pcos(\theta_h) (m_h + m_p)  \dot {\theta}_h \dot { \theta}_p\\
&\ \ \ \ \ \ \ \ \ -\dot \theta_p^2 (d_p  + l_p \lambda_x  \lambda_pm_p cos(\theta_p)  )  - l_p \lambda_x\lambda_h m_p cos(\theta_p)  \dot {\theta}_h \dot { \theta}_p


\end{align}
$$
$$
V_2 =e^{-\int_0^t (\dot \theta_h-\beta\dot \theta_p)^2dt}>0
$$

对其求导有
$$
\dot V_2 =-e^{-\int_0^t (\dot \theta_h-\beta\dot \theta_p)^2dt}(\dot\theta_h^2+\beta^2\dot\theta_p^2-2\beta\dot\theta_h\dot\theta_p)
$$
现取
$$
\beta = e^{\int_0^t (\dot \theta_h-\beta\dot \theta_p)^2dt}\frac{\lambda_x(\lambda_pl_hcos(\theta_h)(m_h+m_p)+l_p\lambda_hcos(\theta_p)m_p)}{2}
$$




取Lyapunov函数
$$
V_2 = \frac{1}{2}k_x(x+\int \lambda_x\tilde xdt )^2+(B-\int_0^t \kappa(t)(\dot \theta_h-\dot \theta_p)^2)+\frac{1}{2}k_e(\tilde x+\lambda_h\theta_h+\lambda_p\theta_p)^2
$$
其中
$$
\kappa(t) = \frac{\lambda_x(\lambda_pl_hcos(\theta_h)(m_h+m_p)+l_p\lambda_hcos(\theta_p)m_p)}{2}
$$
,B是一个趋于无穷，使得
$$
B-\int_0^t \kappa(t)*(\dot \theta_h-\dot \theta_p)^2 \ge 0
$$
的实数，

由此得到
$$
\begin{align}
&V=V_1+V_2 
\end{align}
$$
其导数为
$$
\begin{align}
&\dot V=(\dot x + \lambda_x \tilde x)[u-f_{r0x}tanh(\frac{\dot x}{\varepsilon_x})+k_{rx}|\dot x|\dot x + \lambda_x (m_c + m_h + m_p) (\dot x+ \lambda_x \tilde x - \lambda_h \dot {\tilde\theta}_h - \lambda_p \dot {\tilde \theta}_p)\\
&\ \ \ \ \ \ \ \ + l_h \lambda_x cos(\theta_h) (m_h + m_p)\dot \theta_h+  l_p \lambda_x m_p cos(\theta_p)\dot \theta_p ]\\
&\ \ \ \ \ \ \ \ -\dot \theta_h^2(d_h+ l_h \lambda_x cos(\theta_h) (m_h + m_p) \lambda_h) -l_h \lambda_x \lambda_pcos(\theta_h) (m_h + m_p)  \dot {\theta}_h \dot { \theta}_p\\
&\ \ \ \ \ \ \ \ -\dot \theta_p^2 (d_p  + l_p \lambda_x \lambda_pm_p cos(\theta_p)  )  - l_p \lambda_x\lambda_h m_p cos(\theta_p)  \dot {\theta}_h \dot { \theta}_p+ k_x(x+\int \lambda_x \tilde xdt )(\dot x +\lambda_x \tilde x )\\
&\ \ \ \ \ \ \ \ +(\lambda_x(\lambda_pl_hcos(\theta_h)(m_h+m_p)+l_p\lambda_hcos(\theta_p)m_p))\dot \theta_h\dot \theta_p+k_e(\tilde x+\lambda_h\theta_h+\lambda_p\theta_p)(\dot x +\lambda_x\tilde x)\\

\end{align}
$$
此时，取
$$
u = -k_p(x+\int \lambda_x \tilde xdt )-k_d(\dot x+\lambda_x\tilde x)-k_e(\tilde x+\lambda_h\theta_h+\lambda_p\theta_p)-Y^T \hat w
$$
其中
$$
\begin{align}
&\tilde x = x-x_d-\lambda_h\theta_h-\lambda_p\theta_p\ ,\ \ \ \ \ \ \ \ \ \ \dot {\tilde x }=\dot x+\lambda_x\tilde x -\lambda_h\dot \theta_h-\lambda_p\dot \theta_p   \\

&Y^T =\left[ \begin{matrix}
	-\tan\text{h}\left( \frac{\dot{x}}{\varepsilon _x} \right)&		|\dot{x}|\dot{x}&		\lambda _x\left( \dot{x}+\lambda _x\tilde{x}-\lambda _h\dot{\tilde{\theta}}_h-\lambda _p\dot{\tilde{\theta}}_p \right)&		\lambda _x\cos \left( \theta _h \right) \dot{\theta}_h&		\lambda _x\\
\end{matrix}\cos \left( \theta _p \right) \right]\\
&w^T=\left[ \begin{matrix}
	f_{r0x}&		k_{rx}&		m_c+m_h+m_p&		l_h\left( m_h+m_p \right)&		l_pm_p\\
\end{matrix} \right]

\\
& \dot {\hat w} = \varGamma Y\left( \dot{x}+\lambda _x\tilde{x} \right) 

\\ 
& 
\end{align}
$$

其中的$\varGamma$是五阶对角阵，

可以得到

由
$$
\begin{align}

&\dot \theta_h =0  \Rightarrow  \ddot \theta_h =0\\
&\dot \theta_p=0  \Rightarrow   \ddot \theta_p=0\\

&x+\lambda_x \int \tilde x  dt= 0\\

&\dot x+\lambda_x\tilde x=0
\end{align}
$$
进而得至
$$
\ddot x+\lambda_x \dot {\tilde x}=0 \Rightarrow \ddot x+\lambda_x(\dot x +\lambda_x\tilde x-\lambda_h\dot \theta_h-\lambda_p\dot \theta_p)=0\Rightarrow \ddot x = 0
$$
又由动力学方程有
$$
\begin{align}
&cos\theta_p \ddot x+gsin\theta_p = 0\\
&cos\theta_h\ddot x+gsin\theta_p = 0

\end{align}
$$
可得
$$
\theta_h = 0,  \ \theta_p = 0
$$
进而推出
$$
\tilde x+\lambda_h\theta_h+\lambda_p\theta_p=0\Rightarrow x=x_d
$$



## 尝试2

构造滑模，

$$
- (\dot \theta_h - \beta\dot \theta_p)(d_h\dot \theta_h + l_h cos(\theta_h)(m_h + m_p)(\dot \theta_h \lambda_h + \dot \theta_p \lambda_p) - (\alpha\dot \theta_h l_h sin(\theta_h)(m_h + m_p)(\dot \theta_h - \beta\dot \theta_p))/2 - (\alpha\beta\dot \theta_h\dot \theta_p l_h sin(\theta_h)(m_h + m_p))/2) \\
- \dot \theta_p(d_p\dot \theta_p + \dot \theta_h l_p \lambda_h m_p cos(\theta_p) + \dot \theta_p l_p \lambda_p m_p cos(\theta_p) - (\alpha\dot \theta_h\dot \theta_p l_p m_p sin(\theta_p))/2 + (\beta\dot \theta_p l_p m_p s sin(\theta_p))/2 + (\beta\dot \theta_h\dot \theta_p l_h l_p m_p sin(\theta_h - \theta_p))/2)
$$

$$
\begin{align}

&- (\dot \theta_h - \beta\dot \theta_p)
(d_h\dot \theta_h + l_h cos(\theta_h)(m_h + m_p)(\dot \theta_h \lambda_h + \dot \theta_p \lambda_p))\\

&- (\dot \theta_h - \beta\dot \theta_p)(- (\alpha\dot \theta_h l_h sin(\theta_h)(m_h + m_p)(\dot \theta_h - \beta\dot \theta_p))/2 )\\

&- (\dot \theta_h - \beta\dot \theta_p)(- (\alpha\beta\dot \theta_h\dot \theta_p l_h sin(\theta_h)(m_h + m_p))/2)\\

&- \dot \theta_p(d_p\dot \theta_p + \dot \theta_h l_p \lambda_h m_p cos(\theta_p) ) \\
&  - \dot \theta_p( \dot \theta_p l_p \lambda_p m_p cos(\theta_p) - (\alpha\dot \theta_h\dot \theta_p l_p m_p sin(\theta_p))/2 )\\
&   - \dot \theta_p( (\beta\dot \theta_p l_p m_p s sin(\theta_p))/2 + (\beta\dot \theta_h\dot \theta_p l_h l_p m_p sin(\theta_h - \theta_p))/2)\\
  \\
  & =  -(m_h + m_p)l_h cos(\theta_h)(\lambda_h\dot \theta_h^2+\lambda_p\beta\dot \theta_p^2)-d_h\dot \theta_h^2\\
   &\ \ \ \  +(m_h + m_p)l_h cos(\theta_h)(\lambda_p-\lambda_h\beta)\dot \theta_h \dot \theta_p+d_h\beta \dot \theta_h\dot \theta_p\\
   &\ \ \ \   +(m_h + m_p)l_hsin(\theta_h)\alpha\dot \theta_h(\dot \theta_h^2-2\beta\dot \theta_h \dot \theta_p+\beta^2 \dot \theta_p^2)/2\\
   &\ \ \ \ +(  (m_h + m_p)l_hsin(\theta_h)\alpha\dot \theta_h(\beta\dot \theta_h\dot \theta_p - \beta^2\dot \theta_p^2)/2\\
   &\ \ \ \ -d_p\dot \theta_p^2-m_pl_p\lambda_hcos(\theta_p)\dot \theta_p\dot \theta_h\\
   &\ \ \ \ -m_pl_p\lambda_pcos(\theta_p)\dot \theta_p^2-m_pl_psin(\theta_p) \alpha\dot \theta_h\dot \theta_p^2/2\\
   &\ \ \ \ -m_pl_hl_psin(\theta_h-\theta_p)\beta\dot \theta_h\dot\theta_p^2/2-( (\beta\dot \theta_p^2 l_p m_p s sin(\theta_p))/2
  
   \end{align}
$$

$$
\begin{align}
& \le -(m_h + m_p)l_h cos(\theta_h)((\lambda_h-\frac{\lambda_p-\lambda_h\beta}{2})\dot \theta_h^2+(\lambda_p\beta-\frac{\lambda_p-\lambda_h\beta}{2})\dot\theta_p^2)\\
& -(d_h-\frac{d_h}{2}\beta)\dot\theta_h^2-(d_p-\frac{d_h}{2}\beta)\dot\theta_p^2+  (m_h + m_p)l_hsin(\theta_h)\alpha\dot \theta_h(\dot \theta_h^2-\beta\dot\theta_h\dot\theta_p)/2\\
& 


\end{align}
$$

$$
-\beta\dot\theta_h\dot\theta_pl_h(m_hssin(\theta_h) + m_pssin(\theta_h) + \dot\theta_pl_pm_psin(\theta_h - \theta_p))
$$

$$
- (\dot\theta_h - \beta\dot\theta_p)
(d_h\dot\theta_h + l_hcos(\theta_h)(m_h + m_p)(\dot\theta_h\lambda_h + \dot\theta_p\lambda_p) + (\alpha\dot\theta_h^2l_hsin(\theta_h)(m_h + m_p))/2) \\
- \dot\theta_p(d_p\dot\theta_p + l_pm_pcos(\theta_p)*(\dot\theta_h\lambda_h + \dot\theta_p\lambda_p) - (\dot\theta_pl_pm_p(\beta s\sin(\theta_p) - \alpha\dot\theta_hsin(\theta_p) + \beta\dot\theta_hl_hsin(\theta_h - \theta_p)))/2
$$

$$
- \dot\theta_p (d_p \dot\theta_p + l_p m_p cos(\theta_p) (\dot\theta_h \lambda_h + \dot\theta_p \lambda_p) + (\dot\theta_h \dot\theta_p l_p m_p sin(\theta_p))/2) 
\\
- \dot\theta_h (d_h \dot\theta_h + l_h cos(\theta_h) (m_h + m_p) (\dot\theta_h \lambda_h + \dot\theta_p \lambda_p) + (\alpha \dot\theta_h^2 l_h sin(\theta_h) (m_h + m_p))/2)
 
$$

$$
- \dot\theta_p (d_p \dot\theta_p + l_p m_p cos(\theta_p) (\dot\theta_h \lambda_h + \dot\theta_p \lambda_p) + (\dot\theta_p^2 l_p m_p sin(\theta_p))/2 + (\alpha \dot\theta_h^2 l_h sin(\theta_h) (m_h + m_p))/2) \\
- \dot\theta_h (d_h \dot\theta_h + l_h cos(\theta_h) (m_h + m_p) (\dot\theta_h \lambda_h + \dot\theta_p \lambda_p))
$$

$$
\dot\theta_p (d_p \dot\theta_p + l_p m_p cos(\theta_p) (\dot\theta_h \lambda_h + \dot\theta_p \lambda_p) + (\alpha \dot\theta_h \dot\theta_p l_p m_p sin(\theta_p))/2) \\
- \dot\theta_h (d_h \dot\theta_h + l_h cos(\theta_h) (m_h + m_p) (\dot\theta_h \lambda_h + \dot\theta_p \lambda_p) + (\alpha \dot\theta_h^2 l_h sin(\theta_h) (m_h + m_p))/2)
 
$$

$$
- \dot\theta_h (d_h \dot\theta_h + l_h cos(\theta_h) (m_h + m_p) (\alpha \ddot\theta_h + \beta \ddot\theta_p) + l_h cos(\theta_h) (m_h + m_p) (\dot\theta_h \lambda_h + \dot\theta_p \lambda_p)) \\
- \dot\theta_p (d_p \dot\theta_p + l_p m_p cos(\theta_p) (\alpha \ddot\theta_h + \beta \ddot\theta_p) + l_p m_p cos(\theta_p) (\dot\theta_h \lambda_h + \dot\theta_p \lambda_p)) \\
- s (\alpha \ddot\theta_h + \beta \ddot\theta_p) (m_c + m_h + m_p)
$$


$$
\begin{align}
&- \dot\theta_h (d_h \dot\theta_h + l_h cos(\theta_h) (m_h + m_p) (\dot\theta_h \lambda_h + \dot\theta_p \lambda_p) + (\alpha \dot\theta_h^2 l_h sin(\theta_h) (m_h + m_p))/2 + (\alpha \dot\theta_h \dot\theta_p l_h sin(\theta_h) (m_h + m_p))/2) \\
&- \dot\theta_p (d_p \dot\theta_p + l_p m_p cos(\theta_p) (\dot\theta_h \lambda_h + \dot\theta_p \lambda_p) + (\alpha \dot\theta_h^2 l_h sin(\theta_h) (m_h + m_p))/2 + (\alpha \dot\theta_h \dot\theta_p l_h sin(\theta_h) (m_h + m_p))/2)\\
&= -d_h\dot\theta_h^2-d_p\dot\theta_p^2-(m_h+m_p)l_hcos(\theta_h)(\lambda_h\dot\theta_h^2+\lambda_p\dot\theta_p\dot\theta_h)\\
&\ \ \ \ -\frac{1}{2}(m_h+m_p)l_h\alpha sin\theta_h(\dot\theta_h^3+2\dot\theta_h^2\dot\theta_p+\dot\theta_h\dot\theta_p^2)\\
&\ \ \ \ -m_pl_pcos\theta_p(\lambda_h\dot\theta_h\dot\theta_p+\lambda_p\dot\theta_p^2)\\
& = -d_h\dot\theta_h^2-d_p\dot\theta_p^2-(m_h+m_p)l_h(cos(\theta_h)(\lambda_h\dot\theta_h^2+\lambda_p\dot\theta_p\dot\theta_h)
+\frac{1}{2}\alpha sin\theta_h(\dot\theta_h^3+2\dot\theta_h^2\dot\theta_p+\dot\theta_h\dot\theta_p^2))\\
&\ \ \ \ -m_pl_pcos\theta_p(\lambda_h\dot\theta_h\dot\theta_p+\lambda_p\dot\theta_p^2)\\
 
 \end{align}
$$

$$
\begin{align}
&- \dot\theta_h (d_h \dot\theta_h + l_h cos(\theta_h) (m_h + m_p) (\dot\theta_h \lambda_h + \dot\theta_p \lambda_p) + (\alpha \dot\theta_h^2 l_h sin(\theta_h) (m_h + m_p))/2 + (\beta \dot\theta_h \dot\theta_p l_h sin(\theta_h) (m_h + m_p))/2)\\
& - \dot\theta_p (d_p \dot\theta_p + l_p m_p cos(\theta_p) (\dot\theta_h \lambda_h + \dot\theta_p \lambda_p) + (\alpha \dot\theta_h^2 l_h sin(\theta_h) (m_h + m_p))/2 + (\beta \dot\theta_h \dot\theta_p l_h sin(\theta_h) (m_h + m_p))/2)\\
 & =-d_h\dot\theta_h^2-d_p\dot\theta_p^2-(m_h+m_p)l_hcos(\theta_h)(\lambda_h\dot\theta_h^2+\lambda_p\dot\theta_p\dot\theta_h)\\
&\ \ \ \ -\frac{1}{2}(m_h+m_p)l_hsin\theta_h(\alpha \dot\theta_h^3+(\alpha +\beta)\dot\theta_h^2\dot\theta_p+\beta\dot\theta_h\dot\theta_p^2)\\
&\ \ \ \ -m_pl_pcos\theta_p(\lambda_h\dot\theta_h\dot\theta_p+\lambda_p\dot\theta_p^2)\\
& = -d_h\dot\theta_h^2-d_p\dot\theta_p^2-m_pl_pcos\theta_p(\lambda_h\dot\theta_h\dot\theta_p+\lambda_p\dot\theta_p^2)
\\
&\ \ \ \ -(m_h+m_p)l_h(cos(\theta_h)(\lambda_h\dot\theta_h^2+\lambda_p\dot\theta_p\dot\theta_h)
+\frac{1}{2}sin\theta_h(\alpha \dot\theta_h^3+(\alpha +\beta)\dot\theta_h^2\dot\theta_p+\beta\dot\theta_h\dot\theta_p^2))\\

 \end{align}
$$

$$
\begin{align}
&- \dot\theta_h (d_h \dot\theta_h + l_h cos(\theta_h) (m_h + m_p) (\dot\theta_h \lambda_h + \dot\theta_p \lambda_p) + (\alpha \dot\theta_h^2 l_h sin(\theta_h) (m_h + m_p))/2 + (\beta \dot\theta_h \dot\theta_p l_h sin(\theta_h) (m_h + m_p))/2) \\
& - \dot\theta_p (d_p \dot\theta_p + l_p m_p cos(\theta_p) (\dot\theta_h \lambda_h + \dot\theta_p \lambda_p) + (\beta \dot\theta_p^2 l_p m_p sin(\theta_p))/2 + (\alpha \dot\theta_h \dot\theta_p l_p m_p sin(\theta_p))/2)\\
& =-d_h\dot\theta_h^2-d_p\dot\theta_p^2-(m_h+m_p)l_hcos(\theta_h)(\lambda_h\dot\theta_h^2+\lambda_p\dot\theta_p\dot\theta_h)\\
&\ \ \ \ -\frac{1}{2}(m_h+m_p)l_hsin\theta_h(\alpha \dot\theta_h^3 +\beta\dot\theta_h^2\dot\theta_p)-\frac{1}{2}m_pl_psin\theta_p(\beta\dot\theta_p^3+\alpha\dot\theta_h\dot\theta_p^2)\\
&\ \ \ \ -m_pl_pcos\theta_p(\lambda_h\dot\theta_h\dot\theta_p+\lambda_p\dot\theta_p^2)\\
& = 
 
 
 \end{align}
$$

$$
\begin{align}

&- \dot\theta_h(d_h\dot\theta_h + l_hcos(\theta_h)(m_h + m_p)(\dot\theta_h\lambda_h + \dot\theta_p\lambda_p) - (\alpha\dot\theta_h^2l_hsin(\theta_h)(m_h + m_p))/2 - (\beta\dot\theta_h\dot\theta_pl_hsin(\theta_h)(m_h + m_p))/2)\\
&- \dot\theta_p(d_p\dot\theta_p + l_pm_pcos(\theta_p)(\dot\theta_h\lambda_h + \dot\theta_p\lambda_p) - (\beta\dot\theta_p^2l_pm_psin(\theta_p))/2 - (\alpha\dot\theta_h\dot\theta_pl_pm_psin(\theta_p))/2)\\
&=
 \end{align}
$$



# 参考文献

<a name="ref1"><font color='black'>[1]</font></a>张梦华.欠驱动单级摆及二级摆型桥式吊车非线性控制策略研究[D].山东大学,2018.

