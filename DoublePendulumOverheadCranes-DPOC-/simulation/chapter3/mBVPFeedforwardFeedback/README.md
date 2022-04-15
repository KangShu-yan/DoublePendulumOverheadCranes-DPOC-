Feedforward and Feedback

考虑二级摆模型
$$
\begin{align}
&\left( m_c+m_h+m_p \right) \ddot{x}+\left( m_h+m_p \right) l_h\ddot{\theta}_h\cos \theta _h+m_pl_p\ddot{\theta}_p\cos \theta _p

\\ 

& \ \  \ \  \ \  \ \ \  \ \  \ \  \ \ \  \ \  \ \  \ -\left( m_h+m_p \right) \dot{\theta}_{h}^{2}l_h\sin \theta _h-m_p\dot{\theta}_{p}^{2}l_p\sin \theta _p=F\\


&\left( m_h+m_p \right) l_h\cos \theta _h\ddot{x}+\left( m_h+m_p \right) l_{h}^{2}\ddot{\theta}_h+m_pl_hl_p\cos \left( \theta _h-\theta _p \right) \ddot{\theta}_p\\

&\ \  \ \  \ \  \ \ \  \ \  \ \  \ \ \ \ \  \ \ \ +d_h\dot \theta_h+m_pl_hl_p\dot{\theta}_{p}^{2}\sin \left( \theta _h-\theta _p \right) +\left( m_h+m_p \right) gl_h\sin \theta _h=0\\

&m_pl_p\cos \theta _p\ddot{x}+m_pl_hl_p\cos \left( \theta _h-\theta _p \right) \ddot{\theta}_h+m_pl_{p}^{2}\ddot{\theta}_p
\\
&\ \  \ \  \ \  \ \ \  \ \  \ \  \ \ \ \ \  \ \ \ -m_pl_hl_p\dot{\theta}_{h}^{2}\sin \left( \theta _h-\theta _p \right) +d_p\dot\theta_p+m_pgl_p\sin \theta _p=0
\end{align}
$$

## 物理参数迭代学习

对于
$$
y=f(x_r,p)
$$
$y_r$是实际测量值，$y_i$是计算值，定义
$$
e_i = y_r-y_i
$$
通过迭代学习找出合适的参数$p*$,
$$
p_{i+1} =p_i+\varGamma e_i
$$
其中$\varGamma$是学习增益，
$$
\begin{align}
&\varGamma_i = (F_{pi}^TF_{pi})^{-1}F_{pi}^T\\
&F_{pi}= \frac{\partial f}{\partial p_i}
\end{align}
$$

由二级摆模型，当
$$
F=0,\ x = 0,\ \dot x = 0,\ \ddot x = 0
$$
动力学方程为
$$
\begin{align}
& \left( m_h+m_p \right) l_h\cos \theta _h\ddot{\theta}_h+m_pl_p\cos \theta _p\ddot{\theta}_p -\left( m_h+m_p \right) l_h\sin \theta _h\dot{\theta}_{h}^{2}-m_pl_p\sin \theta _p\dot{\theta}_{p}^{2}=0\\

&\left( m_h+m_p \right) l_{h}^{2}\ddot{\theta}_h+m_pl_hl_p\cos \left( \theta _h-\theta _p \right) \ddot{\theta}_p
+d_h\dot \theta_h+m_pl_hl_p\sin \left( \theta _h-\theta _p \right)\dot{\theta}_{p}^{2} \\ &\ \  \ \  \ \  \ \ \  \ \  \ \  \ \ \ \ \  \ \  \ \  \ \  \ \ \  \ \  \ \  \ \ \ \ \ \ \  \ \  \ \  \ \ \  \ \  \ \  \ \ \ \ \ \ \  \ \  \ \  \ \ \  \ \  \ \  \ \ \ \ \ \ \  \ \  \ \  \ \ \  \ \  \ \  \ \ \ \ \  \ \ +\left( m_h+m_p \right) gl_h\sin \theta _h=0\\

&m_pl_hl_p\cos \left( \theta _h-\theta _p \right) \ddot{\theta}_h+m_pl_{p}^{2}\ddot{\theta}_p
 -m_pl_hl_p\sin \left( \theta _h-\theta _p \right)\dot{\theta}_{h}^{2} +d_p\dot\theta_p+m_pgl_p\sin \theta _p=0

\end{align}
$$
考虑参数辨识，则未知参数有$p = (m_p,\ l_h,\ l_p,\ d_h ,\ d_p )$​,   
$$
\begin{align}
&\ddot \theta=M^{-1}_\theta(-C_\theta\dot \theta-G_\theta+B_\theta v)
\\
& \ \ = M^{-1}_\theta(-C_\theta\dot\theta-G_\theta)=F_p
\end{align}
$$
得到
$$
\begin{align}
& \ddot\theta_h = \frac{(cos(\theta_h - \theta_p)(d_p\theta_p + gl_pm_psin(\theta_p) - \dot\theta_hl_hl_pm_p\theta_hsin(\theta_h - \theta_p)))}{(- l_hl_pm_pcos(\theta_h - \theta_p)^2 + l_hl_pm_h + l_hl_pm_p)} \\
&\ \ \ \ \ \ \ \ - \frac{(d_h\theta_h + gl_hsin(\theta_h)(m_h + m_p) + \dot\theta_pl_hl_pm_p\theta_psin(\theta_h - \theta_p))}{(l_h^2m_h + l_h^2m_p - l_h^2m_pcos(\theta_h - \theta_p)^2)}
\\
& \ddot\theta_p = \frac{(cos(\theta_h - \theta_p)(d_h\theta_h + gl_hsin(\theta_h)(m_h + m_p) + \dot\theta_pl_hl_pm_p\theta_psin(\theta_h - \theta_p)))}{(- l_hl_pm_pcos(\theta_h - \theta_p)^2 + l_hl_pm_h + l_hl_pm_p)} \\
&\ \ \ \ \ \ \ \ - \frac{((m_h + m_p)(d_p\theta_p + gl_pm_psin(\theta_p) - \dot\theta_hl_hl_pm_p\theta_hsin(\theta_h - \theta_p)))}{(- l_p^2m_p^2cos(\theta_h - \theta_p)^2 + l_p^2m_p^2 + m_hl_p^2m_p)}
\end{align}
$$
考虑$F_p$关于$p$的导数有
$$
\begin{align}
\frac{\partial F_p}{\partial p} = \left[ \begin{matrix}
	\frac{\partial F^1_{p}}{\partial p_1}&		\frac{\partial F^1_{p}}{\partial p_2}&		\frac{\partial F^1_{p}}{\partial p_3}&		\frac{\partial F^1_{p}}{\partial p_4}&		\frac{\partial F^1_{p}}{\partial p_5}\\
	\frac{\partial F^2_{p}}{\partial p_1}&		\frac{\partial F^2_{p}}{\partial p_2}&		\frac{\partial F^2_{p}}{\partial p_3}&		\frac{\partial F^2_{p}}{\partial p_4}&		\frac{\partial F^2_{p}}{\partial p_5}	\\
\end{matrix} \right] 

\end{align}
$$
其中
$$
\begin{align}
 
&\frac{\partial F^1_{p}}{\partial p_1} =
 
