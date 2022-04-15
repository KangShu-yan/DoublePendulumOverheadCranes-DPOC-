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

#include "pidcontrol.h"

PIDControl::PIDControl(struct PhysicalParameters &params, QVector<double>& gains)
{
    int dim = gains.size();
    K.resize(dim);
    m_c = params.m_c;m_h = params.m_h;m_p = params.m_p;g = params.g;
    l_h = params.l_h;l_p = params.l_p; d_h  = params.d_h;
    d_p  = params.d_p;f_rx = params.f_rx;k_rx = params.k_rx;
    epsilonx = params.epsilonx; x_d = params.x_d; max_u = params.max_u;
    Ts = params.Ts; v_d = params.v_d;
    for(int i = 0;i<dim;++i)K(i)=gains[i];
}

PIDControl::~PIDControl(){
}

double PIDControl::updateControl(double x,double dotx,double theta_h,double dottheta_h,double theta_p,double dottheta_p){
    double u=0.0;
    static double sum = 0;
//    double e = dotx-v_d;
    double e = x-x_d;
    double le=0;
    sum = sum+e*Ts;
    u = K(0)*e+K(1)*sum+K(2)*(e-le)/Ts;
    umax(u);
    le = e;
#if DEBUG
//    qDebug()<<"e: "<<e<<" sum: "<<sum<<" K(0): "<<K(0)<<" K(1)"<<K(1)<<" K(2): "<<K(2) ;
#endif
    return u;
}
