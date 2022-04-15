# LQR control for dual pendulum overhead crane



## 情形1：

**如果直接认为**$\dot \theta_h^2 = 0,\dot \theta_p^2 = 0,\ sin\theta_h = \theta_h, sin(\theta_h-\theta_p) = \theta_h-\theta_p,cos(\theta_h-\theta_p)=1...$,
$$
\begin{align}
&(m_c+m_h+m_p)\ddot x+(m_h+m_p)l_h\ddot \theta_h+m_pl_p\ddot \theta_p = F_x\\
& (m_h+m_p)l_h\ddot x+(m_h+m_p)l_h^2\ddot \theta+m_pl_hl_p\ddot \theta_p+(m_h+m_p)gl_h\theta_h+d_h\dot \theta_h = 0
\\
& 
m_pl_p\ddot x+m_pl_hl_p\ddot \theta_h+m_pl_p^2\ddot \theta_p+m_pgl_p\theta_p+d_p\dot \theta_p=0


\end{align}
$$

可得
$$
\begin{align}
 &\ddot x = \frac{F_{ax}}{m_c} + \frac{d_h \dot\theta_h + g l_h m_h \theta_h + g l_h m_p \theta_h}{l_h m_c} = f_x+b_xu
\\
&\ddot \theta_h =\frac{ F_{ax}}{l_hm_c} -\frac{d_h \dot \theta_h l_p m_c - d_p \dot \theta_p l_h m_c + d_h \dot \theta_h l_p m_h + g l_h l_p m_h^2 \theta_h+g l_h l_p m_c m_h \theta_h }{(l_h^2 l_p m_c m_h)}   \\
&\ \ \ \ \ \ \ \    + \frac{ g l_h l_p m_c m_p \theta_h - g l_h l_p m_c m_p \theta_p + g l_h l_p m_h m_p \theta_h}{(l_h^2 l_p m_c m_h)} = f_h+b_hu
\\
 
&\ddot \theta_p = -\frac{d_p \dot \theta_p l_h m_h - d_h \dot \theta_h l_p m_p + d_p \dot \theta_p l_h m_p - g l_h l_p m_p^2  \theta_h + g l_h l_p m_p^2  \theta_p - g l_h l_p m_h m_p  \theta_h} {l_h l_p^2 m_h m_p}

\\ 

&\ \ \ \ \ \ \ \ + \frac{g l_h l_p m_h m_p  \theta_p}{l_h l_p^2 m_h m_p} = f_p +b_pu
\end{align}
$$
考虑$[x_1\  x_2\  x_3\  x_4\  x_5\ x_6]^T = [x\ \dot x\ \theta_h \ \dot \theta_h \ \theta_p \ \dot \theta_p ]^T$,有
$$
\begin{align}
&\dot x_1 = \dot x_2\\ 
&\dot x_2 = ( F_{ax} l_h + d_h \dot \theta_h + g l_h m_h \theta_h + g l_h m_p \theta_h)/(l_h m_c)\\
&  \dot  x_3 = x_4\\
&  \dot  x_4 = -(d_h \dot \theta_h l_p m_c - d_p \dot \theta_p l_h m_c + d_h \dot \theta_h l_p m_h +  F_{ax} l_h l_p m_h + g l_h l_p m_h^2 \theta_h + g l_h l_p m_c m_h \theta_h + g l_h l_p m_c m_p \theta_h - g l_h l_p m_c m_p \theta_p + g l_h l_p m_h m_p \theta_h)/(l_h^2 l_p m_c m_h) \\
& \dot  x_5 =x_6  \\
& \dot  x_6 =-(d_p \dot \theta_p l_h m_h - d_h dot\theta_h l_p m_p + d_p \dot\theta_p l_h m_p - g l_h l_p m_p^2 \theta_h + g l_h l_p m_p^2 \theta_p - g l_h l_p m_h m_p \theta_h + g l_h l_p m_h m_p \theta_p)/(l_h l_p^2 m_h m_p) 

