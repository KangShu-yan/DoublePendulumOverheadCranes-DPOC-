#include "userwindow.h"

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
//#include "ui_userwindow.h"




UserWindow::UserWindow(QWidget *parent)
    : QWidget(parent)
//    ,ui(new Ui::UserWindow)
      ,m_pScrollWidget(nullptr)
    ,m_pControllerBase(nullptr)
    ,m_pSerialTimer(nullptr)
    ,m_pControlCycleTimer(nullptr)
    ,m_pSensorDataObserver(nullptr)
    ,m_pFile(nullptr)
    ,m_pTxtOutPut(nullptr)
    ,m_bRecordData(false)
    ,m_bComplete(false)

{

    this->setWindowIcon(QIcon(":/images/log.jpeg"));
//    满屏
//    this->setGeometry(10, 50, 1850, 1000);
//    小屏
    this->setGeometry(QRect(720, 360, 600, 660));
    this->setWindowTitle("Dual pendulum view");
    QRect screenRect = QGuiApplication::primaryScreen()->geometry();
//    scroll area
    QScrollArea* pScrollArea = new QScrollArea(this);
    pScrollArea->setVerticalScrollBarPolicy(Qt::ScrollBarAsNeeded);
    pScrollArea->setHorizontalScrollBarPolicy(Qt::ScrollBarAsNeeded);
    pScrollArea->setGeometry(0, 0, screenRect.width(), screenRect.height()-70);
    //set m_pScrollWidger to m_pScrollArea
    m_pScrollWidget = new QWidget(pScrollArea);
    m_pScrollWidget->setGeometry(0, 0, 800, 700);
    pScrollArea->setWidget(m_pScrollWidget);
    m_pMainVLayout = new QVBoxLayout();
    m_pHLayout = new QHBoxLayout();

//    add tools
    m_pBtnOpen = new QPushButton();
    m_pBtnSave = new QPushButton();
    m_pBtnSaveAs = new QPushButton();
    m_pBtnScreenshot = new QPushButton();

    m_pBtnInfo = new QPushButton();
    m_pBtnExit = new QPushButton();
    m_pToolHLayout = new QHBoxLayout();
//    QPixmap icon(tr(":/images/save.png"));
    m_pIcon = new QPixmap();
    m_pIcon->load(":/images/open.png");
    m_pBtnOpen->setIcon(*m_pIcon);
    m_pBtnOpen->setFlat(true);
    m_pBtnOpen->setIconSize(QSize(50,50));
    m_pBtnOpen->setToolTip("Open File");
//    m_pBtnOpen->setMinimumSize(40,40);
    m_pToolHLayout ->addWidget(m_pBtnOpen);


    m_pIcon->load(":/images/save.png");
    m_pBtnSave->setIcon(*m_pIcon);
    m_pBtnSave->setFlat(true);
    m_pBtnSave->setIconSize(QSize(50,50));
    m_pBtnSave->setToolTip("Save Data");
    connect(m_pBtnSave,SIGNAL(clicked()),this,SLOT(onSaveDataSlot()));
//    connect(m_pBtnOperationSerial,SIGNAL(clicked()), this, SLOT(onOpenCloseSerial()));
    // This is available in all editors.

//    m_pBtnSave->setMinimumSize(40,40);
    m_pToolHLayout ->addWidget(m_pBtnSave);

    m_pIcon->load(":/images/save_as.png");
    m_pBtnSaveAs->setIcon(*m_pIcon);
    m_pBtnSaveAs->setFlat(true);
    m_pBtnSaveAs->setIconSize(QSize(50,50));
    m_pBtnSaveAs->setToolTip("Save As");
//    m_pBtnSaveAs->setMinimumSize(40,40);
    m_pToolHLayout ->addWidget(m_pBtnSaveAs);

    m_pIcon->load(":/images/snapshot.png");
    m_pBtnScreenshot->setIcon(*m_pIcon);
    m_pBtnScreenshot->setFlat(true);
    m_pBtnScreenshot->setIconSize(QSize(50,50));
    m_pBtnScreenshot->setToolTip("Save As");
    m_pBtnScreenshot->setMinimumSize(30,30);
    m_pToolHLayout ->addWidget(m_pBtnScreenshot);

    connect(m_pBtnScreenshot,SIGNAL(clicked()),this,SLOT(onScreenshotSlot()));


    m_pIcon->load(":/images/info.png");
    m_pBtnInfo->setIcon(*m_pIcon);
    m_pBtnInfo->setFlat(true);
    m_pBtnInfo->setIconSize(QSize(50,50));
    m_pBtnInfo->setToolTip("More Information");
//    m_pBtnInfo->setMinimumSize(40,40);
    m_pToolHLayout ->addWidget(m_pBtnInfo);

    m_pIcon->load(":/images/exit.png");
    m_pBtnExit->setIcon(*m_pIcon);
    m_pBtnExit->setFlat(true);
    m_pBtnExit->setIconSize(QSize(50,50));
    m_pBtnExit->setToolTip("Exit Application");
//    m_pBtnInfo->setMinimumSize(40,40);
    m_pToolHLayout ->addWidget(m_pBtnExit);

    m_pSpacerItem = new QSpacerItem(50,50,QSizePolicy::Expanding,QSizePolicy::Minimum);
    m_pToolHLayout->addItem(m_pSpacerItem);


    m_pGridLayout = new QGridLayout();
//    添加曲线
     m_pCurveVLayout = new  QVBoxLayout();
    for(size_t i = 0;i<4;++i)
    {
        m_pCustomPlotWidget[i] = new QCustomPlot;
        m_pCustomPlotWidget[i]->resize(120, 80);
        m_pCurveVLayout->addWidget(m_pCustomPlotWidget[i]);
        m_pCustomPlotWidget[i]->show();
    }
    m_pHLayout ->addLayout(m_pCurveVLayout);
    makeplot();
        //    将曲线放进网格中

//    量化结果
    m_pGridAnalysis = new QGridLayout();
//    QTextCodec* cod=QTextCodec::codecForLocale();
    m_ppf = new QLabel();
//    QString mu(0x03BC);
//    mu = mu+"0x0394";
    m_ppf->setText("Pf:");
    m_pthetahMax = new QLabel();
//    mu.clear();mu = 0x
    m_pthetahMax->setText("Hook Max Angle:");
    m_pthetahRes = new QLabel();
    m_pthetahRes->setText("Hook Residual Angle:");
    m_pthetapMax = new QLabel();
    m_pthetapMax->setText("Payload Max angle:");
    m_pthetapRes = new QLabel();
    m_pthetapRes->setText("Payload Residual Angle:");
    m_pts = new QLabel();
    m_pts->setText("Regularization Time:");
    m_pFMax = new QLabel();
    m_pFMax->setText("Max Control Force:");
    m_ppower = new QLabel();
    m_ppower->setText("Consumed Power:");

//    m_ppf->setText(cod->toUnicode("Ω+2081"));
//    m_ppf = new QLabel(tr("<font color='black'><sub>2</sub>"));
//    将分析结果添加至网格
    m_pGridAnalysis->addWidget(m_ppf,0,0);
    m_pGridAnalysis->addWidget(m_pts,1,0);
    m_pGridAnalysis->addWidget(m_pFMax,2,0);
    m_pGridAnalysis->addWidget(m_ppower,3,0);
    m_pGridAnalysis->addWidget(m_pthetahMax,4,0);
    m_pGridAnalysis->addWidget(m_pthetahRes,5,0);
    m_pGridAnalysis->addWidget(m_pthetapMax,6,0);
    m_pGridAnalysis->addWidget(m_pthetapRes,7,0);
//    serial show
    m_pGridSerial = new QGridLayout();
    m_pSerialChoose =  new QLabel("Choose Serial");
    m_pBaudrate = new QLabel("Serial Baudrate");
    m_pStopBit = new QLabel("Stop Bit");
    m_pDataBit = new QLabel("Data Bit");
    m_pCRC = new QLabel("CRC");
    m_pOperation = new QLabel("Operation");




    size_t SerialNum = 2;
    m_pCBSerialChoose.resize(SerialNum);
    for(size_t i = 0;i<SerialNum;++i)
    {
        m_pCBSerialChoose[i] = new QComboBox();
//        m_pCBSerialChoose[i]->show();
        connect( m_pCBSerialChoose[i] ,SIGNAL(highlighted(int)), this, SLOT(onHighLightedSerialCBSlot(int)));


    }
    m_pCBBaudrate = new QComboBox();
    m_pCBStopBit = new QComboBox();
    m_pCBDataBit = new QComboBox();
    m_pCBCRC = new QComboBox();
    m_pBtnOperationSerial = new QPushButton("Open Serial");
    m_pBtnOperationSerial->setToolTip("Open Serial");
    m_pIcon->load(":/images/serial_off.png");
    m_pBtnOperationSerial->setIcon(*m_pIcon);
    connect(m_pBtnOperationSerial,SIGNAL(clicked()), this, SLOT(onOpenCloseSerial()));


//    m_pBtnOperationSerial->setStyleSheet("text-align:justify;");

//    m_pCBBaudrate->show();
//    m_pCBStopBit->show();
//    m_pCBDataBit->show();
//    m_pCBCRC->show();


    m_pCBBaudrate->insertItem(0, "Self Definition");
    m_pCBBaudrate->insertItem(1, "921600");
    m_pCBBaudrate->insertItem(2, "115200");
    m_pCBBaudrate->insertItem(3, "19200");
    m_pCBBaudrate->insertItem(4, "9600");
    m_pCBBaudrate->setCurrentIndex(2);

    m_pCBStopBit->insertItem(0, "1");
    m_pCBStopBit->insertItem(1, "1.5");
    m_pCBStopBit->insertItem(2, "2");

    m_pCBDataBit->insertItem(0, "8");
    m_pCBDataBit->insertItem(1, "7");
    m_pCBDataBit->insertItem(2, "6");
    m_pCBDataBit->insertItem(3, "5");

    m_pCBCRC->insertItem(0, "No Parity");
    m_pCBCRC->insertItem(1, "Odd Parity");
    m_pCBCRC->insertItem(2, "Even Parity");

    m_pSerialCBHLayout = new QHBoxLayout();
    m_pSerialCBHLayout->addWidget(m_pCBSerialChoose[0]);
    m_pSerialCBHLayout->addWidget(m_pCBSerialChoose[1]);


    m_pGridSerial->addWidget(m_pSerialChoose,0,0);
    m_pGridSerial->addLayout(m_pSerialCBHLayout,0,1);
    m_pGridSerial->addWidget(m_pBaudrate,1,0);
    m_pGridSerial->addWidget(m_pCBBaudrate,1,1);
    m_pGridSerial->addWidget(m_pStopBit,2,0);
    m_pGridSerial->addWidget(m_pCBStopBit,2,1);
    m_pGridSerial->addWidget(m_pDataBit,3,0);
    m_pGridSerial->addWidget(m_pCBDataBit,3,1);
    m_pGridSerial->addWidget(m_pCRC,4,0);
    m_pGridSerial->addWidget(m_pCBCRC,4,1);
    m_pGridSerial->addWidget(m_pOperation,5,0);
    m_pGridSerial->addWidget(m_pBtnOperationSerial,5,1);

//    控制器选择
    m_pCfgVLayout = new QVBoxLayout();
    m_pCtrChoose = new QLabel("Controller");
    m_pCBController = new QComboBox();
//    m_pCBController->show();
    m_pCBController->setMaximumWidth(200);
    m_pCBController->insertItem(0, "Linear Quadrautic Regulator");
    m_pCBController->insertItem(1, "Feedback with Trajectory Planning");
    m_pCBController->insertItem(2, "Enhanced Coupling with Partial Feedback");
    m_pCBController->insertItem(3, "Enhanced Coupling by Energy Analysis");
    m_pCBController->insertItem(4, "Combined Sliding Mode");
    m_pCBController->insertItem(5, "Proportional Integral Differential ");
    m_pCBController->setCurrentIndex(5);

    connect(m_pCBController, SIGNAL(currentIndexChanged(int)), this, SLOT(onControllerChanged(int)));


    m_pCtrChooseHLayout = new QHBoxLayout();
    m_pCtrChooseHLayout->addWidget(m_pCtrChoose);
    m_pCtrChooseHLayout->addWidget(m_pCBController);
//    physical parmeters
    m_pGridCtrPhyParams = new QGridLayout();
    m_pmc = new QLabel("Mc(Kg)");
    m_pmh = new QLabel("Mh(kg)");
    m_pmp = new QLabel("Mp(Kg)");
    m_plh = new QLabel("Lh(m)");
    m_plp = new QLabel("Lp(m)");
    m_pdh = new QLabel("Dh");
    m_pdp = new QLabel("Dp");
    m_pEpsilonx = new QLabel("Ex");
    m_pKrx = new QLabel("Krx");
    m_pFrx = new QLabel("Frx");
    m_pTs = new QLabel("Ts(s)");
     m_pUmax = new QLabel("UMax(N)");
     m_pXd = new QLabel("Xd(m)");
    m_pVd = new QLabel("Vd(m/s)");
    m_pVd->hide();

    m_pLEmc = new QLineEdit("1.3351");
    m_pLEmh = new QLineEdit("0.164");
    m_pLEmp = new QLineEdit("0.08");
    m_pLElh = new QLineEdit("0.3");
    m_pLElp = new QLineEdit("0.1");
    m_pLEdh = new QLineEdit("0.03");
    m_pLEdp = new QLineEdit("0.03");
    m_pLEEpsilonx = new QLineEdit("0.01");
    m_pLEFrx = new QLineEdit("1");
    m_pLEKrx = new QLineEdit("-0.5");
    m_pLETs = new QLineEdit("0.01");
    m_pLEUmax = new QLineEdit("180");
    m_pLEXd= new QLineEdit("0.3");
    m_pLEVd= new QLineEdit("0.05");


    m_pLEmc->setMaximumWidth(40);
    m_pLEmh->setMaximumWidth(40);
    m_pLEmp->setMaximumWidth(40);
    m_pLElh->setMaximumWidth(40);
    m_pLElp->setMaximumWidth(40);
    m_pLEdh->setMaximumWidth(40);
    m_pLEdp->setMaximumWidth(40);
    m_pLEEpsilonx->setMaximumWidth(40);
    m_pLEKrx->setMaximumWidth(40);
    m_pLEFrx->setMaximumWidth(40);
    m_pLETs->setMaximumWidth(40);
    m_pLEUmax->setMaximumWidth(40);
    m_pLEXd->setMaximumWidth(40);
    m_pLEVd->setMaximumWidth(40);
    m_pLEVd->hide();

    m_pGridCtrPhyParams->addWidget(m_pmc,0,0);
    m_pGridCtrPhyParams->addWidget(m_pLEmc,0,1);
    m_pGridCtrPhyParams->addWidget(m_pmh,0,2);
    m_pGridCtrPhyParams->addWidget(m_pLEmh,0,3);
    m_pGridCtrPhyParams->addWidget(m_pmp,0,4);
    m_pGridCtrPhyParams->addWidget(m_pLEmp,0,5);
    m_pGridCtrPhyParams->addWidget(m_plh,1,0);
    m_pGridCtrPhyParams->addWidget(m_pLElh,1,1);
    m_pGridCtrPhyParams->addWidget(m_plp,1,2);
    m_pGridCtrPhyParams->addWidget(m_pLElp,1,3);
    m_pGridCtrPhyParams->addWidget(m_pdh,1,4);
    m_pGridCtrPhyParams->addWidget(m_pLEdh,1,5);
    m_pGridCtrPhyParams->addWidget(m_pdp,2,0);
    m_pGridCtrPhyParams->addWidget(m_pLEdp,2,1);
    m_pGridCtrPhyParams->addWidget(m_pEpsilonx,2,2);
    m_pGridCtrPhyParams->addWidget(m_pLEEpsilonx,2,3);

    m_pGridCtrPhyParams->addWidget(m_pKrx,2,4);
    m_pGridCtrPhyParams->addWidget(m_pLEKrx,2,5);

    m_pFrxHLayout = new QHBoxLayout();
    m_pFrxHLayout->addWidget(m_pFrx);
    m_pFrxHLayout->addWidget(m_pLEFrx);
    m_pFrxHLayout->addWidget(m_pTs);
    m_pFrxHLayout->addWidget(m_pLETs);
    m_pFrxHLayout->addWidget(m_pUmax);
    m_pFrxHLayout->addWidget(m_pLEUmax);

    m_pXdHLayout = new QHBoxLayout();
    m_pXdHLayout->addWidget(m_pXd);
    m_pXdHLayout->addWidget(m_pLEXd);
    m_pXdHLayout->addWidget(m_pVd);
    m_pXdHLayout->addWidget(m_pLEVd);


    m_pGridCtrPhyGains =new QGridLayout();
    int GainNum = 10;
    m_pGains.resize(GainNum);
    m_pLEGains.resize(GainNum);
    for(int i =0;i<GainNum;++i)
    {
        QString str = "K";
        str.push_back(QString::number(i+1,10));
        m_pGains[i] = new QLabel(str);
        m_pLEGains[i] = new QLineEdit("0");
        m_pLEGains[i]->setMaximumWidth(40);

        m_pGridCtrPhyGains->addWidget(m_pGains[i],static_cast<int>(i/3),static_cast<int>((i%3)*2));
        m_pGridCtrPhyGains->addWidget(m_pLEGains[i],static_cast<int>(i/3),static_cast<int>(i%3*2+1));
        if(i>=3){m_pGains[i]->hide();m_pLEGains[i]->hide();}
    }

//    configuration
    m_pMenuBar = new QMenuBar();

    QDateTime curDateTime=QDateTime::currentDateTime();
    QString date = curDateTime.toString("yyyy-MM-dd hh:mm:ss");
    m_pStatus = new  QLabel(date);
    m_pStatusBar = new QStatusBar();
    m_pStatus->setMaximumHeight(20);
    m_pStatusBar->setMaximumHeight(20);
    m_pStatusBar->addWidget(m_pStatus);

    m_pCfgVLayout->addLayout(m_pGridSerial);
//    m_pCfgVLayout->addLayout(m_pGridSerial);
    m_pCfgVLayout->addLayout(m_pCtrChooseHLayout);
    m_pCfgVLayout->addLayout(m_pGridCtrPhyParams);
    m_pCfgVLayout->addLayout(m_pFrxHLayout);
     m_pCfgVLayout->addLayout(m_pXdHLayout);
    m_pCfgVLayout->addLayout(m_pGridCtrPhyGains);
//    添加至网格
    m_pBtnRunController = new QPushButton("Run Controller");
    QPixmap icon(tr(":/images/play.png"));
    m_pBtnRunController->setIcon(icon);
    m_pBtnRunController->setToolTip("Run Controller");
    connect(m_pBtnRunController, SIGNAL(clicked()), this, SLOT(onRunControllerButton()));

    m_pBtnRecordData = new QPushButton();
    m_pIcon->load(tr(":/images/recordfill.png"));
    m_pBtnRecordData->setIcon(*m_pIcon);
    m_pBtnRecordData->setFlat(true);
    m_pBtnRecordData->setToolTip("Record Data");
    m_pBtnRecordData->setMaximumWidth(30);
    connect(m_pBtnRecordData, SIGNAL(clicked()), this, SLOT(onRecordDataSlot()));

    m_pBtnResetData = new QPushButton();
    m_pIcon->load(tr(":/images/reset.png"));
    m_pBtnResetData->setIcon(*m_pIcon);
    m_pBtnResetData->setFlat(true);
    m_pBtnResetData->setToolTip("Reset Data");
    m_pBtnResetData->setMaximumWidth(30);
    connect(m_pBtnResetData, SIGNAL(clicked()), this, SLOT(onBtnResetData()));

    m_pRunHLayout = new QHBoxLayout();
    m_pRunHLayout->addWidget(m_pBtnRecordData);
    m_pRunHLayout->addWidget(m_pBtnResetData);
    m_pRunHLayout->addWidget(m_pBtnRunController);

    m_pCfgVLayout-> addLayout(m_pRunHLayout);
    m_pCfgVLayout-> addLayout(m_pGridAnalysis);


    m_pHLayout->setStretchFactor(m_pCurveVLayout,3);
    m_pHLayout->setStretchFactor(m_pCfgVLayout,1);
    m_pHLayout ->addLayout(m_pCfgVLayout);

    m_pMainVLayout->addLayout(m_pToolHLayout);
    m_pMainVLayout->addLayout(m_pHLayout);
//    m_pMainVLayout->addLayout(m_pAnalysisHLayout);
    m_pMainVLayout->addWidget(m_pStatusBar);
    m_pScrollWidget->setLayout(m_pMainVLayout);
    auto mainLayout = new QGridLayout;
    mainLayout->addWidget(m_pScrollWidget);
    setLayout(mainLayout);

    m_pSensorDataObserver = new SensorDataObserver(m_pScrollWidget);
    for(int i = 0;i<m_pSensorDataObserver->m_pSerialInfo.size();++i)
    {
         this->m_pCBSerialChoose[0]->addItem(m_pSensorDataObserver->m_pSerialInfo[i]->portName());
         this->m_pCBSerialChoose[1]->addItem(m_pSensorDataObserver->m_pSerialInfo[i]->portName());
    }
    m_pControlCycleTimer = new QTimer();
    connect(m_pControlCycleTimer, SIGNAL(timeout()), this, SLOT(onRealtimeControlSlot()));
//    QString csvFileName = QCoreApplication::applicationDirPath()+QDateTime::currentDateTime().toString("yyyyMMddhhmmss")+".csv";
//#if DEBUG
//    qDebug()<<"csvFileName: "<<csvFileName;
//#endif
//    m_pFile = new QFile(csvFileName);
//    m_pTxtOutPut = new QTextStream(m_pFile);
//    m_pFile->open(QIODevice::WriteOnly | QIODevice::Append); //只写 与 添加 打开
//    *m_pTxtOutPut<<"Time(s)"<<","<<"Cart Position(m)"<<","<<"Hook Angle(deg)"<<","<<"Payload Angle(deg)"<<"\r\n";
//    m_pTxtOutPut->flush();
    lastData.carPosition =0;
    lastData.carVelocity=0;
    lastData.hookAngle = 0;
    lastData.payloadAngle = 0;
    lastData.Force = 0;
    onControllerChanged(5);
}

