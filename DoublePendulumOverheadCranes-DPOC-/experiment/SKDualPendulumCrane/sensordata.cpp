#include "sensordata.h"

#include <QTimer>
#include <QFileDialog>
#include <QCoreApplication>
#include <QPainter>
#include <QPushButton>
#include <QButtonGroup>
#include <QGroupBox>
#include <QComboBox>
#include <QDateTime>
#include <QHBoxLayout>
#include <QDebug>
#include <QTextCodec>
#include <QThread>
#include <QScrollArea>
#include <QDesktopWidget>
#include "qcustomplot.h"

//#include <iostream>
#ifdef _WIN32
#include <windows.h>
#endif
//#include <opencv2/core/core.hpp>
//#include <opencv2/highgui/highgui.hpp>
//#include <opencv2/imgproc/imgproc.hpp>

#define READ_BIN_TIME            1
#define UPDATE_PLAY_INFO_TIME    30


SensorDataObserver::SensorDataObserver( QWidget *parent)
    : QWidget(parent)
    ,m_bIsGotOriginalPos(false)
    ,m_lastTime(0)

{

//    m_vLocalHAngle.resize(30);
//    m_vLocalPAngle.resize(30);
    m_iSmoothWindowWidth.resize(2);
    m_iSmoothWindowWidth[0]=m_iSmoothWindowWidth[1]=30;
//    m_vLocalAngle.resize(2);
    m_pSerial.resize(2);
    for(int i = 0;i<m_pSerial.size();++i)m_pSerial[i]=nullptr;
//    m_pSerialTimer.resize(2);
    m_bSerialConnected.resize(2);
    m_vSum.resize(6);
    for(int i = 0;i<m_vSum.size();++i)m_vSum[i]=0;
    m_qOriginalData.resize(6);  //x dotx theta_h dottheta_h theta_p dottheta_p
    initSerial();
    m_lastData.carPosition=0;
    m_lastData.carVelocity=0;
    m_lastData.hookAngle = 0;
    m_lastData.hookAngleVelocity=0;
    m_lastData.payloadAngle = 0;
    m_lastData.payloadAngleVelocity=0;
    m_lastData.Force = 0;

}

SensorDataObserver::~SensorDataObserver()
{


}
void SensorDataObserver::rstALL()
{

#if DEBUG
//    qDebug()<<"rstALL";
#endif
    rstGts();
    closeSerial();
    for(int i = 0;i<m_pSerialInfo.size();++i)
    {
        delete m_pSerialInfo[i];
        m_pSerialInfo[i] = nullptr;
    }
}

void SensorDataObserver::rstData()
{
    this->m_qResult.clear();
    this->m_qLocalResult.clear();
    for(int i = 0;i<m_qOriginalData.size();++i)
        m_qOriginalData[i].clear();
    for(int i = 0;i<m_vSum.size();++i)
        m_vSum[i]=0;
}
void SensorDataObserver::initSerial()
{
    int i = 0;
    m_pSerialInfo.resize(QSerialPortInfo::availablePorts().size());
    foreach (const QSerialPortInfo &info, QSerialPortInfo::availablePorts())
    {
//         QSerialPort *pSerial = new QSerialPort ;
//         pSerial->setPort(info);
        m_pSerialInfo[i] = new QSerialPort;
        m_pSerialInfo[i++]->setPort(info);
//         m_pSerialInfo.push_back(pSerial);
    }
}