\end{align}
$$
考虑$\dot x = f(x,\dot x,)$的一阶泰勒，$x_d = [x_d\ 0\ 0\ 0\ 0\ 0]^T$，$u_d$是上一次的控制量
$$
\dot x = f(x,\dot x)|_{(x_d,u_d)}+\frac{\partial f(x,\dot x)}{\partial x}|_{(x_d, u_d)}(x-x_d)+\frac{\partial f(x,\dot x)}{\partial u}|_{(x_d, u_d)}(u-u_d)+O((x-x_d)^2)
$$
令$e = x-x_d$可以得到
$$
\dot e = Ae+B\varDelta u\\
 y  = Cx
$$
具体的
$$
A=\left[ \begin{matrix}
	0& 1&                                                                                                  0&                                                0&                                                          0&                                                0		\\
	0& 0&                                                                  (g l_h m_h + g l_h m_p)/(l_h m_c)&                                    d_h/(l_h m_c)&                                                          0&                                                0		\\
	0& 0&                                                                                                  0&                                                1&                                                          0&                                                0		\\
	0& 0& -(g l_h l_p m_h^2 + g l_h l_p m_c m_h + g l_h l_p m_c m_p + g l_h l_p m_h m_p)/(l_h^2 l_p m_c m_h)& -(d_h l_p m_c + d_h l_p m_h)/(l_h^2 l_p m_c m_h)&                                          (g m_p)/(l_h m_h)&                                d_p/(l_h l_p m_h)		\\
	0& 0&                                                                                                  0&                                                0&                                                          0&                                                1		\\
	0& 0&                                          (g l_h l_p m_p^2 + g l_h l_p m_h m_p)/(l_h l_p^2 m_h m_p)&                                d_h/(l_h l_p m_h)& -(g l_h l_p m_p^2 + g l_h l_p m_h m_p)/(l_h l_p^2 m_h m_p)& -(d_p l_h m_h + d_p l_h m_p)/(l_h l_p^2 m_h m_p)		\\
\end{matrix} \right]
$$

$$
B =\left[ \begin{array}{l}
	0\\
	 1/m_c\\
	0\\
	-1/(l_h*m_c)\\
	0\\
	0\\
\end{array} \right],C = I_{6\times 6}
$$





离散的方程有
$$
e[K+1] = (I+TA)e[k]+TBu[k]
$$


由HJB得到连续和离散
$$
\varDelta u =  -R^{-1}(B^TP+N)e\\
\varDelta u[k] =-(\tilde B^TP\tilde B+R)^{-1}(\tilde B^TP\tilde A+N^T)e(k)
$$




由黎卡提方程
$$
Q+A^TP+PA-(PB+N)R^{-1}(B^TP+N^T)=0
$$
求出对角阵$P$，其中$Q = C^TC,R = I$

模型参数为
$$
m_c = 8kg,\ m_h = 0.5kg,\ m_p = 1kg,\ l_h = 1m,\ l_p = 0.5m,\\ \ x_d = 2m,\ frx = 4.6,\ \varepsilon_x = 0.01, krx = -0.5;
$$
选取增益为
$$
k_p = 200,\ k_d = 10, \ k_s = 30, \alpha = 2;
$$

## 情形2

**当不做**$\dot \theta_h^2 = 0,\dot \theta_p^2 = 0,\ sin\theta_h = \theta_h, sin(\theta_h-\theta_p) = \theta_h-\theta_p,cos(\theta_h-\theta_p)=1...$,的假设











# 实验

## 情形1

202112171918no friction.fig, 202112171918friction_1.fig, 202112171918friction_2.fig为情形1

## 情形2

$$
\ddot q = f(q,\dot q)=M^{-1}(U-C\dot q-G)
$$