UserWindow::~UserWindow()
{

//    if (m_pSensorDataObserver)
//    {
//        delete m_pSensorDataObserver;
//        m_pSensorDataObserver = nullptr;
//    }


}

void UserWindow::resizeEvent(QResizeEvent *)
{
    //cout << "CeleX5Widget::resizeEvent" << endl;
}

void UserWindow::closeEvent(QCloseEvent *)
{
#if DEBUG
    qDebug()<<"closeEvent";
#endif
    dataTimer.stop();
    m_bRecordData = false;
    if(m_pFile!=nullptr)
    {
        if(m_pFile->isOpen())m_pFile->close();
        delete m_pFile;
        m_pFile = nullptr;
    }
    if(m_pTxtOutPut!=nullptr)
    {
#if DEBUG
//    qDebug()<<"m_pTxtOutPut";
#endif
        m_pTxtOutPut->flush();
        delete m_pTxtOutPut;
        m_pTxtOutPut = nullptr;
    }
    if(m_pSerialTimer)
    {
        if(m_pSerialTimer->isActive())m_pSerialTimer->stop();
        delete m_pSerialTimer;
        m_pSerialTimer = nullptr;
    }
    if(m_pControlCycleTimer)
    {
#if DEBUG
//    qDebug()<<"m_pControlCycleTimer";
#endif
        if(m_pControlCycleTimer->isActive())m_pControlCycleTimer->stop();
        delete m_pControlCycleTimer;
        m_pControlCycleTimer=nullptr;
    }
    if (m_pSensorDataObserver)
    {
        m_pSensorDataObserver->rstALL();
        delete m_pSensorDataObserver;
        m_pSensorDataObserver = nullptr;
    }
    if(m_pControllerBase)
    {
        delete m_pControllerBase;
        m_pControllerBase = nullptr;
    }
}
void UserWindow::onHighLightedSerialCBSlot(int i)
{
#if DEBUG
//    qDebug()<<"onHighLightedSerialCBSlot";
#endif
}
void UserWindow::playback(QPushButton *pButton)
{
    if ("Playback" == pButton->text())
    {
        QString filePath = QFileDialog::getOpenFileName(this, "Open a bin file", QCoreApplication::applicationDirPath(), "Bin Files (*.bin)");

        if (filePath.isEmpty())
            return;

    }
}