\frac{(cos(\theta_h - \theta_p)(gl_psin(\theta_p) - \dot\theta_hl_hl_p\theta_hsin(\theta_h - \theta_p)))}{(- l_hl_pm_pcos(\theta_h - \theta_p)^2 + l_hl_pm_h + l_hl_pm_p) }
\\&
- \frac{(gl_hsin(\theta_h) + \dot\theta_pl_hl_p\theta_psin(\theta_h - \theta_p))}{(l_h^2m_h + l_h^2m_p - l_h^2m_pcos(\theta_h - \theta_p)^2) }
\\&
- \frac{((l_h^2cos(\theta_h - \theta_p)^2 - l_h^2)(d_h\theta_h + gl_hsin(\theta_h)(m_h + m_p) + \dot\theta_pl_hl_pm_p\theta_psin(\theta_h - \theta_p)))}{(l_h^2m_h + l_h^2m_p - l_h^2m_pcos(\theta_h - \theta_p)^2)^2}
\\&
- \frac{(cos(\theta_h - \theta_p)(l_hl_p - l_hl_pcos(\theta_h - \theta_p)^2)(d_p\theta_p + gl_pm_psin(\theta_p) - \dot\theta_hl_hl_pm_p\theta_hsin(\theta_h - \theta_p)))}{(- l_hl_pm_pcos(\theta_h - \theta_p)^2 + l_hl_pm_h + l_hl_pm_p)^2}
 
 \\
 &\frac{\partial F^1_{p}}{\partial p_2} =  
\frac{((2l_hm_h + 2l_hm_p - 2l_hm_pcos(\theta_h - \theta_p)^2)(d_h\theta_h + gl_hsin(\theta_h)(m_h + m_p) + \dot\theta_pl_hl_pm_p\theta_psin(\theta_h - \theta_p)))}{(l_h^2m_h + l_h^2m_p - l_h^2m_pcos(\theta_h - \theta_p)^2)^2 }
\\&
-\frac{ (gsin(\theta_h)(m_h + m_p) + \dot\theta_pl_pm_p\theta_psin(\theta_h - \theta_p))}{(l_h^2m_h + l_h^2m_p - l_h^2m_pcos(\theta_h - \theta_p)^2) }
\\&
- \frac{(cos(\theta_h - \theta_p)(- l_pm_pcos(\theta_h - \theta_p)^2 + l_pm_h + l_pm_p)(d_p\theta_p + gl_pm_psin(\theta_p) - \dot\theta_hl_hl_pm_p\theta_hsin(\theta_h - \theta_p)))}{(- l_hl_pm_pcos(\theta_h - \theta_p)^2 + l_hl_pm_h + l_hl_pm_p)^2 }
\\&
- \frac{(\dot\theta_hl_pm_p\theta_hcos(\theta_h - \theta_p)sin(\theta_h - \theta_p))}{(- l_hl_pm_pcos(\theta_h - \theta_p)^2 + l_hl_pm_h + l_hl_pm_p)}
 
\\
 
&\frac{\partial F^1_{p}}{\partial p_3} =\frac{(cos(\theta_h - \theta_p)(gm_psin(\theta_p) - \dot\theta_hl_hm_p\theta_hsin(\theta_h - \theta_p)))}{(- l_hl_pm_pcos(\theta_h - \theta_p)^2 + l_hl_pm_h + l_hl_pm_p)}
\\&
- \frac{(cos(\theta_h - \theta_p)(- l_hm_pcos(\theta_h - \theta_p)^2 + l_hm_h + l_hm_p)(d_p\theta_p + gl_pm_psin(\theta_p) - \dot\theta_hl_hl_pm_p\theta_hsin(\theta_h - \theta_p)))}{(- l_hl_pm_pcos(\theta_h - \theta_p)^2 + l_hl_pm_h + l_hl_pm_p)^2 }
\\& 
- \frac{(\dot\theta_pl_hm_p\theta_psin(\theta_h - \theta_p))}{(l_h^2m_h + l_h^2m_p - l_h^2m_pcos(\theta_h - \theta_p)^2)}
 \\
&\frac{\partial F^1_{p}}{\partial p_4} = -\frac{\theta_h}{(l_h^2m_h + l_h^2m_p - l_h^2m_pcos(\theta_h - \theta_p)^2)}
\\
& \frac{\partial F^1_{p}}{\partial p_5}=\frac{(\theta_pcos(\theta_h - \theta_p))}{(- l_hl_pm_pcos(\theta_h - \theta_p)^2 + l_hl_pm_h + l_hl_pm_p)}
\\
&
\frac{\partial F^2_{p}}{\partial p_1} =
 
\frac{(cos(\theta_h - \theta_p)(gl_hsin(\theta_h) + \dot\theta_pl_hl_p\theta_psin(\theta_h - \theta_p)))}{(- l_hl_pm_pcos(\theta_h - \theta_p)^2 + l_hl_pm_h + l_hl_pm_p) }
\\&
- \frac{(d_p\theta_p + gl_pm_psin(\theta_p) - \dot\theta_hl_hl_pm_p\theta_hsin(\theta_h - \theta_p))}{(- l_p^2m_p^2cos(\theta_h - \theta_p)^2 + l_p^2m_p^2 + m_hl_p^2m_p)} 
\\& 
-\frac{ ((m_h + m_p)(gl_psin(\theta_p) - \dot\theta_hl_hl_p\theta_hsin(\theta_h - \theta_p)))}{(- l_p^2m_p^2cos(\theta_h - \theta_p)^2 + l_p^2m_p^2 + m_hl_p^2m_p) }
\\&
+ \frac{((m_h + m_p)(l_p^2m_h + 2l_p^2m_p - 2l_p^2m_pcos(\theta_h - \theta_p)^2)(d_p\theta_p + gl_pm_psin(\theta_p) - \dot\theta_hl_hl_pm_p\theta_hsin(\theta_h - \theta_p)))}{(- l_p^2m_p^2cos(\theta_h - \theta_p)^2 + l_p^2m_p^2 + m_hl_p^2m_p)^2}
\\&
-\frac{ (cos(\theta_h - \theta_p)(l_hl_p - l_hl_pcos(\theta_h - \theta_p)^2)(d_h\theta_h + gl_hsin(\theta_h)(m_h + m_p) + \dot\theta_pl_hl_pm_p\theta_psin(\theta_h - \theta_p)))}{(- l_hl_pm_pcos(\theta_h - \theta_p)^2 + l_hl_pm_h + l_hl_pm_p)^2}
 
\\
&\frac{\partial F^2_{p}}{\partial p_2} = 
 
\frac{(cos(\theta_h - \theta_p)(gsin(\theta_h)(m_h + m_p) + \dot\theta_pl_pm_p\theta_psin(\theta_h - \theta_p)))}{(- l_hl_pm_pcos(\theta_h - \theta_p)^2 + l_hl_pm_h + l_hl_pm_p)}
\\&
- \frac{(cos(\theta_h - \theta_p)(- l_pm_pcos(\theta_h - \theta_p)^2 + l_pm_h + l_pm_p)(d_h\theta_h + gl_hsin(\theta_h)(m_h + m_p) + \dot\theta_pl_hl_pm_p\theta_psin(\theta_h - \theta_p)))}{(- l_hl_pm_pcos(\theta_h - \theta_p)^2 + l_hl_pm_h + l_hl_pm_p)^2}
\\&
+\frac{ (\dot\theta_hl_pm_p\theta_hsin(\theta_h - \theta_p)(m_h + m_p))}{(- l_p^2m_p^2cos(\theta_h - \theta_p)^2 + l_p^2m_p^2 + m_hl_p^2m_p)}
 
\\& 
\frac{\partial F^2_{p}}{\partial p_3} =  
 