void SensorDataObserver::openSerial(QVector<QString>& portName,
                                    QString& baudrate,QString &stopBit,
                                    QString& dataBit,QString& crc)
{


    for(int i = 0;i<2;++i)
    {
#if DEBUG
    qDebug()<< "portName[i]: "<<portName[i];
#endif

       if(!m_pSerial[i])m_pSerial[i] = QSharedPointer<QSerialPort>::create();
        m_pSerial[i]->setPortName(portName[i]);
        if(m_pSerial[i]->open(QIODevice::ReadWrite))
        {

            m_pSerial[i]->setBaudRate(baudrate.toInt());
            if(stopBit=="2")m_pSerial[i]->setStopBits(QSerialPort::TwoStop);
            else if(stopBit=="1.5")m_pSerial[i]->setStopBits(QSerialPort::OneAndHalfStop);
            else m_pSerial[i]->setStopBits(QSerialPort::OneStop);

            if(dataBit=="5")m_pSerial[i]->setDataBits(QSerialPort::Data5);
            else if(dataBit=="6")m_pSerial[i]->setDataBits(QSerialPort::Data6);
            else if(dataBit=="7")m_pSerial[i]->setDataBits(QSerialPort::Data7);
            else m_pSerial[i]->setDataBits(QSerialPort::Data8);

            if(crc=="Odd Parity")m_pSerial[i]->setParity(QSerialPort::OddParity);
            else if(crc =="Even Parity")m_pSerial[i]->setParity(QSerialPort::EvenParity);
            else m_pSerial[i]->setParity(QSerialPort::NoParity);


//            if(!m_pSerialTimer[i])m_pSerialTimer[i] = new QTimer();


//            connect(m_pSerialTimer[i],SIGNAL(timeout()),this,SLOT(onReadSerial()));
////            串口更新周期
//            m_pSerialTimer[i]->start(5);
#if DEBUG
//    qDebug()<< "i: "<< i;
#endif
            m_bSerialConnected[i]=true;

        }
        else {


            QMessageBox::about(nullptr, "提示", portName[i]+"串口没有打开！");
        }
    }
#if DEBUG
//    qDebug()<<"connected[0]: "<< m_bSerialConnected[0]<<" [1]: "<<m_bSerialConnected[1];
#endif
//    m_pSerial[1] = QSharedPointer<QSerialPort>::create();


}
void SensorDataObserver::closeSerial()
{
    for(int i = 0;i<2;++i)
    {
        if(m_pSerial[i]&&m_pSerial[i]->isOpen())m_pSerial[i]->close();
        m_bSerialConnected[i]=false;
    }
}
void SensorDataObserver::serialState(bool& aSerial,bool& bSerial)
{
    aSerial = m_bSerialConnected[0];
    bSerial= m_bSerialConnected[1];
#if DEBUG
//    qDebug()<< "m_bSerialConnected[0]: "<< m_bSerialConnected[0]<<" m_bSerialConnected[1]: "<< m_bSerialConnected[1];
#endif
}
void SensorDataObserver::analysisSerialData(QByteArray& readData,int k)
{

    int len = readData.length();
#if DEBUG
// qDebug()<<"len : " <<len;
#endif
   static QTime time(QTime::currentTime());
   static uint8_t flag = 0;
    CharConvertShort val ;
    static double hAngle=0,pAngle = 0;
//    static AnalysisData lastData;
      struct AnalysisData data;

//    for (int i = 0; i < len;++i)
//    {
//        if ((i+5)<len&&readData.at(i)== static_cast<char>(0xAE) && readData.at(i+1) == static_cast<char>(0xEA)
//                &&readData.at(i+4) == static_cast<char>(0xEF)&&readData.at(i+5) == static_cast<char>(0xFE))
//        {
//#if DEBUG
////            qDebug()<<"hook angle";
//#endif
//            val.data[0] = readData.at(i+2);
//            val.data[1]= readData.at(i+3);
//             hAngle = static_cast<double>(val.x)/4096*2*pi;    // angle (rad)
////            m_vLocalAngle[0].push_back(angle);
//            i+=5;
////            if(m_vLocalAngle[0].size()==m_iSmoothWindowWidth)
////                smoothData(m_vLocalAngle[0]);
//            flag |=1;
//        }
//        else if((i+5)<len&&readData.at(i)== static_cast<char>(0x55)&&readData.at(i+1)== static_cast<char>(0x53))
//        {
//            val.data[0] = readData.at(i+4);
//            val.data[1]=readData.at(i+5);
////           *180 得到角度 degree 乘以pi为rad
//            if(k==0)
//            {
//                hAngle = static_cast<double>(val.x)/32768*pi;
//                 flag |=1;
//            }
//            else if(k==1)
//            {
//                pAngle = static_cast<double>(val.x)/32768*pi;
//                 flag |=1<<4;

//            }
////            pAngle = static_cast<double>(val.x)/32768;
//#if DEBUG
////            qDebug()<<"pAngle : " <<pAngle;
//#endif
////            m_vLocalAngle[1].push_back(angle);
//            i+=11;
////            if(m_vLocalAngle[1].size()==m_iSmoothWindowWidth)
////                smoothData(m_vLocalAngle[1]);

//        }
      double currentTime = time.elapsed()/1000.0;
      double dt =currentTime-m_lastTime;
      if(dt>0.002)
      {
    //        if(flag==static_cast<uint8_t>(0x01))
    //        {
    //            time_to_s (1000000/125)
    //            GT_GetClockHighPrecision(&m_currentTime);



    //            double dt = static_cast<double>(m_currentTime-m_lastTime)/(1000000.0/125);
    #if DEBUG
//          qDebug()<<"dt: "<<dt<<" currentTime: "<< currentTime<<" m_lastTime :"<<m_lastTime;
    #endif
                readPosition(data.carPosition);

                data.hookAngle = hAngle;
                data.payloadAngle = pAngle;
                data.Force = 0;
    #if DEBUG
//                qDebug()<<"data.carPosition: "<<data.carPosition<<" m_lastData.carPosition: "<<m_lastData.carPosition;
    #endif
                data.carVelocity = (data.carPosition-m_lastData.carPosition)/dt;
                data.hookAngle = (hAngle-m_lastData.hookAngle)/dt;
                data.payloadAngleVelocity = (pAngle-m_lastData.payloadAngle)/dt;

                smoothData(data.carPosition,0);
                smoothData(data.carVelocity,1);

                smoothData(data.hookAngle,2);
                smoothData(data.hookAngleVelocity,3);
                smoothData(data.payloadAngle,4);
                smoothData(data.payloadAngleVelocity,5);
#if DEBUG
//                qDebug()<<"data x: "<<data.carPosition<<" dotx "<<data.carVelocity;
#endif
                m_qLocalResult.push_back(data);


    #if DEBUG
//                qDebug()<<"hAngle : " <<hAngle<<" pAngle: "<<pAngle<<" carVelocity: "<<data.carVelocity ;
    #endif
    //            // buffer limit
                if(m_qLocalResult.size()>20)m_qLocalResult.pop_front();
                m_lastTime = currentTime;
                m_lastData = data;
    //            flag = 0;
    //        }
          }
//    }

}