void UserWindow::makeplot(){
//#if DEBUG
//    qDebug()<<"make plot ";
//#endif

    // 存储600点过去的数据
    for(size_t  i = 0;i<4;++i)
    {
        m_pCustomPlotWidget[i]->addGraph(); // blue line
          m_pCustomPlotWidget[i]->graph(0)->setPen(QPen(QColor(40, 110, 255)));
          QSharedPointer<QCPAxisTickerTime> timeTicker(new QCPAxisTickerTime);
          timeTicker->setTimeFormat("%h:%m:%s");
          m_pCustomPlotWidget[i]->xAxis->setTicker(timeTicker);
          m_pCustomPlotWidget[i]->axisRect()->setupFullAxesBox();
          if(i==0)
            m_pCustomPlotWidget[i]->yAxis->setRange(-0.1, 0.1);
          else
              m_pCustomPlotWidget[i]->yAxis->setRange(-1, 1);

          this->m_pCustomPlotWidget[i]->xAxis->setLabel("Times[s]");
           m_pCustomPlotWidget[i]->legend->setVisible(true);
          m_pCustomPlotWidget[i]->axisRect()->setupFullAxesBox(true);
          this->m_pCustomPlotWidget[i]->setInteractions(QCP::iRangeDrag|QCP::iRangeZoom);

//          int nowtime = QTime::currentTime().msecsSinceStartOfDay();
//           this->m_pCustomPlotWidget[i]->xAxis->setRange((nowtime-10000)*0.001,nowtime*0.001);
//          this->m_pCustomPlotWidget[i]->rescaleAxes(true);
//          this->m_pCustomPlotWidget[i]->graph(0)->rescaleValueAxis(true, true);

          // make left and bottom axes transfer their ranges to right and top axes:
          connect(m_pCustomPlotWidget[i]->xAxis, SIGNAL(rangeChanged(QCPRange)), m_pCustomPlotWidget[i]->xAxis2, SLOT(setRange(QCPRange)));
          connect(m_pCustomPlotWidget[i]->yAxis, SIGNAL(rangeChanged(QCPRange)), m_pCustomPlotWidget[i]->yAxis2, SLOT(setRange(QCPRange)));

//          connect(m_pCustomPlotWidget[i], SIGNAL(mouseWheel(QWheelEvent*)), this, SLOT(mouseWheelSlot()));


    }

    // setup a timer that repeatedly calls MainWindow::realtimeDataSlot:

    connect(&dataTimer, SIGNAL(timeout()), this, SLOT(onRealtimeDataSlot()));
    dataTimer.start(20); // Interval 0 means to refresh as fast as possible

     this->m_pCustomPlotWidget[0]->yAxis->setLabel(tr("x"));
     this->m_pCustomPlotWidget[1]->yAxis->setLabel(tr("α"));
     this->m_pCustomPlotWidget[2]->yAxis->setLabel(tr("β"));
     this->m_pCustomPlotWidget[3]->yAxis->setLabel(tr("u"));

}
void UserWindow::mouseWheelSlot()
{


}
void UserWindow::yAxisChanged(QCPRange range)
{
//#if DEBUG
//    qDebug()<<" range.center(): "<<range.center()<<"  range.size(): "<<range.size();
//#endif
//    m_pCustomPlotWidget[i]->yAxis->setRange();

}
void UserWindow::xAxisChanged(QCPRange range){
#if DEBUG
//    qDebug()<<"xAxisChanged ";
#endif
}
//实时显示到曲线
void UserWindow::onRealtimeDataSlot()
{
#if DEBUG
//    qDebug()<<"On realtime data slot";
#endif
    static QVector<QQueue<int>> vLocalMax(4);
    static QVector<QQueue<int>> vLocalMin(4);
    static QTime time(QTime::currentTime());
    static int  cnt = 0;
      // calculate two new data points:
      double key = time.elapsed()/1000.0; // time elapsed since start of demo, in seconds
#if DEBUG
//    qDebug()<<"key: "<< key;
#endif
      static double lastPointKey = 0;
     if(m_pSensorDataObserver->m_qLocalResult.empty())return;
     if(!m_bComplete)return;
     m_bComplete = false;
     AnalysisData data = m_pSensorDataObserver->m_qLocalResult.front();

     double val=0, ctime  = key,carPosition = data.carPosition,hookAngle = data.hookAngle*360/2/pi;
     double payloadAngle = data.payloadAngle*180/pi,force = data.Force;

      for(int i= 0;i<4;++i)
      {
          if (key-lastPointKey > 0.002) // at most add point every 2 ms
          {
            // add data to lines:
              if(i==0)
              {
                  val = carPosition;
#if DEBUG
//    qDebug()<<"position: "<< carPosition;
#endif
              }
              else if(i==1) {val = hookAngle;
                #if DEBUG
//                     qDebug()<<"hookAngle: "<< val;
                #endif
              }
              else if(i==2){
                  val = payloadAngle;
#if DEBUG
//     qDebug()<<"payloadAngle: "<< val;
#endif
              }
              else if(i==3) val = force;

            m_pCustomPlotWidget[i]->graph(0)->addData(key, val);
            m_pCustomPlotWidget[i]->graph()->setName(QString::number(val,'f',6)); // set the name
            this->m_pCustomPlotWidget[i]->graph(0)->rescaleAxes();
#if DEBUG
//            qDebug()<<"val = "<<val ;
#endif
            int minTop = -1;if(i==0)minTop = 0;
            if(!vLocalMin[i].empty())minTop = vLocalMin[i].back();
            int maxTop = 1; if(i==0)maxTop = 0;
            if(!vLocalMax[i].empty())maxTop = vLocalMax[i].back();
            vLocalMin[i].push_back(val<minTop?static_cast<int>(val):minTop);
            vLocalMax[i].push_back(val>maxTop?static_cast<int>(val):maxTop);

            if(vLocalMax[i].size()>200)vLocalMax[i].pop_front();
            if(vLocalMin[i].size()>200)vLocalMin[i].pop_front();

          }
          // make key axis range scroll with the data (at a constant range size of 8):
          m_pCustomPlotWidget[i]->xAxis->setRange(key, 15, Qt::AlignRight);
          if(!vLocalMin[i].empty()&&!vLocalMax[i].empty())
          {
#if DEBUG
//              qDebug()<<"vLocalMin[i].front(): "<<vLocalMin[i].front()<<" vLocalMax[i].front(): "<<vLocalMax[i].front();
#endif

              if(i==0)
              {
//                  if(m_pCBController->currentIndex()==5)m_pCustomPlotWidget[i]->yAxis->setRange(vLocalMin[i].front()-0.035, vLocalMax[i].back()+0.035);
//                  else
                  m_pCustomPlotWidget[i]->yAxis->setRange(vLocalMin[i].front()-0.2, vLocalMax[i].back()+0.2);
              }
              else
                  m_pCustomPlotWidget[i]->yAxis->setRange(vLocalMin[i].front()-1, vLocalMax[i].back()+1);
              vLocalMax[i].pop_front();
              vLocalMin[i].pop_front();
          }
          m_pCustomPlotWidget[i]->replot();
      }
#if DEBUG
//          qDebug()<<"m_bRecordData: "<<m_bRecordData;
#endif
      if(m_bRecordData)
      {
#if DEBUG
//          qDebug()<<"m_bRecordData";
#endif
          ++cnt;
          *m_pTxtOutPut<<ctime<<","<<carPosition<<","<<hookAngle<<","<<payloadAngle<<","<<force<<"\r\n";
          if(cnt%100==0)m_pTxtOutPut->flush();
      }
      lastPointKey = key;

      if(!m_pSensorDataObserver->m_qLocalResult.empty())m_pSensorDataObserver->m_qLocalResult.pop_front();
}