\frac{((m_h + m_p)(2l_pm_p^2 - 2l_pm_p^2cos(\theta_h - \theta_p)^2 + 2l_pm_hm_p)(d_p\theta_p + gl_pm_psin(\theta_p) - \dot\theta_hl_hl_pm_p\theta_hsin(\theta_h - \theta_p)))}{(- l_p^2m_p^2cos(\theta_h - \theta_p)^2 + l_p^2m_p^2 + m_hl_p^2m_p)^2 }
\\& 
-\frac{ ((m_h + m_p)(gm_psin(\theta_p) - \dot\theta_hl_hm_p\theta_hsin(\theta_h - \theta_p)))}{(- l_p^2m_p^2cos(\theta_h - \theta_p)^2 + l_p^2m_p^2 + m_hl_p^2m_p)} 
\\&
- \frac{(cos(\theta_h - \theta_p)(- l_hm_pcos(\theta_h - \theta_p)^2 + l_hm_h + l_hm_p)(d_h\theta_h + gl_hsin(\theta_h)(m_h + m_p) + \dot\theta_pl_hl_pm_p\theta_psin(\theta_h - \theta_p)))}{(- l_hl_pm_pcos(\theta_h - \theta_p)^2 + l_hl_pm_h + l_hl_pm_p)^2 }
\\& 
+ \frac{(\dot\theta_pl_hm_p\theta_pcos(\theta_h - \theta_p)sin(\theta_h - \theta_p))}{(- l_hl_pm_pcos(\theta_h - \theta_p)^2 + l_hl_pm_h + l_hl_pm_p)}
 

 
 \\&
 \frac{\partial F^2_{p}}{\partial p_4} = \frac{(\theta_hcos(\theta_h - \theta_p))}{(- l_hl_pm_pcos(\theta_h - \theta_p)^2 + l_hl_pm_h + l_hl_pm_p)}

 
 \\&
 \frac{\partial F^2_{p}}{\partial p_5} = -\frac{(\theta_p(m_h + m_p))}{(- l_p^2m_p^2cos(\theta_h - \theta_p)^2 + l_p^2m_p^2 + m_hl_p^2m_p)}



\end{align}
$$


## bvp 轨迹规划

bvp5c是一个有限差分代码，此代码实现4阶段Lobatto IIIa公式，



由二级摆模型，考虑前馈控制$u=\ddot x$,有
$$
\begin{align}

& \ddot x = u\\


&\left( m_h+m_p \right) l_h\cos \theta _hu+\left( m_h+m_p \right) l_{h}^{2}\ddot{\theta}_h+m_pl_hl_p\cos \left( \theta _h-\theta _p \right) \ddot{\theta}_p\\

&\ \  \ \  \ \  \ \ \  \ \  \ \  \ \ \ \ \  \ \ \ +d_h\dot \theta_h+m_pl_hl_p\dot{\theta}_{p}^{2}\sin \left( \theta _h-\theta _p \right) +\left( m_h+m_p \right) gl_h\sin \theta _h=0\\

&m_pl_p\cos \theta _pu+m_pl_hl_p\cos \left( \theta _h-\theta _p \right) \ddot{\theta}_h+m_pl_{p}^{2}\ddot{\theta}_p
\\
&\ \  \ \  \ \  \ \ \  \ \  \ \  \ \ \ \ \  \ \ \ -m_pl_hl_p\dot{\theta}_{h}^{2}\sin \left( \theta _h-\theta _p \right) +d_p\dot\theta_p+m_pgl_p\sin \theta _p=0

\end{align}
$$
由（12）~（16）可以得到
$$
\begin{align}
&\ddot x = u\\
&M_\theta\ddot \theta+C_\theta\dot \theta+G_\theta(\theta)=B_\theta v
\end{align}
$$
其中
$$
\begin{align}
&M_{\theta}=\left[ \begin{matrix}
	\left( m_h+m_p \right)l_h^2&		m_pl_hl_pcos(\theta_h-\theta_p)\\
	m_pl_hl_pcos(\theta_h-\theta_p)&		m_pl_p^2\\
\end{matrix} \right] 
\\

&C_\theta = \left[ \begin{matrix}
	d_h&		m_pl_hl_psin(\theta_h-\theta_p)\dot \theta_p\\
	-m_pl_hl_psin(\theta_h-\theta_p)\dot \theta_h&		d_p\\
\end{matrix} \right] 
\\
&G_\theta = \left[ \begin{array}{c}
	\left( m_h+m_p \right)gl_hsin\theta_h\\
	m_pgl_psin\theta_p\\
\end{array} \right] 
\\

&B_\theta = \left[ \begin{array}{c}
	-\left( m_h+m_p \right)l_hcos\theta_h\\
	-m_pl_pcos\theta_p\\
\end{array} \right] 

\end{align}
$$
由（19）,可得
$$
\begin{align}
&M^{-1}_\theta =1/D\left[ \begin{matrix}
	m_pl_p^2&		-m_pl_hl_pcos(\theta_h-\theta_p)\\
	-m_pl_hl_pcos(\theta_h-\theta_p)&		(m_h+m_p)l_h^2\\
\end{matrix} \right] \\
&D = l_h^2l_p^2m_p^2+l_h^2l_p^2m_hm_p-l_h^2l_p^2m_p^2cos^2(\theta_h-\theta_p)

\end{align}
$$
进一步有
$$
\begin{align}
&\ddot x = v\\
&\ddot \theta=M^{-1}_\theta(-C_\theta\dot \theta-G_\theta+B_\theta v)
\\
& \ \ = M^{-1}_\theta(-C_\theta\dot\theta-G_\theta)+M^{-1}_\theta B_\theta v
\\
& \ \ = \left[ \begin{array}{c}
	f_1\\
	f_2\\
\end{array} \right] +\left[ \begin{array}{c}
	b_1\\
	b_2\\
\end{array} \right]v 
\\
& \ \ = f+bv
\end{align}
$$
其中
$$
\begin{align}
& f_1=\frac{l_p cos(\theta_h - \theta_p) (d_p \theta_p  + g l_p m_p sin(\theta_p) - \dot\theta_h l_h l_p m_p \theta_h sin(\theta_h - \theta_p))}{l_h^3 m_h + l_h^3 m_p - l_h l_p^2 m_p cos(\theta_h - \theta_p)^2}\\
&\ \ \ \ \ \ \ \ -\frac{ d_h \theta_h  + g l_h sin(\theta_h) (m_h + m_p) + \dot\theta_p l_h l_p m_p \theta_p sin(\theta_h - \theta_p)}{l_h^2 m_h + l_h^2 m_p - l_p^2 m_p cos(\theta_h - \theta_p)^2}
\\&
=\frac{(cos(\theta_h - \theta_p)(- l_hl_pm_psin(\theta_h - \theta_p)\dot\theta_h^2 + d_p\dot\theta_p + gl_pm_psin(\theta_p)))}{(- l_hl_pm_pcos(\theta_h - \theta_p)^2 + l_hl_pm_h + l_hl_pm_p)} 
\\& - \frac{(l_hl_pm_psin(\theta_h - \theta_p)\dot\theta_p^2 + d_h\dot\theta_h + gl_hsin(\theta_h)(m_h + m_p))}{(l_h^2m_h + l_h^2m_p - l_h^2m_pcos(\theta_h - \theta_p)^2)}


\\
&f_2 = \frac{l_p cos(\theta_h - \theta_p) (d_h \theta_h + g l_h sin(\theta_h) (m_h + m_p) + \dot\theta_p l_h l_p m_p \theta_p sin(\theta_h - \theta_p))}{l_h^3 m_h + l_h^3 m_p - l_h l_p^2 m_p cos(\theta_h - \theta_p)^2} 
\\
&\ \ \ \ \ \ \ \ - \frac{(m_h + m_p) (d_p \theta_p  + g l_p m_p sin(\theta_p) - \dot\theta_h l_h l_p m_p \theta_h sin(\theta_h - \theta_p))}{l_h^2 m_p^2 + m_h l_h^2 m_p - l_p^2 m_p^2 cos(\theta_h - \theta_p)^2}
\\&=\frac{cos(\theta_h - \theta_p)(l_hl_pm_psin(\theta_h - \theta_p)\dot\theta_p^2 + d_h\dot\theta_h + gl_hm_hsin(\theta_h) + gl_hm_psin(\theta_h))}{l_hl_p(- m_pcos(\theta_h - \theta_p)^2 + m_h + m_p)} 
\\&
- \frac{(m_h + m_p)(- l_hl_pm_psin(\theta_h - \theta_p)\dot\theta_h^2 + d_p\dot\theta_p + gl_pm_psin(\theta_p))}{l_p^2m_p(- m_pcos(\theta_h - \theta_p)^2 + m_h + m_p)}

