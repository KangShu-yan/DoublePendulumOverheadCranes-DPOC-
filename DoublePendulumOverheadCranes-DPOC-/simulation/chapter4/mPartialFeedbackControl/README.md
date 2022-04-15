# combined control 

## 方程

考虑初始约束的二级摆控制律为<sup><a href = "#ref1">[1]</a></sup>

对于二级摆动力学


$$
\left( m_c+m_h+m_p \right) \ddot{x}+\left( m_h+m_p \right) l_h\ddot{\theta}_h\cos \theta _h+m_pl_p\ddot{\theta}_p\cos \theta _p

\\ 

-\left( m_h+m_p \right) \dot{\theta}_{h}^{2}l_h\sin \theta _h-m_p\dot{\theta}_{p}^{2}l_p\sin \theta _p=F
$$

$$
\left( m_h+m_p \right) l_h\cos \theta _h\ddot{x}+\left( m_h+m_p \right) l_{h}^{2}\ddot{\theta}_h+m_pl_hl_p\cos \left( \theta _h-\theta _p \right) \ddot{\theta}_p\\

+d_h\dot \theta_h+m_pl_hl_p\dot{\theta}_{p}^{2}\sin \left( \theta _h-\theta _p \right) +\left( m_h+m_p \right) gl_h\sin \theta _h=0
$$
$$
m_pl_p\cos \theta _p\ddot{x}+m_pl_hl_p\cos \left( \theta _h-\theta _p \right) \ddot{\theta}_h+m_pl_{p}^{2}\ddot{\theta}_p
\\
-m_pl_hl_p\dot{\theta}_{h}^{2}\sin \left( \theta _h-\theta _p \right) +d_p\dot\theta_p+m_pgl_p\sin \theta _p=0
$$

对于（2）（3）式取$d_h= 0, d_p = 0$，$(2)*l_p$,$(3)*l_hcos(\theta_h-\theta_p)$可得
$$
\left( m_h+m_p \right) l_hl_p\cos \theta _h\ddot{x}+\left( m_h+m_p \right) l_{h}^{2}l_p\ddot{\theta}_h+m_pl_hl_p^2\cos \left( \theta _h-\theta _p \right)\ddot{\theta}_p \\ +m_pl_hl_p^2\dot{\theta}_{p}^{2}\sin \left( \theta _h-\theta _p \right) +\left( m_h+m_p \right) gl_hl_p\sin \theta _h=0
$$
$$
m_pl_hl_p\cos \theta _pcos(\theta_h-\theta_p)\ddot{x}+m_pl_h^2l_p\cos^2 \left( \theta _h-\theta _p \right) \ddot{\theta}_h+m_pl_hl_{p}^{2}cos(\theta_h-\theta_p)\ddot{\theta}_p
\\
-m_pl_h^2l_p\dot{\theta}_{h}^{2}\sin \left( \theta _h-\theta _p \right)cos(\theta_h-\theta_p) +m_pgl_hl_p\sin \theta _pcos(\theta_h-\theta_p)=0
$$

则(4)-(5)式有
$$
\ddot \theta_h=  \frac{m_pgcos(\theta_h-\theta_p)sin\theta_p-(m_h+m_p)gsin\theta_h-m_psin(\theta_h-\theta_p)(l_p\dot \theta_p^2+l_h\dot \theta_h^2cos(\theta_h-\theta_p))-[(m_h+m_p)cos\theta_h-m_pcos(\theta_h-\theta_p)cos\theta_p]\ddot x}{(m_h+m_p)l_h-m_pl_hcos^2(\theta_h-\theta_p)}
$$
针对（3）式有
$$
\ddot \theta_p = \frac{l_h\dot \theta_h^2sin(\theta_h-\theta_p)-gsin\theta_p-cos\theta_p\ddot x-l_hcos(\theta_h-\theta_p)\ddot \theta_h}{l_p}
$$
进一步，将（6）（7）式代入（1）可得
$$
[(m_c+m_h+m_p)-m_pcos^2\theta_p]\ddot x+[(m_h+m_p)l_hcos\theta_h-m_pl_hcos(\theta_h-\theta_p)cos\theta_p]\ddot \theta_h