void UserWindow::onRunControllerButton()
{
    if(m_pBtnRunController->toolTip()=="Run Controller")
//    if(m_pBtnRunController->text()=="Run Controller")  //Run Controller
    {
#if DEBUG
    qDebug()<<"On control run";
#endif

//        if(m_pSerialTimer&&m_pSerialTimer->isActive())
//        {
//#if DEBUG
////    qDebug()<<"m_pSerialTimer is active ";
//#endif
        //        或将废弃
//            m_pSerialTimer->stop();
//            m_pControlCycleTimer->start(10); //10ms
//        }
//        else
//        {
//            QMessageBox::about(nullptr, "提示", "串口没有打开！");
//            return;
//        }
        if(!m_pSensorDataObserver->initGts())
        {
#if DEBUG
    qDebug()<<"init Gts unsuccessfully ";
#endif

            return;
        }
//        Sleep(10);
        m_pControlCycleTimer->start(static_cast<int>(m_pLETs->text().toDouble()*1000)); //10ms
        if(!m_pConcreteCtr)m_pConcreteCtr =QSharedPointer<ConcreteControl>::create();
        struct PhysicalParameters params;
        params.m_c = m_pLEmc->text().toDouble();
        params.m_h = m_pLEmh->text().toDouble();
        params.m_p = m_pLEmp->text().toDouble();
        params.l_h = m_pLElh->text().toDouble();
        params.l_p = m_pLElp->text().toDouble();
        params.d_h = m_pLEdh->text().toDouble();
        params.d_p = m_pLEdp->text().toDouble();
        params.epsilonx = m_pLEEpsilonx->text().toDouble();
        params.k_rx = m_pLEKrx->text().toDouble();
        params.f_rx = m_pLEFrx->text().toDouble();
        params.Ts = m_pLETs->text().toDouble();
        params.x_d = m_pLEXd->text().toDouble();
        params.v_d = m_pLEVd->text().toDouble();

#if DEBUG
//    qDebug()<<"params.Ts: "<<params.Ts;
#endif
        params.max_u= m_pLEUmax->text().toDouble();
        QVector<double> gains;
        int len = m_pGains.size();
        gains.resize(len);
        for(int j = 0;j<len;++j)gains[j] = m_pLEGains[j]->text().toDouble();
        int  i = m_pCBController->currentIndex();
        if(m_pControllerBase!=nullptr) delete m_pControllerBase;
         m_pControllerBase = m_pConcreteCtr->createController(i,  params,  gains);

        m_pBtnRunController->setText("Stop Controller");
        m_pBtnRunController->setToolTip("Stop Controller");
        m_pIcon->load(":/images/pause.png");
        m_pBtnRunController->setIcon(*m_pIcon);
    }
    else
    {
        m_pBtnRunController->setText("Run Controller");
        m_pBtnRunController->setToolTip("Run Controller");
        m_pIcon->load(":/images/play.png");
        m_pBtnRunController->setIcon(*m_pIcon);
        m_pSensorDataObserver->rstGts();
        if(m_pSerialTimer&&!m_pSerialTimer->isActive())m_pSerialTimer->start(10);
        if(m_pControlCycleTimer)m_pControlCycleTimer->stop();
    }

}

