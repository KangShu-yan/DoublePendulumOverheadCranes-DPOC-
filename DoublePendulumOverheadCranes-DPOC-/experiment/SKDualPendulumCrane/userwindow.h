#ifndef USERWINDOW_H
#define USERWINDOW_H



#include "sensordata.h"
#include "qcustomplot.h"
//#include "Eigen/Geometry"

#include "concretecontrol.h"



#include <QTime>
#include <QMessageBox>
#include <QRadioButton>
#include <QTextEdit>
#include <QFile>
#include <iostream>
#include <fstream>
//#include <sstream>

#ifdef _WIN32
#include <windows.h>
#else
#include<unistd.h>
#endif



using namespace std;

//#pragma execution_character_set("utf-8")


namespace Ui {
    class UserWindow;
}

class QLabel;
class MainWindow;
class QComboBox;

class QHBoxLayout;
class QVBoxLayout;
class QGridLayout;
class QAbstractButton;
class QPushButton;
class QButtonGroup;
class QCustomPlot;
class QGraphicsView;


class UserWindow : public QWidget
{
    Q_OBJECT
public:
    explicit UserWindow(QWidget *parent = nullptr);
    virtual ~UserWindow();
    void resizeEvent(QResizeEvent *event);
    void closeEvent(QCloseEvent *event);

private:
    void playback(QPushButton* pButton);

    QPushButton* createButton(QString text, QRect rect, QWidget *parent);
//    SliderWidget* createSlider(CeleX5::CfgInfo cfgInfo, int value, QRect rect, QWidget *parent, QWidget *widgetSlot);
    //
//    void changeFPN();
    //
    void record(QPushButton* pButton);
    void recordImages(QPushButton* pButton);
    void recordVideo(QPushButton* pButton);
    //
    void switchMode(QPushButton* pButton, bool isLoopMode, bool bPlayback);
    void makeplot();
//    void showCFG();
//    void showAdvancedSetting();
//    void showMoreParameters(int index);
//    void showPlaybackBoard(bool show);
    //
//    void setSliderMaxValue(QWidget* parent, QString objName, int value);
//    int  getSliderMax(QWidget* parent, QString objName);
    //
    void setButtonEnable(QPushButton* pButton);
    void setButtonNormal(QPushButton* pButton);
    //
    void onBtnRotateLRReleased(QPushButton* pButton);
    void onBtnRotateUDReleased(QPushButton* pButton);

    //------- for playback -------
//    void convertBin2Video(QPushButton* pButton);
    void convertBin2CSV(QPushButton* pButton);
//    void setConRunControllerButtonurrentPackageNo(int value);

signals:

protected slots:
    void onOpenCloseSerial();
    void onBtnResetData();

    void onButtonClicked(QAbstractButton* button);
    void onSaveDataSlot();
    void onRecordDataSlot();
//     void onResetDataSlot();
    void onScreenshotSlot();
//    void onValueChanged(uint32_t value, CfgSlider* slider);
    void onRecordDataTimer();
    //
    void onControlMethodChanged(QString text);
//    void onImageTypeChanged(int index);
//    void onLoopEventTypeChanged(int index);
//    void onShowMultipleWindows();
//    void onEventShowTypeChanged(int index);

    void onRealtimeDataSlot();
    void onRunControllerButton();

    void onRealtimeControlSlot();
    void onRealtimeSerialSlot();

    void onControllerChanged(int i);
    void onHighLightedSerialCBSlot(int i);
//    void onShowImagesSwitch(bool state);
//    void onJPGFormatClicked(bool state);
//    void onBMPFormatClicked(bool state);
    //
//    void onShowMoreParameters();

//    void onReadBinTimer();
//    void onUpdatePlayInfo();
//    void onBtnPlayPauseReleased();
//    void onBtnReplayRelease();
    void onBtnSavePicReleased();
    void mouseWheelSlot();
    void xAxisChanged(QCPRange range);
    void yAxisChanged(QCPRange range );

private:

//    Ui::UserWindow *ui;
    QWidget*            m_pScrollWidget;
//    QWidget*            m_pControlParams;
//    SettingsWidget*     m_pSettingsWidget;

    QMenuBar*           m_pMenuBar;
    QToolBar*           m_pToolBar;
    QStatusBar*         m_pStatusBar;
    QButtonGroup*       m_pButtonGroup;
    // i
    QHBoxLayout*        m_pToolHLayout;
    QHBoxLayout*        m_pHLayout;
    QHBoxLayout*        m_pSerialCBHLayout;
    QHBoxLayout*        m_pRunHLayout;
    QHBoxLayout*        m_pCtrChooseHLayout;
    QHBoxLayout*        m_pFrxHLayout;
     QHBoxLayout*        m_pXdHLayout;
    QVBoxLayout*        m_pMainVLayout;
    QVBoxLayout*        m_pCurveVLayout;
    QVBoxLayout*        m_pAnalysisVLayout;
    QVBoxLayout*        m_pCfgVLayout;

//    QVBoxLayout*        m_pFstCurveVLayout;
//    QVBoxLayout*        m_pSedCurveVLayout;
    QGridLayout *       m_pGridLayout;
    QGridLayout *       m_pGridAnalysis;
    QGridLayout *       m_pGridSerial;