\\
-(m_h+m_p)l_hsin\theta_h\dot\theta_h^2-
m_pl_psin\theta_p\dot \theta_p^2+m_pcos\theta_p(l_hsin(\theta_h-\theta_p)-gsin\theta_p)=F
$$
可得
$$
m(\theta_h,\theta_p)\ddot x+h(\theta_h,\theta_p,\dot \theta_h,\dot \theta_p)=F
$$
其中，
$$
\begin{align}
&m(\theta_h,\theta_p)= m_c+m_h+m_psin^2\theta_p+\\
&((m_h+m_p)l_hcos\theta_h-m_pl_hcos(\theta_h-\theta_p)cos\theta_p)^2/((m_h+m_p)l_h-m_pl_hcos^2(\theta_h-\theta_p))
\end{align}
$$

$$
\begin{align}


&h(\theta_h,\theta_p,\dot \theta_h,\dot \theta_p) = [m_pgcos(\theta_h-\theta_p)sin\theta_p-(m_h+m_p)gsin\theta_h-m_psin(\theta_h-\theta_p)(l_p\dot \theta_p^2\\
&+l_h\dot \theta_h^2)][(m_h+m_p)l_hcos\theta_h-m_pl_hcos(\theta_h-\theta_p)cos\theta_p]/((m_h+m_p)l_h-m_pl_hcos(\theta_h-\theta_p))\\
&-(m_h+m_p)l_hsin\theta_h\dot\theta_h^2-
m_pl_psin\theta_p\dot \theta_p^2
+m_pcos\theta_p(l_hsin(\theta_h-\theta_p)-gsin\theta_p)



\end{align}
$$

对于挂钩与负载的摆动有
$$
V_{\theta} = \frac{1}{2}(m_h+m_p)l_h^2\dot \theta_h^2+m_hgl_h(1-cos\theta_h)+\frac{1}{2}m_pl_p^2\dot \theta_p^2+m_pg(l_h(1-cos\theta_h)+l_p(1-cos(\theta_p)))
$$
对其求导，有
$$
\dot V_{\theta} =[-(m_h+m_p)^2l_h^2cos\theta_h\dot \theta_h+m_p(m_h+m_p)l_h^2cos(\theta_h-\theta_p)cos\theta_p\dot 
\theta_h\\
+m_p(m_h+m_p)l_hl_pcos(\theta_h-\theta_p)\dot \theta_p-
m_p^2l_hl_pcos^2(\theta_h-\theta_p)cos\theta_p\dot \theta_p]\ddot x
\\
+m_p(m_h+m_p)l_hl_psin(\theta_h-\theta_p)\dot \theta_p-m_p^2l_hl_pcos(\theta_h-\theta_p)sin(\theta_h-\theta_p)\dot \theta_p\\
-m_p(m_h+m_p)gl_h^2cos(\theta_h-\theta_p)sin\theta_h\dot \theta_h -m_p(m_h+m_p)l_h^3sin(\theta_h-\theta_p)cos(\theta_h-\theta_p)\dot \theta_h^2\\
-m_p(m_h+m_p)l_h^2l_psin(\theta_h-\theta_p)\dot \theta_h\dot \theta_p^2+m_p^2l_h^2l_psin(\theta_h-\theta_p)cos^2(\theta_h-\theta_p)\dot \theta_h^2\dot \theta_p\\
+m_p^2l_hl_p^2sin(\theta_h-\theta_p)cos(\theta_h-\theta_p)\dot \theta_p^3+m_p(m_h+m_p)gl_hl_pcos(\theta_h-\theta_p)sin\theta_h\dot \theta_p\\
+m_p(m_h+m_p)gl_h^2cos(\theta_h-\theta_p)sin\theta_p\dot\theta_h-m_p^2gl_hl_pcos^2(\theta_h-\theta_p)sin\theta_p\dot\theta_p
$$
考虑负载有
$$
V_\theta = \frac{1}{2}
$$
求$\ddot q$有
$$
\ddot q = M^{-1}(U-G-C\dot q)
$$
取


$$
D = M^{-1}
$$
## 新的想法