void UserWindow::onRealtimeSerialSlot()
{
    m_pSensorDataObserver->onReadSerial();
#if DEBUG
    qDebug()<<"On realtime serial ";
#endif
}

void UserWindow::onRealtimeControlSlot()
{
#if DEBUG
//    qDebug()<<"On realtime control slot ";
#endif
//    static
//    读取串口数据
    m_pSensorDataObserver->onReadSerial();
//    使用检测数据
    if(m_pSensorDataObserver->m_qLocalResult.empty())return;
    AnalysisData data = m_pSensorDataObserver->m_qLocalResult.front();
    double Ts =m_pControllerBase->Ts;
    double x = data.carPosition;
    double dotx  = data.carVelocity;
//            (data.carPosition-lastData.carPosition)/Ts;
//    m_pSensorDataObserver->smoothData(dotx,1);

//    if(m_pCBController->currentIndex()==5)m_pSensorDataObserver->m_qLocalResult.front().carPosition = dotx;  // 只是为了实验用
    double theta_h = data.hookAngle;
    double dottheta_h = data.hookAngleVelocity;
//            (data.hookAngle-lastData.hookAngle)/Ts;
    double theta_p = data.payloadAngle;
    double dottheta_p = data.payloadAngleVelocity;
//            (data.payloadAngle-lastData.payloadAngle)/Ts;

  double force =m_pControllerBase->updateControl(x,dotx,theta_h,dottheta_h,theta_p,dottheta_p);

  m_pSensorDataObserver->m_qLocalResult.front().Force = force;
//  m_pSensorDataObserver->m_qLocalResult.front().carVelocity = dotx;
  m_pSensorDataObserver->m_qResult.push_back( m_pSensorDataObserver->m_qLocalResult.front());

  if(m_pSensorDataObserver->m_qResult.size()>800)m_pSensorDataObserver->m_qResult.pop_front();
#if DEBUG
  qDebug()<<"x: "<< x<<" dotx: "<<dotx<<" force: "<<force;
//  qDebug()<< "Ts: "<<Ts<<" force: "<< force<< " m_pSensorDataObserver->m_qResult.back().carVelocity "<< m_pSensorDataObserver->m_qResult.back().carVelocity ;
//  qDebug()<<"m_pSensorDataObserver->m_qResult.back().Force: "<<m_pSensorDataObserver->m_qResult.back().Force;
#endif
//  force = 0;
  m_pSensorDataObserver->setGtsDac(force);
  m_bComplete = true;
    lastData = data;
}




