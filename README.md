# DoublePendulumOverheadCranes-DPOC-

#v双摆效应桥式吊车消摆定位控制

Anti-swing and positioning control for double pendulum effects overhead cranes

代码中包括设计的轨迹规划方法、非线性控制律和被比较的方法。

#主要内容如下：

①  基于两点边界值分析的轨迹规划方法。针对现有双摆效应桥式吊车轨迹规划方法的不足，通过引入虚拟状态量设计基于两点边界值的非线性轨迹规划方法，该方法合理地分析系统的物理约束，将其融入到轨迹规划过程中。随后，设计了对应的跟踪控制方法并利用对比仿真验证了所提轨迹规划方法的可行性。

②  基于部分反馈分析的增强消摆跟踪控制方法。针对双摆效应吊车的跟踪控制，结合部分反馈法和状态量的动态耦合关系设计控制器，该方法由台车位移、吊钩摆角和负载摆角构造新的位移信号并设计对应的跟踪控制律，能够实现台车定位并快速地抵消吊钩及负载的摆动。论文提供了一系列仿真和实验结果。

③  基于末端虚拟运动的自适应控制方法。针对吊车系统存在参数不确定的问题，设计基于负载虚拟水平运动的自适应控制方法。首先定义包含台车运动量、吊钩及负载摆动量的重构位移信号，再结合滑模面和系统的总能量构造控制器，该方法无需已知系统参数，具有良好的暂态控制性能且适用于实际工程。论文设计了对比仿真与实验，并评估了本方法在外界干扰和系统参数变化情形下的控制性能。

The major contents are as follows:

① A trajectory planning method based on two-point boundary value analysis. Aiming at the shortcomings of the existing double pendulum effects overhead crane trajectory planning methods, a nonlinear trajectory planning method based on the two-point boundary value is designed by introducing virtual states. The method reasonably analyzes the physical constraints of the system and integrates it into the trajectory planning process. Subsequently, the corresponding tracking control method is designed and the feasibility of the proposed trajectory planning method is verified by comparative simulation experiments. 

②  Enhanced anti-swing tracking control method based on partial feedback analysis. Aiming at the tracking control of the double pendulum effects cranes, the controller is designed by combining the partial feedback method and the dynamic coupling relationship of the states. This method constructs a new displacement signal from the trolley displacement, hook swing angle and load swing angle, and designs the corresponding tracking control law, which can achieve the positioning of the trolley and quickly offset the swing of the hook and the cargos. A series of simulation and experimental results are provided in this paper.

③ An adaptive control method based on the end virtual motion. Aiming at the real problems of system parameter uncertainty and external disturbance, an adaptive control method based on the virtual horizontal motion of load is designed. Firstly, the reconstructed displacement signal including the motion of the cart, the hook and cargos swing is defined, and then the controller is constructed based on the sliding surface and the total energy of the system. This method does not require known system parameters, has good transient control performance and is suitable for engineering applications. A comparative simulation and experiment are designed in this paper, and the control performance of the method under the condition of external disturbance and system parameter change is evaluated.



#simulation是论文仿真代码

用到matlab，bvp，ode等工具

#experiment是论文实验代码

用到keil, QtCreator, Eigen等工具
