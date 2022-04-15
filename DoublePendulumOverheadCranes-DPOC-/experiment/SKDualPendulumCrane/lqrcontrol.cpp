/**
 * This file is part of PIC 10C Final Project - A Graphic Calculator.
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.

 * We declare that this work is our own.
 * We did this work honestly and can fully stand behind everything that we have written.
 * We did not copy code from anyone, student or otherwise, expect files we downloaded and have the permission to use.
 * We pledge that we have neither given nor received unauthorized assistance on making this project.

 * @file eulermethod.cpp
 * @brief The implementation file for the Euler Method window.
 *
 * This is the Euler Method window for the project.
 *
 * @author Ryan Du (Empyreal092)
 * @author Firat Taxpulat (FT-1984)
 * @author Anita Chen (achen1105)
 *
 * @bug No known bugs, but more features to be added
 */

#include "lqrcontrol.h"

//LQRControl::LQRControl(ControllerBase *parent,struct PhysicalParameters params, struct Gains gains) : ControllerBase(parent)
LQRControl::LQRControl(struct PhysicalParameters &params, QVector<double>& gains)


{
    int dim = 6;
    K.resize(dim);
    Q.resize(dim,dim);
    for(int i = 0;i<dim;++i)Q(i,i) = gains[i];
    R.resize(1,1);
    R(0,0) = gains.back();
    m_c = params.m_c;m_h = params.m_h;m_p = params.m_p;g = params.g;
    l_h = params.l_h;l_p = params.l_p; d_h  = params.d_h;
    d_p  = params.d_p;f_rx = params.f_rx;k_rx = params.k_rx;
    epsilonx = params.epsilonx; x_d = params.x_d; max_u = params.max_u;
    Ts = params.Ts;


    Eigen::MatrixXd A(dim,dim), B(dim,1);
    A<<0,1,0,0,0,0
            ,0,0,g*(m_h+m_p)/m_c,d_h/(l_h*m_c),0,0
            ,0,0,0,1,0,0
            ,0, 0, -(g*(m_c + m_h)*(m_h + m_p))/(l_h*m_c*m_h), -(d_h*(m_c + m_h))/(l_h*l_h*m_c*m_h),          (g*m_p)/(l_h*m_h),                  d_p/(l_h*l_p*m_h)
            ,0, 0,                                          0,                                  0,                          0,                                  1
            ,0, 0,                  (g*(m_h + m_p))/(l_p*m_h),                  d_h/(l_h*l_p*m_h), -(g*(m_h + m_p))/(l_p*m_h), -(d_p*(m_h + m_p))/(l_p*l_p*m_h*m_p);
    B<<0
            ,1/m_c
                ,0
     ,-1/(l_h*m_c)
                ,0
                ,0;

    Eigen::MatrixXd I =  Eigen::MatrixXd::Identity(dim,dim);
    A= I+A*Ts;
    B = Ts*B;
    solveRiccati(A, B, Q, R);
}

LQRControl::~LQRControl(){
}

double LQRControl::updateControl(double x,double dotx,double theta_h,double dottheta_h,double theta_p,double dottheta_p){
    double u=0.0;
    Eigen::VectorXd e(6);
    e<<x-x_d,dotx,theta_h,dottheta_h,theta_p,dottheta_p;
    u = -K*e;
    umax(u);

    return u;
}
// 离散求解
bool LQRControl::solveRiccati(Eigen::MatrixXd& A,Eigen::MatrixXd& B,Eigen::MatrixXd& Q,Eigen::MatrixXd & R
                             ,const double &tolerance, const uint iter_max)
{

    Eigen::MatrixXd P(Q);
    Eigen::MatrixXd P_next;

     Eigen::MatrixXd AT = A.transpose();
     Eigen::MatrixXd BT = B.transpose();
     Eigen::MatrixXd Rinv = R.inverse();

     double diff;
     for (uint i = 0; i < iter_max; ++i) {
       // -- discrete solver --
       P_next = AT * P * A -
                AT * P * B * (R + BT * P * B).inverse() * BT * P * A + Q;

       diff = fabs((P_next - P).maxCoeff());
       P = P_next;
       if (diff < tolerance) {
#if DEBUG
         qDebug() << "iteration mumber = " << i ;
#endif
         int n = static_cast<int>(P.rows());
         for(int i = 0;i<n;++i)
             K(i) = P(i,i);
         return true;
       }
     }
     return false; // over iteration limit

}
