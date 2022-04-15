#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>
#include "userwindow.h"

#include <QApplication>
#include <QLabel>
#include <QPushButton>
#include <QGridLayout>
#include <QToolBar>
#include <QToolButton>
#include <QLineEdit>
#include <QTextEdit>
//#include <QTime>
#include <QTimer>
#include <QMouseEvent>
using namespace  std;

namespace Ui {
class MainWindow;
}

class MainWindow : public QMainWindow
{
    Q_OBJECT

public:
    explicit MainWindow(QWidget *parent = nullptr);
    ~MainWindow();

protected:
    //
    void mouseMoveEvent(QMouseEvent *event) override;  //鼠标移动
    void mousePressEvent(QMouseEvent *event) override;    //鼠标单击
    void mouseReleaseEvent(QMouseEvent *)override;
   void closeEvent(QCloseEvent *event)override;
private slots:
    void showUserWindow();
private:
    Ui::MainWindow  *ui;
    UserWindow*     m_pUsrWindow;
    QTimer*         m_pStartTimer;
    QTextEdit*      txt;
    QLineEdit*      m_pVersionInfo;
    QPoint          L ;
//    ifstream         m_fIn;
};

#endif // MAINWINDOW_H