void UserWindow::onOpenCloseSerial()
{
//#if DEBUG
//    qDebug()<<"On open or close serial ";
//#endif
    if(m_pBtnOperationSerial->text()=="Open Serial")
    {
//#if DEBUG
//    qDebug()<<"openSerial";
//#endif
        QVector<QString> portName{m_pCBSerialChoose[0]->currentText(),m_pCBSerialChoose[1]->currentText()};
        QString baudrate = m_pCBBaudrate->currentText();
        QString stopBit = m_pCBStopBit->currentText();
        QString dataBit = m_pCBDataBit->currentText();
        QString crc = m_pCBCRC->currentText();
        m_pSensorDataObserver->openSerial(portName,baudrate,stopBit,dataBit,crc);

        if(!m_pSerialTimer)m_pSerialTimer = new QTimer();
        connect(m_pSerialTimer, SIGNAL(timeout()), this, SLOT(onRealtimeSerialSlot()));
        m_pSerialTimer->start(10); // 10ms

    }
    else
    {
        if(m_pSerialTimer->isActive())m_pSerialTimer->stop();
        m_pSensorDataObserver->closeSerial();
//#if DEBUG
//    qDebug()<<"openSerial";
//#endif
    }
    bool aSerial=false,bSerial = false;

    m_pSensorDataObserver->serialState(aSerial,bSerial);
//#if DEBUG
//    qDebug()<< "aSerial: "<< aSerial<<" bSerial: "<< bSerial;
//#endif
    if(aSerial|bSerial)
    {

        m_pBtnOperationSerial->setText("Close Serial");
        m_pBtnOperationSerial->setToolTip("Close Serial");
        m_pIcon->load(":/images/serial_on.png");
        m_pBtnOperationSerial->setIcon(*m_pIcon);
    }
    else {
        m_pBtnOperationSerial->setText("Open Serial");
         m_pBtnOperationSerial->setToolTip("Open Serial");
        m_pIcon->load(":/images/serial_off.png");
        m_pBtnOperationSerial->setIcon(*m_pIcon);
    }

}

