#ifndef SENSORDATA_H
#define SENSORDATA_H

//#include "sliderwidget.h"
//#include "cfgslider.h"
//#include "celex5cfg.h"
//#include "settingswidget.h"
//#include "./include/celex5/celex5.h"
//#include "./include/celex5/celex5datamanager.h"
//#include "videostream.h"

#include "./include/gts.h"

#include <QTime>
#include <QMessageBox>
#include <QRadioButton>
#include <QTextEdit>
#include <QSerialPort>
#include <QSerialPortInfo>
#include <complex>
#include <QQueue>
#include <QVector>
#include <QDebug>

#ifdef _WIN32
#include <windows.h>
#else
#include<unistd.h>
#endif

#define AXIS_1 1
#define DEBUG 1
const double pi =  3.1415926;
//#define SMOOTH_WINDOW_LENTH
using namespace std;

//#pragma execution_character_set("utf-8")

enum DisplayType {
    Realtime = 0,
    Playback = 1,
    ConvertBin2Video = 2,
    ConvertBin2CSV = 3
};
union CharConvertShort
{
    short int x;
    char data[2];
};
struct AnalysisData
{

    double carPosition;
    double carVelocity;
    double hookAngle;
    double hookAngleVelocity;
    double payloadAngle;
    double payloadAngleVelocity;
    double Force;
    AnalysisData():carPosition(0),carVelocity(0),hookAngle(0)
      ,hookAngleVelocity(0)
      ,payloadAngle(0)
      ,payloadAngleVelocity(0)
      ,Force(0){}
};

class QLabel;
class MainWindow;
class QComboBox;
class SensorDataObserver : public QWidget
{
    Q_OBJECT
public:
    SensorDataObserver(QWidget *parent);
    ~SensorDataObserver();

    void setSaveBmp(bool save);
    bool isSavingBmp();

    void openSerial(QVector<QString>& portName,
                    QString& baudrate,QString &stopBit,
                    QString& dataBit,QString& crc);
    void closeSerial();
    void serialState(bool& aSerial,bool& bSerial);
    void setGtsDac(double &force);
    bool initGts();
    void rstGts();
    void rstALL();
    void rstData();
    void smoothData(double& data,uint8_t type);
private:
    void initSerial();


    void analysisSerialData(QByteArray& readData,int i);

    void readPosition(double &x);
//    void updateOPDirection(unsigned char *pBuffer1);
//    void updateEventImage(CeleX5::EventPicType type);
//    void processSensorBuffer(CeleX5::CeleX5Mode mode, int loopNum);
    //

    void saveCurve(unsigned char* pBuffer, int index);
//    void savePics(CeleX5ProcessedData* pSensorData);
    void writeCSVData();



protected:
//    void paintEvent(QPaintEvent *event);

protected slots:
    void onUpdateSensor();  // degree and position
//    void onReadSerial();
public slots:
//    void onUpdateSensor();  // degree and position
    void onReadSerial();
public:
    QVector<QSerialPort*> m_pSerialInfo;
    QQueue<struct AnalysisData> m_qResult;
    QQueue<struct AnalysisData> m_qLocalResult;
     QVector<QQueue<double>> m_qOriginalData;
//    QVector<QVector<std::pair <double,double>>> points;
private:
    QVector<double> m_vSum;

    QVector<QSharedPointer<QSerialPort>> m_pSerial;
    QVector<QTimer*>      m_pSerialTimer;
//    局部数据
//    QQueue<double> m_vLocalCarPosition;
////    QQueue<double> m_vLocalHAngle;
//    QVector<QQueue<double>> m_vLocalAngle;
////    QQueue<double> m_vLocalPAngle;
////    vector<float> m_vLocalPayloadAngle;
//    QVector<double> m_vLocalForce;
//    经过处理后的数据


    QVector<bool>       m_bSerialConnected;

    QVector<int>         m_iSmoothWindowWidth;
    unsigned long original_time;
    double     m_dCartOriginalPos;
    bool       m_bIsGotOriginalPos;

//    unsigned long m_currentTime;
    double m_lastTime;

    AnalysisData m_lastData;

};

class QHBoxLayout;
class QGridLayout;
class QAbstractButton;
class QPushButton;
class QButtonGroup;
class QCustomPlot;
class QGraphicsView;

#endif // SENSORDATA_H