对于动力学（1）取$\theta = [\theta_h\ \  \theta_p]^T$有
$$
\begin{align}
&\left( m_c+m_h+m_p \right) \ddot{x}+M_{x\theta}\ddot\theta
 -\left( m_h+m_p \right) \dot{\theta}_{h}^{2}l_h\sin \theta _h-m_p\dot{\theta}_{p}^{2}l_p\sin \theta _p=F
\\
&M_x\ddot x +M_\theta\ddot\theta+C_\theta\dot \theta+G_\theta = 0 

\end{align}
$$
其中
$$
\begin{align}
& M_{x\theta} = \left[ \begin{matrix}
	\left( m_h+m_p \right) l_h\cos \theta _h&		m_pl_p\cos \theta _p\\
\end{matrix} \right] 
\\

 &M_x=\left[ \begin{array}{c}
	\left( m_h+m_p \right)l_hcos\theta_h\\
	m_pl_pcos\theta_p\\
\end{array} \right] ,\ \ M_{\theta}=\left[ \begin{matrix}
	\left( m_h+m_p \right)l^2_h&		m_pl_hl_pcos(\theta_h-\theta_p)\\
	m_pl_hl_pcos(\theta_h-\theta_p)&		m_pl^2_p\\
\end{matrix} \right] 
\\
&C_{\theta}=\left[ \begin{matrix}
	d_h&		m_pl_hl_psin(\theta_h-\theta_p)\dot \theta_p \\
	-m_pl_hl_psin(\theta_h-\theta_p)\dot \theta_h&		d_p\\
\end{matrix} \right] 
\\
& G_{\theta}=\left[ \begin{array}{c}
	(m_h+m_p)gl_hsin\theta_h\\
	m_pgl_psin\theta_p\\
\end{array} \right] 

\end{align}
$$
令$d_h = 0, \ \ d_p = 0;$有
$$
\frac{1}{2}\dot{M}_{\theta}-C_{\theta}=\left[ \begin{matrix}
	0&		-\frac{1}{2}m_pl_hl_psin(\theta_h-\theta_p)(\dot \theta_h+\dot \theta_p)\\
	\frac{1}{2}m_pl_hl_psin(\theta_h-\theta_p)(\dot \theta_h+\dot \theta_p)&		0\\
\end{matrix} \right]
$$
故满足
$$
\dot \theta^T(\frac{1}{2}\dot{M}_{\theta}-C_{\theta})\dot \theta = 0
$$
对于$M_\theta$,其逆为
$$
\begin{align}
&M^{-1}_\theta =1/D\left[ \begin{matrix}
	m_pl_p^2&		-m_pl_hl_pcos(\theta_h-\theta_p)\\
	-m_pl_hl_pcos(\theta_h-\theta_p)&		\left( m_h+m_p \right)l^2_h\\
\end{matrix} \right] 
\\
& D = - l_h^2 l_p^2 m_p^2 cos(\theta_h - \theta_p)^2 + l_h^2 l_p^2 m_p^2 + m_h l_h^2 l_p^2 m_p
\end{align}
$$
进一步
$$
\ddot \theta = M_\theta^{-1}(-G_\theta-C_\theta\dot \theta-M_x\ddot x)
$$


取关于负载与挂钩的能量函数，有
$$
\begin{align}
&V_1 = \frac{1}{2}\dot \theta^TM_\theta\dot \theta+m_pgl_p(1-cos\theta_p)+(m_h+m_p)gl_h(1-cos\theta_h)\\
&
+m_p(m_h+m_p)(l_hcos\theta_h\dot \theta_h+l_pcos\theta_p\dot \theta_p)^2 