bool SensorDataObserver::initGts()
{
    // 打开运动控制器
    short sRtn ;
    sRtn= GT_Open();
//
#if DEBUG
//    qDebug()<<" initGts sRtn: "<<sRtn;
#endif
    if(sRtn!=0) QMessageBox::about(nullptr, "提示", "运动控制器没有打开！");
    // 指令返回值检测
    // 系统复位
    sRtn = GT_Reset();
    if(sRtn!=0) {
        QMessageBox::about(nullptr, "提示", "运动控制器复位不成功！");
        return false;
    }
    // 配置轴1脉冲输出方式为脉冲+方向
    sRtn = GT_StepDir(1);
    if(sRtn!=0) {
        QMessageBox::about(nullptr, "提示", "运动控制器配置输出方式不成功！");
        return false;
    }
    // 配置完成后要更新状态
    sRtn = GT_ClrSts(AXIS_1);
    if(sRtn!=0) {
        QMessageBox::about(nullptr, "提示", "运动控制器更新状态不成功！");
        return false;
    }
    // 轴1伺服使能
    sRtn = GT_AxisOn(AXIS_1);
#if DEBUG
//    qDebug()<<" sRtn: "<<sRtn;
#endif
//    QMessageBox不能放在构造函数中
    if(sRtn!=0){
        QMessageBox::information(nullptr, "提示","伺服失败！");
        return false;
    }
    m_dCartOriginalPos = 0.0;
    if(!m_bIsGotOriginalPos){
        GT_GetAxisEncPos(AXIS_1, &m_dCartOriginalPos, 1, NULL);
#if DEBUG
//        qDebug()<<"m_dCartOriginalPos: "<<m_dCartOriginalPos;
#endif
        m_bIsGotOriginalPos = true;
    }
    short u = 0;
    GT_SetDac(AXIS_1, &u, 1);
    return true;
}
void SensorDataObserver::rstGts()
{
    short u = 0;
    GT_SetDac(AXIS_1, &u, 1);
    GT_AxisOff(AXIS_1);
}
void SensorDataObserver::setGtsDac(double &force)
{
//    force_to_torque = (2000.0*PI*0.8/5),dac_to_torque = (10*0.637/32767)
    short set_dac_value = (short)(force / (2000*3.1415926*0.8/5) / (10*0.637/32767));
#if DEBUG
//    qDebug()<< "set_dac_value: "<<set_dac_value;
#endif

    GT_SetDac(AXIS_1, &set_dac_value, 1);


}



void SensorDataObserver::readPosition(double &position)
{
//    static unsigned long last_time = 0;
//    static double last_pos = 0.0;
//    unsigned long current_time = 0;
    //fpga高精度时钟
//    GT_GetClockHighPrecision(&current_time);

    GT_GetAxisEncPos(AXIS_1, &position, 1, NULL);
//    pusle_to_mm (15000*4/5)  15000是编码器分频脉冲数,4倍频输出 1圈对于丝杆来说是5mm
    position  = (position-m_dCartOriginalPos)/(15000*4/5)/1000.0;
#if DEBUG
//    qDebug()<< "readPosition";
#endif
}
void SensorDataObserver::saveCurve(unsigned char *pBuffer, int index)
{

}
void SensorDataObserver::smoothData(double& data,uint8_t i)
{

    m_vSum[i]+=data;
#if DEBUG
//    qDebug()<<"data: "<<data;
#endif
    m_qOriginalData[i].push_back(data);
    if(m_qOriginalData[i].size()>20)
    {
        m_vSum[i] -=m_qOriginalData[i].front();
        m_qOriginalData[i].pop_front();
    }
    data = m_vSum[i]/m_qOriginalData[i].size();
#if DEBUG
//    qDebug()<<"data: "<<data<<" m_qOriginalData[i].size(): "<<m_qOriginalData[i].size();
#endif
}


