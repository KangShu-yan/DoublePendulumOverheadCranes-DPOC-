#include "concretecontrol.h"

ConcreteControl::ConcreteControl()  {


}

ConcreteControl::~ConcreteControl(){
}



//QSharedPointer<ControllerBase>
ControllerBase* ConcreteControl::createController(int i,struct PhysicalParameters& params, QVector<double> &gains)
{


    switch(i)
    {
        case 0:
            return new LQRControl(params,gains);
//        case 1:
//            return new LQRControl(params,gains);
//        case 2:
//            return new LQRControl(params,gains);
//        case 3:
//        case 4:
         case 5:
            return new PIDControl(params,gains);
    default:
        return new LQRControl(params,gains);



    }


}
