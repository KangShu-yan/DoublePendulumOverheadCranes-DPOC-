#include "controllerbase.h"


ControllerBase::ControllerBase()
//ControllerBase::ControllerBase(QWidget *parent) : QWidget(parent)
{


}

ControllerBase::~ControllerBase(){
}
void ControllerBase::umax(double & u)
{
    if(u>max_u)
        u = max_u;
    else if(u<-max_u)
        u = -max_u;
}

//void ODESolverBase::changeinicond(double i){
//    initial_cond = i; // change final
//}

//void ODESolverBase::muteErrorSound()
//{
//    if(muteIsPressed == false)
//    {
//        muteIsPressed = true;  // Mutes sound if unmuted.
//    }
//    else
//    {
//        muteIsPressed = false; // Unmutes sound if muted.
//    }
//}