$q_d = [x_d,0,0]^T,\dot q_d = [0,0, 0 ]^T$可得
$$
\frac{\partial M^{-1}}{\partial q}(U-C\dot q-G)|_{(q_d,\dot q_d)}+M^{-1}(\frac{\partial U}{\partial q}-\frac{\partial C(q,\dot q)}{\partial q}\dot q-\frac{\partial G}{\partial q})|_{(q_d,\dot q_d)}\\
=
$$


# code 

## 情形1

```matlab
syms m_c m_p m_h l_h l_p F_ax F_theta_h F_theta_p dottheta_h dottheta_p dotx theta_h theta_p x g F_fx  ddotx ddottheta_h ddottheta_p d_h d_p
 M = [m_c+m_h+m_p (m_h+m_p)*l_h m_p*l_p;(m_h+m_p)*l_h (m_h+m_p)*l_h^2 m_p*l_h*l_p;m_p*l_p m_p*l_h*l_p m_p*l_p^2]

C=  
 G = [0;(m_h+m_p)*g*l_h*theta_h;m_p*g*l_p*theta_p]
U = [F_ax;0;0]
ddotq = M\(U-C*[dotx;dottheta_h;dottheta_p]-G)

A = [dotx ; (F_ax*l_h + d_h*dottheta_h + g*l_h*m_h*theta_h + g*l_h*m_p*theta_h)/(l_h*m_c);dottheta_h;-(d_h*dottheta_h*l_p*m_c - d_p*dottheta_p*l_h*m_c + d_h*dottheta_h*l_p*m_h + F_ax*l_h*l_p*m_h + g*l_h*l_p*m_h^2*theta_h + g*l_h*l_p*m_c*m_h*theta_h + g*l_h*l_p*m_c*m_p*theta_h - g*l_h*l_p*m_c*m_p*theta_p + g*l_h*l_p*m_h*m_p*theta_h)/(l_h^2*l_p*m_c*m_h);dottheta_p; -(d_p*dottheta_p*l_h*m_h - d_h*dottheta_h*l_p*m_p + d_p*dottheta_p*l_h*m_p - g*l_h*l_p*m_p^2*theta_h + g*l_h*l_p*m_p^2*theta_p - g*l_h*l_p*m_h*m_p*theta_h + g*l_h*l_p*m_h*m_p*theta_p)/(l_h*l_p^2*m_h*m_p)];
B = jacobian(A,[x;dotx;theta_h;dottheta_h;theta_p;dottheta_p]);
B = jacobian(A,[F_ax]);
 
 

```

控制代码

```matlab
len=length(x); 
Q = C^TC;
R =1;
% N = 0;

e = [x-xd;dotx;theta_h;dottheta_h;theta_p;dottheta_p]^T;
[k,P,eig] =lqr(A,B,Q,R);
u = -ke;


```

## 情形2

```matlab
M=[m_c+m_h+m_p (m_h+m_p)*l_h*cos(theta_h) m_p*l_p*cos(theta_p);
    (m_h+m_p)*l_h*cos(theta_h) (m_h+m_p)*l_h^2 m_p*l_h*l_p*cos(theta_h-theta_p);
    m_p*l_p*cos(theta_p) m_p*l_h*l_p*cos(theta_h-theta_p) m_p*l_h^2];
C = [0 -(m_h+m_p)*l_h*sin(theta_h)*dottheta_h -m_p*l_p*sin(theta_p)*dottheta_p;
    0 d_h m_p*l_h*l_p*sin(theta_h-theta_p)*dottheta_p;
    0 -m_p*l_h*l_p*sin(theta_h-theta_p)*dottheta_h+d_p 0];
G = [0; (m_h+m_p)*g*l_h*sin(theta_h);m_p*g*l_p*sin(theta_p)];


U = [F_ax; 0;0];
dq = [dotx;dottheta_h;dottheta_p];
ddq = M\(U-G-C*dq);



```



# 参考文献

张梦华.欠驱动单级摆及二级摆型桥式吊车非线性控制策略研究[D].山东大学,2018.

blog.sina.com.cn/s/blog_568ae0b70102wnjf.html

