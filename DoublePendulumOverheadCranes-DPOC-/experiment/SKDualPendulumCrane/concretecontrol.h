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

 * @file odesolverbase.h
 * @brief The header file for the base of all ode solver.
 *
 * This is the base of all function plot window for the project.
 *
 * @author Ryan Du (Empyreal092)
 * @author Firat Taxpulat (FT-1984)
 * @author Anita Chen (achen1105)
 *
 * @bug No known bugs, but more features to be added
 */


#ifndef CONCRETECONTROL_H
#define CONCRETECONTROL_H

#include <QWidget>
//#include <QLabel>
//#include "userwindow.h"
#include "controllerbase.h"
#include "lqrcontrol.h"
#include "pidcontrol.h"

namespace Ui {
class ConcreteControl;
}

/**
 * @class	ConcreteControl
 *
 * @brief	An ode solver base class, abstract class.
 */

class ConcreteControl : public QWidget
{
    Q_OBJECT

 public:

    /**
     * @fn	explicit TwoPtrWindow::TwoPtrWindow(FunctionPlot *parent = nullptr);
     *
     * @brief	Constructor
     *
     * @param [in,out]	parent	(Optional) If non-null, the parent.
     */

    explicit ConcreteControl();

    /**
     * @fn	TwoPtrWindow::~TwoPtrWindow();
     *
     * @brief	Destructor
     */

    virtual ~ConcreteControl() ;


    static ControllerBase* createController(int i,struct PhysicalParameters& params,QVector<double> &gains);
//    static QSharedPointer<ControllerBase> createController(int i,QVector<double> &gains);



};

#endif // CONCRETECONTROL_H