\\
& b_1 = \frac{l^2_p cos(\theta_h - \theta_p) m_p  cos(\theta_p) }{l_h^3 m_h + l_h^3 m_p - l_h l_p^2 m_p cos(\theta_h - \theta_p)^2} -\frac{  l_h  cos(\theta_h) (m_h + m_p) }{l_h^2 m_h + l_h^2 m_p - l_p^2 m_p cos(\theta_h - \theta_p)^2}
 \\&=-\frac{2m_hcos(\theta_h) + m_pcos(\theta_h) - m_pcos(\theta_h - 2\theta_p)}{l_h(2m_h + m_p - m_pcos(2\theta_h - 2\theta_p))} 
\\
& b_2 = \frac{l_hl_p cos(\theta_h - \theta_p)   cos(\theta_h) (m_h + m_p) }{l_h^3 m_h + l_h^3 m_p - l_h l_p^2 m_p cos(\theta_h - \theta_p)^2} 
- \frac{(m_h + m_p)  l_p m_p  cos(\theta_p) }{l_h^2 m_p^2 + m_h l_h^2 m_p - l_p^2 m_p^2 cos(\theta_h - \theta_p)^2}
\\& = \frac{(cos(2\theta_h - \theta_p) - cos(\theta_p))(m_h + m_p)}{l_p(2m_h + m_p - m_pcos(2\theta_h - 2\theta_p))}





\end{align}
$$

可以得到状态方程 
$$
\begin{align}
& \dot x_1 = x_2\\
& \dot x_2 = v \\
& \dot x_3 = x_4\\
& \dot x_4 = f_1+b_1v\\
& \dot x_5 = x_6 \\
& \dot x_6 = f_2+b_2v\\


\end{align}
$$
即$\dot \chi = f(t,\chi)$,其雅克比矩阵为
$$
A =\left[ \begin{matrix}
	0&		1&		0&		0&		0&		0\\
	0&		0&		0&		0&		0&		0\\
	0&		0&		0&		1&		0&		0\\
	0&		0&		A_1&		A_2&		A_3&		A_4\\
	0&		0&		0&		0&		0&		1\\
	0&		0&		A_5&		A_6&		A_7&		A_8\\
\end{matrix} \right]|_{(x_r,u_r)}
$$
其中
$$
\begin{align}
& A_1 = \frac{(2 l_p^2 m_p cos(\theta_h  - \theta_p) sin(\theta_h  - \theta_p) (d_h \theta_h  + l_h u cos(\theta_h ) (m_h + m_p) + g l_h sin(\theta_h ) (m_h + m_p) )}{(l_h^2 m_h + l_h^2 m_p - l_p^2 m_p cos(\theta_h  - \theta_p)^2)^2 }
\\
&+\frac{2 l_p^2 m_p cos(\theta_h  - \theta_p) sin(\theta_h  - \theta_p)( \dot\theta_p l_h l_p m_p \theta_p sin(\theta_h  - \theta_p))}{(l_h^2 m_h + l_h^2 m_p - l_p^2 m_p cos(\theta_h  - \theta_p)^2)^2 }
\\
&- \frac{(l_p cos(\theta_h  - \theta_p) (\dot\theta_h  l_h l_p m_p sin(\theta_h  - \theta_p) + \dot\theta_h  l_h l_p m_p \theta_h  cos(\theta_h  - \theta_p)))}{(l_h^3 m_h + l_h^3 m_p - l_h l_p^2 m_p cos(\theta_h  - \theta_p)^2) }
 \\
&- \frac{(l_p sin(\theta_h  - \theta_p) (d_p \theta_p + l_p m_p u cos(\theta_p) + g l_p m_p sin(\theta_p) - \dot\theta_h  l_h l_p m_p \theta_h  sin(\theta_h  - \theta_p)))}{(l_h^3 m_h + l_h^3 m_p - l_h l_p^2 m_p cos(\theta_h  - \theta_p)^2)} 
\\
&- \frac{(d_h + g l_h cos(\theta_h ) (m_h + m_p) - l_h u sin(\theta_h ) (m_h + m_p) + \dot\theta_p l_h l_p m_p \theta_p cos(\theta_h  - \theta_p))}{(l_h^2 m_h + l_h^2 m_p - l_p^2 m_p cos(\theta_h  - \theta_p)^2) }
\\
&- \frac{(2 l_h l_p^3 m_p cos(\theta_h  - \theta_p)^2 sin(\theta_h  - \theta_p) (d_p \theta_p + l_p m_p u cos(\theta_p) + g l_p m_p sin(\theta_p) ))}{(l_h^3 m_h + l_h^3 m_p - l_h l_p^2 m_p cos(\theta_h  - \theta_p)^2)^2}
\\
&+ \frac{ 2 l_h l_p^3 m_p cos(\theta_h  - \theta_p)^2 sin(\theta_h  - \theta_p) \dot\theta_h  l_h l_p m_p \theta_h  sin(\theta_h  - \theta_p))}{(l_h^3 m_h + l_h^3 m_p - l_h l_p^2 m_p cos(\theta_h  - \theta_p)^2)^2}
\\


& A_2 = -\frac{(l_h l_p^2 m_p \theta_h cos(\theta_h - \theta_p) sin(\theta_h - \theta_p))}{(l_h^3 m_h + l_h^3 m_p - l_h l_p^2 m_p cos(\theta_h - \theta_p)^2)}

\\
& A_3 = 
\frac{(l_p sin(\theta_h - \theta_p) (d_p \theta_p + l_p m_p u cos(\theta_p) + g l_p m_p sin(\theta_p) - \dot\theta_h l_h l_p m_p \theta_h sin(\theta_h - \theta_p)))}{(l_h^3 m_h + l_h^3 m_p - l_h l_p^2 m_p cos(\theta_h - \theta_p)^2) }
\\
&- \frac{(\dot\theta_p l_h l_p m_p sin(\theta_h - \theta_p) - \dot\theta_p l_h l_p m_p \theta_p cos(\theta_h - \theta_p))}{(l_h^2 m_h + l_h^2 m_p - l_p^2 m_p cos(\theta_h - \theta_p)^2) }
\\
&+ \frac{(l_p cos(\theta_h - \theta_p) (d_p + g l_p m_p cos(\theta_p) - l_p m_p u sin(\theta_p) + \dot\theta_h l_h l_p m_p \theta_h cos(\theta_h - \theta_p)))}{(l_h^3 m_h + l_h^3 m_p - l_h l_p^2 m_p cos(\theta_h - \theta_p)^2) }
\\
&- \frac{(2 l_p^2 m_p cos(\theta_h - \theta_p) sin(\theta_h - \theta_p) (d_h \theta_h + l_h u cos(\theta_h) (m_h + m_p) + g l_h sin(\theta_h) (m_h + m_p) + \dot\theta_p l_h l_p m_p \theta_p sin(\theta_h - \theta_p)))}{(l_h^2 m_h + l_h^2 m_p - l_p^2 m_p cos(\theta_h - \theta_p)^2)^2 }
\\
&+ \frac{(2 l_h l_p^3 m_p cos(\theta_h - \theta_p)^2 sin(\theta_h - \theta_p) (d_p \theta_p + l_p m_p u cos(\theta_p) + g l_p m_p sin(\theta_p) - \dot\theta_h l_h l_p m_p \theta_h sin(\theta_h - \theta_p)))}{(l_h^3 m_h + l_h^3 m_p - l_h l_p^2 m_p cos(\theta_h - \theta_p)^2)^2}
 

\\
& A_4 = -\frac{(l_h l_p m_p \theta_p sin(\theta_h - \theta_p))}{(l_h^2 m_h + l_h^2 m_p - l_p^2 m_p cos(\theta_h - \theta_p)^2)}