void UserWindow::onButtonClicked(QAbstractButton *button)
{
//    cout << "MainWindow::onButtonClicked: " << button->objectName().toStdString() << endl;
}


void UserWindow::onRecordDataTimer()
{
//    if (!m_pRecordDataTimer->isActive())
//        return;

//    m_pCeleX5->stopRecording();
//    //
//    const QDateTime now = QDateTime::currentDateTime();
//    const QString timestamp = now.toString(QLatin1String("yyyyMMdd_hhmmsszzz"));
//    QString qstrBinName;
//    if (CeleX5::CeleX5_OpalKelly != m_emDeviceType)
//    {
//        qstrBinName = QCoreApplication::applicationDirPath() + "/MipiData_" + timestamp;
//    }
//    else
//    {
//        qstrBinName = QCoreApplication::applicationDirPath() + "/ParaData_" + timestamp;
//    }
//    QStringList modeList;
//    modeList << "_E_" << "_EO_" << "_EI_" << "_F_" << "_FO1_" << "_FO2_" << "_FO3_" << "_FO4_";
//    if (m_pCeleX5->isLoopModeEnabled())
//        qstrBinName += "_Loop_";
//    else
//        qstrBinName += modeList.at(int(m_pCeleX5->getSensorFixedMode()));

//    qstrBinName += QString::number(m_pCeleX5->getClockRate());
//    qstrBinName += "M.bin"; //MHz
//    std::string filePath = qstrBinName.toStdString();
//    m_pCeleX5->startRecording(filePath);
}
void UserWindow::onControlMethodChanged(QString text)
{
    qDebug()<<text;
}


void UserWindow::onBtnSavePicReleased()
{
//    if (m_pSensorDataObserver->isSavingBmp())
//    {
//        m_pSensorDataObserver->setSaveBmp(false);
//        m_pBtnSavePic->setText("Start Saving Pic");
//        m_pBtnSavePic->setStyleSheet("QPushButton {background: #002F6F; color: white; "
//                                     "border-style: outset; border-width: 2px; border-radius: 10px; border-color: #002F6F; "
//                                     "font: 20px Calibri; }"
//                                     "QPushButton:pressed {background: #992F6F;}");
//    }
//    else
//    {
//        m_pSensorDataObserver->setSaveBmp(true);
//        m_pBtnSavePic->setText("Stop Saving Pic");
//        m_pBtnSavePic->setStyleSheet("QPushButton {background: #992F6F; color: yellow; "
//                                     "border-style: outset; border-width: 2px; border-radius: 10px; border-color: #002F6F; "
//                                     "font: 20px Calibri; }"
//                                     "QPushButton:pressed {background: #992F6F; }");
//    }
}