void SensorDataObserver::writeCSVData()
{    

    size_t dataSize = 1;
    if (1)
    {
        for (size_t i = 0; i < dataSize; i++)
        {
//            g_ofWriteMat << 1<< ',' << 2<< ','  << endl;
        }
    }

}



//#ifdef _LOG_TIME_CONSUMING_
//    gettimeofday(&tv_end, NULL);
//    //cout << "paintEvent time = " << tv_end.tv_usec - tv_begin.tv_usec << endl;
//#endif
//}
void SensorDataObserver::onReadSerial()
{

//    for(int i = 0;i<2;++i)
//    {
//        if(m_pSerial[i]&&m_pSerial[i]->isOpen())
//        {
        QByteArray readData ;
//            QByteArray readData = m_pSerial[i]->readAll();

//            if(readData != nullptr)
//            {
#if DEBUG
//                qDebug()<<"get data from serial";
#endif
                analysisSerialData(readData,0);

//            }
//        }
//    }


}
void SensorDataObserver::onUpdateSensor()
{
//    if (m_pCeleX5->isLoopModeEnabled())
//    {
//        return;
//        m_pCeleX5->getFullPicBuffer(m_pBuffer[0]);
//        updateQImageBuffer(m_pBuffer[0], 1, 0);

//        CeleX5::CeleX5Mode mode = m_pCeleX5->getSensorLoopMode(2);
//        if (mode == CeleX5::Event_Off_Pixel_Timestamp_Mode)
//        {
//            if (0 == m_iLoopPicMode)
//                m_pCeleX5->getEventPicBuffer(m_pBuffer[1], CeleX5::EventBinaryPic);
//            else if (1 == m_iLoopPicMode)
//                m_pCeleX5->getEventPicBuffer(m_pBuffer[1], CeleX5::EventDenoisedBinaryPic);
//            else if (2 == m_iLoopPicMode)
//                m_pCeleX5->getEventPicBuffer(m_pBuffer[1], CeleX5::EventCountPic);
//            else if (3 == m_iLoopPicMode)
//                m_pCeleX5->getEventPicBuffer(m_pBuffer[1], CeleX5::EventDenoisedCountPic);
//        }
//        else if (mode == CeleX5::Event_In_Pixel_Timestamp_Mode)
//        {
//            if (0 == m_iLoopPicMode)
//                m_pCeleX5->getOpticalFlowPicBuffer(m_pBuffer[1], CeleX5::OpticalFlowPic);
//            else if (1 == m_iLoopPicMode)
//                m_pCeleX5->getEventPicBuffer(m_pBuffer[1], CeleX5::EventBinaryPic);
//        }
//        else if (mode == CeleX5::Event_Intensity_Mode)
//        {
//            if (0 == m_iLoopPicMode)
//                m_pCeleX5->getEventPicBuffer(m_pBuffer[1], CeleX5::EventBinaryPic);
//            else if (1 == m_iLoopPicMode)
//                m_pCeleX5->getEventPicBuffer(m_pBuffer[1], CeleX5::EventGrayPic);
//            else if (2 == m_iLoopPicMode)
//                m_pCeleX5->getEventPicBuffer(m_pBuffer[1], CeleX5::EventAccumulatedPic);
//            else if (3 == m_iLoopPicMode)
//                m_pCeleX5->getEventPicBuffer(m_pBuffer[1], CeleX5::EventCountPic);
//        }
//        updateQImageBuffer(m_pBuffer[1], 2, 0);

//        m_pCeleX5->getOpticalFlowPicBuffer(m_pBuffer[2], CeleX5::OpticalFlowPic);
//        updateQImageBuffer(m_pBuffer[2], 3, 1);

//        if (m_bRecordingImages)
//        {
//            saveRecordingImage(m_pBuffer[0], 1);

//            m_pCeleX5->getEventPicBuffer(m_pBuffer[3], CeleX5::EventCountPic);
//            saveRecordingImage(m_pBuffer[3], 2);
//        }
//    }
//    else
//    {
//        CeleX5::CeleX5Mode mode = m_pCeleX5->getSensorFixedMode();

//        processSensorBuffer(mode, -1);

//        m_uiRealFullFrameFPS = m_pCeleX5->getFullFrameFPS();
//    }
}