\\
& A_5 =  
\frac{((\dot\theta_h l_h l_p m_p sin(\theta_h - \theta_p) + \dot\theta_h l_h l_p m_p \theta_h cos(\theta_h - \theta_p)) (m_h + m_p))}{(l_h^2 m_p^2 + m_h l_h^2 m_p - l_p^2 m_p^2 cos(\theta_h - \theta_p)^2)}
\\
& -\frac {(l_p sin(\theta_h - \theta_p) (d_h \theta_h + l_h u cos(\theta_h) (m_h + m_p) + g l_h sin(\theta_h) (m_h + m_p) + \dot\theta_p l_h l_p m_p \theta_p sin(\theta_h - \theta_p)))}{(l_h^3 m_h + l_h^3 m_p - l_h l_p^2 m_p cos(\theta_h - \theta_p)^2) }
\\
&+ \frac{(l_p cos(\theta_h - \theta_p) (d_h + g l_h cos(\theta_h) (m_h + m_p) - l_h u sin(\theta_h) (m_h + m_p) + \dot\theta_p l_h l_p m_p \theta_p cos(\theta_h - \theta_p)))}{(l_h^3 m_h + l_h^3 m_p - l_h l_p^2 m_p cos(\theta_h - \theta_p)^2)}
\\
& + \frac{(2 l_p^2 m_p^2 cos(\theta_h - \theta_p) sin(\theta_h - \theta_p) (m_h + m_p) (d_p \theta_p + l_p m_p u cos(\theta_p) + g l_p m_p sin(\theta_p) - \dot\theta_h l_h l_p m_p \theta_h sin(\theta_h - \theta_p)))}{(l_h^2 m_p^2 + m_h l_h^2 m_p - l_p^2 m_p^2 cos(\theta_h - \theta_p)^2)^2 }
\\
&- \frac{(2 l_h l_p^3 m_p cos(\theta_h - \theta_p)^2 sin(\theta_h - \theta_p) (d_h \theta_h + l_h u cos(\theta_h) (m_h + m_p) + g l_h sin(\theta_h) (m_h + m_p) + \dot\theta_p l_h l_p m_p \theta_p sin(\theta_h - \theta_p)))}{(l_h^3 m_h + l_h^3 m_p - l_h l_p^2 m_p cos(\theta_h - \theta_p)^2)^2}
 

\\
& A_6  = \frac{(l_h l_p m_p \theta_h sin(\theta_h - \theta_p) (m_h + m_p))}{(l_h^2 m_p^2 + m_h l_h^2 m_p - l_p^2 m_p^2 cos(\theta_h - \theta_p)^2)}

\\
& A_7 =  
\frac{(l_p sin(\theta_h - \theta_p) (d_h \theta_h + l_h u cos(\theta_h) (m_h + m_p) + g l_h sin(\theta_h) (m_h + m_p) + \dot\theta_p l_h l_p m_p \theta_p sin(\theta_h - \theta_p)))}{(l_h^3 m_h + l_h^3 m_p - l_h l_p^2 m_p cos(\theta_h - \theta_p)^2) }
\\
&- \frac{((m_h + m_p) (d_p + g l_p m_p cos(\theta_p) - l_p m_p u sin(\theta_p) + \dot\theta_h l_h l_p m_p \theta_h cos(\theta_h - \theta_p)))}{(l_h^2 m_p^2 + m_h l_h^2 m_p - l_p^2 m_p^2 cos(\theta_h - \theta_p)^2)}
\\
& + \frac{(l_p cos(\theta_h - \theta_p) (\dot\theta_p l_h l_p m_p sin(\theta_h - \theta_p) - \dot\theta_p l_h l_p m_p \theta_p cos(\theta_h - \theta_p)))}{(l_h^3 m_h + l_h^3 m_p - l_h l_p^2 m_p cos(\theta_h - \theta_p)^2) }
\\
&- \frac{(2 l_p^2 m_p^2 cos(\theta_h - \theta_p) sin(\theta_h - \theta_p) (m_h + m_p) (d_p \theta_p + l_p m_p u cos(\theta_p) + g l_p m_p sin(\theta_p) - \dot\theta_h l_h l_p m_p \theta_h sin(\theta_h - \theta_p)))}{(l_h^2 m_p^2 + m_h l_h^2 m_p - l_p^2 m_p^2 cos(\theta_h - \theta_p)^2)^2 }
\\
&+ \frac{(2 l_h l_p^3 m_p cos(\theta_h - \theta_p)^2 sin(\theta_h - \theta_p) (d_h \theta_h + l_h u cos(\theta_h) (m_h + m_p) + g l_h sin(\theta_h) (m_h + m_p) + \dot\theta_p l_h l_p m_p \theta_p sin(\theta_h - \theta_p)))}{(l_h^3 m_h + l_h^3 m_p - l_h l_p^2 m_p cos(\theta_h - \theta_p)^2)^2}
 

\\
& A_8 =  
 \frac{(l_h l_p^2 m_p \theta_p cos(\theta_h - \theta_p) sin(\theta_h - \theta_p))}{(l_h^3 m_h + l_h^3 m_p - l_h l_p^2 m_p cos(\theta_h - \theta_p)^2)}
 



\end{align}
$$
A简化后
$$
\begin{align}
 &a_{43}=\frac{2l_h^2m_pcos(\theta_h - \theta_p)sin(\theta_h - \theta_p)(d_h\theta_h + l_hucos(\theta_h)(m_h + m_p) + gl_hsin(\theta_h)(m_h + m_p) + \dot\theta_pl_hl_pm_p\theta_psin(\theta_h - \theta_p))}{(l_h^2m_h + l_h^2m_p - l_h^2m_pcos(\theta_h - \theta_p)^2)^2 }
 \\& -\frac{ 2l_hl_pm_pcos(\theta_h - \theta_p)^2sin(\theta_h - \theta_p)(d_p\theta_p + l_pm_pucos(\theta_p) + gl_pm_psin(\theta_p) - \dot\theta_hl_hl_pm_p\theta_hsin(\theta_h - \theta_p))}{(- l_hl_pm_pcos(\theta_h - \theta_p)^2 + l_hl_pm_h + l_hl_pm_p)^2}
 \\&- \frac{sin(\theta_h - \theta_p)(d_p\theta_p + l_pm_pucos(\theta_p) + gl_pm_psin(\theta_p) - \dot\theta_hl_hl_pm_p\theta_hsin(\theta_h - \theta_p))}{- l_hl_pm_pcos(\theta_h - \theta_p)^2 + l_hl_pm_h + l_hl_pm_p }
 \\&- \frac{cos(\theta_h - \theta_p)(\dot\theta_hl_hl_pm_psin(\theta_h - \theta_p) + \dot\theta_hl_hl_pm_p\theta_hcos(\theta_h - \theta_p))}{- l_hl_pm_pcos(\theta_h - \theta_p)^2 + l_hl_pm_h + l_hl_pm_p }
 \\&- \frac{d_h + gl_hcos(\theta_h)(m_h + m_p) - l_husin(\theta_h)(m_h + m_p) + \dot\theta_pl_hl_pm_p\theta_pcos(\theta_h - \theta_p)}{(l_h^2m_h + l_h^2m_p - l_h^2m_pcos(\theta_h - \theta_p)^2)}

 





\end{align}
$$

$$
\begin{align}