void UserWindow::onControllerChanged(int i)
{
    int n = m_pLEGains.size(),m = n;
    switch(i)
    {
//    simple LQR
        case 0:
            n = 7;break;
//    LQR with trajectory planning using bvp, which is designed by kang shu
        case 1:
            n = 8;break;
//enhanced-coupling based on  partial feedback control ,which is designed by kang shu
        case 2:
            n = 5;break;
//enhanced-coupling based  on energy analysis ,which is designed by meng hua zhang
        case 3:
            n = 8;break;
//combined sliding mode designed by Le Anh Tuan
        case 4:
            n = 5;break;
// proportional integral differential, which  is only used fo regulate velocity of motor
        case 5:
            n = 3;
            m_pVd->show();
            m_pLEVd->show();
            break;
    default:
        break;
    }
    for(int j = 0;j<m;++j)
    {
        if(j<n)
        {
            m_pGains[j]->show();
            m_pLEGains[j]->show();
        }else
        {
            m_pGains[j]->hide();
            m_pLEGains[j]->hide();
        }
    }
}

void UserWindow::onSaveDataSlot()
{
////
//    //保存数据的文件路径
//     QString csvFileName = QCoreApplication::applicationDirPath()+QDateTime::currentDateTime().toString("yyyy.MM.dd hh:mm:ss.zzz")+".csv";
////             QFileDialog::getSaveFileName(this, "保存设置", ".", "csv files(*.csv)");  //选择保存位置，编辑文件名称

//      m_file.setFileName(csvFileName);

//     if (!m_file.exists())  //文件不存在时新建
//     {
//          m_file.open(QIODevice::WriteOnly);
//          m_pTxtOutPut.
//          m_txtOutPut(&m_file);
//          //标题
//    //      txtOutPut << "Unit(%)\n";
//          txtOutPut << "Time(s),Cart Position(m),Hook Angle(deg),Paylaod Angle(deg)\n"; //注意，每行数据结束后要加换行符
////          m_file.close();
//     }
//     m_file.open(QIODevice::WriteOnly | QIODevice::Append);
//     QTextStream txtOutPut(&m_file);

//    if(m_pBtnSave->toolTip()=="Save Data")
//    {
//        m_pBtnSave->setToolTip("Stop Save Data");

//    }
//    else {
//        m_pBtnSave->setToolTip("Save Data");

//    }



}
void UserWindow::onScreenshotSlot()
{
#if DEBUG
    qDebug()<<"onScreenshotSlot()";
#endif

#if QT_VERSION < QT_VERSION_CHECK(5, 0, 0)
  QPixmap pm = QPixmap::grabWindow(qApp->desktop()->winId(), this->x()+2, this->y()+2, this->frameGeometry().width()-4, this->frameGeometry().height()-4);
#elif QT_VERSION < QT_VERSION_CHECK(5, 5, 0)
  QPixmap pm = qApp->primaryScreen()->grabWindow(qApp->desktop()->winId(), this->x()+2, this->y()+2, this->frameGeometry().width()-4, this->frameGeometry().height()-4);
#else
  QPixmap pm = qApp->primaryScreen()->grabWindow(qApp->desktop()->winId(), this->x()-7, this->y()-7, this->frameGeometry().width()+14, this->frameGeometry().height()+14);
#endif
  QString fileName = QDateTime::currentDateTime().toString("yyyyMMddhhmmss")+"snapshot.png";
  fileName.replace(" ", "");
  pm.save("./screenshots/"+fileName);
}
void UserWindow::onRecordDataSlot()
{
#if DEBUG
//   qDebug()<<"onRecordDataSlot";
#endif
    if(m_pBtnRecordData->toolTip()=="Record Data")
    {
        m_bRecordData = true;
        m_pBtnRecordData->setToolTip("Stop Record Data");
        m_pIcon->load(":/images/record.png");
        m_pBtnRecordData->setIcon(*m_pIcon);

    }
    else {
        m_bRecordData = false;
        m_pBtnRecordData->setToolTip("Record Data");
        m_pIcon->load(":/images/recordfill.png");
        m_pBtnRecordData->setIcon(*m_pIcon);
    }
}




QPushButton *UserWindow::createButton(QString text, QRect rect, QWidget *parent)
{
    QPushButton* pButton = new QPushButton(text, parent);
    pButton->setGeometry(rect);

    pButton->setStyleSheet("QPushButton {background: #002F6F; color: white; "
                           "border-style: outset; border-width: 2px; border-radius: 10px; "
                           "font: 20px Calibri; }"
                           "QPushButton:pressed {background: #992F6F; }"
                           "QPushButton:disabled {background: #777777; color: lightgray;}");
    return pButton;
}

void UserWindow::onBtnResetData()
{
#if DEBUG
    qDebug()<<"onBtnResetData";
#endif
    lastData.carPosition =0;
    lastData.carVelocity = 0;
    lastData.hookAngle = 0;
    lastData.payloadAngle = 0;
    lastData.Force = 0;
    m_pSensorDataObserver->rstData();
}

void UserWindow::setButtonEnable(QPushButton *pButton)
{
    pButton->setStyleSheet("QPushButton {background: #008800; color: white; "
                           "border-style: outset; border-width: 2px; border-radius: 10px; "
                           "font: 20px Calibri; }"
                           "QPushButton:pressed {background: #992F6F; }"
                           "QPushButton:disabled {background: #777777; color: lightgray;}");
}

void UserWindow::setButtonNormal(QPushButton *pButton)
{
    pButton->setStyleSheet("QPushButton {background: #002F6F; color: white; "
                           "border-style: outset; border-width: 2px; border-radius: 10px; border-color: #002F6F; "
                           "font: 20px Calibri; }"
                           "QPushButton:pressed {background: #992F6F;}");
}

//void CeleX5Widget::showMoreParameters(int index)
//{
//    if (!m_pCeleX5Cfg)
//    {
//        m_pCeleX5Cfg = new CeleX5Cfg(m_pCeleX5);
//        //m_pCeleX5Cfg->setTestWidget(this);
//    }
//    m_pCeleX5Cfg->setCurrentIndex(index);
//    m_pCeleX5Cfg->raise();
//    m_pCeleX5Cfg->show();
//}