    QGridLayout *       m_pGridCtrPhyParams;
    QGridLayout *       m_pGridCtrPhyGains;

//    QGridLayout *       m_pGridCtrPhyParams;

    QLabel*             m_pStatus;
//    quatified results
    QLabel *           m_ppf;
    QLabel *           m_pthetahMax;
    QLabel *           m_pthetahRes;
    QLabel *           m_pthetapMax;
    QLabel *           m_pthetapRes;
    QLabel *           m_pts;
    QLabel *           m_pFMax;
    QLabel *           m_ppower;

    QLabel *           m_pSerialChoose;
    QLabel *           m_pBaudrate;
    QLabel *           m_pStopBit;
    QLabel *           m_pDataBit;
    QLabel *           m_pCRC;
    QLabel *           m_pOperation;

    QLabel *           m_pCtrChoose;
    QLabel *           m_pmc;
    QLabel *           m_pmh;
    QLabel *           m_pmp;
    QLabel *           m_plh;
    QLabel *           m_plp;
    QLabel *           m_pdh;
    QLabel *           m_pdp;
    QLabel *           m_pEpsilonx;
    QLabel *           m_pKrx;
    QLabel *           m_pFrx;
    QLabel *           m_pTs;
    QLabel *           m_pUmax;
    QLabel *           m_pXd;
    QLabel *           m_pVd;

//    QVector<QSharedPointer<QLabel>> m_pGains;
    QVector<QLabel*> m_pGains;
    QLabel*            m_pRun;

    QLineEdit*         m_pLEmc;
    QLineEdit*         m_pLEmh;
    QLineEdit*         m_pLEmp;
    QLineEdit*         m_pLElh;
    QLineEdit*         m_pLElp;
    QLineEdit*         m_pLEdh;
    QLineEdit*         m_pLEdp;
    QLineEdit*         m_pLEEpsilonx;
    QLineEdit*         m_pLEKrx;
    QLineEdit*         m_pLEFrx;
    QLineEdit*         m_pLETs;
    QLineEdit*         m_pLEUmax;
    QLineEdit*         m_pLEXd;
     QLineEdit*         m_pLEVd;

//    QVector<QSharedPointer<QLineEdit>>     m_pLEGains;
    QVector<QLineEdit*>     m_pLEGains;
    std::vector<QComboBox*>     m_pCBSerialChoose;

    QComboBox*          m_pCBBaudrate;
    QComboBox*          m_pCBStopBit;
    QComboBox*          m_pCBDataBit;
    QComboBox*          m_pCBCRC;
    QComboBox*          m_pCBController;

    QPushButton*        m_pBtnOperationSerial;

    QPushButton*        m_pBtnSave;
    QPushButton*        m_pBtnSaveAs;
    QPushButton*        m_pBtnScreenshot;
    QPushButton*        m_pBtnInfo;
    QPushButton*        m_pBtnOpen;
    QPushButton*        m_pBtnExit;
    QSpacerItem*        m_pSpacerItem;

    QPushButton*        m_pBtnRunController;
    QPushButton*       m_pBtnRecordData;
    QPushButton*       m_pBtnResetData;



    QPixmap*            m_pIcon;

    QSharedPointer<ConcreteControl> m_pConcreteCtr;
//    QSharedPointer<ControllerBase> m_pControllerBase;
    ControllerBase* m_pControllerBase;


    //
    QWidget*            m_pPlaybackBg;

     Ui::UserWindow *ui;

//    QPushButton*        m_pBtnSavePic;
//    QPushButton*        m_pBtnSavePicEx;
//    QButtonGroup*       m_pBtnGroup;

    //
    QWidget*            m_pVersionWidget;
//    QPushButton*        m_pBtnPlayPause;
    //
    QCustomPlot*        m_pCustomPlotWidget[4];

    AnalysisData lastData;

    QTimer              dataTimer;
    QTimer*              m_pSerialTimer;
    QTimer*             m_pControlCycleTimer;
    SensorDataObserver* m_pSensorDataObserver;
//    map<string, vector<CeleX5::CfgInfo>> m_mapCfgDefault;

    bool                m_bPlaybackPaused;
    //
//    QStringList         m_qstBinfilePathList;

    int                 m_iCurve;
    int                 m_iPackageCountBegin;
    int                 m_iPackageCountEnd;
//    std::ofstream      m_ofWriteMat;
    QFile*               m_pFile;
    QTextStream* m_pTxtOutPut;
    bool                m_bRecordData;
    bool                m_bComplete;
};

#endif // CELEX5WIDGET_H