\end{align}
$$
对其求导有
$$
\begin{align}
&\dot V_1 = \dot \theta^TM_\theta\ddot \theta+\frac{1}{2}\dot \theta^T\dot M_\theta\dot \theta+m_pgl_psin\theta_p\dot\theta_p+(m_h+m_p)gl_hsin\theta_h\dot \theta_h
\\
& = \dot \theta^T(M_\theta\ddot \theta+C_\theta\dot\theta)+\dot \theta^T(\frac{1}{2}\dot M_\theta-C_\theta)\dot \theta+m_pgl_psin\theta_p\dot\theta_p+(m_h+m_p)gl_hsin\theta_h\dot \theta_h\\
&  = \dot\theta^T(-G_\theta-M_x\ddot x)+m_pgl_psin\theta_p\dot\theta_p+(m_h+m_p)gl_hsin\theta_h\dot \theta_h \\
& = -\dot\theta^TM_x\ddot x
\end{align}
$$
构造虚拟的输入，有$\ddot x_v =  M_x^T\dot \theta$,即，
$$
\ddot x_v = (m_h+m_p)l_hcos\theta_h\dot\theta_h+m_pl_pcos\theta_p\dot\theta_p
$$
则有
$$
\dot x_v = (m_h+m_p)l_hsin\theta_h+m_pl_psin\theta_p
$$
进而有
$$
x_v = (m_h+m_p)l_h\int sin\theta_hdt+m_pl_p\int sin\theta_pdt
$$
取$\xi =x-x_d- \varLambda\int\int\dot \theta^TM_xdtdt $,这里$\varLambda \ =\ \left[ \begin{matrix}
	\lambda _h&		0\\
	0&		\lambda _p\\
\end{matrix} \right] $,
$$
\begin{align}
&V=\frac{1}{2}\dot \xi^T\dot \xi+\frac{1}{2}\dot \theta^T\varLambda M_\theta\dot \theta+m_pgl_p(1-cos\theta_p)+(m_h+m_p)gl_h(1-cos\theta_h)+\frac{1}{2}k_p(\xi-\int\dot \theta^T\varLambda M_x)^2
\\
&\dot V= \dot \xi^T\ddot \xi-\dot\theta^T\varLambda M_x\ddot x+(\xi-\int \dot \theta^T\varLambda M_xdt)(\dot \xi-\dot \theta^T\varLambda M_x)\\
& \ \ \  = \ddot \xi(\dot \xi-\dot \theta^T\varLambda M_x)-\dot\theta^T\varLambda M_x\dot\theta^T\varLambda M_x+k_p(\xi-\int \dot \theta^T\varLambda M_xdt)(\dot \xi-\dot \theta^T\varLambda M_x) \\
& \ \ \ = (\dot \xi-\dot \theta^T\varLambda M_x)(\ddot \xi+k_p(\xi-\varLambda \int \dot \theta^TM_xdt))-\dot\theta^T \varLambda M_x\dot\theta^T\varLambda M_x

\end{align}
$$
取
$$
\ddot \xi = -k_p(\xi-\int \dot \theta^T\varLambda M_xdt)-k_d(\dot \xi-\dot\theta^T\varLambda M_x)
$$
进而得到
$$
\ddot x = \ddot \xi +\dot\theta^T\varLambda M_x
$$
又由动力学方程有
$$
\begin{align}
&\left( m_c+m_h+m_p \right) \ddot{x}-M_{x\theta}M_\theta^{-1}(G_\theta+C_\theta\dot \theta+M_x\ddot x)
\\ 
& \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ -\left( m_h+m_p \right) \dot{\theta}_{h}^{2}l_h\sin \theta _h-m_p\dot{\theta}_{p}^{2}l_p\sin \theta _p=F

\end{align}
$$
整理之有
$$
(m_c+m_h+m_p-M_{x\theta}M_\theta^{-1}M_x)\ddot x+h(\theta_h,\theta_p,\dot\theta_h,\dot\theta_p) = F
$$


其中
$$
\begin{align}
& h(\theta_h,\theta_p,\dot\theta_h,\dot\theta_p) = -M_{x\theta}M_\theta^{-1}(G_\theta+C_\theta\dot \theta)-\left( m_h+m_p \right) \dot{\theta}_{h}^{2}l_h\sin \theta _h-m_p\dot{\theta}_{p}^{2}l_p\sin \theta _p
\end{align}
$$
最终得控制律
$$
\begin{align}
u = F+F_{rx}

\end{align}
$$


## 公式推导代码

