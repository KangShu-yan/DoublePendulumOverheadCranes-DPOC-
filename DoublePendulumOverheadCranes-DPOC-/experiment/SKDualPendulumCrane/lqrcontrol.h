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

 * @file eulermethod.h
 * @brief The header file for the Euler Method window.
 *
 * This is the Euler Method window for the project.
 *
 * @author Ryan Du (Empyreal092)
 * @author Firat Taxpulat (FT-1984)
 * @author Anita Chen (achen1105)
 *
 * @bug No known bugs
 */


#ifndef LQRCONTROL_H
#define LQRCONTROL_H

#include <QWidget>
#include "controllerbase.h"



struct Gains
{
    Eigen::MatrixXd Q;
    Eigen::MatrixXd R;
};
namespace Ui {
class LQRControl;
}



/**
 * @class	EulerMethod
 *
 * @brief	The Euler Method window.
 */

class LQRControl : public ControllerBase{
   Q_OBJECT

public:

   /**
    * @fn	explicit EulerMethod::EulerMethod(ODESolverBase *parent = nullptr);
    *
    * @brief	Constructor
    *
    * @param [in,out]	parent	(Optional) If non-null, the parent.
    */

//   explicit LQRControl(UserWindow *parent);
//    explicit LQRControl(ControllerBase* parent,struct PhysicalParameters params,struct Gains);
     explicit LQRControl(struct PhysicalParameters& params,QVector<double>& gains);

   /**
    * @fn	EulerMethod::~EulerMethod() override;
    *
    * @brief	Destructor
    */

   ~LQRControl() override;

   /**
    * @fn	void EulerMethod::makepoints() override;
    *
    * @brief	Make the points for the graph
    */

   virtual double updateControl(double x,double dotx,double theta_h
                        ,double dottheta_h,double theta_p,double dottheta_p) override;

private:
   bool solveRiccati(Eigen::MatrixXd& A,Eigen::MatrixXd& B,Eigen::MatrixXd& Q,Eigen::MatrixXd & R
                      ,const double &tolerance =1.E-5, const uint iter_max=100000);
private:
   Eigen::RowVectorXd K;
   Eigen::MatrixXd Q;
   Eigen::MatrixXd R;
};

#endif // LQRCONTROL_H