\\&a_{44} = -\frac{(l_hl_pm_p\theta_hcos(\theta_h - \theta_p)sin(\theta_h - \theta_p))}{(- l_hl_pm_pcos(\theta_h - \theta_p)^2 + l_hl_pm_h + l_hl_pm_p)}
\\&a_{45} = -\frac{ (2l_h^2m_pcos(\theta_h - \theta_p)sin(\theta_h - \theta_p)(d_h\theta_h + l_hucos(\theta_h)(m_h + m_p) + gl_hsin(\theta_h)(m_h + m_p) + \dot\theta_pl_hl_pm_p\theta_psin(\theta_h - \theta_p)))}{(l_h^2m_h + l_h^2m_p - l_h^2m_pcos(\theta_h - \theta_p)^2)^2 }
\\&+ \frac{(2l_hl_pm_pcos(\theta_h - \theta_p)^2sin(\theta_h - \theta_p)(d_p\theta_p + l_pm_pucos(\theta_p) + gl_pm_psin(\theta_p) - \dot\theta_hl_hl_pm_p\theta_hsin(\theta_h - \theta_p)))}{(- l_hl_pm_pcos(\theta_h - \theta_p)^2 + l_hl_pm_h + l_hl_pm_p)^2}
\\&+ \frac{(sin(\theta_h - \theta_p)(d_p\theta_p + l_pm_pucos(\theta_p) + gl_pm_psin(\theta_p) - \dot\theta_hl_hl_pm_p\theta_hsin(\theta_h - \theta_p)))}{(- l_hl_pm_pcos(\theta_h - \theta_p)^2 + l_hl_pm_h + l_hl_pm_p)}
\\&+ \frac{(cos(\theta_h - \theta_p)(d_p + gl_pm_pcos(\theta_p) - l_pm_pusin(\theta_p) + \dot\theta_hl_hl_pm_p\theta_hcos(\theta_h - \theta_p)))}{(- l_hl_pm_pcos(\theta_h - \theta_p)^2 + l_hl_pm_h + l_hl_pm_p) }
\\& - \frac{(\dot\theta_pl_hl_pm_psin(\theta_h - \theta_p) - \dot\theta_pl_hl_pm_p\theta_pcos(\theta_h - \theta_p))}{(l_h^2m_h + l_h^2m_p - l_h^2m_pcos(\theta_h - \theta_p)^2) }


 
\\&a_{46} = -\frac{(l_hl_pm_p\theta_psin(\theta_h - \theta_p))}{(l_h^2m_h + l_h^2m_p - l_h^2m_pcos(\theta_h - \theta_p)^2)}
\\&a_{63} =  - \frac{(2l_hl_pm_pcos(\theta_h - \theta_p)^2sin(\theta_h - \theta_p)(d_h\theta_h + l_hucos(\theta_h)(m_h + m_p) + gl_hsin(\theta_h)(m_h + m_p) + \dot\theta_pl_hl_pm_p\theta_psin(\theta_h - \theta_p)))}{(- l_hl_pm_pcos(\theta_h - \theta_p)^2 + l_hl_pm_h + l_hl_pm_p)^2}
\\& + \frac{(2l_p^2m_p^2cos(\theta_h - \theta_p)sin(\theta_h - \theta_p)(m_h + m_p)(d_p\theta_p + l_pm_pucos(\theta_p) + gl_pm_psin(\theta_p) - \dot\theta_hl_hl_pm_p\theta_hsin(\theta_h - \theta_p)))}{(- l_p^2m_p^2cos(\theta_h - \theta_p)^2 + l_p^2m_p^2 + m_hl_p^2m_p)^2}
\\&- \frac{(sin(\theta_h - \theta_p)(d_h\theta_h + l_hucos(\theta_h)(m_h + m_p) + gl_hsin(\theta_h)(m_h + m_p) + \dot\theta_pl_hl_pm_p\theta_psin(\theta_h - \theta_p)))}{(- l_hl_pm_pcos(\theta_h - \theta_p)^2 + l_hl_pm_h + l_hl_pm_p)}
\\&+\frac{(cos(\theta_h - \theta_p)(d_h + gl_hcos(\theta_h)(m_h + m_p) - l_husin(\theta_h)(m_h + m_p) + \dot\theta_pl_hl_pm_p\theta_pcos(\theta_h - \theta_p)))}{(- l_hl_pm_pcos(\theta_h - \theta_p)^2 + l_hl_pm_h + l_hl_pm_p) }
\\& + \frac{((\dot\theta_hl_hl_pm_psin(\theta_h - \theta_p) + \dot\theta_hl_hl_pm_p\theta_hcos(\theta_h - \theta_p))(m_h + m_p))}{(- l_p^2m_p^2cos(\theta_h - \theta_p)^2 + l_p^2m_p^2 + m_hl_p^2m_p)}

\\& a_{64} = \frac{(l_hl_pm_p\theta_hsin(\theta_h - \theta_p)(m_h + m_p))}{(- l_p^2m_p^2cos(\theta_h - \theta_p)^2 + l_p^2m_p^2 + m_hl_p^2m_p)}

\\&a_{65}=  \frac{(2l_hl_pm_pcos(\theta_h - \theta_p)^2sin(\theta_h - \theta_p)(d_h\theta_h + l_hucos(\theta_h)(m_h + m_p) + gl_hsin(\theta_h)(m_h + m_p) + \dot\theta_pl_hl_pm_p\theta_psin(\theta_h - \theta_p)))}{(- l_hl_pm_pcos(\theta_h - \theta_p)^2 + l_hl_pm_h + l_hl_pm_p)^2 }
\\&- \frac{(2l_p^2m_p^2cos(\theta_h - \theta_p)sin(\theta_h - \theta_p)(m_h + m_p)(d_p\theta_p + l_pm_pucos(\theta_p) + gl_pm_psin(\theta_p) - \dot\theta_hl_hl_pm_p\theta_hsin(\theta_h - \theta_p)))}{(- l_p^2m_p^2cos(\theta_h - \theta_p)^2 + l_p^2m_p^2 + m_hl_p^2m_p)^2}
\\&+\frac{(sin(\theta_h - \theta_p)(d_h\theta_h + l_hucos(\theta_h)(m_h + m_p) + gl_hsin(\theta_h)(m_h + m_p) + \dot\theta_pl_hl_pm_p\theta_psin(\theta_h - \theta_p)))}{(- l_hl_pm_pcos(\theta_h - \theta_p)^2 + l_hl_pm_h + l_hl_pm_p) }
\\&- \frac{((m_h + m_p)(d_p + gl_pm_pcos(\theta_p) - l_pm_pusin(\theta_p) + \dot\theta_hl_hl_pm_p\theta_hcos(\theta_h - \theta_p)))}{(- l_p^2m_p^2cos(\theta_h - \theta_p)^2 + l_p^2m_p^2 + m_hl_p^2m_p)}
\\& + \frac{(cos(\theta_h - \theta_p)(\dot\theta_pl_hl_pm_psin(\theta_h - \theta_p) - \dot\theta_pl_hl_pm_p\theta_pcos(\theta_h - \theta_p)))}{(- l_hl_pm_pcos(\theta_h - \theta_p)^2 + l_hl_pm_h + l_hl_pm_p) }

 
\\&a_{66} = \frac{(l_hl_pm_p\theta_pcos(\theta_h - \theta_p)sin(\theta_h - \theta_p))}{(- l_hl_pm_pcos(\theta_h - \theta_p)^2 + l_hl_pm_h + l_hl_pm_p)}
\end{align}
$$





求取输入矩阵
$$
B = \left[ \begin{matrix}
	0&		1&		0&		B_1&		0&		B_2\\
\end{matrix} \right] ^T|_{(x_r,v_r)}
$$
其中
$$
\begin{align}
& B_1 =  \frac{(l_p^2 m_p cos(\theta_h - \theta_p) cos(\theta_p))}{(l_h^3 m_h + l_h^3 m_p - l_h l_p^2 m_p cos(\theta_h - \theta_p)^2) }- \frac{(l_h cos(\theta_h) (m_h + m_p))}{(l_h^2 m_h + l_h^2 m_p - l_p^2 m_p cos(\theta_h - \theta_p)^2)}
\\
& B_2 = \frac{(l_h l_p cos(\theta_h - \theta_p) cos(\theta_h) (m_h + m_p))}{(l_h^3 m_h + l_h^3 m_p - l_h l_p^2 m_p cos(\theta_h - \theta_p)^2) }- \frac{(l_p m_p cos(\theta_p) (m_h + m_p))}{(l_h^2 m_p^2 + m_h l_h^2 m_p - l_p^2 m_p^2 cos(\theta_h - \theta_p)^2)}