```matlab
syms m_aa m_au m_ua m_uu  c_aa c_au c_ua c_uu g_a g_u u_a u
M = [m_aa m_au;m_ua m_uu];
inv(M);

m_aa = m_c+m_h+m_p
m_au = [(m_h+m_p) l_h cos(theta_h) m_p*l_p*cos(theta_p)]
m_ua = [(m_h+m_p)*l_h*cos(theta_h);m_p*l_p*cos(theta_p)];
m_uu = [(m_h+m_p)*l_h^2 m_p*l_h*l_p*cos(theta_h-theta_p);m_p*l_h*l_p*cos(theta_h-theta_p) m_p*l_p^2]
c_aa = 0;c_au  = [-(m_h+m_p)*l_h*sin(theta_h)*dottheta_h 0]
c_ua = [0;0]
c_uu = [0 m_p*l_h*l_p*sin(theta_h-theta_p)*dottheta_p;-m_p*l_h*l_p*sin(theta_h-theta_p)*dottheta_h 0]
g_a = 0;g_u = [(m_h+m_p)*g*l_h*sin(theta_h);m_p*g*l_p*sin(theta_p)]
syms M 
M = [m_c+m_h+m_p (m_h+m_p)*l_h*cos(theta_h) m_p*l_p*cos(theta_p);(m_h+m_p)*l_h*cos(theta_h) (m_h+m_p)*l_h^2 m_p*l_h*l_p*cos(theta_h-theta_p);m_p*l_p*cos(theta_p) m_p*l_h*l_p*cos(theta_h-theta_p) m_p*l_h^2]


syms H_11 H_12 H_13 H_21 H_22 H_23 H_31 H_32 H_33 g_2 g_3 c_12 c_13 c_23

H = [H_11 H_12 H_13; H_12 H_22 H_23; H_13 H_23 H_33]
U = [u;0;0]
G = [0;g_2;g_3]
C = [0 c_12 c_13;0 0 c_23 ;0 -c_23 0]
 dq=[dotx ;dottheta_h;dottheta_p]
 
 
 A = m_p*g*cos(theta_h-theta_p)*sin(theta_p)-(m_h+m_p)*g*sin(theta_h)-m_p*sin(theta_h-theta_p)*(l_p*dottheta_p^2+l_h*dottheta_h^2*cos(theta_h-theta_p))-((m_h+m_p)*cos(theta_h)-m_p*cos(theta_h-theta_p)*cos(theta_p))*ddotx
 
 A*((m_h+m_p)*l_h^2*dottheta_h-l_h*dottheta_p*cos(theta_h-theta_p))/((m_h+m_p)*l_h-m_p*l_h*cos(theta_h-theta_p)^2)
 
 syms m_h m_p m_c l_h l_p theta_h theta_p dottheta_h dottheta_p 
 M_theta = [(m_h+m_p)*l_h^2 m_p*l_h*l_p*cos(theta_h-theta_p); m_p*l_h*l_p*cos(theta_h-theta_p) m_p*l_p^2];
 
 invM_theta = inv(M_theta);
 
 
 
 
```

## 实验结果

表 4.2实验量化结果

Table 4.2 The first set of simulation experiments: Quantitative experimental results

| 控制方法   | $t_s$ | $x_f$ | $|\theta_h|_{max}$ | $|\theta_p|_{max}$ |      |      |      |       |      |
| ---------- | ----- | ----- | ------------------ | ------------------ | ---- | ---- | ---- | ----- | ---- |
| 本方法调节 | 4.87  | 1.00  | 2.33               | 2.57               | 0.37 | 0.49 | 1.49 | 5.49  |      |
| HSMC  调节 | 14.83 | 0.99  | 1.77               | 2.22               | 0.06 | 0.07 | 1.31 | 12.76 |      |
| 鲁棒实验   | 19.91 | 1.05  | 3.65               | 4.92               | 0.05 | 0.05 | 2.58 | 9.19  |      |
| 跟踪控制   | 2.67  | 0.98  | 5.46               | 7.505              | 4.09 | 4.79 | 4.88 | 8.43  |      |

本方法调节控制：

202203272131Tracking.csv

release20220327105435  release20220320101743

HSMC调节

鲁棒实验

# 参考文献

<a name="ref1"><font color='black'>[1]</font></a>张梦华.欠驱动单级摆及二级摆型桥式吊车非线性控制策略研究[D].山东大学,2018.

