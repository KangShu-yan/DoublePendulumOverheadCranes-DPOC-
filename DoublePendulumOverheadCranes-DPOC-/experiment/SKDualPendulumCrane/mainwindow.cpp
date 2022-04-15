#include "mainwindow.h"
#include "ui_mainwindow.h"
#include <QCloseEvent>


MainWindow::MainWindow(QWidget *parent) :
    QMainWindow(parent),
    ui(new Ui::MainWindow),
    m_pUsrWindow(nullptr)
{
    ui->setupUi(this);
    this->move(500, 400);
//    设置程序图标
    this->setWindowIcon(QIcon(":/images/log.jpeg"));
//    无边框
    this->setWindowFlags(Qt::FramelessWindowHint);
    this->setGeometry(QRect(720, 360, 480, 360));
    this->setAutoFillBackground(true);
//    设置背景
    QPalette palette;
    QPixmap pixmap(":/images/cover.png");
    palette.setBrush(QPalette::Window, QBrush(pixmap));
    this->setPalette(palette);
//    应用程序版本信息
    m_pVersionInfo = new QLineEdit(this);
    m_pVersionInfo->setText("Version 1.0.0");
    m_pVersionInfo->setGeometry(QRect(30, 320, 200, 20));
    m_pVersionInfo->setStyleSheet("font: 20px Calibri; color: #000000;background:transparent;border-width:0;border-style:outset");
// 启动主界面程序
    m_pStartTimer = new QTimer(this);
    m_pStartTimer->setSingleShot(true);
    connect(m_pStartTimer, SIGNAL(timeout()), this, SLOT(showUserWindow()));

    m_pStartTimer->start(5000);


}

MainWindow::~MainWindow()
{
    delete ui;
}



void MainWindow::showUserWindow()
{
    bool bCeleX5Device = true;
    if (bCeleX5Device)
    {
        this->setWindowTitle("CeleX5-Demo");

        if (!m_pUsrWindow)
        {
            m_pUsrWindow = new UserWindow;
        }
        m_pUsrWindow->show();
        m_pUsrWindow->showMaximized();
    }
    this->hide();

}

//重载的鼠标事件
void MainWindow::mouseMoveEvent(QMouseEvent *event)
{
    QPoint p3 = event->globalPos();
    QPoint p2 = p3-L;
    this->move(p2);
}
void MainWindow::mousePressEvent(QMouseEvent *event)
{
    QPoint p3 = event->globalPos();
    QPoint p2 = this->geometry().topLeft();
    L = p3-p2;
}
void MainWindow::mouseReleaseEvent(QMouseEvent *)
{
    this->L = QPoint();
}
//重载关闭窗口
void MainWindow::closeEvent(QCloseEvent *event)
{
    if (m_pUsrWindow)
        m_pUsrWindow->closeEvent(event);
}