\end{align}
$$
得到线性化方程
$$
\begin{align}
&\varDelta \dot x = A\varDelta x+B\varDelta v
\\
&\varDelta x = x-x_r,\ \varDelta v= v-v_r
\end{align}
$$


取饱和函数
$$
\psi_i(\xi_i,\psi^{\pm}_i) = \psi^{+}_i-\frac{\psi^+_i-\psi^-_i}{1+e^{\frac{4\xi_i}{\psi^+_i-\psi^-_i}}},\ i = 1,2
\\
\psi _3\left( v,\psi _{3}^{\pm} \right) =\left\{ \begin{array}{l}
	\psi _{3}^{+},\ \ v>\psi _{3}^{+}\\
	v\ ,\ \ \ v\in \left[ \psi _{3}^{-},\psi _{3}^{+} \right] \\\
	\psi _{3}^{-},\ \ v<\psi _{3}^{-}\\
\end{array} \right.
$$
取$m = \frac{4}{\psi^+_i-\psi^-_i}$可以得到
$$
\begin{align}

&\frac{\partial\psi_i}{\partial\xi_i}=\frac{4e^{m_i\xi_i}}{(e^{m_i\xi_i} + 1)^2}
\\
&\frac{\partial^2\psi_i}{\partial\xi_i^2}=\frac{4m_ie^{m_i\xi_i}(1-e^{m_i\xi_i})}{(e^{m_i\xi_i}+1)^3}
\end{align}
$$
取期望的轨迹$x^*(t),\eta^*(t),\dot \eta^*(t) $, 
$$
\begin{align}
&x^* = \psi_1(\xi_1,\psi^{\pm}_1)\\
\\
& \dot x^* = \frac{\partial\psi_1}{\partial \xi_1}\dot \xi_1 
\\
& \dot \xi_1 = \psi_2(\xi_2,\psi^{\pm}_2)
\\
& \dot \xi_2 = \psi_3(\varPhi(t,\boldsymbol{p}),\psi^{\pm}_3)
\\
& u^* = \ddot x^* = \frac{\partial^2\psi_1}{\partial \xi^2_1}\dot \xi^2_1+\frac{\partial\psi_1}{\partial\xi_1}\ddot \xi_1
\\
& \ \ \ \  =  \frac{\partial^2\psi_1}{\partial \xi^2_1}\psi^2_2+\frac{\partial\psi_1}{\partial\xi_1}[\frac{\partial\psi_2}{\partial\xi_1}\psi_2+\frac{\partial\psi_2}{\partial\xi_2}\psi_3(\varPhi(t,\boldsymbol{p}),\psi^{\pm}_3(\xi_1,\xi_2))]

\end{align}
$$

其中
$$
\begin{align}
&v = \varPhi(t,\boldsymbol{p}) = \sum^n_{i = 1}p_isin(\frac{h_i\pi t}{T}) , \ n = 8\\
& \psi^{\pm}_1=x^{\pm}_0
\\
& \psi^{\pm}_2=x^{\pm}_1[\frac{\partial\psi_1}{\partial\xi_1}]^{-1}
\\
& \psi^{\pm}_3(\xi_1,\xi_2) = x^{\pm}_2[\frac{\partial\psi_1}{\partial\xi_1}\frac{\partial\psi_2}{\partial\xi_2}]^{-1}-[\frac{\partial^2\psi_1}{\partial\xi^2_1}\psi^2_2+\frac{\partial\psi_1}{\partial\xi_1}\frac{\partial\psi_2}{\partial\xi_1}\psi_2][\frac{\partial\psi_1}{\partial\xi_1}\frac{\partial\psi_2}{\partial\xi_2}]^{-1}
\\
&\xi_{1,0}= \psi^{-1}_1(x_0,\psi^{\pm}_1), 
\ \xi_{1,T}=\psi^{-1}_1(x_T,\psi^{\pm}_1)
\\
& \xi_{2,0} = \psi^{-1}_2(0,\psi^{\pm}_2)=0, \ \xi_{2,T}=\psi^{-1}_2(0,\psi^{\pm}_2)=0
\\
& \varPhi(0,\boldsymbol{p}) = \varPhi(T,p) = 0
\end{align}
$$
其中针对实物，,$x^{+}_0 = 0.5m,\ x^{+}_1=0.4m/s,\ x^{+}_2 = 1m/s^2$, 

可以得到
$$
\begin{align}
&\xi_{1,0}= \frac{1}{m_1}\ln\frac{\psi^-_1-x_0}{x_0-\psi^+_1}, 
\ \xi_{1,T}=\frac{1}{m_1}\ln\frac{\psi^-_1-x_T}{x_T-\psi^+_1}
\\
& \xi_{2,0} = \psi^{-1}_2(0,\psi^{\pm}_2)=0, \ \xi_{1,T}=\psi^{-1}_2(0,\psi^{\pm}_2)=0
\\
& \frac{\partial \psi_2}{\partial \xi_1 } = \frac{\partial\psi^+_2}{\partial\xi_1}-\frac{\frac{\partial \psi^+_2}{\partial\xi_1}-\frac{\partial\psi^-_2}{\partial \xi_1}}{1+e^{m\xi_2}}+\frac{4\xi_2e^{m_2\xi_2}(\frac{\partial\psi^+_2}{\partial \xi_1}-\frac{\partial \psi^-_2}{\partial\xi_1})}{(1+e^{m_2\xi_2})^2(\psi^{+}_2-\psi^-_2)}
\\
& \frac{\partial\psi^{\pm}_2}{\partial\xi_1} = \frac{\partial}{\partial\xi_1}[x^{\pm}_1\frac{(e^{m_1\xi_1+1})^2}{4e^{m_1\xi_1}}]=\frac{x^{\pm}_1}{4}(m_1e^{m_1\xi_1}-m_1e^{-m_1\xi_1})
\end{align}
$$


## 反馈控制

采用$H\infin$控制，考虑外部扰动

动力学模型
$$
\dot{x}=Ax+Bu+L\tilde{d}
$$
代价函数
$$
J(t)=\frac{1}{2}\int_0^T{\left[ y^Ty+ru^Tu-\rho ^2\tilde{d}^T\tilde{d} \right] dt,\ r,\ \rho >0}
$$
由此求最大扰动时的最小控制问题
$$
\underset{u}{\min}\underset{\tilde{d}}{\max}J\left( u,\tilde{d} \right)
$$


取目标函数
$$
J^*\left( x \right) =x^TPx
$$
由HJB方程，求
$$
\forall x,\ 0=\underset{u}{\min}\left[ y^Ty+ru^Tu-\rho ^2\tilde{d}^T\tilde{d}+\frac{\partial J^*}{\partial x}\left( Ax+Bu \right) \right]
$$
关于u求导得到
$$
u^* = -Kx\\
K = \frac{1}{r}B^TP
$$

回代到HJB方程可得$Riccati$方程
$$
\begin{align}
&A^TP+PA+Q-P(\frac{1}{r}BB^T-\frac{1}{2\rho^2}LL^T)P=0\\
& \tilde d(t) = \frac{1}{\rho^2}L^TPx(t)
\end{align}
$$

## 离散的LQR

### 简单状态方程

$$
\begin{align}
x[n+1]=Ax[n]+Bu[n]
\end{align}
$$

目标函数为
$$
min\sum^{N-1}_{n=0}x^T[n]Qx[n]+u^T[n]Ru[n],\ Q = Q^T\ge 0,R = R^T>0
$$
代价函数为
$$
J(x,n-1)=\underset{u}{\min}x^TQx+u^TRu+J(Ax+Bu,n)
$$
选择期望解
$$
J(x,n) = x^Ts[n]x,\ s[n]=s^T[n]>0
$$
那么，由式（105）取微分有
$$
2u^TR+2(Ax+Bu)^Ts[n]B=0
$$
得到
$$
u^*[n] = -(R+B^Ts[n]B)^{-1}B^Ts[n]Ax = K[n]x
$$
将上式回代至（105）有
$$
\begin{align}
& x^Ts[n-1]x = x^TQx+x^TK^TRKx+(Ax-BKx)^Ts[n](Ax-BKx)
\end{align}
$$
对其整理，推得
$$
\begin{align}
&s[n-1]=Q+K^TRK+(A-BK)^Ts[n](A-BK)\Rightarrow
\\& \ \  \ \  \ \ \ \ \ \ \ \ \  =Q +A^Ts[n]A-A^Ts[n]BK-K^TB^Ts[n]A+K^T(R+B^Ts[n]B)K 
\\&\ \  \ \  \ \ \ \ \ \ \ \ \ =Q +A^Ts[n]A-A^Ts[n]BK-K^TB^Ts[n]A+K^TB^Ts[n]A
\\&\ \  \ \  \ \ \ \ \ \ \ \ \ = Q +A^Ts[n]A-A^Ts[n]BK
\\&\ \  \ \  \ \ \ \ \ \ \ \ \ = Q+A^Ts[n]A-A^Ts[n]B(R+B^Ts[n]B)^{-1}B^Ts[n]A
\end{align}
$$

### 扩张的状态方程

对于状态方程
$$
\begin{align}
&x[n+1]=Ax[n]+Bu[n]\\
&y[k+1] = C^Tx[n]
\end{align}
$$
考虑积分项
$$
x_I[n+1] = x_I[n]+C^Tx[n]
$$
取$\tilde x = [x\  x_I]^T$，得到扩张状态方程
$$
\tilde x[n+1]=\tilde A\tilde x[n]+\tilde B\tilde u[n]
$$
其中
$$
\begin{align}
& \tilde A =  \left[ \begin{matrix}
	A&		0\\
	C^T&		1\\
\end{matrix} \right] ,\ \tilde B = \left[ \begin{array}{c}
	B\\
	0\\
\end{array} \right] 

\end{align}
$$


### 考虑系统不确定性的状态方程

$$
x[n+1] = Ax[n]+Bu[n]+Ld[n]
$$

目标函数为
$$
\begin{align}
&min\sum^{N-1}_{n=0}
	x^T\left[ n \right]
	 Q
	x\left[ n \right]
	+
	u^T[n]
	R
	u[n]-d^T[n]Nd[n] \\& Q = Q^T\ge 0,R = R^T>0,N = N^T>0
\end{align}
$$
代价函数为
$$
\begin{align}
&J(x,n-1)=\underset{u}{\min}\underset{d}{\max}
	x^T\left[ n \right]
	 Q
	x\left[ n \right]
	+
	u^T[n]
	R
	u[n]-d^T[n]Nd[n]+J(Ax+Bu,n)
\end{align}
$$
选择期望解
$$
\begin{align}
&J(x,n) = 
	x^Ts[n]
	x,\ s[n]=s^T[n]>0

\end{align}
$$
对于式，代入式,并取微分有
$$
2u^TR+2(Ax+Bu)^Ts[n]B=0
$$
得到
$$
u^*[n] = -(R+B^Ts[n]B)^{-1}B^Ts[n]Ax[n] = -K[n]x[n]
$$
回代至有
$$
\begin{align}
&x^Ts[n-1]x= x^TQx+x^T(A^Ts[n]B(R+B^Ts[n]B)^{-1})^TR(R+B^Ts[n]B)^{-1}B^Ts[n]Ax
\\& -d^T[n]Nd[n]+(Ax+Bu)^Ts[n](Ax+Bu)
 

\end{align}
$$


## code 

```matlab
syms m_c m_p m_h l_h l_p F_ax F_theta_h F_theta_p dottheta_h dottheta_p dotx theta_h theta_p x g F_fx  ddotx ddottheta_h ddottheta_p d_h d_p u
M_theta = [(m_h+m_p)*l_h^2 m_p*l_h*l_p*cos(theta_h-theta_p);m_p*l_h*l_p*cos(theta_h-theta_p) m_p*l_p^2];
C_theta = [d_h m_p*l_h*l_p*sin(theta_h-theta_p)*dottheta_p;-m_p*l_h*l_p*sin(theta_h-theta_p)*dottheta_h d_p];
G_theta = [(m_h+m_p)*g*l_h*sin(theta_h);m_p*g*l_p*sin(theta_p)];
B_theta = [-(m_h+m_p)*l_h*cos(theta_h);-m_p*l_p*cos(theta_p)];

inv(M_theta)
ans*(-C_theta*[theta_h;theta_p]-G_theta+B_theta*u)

%ddottheta_h = (l_p*cos(theta_h - theta_p)*(d_p*theta_p + l_p*m_p*v*cos(theta_p) + g*l_p*m_p*sin(theta_p) - dottheta_h*l_h*l_p*m_p*theta_h*sin(theta_h - theta_p)))/(l_h^3*m_h + l_h^3*m_p - l_h*l_p^2*m_p*cos(theta_h - theta_p)^2) - (d_h*theta_h + l_h*v*cos(theta_h)*(m_h + m_p) + g*l_h*sin(theta_h)*(m_h + m_p) + dottheta_p*l_h*l_p*m_p*theta_p*sin(theta_h - theta_p))/(l_h^2*m_h + l_h^2*m_p - l_p^2*m_p*cos(theta_h - theta_p)^2)

%ddottheta_p = (l_p*cos(theta_h - theta_p)*(d_h*theta_h + l_h*v*cos(theta_h)*(m_h + m_p) + g*l_h*sin(theta_h)*(m_h + m_p) + dottheta_p*l_h*l_p*m_p*theta_p*sin(theta_h - theta_p)))/(l_h^3*m_h + l_h^3*m_p - l_h*l_p^2*m_p*cos(theta_h - theta_p)^2) - ((m_h + m_p)*(d_p*theta_p + l_p*m_p*v*cos(theta_p) + g*l_p*m_p*sin(theta_p) - dottheta_h*l_h*l_p*m_p*theta_h*sin(theta_h - theta_p)))/(l_h^2*m_p^2 + m_h*l_h^2*m_p - l_p^2*m_p^2*cos(theta_h - theta_p)^2)

inv(M_theta)*(-C_theta*[theta_h;theta_p]-G_theta+B_theta*u)

f = [dotx;u;dottheta_h;ans(1);dottheta_p;ans(2)];
z = [x;dotx;theta_h;dottheta_h;theta_p;dottheta_p];

A= jacobian(f,z)
B= jacobian(f,u)
 
inv(M_theta)*(-C_theta*[dottheta_h;dottheta_p]-G_theta)
p = [m_p;l_h;l_p;d_h;d_p];

D = jacobian(ans,p)


```

### bvp的部分代码

# 参考文献

<a name="ref1"><font color='black'>[1]</font></a>张梦华.欠驱动单级摆及二级摆型桥式吊车非线性控制策略研究[D].山东大学,2018.

Jian-Xin Xu,Sanjib,K. Panda等.Real-time Iterative Learning Control[M].Springer, London,1000.

Anderson,,James等.System level synthesis[J].ANNUAL REVIEWS IN CONTROL,2019,47:364-393.

Y. Wang, N. Matni and J. C. Doyle, "Localized LQR optimal control," 53rd IEEE Conference on Decision and Control, 2014, pp. 1661-1668, doi: 10.1109/CDC.2014.7039638.



https://ww2.mathworks.cn/help/matlab/math/solve-bvp-with-unknown-parameter.html?lang=en

