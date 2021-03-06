//+------------------------------------------------------------------+
//|                                            Autobot Pro V 14.mq4  |
//|                                                Alexandr Kisterny |
//|                                     https://www.binary-forum.com |
//+------------------------------------------------------------------+
#property copyright "Alexandr Kisterny"
#property link      "https://binary-forum.com/members/alexksander.325/"
#property strict
#property indicator_chart_window
#property description "Разработка технических индикаторов и торговых роботов МТ4 для Forex и Б.О."
#property description "==================================================================="
#property description "Skype: alexksander01"
#property description "or"
#property description "Mail: Kisterny@i.ua"
//#property icon "\\Images\\autobot pro.ico"
//---
#property indicator_buffers 4
#property indicator_width1  1
#property indicator_width2  1
#property indicator_width3  1
#property indicator_width4  1
#property indicator_color1  clrMagenta
#property indicator_color2  clrRed
#property indicator_color3  clrOrange
#property indicator_color4  clrOrange
//---
#import "Autobot.Pro.dll"
int TCPMessage(string, int, string);
#import
#import "Autobot.Pro.udp.dll"
void UDPInit(string, int);
void UDPMessage(string);
void UDPDeInit();
#import
//---
enum w_mode {ticks = 0,//По тикам
             time  = 1 //По таймеру
            };
//---
enum swth   {onn = 0,//Включено 
             off = 1 //Выключено
            };
//---
enum srw    {bolshe = 0,// >
             menshe = 1,// <
             ravno  = 2,// ==
             neravno= 3 // !=
            };
//---
enum swith  {signalsound = 0,//Звуковой сигнал
             signalalert = 1,//Алерт
             signaloff   = 2 //Выключено
            };
//---
enum strt_s {po_baram   = 0,//По тику на новом баре
             po_vremeny = 1 //По времени
            };
//---
enum mrt_m  {next_bar = 0,//На след. баре
             next_sig = 1 //На след. сигнале 
            };                        
//---
enum tcp_udp_mode {tcp_mode = 0, // Только TCP
                   udp_mode = 1, // Только UDP
                   tcp_and_udp_mode = 2 // TCP и UDP
                  };
//+------------------------------------------------------------------+
//| Custom indicator input parameters                                |
//+------------------------------------------------------------------+
input  w_mode work_m          = 1;               // Режим работы (исполнение кода):
input  int    timing          = 500;             // Период обновления данных в милесекундах:
extern int    gmt_shift       = 0;               // Сдвиг по GMT(0 = время терминала):
input  swth   auto_GMT        = 1;               // Автоподстройка GMT:
input  string sep1            = "";////---
input  string auto_set        = "===== Настройка автоматической торговли   =======================================";//=============================================================================================
input  swth   auto            = 1;               // Разрешить прием сигналов с индикатора:
input  string i_name          = "Indicator name";// Имя индикатора:
input  int    b_bufer         = 0;               // Номер буфера BUY:
input  int    s_bufer         = 1;               // Номер буфера SELL:
input  double b_null_val      = 2147483647.0;    // Значение буфера BUY: 
input  double s_null_val      = 2147483647.0;    // Значение буфера SELL:
input  srw    b_srw           = 3;               // Логическая операция BUY:
input  srw    s_srw           = 3;               // Логическая операция SELL:
input  int    S_shift         = 0;               // Смотреть буферы (стрелку) на баре:
input  swth   use_martin      = 1;               // Использовать Мартингейл:
input  mrt_m  martin_mode     = 0;               // Режим работы Мартингейла:
input  int    martin_cnt      = 3;               // Количество колен Мартингейла:
input  swth   use_dodge       = off;             // Прекращать серию мартина в случае доджа:
input  int    otstup          = 15;              // Отступ стрелки от свечи:
input  swith  signal          = 0;               // Оповещение о сигнале:
input  string sound_file      = "alert.wav";     // Файл звукового сигнала
input  swth   use_log         = 1;               // Выводить лог на график:
input  swth   use_print       = 0;               // Выводить лог в журнал:
input  string sept1           = "";////---
input  swth   use_time1       = 0;               // Использовать 1-й фильтр времени:
input  string StartTradeHour  = "00:00";         // Время начала торговли 1:
input  string EndTradeHour    = "23:30";         // Время окончания торговли 1:
input  string sept2           = "";////---
input  swth   use_time2       = 1;               // Использовать 2-й фильтр времени:
input  string StartTradeHour2 = "00:00";         // Время начала торговли 2:
input  string EndTradeHour2   = "23:30";         // Время окончания торговли 2:
input  string sept3           = "";////---
input  swth   use_time3       = 1;               // Использовать 3-й фильтр времени:
input  string StartTradeHour3 = "00:00";         // Время начала торговли 3:
input  string EndTradeHour3   = "23:30";         // Время окончания торговли 3:
input  string sept4           = "";////---
input  swth   use_time4       = 1;               // Использовать 4-й фильтр времени:
input  string StartTradeHour4 = "00:00";         // Время начала торговли 4:
input  string EndTradeHour4   = "23:30";         // Время окончания торговли 4:
input  string sept5           = "";////---
input  swth   use_time5       = 1;               // Использовать 5-й фильтр времени:
input  string StartTradeHour5 = "00:00";         // Время начала торговли 5:
input  string EndTradeHour5   = "23:30";         // Время окончания торговли 5:
input  string sept6           = "";////---
input  swth   use_time6       = 1;               // Использовать 6-й фильтр времени:
input  string StartTradeHour6 = "00:00";         // Время начала торговли 6:
input  string EndTradeHour6   = "23:30";         // Время окончания торговли 6:
input  string sep2            = "";////---
input  string start_set       = "===== Настройка старта сигнала (автоторговля)  =======================================";//=============================================================================================
input  strt_s signal_mode     = 1;               // Стартовать сигнал по:
input  int    bar_shift       = 0;               // Если по тикам, то поправка смещения в барах (0-не смещать):
input  int    sec_shift       = 1;               // Если по времени, то поправка старта в секундах:  
input  string sep3            = "";////---
input  string end_set         = "===== Настройка завершения сигнала (автоторговля)  =======================================";//=============================================================================================
input  strt_s expr_mode       = 1;               // Завершать сигнал по:
input  int    ex_bar_shift    = 1;               // Если по тикам, то поправка смещения в барах:
extern int    ex_min_shift    = 5;               // Если по времени, то поправка експирации в минутах:  
input  string sep4            = "";////---
input  string mtr_set         = "===== Настройка ручной торговли  =======================================";//=============================================================================================
input  swth   use_panel       = 1;               // Отображать сигнальную панель:
input  double Lot1            = 1;               // Лот 1:
input  double Lot2            = 2;               // Лот 2:
input  double Lot3            = 3;               // Лот 3:
input  double Lot4            = 5;               // Лот 4:
input  double Lot5            = 8;               // Лот 5:
input  double Lot6            = 10;              // Лот 6:
input  string sep5            = "";////--- 
input  int    bar1            = 1;               // Значение 1 для експирации по барам:
input  int    bar2            = 2;               // Значение 2 для експирации по барам:
input  int    bar3            = 3;               // Значение 3 для експирации по барам:
input  int    bar4            = 4;               // Значение 4 для експирации по барам:
input  int    bar5            = 5;               // Значение 5 для експирации по барам:
input  int    bar6            = 6;               // Значение 6 для експирации по барам:
input  string sep6            = "";////--- 
input  int    min1            = 1;               // Значение 1 для експирации по минутам:
input  int    min2            = 2;               // Значение 2 для експирации по минутам:
input  int    min3            = 3;               // Значение 3 для експирации по минутам:
input  int    min4            = 5;               // Значение 4 для експирации по минутам:
input  int    min5            = 10;              // Значение 5 для експирации по минутам:
input  int    min6            = 15;              // Значение 6 для експирации по минутам:
input  int    min7            = 30;              // Значение 4 для експирации по минутам:
input  int    min8            = 60;              // Значение 5 для експирации по минутам:
input  int    min9            = 0;               // Значение 6 для експирации по минутам:
input  string sep7            = "";////--- 
input  double Multipler       = 2.5;             // Множитель мартина:
input  string sep8            = "";////--- 
input  strt_s signal_mode_m   = 1;               // Стартовать сигнал по:
input  int    bar_shift_m     = 0;               // Если по тикам, то поправка старта в барах (0-не смещать):
input  int    sec_shift_m     = 1;               // Если по времени, то поправка старта в секундах:  
input  string sep9            = "";////---
input  strt_s expr_mode_m     = 0;               // Завершать сигнал по:
input  string sep10           = "";////---
input  string timer_set       = "===== Параметры таймера закрытия свечи =======================================";//=============================================================================================
input  swth   use_timer       = 0;               // Отображать на графике:
input  string Font            = "Calibri";       // Шрифт таймера:
input  int    Font_Size       = 10;              // Размер шрифта:
input  color  Font_Color      = clrDarkOrange;   // Цвет таймера:
input  string sep11           = "";////---
input  string send_set        = "===== Параметры отправки сигналов на сервис =======================================";//=============================================================================================
string        TcpServer       = "91.217.90.11";  // IP адрес сервера для отправки TCP-пакетов
string        UdpServer       = TcpServer;       // IP адрес сервера для отправки UDP-пакетов
//string        TcpServer       = "192.168.1.6";   // IP адрес сервера для отправки TCP-пакетов
int           TcpPort         = 4568;            // TCP порт сервера
input  int    UdpPort         = 4568;            // UDP порт сервера
input  swth   send_signal     = 1;               // Отправлять сигналы на сервер?
input  string ab_name         = "YourLogin";     // Имя ТС (Логин на Autobot.Pro)
input  string ab_pass         = "123456";        // Пароль (Пароль на Autobot.Pro)
input  tcp_udp_mode netw_mode = tcp_mode;        // Сетевой протокол
//+------------------------------------------------------------------+
//| Custom indicator global variables                        |
//+------------------------------------------------------------------+
double   upbuffer[];//BUY  buffer
double   dnbuffer[];//SELL buffer
double   upbuffer_m[];//manual BUY  buffer
double   dnbuffer_m[];//manual SELL buffer   
//--- переменные для таймера ---
int      minutes   = 0;
int      seconds   = 0;
int      hours     = 0;
//--- переменная для времени последнего оповещения о сигнале
datetime bartime    = 0;
datetime buy_time_m = 0;
datetime sel_time_m = 0;
//--- переменные для хранения лога
datetime log_time  = 0;
int      log_sz    = 10;
string   log_mass[10];
//--- переменные и массивы для организации подсчёта статистики
int      buy_sz    = 0;
int      sel_sz    = 0;
double   buy_price[1];
double   sel_price[1];
datetime stat_time = 0;
datetime buy_time[1];
datetime sel_time[1];
datetime exp_buy_time[1];
datetime exp_sel_time[1];
int      wins = 0;
int      losses = 0;
//--- переменные и массивы для организации подсчёта статистики
//--- по Мартину
int      m_buy_sz    = 0;
int      m_sel_sz    = 0;
double   m_buy_price[1];
double   m_sel_price[1];
datetime m_stat_time = 0;
datetime m_buy_time[1];
datetime m_sel_time[1];
datetime m_exp_buy_time[1];
datetime m_exp_sel_time[1];
bool     m_buy_trigger = false;
bool     m_sel_trigger = false;
int      coleno = 0;
int      m_wins = 0;
int      m_losses = 0;
//--- Переменные для создания торговой панели
string call_btn         = "call_btn";        //Мгновенный старт
string put_btn          = "put_btn";         //Мгновенный старт
string call_end_bar_btn = "call_end_bar_btn";//Сигнал до конца текущего бара
string put_end_bar_btn  = "put_end_bar_btn"; //Сигнал до конца текущего бара
string call_timer_btn   = "call_timer_btn";  //Для постановки сигнала в очередь
string put_timer_btn    = "put_timer_btn";   //Для постановки сигнала в очередь
string cancell_btn      = "cancell_btn";     //Кнопка отмены
string ramka1           = "ramka1";
string ramka2           = "ramka2";
string ramka3           = "ramka3";
string ramka4           = "ramka4";
string ramka5           = "ramka5";
string ramka6           = "ramka6";
string lot_label        = "lot_label";
string lot1_btn         = "lot1_btn";
string lot2_btn         = "lot2_btn";
string lot3_btn         = "lot3_btn";
string lot4_btn         = "lot4_btn";
string lot5_btn         = "lot5_btn";
string lot6_btn         = "lot6_btn";
string series_label     = "series_label";
string srs0_btn         = "srs0_btn";
string srs1_btn         = "srs1_btn";
string srs2_btn         = "srs2_btn";
string srs3_btn         = "srs3_btn";
string srs4_btn         = "srs4_btn";
string srs5_btn         = "srs5_btn";
string size_label       = "size_label";
string size_labe2       = "size_labe2";
string bar1_btn         = "bar1_btn";
string bar2_btn         = "bar2_btn";
string bar3_btn         = "bar3_btn";
string bar4_btn         = "bar4_btn";
string bar5_btn         = "bar5_btn";
string bar6_btn         = "bar6_btn";
string bar_label        = "bar_label";
string min1_btn         = "min1_btn";
string min2_btn         = "min2_btn";
string min3_btn         = "min3_btn";
string min4_btn         = "min4_btn";
string min5_btn         = "min5_btn";
string min6_btn         = "min6_btn";
string min7_btn         = "min7_btn";
string min8_btn         = "min8_btn";
string min9_btn         = "min9_btn";
string min_label        = "min_label";
//--
double tmp_lot  = Lot1;
double last_lot = Lot1;
int    tmp_sec  = Period()*60*bar1;
int    tmp_sec2 = 60*min1; 
int    coleno_m = 0;

datetime start_time = Time[0];
datetime g_exp_time = Time[0];


bool s_trigger = true;
 
 // Количество объектов линий цены Buy/Sell
int mLineObjectsNumber=0;

int tmp_min_shift = ex_min_shift;
 
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
{
 SetIndexStyle     (0,DRAW_ARROW);
 SetIndexArrow     (0,233);
 SetIndexBuffer    (0,upbuffer);
 SetIndexEmptyValue(0,EMPTY_VALUE);
 SetIndexLabel     (0,"Сигнал Buy");
 //---
 SetIndexStyle     (1,DRAW_ARROW);
 SetIndexArrow     (1,234);
 SetIndexBuffer    (1,dnbuffer);
 SetIndexEmptyValue(1,EMPTY_VALUE);
 SetIndexLabel     (1,"Сигнал Sell");
 //---
 SetIndexStyle     (2,DRAW_ARROW);
 SetIndexArrow     (2,233);
 SetIndexBuffer    (2,upbuffer_m);
 SetIndexEmptyValue(2,EMPTY_VALUE);
 SetIndexLabel     (2,"Ручной сигнал Buy");
 //---
 SetIndexStyle     (3,DRAW_ARROW);
 SetIndexArrow     (3,234);
 SetIndexBuffer    (3,dnbuffer_m);
 SetIndexEmptyValue(3,EMPTY_VALUE);
 SetIndexLabel     (3,"Ручной сигнал Sell");
 //---
 EventSetMillisecondTimer(timing);
 //---
 bartime     = Time[0];
 log_time    = Time[0];
 stat_time   = Time[0];
 m_stat_time = Time[0];
 start_time  = Time[0];
 g_exp_time  = Time[0];
 //---
 if(use_log == 0){Print_Log("");}
 
 if(use_panel == 0){CreateButtons();}
 
 if(auto == 0 && i_name == "Indicator name"){Alert("Вы забыли указать имя индикатора !");}
 
 if(auto_GMT == 0)
 {
  if(AccountInfoString(ACCOUNT_COMPANY) == "Alpari International Limited"){gmt_shift = -3;}
  if(AccountInfoString(ACCOUNT_COMPANY) == "World Forex Corp."){gmt_shift = -3;}
  if(StringFind(AccountCompany(),"Grand Capital",0) > 0 && StringFind(AccountCompany(),"GrandCapital",0) > 0){gmt_shift = -3;}
  if(AccountInfoString(ACCOUNT_COMPANY) == "Global Derivative Markets Ltd."){gmt_shift = 0;}
  if(StringFind(AccountCompany(),"GDM Forex",0) > 0 && StringFind(AccountCompany(),"GDMFX",0) > 0){gmt_shift = 0;}
 }
 
 if(signal_mode == 1 && sec_shift > 0 && martin_mode == 1){tmp_min_shift+=1;}
 
 if (netw_mode == udp_mode || netw_mode == tcp_and_udp_mode) {
  UDPInit(UdpServer, UdpPort);
 }
 
 return(INIT_SUCCEEDED);
}
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
{
 EventKillTimer();
 ObjectDelete("time");
 ObjectsDeleteAll(0,OBJ_BUTTON);
 ObjectsDeleteAll(0,OBJ_LABEL);
 ObjectsDeleteAll(0,OBJ_RECTANGLE_LABEL);
 ObjectsDeleteAll(0,OBJ_VLINE);
 if(use_log == onn){Comment("");}
 start_time = Time[0];
 
 for(int l=0;l<=mLineObjectsNumber;l++)
      {
       if (ObjectFind("Line"+string(l))!=-1)
         {
             ObjectDelete(0,"Line"+string(l));
         }
      }
      
 if(signal_mode == 1 && sec_shift > 0 && martin_mode == 1){tmp_min_shift-=1;}
 
 UDPDeInit();
 
 return(0);
}
//+------------------------------------------------------------------+
//| Если режим работы по тикам, то исполняем всё в теле этой ф-ции   |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,const int prev_calculated,const datetime &time[],const double &open[],const double &high[],const double &low[],const double &close[],const long &tick_volume[],const long &volume[],const int &spread[])
{
 if(work_m == 0)
 {
  if(buy_time_m > 0 && buy_time_m == Time[0]){upbuffer_m[0] = Low[0]-otstup*Point;}
  if(buy_time_m > 0 && buy_time_m < Time[0] ){upbuffer_m[0] = EMPTY_VALUE; buy_time_m = 0;}
  if(sel_time_m > 0 && sel_time_m == Time[0]){dnbuffer_m[0] = High[0]+otstup*Point;}
  if(sel_time_m > 0 && sel_time_m < Time[0] ){dnbuffer_m[0] = EMPTY_VALUE; sel_time_m = 0;}
 
  for(int x = -1;x<ObjectsTotal();x++)
  {
   if(ObjectFind(0,ObjectName(x)) == 0 && StringSubstr(ObjectName(x),0,13) == "CALL_exp_line" && ObjectGetInteger(0,ObjectName(x),OBJPROP_TIME) <= TimeCurrent()){ObjectDelete(ObjectName(x));}
   if(ObjectFind(0,ObjectName(x)) == 0 && StringSubstr(ObjectName(x),0,12) == "PUT_exp_line" && ObjectGetInteger(0,ObjectName(x),OBJPROP_TIME) <= TimeCurrent()){ObjectDelete(ObjectName(x));}
  
   if(ObjectFind(0,ObjectName(x)) == 0 && StringSubstr(ObjectName(x),0,13) == "CALL_str_line" && ObjectGetInteger(0,ObjectName(x),OBJPROP_TIME) <= TimeCurrent()){ObjectDelete(ObjectName(x));buy_time_m = Time[0];if(send_signal==0){AutobotBuy(g_exp_time, tmp_lot, tmp_sec);}PlaySound("entry.wav");}
   if(ObjectFind(0,ObjectName(x)) == 0 && StringSubstr(ObjectName(x),0,12) == "PUT_str_line" && ObjectGetInteger(0,ObjectName(x),OBJPROP_TIME) <= TimeCurrent()){ObjectDelete(ObjectName(x));sel_time_m = Time[0];if(send_signal==0){AutobotSell(g_exp_time, tmp_lot, tmp_sec);}PlaySound("entry.wav");}
  }
 } 
 
 if(work_m == 0 && start_time < Time[0]){main_calc();}  
 return(rates_total);
}
//+------------------------------------------------------------------+
//| Если режим работы по таймеру, то исполняем всё в теле этой ф-ции |
//+------------------------------------------------------------------+
void OnTimer()
{
 if(work_m == 1)
 {
  if(buy_time_m > 0 && buy_time_m == Time[0]){upbuffer_m[0] = Low[0]-otstup*Point;}
  if(buy_time_m > 0 && buy_time_m < Time[0] ){upbuffer_m[0] = EMPTY_VALUE; buy_time_m = 0;}
  if(sel_time_m > 0 && sel_time_m == Time[0]){dnbuffer_m[0] = High[0]+otstup*Point;}
  if(sel_time_m > 0 && sel_time_m < Time[0] ){dnbuffer_m[0] = EMPTY_VALUE; sel_time_m = 0;}
 
  for(int x = -1;x<ObjectsTotal();x++)
  {
   if(ObjectFind(0,ObjectName(x)) == 0 && StringSubstr(ObjectName(x),0,13) == "CALL_exp_line" && ObjectGetInteger(0,ObjectName(x),OBJPROP_TIME) <= TimeCurrent()){ObjectDelete(ObjectName(x));}
   if(ObjectFind(0,ObjectName(x)) == 0 && StringSubstr(ObjectName(x),0,12) == "PUT_exp_line" && ObjectGetInteger(0,ObjectName(x),OBJPROP_TIME) <= TimeCurrent()){ObjectDelete(ObjectName(x));}
  
   if(ObjectFind(0,ObjectName(x)) == 0 && StringSubstr(ObjectName(x),0,13) == "CALL_str_line" && ObjectGetInteger(0,ObjectName(x),OBJPROP_TIME) <= TimeCurrent()){ObjectDelete(ObjectName(x));buy_time_m = Time[0];if(send_signal==0){AutobotBuy(g_exp_time, tmp_lot, tmp_sec2);}PlaySound("entry.wav");}
   if(ObjectFind(0,ObjectName(x)) == 0 && StringSubstr(ObjectName(x),0,12) == "PUT_str_line" && ObjectGetInteger(0,ObjectName(x),OBJPROP_TIME) <= TimeCurrent()){ObjectDelete(ObjectName(x));sel_time_m = Time[0];if(send_signal==0){AutobotSell(g_exp_time, tmp_lot, tmp_sec2);}PlaySound("entry.wav");}
  }
 }
 
 if(work_m == 1 && start_time < Time[0]){main_calc();}
}
//+------------------------------------------------------------------+
//| функции обработки событий на графике                             |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,const long &lparam,const double &dparam,const string &sparam)
{
 EventsProccesing();
}


//+------------------------------------------------------------------+
//| Главная ф-ция, дающая старт остальным                            |
//+------------------------------------------------------------------+
void main_calc()
{
 minutes = (int)(Time[0] + 60 * Period() - TimeCurrent());
 seconds = minutes % 60;
 hours   = (minutes - seconds) / 3600;
 minutes = (minutes - seconds) / 60 - hours*60;
 if(use_timer == onn){Printing_timer();}
 //---
 //Comment(string(Time[0] + 60*Period() ));
 
 
 
 string tradetime = TimeToStr(TimeCurrent(),TIME_MINUTES);
 if(((use_time1 == 0 && ((StartTradeHour  < EndTradeHour  && tradetime >= StartTradeHour  && tradetime < EndTradeHour) ||(StartTradeHour  > EndTradeHour  && (tradetime < EndTradeHour  || tradetime >= StartTradeHour )))) ||
    (use_time2 == 0 && ((StartTradeHour2 < EndTradeHour2 && tradetime >= StartTradeHour2 && tradetime < EndTradeHour2)||(StartTradeHour2 > EndTradeHour2 && (tradetime < EndTradeHour2 || tradetime >= StartTradeHour2)))) ||
    (use_time3 == 0 && ((StartTradeHour3 < EndTradeHour3 && tradetime >= StartTradeHour3 && tradetime < EndTradeHour3)||(StartTradeHour3 > EndTradeHour3 && (tradetime < EndTradeHour3 || tradetime >= StartTradeHour3)))) ||
    (use_time4 == 0 && ((StartTradeHour4 < EndTradeHour4 && tradetime >= StartTradeHour4 && tradetime < EndTradeHour4)||(StartTradeHour4 > EndTradeHour4 && (tradetime < EndTradeHour4 || tradetime >= StartTradeHour4)))) ||
    (use_time5 == 0 && ((StartTradeHour5 < EndTradeHour5 && tradetime >= StartTradeHour5 && tradetime < EndTradeHour5)||(StartTradeHour5 > EndTradeHour5 && (tradetime < EndTradeHour5 || tradetime >= StartTradeHour5)))) ||
    (use_time6 == 0 && ((StartTradeHour6 < EndTradeHour6 && tradetime >= StartTradeHour6 && tradetime < EndTradeHour6)||(StartTradeHour6 > EndTradeHour6 && (tradetime < EndTradeHour6 || tradetime >= StartTradeHour6))))) && 
     i_name != "Indicator name" && auto == 0)
 {
  double buy_bufer = NormalizeDouble(iCustom(NULL,PERIOD_CURRENT,i_name,b_bufer,0+S_shift),_Digits); 
  double sel_bufer = NormalizeDouble(iCustom(NULL,PERIOD_CURRENT,i_name,s_bufer,0+S_shift),_Digits);
  //---
  Buy_calculate(buy_bufer);
  Sel_calculate(sel_bufer);
 }
 //---
 Buy_stat_procces();
 Sel_stat_procces();
 Buy_signals_procces();
 Sel_signals_procces();
 
}
//+------------------------------------------------------------------+
//| Обработка сигналов с буферов внешнего индикатора и отрисовка     |
//| стрелок с алертами                                               |
//+------------------------------------------------------------------+

void Buy_calculate(double buy_bufer)
{
 if (b_srw == 0){if(buy_bufer >  b_null_val){upbuffer[0] = Low[0]  - otstup*Point;notifybuy();}else upbuffer[0] = EMPTY_VALUE;}
 if (b_srw == 1){if(buy_bufer <  b_null_val){upbuffer[0] = Low[0]  - otstup*Point;notifybuy();}else upbuffer[0] = EMPTY_VALUE;}
 if (b_srw == 2){if(buy_bufer == b_null_val){upbuffer[0] = Low[0]  - otstup*Point;notifybuy();}else upbuffer[0] = EMPTY_VALUE;}
 if (b_srw == 3){if(buy_bufer != b_null_val){upbuffer[0] = Low[0]  - otstup*Point;notifybuy();}else upbuffer[0] = EMPTY_VALUE;}
}
//---
void Sel_calculate(double sel_bufer)
{
 if (s_srw == 0){if(sel_bufer >  s_null_val){dnbuffer[0] = High[0] + otstup*Point;notifysell();}else dnbuffer[0] = EMPTY_VALUE;}
 if (s_srw == 1){if(sel_bufer <  s_null_val){dnbuffer[0] = High[0] + otstup*Point;notifysell();}else dnbuffer[0] = EMPTY_VALUE;}
 if (s_srw == 2){if(sel_bufer == s_null_val){dnbuffer[0] = High[0] + otstup*Point;notifysell();}else dnbuffer[0] = EMPTY_VALUE;}
 if (s_srw == 3){if(sel_bufer != s_null_val){dnbuffer[0] = High[0] + otstup*Point;notifysell();}else dnbuffer[0] = EMPTY_VALUE;}
}

//+------------------------------------------------------------------+
//| Поиск сигналов во внутренних буфферах и подготовка к расчёту     |
//| статистики                                                       |
//+------------------------------------------------------------------+
void Buy_signals_procces()
{
 //--- Если старт сигнала настроен по тикам то исполняем данный кусок кода
 if(signal_mode == 0)
 {
  //--- Если есть сигнал на нужном нам баре, то подготавливаем необходимы массивы
  //--- и заполняем их данными
  if(m_buy_trigger == true && martin_mode == next_sig && upbuffer[0+bar_shift] != EMPTY_VALUE && m_stat_time < Time[0]) 
  {
   if(expr_mode == 0){m_stat_time = Time[0] + 60*Period()*ex_bar_shift;}
   if(expr_mode == 1){m_stat_time = Time[0] + 60*ex_min_shift;}
   //m_stat_time = Time[0];
   m_buy_sz++;
   ArrayResize(m_buy_price   ,m_buy_sz);
   ArrayResize(m_buy_time    ,m_buy_sz);
   ArrayResize(m_exp_buy_time,m_buy_sz);
   m_buy_price[m_buy_sz-1] = NormalizeDouble(Bid,_Digits);
   m_buy_time [m_buy_sz-1] = Time[0];
   if(expr_mode == 0){m_exp_buy_time[m_buy_sz-1] = Time[0] + 60*Period()*ex_bar_shift;}
   if(expr_mode == 1){m_exp_buy_time[m_buy_sz-1] = Time[0] + 60*ex_min_shift;}
   if(send_signal==0){AutobotBuy(m_exp_buy_time[m_buy_sz-1], 0, 0);}
   //--- Log functions
   string log_txt = TimeToStr(Time[0]) + " :: " + Symbol() + " :: " + "CALL_M " + string(coleno) + " :: " + "price: " + DoubleToStr(m_buy_price[m_buy_sz-1],_Digits) + " :: " + "exp on: " + string(TimeHour(m_exp_buy_time[m_buy_sz-1]))+ ":" + string(TimeMinute(m_exp_buy_time[m_buy_sz-1]))+ ":" + string(TimeSeconds(m_exp_buy_time[m_buy_sz-1])); 
   if(use_log == 0){Print_Log(log_txt);}
   if(use_print == 0){Print(log_txt);}
  }
  
  if(m_buy_trigger == true && martin_mode == next_bar && m_stat_time < Time[0])
  {
   //m_stat_time = Time[0];
   if(expr_mode == 0){m_stat_time = Time[0] + 60*Period()*ex_bar_shift;}
   if(expr_mode == 1){m_stat_time = Time[0] + 60*ex_min_shift-60;}
   
   m_buy_sz++;
   ArrayResize(m_buy_price   ,m_buy_sz);
   ArrayResize(m_buy_time    ,m_buy_sz);
   ArrayResize(m_exp_buy_time,m_buy_sz);
   m_buy_price[m_buy_sz-1] = NormalizeDouble(Bid,_Digits);
   m_buy_time [m_buy_sz-1] = Time[0];
   if(expr_mode == 0){m_exp_buy_time[m_buy_sz-1] = Time[0] + 60*Period()*ex_bar_shift;}
   if(expr_mode == 1){m_exp_buy_time[m_buy_sz-1] = Time[0] + 60*ex_min_shift;}
   if(send_signal==0){AutobotBuy(m_exp_buy_time[m_buy_sz-1], 0, 0);}
   //--- Log functions
   string log_txt = TimeToStr(Time[0]) + " :: " + Symbol() + " :: " + "CALL_M " + string(coleno) + " :: " + "price: " + DoubleToStr(m_buy_price[m_buy_sz-1],_Digits) + " :: " + "exp on: " + string(TimeHour(m_exp_buy_time[m_buy_sz-1]))+ ":" + string(TimeMinute(m_exp_buy_time[m_buy_sz-1]))+ ":" + string(TimeSeconds(m_exp_buy_time[m_buy_sz-1])); 
   if(use_log == 0){Print_Log(log_txt);}
   if(use_print == 0){Print(log_txt);}
  }
  
  if(m_buy_trigger == false && upbuffer[0+bar_shift] != EMPTY_VALUE && stat_time < Time[0])
  {
   if(expr_mode == 0){stat_time = Time[0] + 60*Period()*ex_bar_shift;}
   if(expr_mode == 1){stat_time = Time[0] + 60*ex_min_shift;}
   //stat_time = Time[0];
   buy_sz++;
   ArrayResize(buy_price   ,buy_sz);
   ArrayResize(buy_time    ,buy_sz);
   ArrayResize(exp_buy_time,buy_sz);
   buy_price[buy_sz-1] = NormalizeDouble(Bid,_Digits);
   buy_time [buy_sz-1] = Time[0];
   if(expr_mode == 0){exp_buy_time[buy_sz-1] = Time[0] + 60*Period()*ex_bar_shift;}
   if(expr_mode == 1){exp_buy_time[buy_sz-1] = Time[0] + 60*ex_min_shift;}
   if(send_signal==0){AutobotBuy(exp_buy_time[buy_sz-1], 0, 0);}
   //--- Log functions
   string log_txt = TimeToStr(Time[0]) + " :: " + Symbol() + " :: " + "CALL" + " :: " + "price: " + DoubleToStr(buy_price[buy_sz-1],_Digits) + " :: " + "exp on: " + string(TimeHour(exp_buy_time[buy_sz-1]))+ ":" + string(TimeMinute(exp_buy_time[buy_sz-1]))+ ":" + string(TimeSeconds(exp_buy_time[buy_sz-1])); 
   if(use_log == 0){Print_Log(log_txt);}
   if(use_print == 0){Print(log_txt);}
  }
  
 }
 //--- Если старт сигнала настроен по времени то исполняем данный кусок кода
 if(signal_mode == 1)
 {
  //--- Если есть сигнал на нужном нам баре, то подготавливаем необходимы массивы
  //--- и заполняем их данными
  
  if(m_buy_trigger == true && martin_mode == next_sig && upbuffer[0] != EMPTY_VALUE  && hours == 0 && minutes == 0 && seconds <= sec_shift  && seconds > -1 && m_stat_time < TimeCurrent())
  {
   if(expr_mode == 0){m_stat_time = Time[0] + 60*Period()*ex_bar_shift;}
   if(expr_mode == 1){m_stat_time = TimeCurrent() + 60*tmp_min_shift;}
   if(TimeSeconds(m_stat_time)> 0){while(TimeSeconds(m_stat_time)>0){m_stat_time--;}}
   //m_stat_time = Time[0];
   m_buy_sz++;
   ArrayResize(m_buy_price   ,m_buy_sz);
   ArrayResize(m_buy_time    ,m_buy_sz);
   ArrayResize(m_exp_buy_time,m_buy_sz);
   m_buy_price[m_buy_sz-1] = NormalizeDouble(Bid,_Digits);
   m_buy_time [m_buy_sz-1] = TimeCurrent();
   if(expr_mode == 0){m_exp_buy_time[m_buy_sz-1] = Time[0] + 60*Period()*ex_bar_shift; m_stat_time = Time[0] + 60*Period()*ex_bar_shift; }
   if(expr_mode == 1){m_exp_buy_time[m_buy_sz-1] = TimeCurrent() + 60*tmp_min_shift; m_stat_time = TimeCurrent() + 60*tmp_min_shift;}
   if(TimeSeconds(m_exp_buy_time[m_buy_sz-1])> 0){while(TimeSeconds(m_exp_buy_time[m_buy_sz-1])>0){m_exp_buy_time[m_buy_sz-1]--;}}
   if(send_signal==0){AutobotBuy(m_exp_buy_time[m_buy_sz-1], 0, 0);}
   //--- Log functions
   string log_txt = string(m_buy_time [m_buy_sz-1]) + " :: " + Symbol() + " :: " + "CALL_M " + string(coleno) + " :: " + "price: " + DoubleToStr(m_buy_price[m_buy_sz-1],_Digits) + " :: " + "exp on: " + string(TimeHour(m_exp_buy_time[m_buy_sz-1]))+ ":" + string(TimeMinute(m_exp_buy_time[m_buy_sz-1]))+ ":" + string(TimeSeconds(m_exp_buy_time[m_buy_sz-1])); 
   if(use_log == 0){Print_Log(log_txt);}
   if(use_print == 0){Print(log_txt);}
  }
  
  //if(m_buy_trigger == true && martin_mode == next_bar && hours == 0 && minutes == 0 && seconds <= sec_shift && m_stat_time < Time[0])
  if(m_buy_trigger == true && martin_mode == next_bar && m_stat_time <= TimeCurrent())
  {
   //m_stat_time = Time[0];
   if(expr_mode == 0){m_stat_time = Time[0] + 60*Period()*ex_bar_shift;}
   if(expr_mode == 1){m_stat_time = TimeCurrent() + 60*ex_min_shift;}
   
   m_buy_sz++;
   ArrayResize(m_buy_price   ,m_buy_sz);
   ArrayResize(m_buy_time    ,m_buy_sz);
   ArrayResize(m_exp_buy_time,m_buy_sz);
   m_buy_price[m_buy_sz-1] = NormalizeDouble(Bid,_Digits);
   m_buy_time [m_buy_sz-1] = TimeCurrent();
   if(expr_mode == 0){m_exp_buy_time[m_buy_sz-1] = Time[0] + 60*Period()*ex_bar_shift;}
   if(expr_mode == 1){m_exp_buy_time[m_buy_sz-1] = TimeCurrent() + 60*ex_min_shift;}
   if(TimeSeconds(m_exp_buy_time[m_buy_sz-1])> 0){while(TimeSeconds(m_exp_buy_time[m_buy_sz-1])>0){m_exp_buy_time[m_buy_sz-1]--;}}
   if(send_signal==0){AutobotBuy(m_exp_buy_time[m_buy_sz-1], 0, 0);}
   //--- Log functions
   string log_txt = string(m_buy_time [m_buy_sz-1]) + " :: " + Symbol() + " :: " + "CALL_M " + string(coleno) + " :: " + "price: " + DoubleToStr(m_buy_price[m_buy_sz-1],_Digits) + " :: " + "exp on: " + string(TimeHour(m_exp_buy_time[m_buy_sz-1]))+ ":" + string(TimeMinute(m_exp_buy_time[m_buy_sz-1]))+ ":" + string(TimeSeconds(m_exp_buy_time[m_buy_sz-1])); 
   if(use_log == 0){Print_Log(log_txt);}
   if(use_print == 0){Print(log_txt);}
  }
  
  if(m_buy_trigger == false && upbuffer[0] != EMPTY_VALUE  && hours == 0 && minutes == 0 && seconds <= sec_shift  && seconds > -1 && stat_time < TimeCurrent())
  {
   if(expr_mode == 0){stat_time = Time[0] + 60*Period()*ex_bar_shift;}
   if(expr_mode == 1){stat_time = TimeCurrent() + 60*ex_min_shift+sec_shift;}
   if(TimeSeconds(stat_time)> 0){while(TimeSeconds(stat_time)>0){stat_time--;}}
   //stat_time = Time[0];
   buy_sz++;
   ArrayResize(buy_price   ,buy_sz);
   ArrayResize(buy_time    ,buy_sz);
   ArrayResize(exp_buy_time,buy_sz);
   buy_price[buy_sz-1] = NormalizeDouble(Bid,_Digits);
   buy_time [buy_sz-1] = TimeCurrent();
   if(expr_mode == 0){exp_buy_time[buy_sz-1] = Time[0] + 60*Period()*ex_bar_shift; stat_time = Time[0] + 60*Period()*ex_bar_shift;}
   if(expr_mode == 1){exp_buy_time[buy_sz-1] = TimeCurrent() + 60*ex_min_shift+sec_shift; stat_time = TimeCurrent() + 60*ex_min_shift+sec_shift;}
   if(TimeSeconds(exp_buy_time[buy_sz-1])> 0){while(TimeSeconds(exp_buy_time[buy_sz-1])>0){exp_buy_time[buy_sz-1]--;}}
   if(send_signal==0){AutobotBuy(exp_buy_time[buy_sz-1], 0, 0);}
   //--- Log functions
   string log_txt = string(buy_time [buy_sz-1]) + " :: " + Symbol() + " :: " + "CALL" + " :: " + "price: " + DoubleToStr(buy_price[buy_sz-1],_Digits) + " :: " + "exp on: " + string(TimeHour(exp_buy_time[buy_sz-1]))+ ":" + string(TimeMinute(exp_buy_time[buy_sz-1]))+ ":" + string(TimeSeconds(exp_buy_time[buy_sz-1])); 
   if(use_log == 0){Print_Log(log_txt);}
   if(use_print == 0){Print(log_txt);}
  }
 }
}
//---
void Sel_signals_procces()
{
 //--- Если старт сигнала настроен по тикам то исполняем данный кусок кода
 if(signal_mode == 0)
 {
  //--- Если есть сигнал на нужном нам баре, то подготавливаем необходимы массивы
  //--- и заполняем их данными
  if(m_sel_trigger == true && martin_mode == next_sig && dnbuffer[0+bar_shift] != EMPTY_VALUE && m_stat_time < Time[0])
  {
   if(expr_mode == 0){m_stat_time = Time[0] + 60*Period()*ex_bar_shift;}
   if(expr_mode == 1){m_stat_time = Time[0] + 60*ex_min_shift;}
   //m_stat_time = Time[0];
   m_sel_sz++;
   ArrayResize(m_sel_price,m_sel_sz);
   ArrayResize(m_sel_time ,m_sel_sz);
   ArrayResize(m_exp_sel_time,m_sel_sz);
   m_sel_price[m_sel_sz-1] = NormalizeDouble(Bid,_Digits);
   m_sel_time [m_sel_sz-1] = Time[0];
   if(expr_mode == 0){m_exp_sel_time[m_sel_sz-1] = Time[0] + 60*Period()*ex_bar_shift;}
   if(expr_mode == 1){m_exp_sel_time[m_sel_sz-1] = Time[0] + 60*ex_min_shift;}
   if(send_signal==0){AutobotSell(m_exp_sel_time[m_sel_sz-1], 0, 0);}
   //--- Log functions
   string log_txt = TimeToStr(Time[0]) + " :: " + Symbol() + " :: " + "PUT_M " + string(coleno) + " :: " + "price: " + DoubleToStr(m_sel_price[m_sel_sz-1],_Digits) + " :: " + "exp on: " + string(TimeHour(m_exp_sel_time[m_sel_sz-1]))+ ":" + string(TimeMinute(m_exp_sel_time[m_sel_sz-1]))+ ":" + string(TimeSeconds(m_exp_sel_time[m_sel_sz-1])); 
   if(use_log == 0){Print_Log(log_txt);}
   if(use_print == 0){Print(log_txt);}
  }
  
  if(m_sel_trigger == true && martin_mode == next_bar && m_stat_time < Time[0])
  {
   //m_stat_time = Time[0];
   if(expr_mode == 0){m_stat_time = Time[0] + 60*Period()*ex_bar_shift;}
   if(expr_mode == 1){m_stat_time = Time[0] + 60*ex_min_shift-60;}
   
   m_sel_sz++;
   ArrayResize(m_sel_price,m_sel_sz);
   ArrayResize(m_sel_time ,m_sel_sz);
   ArrayResize(m_exp_sel_time,m_sel_sz);
   m_sel_price[m_sel_sz-1] = NormalizeDouble(Bid,_Digits);
   m_sel_time [m_sel_sz-1] = Time[0];
   if(expr_mode == 0){m_exp_sel_time[m_sel_sz-1] = Time[0] + 60*Period()*ex_bar_shift;}
   if(expr_mode == 1){m_exp_sel_time[m_sel_sz-1] = Time[0] + 60*ex_min_shift;}
   if(send_signal==0){AutobotSell(m_exp_sel_time[m_sel_sz-1], 0, 0);}
   //--- Log functions
   string log_txt = TimeToStr(Time[0]) + " :: " + Symbol() + " :: " + "PUT_M " + string(coleno) + " :: " + "price: " + DoubleToStr(m_sel_price[m_sel_sz-1],_Digits) + " :: " + "exp on: " + string(TimeHour(m_exp_sel_time[m_sel_sz-1]))+ ":" + string(TimeMinute(m_exp_sel_time[m_sel_sz-1]))+ ":" + string(TimeSeconds(m_exp_sel_time[m_sel_sz-1])); 
   if(use_log == 0){Print_Log(log_txt);}
   if(use_print == 0){Print(log_txt);}
  }
  
  if(m_sel_trigger == false && dnbuffer[0+bar_shift] != EMPTY_VALUE && stat_time < Time[0])
  {
   if(expr_mode == 0){stat_time = Time[0] + 60*Period()*ex_bar_shift;}
   if(expr_mode == 1){stat_time = Time[0] + 60*ex_min_shift;}
   //stat_time = Time[0];
   sel_sz++;
   ArrayResize(sel_price,sel_sz);
   ArrayResize(sel_time ,sel_sz);
   ArrayResize(exp_sel_time,sel_sz);
   sel_price[sel_sz-1] = NormalizeDouble(Bid,_Digits);
   sel_time [sel_sz-1] = Time[0];
   if(expr_mode == 0){exp_sel_time[sel_sz-1] = Time[0] + 60*Period()*ex_bar_shift;}
   if(expr_mode == 1){exp_sel_time[sel_sz-1] = Time[0] + 60*ex_min_shift;}
   if(send_signal==0){AutobotSell(exp_sel_time[sel_sz-1], 0, 0);}
   //--- Log functions
   string log_txt = TimeToStr(Time[0]) + " :: " + Symbol() + " :: " + "PUT " + " :: " + "price: " + DoubleToStr(sel_price[sel_sz-1],_Digits) + " :: " + "exp on: " + string(TimeHour(exp_sel_time[sel_sz-1]))+ ":" + string(TimeMinute(exp_sel_time[sel_sz-1]))+ ":" + string(TimeSeconds(exp_sel_time[sel_sz-1])); 
   if(use_log == 0){Print_Log(log_txt);}
   if(use_print == 0){Print(log_txt);}
  }
 }
 //--- Если старт сигнала настроен по времени то исполняем данный кусок кода
 if(signal_mode == 1)
 {
  //--- Если есть сигнал на нужном нам баре, то подготавливаем необходимы массивы
  //--- и заполняем их данными
  if(m_sel_trigger == true && martin_mode == next_sig && dnbuffer[0] != EMPTY_VALUE && hours == 0 && minutes == 0 && seconds <= sec_shift  && seconds > -1 && m_stat_time < TimeCurrent())
  {
   if(expr_mode == 0){m_stat_time = Time[0] + 60*Period()*ex_bar_shift;}
   if(expr_mode == 1){m_stat_time = TimeCurrent() + 60*tmp_min_shift;}
   if(TimeSeconds(m_stat_time)> 0){while(TimeSeconds(m_stat_time)>0){m_stat_time--;}}
   //m_stat_time = Time[0];
   m_sel_sz++;
   ArrayResize(m_sel_price   ,m_sel_sz);
   ArrayResize(m_sel_time    ,m_sel_sz);
   ArrayResize(m_exp_sel_time,m_sel_sz);
   m_sel_price[m_sel_sz-1] = NormalizeDouble(Bid,_Digits);
   m_sel_time [m_sel_sz-1] = TimeCurrent();
   if(expr_mode == 0){m_exp_sel_time[m_sel_sz-1] = Time[0] + 60*Period()*ex_bar_shift;}
   if(expr_mode == 1){m_exp_sel_time[m_sel_sz-1] = TimeCurrent() + 60*tmp_min_shift;}
   if(TimeSeconds(m_exp_sel_time[m_sel_sz-1])> 0){while(TimeSeconds(m_exp_sel_time[m_sel_sz-1])>0){m_exp_sel_time[m_sel_sz-1]--;}}
   if(send_signal==0){AutobotSell(m_exp_sel_time[m_sel_sz-1], 0, 0);}
   //--- Log functions
   string log_txt = string(m_sel_time [m_sel_sz-1]) + " :: " + Symbol() + " :: " + "PUT_M " + string(coleno) + " :: " + "price: " + DoubleToStr(m_sel_price[m_sel_sz-1],_Digits) + " :: " + "exp on: " + string(TimeHour(m_exp_sel_time[m_sel_sz-1]))+ ":" + string(TimeMinute(m_exp_sel_time[m_sel_sz-1]))+ ":" + string(TimeSeconds(m_exp_sel_time[m_sel_sz-1])); 
   if(use_log == 0){Print_Log(log_txt);}
   if(use_print == 0){Print(log_txt);}
  }
  
  if(m_sel_trigger == true && martin_mode == next_bar && m_stat_time <= TimeCurrent())
  {
   //m_stat_time = Time[0];
   if(expr_mode == 0){m_stat_time = Time[0] + 60*Period()*ex_bar_shift;}
   if(expr_mode == 1){m_stat_time = TimeCurrent() + 60*ex_min_shift;}
   
   m_sel_sz++;
   ArrayResize(m_sel_price   ,m_sel_sz);
   ArrayResize(m_sel_time    ,m_sel_sz);
   ArrayResize(m_exp_sel_time,m_sel_sz);
   m_sel_price[m_sel_sz-1] = NormalizeDouble(Bid,_Digits);
   m_sel_time [m_sel_sz-1] = TimeCurrent();
   if(expr_mode == 0){m_exp_sel_time[m_sel_sz-1] = Time[0] + 60*Period()*ex_bar_shift;}
   if(expr_mode == 1){m_exp_sel_time[m_sel_sz-1] = TimeCurrent() + 60*ex_min_shift;}
   if(TimeSeconds(m_exp_sel_time[m_sel_sz-1])> 0){while(TimeSeconds(m_exp_sel_time[m_sel_sz-1])>0){m_exp_sel_time[m_sel_sz-1]--;}}
   if(send_signal==0){AutobotSell(m_exp_sel_time[m_sel_sz-1], 0, 0);}
   //--- Log functions
   string log_txt = string(m_sel_time [m_sel_sz-1]) + " :: " + Symbol() + " :: " + "PUT_M " + string(coleno) + " :: " + "price: " + DoubleToStr(m_sel_price[m_sel_sz-1],_Digits) + " :: " + "exp on: " + string(TimeHour(m_exp_sel_time[m_sel_sz-1]))+ ":" + string(TimeMinute(m_exp_sel_time[m_sel_sz-1]))+ ":" + string(TimeSeconds(m_exp_sel_time[m_sel_sz-1])); 
   if(use_log == 0){Print_Log(log_txt);}
   if(use_print == 0){Print(log_txt);}
  }
  
  if(m_sel_trigger == false && dnbuffer[0] != EMPTY_VALUE && hours == 0 && minutes == 0 && seconds <= sec_shift  && seconds > -1 && stat_time < Time[0])
  {
   if(expr_mode == 0){stat_time = Time[0] + 60*Period()*ex_bar_shift;}
   if(expr_mode == 1){stat_time = TimeCurrent() + 60*ex_min_shift+sec_shift;}
   if(TimeSeconds(stat_time)> 0){while(TimeSeconds(stat_time)>0){stat_time--;}}
   //stat_time = Time[0];
   sel_sz++;
   ArrayResize(sel_price,sel_sz);
   ArrayResize(sel_time ,sel_sz);
   ArrayResize(exp_sel_time,sel_sz);
   sel_price[sel_sz-1] = NormalizeDouble(Bid,_Digits);
   sel_time [sel_sz-1] = TimeCurrent();
   if(expr_mode == 0){exp_sel_time[sel_sz-1] = Time[0] + 60*Period()*ex_bar_shift;}
   if(expr_mode == 1){exp_sel_time[sel_sz-1] = TimeCurrent() + 60*ex_min_shift+sec_shift;}
   if(TimeSeconds(exp_sel_time[sel_sz-1])> 0){while(TimeSeconds(exp_sel_time[sel_sz-1])>0){m_exp_sel_time[sel_sz-1]--;}}
   if(send_signal==0){AutobotSell(exp_sel_time[sel_sz-1], 0, 0);}
   //--- Log functions
   string log_txt = string(sel_time [sel_sz-1]) + " :: " + Symbol() + " :: " + "PUT " + " :: " + "price: " + DoubleToStr(sel_price[sel_sz-1],_Digits) + " :: " + "exp on: " + string(TimeHour(exp_sel_time[sel_sz-1]))+ ":" + string(TimeMinute(exp_sel_time[sel_sz-1]))+ ":" + string(TimeSeconds(exp_sel_time[sel_sz-1])); 
   if(use_log == 0){Print_Log(log_txt);}
   if(use_print == 0){Print(log_txt);}
  }
 }
}
//+------------------------------------------------------------------+
//| Функции расчета результатов сделок                               |
//+------------------------------------------------------------------+
void Buy_stat_procces()
{
 //--- Начинаем перебор массивов, где хранятся сделки на покупку(CALL)
 for(int x=(buy_sz-1);x>-1;x--)
 {
  //--- Проверяем прибыльные сделки
  if(buy_price[x] > 0 && buy_price[x] < NormalizeDouble(Bid,_Digits) && TimeCurrent() >= exp_buy_time[x] && m_buy_trigger == false)
  {
   if(use_martin == onn && martin_mode == next_sig)
   {
    if(m_buy_trigger == true || m_sel_trigger == true){m_wins++;}
    if(m_buy_trigger == false && m_sel_trigger == false){wins++;}
   }
   if(use_martin == onn && martin_mode == next_bar){wins++;}
   if(use_martin == off){wins++;}
   if(martin_mode == next_sig){m_sel_trigger = false;}
   //---
   string log_txt = TimeToString(exp_buy_time[x],TIME_DATE|TIME_SECONDS) + " :: " + "Сделка CALL была закрыта по цене: " + DoubleToString(Bid,_Digits) + " с прибылью";
   if(use_log == 0){Print_Log(log_txt);}
   if(use_print == 0){Print(log_txt);}
   buy_price[x] = 0;exp_buy_time[x] = 0;coleno = 0;
   
  }
  //--- Проверяем убыточные сделки
  if(buy_price[x] > 0 && buy_price[x] > NormalizeDouble(Bid,_Digits) && TimeCurrent() >= exp_buy_time[x] && m_buy_trigger == false)
  {
   if(use_martin == onn && martin_mode == next_sig){if(m_buy_trigger == true || m_sel_trigger == true){m_losses++;}}
   if(use_martin == off){losses++;}   
   //---
   string log_txt = TimeToString(exp_buy_time[x],TIME_DATE|TIME_SECONDS) + " :: " + "Сделка CALL была закрыта по цене: " + DoubleToString(Bid,_Digits) +" в убыток";
   if(use_log == 0){Print_Log(log_txt);}
   if(use_print == 0){Print(log_txt);}
   buy_price[x] = 0;exp_buy_time[x] = 0;
   //--- Далее, если включен Мартин, то выполняем ети функции
   if(use_martin == onn)
   {
    if(martin_mode == next_sig){m_sel_trigger = true;}
    m_buy_trigger = true;coleno++;
    if(coleno > martin_cnt){m_buy_trigger = false;m_sel_trigger = false;losses++;coleno=0;}
    if(martin_mode == next_sig){m_stat_time = Time[0];}
   }
  }
 }
 
 //--- Начинаем перебор массивов, где хранятся сделки на покупку по Мартину(Martin_CALL)
 for(int y=(m_buy_sz-1);y>-1;y--)
 {
  //--- Проверяем прибыльные сделки
  if(m_buy_price[y] > 0 && m_buy_price[y] < NormalizeDouble(Bid,_Digits) && TimeCurrent() >= m_exp_buy_time[y] && m_buy_trigger == true)
  {
   m_buy_trigger = false;m_sel_trigger = false;
   if(martin_mode == next_sig){m_sel_trigger = false; stat_time = Time[0]; m_stat_time = Time[0];}
   string log_txt = TimeToString(m_exp_buy_time[y],TIME_DATE|TIME_SECONDS) + " :: " + "Сделка CALL по Мартину была закрыта по цене: " + DoubleToString(Bid,_Digits) + " с прибылью";
   if(use_log == 0){Print_Log(log_txt);}
   if(use_print == 0){Print(log_txt);}
   m_buy_price[y] = 0;m_exp_buy_time[y] = 0;coleno = 0;m_wins++;wins++;
   //---
   
  }
  //--- Проверяем убыточные сделки
  if(m_buy_price[y] > 0 && m_buy_price[y] > NormalizeDouble(Bid,_Digits) && TimeCurrent() >= m_exp_buy_time[y] && m_buy_trigger == true)
  {
   if(use_dodge == onn && m_buy_price[y] == NormalizeDouble(Bid,_Digits))
   {
    m_losses++;losses++;coleno = 0; m_buy_trigger = false;m_sel_trigger = false;stat_time = Time[0];m_stat_time = Time[0];
    string log_txt = TimeToString(m_exp_buy_time[y],TIME_DATE|TIME_SECONDS) + " :: " + "Сделка CALL по Мартину была закрыта по цене: " + DoubleToString(Bid,_Digits) +" в убыток по доджу. Серия прекращена.";
    if(use_log == 0){Print_Log(log_txt);}
    if(use_print == 0){Print(log_txt);}
    m_buy_price[y] = 0;m_exp_buy_time[y] = 0;
    return;
   }
   //---
   string log_txt = TimeToString(m_exp_buy_time[y],TIME_DATE|TIME_SECONDS) + " :: " + "Сделка CALL по Мартину была закрыта по цене: " + DoubleToString(Bid,_Digits) +" в убыток";
   if(use_log == 0){Print_Log(log_txt);}
   if(use_print == 0){Print(log_txt);}
   m_buy_price[y] = 0;m_exp_buy_time[y] = 0;m_losses++;
   //--- Далее, если включен Мартин, то выполняем ети функции
   if(use_martin == onn)
   {
    if(martin_mode == next_sig){m_sel_trigger = true;}
    m_buy_trigger = true;coleno++;
    if(coleno > martin_cnt){m_buy_trigger = false;m_sel_trigger = false;losses++;coleno=0;}
    if(martin_mode == next_sig){m_stat_time = Time[0];}
   }
  }
 }
 
}


void Sel_stat_procces()
{
 //--- Начинаем перебор массивов, где хранятся сделки на продажу(PUT) 
 for(int x=(sel_sz-1);x>-1;x--)
 {
  //--- Проверяем прибыльные сделки
  if(sel_price[x] > 0 && sel_price[x] > NormalizeDouble(Bid,_Digits) && TimeCurrent() >= exp_sel_time[x] && m_sel_trigger == false)
  {
   if(use_martin == onn && martin_mode == next_sig)
   {
    if(m_buy_trigger == true || m_sel_trigger == true){m_wins++;}
    if(m_buy_trigger == false && m_sel_trigger == false){wins++;}
   }
   if(use_martin == onn && martin_mode == next_bar){wins++;}
   if(use_martin == off){wins++;}
   if(martin_mode == next_sig){m_buy_trigger = false;}
   //---
   string log_txt = TimeToString(exp_sel_time[x],TIME_DATE|TIME_SECONDS) + " :: " + "Сделка PUT была закрыта по цене: " + DoubleToString(Bid,_Digits) + " с прибылью";
   if(use_log == 0){Print_Log(log_txt);}
   if(use_print == 0){Print(log_txt);}
   sel_price[x] = 0;exp_sel_time[x] = 0;coleno = 0; 
   
  }
  //--- Проверяем убыточные сделки
  if(sel_price[x] > 0 && sel_price[x] < NormalizeDouble(Bid,_Digits) && TimeCurrent() >= exp_sel_time[x] && m_sel_trigger == false)
  {
   if(use_martin == onn && martin_mode == next_sig){if(m_buy_trigger == true || m_sel_trigger == true){m_losses++;}}
   if(use_martin == off){losses++;}   
   //---
   string log_txt = TimeToString(exp_sel_time[x],TIME_DATE|TIME_SECONDS) + " :: " + "Сделка PUT была закрыта по цене: " + DoubleToString(Bid,_Digits) + " в убыток";
   if(use_log == 0){Print_Log(log_txt);}
   if(use_print == 0){Print(log_txt);}
   sel_price[x] = 0;exp_sel_time[x] = 0;
   
   //--- Далее, если включен Мартин, то выполняем ети функции
   if(use_martin == onn)
   {
    if(martin_mode == next_sig){m_buy_trigger = true;}
    m_sel_trigger = true;coleno++;
    if(coleno > martin_cnt){m_buy_trigger = false;m_sel_trigger = false;losses++;coleno=0;}
    if(martin_mode == next_sig){m_stat_time = Time[0];}
   }
  }
 }
 
  //--- Начинаем перебор массивов, где хранятся сделки на продажу по Мартину(Martin_PUT) 
 for(int y=(m_sel_sz-1);y>-1;y--)
 {
  //--- Проверяем прибыльные сделки
  if(m_sel_price[y] > 0 && m_sel_price[y] > NormalizeDouble(Bid,_Digits) && TimeCurrent() >= m_exp_sel_time[y] && m_sel_trigger == true)
  {
   m_buy_trigger = false;m_sel_trigger = false;
   if(martin_mode == next_sig){m_buy_trigger = false; stat_time = Time[0]; m_stat_time = Time[0];}
   string log_txt = TimeToString(m_exp_sel_time[y],TIME_DATE|TIME_SECONDS) + " :: " + "Сделка PUT по мартину была закрыта по цене: " + DoubleToString(Bid,_Digits) + " с прибылью";
   if(use_log == 0){Print_Log(log_txt);}
   if(use_print == 0){Print(log_txt);}
   m_sel_price[y] = 0;m_exp_sel_time[y] = 0;coleno = 0;m_wins++;wins++;
   //---
  }
  //--- Проверяем убыточные сделки
  if(m_sel_price[y] > 0 && m_sel_price[y] < NormalizeDouble(Bid,_Digits) && TimeCurrent() >= m_exp_sel_time[y] && m_sel_trigger == true)
  {
   if(use_dodge == onn && m_sel_price[y] == NormalizeDouble(Bid,_Digits))
   {
    m_losses++;losses++;coleno = 0; m_buy_trigger = false;m_sel_trigger = false;stat_time = Time[0];m_stat_time = Time[0];
    string log_txt = TimeToString(m_exp_sel_time[y],TIME_DATE|TIME_SECONDS) + " :: " + "Сделка PUT по мартину была закрыта по цене: " + DoubleToString(Bid,_Digits) + " в убыток по доджу. Серия прекращена.";
    if(use_log == 0){Print_Log(log_txt);}
    if(use_print == 0){Print(log_txt);}
    m_sel_price[y] = 0;m_exp_sel_time[y] = 0;
    return;
   }
   string log_txt = TimeToString(m_exp_sel_time[y],TIME_DATE|TIME_SECONDS) + " :: " + "Сделка PUT по мартину была закрыта по цене: " + DoubleToString(Bid,_Digits) + " в убыток";
   if(use_log == 0){Print_Log(log_txt);}
   if(use_print == 0){Print(log_txt);}
   m_sel_price[y] = 0;m_exp_sel_time[y] = 0;m_losses++;
   //---
   
   //--- Далее, если включен Мартин, то выполняем ети функции
   if(use_martin == onn)
   {
    if(martin_mode == next_sig){m_buy_trigger = true;}
    m_sel_trigger = true;coleno++;
    if(coleno > martin_cnt){m_buy_trigger = false;m_sel_trigger = false;losses++;coleno=0;}
    if(martin_mode == next_sig){m_stat_time = Time[0];}
   }
  }
 }
}

//+------------------------------------------------------------------+
//| Функции отправки сигналов на сервис                               |
//+------------------------------------------------------------------+
void AutobotBuy(long exptime, double amount, int expsec)
{
   string symb_buy=StringSubstr(Symbol(),0,6);
   
   //int expmin = Period();
   //if(expr_mode == 0){expmin = (60*Period()*ex_bar_shift) / 60;}
   //if(expr_mode == 1){expmin = (60*ex_min_shift) / 60;}
   
   if(amount == 0 && expsec == 0)
   {
      string msg = string("{ \"notify_type\" : \"signal\", \"callput\" : \"CALL\", \"symbol\" : \"" + symb_buy + "\", \"tfdigi\" : \"" + string(expsec) + "\", \"tfdur\" : \"s\", \"date_expiry\" : \"" + string((long)exptime+(gmt_shift*3600)) + "\", \"logints\" : \""+ab_name+"\", \"passts\" : \"" + ab_pass + "\", \"martin\" : \"" + string(coleno) + "\"}");
      
      if (netw_mode == udp_mode || netw_mode == tcp_and_udp_mode) {
         UDPMessage(msg);
      }
      if (netw_mode == tcp_mode || netw_mode == tcp_and_udp_mode) {
         TCPMessage(TcpServer, TcpPort, msg);
      }
      
      if(use_print == 0){Print(msg);}
   }else{
      // От ручных сигналов
      if(expsec <= 60 && expsec > 20){
         string msg = string("{ \"notify_type\" : \"signal\", \"callput\" : \"CALL\", \"symbol\" : \"" + symb_buy + "\", \"tfdigi\" : \"" + string(expsec) + "\", \"tfdur\" : \"s\", \"date_expiry\" : \"\", \"logints\" : \""+ab_name+"\", \"passts\" : \"" + ab_pass + "\", \"martin\" : \"0\", \"lot\" : \"" + string(amount) + "\"}");
         
         if (netw_mode == udp_mode || netw_mode == tcp_and_udp_mode) {
            UDPMessage(msg);
         }
         if (netw_mode == tcp_mode || netw_mode == tcp_and_udp_mode) {
            TCPMessage(TcpServer, TcpPort, msg);
         }
         
         if(use_print == 0){Print(msg);}
      }
      if(expsec > 60){
         string msg = string("{ \"notify_type\" : \"signal\", \"callput\" : \"CALL\", \"symbol\" : \"" + symb_buy + "\", \"tfdigi\" : \"" + string(expsec) + "\", \"tfdur\" : \"s\", \"date_expiry\" : \"" + string((long)exptime+(gmt_shift*3600)) + "\", \"logints\" : \""+ab_name+"\", \"passts\" : \"" + ab_pass + "\", \"martin\" : \"0\", \"lot\" : \"" + string(amount) + "\"}");
         
         if (netw_mode == udp_mode || netw_mode == tcp_and_udp_mode) {
            UDPMessage(msg);
         }
         if (netw_mode == tcp_mode || netw_mode == tcp_and_udp_mode) {
            TCPMessage(TcpServer, TcpPort, msg);
         }
         
         if(use_print == 0){Print(msg);}
      }
   }
   
   drawEntryLine(true);
}

//---

void AutobotSell(long exptime, double amount, int expsec) 
{
   string symb_sell=StringSubstr(Symbol(),0,6);
   
   //int expmin = Period();
   //if(expr_mode == 0){expmin = (60*Period()*ex_bar_shift) / 60;}
   //if(expr_mode == 1){expmin = (60*ex_min_shift) / 60;}
   
   if(amount == 0 && expsec == 0)
   {
      string msg = string("{ \"notify_type\" : \"signal\", \"callput\" : \"PUT\", \"symbol\" : \"" + symb_sell + "\", \"tfdigi\" : \"" + string(expsec) + "\", \"tfdur\" : \"s\", \"date_expiry\" : \"" + string((long)exptime+(gmt_shift*3600)) + "\", \"logints\" : \""+ab_name+"\", \"passts\" : \"" + ab_pass + "\", \"martin\" : \"" + string(coleno) + "\"}");
      
      if (netw_mode == udp_mode || netw_mode == tcp_and_udp_mode) {
         UDPMessage(msg);
      }
      if (netw_mode == tcp_mode || netw_mode == tcp_and_udp_mode) {
         TCPMessage(TcpServer, TcpPort, msg);
      }
      
      if(use_print == 0){Print(msg);}
   }else{
      // От ручных сигналов
      if(expsec <= 60 && expsec > 20){
         string msg = string("{ \"notify_type\" : \"signal\", \"callput\" : \"PUT\", \"symbol\" : \"" + symb_sell + "\", \"tfdigi\" : \"" + string(expsec) + "\", \"tfdur\" : \"s\", \"date_expiry\" : \"\", \"logints\" : \""+ab_name+"\", \"passts\" : \"" + ab_pass + "\", \"martin\" : \"0\", \"lot\" : \"" + string(amount) + "\"}");
         
         if (netw_mode == udp_mode || netw_mode == tcp_and_udp_mode) {
            UDPMessage(msg);
         }
         if (netw_mode == tcp_mode || netw_mode == tcp_and_udp_mode) {
            TCPMessage(TcpServer, TcpPort, msg);
         }
         
         if(use_print == 0){Print(msg);}
      }
      if(expsec > 60){
         string msg = string("{ \"notify_type\" : \"signal\", \"callput\" : \"PUT\", \"symbol\" : \"" + symb_sell + "\", \"tfdigi\" : \"" + string(expsec) + "\", \"tfdur\" : \"s\", \"date_expiry\" : \"" + string((long)exptime+(gmt_shift*3600)) + "\", \"logints\" : \""+ab_name+"\", \"passts\" : \"" + ab_pass + "\", \"martin\" : \"0\", \"lot\" : \"" + string(amount) + "\"}");
         
         if (netw_mode == udp_mode || netw_mode == tcp_and_udp_mode) {
            UDPMessage(msg);
         }
         if (netw_mode == tcp_mode || netw_mode == tcp_and_udp_mode) {
            TCPMessage(TcpServer, TcpPort, msg);
         }
         
         if(use_print == 0){Print(msg);}
      }
   }
   
   drawEntryLine(false);
}
//+------------------------------------------------------------------+
//| Функции алертов                                                  |
//+------------------------------------------------------------------+
void notifysell()
{
 if(signal == signalsound && bartime < Time[0]){bartime = Time[0];PlaySound(sound_file);}
 if(signal == signalalert && bartime < Time[0]){bartime = Time[0];Alert(Symbol() + " ::: Signal SELL ");}
}
void notifybuy()
{
 if(signal == signalsound && bartime < Time[0]){bartime = Time[0];PlaySound(sound_file);}
 if(signal == signalalert && bartime < Time[0]){bartime = Time[0];Alert(Symbol() + " ::: Signal BUY ");}
}
//+------------------------------------------------------------------+
//| Функция отрисовки таймера закрытия свечи на графике              |
//+------------------------------------------------------------------+
void Printing_timer()
{
 if(ObjectFind("time") != 0) 
 {
  ObjectCreate ("time", OBJ_TEXT, 0, Time[0], Bid - Font_Size*Point);
  ObjectSet    ("time",OBJPROP_BACK, false);
  ObjectSetText("time", "                  « " + string(hours) + ":" + string(minutes) + ":" + string(seconds),Font_Size,Font,Font_Color);
 } 
 else 
 {
  ObjectSetText("time", "                  « " + string(hours) + ":" + string(minutes) + ":" + string(seconds),Font_Size,Font,Font_Color);
  ObjectMove   ("time", 0, Time[0], Bid - Font_Size*Point);
 }
}

//+------------------------------------------------------------------+
//| Функция создания кнопок на графике                               |
//+------------------------------------------------------------------+
void CreateButtons()
{
 
 ObjectCreate    (0,call_btn,OBJ_BUTTON,0,0,0);
 ObjectSetInteger(0,call_btn,OBJPROP_XDISTANCE,130);
 ObjectSetInteger(0,call_btn,OBJPROP_YDISTANCE,20);
 ObjectSetInteger(0,call_btn,OBJPROP_XSIZE,35);
 ObjectSetInteger(0,call_btn,OBJPROP_YSIZE,25);
 ObjectSetInteger(0,call_btn,OBJPROP_CORNER,CORNER_RIGHT_UPPER);
 ObjectSetString (0,call_btn,OBJPROP_TEXT,"й");
 ObjectSetString (0,call_btn,OBJPROP_FONT,"Wingdings");
 ObjectSetInteger(0,call_btn,OBJPROP_FONTSIZE,10);
 ObjectSetInteger(0,call_btn,OBJPROP_COLOR,clrWhite);
 ObjectSetInteger(0,call_btn,OBJPROP_BGCOLOR,clrDarkGreen);
 ObjectSetInteger(0,call_btn,OBJPROP_BORDER_COLOR,clrWhite);
 ObjectSetInteger(0,call_btn,OBJPROP_BACK,false);
 ObjectSetInteger(0,call_btn,OBJPROP_STATE,false);
 ObjectSetInteger(0,call_btn,OBJPROP_SELECTABLE,false);
 ObjectSetInteger(0,call_btn,OBJPROP_SELECTED,false);
 ObjectSetInteger(0,call_btn,OBJPROP_HIDDEN,true);
 ObjectSetInteger(0,call_btn,OBJPROP_ZORDER, 100);
 //--- 
 ObjectCreate    (0,put_btn,OBJ_BUTTON,0,0,0);
 ObjectSetInteger(0,put_btn,OBJPROP_XDISTANCE,130);
 ObjectSetInteger(0,put_btn,OBJPROP_YDISTANCE,50);
 ObjectSetInteger(0,put_btn,OBJPROP_XSIZE,35);
 ObjectSetInteger(0,put_btn,OBJPROP_YSIZE,25);
 ObjectSetInteger(0,put_btn,OBJPROP_CORNER,CORNER_RIGHT_UPPER);
 ObjectSetString (0,put_btn,OBJPROP_TEXT,"к");
 ObjectSetString (0,put_btn,OBJPROP_FONT,"Wingdings");
 ObjectSetInteger(0,put_btn,OBJPROP_FONTSIZE,10);
 ObjectSetInteger(0,put_btn,OBJPROP_COLOR,clrWhite);
 ObjectSetInteger(0,put_btn,OBJPROP_BGCOLOR,clrCrimson);
 ObjectSetInteger(0,put_btn,OBJPROP_BORDER_COLOR,clrWhite);
 ObjectSetInteger(0,put_btn,OBJPROP_BACK,false);
 ObjectSetInteger(0,put_btn,OBJPROP_STATE,false);
 ObjectSetInteger(0,put_btn,OBJPROP_SELECTABLE,false);
 ObjectSetInteger(0,put_btn,OBJPROP_SELECTED,false);
 ObjectSetInteger(0,put_btn,OBJPROP_HIDDEN,true);
 ObjectSetInteger(0,put_btn,OBJPROP_ZORDER, 100);
 //--- 
 ObjectCreate    (0,call_end_bar_btn,OBJ_BUTTON,0,0,0);
 ObjectSetInteger(0,call_end_bar_btn,OBJPROP_XDISTANCE,90);
 ObjectSetInteger(0,call_end_bar_btn,OBJPROP_YDISTANCE,20);
 ObjectSetInteger(0,call_end_bar_btn,OBJPROP_XSIZE,35);
 ObjectSetInteger(0,call_end_bar_btn,OBJPROP_YSIZE,25);
 ObjectSetInteger(0,call_end_bar_btn,OBJPROP_CORNER,CORNER_RIGHT_UPPER);
 ObjectSetString (0,call_end_bar_btn,OBJPROP_TEXT,"йM");
 ObjectSetString (0,call_end_bar_btn,OBJPROP_FONT,"Wingdings");
 ObjectSetInteger(0,call_end_bar_btn,OBJPROP_FONTSIZE,10);
 ObjectSetInteger(0,call_end_bar_btn,OBJPROP_COLOR,clrWhite);
 ObjectSetInteger(0,call_end_bar_btn,OBJPROP_BGCOLOR,clrDarkGreen);
 ObjectSetInteger(0,call_end_bar_btn,OBJPROP_BORDER_COLOR,clrWhite);
 ObjectSetInteger(0,call_end_bar_btn,OBJPROP_BACK,false);
 ObjectSetInteger(0,call_end_bar_btn,OBJPROP_STATE,false);
 ObjectSetInteger(0,call_end_bar_btn,OBJPROP_SELECTABLE,false);
 ObjectSetInteger(0,call_end_bar_btn,OBJPROP_SELECTED,false);
 ObjectSetInteger(0,call_end_bar_btn,OBJPROP_HIDDEN,true);
 ObjectSetInteger(0,call_end_bar_btn,OBJPROP_ZORDER, 100);
 //---
 ObjectCreate    (0,put_end_bar_btn,OBJ_BUTTON,0,0,0);
 ObjectSetInteger(0,put_end_bar_btn,OBJPROP_XDISTANCE,90);
 ObjectSetInteger(0,put_end_bar_btn,OBJPROP_YDISTANCE,50);
 ObjectSetInteger(0,put_end_bar_btn,OBJPROP_XSIZE,35);
 ObjectSetInteger(0,put_end_bar_btn,OBJPROP_YSIZE,25);
 ObjectSetInteger(0,put_end_bar_btn,OBJPROP_CORNER,CORNER_RIGHT_UPPER);
 ObjectSetString (0,put_end_bar_btn,OBJPROP_TEXT,"кM");
 ObjectSetString (0,put_end_bar_btn,OBJPROP_FONT,"Wingdings");
 ObjectSetInteger(0,put_end_bar_btn,OBJPROP_FONTSIZE,10);
 ObjectSetInteger(0,put_end_bar_btn,OBJPROP_COLOR,clrWhite);
 ObjectSetInteger(0,put_end_bar_btn,OBJPROP_BGCOLOR,clrCrimson);
 ObjectSetInteger(0,put_end_bar_btn,OBJPROP_BORDER_COLOR,clrWhite);
 ObjectSetInteger(0,put_end_bar_btn,OBJPROP_BACK,false);
 ObjectSetInteger(0,put_end_bar_btn,OBJPROP_STATE,false);
 ObjectSetInteger(0,put_end_bar_btn,OBJPROP_SELECTABLE,false);
 ObjectSetInteger(0,put_end_bar_btn,OBJPROP_SELECTED,false);
 ObjectSetInteger(0,put_end_bar_btn,OBJPROP_HIDDEN,true);
 ObjectSetInteger(0,put_end_bar_btn,OBJPROP_ZORDER, 100);
 //--- 
 ObjectCreate    (0,call_timer_btn,OBJ_BUTTON,0,0,0);
 ObjectSetInteger(0,call_timer_btn,OBJPROP_XDISTANCE,50);
 ObjectSetInteger(0,call_timer_btn,OBJPROP_YDISTANCE,20);
 ObjectSetInteger(0,call_timer_btn,OBJPROP_XSIZE,35);
 ObjectSetInteger(0,call_timer_btn,OBJPROP_YSIZE,25);
 ObjectSetInteger(0,call_timer_btn,OBJPROP_CORNER,CORNER_RIGHT_UPPER);
 ObjectSetString (0,call_timer_btn,OBJPROP_TEXT,"йё");
 ObjectSetString (0,call_timer_btn,OBJPROP_FONT,"Wingdings");
 ObjectSetInteger(0,call_timer_btn,OBJPROP_FONTSIZE,10);
 ObjectSetInteger(0,call_timer_btn,OBJPROP_COLOR,clrWhite);
 ObjectSetInteger(0,call_timer_btn,OBJPROP_BGCOLOR,clrDarkGreen);
 ObjectSetInteger(0,call_timer_btn,OBJPROP_BORDER_COLOR,clrWhite);
 ObjectSetInteger(0,call_timer_btn,OBJPROP_BACK,false);
 ObjectSetInteger(0,call_timer_btn,OBJPROP_STATE,false);
 ObjectSetInteger(0,call_timer_btn,OBJPROP_SELECTABLE,false);
 ObjectSetInteger(0,call_timer_btn,OBJPROP_SELECTED,false);
 ObjectSetInteger(0,call_timer_btn,OBJPROP_HIDDEN,true);
 ObjectSetInteger(0,call_timer_btn,OBJPROP_ZORDER, 100);
 //--- 
 ObjectCreate    (0,put_timer_btn,OBJ_BUTTON,0,0,0);
 ObjectSetInteger(0,put_timer_btn,OBJPROP_XDISTANCE,50);
 ObjectSetInteger(0,put_timer_btn,OBJPROP_YDISTANCE,50);
 ObjectSetInteger(0,put_timer_btn,OBJPROP_XSIZE,35);
 ObjectSetInteger(0,put_timer_btn,OBJPROP_YSIZE,25);
 ObjectSetInteger(0,put_timer_btn,OBJPROP_CORNER,CORNER_RIGHT_UPPER);
 ObjectSetString (0,put_timer_btn,OBJPROP_TEXT,"кё");
 ObjectSetString (0,put_timer_btn,OBJPROP_FONT,"Wingdings");
 ObjectSetInteger(0,put_timer_btn,OBJPROP_FONTSIZE,10);
 ObjectSetInteger(0,put_timer_btn,OBJPROP_COLOR,clrWhite);
 ObjectSetInteger(0,put_timer_btn,OBJPROP_BGCOLOR,clrCrimson);
 ObjectSetInteger(0,put_timer_btn,OBJPROP_BORDER_COLOR,clrWhite);
 ObjectSetInteger(0,put_timer_btn,OBJPROP_BACK,false);
 ObjectSetInteger(0,put_timer_btn,OBJPROP_STATE,false);
 ObjectSetInteger(0,put_timer_btn,OBJPROP_SELECTABLE,false);
 ObjectSetInteger(0,put_timer_btn,OBJPROP_SELECTED,false);
 ObjectSetInteger(0,put_timer_btn,OBJPROP_HIDDEN,true);
 ObjectSetInteger(0,put_timer_btn,OBJPROP_ZORDER, 100);
 //--- 
 ObjectCreate    (0,cancell_btn,OBJ_BUTTON,0,0,0);
 ObjectSetInteger(0,cancell_btn,OBJPROP_XDISTANCE,130);
 ObjectSetInteger(0,cancell_btn,OBJPROP_YDISTANCE,80);
 ObjectSetInteger(0,cancell_btn,OBJPROP_XSIZE,115);
 ObjectSetInteger(0,cancell_btn,OBJPROP_YSIZE,25);
 ObjectSetInteger(0,cancell_btn,OBJPROP_CORNER,CORNER_RIGHT_UPPER);
 ObjectSetString (0,cancell_btn,OBJPROP_TEXT,"-- :: CANCELL :: --");
 ObjectSetString (0,cancell_btn,OBJPROP_FONT,"Calibri");
 ObjectSetInteger(0,cancell_btn,OBJPROP_FONTSIZE,10);
 ObjectSetInteger(0,cancell_btn,OBJPROP_COLOR,clrWhite);
 ObjectSetInteger(0,cancell_btn,OBJPROP_BGCOLOR,clrRed);
 ObjectSetInteger(0,cancell_btn,OBJPROP_BORDER_COLOR,clrWhite);
 ObjectSetInteger(0,cancell_btn,OBJPROP_BACK,false);
 ObjectSetInteger(0,cancell_btn,OBJPROP_STATE,false);
 ObjectSetInteger(0,cancell_btn,OBJPROP_SELECTABLE,false);
 ObjectSetInteger(0,cancell_btn,OBJPROP_SELECTED,false);
 ObjectSetInteger(0,cancell_btn,OBJPROP_HIDDEN,true);
 ObjectSetInteger(0,cancell_btn,OBJPROP_ZORDER, 100);
 //--- 
 ObjectCreate(0,ramka1,OBJ_RECTANGLE_LABEL,0,0,0);
 ObjectSetInteger(0,ramka1,OBJPROP_XDISTANCE,135); 
 ObjectSetInteger(0,ramka1,OBJPROP_YDISTANCE,15); 
 ObjectSetInteger(0,ramka1,OBJPROP_XSIZE,125); 
 ObjectSetInteger(0,ramka1,OBJPROP_YSIZE,95); 
 ObjectSetInteger(0,ramka1,OBJPROP_BGCOLOR,clrNONE); 
 ObjectSetInteger(0,ramka1,OBJPROP_BORDER_TYPE,BORDER_FLAT); 
 ObjectSetInteger(0,ramka1,OBJPROP_CORNER,CORNER_RIGHT_UPPER); 
 ObjectSetInteger(0,ramka1,OBJPROP_COLOR,clrGray); 
 ObjectSetInteger(0,ramka1,OBJPROP_STYLE,STYLE_SOLID); 
 ObjectSetInteger(0,ramka1,OBJPROP_WIDTH,3); 
 ObjectSetInteger(0,ramka1,OBJPROP_BACK,true); 
 ObjectSetInteger(0,ramka1,OBJPROP_SELECTABLE,false); 
 ObjectSetInteger(0,ramka1,OBJPROP_SELECTED,false); 
 ObjectSetInteger(0,ramka1,OBJPROP_HIDDEN,true); 
 ObjectSetInteger(0,ramka1,OBJPROP_ZORDER,0); 
 //--- 
 ObjectCreate(0,ramka2,OBJ_RECTANGLE_LABEL,0,0,0);
 ObjectSetInteger(0,ramka2,OBJPROP_XDISTANCE,135); 
 ObjectSetInteger(0,ramka2,OBJPROP_YDISTANCE,111); 
 ObjectSetInteger(0,ramka2,OBJPROP_XSIZE,125); 
 ObjectSetInteger(0,ramka2,OBJPROP_YSIZE,80); 
 ObjectSetInteger(0,ramka2,OBJPROP_BGCOLOR,clrNONE); 
 ObjectSetInteger(0,ramka2,OBJPROP_BORDER_TYPE,BORDER_FLAT); 
 ObjectSetInteger(0,ramka2,OBJPROP_CORNER,CORNER_RIGHT_UPPER); 
 ObjectSetInteger(0,ramka2,OBJPROP_COLOR,clrGray); 
 ObjectSetInteger(0,ramka2,OBJPROP_STYLE,STYLE_SOLID); 
 ObjectSetInteger(0,ramka2,OBJPROP_WIDTH,3); 
 ObjectSetInteger(0,ramka2,OBJPROP_BACK,true); 
 ObjectSetInteger(0,ramka2,OBJPROP_SELECTABLE,false); 
 ObjectSetInteger(0,ramka2,OBJPROP_SELECTED,false); 
 ObjectSetInteger(0,ramka2,OBJPROP_HIDDEN,true); 
 ObjectSetInteger(0,ramka2,OBJPROP_ZORDER,0);
 //--- 
 ObjectCreate (lot_label, OBJ_LABEL,0, 0, 0);
 ObjectSet    (lot_label, OBJPROP_CORNER,CORNER_RIGHT_UPPER);
 ObjectSet    (lot_label, OBJPROP_XDISTANCE, 65);
 ObjectSet    (lot_label, OBJPROP_YDISTANCE, 115);
 ObjectSet    (lot_label, OBJPROP_SELECTABLE,false);
 ObjectSet    (lot_label, OBJPROP_SELECTED,false);
 ObjectSet    (lot_label, OBJPROP_HIDDEN,true);
 ObjectSetText(lot_label,"ВЫБОР ЛОТА: ",8,"Calibri",clrGold); 
 //--- 
 ObjectCreate    (0,lot1_btn,OBJ_BUTTON,0,0,0);
 ObjectSetInteger(0,lot1_btn,OBJPROP_XDISTANCE,130);
 ObjectSetInteger(0,lot1_btn,OBJPROP_YDISTANCE,130);
 ObjectSetInteger(0,lot1_btn,OBJPROP_XSIZE,35);
 ObjectSetInteger(0,lot1_btn,OBJPROP_YSIZE,25);
 ObjectSetInteger(0,lot1_btn,OBJPROP_CORNER,CORNER_RIGHT_UPPER);
 ObjectSetString (0,lot1_btn,OBJPROP_TEXT,DoubleToString(Lot1,2));
 ObjectSetString (0,lot1_btn,OBJPROP_FONT,"Calibri");
 ObjectSetInteger(0,lot1_btn,OBJPROP_FONTSIZE,10);
 ObjectSetInteger(0,lot1_btn,OBJPROP_COLOR,clrWhite);
 ObjectSetInteger(0,lot1_btn,OBJPROP_BGCOLOR,clrDodgerBlue);
 ObjectSetInteger(0,lot1_btn,OBJPROP_BORDER_COLOR,clrWhite);
 ObjectSetInteger(0,lot1_btn,OBJPROP_BACK,false);
 ObjectSetInteger(0,lot1_btn,OBJPROP_STATE,false);
 ObjectSetInteger(0,lot1_btn,OBJPROP_SELECTABLE,false);
 ObjectSetInteger(0,lot1_btn,OBJPROP_SELECTED,false);
 ObjectSetInteger(0,lot1_btn,OBJPROP_HIDDEN,true);
 ObjectSetInteger(0,lot1_btn,OBJPROP_ZORDER, 100);
 //--- 
 ObjectCreate    (0,lot2_btn,OBJ_BUTTON,0,0,0);
 ObjectSetInteger(0,lot2_btn,OBJPROP_XDISTANCE,90);
 ObjectSetInteger(0,lot2_btn,OBJPROP_YDISTANCE,130);
 ObjectSetInteger(0,lot2_btn,OBJPROP_XSIZE,35);
 ObjectSetInteger(0,lot2_btn,OBJPROP_YSIZE,25);
 ObjectSetInteger(0,lot2_btn,OBJPROP_CORNER,CORNER_RIGHT_UPPER);
 ObjectSetString (0,lot2_btn,OBJPROP_TEXT,DoubleToString(Lot2,2));
 ObjectSetString (0,lot2_btn,OBJPROP_FONT,"Calibri");
 ObjectSetInteger(0,lot2_btn,OBJPROP_FONTSIZE,10);
 ObjectSetInteger(0,lot2_btn,OBJPROP_COLOR,clrWhite);
 ObjectSetInteger(0,lot2_btn,OBJPROP_BGCOLOR,clrGray);
 ObjectSetInteger(0,lot2_btn,OBJPROP_BORDER_COLOR,clrWhite);
 ObjectSetInteger(0,lot2_btn,OBJPROP_BACK,false);
 ObjectSetInteger(0,lot2_btn,OBJPROP_STATE,false);
 ObjectSetInteger(0,lot2_btn,OBJPROP_SELECTABLE,false);
 ObjectSetInteger(0,lot2_btn,OBJPROP_SELECTED,false);
 ObjectSetInteger(0,lot2_btn,OBJPROP_HIDDEN,true);
 ObjectSetInteger(0,lot2_btn,OBJPROP_ZORDER, 100);
 //--- 
 ObjectCreate    (0,lot3_btn,OBJ_BUTTON,0,0,0);
 ObjectSetInteger(0,lot3_btn,OBJPROP_XDISTANCE,50);
 ObjectSetInteger(0,lot3_btn,OBJPROP_YDISTANCE,130);
 ObjectSetInteger(0,lot3_btn,OBJPROP_XSIZE,35);
 ObjectSetInteger(0,lot3_btn,OBJPROP_YSIZE,25);
 ObjectSetInteger(0,lot3_btn,OBJPROP_CORNER,CORNER_RIGHT_UPPER);
 ObjectSetString (0,lot3_btn,OBJPROP_TEXT,DoubleToString(Lot3,2));
 ObjectSetString (0,lot3_btn,OBJPROP_FONT,"Calibri");
 ObjectSetInteger(0,lot3_btn,OBJPROP_FONTSIZE,10);
 ObjectSetInteger(0,lot3_btn,OBJPROP_COLOR,clrWhite);
 ObjectSetInteger(0,lot3_btn,OBJPROP_BGCOLOR,clrGray);
 ObjectSetInteger(0,lot3_btn,OBJPROP_BORDER_COLOR,clrWhite);
 ObjectSetInteger(0,lot3_btn,OBJPROP_BACK,false);
 ObjectSetInteger(0,lot3_btn,OBJPROP_STATE,false);
 ObjectSetInteger(0,lot3_btn,OBJPROP_SELECTABLE,false);
 ObjectSetInteger(0,lot3_btn,OBJPROP_SELECTED,false);
 ObjectSetInteger(0,lot3_btn,OBJPROP_HIDDEN,true);
 ObjectSetInteger(0,lot3_btn,OBJPROP_ZORDER, 100);
 //--- 
 ObjectCreate    (0,lot4_btn,OBJ_BUTTON,0,0,0);
 ObjectSetInteger(0,lot4_btn,OBJPROP_XDISTANCE,130);
 ObjectSetInteger(0,lot4_btn,OBJPROP_YDISTANCE,160);
 ObjectSetInteger(0,lot4_btn,OBJPROP_XSIZE,35);
 ObjectSetInteger(0,lot4_btn,OBJPROP_YSIZE,25);
 ObjectSetInteger(0,lot4_btn,OBJPROP_CORNER,CORNER_RIGHT_UPPER);
 ObjectSetString (0,lot4_btn,OBJPROP_TEXT,DoubleToString(Lot4,2));
 ObjectSetString (0,lot4_btn,OBJPROP_FONT,"Calibri");
 ObjectSetInteger(0,lot4_btn,OBJPROP_FONTSIZE,10);
 ObjectSetInteger(0,lot4_btn,OBJPROP_COLOR,clrWhite);
 ObjectSetInteger(0,lot4_btn,OBJPROP_BGCOLOR,clrGray);
 ObjectSetInteger(0,lot4_btn,OBJPROP_BORDER_COLOR,clrWhite);
 ObjectSetInteger(0,lot4_btn,OBJPROP_BACK,false);
 ObjectSetInteger(0,lot4_btn,OBJPROP_STATE,false);
 ObjectSetInteger(0,lot4_btn,OBJPROP_SELECTABLE,false);
 ObjectSetInteger(0,lot4_btn,OBJPROP_SELECTED,false);
 ObjectSetInteger(0,lot4_btn,OBJPROP_HIDDEN,true);
 ObjectSetInteger(0,lot4_btn,OBJPROP_ZORDER, 100);
 //--- 
 ObjectCreate    (0,lot5_btn,OBJ_BUTTON,0,0,0);
 ObjectSetInteger(0,lot5_btn,OBJPROP_XDISTANCE,90);
 ObjectSetInteger(0,lot5_btn,OBJPROP_YDISTANCE,160);
 ObjectSetInteger(0,lot5_btn,OBJPROP_XSIZE,35);
 ObjectSetInteger(0,lot5_btn,OBJPROP_YSIZE,25);
 ObjectSetInteger(0,lot5_btn,OBJPROP_CORNER,CORNER_RIGHT_UPPER);
 ObjectSetString (0,lot5_btn,OBJPROP_TEXT,DoubleToString(Lot5,2));
 ObjectSetString (0,lot5_btn,OBJPROP_FONT,"Calibri");
 ObjectSetInteger(0,lot5_btn,OBJPROP_FONTSIZE,10);
 ObjectSetInteger(0,lot5_btn,OBJPROP_COLOR,clrWhite);
 ObjectSetInteger(0,lot5_btn,OBJPROP_BGCOLOR,clrGray);
 ObjectSetInteger(0,lot5_btn,OBJPROP_BORDER_COLOR,clrWhite);
 ObjectSetInteger(0,lot5_btn,OBJPROP_BACK,false);
 ObjectSetInteger(0,lot5_btn,OBJPROP_STATE,false);
 ObjectSetInteger(0,lot5_btn,OBJPROP_SELECTABLE,false);
 ObjectSetInteger(0,lot5_btn,OBJPROP_SELECTED,false);
 ObjectSetInteger(0,lot5_btn,OBJPROP_HIDDEN,true);
 ObjectSetInteger(0,lot5_btn,OBJPROP_ZORDER, 100);
 //--- 
 ObjectCreate    (0,lot6_btn,OBJ_BUTTON,0,0,0);
 ObjectSetInteger(0,lot6_btn,OBJPROP_XDISTANCE,50);
 ObjectSetInteger(0,lot6_btn,OBJPROP_YDISTANCE,160);
 ObjectSetInteger(0,lot6_btn,OBJPROP_XSIZE,35);
 ObjectSetInteger(0,lot6_btn,OBJPROP_YSIZE,25);
 ObjectSetInteger(0,lot6_btn,OBJPROP_CORNER,CORNER_RIGHT_UPPER);
 ObjectSetString (0,lot6_btn,OBJPROP_TEXT,DoubleToString(Lot6,2));
 ObjectSetString (0,lot6_btn,OBJPROP_FONT,"Calibri");
 ObjectSetInteger(0,lot6_btn,OBJPROP_FONTSIZE,10);
 ObjectSetInteger(0,lot6_btn,OBJPROP_COLOR,clrWhite);
 ObjectSetInteger(0,lot6_btn,OBJPROP_BGCOLOR,clrGray);
 ObjectSetInteger(0,lot6_btn,OBJPROP_BORDER_COLOR,clrWhite);
 ObjectSetInteger(0,lot6_btn,OBJPROP_BACK,false);
 ObjectSetInteger(0,lot6_btn,OBJPROP_STATE,false);
 ObjectSetInteger(0,lot6_btn,OBJPROP_SELECTABLE,false);
 ObjectSetInteger(0,lot6_btn,OBJPROP_SELECTED,false);
 ObjectSetInteger(0,lot6_btn,OBJPROP_HIDDEN,true);
 ObjectSetInteger(0,lot6_btn,OBJPROP_ZORDER, 100);
 //--- 
 ObjectCreate(0,ramka3,OBJ_RECTANGLE_LABEL,0,0,0);
 ObjectSetInteger(0,ramka3,OBJPROP_XDISTANCE,135); 
 ObjectSetInteger(0,ramka3,OBJPROP_YDISTANCE,192); 
 ObjectSetInteger(0,ramka3,OBJPROP_XSIZE,125); 
 ObjectSetInteger(0,ramka3,OBJPROP_YSIZE,80); 
 ObjectSetInteger(0,ramka3,OBJPROP_BGCOLOR,clrNONE); 
 ObjectSetInteger(0,ramka3,OBJPROP_BORDER_TYPE,BORDER_FLAT); 
 ObjectSetInteger(0,ramka3,OBJPROP_CORNER,CORNER_RIGHT_UPPER); 
 ObjectSetInteger(0,ramka3,OBJPROP_COLOR,clrGray); 
 ObjectSetInteger(0,ramka3,OBJPROP_STYLE,STYLE_SOLID); 
 ObjectSetInteger(0,ramka3,OBJPROP_WIDTH,3); 
 ObjectSetInteger(0,ramka3,OBJPROP_BACK,true); 
 ObjectSetInteger(0,ramka3,OBJPROP_SELECTABLE,false); 
 ObjectSetInteger(0,ramka3,OBJPROP_SELECTED,false); 
 ObjectSetInteger(0,ramka3,OBJPROP_HIDDEN,true); 
 ObjectSetInteger(0,ramka3,OBJPROP_ZORDER,0);
 //--- 
 ObjectCreate (series_label, OBJ_LABEL,0, 0, 0);
 ObjectSet    (series_label, OBJPROP_CORNER,CORNER_RIGHT_UPPER);
 ObjectSet    (series_label, OBJPROP_XDISTANCE, 54);
 ObjectSet    (series_label, OBJPROP_YDISTANCE, 196);
 ObjectSet    (series_label, OBJPROP_SELECTABLE,false);
 ObjectSet    (series_label, OBJPROP_SELECTED,false);
 ObjectSet    (series_label, OBJPROP_HIDDEN,true);
 ObjectSetText(series_label,"ВЫБОР КОЛЕНА: ",8,"Calibri",clrDodgerBlue);
 //--- 
 ObjectCreate    (0,srs0_btn,OBJ_BUTTON,0,0,0);
 ObjectSetInteger(0,srs0_btn,OBJPROP_XDISTANCE,130);
 ObjectSetInteger(0,srs0_btn,OBJPROP_YDISTANCE,210);
 ObjectSetInteger(0,srs0_btn,OBJPROP_XSIZE,35);
 ObjectSetInteger(0,srs0_btn,OBJPROP_YSIZE,25);
 ObjectSetInteger(0,srs0_btn,OBJPROP_CORNER,CORNER_RIGHT_UPPER);
 ObjectSetString (0,srs0_btn,OBJPROP_TEXT,"0");
 ObjectSetString (0,srs0_btn,OBJPROP_FONT,"Calibri");
 ObjectSetInteger(0,srs0_btn,OBJPROP_FONTSIZE,10);
 ObjectSetInteger(0,srs0_btn,OBJPROP_COLOR,clrWhite);
 ObjectSetInteger(0,srs0_btn,OBJPROP_BGCOLOR,clrOrange);
 ObjectSetInteger(0,srs0_btn,OBJPROP_BORDER_COLOR,clrWhite);
 ObjectSetInteger(0,srs0_btn,OBJPROP_BACK,false);
 ObjectSetInteger(0,srs0_btn,OBJPROP_STATE,false);
 ObjectSetInteger(0,srs0_btn,OBJPROP_SELECTABLE,false);
 ObjectSetInteger(0,srs0_btn,OBJPROP_SELECTED,false);
 ObjectSetInteger(0,srs0_btn,OBJPROP_HIDDEN,true);
 ObjectSetInteger(0,srs0_btn,OBJPROP_ZORDER, 100);
 //--- 
 ObjectCreate    (0,srs1_btn,OBJ_BUTTON,0,0,0);
 ObjectSetInteger(0,srs1_btn,OBJPROP_XDISTANCE,90);
 ObjectSetInteger(0,srs1_btn,OBJPROP_YDISTANCE,210);
 ObjectSetInteger(0,srs1_btn,OBJPROP_XSIZE,35);
 ObjectSetInteger(0,srs1_btn,OBJPROP_YSIZE,25);
 ObjectSetInteger(0,srs1_btn,OBJPROP_CORNER,CORNER_RIGHT_UPPER);
 ObjectSetString (0,srs1_btn,OBJPROP_TEXT,"1");
 ObjectSetString (0,srs1_btn,OBJPROP_FONT,"Calibri");
 ObjectSetInteger(0,srs1_btn,OBJPROP_FONTSIZE,10);
 ObjectSetInteger(0,srs1_btn,OBJPROP_COLOR,clrWhite);
 ObjectSetInteger(0,srs1_btn,OBJPROP_BGCOLOR,clrGray);
 ObjectSetInteger(0,srs1_btn,OBJPROP_BORDER_COLOR,clrWhite);
 ObjectSetInteger(0,srs1_btn,OBJPROP_BACK,false);
 ObjectSetInteger(0,srs1_btn,OBJPROP_STATE,false);
 ObjectSetInteger(0,srs1_btn,OBJPROP_SELECTABLE,false);
 ObjectSetInteger(0,srs1_btn,OBJPROP_SELECTED,false);
 ObjectSetInteger(0,srs1_btn,OBJPROP_HIDDEN,true);
 ObjectSetInteger(0,srs1_btn,OBJPROP_ZORDER, 100);
 //--- 
 ObjectCreate    (0,srs2_btn,OBJ_BUTTON,0,0,0);
 ObjectSetInteger(0,srs2_btn,OBJPROP_XDISTANCE,50);
 ObjectSetInteger(0,srs2_btn,OBJPROP_YDISTANCE,210);
 ObjectSetInteger(0,srs2_btn,OBJPROP_XSIZE,35);
 ObjectSetInteger(0,srs2_btn,OBJPROP_YSIZE,25);
 ObjectSetInteger(0,srs2_btn,OBJPROP_CORNER,CORNER_RIGHT_UPPER);
 ObjectSetString (0,srs2_btn,OBJPROP_TEXT,"2");
 ObjectSetString (0,srs2_btn,OBJPROP_FONT,"Calibri");
 ObjectSetInteger(0,srs2_btn,OBJPROP_FONTSIZE,10);
 ObjectSetInteger(0,srs2_btn,OBJPROP_COLOR,clrWhite);
 ObjectSetInteger(0,srs2_btn,OBJPROP_BGCOLOR,clrGray);
 ObjectSetInteger(0,srs2_btn,OBJPROP_BORDER_COLOR,clrWhite);
 ObjectSetInteger(0,srs2_btn,OBJPROP_BACK,false);
 ObjectSetInteger(0,srs2_btn,OBJPROP_STATE,false);
 ObjectSetInteger(0,srs2_btn,OBJPROP_SELECTABLE,false);
 ObjectSetInteger(0,srs2_btn,OBJPROP_SELECTED,false);
 ObjectSetInteger(0,srs2_btn,OBJPROP_HIDDEN,true);
 ObjectSetInteger(0,srs2_btn,OBJPROP_ZORDER, 100);
 //--- 
 ObjectCreate    (0,srs3_btn,OBJ_BUTTON,0,0,0);
 ObjectSetInteger(0,srs3_btn,OBJPROP_XDISTANCE,130);
 ObjectSetInteger(0,srs3_btn,OBJPROP_YDISTANCE,240);
 ObjectSetInteger(0,srs3_btn,OBJPROP_XSIZE,35);
 ObjectSetInteger(0,srs3_btn,OBJPROP_YSIZE,25);
 ObjectSetInteger(0,srs3_btn,OBJPROP_CORNER,CORNER_RIGHT_UPPER);
 ObjectSetString (0,srs3_btn,OBJPROP_TEXT,"3");
 ObjectSetString (0,srs3_btn,OBJPROP_FONT,"Calibri");
 ObjectSetInteger(0,srs3_btn,OBJPROP_FONTSIZE,10);
 ObjectSetInteger(0,srs3_btn,OBJPROP_COLOR,clrWhite);
 ObjectSetInteger(0,srs3_btn,OBJPROP_BGCOLOR,clrGray);
 ObjectSetInteger(0,srs3_btn,OBJPROP_BORDER_COLOR,clrWhite);
 ObjectSetInteger(0,srs3_btn,OBJPROP_BACK,false);
 ObjectSetInteger(0,srs3_btn,OBJPROP_STATE,false);
 ObjectSetInteger(0,srs3_btn,OBJPROP_SELECTABLE,false);
 ObjectSetInteger(0,srs3_btn,OBJPROP_SELECTED,false);
 ObjectSetInteger(0,srs3_btn,OBJPROP_HIDDEN,true);
 ObjectSetInteger(0,srs3_btn,OBJPROP_ZORDER, 100);
 //--- 
 ObjectCreate    (0,srs4_btn,OBJ_BUTTON,0,0,0);
 ObjectSetInteger(0,srs4_btn,OBJPROP_XDISTANCE,90);
 ObjectSetInteger(0,srs4_btn,OBJPROP_YDISTANCE,240);
 ObjectSetInteger(0,srs4_btn,OBJPROP_XSIZE,35);
 ObjectSetInteger(0,srs4_btn,OBJPROP_YSIZE,25);
 ObjectSetInteger(0,srs4_btn,OBJPROP_CORNER,CORNER_RIGHT_UPPER);
 ObjectSetString (0,srs4_btn,OBJPROP_TEXT,"4");
 ObjectSetString (0,srs4_btn,OBJPROP_FONT,"Calibri");
 ObjectSetInteger(0,srs4_btn,OBJPROP_FONTSIZE,10);
 ObjectSetInteger(0,srs4_btn,OBJPROP_COLOR,clrWhite);
 ObjectSetInteger(0,srs4_btn,OBJPROP_BGCOLOR,clrGray);
 ObjectSetInteger(0,srs4_btn,OBJPROP_BORDER_COLOR,clrWhite);
 ObjectSetInteger(0,srs4_btn,OBJPROP_BACK,false);
 ObjectSetInteger(0,srs4_btn,OBJPROP_STATE,false);
 ObjectSetInteger(0,srs4_btn,OBJPROP_SELECTABLE,false);
 ObjectSetInteger(0,srs4_btn,OBJPROP_SELECTED,false);
 ObjectSetInteger(0,srs4_btn,OBJPROP_HIDDEN,true);
 ObjectSetInteger(0,srs4_btn,OBJPROP_ZORDER, 100);
 //--- 
 ObjectCreate    (0,srs5_btn,OBJ_BUTTON,0,0,0);
 ObjectSetInteger(0,srs5_btn,OBJPROP_XDISTANCE,50);
 ObjectSetInteger(0,srs5_btn,OBJPROP_YDISTANCE,240);
 ObjectSetInteger(0,srs5_btn,OBJPROP_XSIZE,35);
 ObjectSetInteger(0,srs5_btn,OBJPROP_YSIZE,25);
 ObjectSetInteger(0,srs5_btn,OBJPROP_CORNER,CORNER_RIGHT_UPPER);
 ObjectSetString (0,srs5_btn,OBJPROP_TEXT,"5");
 ObjectSetString (0,srs5_btn,OBJPROP_FONT,"Calibri");
 ObjectSetInteger(0,srs5_btn,OBJPROP_FONTSIZE,10);
 ObjectSetInteger(0,srs5_btn,OBJPROP_COLOR,clrWhite);
 ObjectSetInteger(0,srs5_btn,OBJPROP_BGCOLOR,clrGray);
 ObjectSetInteger(0,srs5_btn,OBJPROP_BORDER_COLOR,clrWhite);
 ObjectSetInteger(0,srs5_btn,OBJPROP_BACK,false);
 ObjectSetInteger(0,srs5_btn,OBJPROP_STATE,false);
 ObjectSetInteger(0,srs5_btn,OBJPROP_SELECTABLE,false);
 ObjectSetInteger(0,srs5_btn,OBJPROP_SELECTED,false);
 ObjectSetInteger(0,srs5_btn,OBJPROP_HIDDEN,true);
 ObjectSetInteger(0,srs5_btn,OBJPROP_ZORDER, 100);
   
 //--- 
 ObjectCreate    (0,bar1_btn,OBJ_BUTTON,0,0,0);
 ObjectSetInteger(0,bar1_btn,OBJPROP_XDISTANCE,130);
 ObjectSetInteger(0,bar1_btn,OBJPROP_YDISTANCE,292);
 ObjectSetInteger(0,bar1_btn,OBJPROP_XSIZE,35);
 ObjectSetInteger(0,bar1_btn,OBJPROP_YSIZE,25);
 ObjectSetInteger(0,bar1_btn,OBJPROP_CORNER,CORNER_RIGHT_UPPER);
 ObjectSetString (0,bar1_btn,OBJPROP_TEXT,string(bar1));
 ObjectSetString (0,bar1_btn,OBJPROP_FONT,"Calibri");
 ObjectSetInteger(0,bar1_btn,OBJPROP_FONTSIZE,10);
 ObjectSetInteger(0,bar1_btn,OBJPROP_COLOR,clrWhite);
 ObjectSetInteger(0,bar1_btn,OBJPROP_BGCOLOR,clrOrange);
 ObjectSetInteger(0,bar1_btn,OBJPROP_BORDER_COLOR,clrWhite);
 ObjectSetInteger(0,bar1_btn,OBJPROP_BACK,false);
 ObjectSetInteger(0,bar1_btn,OBJPROP_STATE,false);
 ObjectSetInteger(0,bar1_btn,OBJPROP_SELECTABLE,false);
 ObjectSetInteger(0,bar1_btn,OBJPROP_SELECTED,false);
 ObjectSetInteger(0,bar1_btn,OBJPROP_HIDDEN,true);
 ObjectSetInteger(0,bar1_btn,OBJPROP_ZORDER, 100);
 //--- 
 ObjectCreate    (0,bar2_btn,OBJ_BUTTON,0,0,0);
 ObjectSetInteger(0,bar2_btn,OBJPROP_XDISTANCE,90);
 ObjectSetInteger(0,bar2_btn,OBJPROP_YDISTANCE,292);
 ObjectSetInteger(0,bar2_btn,OBJPROP_XSIZE,35);
 ObjectSetInteger(0,bar2_btn,OBJPROP_YSIZE,25);
 ObjectSetInteger(0,bar2_btn,OBJPROP_CORNER,CORNER_RIGHT_UPPER);
 ObjectSetString (0,bar2_btn,OBJPROP_TEXT,string(bar2));
 ObjectSetString (0,bar2_btn,OBJPROP_FONT,"Calibri");
 ObjectSetInteger(0,bar2_btn,OBJPROP_FONTSIZE,10);
 ObjectSetInteger(0,bar2_btn,OBJPROP_COLOR,clrWhite);
 ObjectSetInteger(0,bar2_btn,OBJPROP_BGCOLOR,clrGray);
 ObjectSetInteger(0,bar2_btn,OBJPROP_BORDER_COLOR,clrWhite);
 ObjectSetInteger(0,bar2_btn,OBJPROP_BACK,false);
 ObjectSetInteger(0,bar2_btn,OBJPROP_STATE,false);
 ObjectSetInteger(0,bar2_btn,OBJPROP_SELECTABLE,false);
 ObjectSetInteger(0,bar2_btn,OBJPROP_SELECTED,false);
 ObjectSetInteger(0,bar2_btn,OBJPROP_HIDDEN,true);
 ObjectSetInteger(0,bar2_btn,OBJPROP_ZORDER, 100);
 //--- 
 ObjectCreate    (0,bar3_btn,OBJ_BUTTON,0,0,0);
 ObjectSetInteger(0,bar3_btn,OBJPROP_XDISTANCE,50);
 ObjectSetInteger(0,bar3_btn,OBJPROP_YDISTANCE,292);
 ObjectSetInteger(0,bar3_btn,OBJPROP_XSIZE,35);
 ObjectSetInteger(0,bar3_btn,OBJPROP_YSIZE,25);
 ObjectSetInteger(0,bar3_btn,OBJPROP_CORNER,CORNER_RIGHT_UPPER);
 ObjectSetString (0,bar3_btn,OBJPROP_TEXT,string(bar3));
 ObjectSetString (0,bar3_btn,OBJPROP_FONT,"Calibri");
 ObjectSetInteger(0,bar3_btn,OBJPROP_FONTSIZE,10);
 ObjectSetInteger(0,bar3_btn,OBJPROP_COLOR,clrWhite);
 ObjectSetInteger(0,bar3_btn,OBJPROP_BGCOLOR,clrGray);
 ObjectSetInteger(0,bar3_btn,OBJPROP_BORDER_COLOR,clrWhite);
 ObjectSetInteger(0,bar3_btn,OBJPROP_BACK,false);
 ObjectSetInteger(0,bar3_btn,OBJPROP_STATE,false);
 ObjectSetInteger(0,bar3_btn,OBJPROP_SELECTABLE,false);
 ObjectSetInteger(0,bar3_btn,OBJPROP_SELECTED,false);
 ObjectSetInteger(0,bar3_btn,OBJPROP_HIDDEN,true);
 ObjectSetInteger(0,bar3_btn,OBJPROP_ZORDER, 100);
 //--- 
 ObjectCreate    (0,bar4_btn,OBJ_BUTTON,0,0,0);
 ObjectSetInteger(0,bar4_btn,OBJPROP_XDISTANCE,130);
 ObjectSetInteger(0,bar4_btn,OBJPROP_YDISTANCE,322);
 ObjectSetInteger(0,bar4_btn,OBJPROP_XSIZE,35);
 ObjectSetInteger(0,bar4_btn,OBJPROP_YSIZE,25);
 ObjectSetInteger(0,bar4_btn,OBJPROP_CORNER,CORNER_RIGHT_UPPER);
 ObjectSetString (0,bar4_btn,OBJPROP_TEXT,string(bar4));
 ObjectSetString (0,bar4_btn,OBJPROP_FONT,"Calibri");
 ObjectSetInteger(0,bar4_btn,OBJPROP_FONTSIZE,10);
 ObjectSetInteger(0,bar4_btn,OBJPROP_COLOR,clrWhite);
 ObjectSetInteger(0,bar4_btn,OBJPROP_BGCOLOR,clrGray);
 ObjectSetInteger(0,bar4_btn,OBJPROP_BORDER_COLOR,clrWhite);
 ObjectSetInteger(0,bar4_btn,OBJPROP_BACK,false);
 ObjectSetInteger(0,bar4_btn,OBJPROP_STATE,false);
 ObjectSetInteger(0,bar4_btn,OBJPROP_SELECTABLE,false);
 ObjectSetInteger(0,bar4_btn,OBJPROP_SELECTED,false);
 ObjectSetInteger(0,bar4_btn,OBJPROP_HIDDEN,true);
 ObjectSetInteger(0,bar4_btn,OBJPROP_ZORDER, 100);
 //--- 
 ObjectCreate    (0,bar5_btn,OBJ_BUTTON,0,0,0);
 ObjectSetInteger(0,bar5_btn,OBJPROP_XDISTANCE,90);
 ObjectSetInteger(0,bar5_btn,OBJPROP_YDISTANCE,322);
 ObjectSetInteger(0,bar5_btn,OBJPROP_XSIZE,35);
 ObjectSetInteger(0,bar5_btn,OBJPROP_YSIZE,25);
 ObjectSetInteger(0,bar5_btn,OBJPROP_CORNER,CORNER_RIGHT_UPPER);
 ObjectSetString (0,bar5_btn,OBJPROP_TEXT,string(bar5));
 ObjectSetString (0,bar5_btn,OBJPROP_FONT,"Calibri");
 ObjectSetInteger(0,bar5_btn,OBJPROP_FONTSIZE,10);
 ObjectSetInteger(0,bar5_btn,OBJPROP_COLOR,clrWhite);
 ObjectSetInteger(0,bar5_btn,OBJPROP_BGCOLOR,clrGray);
 ObjectSetInteger(0,bar5_btn,OBJPROP_BORDER_COLOR,clrWhite);
 ObjectSetInteger(0,bar5_btn,OBJPROP_BACK,false);
 ObjectSetInteger(0,bar5_btn,OBJPROP_STATE,false);
 ObjectSetInteger(0,bar5_btn,OBJPROP_SELECTABLE,false);
 ObjectSetInteger(0,bar5_btn,OBJPROP_SELECTED,false);
 ObjectSetInteger(0,bar5_btn,OBJPROP_HIDDEN,true);
 ObjectSetInteger(0,bar5_btn,OBJPROP_ZORDER, 100);
 //--- 
 ObjectCreate    (0,bar6_btn,OBJ_BUTTON,0,0,0);
 ObjectSetInteger(0,bar6_btn,OBJPROP_XDISTANCE,50);
 ObjectSetInteger(0,bar6_btn,OBJPROP_YDISTANCE,322);
 ObjectSetInteger(0,bar6_btn,OBJPROP_XSIZE,35);
 ObjectSetInteger(0,bar6_btn,OBJPROP_YSIZE,25);
 ObjectSetInteger(0,bar6_btn,OBJPROP_CORNER,CORNER_RIGHT_UPPER);
 ObjectSetString (0,bar6_btn,OBJPROP_TEXT,string(bar6));
 ObjectSetString (0,bar6_btn,OBJPROP_FONT,"Calibri");
 ObjectSetInteger(0,bar6_btn,OBJPROP_FONTSIZE,10);
 ObjectSetInteger(0,bar6_btn,OBJPROP_COLOR,clrWhite);
 ObjectSetInteger(0,bar6_btn,OBJPROP_BGCOLOR,clrGray);
 ObjectSetInteger(0,bar6_btn,OBJPROP_BORDER_COLOR,clrWhite);
 ObjectSetInteger(0,bar6_btn,OBJPROP_BACK,false);
 ObjectSetInteger(0,bar6_btn,OBJPROP_STATE,false);
 ObjectSetInteger(0,bar6_btn,OBJPROP_SELECTABLE,false);
 ObjectSetInteger(0,bar6_btn,OBJPROP_SELECTED,false);
 ObjectSetInteger(0,bar6_btn,OBJPROP_HIDDEN,true);
 ObjectSetInteger(0,bar6_btn,OBJPROP_ZORDER, 100);
 //--- 
 ObjectCreate(0,ramka5,OBJ_RECTANGLE_LABEL,0,0,0);
 ObjectSetInteger(0,ramka5,OBJPROP_XDISTANCE,135); 
 ObjectSetInteger(0,ramka5,OBJPROP_YDISTANCE,273); 
 ObjectSetInteger(0,ramka5,OBJPROP_XSIZE,125); 
 ObjectSetInteger(0,ramka5,OBJPROP_YSIZE,80); 
 ObjectSetInteger(0,ramka5,OBJPROP_BGCOLOR,clrNONE); 
 ObjectSetInteger(0,ramka5,OBJPROP_BORDER_TYPE,BORDER_FLAT); 
 ObjectSetInteger(0,ramka5,OBJPROP_CORNER,CORNER_RIGHT_UPPER); 
 ObjectSetInteger(0,ramka5,OBJPROP_COLOR,clrGray); 
 ObjectSetInteger(0,ramka5,OBJPROP_STYLE,STYLE_SOLID); 
 ObjectSetInteger(0,ramka5,OBJPROP_WIDTH,3); 
 ObjectSetInteger(0,ramka5,OBJPROP_BACK,true); 
 ObjectSetInteger(0,ramka5,OBJPROP_SELECTABLE,false); 
 ObjectSetInteger(0,ramka5,OBJPROP_SELECTED,false); 
 ObjectSetInteger(0,ramka5,OBJPROP_HIDDEN,true); 
 ObjectSetInteger(0,ramka5,OBJPROP_ZORDER,0);
 //--- 
 ObjectCreate (bar_label, OBJ_LABEL,0, 0, 0);
 ObjectSet    (bar_label, OBJPROP_CORNER,CORNER_RIGHT_UPPER);
 ObjectSet    (bar_label, OBJPROP_XDISTANCE, 28);
 ObjectSet    (bar_label, OBJPROP_YDISTANCE, 277);
 ObjectSet    (bar_label, OBJPROP_SELECTABLE,false);
 ObjectSet    (bar_label, OBJPROP_SELECTED,false);
 ObjectSet    (bar_label, OBJPROP_HIDDEN,true);
 ObjectSetText(bar_label,"ПОПРАВКА ПО БАРАМ",8,"Calibri",clrOrange);
 //--- 
 ObjectCreate(0,ramka6,OBJ_RECTANGLE_LABEL,0,0,0);
 ObjectSetInteger(0,ramka6,OBJPROP_XDISTANCE,135); 
 ObjectSetInteger(0,ramka6,OBJPROP_YDISTANCE,354); 
 ObjectSetInteger(0,ramka6,OBJPROP_XSIZE,125); 
 ObjectSetInteger(0,ramka6,OBJPROP_YSIZE,110); 
 ObjectSetInteger(0,ramka6,OBJPROP_BGCOLOR,clrNONE); 
 ObjectSetInteger(0,ramka6,OBJPROP_BORDER_TYPE,BORDER_FLAT); 
 ObjectSetInteger(0,ramka6,OBJPROP_CORNER,CORNER_RIGHT_UPPER); 
 ObjectSetInteger(0,ramka6,OBJPROP_COLOR,clrGray); 
 ObjectSetInteger(0,ramka6,OBJPROP_STYLE,STYLE_SOLID); 
 ObjectSetInteger(0,ramka6,OBJPROP_WIDTH,3); 
 ObjectSetInteger(0,ramka6,OBJPROP_BACK,true); 
 ObjectSetInteger(0,ramka6,OBJPROP_SELECTABLE,false); 
 ObjectSetInteger(0,ramka6,OBJPROP_SELECTED,false); 
 ObjectSetInteger(0,ramka6,OBJPROP_HIDDEN,true); 
 ObjectSetInteger(0,ramka6,OBJPROP_ZORDER,0);
 //--- 
 ObjectCreate (min_label, OBJ_LABEL,0, 0, 0);
 ObjectSet    (min_label, OBJPROP_CORNER,CORNER_RIGHT_UPPER);
 ObjectSet    (min_label, OBJPROP_XDISTANCE, 14);
 ObjectSet    (min_label, OBJPROP_YDISTANCE, 358);
 ObjectSet    (min_label, OBJPROP_SELECTABLE,false);
 ObjectSet    (min_label, OBJPROP_SELECTED,false);
 ObjectSet    (min_label, OBJPROP_HIDDEN,true);
 ObjectSetText(min_label,"ПОПРАВКА ПО МИНУТАМ",8,"Calibri",clrOrange);
 //--- 
 ObjectCreate    (0,min1_btn,OBJ_BUTTON,0,0,0);
 ObjectSetInteger(0,min1_btn,OBJPROP_XDISTANCE,130);
 ObjectSetInteger(0,min1_btn,OBJPROP_YDISTANCE,372);
 ObjectSetInteger(0,min1_btn,OBJPROP_XSIZE,35);
 ObjectSetInteger(0,min1_btn,OBJPROP_YSIZE,25);
 ObjectSetInteger(0,min1_btn,OBJPROP_CORNER,CORNER_RIGHT_UPPER);
 ObjectSetString (0,min1_btn,OBJPROP_TEXT,string(min1));
 ObjectSetString (0,min1_btn,OBJPROP_FONT,"Calibri");
 ObjectSetInteger(0,min1_btn,OBJPROP_FONTSIZE,10);
 ObjectSetInteger(0,min1_btn,OBJPROP_COLOR,clrWhite);
 ObjectSetInteger(0,min1_btn,OBJPROP_BGCOLOR,clrOrange);
 ObjectSetInteger(0,min1_btn,OBJPROP_BORDER_COLOR,clrWhite);
 ObjectSetInteger(0,min1_btn,OBJPROP_BACK,false);
 ObjectSetInteger(0,min1_btn,OBJPROP_STATE,false);
 ObjectSetInteger(0,min1_btn,OBJPROP_SELECTABLE,false);
 ObjectSetInteger(0,min1_btn,OBJPROP_SELECTED,false);
 ObjectSetInteger(0,min1_btn,OBJPROP_HIDDEN,true);
 ObjectSetInteger(0,min1_btn,OBJPROP_ZORDER, 100);
 //--- 
 ObjectCreate    (0,min2_btn,OBJ_BUTTON,0,0,0);
 ObjectSetInteger(0,min2_btn,OBJPROP_XDISTANCE,90);
 ObjectSetInteger(0,min2_btn,OBJPROP_YDISTANCE,372);
 ObjectSetInteger(0,min2_btn,OBJPROP_XSIZE,35);
 ObjectSetInteger(0,min2_btn,OBJPROP_YSIZE,25);
 ObjectSetInteger(0,min2_btn,OBJPROP_CORNER,CORNER_RIGHT_UPPER);
 ObjectSetString (0,min2_btn,OBJPROP_TEXT,string(min2));
 ObjectSetString (0,min2_btn,OBJPROP_FONT,"Calibri");
 ObjectSetInteger(0,min2_btn,OBJPROP_FONTSIZE,10);
 ObjectSetInteger(0,min2_btn,OBJPROP_COLOR,clrWhite);
 ObjectSetInteger(0,min2_btn,OBJPROP_BGCOLOR,clrGray);
 ObjectSetInteger(0,min2_btn,OBJPROP_BORDER_COLOR,clrWhite);
 ObjectSetInteger(0,min2_btn,OBJPROP_BACK,false);
 ObjectSetInteger(0,min2_btn,OBJPROP_STATE,false);
 ObjectSetInteger(0,min2_btn,OBJPROP_SELECTABLE,false);
 ObjectSetInteger(0,min2_btn,OBJPROP_SELECTED,false);
 ObjectSetInteger(0,min2_btn,OBJPROP_HIDDEN,true);
 ObjectSetInteger(0,min2_btn,OBJPROP_ZORDER, 100);
 //--- 
 ObjectCreate    (0,min3_btn,OBJ_BUTTON,0,0,0);
 ObjectSetInteger(0,min3_btn,OBJPROP_XDISTANCE,50);
 ObjectSetInteger(0,min3_btn,OBJPROP_YDISTANCE,372);
 ObjectSetInteger(0,min3_btn,OBJPROP_XSIZE,35);
 ObjectSetInteger(0,min3_btn,OBJPROP_YSIZE,25);
 ObjectSetInteger(0,min3_btn,OBJPROP_CORNER,CORNER_RIGHT_UPPER);
 ObjectSetString (0,min3_btn,OBJPROP_TEXT,string(min3));
 ObjectSetString (0,min3_btn,OBJPROP_FONT,"Calibri");
 ObjectSetInteger(0,min3_btn,OBJPROP_FONTSIZE,10);
 ObjectSetInteger(0,min3_btn,OBJPROP_COLOR,clrWhite);
 ObjectSetInteger(0,min3_btn,OBJPROP_BGCOLOR,clrGray);
 ObjectSetInteger(0,min3_btn,OBJPROP_BORDER_COLOR,clrWhite);
 ObjectSetInteger(0,min3_btn,OBJPROP_BACK,false);
 ObjectSetInteger(0,min3_btn,OBJPROP_STATE,false);
 ObjectSetInteger(0,min3_btn,OBJPROP_SELECTABLE,false);
 ObjectSetInteger(0,min3_btn,OBJPROP_SELECTED,false);
 ObjectSetInteger(0,min3_btn,OBJPROP_HIDDEN,true);
 ObjectSetInteger(0,min3_btn,OBJPROP_ZORDER, 100);
 //--- 
 ObjectCreate    (0,min4_btn,OBJ_BUTTON,0,0,0);
 ObjectSetInteger(0,min4_btn,OBJPROP_XDISTANCE,130);
 ObjectSetInteger(0,min4_btn,OBJPROP_YDISTANCE,402);
 ObjectSetInteger(0,min4_btn,OBJPROP_XSIZE,35);
 ObjectSetInteger(0,min4_btn,OBJPROP_YSIZE,25);
 ObjectSetInteger(0,min4_btn,OBJPROP_CORNER,CORNER_RIGHT_UPPER);
 ObjectSetString (0,min4_btn,OBJPROP_TEXT,string(min4));
 ObjectSetString (0,min4_btn,OBJPROP_FONT,"Calibri");
 ObjectSetInteger(0,min4_btn,OBJPROP_FONTSIZE,10);
 ObjectSetInteger(0,min4_btn,OBJPROP_COLOR,clrWhite);
 ObjectSetInteger(0,min4_btn,OBJPROP_BGCOLOR,clrGray);
 ObjectSetInteger(0,min4_btn,OBJPROP_BORDER_COLOR,clrWhite);
 ObjectSetInteger(0,min4_btn,OBJPROP_BACK,false);
 ObjectSetInteger(0,min4_btn,OBJPROP_STATE,false);
 ObjectSetInteger(0,min4_btn,OBJPROP_SELECTABLE,false);
 ObjectSetInteger(0,min4_btn,OBJPROP_SELECTED,false);
 ObjectSetInteger(0,min4_btn,OBJPROP_HIDDEN,true);
 ObjectSetInteger(0,min4_btn,OBJPROP_ZORDER, 100);
 //--- 
 ObjectCreate    (0,min5_btn,OBJ_BUTTON,0,0,0);
 ObjectSetInteger(0,min5_btn,OBJPROP_XDISTANCE,90);
 ObjectSetInteger(0,min5_btn,OBJPROP_YDISTANCE,402);
 ObjectSetInteger(0,min5_btn,OBJPROP_XSIZE,35);
 ObjectSetInteger(0,min5_btn,OBJPROP_YSIZE,25);
 ObjectSetInteger(0,min5_btn,OBJPROP_CORNER,CORNER_RIGHT_UPPER);
 ObjectSetString (0,min5_btn,OBJPROP_TEXT,string(min5));
 ObjectSetString (0,min5_btn,OBJPROP_FONT,"Calibri");
 ObjectSetInteger(0,min5_btn,OBJPROP_FONTSIZE,10);
 ObjectSetInteger(0,min5_btn,OBJPROP_COLOR,clrWhite);
 ObjectSetInteger(0,min5_btn,OBJPROP_BGCOLOR,clrGray);
 ObjectSetInteger(0,min5_btn,OBJPROP_BORDER_COLOR,clrWhite);
 ObjectSetInteger(0,min5_btn,OBJPROP_BACK,false);
 ObjectSetInteger(0,min5_btn,OBJPROP_STATE,false);
 ObjectSetInteger(0,min5_btn,OBJPROP_SELECTABLE,false);
 ObjectSetInteger(0,min5_btn,OBJPROP_SELECTED,false);
 ObjectSetInteger(0,min5_btn,OBJPROP_HIDDEN,true);
 ObjectSetInteger(0,min5_btn,OBJPROP_ZORDER, 100);
 //--- 
 ObjectCreate    (0,min6_btn,OBJ_BUTTON,0,0,0);
 ObjectSetInteger(0,min6_btn,OBJPROP_XDISTANCE,50);
 ObjectSetInteger(0,min6_btn,OBJPROP_YDISTANCE,402);
 ObjectSetInteger(0,min6_btn,OBJPROP_XSIZE,35);
 ObjectSetInteger(0,min6_btn,OBJPROP_YSIZE,25);
 ObjectSetInteger(0,min6_btn,OBJPROP_CORNER,CORNER_RIGHT_UPPER);
 ObjectSetString (0,min6_btn,OBJPROP_TEXT,string(min6));
 ObjectSetString (0,min6_btn,OBJPROP_FONT,"Calibri");
 ObjectSetInteger(0,min6_btn,OBJPROP_FONTSIZE,10);
 ObjectSetInteger(0,min6_btn,OBJPROP_COLOR,clrWhite);
 ObjectSetInteger(0,min6_btn,OBJPROP_BGCOLOR,clrGray);
 ObjectSetInteger(0,min6_btn,OBJPROP_BORDER_COLOR,clrWhite);
 ObjectSetInteger(0,min6_btn,OBJPROP_BACK,false);
 ObjectSetInteger(0,min6_btn,OBJPROP_STATE,false);
 ObjectSetInteger(0,min6_btn,OBJPROP_SELECTABLE,false);
 ObjectSetInteger(0,min6_btn,OBJPROP_SELECTED,false);
 ObjectSetInteger(0,min6_btn,OBJPROP_HIDDEN,true);
 ObjectSetInteger(0,min6_btn,OBJPROP_ZORDER, 100);
 //--- 
 ObjectCreate    (0,min7_btn,OBJ_BUTTON,0,0,0);
 ObjectSetInteger(0,min7_btn,OBJPROP_XDISTANCE,130);
 ObjectSetInteger(0,min7_btn,OBJPROP_YDISTANCE,432);
 ObjectSetInteger(0,min7_btn,OBJPROP_XSIZE,35);
 ObjectSetInteger(0,min7_btn,OBJPROP_YSIZE,25);
 ObjectSetInteger(0,min7_btn,OBJPROP_CORNER,CORNER_RIGHT_UPPER);
 ObjectSetString (0,min7_btn,OBJPROP_TEXT,string(min7));
 ObjectSetString (0,min7_btn,OBJPROP_FONT,"Calibri");
 ObjectSetInteger(0,min7_btn,OBJPROP_FONTSIZE,10);
 ObjectSetInteger(0,min7_btn,OBJPROP_COLOR,clrWhite);
 ObjectSetInteger(0,min7_btn,OBJPROP_BGCOLOR,clrGray);
 ObjectSetInteger(0,min7_btn,OBJPROP_BORDER_COLOR,clrWhite);
 ObjectSetInteger(0,min7_btn,OBJPROP_BACK,false);
 ObjectSetInteger(0,min7_btn,OBJPROP_STATE,false);
 ObjectSetInteger(0,min7_btn,OBJPROP_SELECTABLE,false);
 ObjectSetInteger(0,min7_btn,OBJPROP_SELECTED,false);
 ObjectSetInteger(0,min7_btn,OBJPROP_HIDDEN,true);
 ObjectSetInteger(0,min7_btn,OBJPROP_ZORDER, 100);
 //--- 
 ObjectCreate    (0,min8_btn,OBJ_BUTTON,0,0,0);
 ObjectSetInteger(0,min8_btn,OBJPROP_XDISTANCE,90);
 ObjectSetInteger(0,min8_btn,OBJPROP_YDISTANCE,432);
 ObjectSetInteger(0,min8_btn,OBJPROP_XSIZE,35);
 ObjectSetInteger(0,min8_btn,OBJPROP_YSIZE,25);
 ObjectSetInteger(0,min8_btn,OBJPROP_CORNER,CORNER_RIGHT_UPPER);
 ObjectSetString (0,min8_btn,OBJPROP_TEXT,string(min8));
 ObjectSetString (0,min8_btn,OBJPROP_FONT,"Calibri");
 ObjectSetInteger(0,min8_btn,OBJPROP_FONTSIZE,10);
 ObjectSetInteger(0,min8_btn,OBJPROP_COLOR,clrWhite);
 ObjectSetInteger(0,min8_btn,OBJPROP_BGCOLOR,clrGray);
 ObjectSetInteger(0,min8_btn,OBJPROP_BORDER_COLOR,clrWhite);
 ObjectSetInteger(0,min8_btn,OBJPROP_BACK,false);
 ObjectSetInteger(0,min8_btn,OBJPROP_STATE,false);
 ObjectSetInteger(0,min8_btn,OBJPROP_SELECTABLE,false);
 ObjectSetInteger(0,min8_btn,OBJPROP_SELECTED,false);
 ObjectSetInteger(0,min8_btn,OBJPROP_HIDDEN,true);
 ObjectSetInteger(0,min8_btn,OBJPROP_ZORDER, 100);
 //--- 
 ObjectCreate    (0,min9_btn,OBJ_BUTTON,0,0,0);
 ObjectSetInteger(0,min9_btn,OBJPROP_XDISTANCE,50);
 ObjectSetInteger(0,min9_btn,OBJPROP_YDISTANCE,432);
 ObjectSetInteger(0,min9_btn,OBJPROP_XSIZE,35);
 ObjectSetInteger(0,min9_btn,OBJPROP_YSIZE,25);
 ObjectSetInteger(0,min9_btn,OBJPROP_CORNER,CORNER_RIGHT_UPPER);
 ObjectSetString (0,min9_btn,OBJPROP_TEXT,string(min9));
 ObjectSetString (0,min9_btn,OBJPROP_FONT,"Calibri");
 ObjectSetInteger(0,min9_btn,OBJPROP_FONTSIZE,10);
 ObjectSetInteger(0,min9_btn,OBJPROP_COLOR,clrWhite);
 ObjectSetInteger(0,min9_btn,OBJPROP_BGCOLOR,clrGray);
 ObjectSetInteger(0,min9_btn,OBJPROP_BORDER_COLOR,clrWhite);
 ObjectSetInteger(0,min9_btn,OBJPROP_BACK,false);
 ObjectSetInteger(0,min9_btn,OBJPROP_STATE,false);
 ObjectSetInteger(0,min9_btn,OBJPROP_SELECTABLE,false);
 ObjectSetInteger(0,min9_btn,OBJPROP_SELECTED,false);
 ObjectSetInteger(0,min9_btn,OBJPROP_HIDDEN,true);
 ObjectSetInteger(0,min9_btn,OBJPROP_ZORDER, 100);
 //--- 
 ObjectCreate(0,ramka4,OBJ_RECTANGLE_LABEL,0,0,0);
 ObjectSetInteger(0,ramka4,OBJPROP_XDISTANCE,135); 
 ObjectSetInteger(0,ramka4,OBJPROP_YDISTANCE,465); 
 ObjectSetInteger(0,ramka4,OBJPROP_XSIZE,125); 
 ObjectSetInteger(0,ramka4,OBJPROP_YSIZE,20); 
 ObjectSetInteger(0,ramka4,OBJPROP_BGCOLOR,clrNONE); 
 ObjectSetInteger(0,ramka4,OBJPROP_BORDER_TYPE,BORDER_FLAT); 
 ObjectSetInteger(0,ramka4,OBJPROP_CORNER,CORNER_RIGHT_UPPER); 
 ObjectSetInteger(0,ramka4,OBJPROP_COLOR,clrGray); 
 ObjectSetInteger(0,ramka4,OBJPROP_STYLE,STYLE_SOLID); 
 ObjectSetInteger(0,ramka4,OBJPROP_WIDTH,3); 
 ObjectSetInteger(0,ramka4,OBJPROP_BACK,true); 
 ObjectSetInteger(0,ramka4,OBJPROP_SELECTABLE,false); 
 ObjectSetInteger(0,ramka4,OBJPROP_SELECTED,false); 
 ObjectSetInteger(0,ramka4,OBJPROP_HIDDEN,true); 
 ObjectSetInteger(0,ramka4,OBJPROP_ZORDER,100);
 //--- 
 ObjectCreate (size_label, OBJ_LABEL,0, 0, 0);
 ObjectSet    (size_label, OBJPROP_CORNER,CORNER_RIGHT_UPPER);
 ObjectSet    (size_label, OBJPROP_XDISTANCE, 50);
 ObjectSet    (size_label, OBJPROP_YDISTANCE, 468);
 ObjectSet    (size_label, OBJPROP_SELECTABLE,false);
 ObjectSet    (size_label, OBJPROP_SELECTED,false);
 ObjectSet    (size_label, OBJPROP_HIDDEN,true);
 ObjectSetText(size_label,"РАЗМЕР СТАВКИ: ",8,"Calibri",clrLime);
 //--- 
 ObjectCreate (size_labe2, OBJ_LABEL,0, 0, 0);
 ObjectSet    (size_labe2, OBJPROP_CORNER,CORNER_RIGHT_UPPER);
 ObjectSet    (size_labe2, OBJPROP_XDISTANCE, 15);
 ObjectSet    (size_labe2, OBJPROP_YDISTANCE, 468);
 ObjectSet    (size_labe2, OBJPROP_SELECTABLE,false);
 ObjectSet    (size_labe2, OBJPROP_SELECTED,false);
 ObjectSet    (size_labe2, OBJPROP_HIDDEN,true);
 ObjectSetText(size_labe2, DoubleToString(tmp_lot,2),8,"Calibri",clrLime);
 
} 

//+------------------------------------------------------------------+
//| Функция обработки нажатия кнопок на панели                       |
//+------------------------------------------------------------------+

void EventsProccesing()
{

//--- Обработка сигнальных кнопок мгновенного старта до конца бара + поправка експирации в минутах
 if(ObjectGetInteger(0,call_end_bar_btn,OBJPROP_STATE) == true)
 {
   buy_time_m = Time[0];
   int end_bar_time = (int)(Time[0] + 60 * Period() - TimeCurrent());
   //datetime expire_time = TimeCurrent() + end_bar_time + tmp_sec2;
   if(send_signal==0){AutobotBuy(TimeCurrent()+ end_bar_time + tmp_sec2, tmp_lot, end_bar_time + tmp_sec2);}
   string log_txt = TimeToString(TimeCurrent(),TIME_SECONDS) + " Сигнал CALL до конца текущего бара, Лот: " + string(tmp_lot) + ", Мартин: " + string(coleno_m) + ", Exp on " + TimeToString(TimeCurrent()+ end_bar_time + tmp_sec2,TIME_SECONDS);
   if(use_log == onn){Print_Log(log_txt);}
   if(use_print == onn){Print(log_txt);}
   
   string obj_line = "CALL_exp_line " + string(TimeCurrent()+ end_bar_time + tmp_sec2);
   ObjectCreate(0,obj_line,OBJ_VLINE,0,TimeCurrent()+ end_bar_time + tmp_sec2,0);
   ObjectSetInteger(0,obj_line,OBJPROP_STYLE,STYLE_DOT);
   ObjectSetInteger(0,obj_line,OBJPROP_COLOR,clrOrange);
   ObjectSetInteger(0,obj_line,OBJPROP_SELECTABLE,false);
   ObjectSetInteger(0,obj_line,OBJPROP_SELECTED,false);
   ObjectSetInteger(0,obj_line,OBJPROP_HIDDEN,true);
   PlaySound("ok.wav");
   Sleep(100);
   ObjectSetInteger(0,call_end_bar_btn,OBJPROP_STATE,false);
   ChartRedraw();
   return;
 }
  
  if(ObjectGetInteger(0,put_end_bar_btn,OBJPROP_STATE) == true)
 {
   sel_time_m = Time[0];
   int end_bar_time = (int)(Time[0] + 60 * Period() - TimeCurrent());
   //datetime expire_time = TimeCurrent() + end_bar_time + tmp_sec2;
   if(send_signal==0){AutobotSell(TimeCurrent()+ end_bar_time + tmp_sec2, tmp_lot, end_bar_time + tmp_sec2);}
   string log_txt = TimeToString(TimeCurrent(),TIME_SECONDS) + " Сигнал PUT до конца текущего бара, Лот: " + string(tmp_lot) + ", Мартин: " + string(coleno_m) + ", Exp on " + TimeToString(TimeCurrent()+ end_bar_time + tmp_sec2,TIME_SECONDS) ;
   if(use_log == onn){Print_Log(log_txt);}
   if(use_print == onn){Print(log_txt);}
   string obj_line = "PUT_exp_line " + string(TimeCurrent()+ end_bar_time + tmp_sec2);
   ObjectCreate(0,obj_line,OBJ_VLINE,0,TimeCurrent()+ end_bar_time + tmp_sec2,0);
   ObjectSetInteger(0,obj_line,OBJPROP_STYLE,STYLE_DOT);
   ObjectSetInteger(0,obj_line,OBJPROP_COLOR,clrOrange);
   ObjectSetInteger(0,obj_line,OBJPROP_SELECTABLE,false);
   ObjectSetInteger(0,obj_line,OBJPROP_SELECTED,false);
   ObjectSetInteger(0,obj_line,OBJPROP_HIDDEN,true);
   PlaySound("ok.wav");
   Sleep(100);
   ObjectSetInteger(0,put_end_bar_btn,OBJPROP_STATE,false);
   ChartRedraw();
   return;
 }
 
 //--- Обработка сигнальных кнопок мгновенного старта до конца бара
 if(ObjectGetInteger(0,call_btn,OBJPROP_STATE) == true)
 {
   buy_time_m = Time[0];
   
   if(send_signal==0){AutobotBuy(TimeCurrent() + tmp_sec2, tmp_lot, tmp_sec2);}
   string log_txt = TimeToString(TimeCurrent(),TIME_SECONDS) + " Сигнал CALL, Лот: " + string(tmp_lot) + ", Мартин: " + string(coleno_m) + ", Exp on " + TimeToString(TimeCurrent()+ tmp_sec2,TIME_SECONDS);
   if(use_log == onn){Print_Log(log_txt);}
   if(use_print == onn){Print(log_txt);}
   
   string obj_line = "CALL_exp_line " + string(TimeCurrent() + tmp_sec2);
   ObjectCreate(0,obj_line,OBJ_VLINE,0,TimeCurrent() + tmp_sec2,0);
   ObjectSetInteger(0,obj_line,OBJPROP_STYLE,STYLE_DOT);
   ObjectSetInteger(0,obj_line,OBJPROP_COLOR,clrOrange);
   ObjectSetInteger(0,obj_line,OBJPROP_SELECTABLE,false);
   ObjectSetInteger(0,obj_line,OBJPROP_SELECTED,false);
   ObjectSetInteger(0,obj_line,OBJPROP_HIDDEN,true);
   PlaySound("ok.wav");
   Sleep(100);
   ObjectSetInteger(0,call_btn,OBJPROP_STATE,false);
   ChartRedraw();
   return;
 }
  
  if(ObjectGetInteger(0,put_btn,OBJPROP_STATE) == true)
 {
   sel_time_m = Time[0];
   if(send_signal==0){AutobotSell(TimeCurrent() + tmp_sec2, tmp_lot, tmp_sec2);}
   string log_txt = TimeToString(TimeCurrent(),TIME_SECONDS) + " Сигнал PUT, Лот: " + string(tmp_lot) + ", Мартин: " + string(coleno_m) + ", Exp on " + TimeToString(TimeCurrent() + tmp_sec2,TIME_SECONDS) ;
   if(use_log == onn){Print_Log(log_txt);}
   if(use_print == onn){Print(log_txt);}
   string obj_line = "PUT_exp_line " + string(TimeCurrent() + tmp_sec2);
   ObjectCreate(0,obj_line,OBJ_VLINE,0,TimeCurrent() + tmp_sec2,0);
   ObjectSetInteger(0,obj_line,OBJPROP_STYLE,STYLE_DOT);
   ObjectSetInteger(0,obj_line,OBJPROP_COLOR,clrOrange);
   ObjectSetInteger(0,obj_line,OBJPROP_SELECTABLE,false);
   ObjectSetInteger(0,obj_line,OBJPROP_SELECTED,false);
   ObjectSetInteger(0,obj_line,OBJPROP_HIDDEN,true);
   PlaySound("ok.wav");
   Sleep(100);
   ObjectSetInteger(0,put_btn,OBJPROP_STATE,false);
   ChartRedraw();
   return;
 }
 
 //--- Обработка сигнальных кнопок постановки сигнала в очередь
 if(ObjectGetInteger(0,call_timer_btn,OBJPROP_STATE) == true)
 {
   //buy_time_m = Time[0];
   int end_bar_time = (int)(Time[0] + 60 * Period() - TimeCurrent());
   int start_bar_time = 0;
   int exp_time = 0;
   if(signal_mode_m == 0){start_bar_time = (int)(TimeCurrent() + end_bar_time + Period()*60*bar_shift_m);}
   if(signal_mode_m == 1){start_bar_time = (int)(TimeCurrent() + end_bar_time - sec_shift_m);}
   if(expr_mode_m == 0 && signal_mode_m == 0){exp_time = start_bar_time + tmp_sec;}
   if(expr_mode_m == 0 && signal_mode_m == 1){exp_time = start_bar_time + tmp_sec + sec_shift_m;}
   if(expr_mode_m == 1 && signal_mode_m == 1){exp_time = start_bar_time + tmp_sec2 + sec_shift_m;}
   if(expr_mode_m == 1 && signal_mode_m == 0){exp_time = start_bar_time + tmp_sec2;}
   g_exp_time = exp_time;
   string log_txt = TimeToString(TimeCurrent(),TIME_SECONDS) + " Сигнал CALL поставлен в очередь, Лот: " + string(tmp_lot) + ", Мартин: " + string(coleno_m) + ", Start on " + TimeToString(start_bar_time,TIME_SECONDS) + " Exp on " + TimeToString(exp_time,TIME_SECONDS);
   if(use_log == onn){Print_Log(log_txt);}
   if(use_print == onn){Print(log_txt);}
   
   string obj_str_line = "CALL_str_line " + TimeToString(start_bar_time,TIME_SECONDS);
   ObjectCreate(0,obj_str_line,OBJ_VLINE,0,start_bar_time,0);
   ObjectSetInteger(0,obj_str_line,OBJPROP_STYLE,STYLE_DOT);
   ObjectSetInteger(0,obj_str_line,OBJPROP_COLOR,clrDodgerBlue);
   ObjectSetInteger(0,obj_str_line,OBJPROP_SELECTABLE,false);
   ObjectSetInteger(0,obj_str_line,OBJPROP_SELECTED,false);
   ObjectSetInteger(0,obj_str_line,OBJPROP_HIDDEN,true);
   
   string obj_line = "CALL_exp_line " + TimeToString(exp_time,TIME_SECONDS);
   ObjectCreate(0,obj_line,OBJ_VLINE,0,exp_time,0);
   ObjectSetInteger(0,obj_line,OBJPROP_STYLE,STYLE_DOT);
   ObjectSetInteger(0,obj_line,OBJPROP_COLOR,clrOrange);
   ObjectSetInteger(0,obj_line,OBJPROP_SELECTABLE,false);
   ObjectSetInteger(0,obj_line,OBJPROP_SELECTED,false);
   ObjectSetInteger(0,obj_line,OBJPROP_HIDDEN,true);
   PlaySound("ok.wav");
   Sleep(100);
   ObjectSetInteger(0,call_timer_btn,OBJPROP_STATE,false);
   ChartRedraw();
   return;
 }
  
  if(ObjectGetInteger(0,put_timer_btn,OBJPROP_STATE) == true)
 {
   //sel_time_m = Time[0];
   int end_bar_time = (int)(Time[0] + 60 * Period() - TimeCurrent());
   int start_bar_time = 0;
   int exp_time = 0;
   if(signal_mode_m == 0){start_bar_time = (int)(TimeCurrent() + end_bar_time + Period()*60*bar_shift_m);}
   if(signal_mode_m == 1){start_bar_time = (int)(TimeCurrent() + end_bar_time - sec_shift_m);}
   if(expr_mode_m == 0 && signal_mode_m == 0){exp_time = start_bar_time + tmp_sec;}
   if(expr_mode_m == 0 && signal_mode_m == 1){exp_time = start_bar_time + tmp_sec + sec_shift_m;}
   if(expr_mode_m == 1 && signal_mode_m == 1){exp_time = start_bar_time + tmp_sec2 + sec_shift_m;}
   if(expr_mode_m == 1 && signal_mode_m == 0){exp_time = start_bar_time + tmp_sec2;}
   g_exp_time = exp_time;
   string log_txt = TimeToString(TimeCurrent(),TIME_SECONDS) + " Сигнал PUT поставлен в очередь, Лот: " + string(tmp_lot) + ", Мартин: " + string(coleno_m) + ", Start on " + TimeToString(start_bar_time,TIME_SECONDS) + " Exp on " + TimeToString(exp_time,TIME_SECONDS);
   if(use_log == onn){Print_Log(log_txt);}
   if(use_print == onn){Print(log_txt);}
   
   string obj_str_line = "PUT_str_line " + TimeToString(start_bar_time,TIME_SECONDS);
   ObjectCreate(0,obj_str_line,OBJ_VLINE,0,start_bar_time,0);
   ObjectSetInteger(0,obj_str_line,OBJPROP_STYLE,STYLE_DOT);
   ObjectSetInteger(0,obj_str_line,OBJPROP_COLOR,clrRed);
   ObjectSetInteger(0,obj_str_line,OBJPROP_SELECTABLE,false);
   ObjectSetInteger(0,obj_str_line,OBJPROP_SELECTED,false);
   ObjectSetInteger(0,obj_str_line,OBJPROP_HIDDEN,true);
   
   
   string obj_line = "PUT_exp_line " + TimeToString(exp_time,TIME_SECONDS);
   ObjectCreate(0,obj_line,OBJ_VLINE,0,exp_time,0);
   ObjectSetInteger(0,obj_line,OBJPROP_STYLE,STYLE_DOT);
   ObjectSetInteger(0,obj_line,OBJPROP_COLOR,clrOrange);
   ObjectSetInteger(0,obj_line,OBJPROP_SELECTABLE,false);
   ObjectSetInteger(0,obj_line,OBJPROP_SELECTED,false);
   ObjectSetInteger(0,obj_line,OBJPROP_HIDDEN,true);
   PlaySound("ok.wav");
   Sleep(100);
   ObjectSetInteger(0,put_timer_btn,OBJPROP_STATE,false);
   ChartRedraw();
   return;
 }
 
 //--- Обработка кнопки отмены сигнала
 if(ObjectGetInteger(0,cancell_btn,OBJPROP_STATE) == true)
 {
   buy_time_m = 0;
   sel_time_m = 0;
   upbuffer_m[0] = EMPTY_VALUE;
   dnbuffer_m[0] = EMPTY_VALUE;
    
   ObjectsDeleteAll(0,OBJ_VLINE);
   
   string log_txt = TimeToString(TimeCurrent(),TIME_SECONDS) + " Сигнал отменён ! ";
   if(use_log == onn){Print_Log(log_txt);}
   if(use_print == onn){Print(log_txt);}
   
   PlaySound("timeout.wav");
   Sleep(100);
   ObjectSetInteger(0,cancell_btn,OBJPROP_STATE,false);
   ChartRedraw();
   return;
 }
 
 
 //--- Обработка выбора лота
 if(ObjectGetInteger(0,lot1_btn,OBJPROP_STATE) == true)
 {
   tmp_lot = Lot1;
   last_lot = Lot1;
   ObjectSetInteger(0,lot1_btn,OBJPROP_BGCOLOR,clrDodgerBlue);
   ObjectSetInteger(0,lot2_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,lot3_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,lot4_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,lot5_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,lot6_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,srs0_btn,OBJPROP_BGCOLOR,clrOrange);
   ObjectSetInteger(0,srs1_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,srs2_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,srs3_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,srs4_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,srs5_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetText(size_labe2, DoubleToString(tmp_lot,2),8,"Calibri",clrLime);
   coleno_m = 0;
   PlaySound("clock_tick.wav");
   string log_txt = TimeToString(TimeCurrent(),TIME_DATE|TIME_SECONDS) + " Лот был изменён на " + DoubleToString(tmp_lot,2);
   if(use_log == onn){Print_Log(log_txt);}
   if(use_print == onn){Print(log_txt);}
   Sleep(100);
   ObjectSetInteger(0,lot1_btn,OBJPROP_STATE,false);
   ChartRedraw();
   return;
  }
  
 if(ObjectGetInteger(0,lot2_btn,OBJPROP_STATE) == true)
 {
   tmp_lot = Lot2;
   last_lot = Lot2;
   ObjectSetInteger(0,lot2_btn,OBJPROP_BGCOLOR,clrDodgerBlue);
   ObjectSetInteger(0,lot1_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,lot3_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,lot4_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,lot5_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,lot6_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,srs0_btn,OBJPROP_BGCOLOR,clrOrange);
   ObjectSetInteger(0,srs1_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,srs2_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,srs3_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,srs4_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,srs5_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetText(size_labe2, DoubleToString(tmp_lot,2),8,"Calibri",clrLime);
   coleno_m = 0;
   PlaySound("clock_tick.wav");
   string log_txt = TimeToString(TimeCurrent(),TIME_DATE|TIME_SECONDS) + " Лот был изменён на " + DoubleToString(tmp_lot,2);
   if(use_log == onn){Print_Log(log_txt);}
   if(use_print == onn){Print(log_txt);}
   Sleep(100);
   ObjectSetInteger(0,lot2_btn,OBJPROP_STATE,false);
   ChartRedraw();
   return;
  }
  
  if(ObjectGetInteger(0,lot3_btn,OBJPROP_STATE) == true)
  {
   tmp_lot = Lot3;
   last_lot = Lot3;
   ObjectSetInteger(0,lot3_btn,OBJPROP_BGCOLOR,clrDodgerBlue);
   ObjectSetInteger(0,lot1_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,lot2_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,lot4_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,lot5_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,lot6_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,srs0_btn,OBJPROP_BGCOLOR,clrOrange);
   ObjectSetInteger(0,srs1_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,srs2_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,srs3_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,srs4_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,srs5_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetText(size_labe2, DoubleToString(tmp_lot,2),8,"Calibri",clrLime);
   coleno_m = 0;
   PlaySound("clock_tick.wav");
   string log_txt = TimeToString(TimeCurrent(),TIME_DATE|TIME_SECONDS) + " Лот был изменён на " + DoubleToString(tmp_lot,2);
   if(use_log == onn){Print_Log(log_txt);}
   if(use_print == onn){Print(log_txt);}
   Sleep(100);
   ObjectSetInteger(0,lot3_btn,OBJPROP_STATE,false);
   ChartRedraw();
   return;
  }
  
  if(ObjectGetInteger(0,lot4_btn,OBJPROP_STATE) == true)
  {
   tmp_lot = Lot4;
   last_lot = Lot4;
   ObjectSetInteger(0,lot4_btn,OBJPROP_BGCOLOR,clrDodgerBlue);
   ObjectSetInteger(0,lot1_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,lot2_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,lot3_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,lot5_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,lot6_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,srs0_btn,OBJPROP_BGCOLOR,clrOrange);
   ObjectSetInteger(0,srs1_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,srs2_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,srs3_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,srs4_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,srs5_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetText(size_labe2, DoubleToString(tmp_lot,2),8,"Calibri",clrLime);
   coleno_m = 0;
   PlaySound("clock_tick.wav");
   string log_txt = TimeToString(TimeCurrent(),TIME_DATE|TIME_SECONDS) + " Лот был изменён на " + DoubleToString(tmp_lot,2);
   if(use_log == onn){Print_Log(log_txt);}
   if(use_print == onn){Print(log_txt);}
   Sleep(100);
   ObjectSetInteger(0,lot4_btn,OBJPROP_STATE,false);
   ChartRedraw();
   return;
  }
  
  if(ObjectGetInteger(0,lot5_btn,OBJPROP_STATE) == true)
  {
   tmp_lot = Lot5;
   last_lot = Lot5;
   ObjectSetInteger(0,lot5_btn,OBJPROP_BGCOLOR,clrDodgerBlue);
   ObjectSetInteger(0,lot1_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,lot2_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,lot3_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,lot4_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,lot6_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,srs0_btn,OBJPROP_BGCOLOR,clrOrange);
   ObjectSetInteger(0,srs1_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,srs2_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,srs3_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,srs4_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,srs5_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetText(size_labe2, DoubleToString(tmp_lot,2),8,"Calibri",clrLime);
   coleno_m = 0;
   PlaySound("clock_tick.wav");
   string log_txt = TimeToString(TimeCurrent(),TIME_DATE|TIME_SECONDS) + " Лот был изменён на " + DoubleToString(tmp_lot,2);
   if(use_log == onn){Print_Log(log_txt);}
   if(use_print == onn){Print(log_txt);}
   Sleep(100);
   ObjectSetInteger(0,lot5_btn,OBJPROP_STATE,false);
   ChartRedraw();
   return;
  }
  
  if(ObjectGetInteger(0,lot6_btn,OBJPROP_STATE) == true)
  {
   tmp_lot = Lot6;
   last_lot = Lot6;
   ObjectSetInteger(0,lot6_btn,OBJPROP_BGCOLOR,clrDodgerBlue);
   ObjectSetInteger(0,lot1_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,lot2_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,lot3_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,lot4_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,lot5_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,srs0_btn,OBJPROP_BGCOLOR,clrOrange);
   ObjectSetInteger(0,srs1_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,srs2_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,srs3_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,srs4_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,srs5_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetText(size_labe2, DoubleToString(tmp_lot,2),8,"Calibri",clrLime);
   coleno_m = 0;
   PlaySound("clock_tick.wav");
   string log_txt = TimeToString(TimeCurrent(),TIME_DATE|TIME_SECONDS) + " Лот был изменён на " + DoubleToString(tmp_lot,2);
   if(use_log == onn){Print_Log(log_txt);}
   if(use_print == onn){Print(log_txt);}
   Sleep(100);
   ObjectSetInteger(0,lot6_btn,OBJPROP_STATE,false);
   ChartRedraw();
   return;
  }
  
  //--- Обработка выбора колена
  if(ObjectGetInteger(0,srs0_btn,OBJPROP_STATE) == true)
  {
   tmp_lot = last_lot;
   ObjectSetInteger(0,srs0_btn,OBJPROP_BGCOLOR,clrOrange);
   ObjectSetInteger(0,srs1_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,srs2_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,srs3_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,srs4_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,srs5_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetText(size_labe2, DoubleToString(tmp_lot,2),8,"Calibri",clrLime);
   coleno_m = 0;
   PlaySound("clock_tick.wav");
   string log_txt = TimeToString(TimeCurrent(),TIME_DATE|TIME_SECONDS) + " Лот был изменён на " + DoubleToString(tmp_lot,2);
   if(use_log == onn){Print_Log(log_txt);}
   if(use_print == onn){Print(log_txt);}
   Sleep(100);
   ObjectSetInteger(0,srs0_btn,OBJPROP_STATE,false);
   ChartRedraw();
   return;
  }
  
  if(ObjectGetInteger(0,srs1_btn,OBJPROP_STATE) == true)
  {
   tmp_lot = last_lot*Multipler;
   ObjectSetInteger(0,srs1_btn,OBJPROP_BGCOLOR,clrOrange);
   ObjectSetInteger(0,srs0_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,srs2_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,srs3_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,srs4_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,srs5_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetText(size_labe2, DoubleToString(tmp_lot,2),8,"Calibri",clrLime);
   coleno_m = 1;
   PlaySound("clock_tick.wav");
   string log_txt = TimeToString(TimeCurrent(),TIME_DATE|TIME_SECONDS) + " Лот был изменён на " + DoubleToString(tmp_lot,2);
   if(use_log == onn){Print_Log(log_txt);}
   if(use_print == onn){Print(log_txt);}
   Sleep(100);
   ObjectSetInteger(0,srs1_btn,OBJPROP_STATE,false);
   ChartRedraw();
   return;
  }
  
  if(ObjectGetInteger(0,srs2_btn,OBJPROP_STATE) == true)
  {
   tmp_lot = last_lot*Multipler*Multipler;
   ObjectSetInteger(0,srs2_btn,OBJPROP_BGCOLOR,clrOrange);
   ObjectSetInteger(0,srs0_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,srs1_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,srs3_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,srs4_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,srs5_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetText(size_labe2, DoubleToString(tmp_lot,2),8,"Calibri",clrLime);
   coleno_m = 2;
   PlaySound("clock_tick.wav");
   string log_txt = TimeToString(TimeCurrent(),TIME_DATE|TIME_SECONDS) + " Лот был изменён на " + DoubleToString(tmp_lot,2);
   if(use_log == onn){Print_Log(log_txt);}
   if(use_print == onn){Print(log_txt);}
   Sleep(100);
   ObjectSetInteger(0,srs2_btn,OBJPROP_STATE,false);
   ChartRedraw();
   return;
  }
  
  if(ObjectGetInteger(0,srs3_btn,OBJPROP_STATE) == true)
  {
   tmp_lot = last_lot*Multipler*Multipler*Multipler;
   ObjectSetInteger(0,srs3_btn,OBJPROP_BGCOLOR,clrOrange);
   ObjectSetInteger(0,srs0_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,srs1_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,srs2_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,srs4_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,srs5_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetText(size_labe2, DoubleToString(tmp_lot,2),8,"Calibri",clrLime);
   coleno_m = 3;
   PlaySound("clock_tick.wav");
   string log_txt = TimeToString(TimeCurrent(),TIME_DATE|TIME_SECONDS) + " Лот был изменён на " + DoubleToString(tmp_lot,2);
   if(use_log == onn){Print_Log(log_txt);}
   if(use_print == onn){Print(log_txt);}
   Sleep(100);
   ObjectSetInteger(0,srs3_btn,OBJPROP_STATE,false);
   ChartRedraw();
   return;
  }
  
  if(ObjectGetInteger(0,srs4_btn,OBJPROP_STATE) == true)
  {
   tmp_lot = last_lot*Multipler*Multipler*Multipler*Multipler;
   ObjectSetInteger(0,srs4_btn,OBJPROP_BGCOLOR,clrOrange);
   ObjectSetInteger(0,srs0_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,srs1_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,srs2_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,srs3_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,srs5_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetText(size_labe2, DoubleToString(tmp_lot,2),8,"Calibri",clrLime);
   coleno_m = 4;
   PlaySound("clock_tick.wav");
   string log_txt = TimeToString(TimeCurrent(),TIME_DATE|TIME_SECONDS) + " Лот был изменён на " + DoubleToString(tmp_lot,2);
   if(use_log == onn){Print_Log(log_txt);}
   if(use_print == onn){Print(log_txt);}
   Sleep(100);
   ObjectSetInteger(0,srs4_btn,OBJPROP_STATE,false);
   ChartRedraw();
   return;
  }
  
  if(ObjectGetInteger(0,srs5_btn,OBJPROP_STATE) == true)
  {
   tmp_lot = last_lot*Multipler*Multipler*Multipler*Multipler*Multipler;
   ObjectSetInteger(0,srs5_btn,OBJPROP_BGCOLOR,clrOrange);
   ObjectSetInteger(0,srs0_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,srs1_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,srs2_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,srs3_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,srs4_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetText(size_labe2, DoubleToString(tmp_lot,2),8,"Calibri",clrLime);
   coleno_m = 5;
   PlaySound("clock_tick.wav");
   string log_txt = TimeToString(TimeCurrent(),TIME_DATE|TIME_SECONDS) + " Лот был изменён на " + DoubleToString(tmp_lot,2);
   if(use_log == onn){Print_Log(log_txt);}
   if(use_print == onn){Print(log_txt);}
   Sleep(100);
   ObjectSetInteger(0,srs5_btn,OBJPROP_STATE,false);
   ChartRedraw();
   return;
  }
  
  //--- Обработка выбора експирации по барам
  if(ObjectGetInteger(0,bar1_btn,OBJPROP_STATE) == true)
  {
   tmp_sec = Period()*60*bar1;
   ObjectSetInteger(0,bar1_btn,OBJPROP_BGCOLOR,clrOrange);
   ObjectSetInteger(0,bar2_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,bar3_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,bar4_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,bar5_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,bar6_btn,OBJPROP_BGCOLOR,clrGray);
   PlaySound("clock_tick.wav");
   string log_txt = TimeToString(TimeCurrent(),TIME_DATE|TIME_SECONDS) + " Експирация по барам равна: " + string(bar1) + " ( " + string(tmp_sec) + " sec"+ " )" ;
   if(use_log == onn){Print_Log(log_txt);}
   if(use_print == onn){Print(log_txt);}
   Sleep(100);
   ObjectSetInteger(0,bar1_btn,OBJPROP_STATE,false);
   ChartRedraw();
   return;
  }
  
  if(ObjectGetInteger(0,bar2_btn,OBJPROP_STATE) == true)
  {
   tmp_sec = Period()*60*bar2;
   ObjectSetInteger(0,bar2_btn,OBJPROP_BGCOLOR,clrOrange);
   ObjectSetInteger(0,bar1_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,bar3_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,bar4_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,bar5_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,bar6_btn,OBJPROP_BGCOLOR,clrGray);
   PlaySound("clock_tick.wav");
   string log_txt = TimeToString(TimeCurrent(),TIME_DATE|TIME_SECONDS) + " Експирация по барам равна: " + string(bar2) + " ( " + string(tmp_sec) + " sec"+ " )" ;
   if(use_log == onn){Print_Log(log_txt);}
   if(use_print == onn){Print(log_txt);}
   Sleep(100);
   ObjectSetInteger(0,bar2_btn,OBJPROP_STATE,false);
   ChartRedraw();
   return;
  }
  
  if(ObjectGetInteger(0,bar3_btn,OBJPROP_STATE) == true)
  {
   tmp_sec = Period()*60*bar3;
   ObjectSetInteger(0,bar3_btn,OBJPROP_BGCOLOR,clrOrange);
   ObjectSetInteger(0,bar1_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,bar2_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,bar4_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,bar5_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,bar6_btn,OBJPROP_BGCOLOR,clrGray);
   PlaySound("clock_tick.wav");
   string log_txt = TimeToString(TimeCurrent(),TIME_DATE|TIME_SECONDS) + " Експирация по барам равна: " + string(bar3) + " ( " + string(tmp_sec) + " sec"+ " )" ;
   if(use_log == onn){Print_Log(log_txt);}
   if(use_print == onn){Print(log_txt);}
   Sleep(100);
   ObjectSetInteger(0,bar3_btn,OBJPROP_STATE,false);
   ChartRedraw();
   return;
  }
  
  if(ObjectGetInteger(0,bar4_btn,OBJPROP_STATE) == true)
  {
   tmp_sec = Period()*60*bar4;
   ObjectSetInteger(0,bar4_btn,OBJPROP_BGCOLOR,clrOrange);
   ObjectSetInteger(0,bar1_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,bar2_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,bar3_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,bar5_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,bar6_btn,OBJPROP_BGCOLOR,clrGray);
   PlaySound("clock_tick.wav");
   string log_txt = TimeToString(TimeCurrent(),TIME_DATE|TIME_SECONDS) + " Експирация по барам равна: " + string(bar4) + " ( " + string(tmp_sec) + " sec"+ " )" ;
   if(use_log == onn){Print_Log(log_txt);}
   if(use_print == onn){Print(log_txt);}
   Sleep(100);
   ObjectSetInteger(0,bar4_btn,OBJPROP_STATE,false);
   ChartRedraw();
   return;
  }
  
  if(ObjectGetInteger(0,bar5_btn,OBJPROP_STATE) == true)
  {
   tmp_sec = Period()*60*bar5;
   ObjectSetInteger(0,bar5_btn,OBJPROP_BGCOLOR,clrOrange);
   ObjectSetInteger(0,bar1_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,bar2_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,bar3_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,bar4_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,bar6_btn,OBJPROP_BGCOLOR,clrGray);
   PlaySound("clock_tick.wav");
   string log_txt = TimeToString(TimeCurrent(),TIME_DATE|TIME_SECONDS) + " Експирация по барам равна: " + string(bar5) + " ( " + string(tmp_sec) + " sec"+ " )" ;
   if(use_log == onn){Print_Log(log_txt);}
   if(use_print == onn){Print(log_txt);}
   Sleep(100);
   ObjectSetInteger(0,bar5_btn,OBJPROP_STATE,false);
   ChartRedraw();
   return;
  }
  
  if(ObjectGetInteger(0,bar6_btn,OBJPROP_STATE) == true)
  {
   tmp_sec = Period()*60*bar6;
   ObjectSetInteger(0,bar6_btn,OBJPROP_BGCOLOR,clrOrange);
   ObjectSetInteger(0,bar1_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,bar2_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,bar3_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,bar4_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,bar5_btn,OBJPROP_BGCOLOR,clrGray);
   PlaySound("clock_tick.wav");
   string log_txt = TimeToString(TimeCurrent(),TIME_DATE|TIME_SECONDS) + " Експирация по барам равна: " + string(bar6) + " ( " + string(tmp_sec) + " sec"+ " )" ;
   if(use_log == onn){Print_Log(log_txt);}
   if(use_print == onn){Print(log_txt);}
   Sleep(100);
   ObjectSetInteger(0,bar6_btn,OBJPROP_STATE,false);
   ChartRedraw();
   return;
  }
  
  //--- Обработка выбора експирации по минутам
  if(ObjectGetInteger(0,min1_btn,OBJPROP_STATE) == true)
  {
   tmp_sec2 = 60*min1;
   ObjectSetInteger(0,min1_btn,OBJPROP_BGCOLOR,clrOrange);
   ObjectSetInteger(0,min2_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,min3_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,min4_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,min5_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,min6_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,min7_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,min8_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,min9_btn,OBJPROP_BGCOLOR,clrGray);
   PlaySound("clock_tick.wav");
   string log_txt = TimeToString(TimeCurrent(),TIME_DATE|TIME_SECONDS) + " Експирация по минутам равна: " + string(min1) + " ( " + string(tmp_sec2) + " sec"+ " )" ;
   if(use_log == onn){Print_Log(log_txt);}
   if(use_print == onn){Print(log_txt);}
   Sleep(100);
   ObjectSetInteger(0,min1_btn,OBJPROP_STATE,false);
   ChartRedraw();
   return;
  }
  
  if(ObjectGetInteger(0,min2_btn,OBJPROP_STATE) == true)
  {
   tmp_sec2 = 60*min2;
   ObjectSetInteger(0,min2_btn,OBJPROP_BGCOLOR,clrOrange);
   ObjectSetInteger(0,min1_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,min3_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,min4_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,min5_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,min6_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,min7_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,min8_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,min9_btn,OBJPROP_BGCOLOR,clrGray);
   PlaySound("clock_tick.wav");
   string log_txt = TimeToString(TimeCurrent(),TIME_DATE|TIME_SECONDS) + " Експирация по минутам равна: " + string(min2) + " ( " + string(tmp_sec2) + " sec"+ " )" ;
   if(use_log == onn){Print_Log(log_txt);}
   if(use_print == onn){Print(log_txt);}
   Sleep(100);
   ObjectSetInteger(0,min2_btn,OBJPROP_STATE,false);
   ChartRedraw();
   return;
  }
  
  if(ObjectGetInteger(0,min3_btn,OBJPROP_STATE) == true)
  {
   tmp_sec2 = 60*min3;
   ObjectSetInteger(0,min3_btn,OBJPROP_BGCOLOR,clrOrange);
   ObjectSetInteger(0,min1_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,min2_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,min4_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,min5_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,min6_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,min7_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,min8_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,min9_btn,OBJPROP_BGCOLOR,clrGray);
   PlaySound("clock_tick.wav");
   string log_txt = TimeToString(TimeCurrent(),TIME_DATE|TIME_SECONDS) + " Експирация по минутам равна: " + string(min3) + " ( " + string(tmp_sec2) + " sec"+ " )" ;
   if(use_log == onn){Print_Log(log_txt);}
   if(use_print == onn){Print(log_txt);}
   Sleep(100);
   ObjectSetInteger(0,min3_btn,OBJPROP_STATE,false);
   ChartRedraw();
   return;
  }
  
  if(ObjectGetInteger(0,min4_btn,OBJPROP_STATE) == true)
  {
   tmp_sec2 = 60*min4;
   ObjectSetInteger(0,min4_btn,OBJPROP_BGCOLOR,clrOrange);
   ObjectSetInteger(0,min1_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,min2_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,min3_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,min5_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,min6_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,min7_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,min8_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,min9_btn,OBJPROP_BGCOLOR,clrGray);
   PlaySound("clock_tick.wav");
   string log_txt = TimeToString(TimeCurrent(),TIME_DATE|TIME_SECONDS) + " Експирация по минутам равна: " + string(min4) + " ( " + string(tmp_sec2) + " sec"+ " )" ;
   if(use_log == onn){Print_Log(log_txt);}
   if(use_print == onn){Print(log_txt);}
   Sleep(100);
   ObjectSetInteger(0,min4_btn,OBJPROP_STATE,false);
   ChartRedraw();
   return;
  }
  
  if(ObjectGetInteger(0,min5_btn,OBJPROP_STATE) == true)
  {
   tmp_sec2 = 60*min5;
   ObjectSetInteger(0,min5_btn,OBJPROP_BGCOLOR,clrOrange);
   ObjectSetInteger(0,min1_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,min2_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,min3_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,min4_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,min6_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,min7_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,min8_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,min9_btn,OBJPROP_BGCOLOR,clrGray);
   PlaySound("clock_tick.wav");
   string log_txt = TimeToString(TimeCurrent(),TIME_DATE|TIME_SECONDS) + " Експирация по минутам равна: " + string(min5) + " ( " + string(tmp_sec2) + " sec"+ " )" ;
   if(use_log == onn){Print_Log(log_txt);}
   if(use_print == onn){Print(log_txt);}
   Sleep(100);
   ObjectSetInteger(0,min5_btn,OBJPROP_STATE,false);
   ChartRedraw();
   return;
  }
  
  if(ObjectGetInteger(0,min6_btn,OBJPROP_STATE) == true)
  {
   tmp_sec2 = 60*min6;
   ObjectSetInteger(0,min6_btn,OBJPROP_BGCOLOR,clrOrange);
   ObjectSetInteger(0,min1_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,min2_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,min3_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,min4_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,min5_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,min7_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,min8_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,min9_btn,OBJPROP_BGCOLOR,clrGray);
   PlaySound("clock_tick.wav");
   string log_txt = TimeToString(TimeCurrent(),TIME_DATE|TIME_SECONDS) + " Експирация по минутам равна: " + string(min6) + " ( " + string(tmp_sec2) + " sec"+ " )" ;
   if(use_log == onn){Print_Log(log_txt);}
   if(use_print == onn){Print(log_txt);}
   Sleep(100);
   ObjectSetInteger(0,min6_btn,OBJPROP_STATE,false);
   ChartRedraw();
   return;
  }
  
  if(ObjectGetInteger(0,min7_btn,OBJPROP_STATE) == true)
  {
   tmp_sec2 = 60*min7;
   ObjectSetInteger(0,min7_btn,OBJPROP_BGCOLOR,clrOrange);
   ObjectSetInteger(0,min1_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,min2_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,min3_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,min4_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,min5_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,min6_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,min8_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,min9_btn,OBJPROP_BGCOLOR,clrGray);
   PlaySound("clock_tick.wav");
   string log_txt = TimeToString(TimeCurrent(),TIME_DATE|TIME_SECONDS) + " Експирация по минутам равна: " + string(min7) + " ( " + string(tmp_sec2) + " sec"+ " )" ;
   if(use_log == onn){Print_Log(log_txt);}
   if(use_print == onn){Print(log_txt);}
   Sleep(100);
   ObjectSetInteger(0,min7_btn,OBJPROP_STATE,false);
   ChartRedraw();
   return;
  }
  
  if(ObjectGetInteger(0,min8_btn,OBJPROP_STATE) == true)
  {
   tmp_sec2 = 60*min8;
   ObjectSetInteger(0,min8_btn,OBJPROP_BGCOLOR,clrOrange);
   ObjectSetInteger(0,min1_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,min2_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,min3_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,min4_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,min5_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,min6_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,min7_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,min9_btn,OBJPROP_BGCOLOR,clrGray);
   PlaySound("clock_tick.wav");
   string log_txt = TimeToString(TimeCurrent(),TIME_DATE|TIME_SECONDS) + " Експирация по минутам равна: " + string(min8) + " ( " + string(tmp_sec2) + " sec"+ " )" ;
   if(use_log == onn){Print_Log(log_txt);}
   if(use_print == onn){Print(log_txt);}
   Sleep(100);
   ObjectSetInteger(0,min8_btn,OBJPROP_STATE,false);
   ChartRedraw();
   return;
  }
  
  if(ObjectGetInteger(0,min9_btn,OBJPROP_STATE) == true)
  {
   tmp_sec2 = 60*min9;
   ObjectSetInteger(0,min9_btn,OBJPROP_BGCOLOR,clrOrange);
   ObjectSetInteger(0,min1_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,min2_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,min3_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,min4_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,min5_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,min6_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,min7_btn,OBJPROP_BGCOLOR,clrGray);
   ObjectSetInteger(0,min8_btn,OBJPROP_BGCOLOR,clrGray);
   PlaySound("clock_tick.wav");
   string log_txt = TimeToString(TimeCurrent(),TIME_DATE|TIME_SECONDS) + " Експирация по минутам равна: " + string(min9) + " ( " + string(tmp_sec2) + " sec"+ " )" ;
   if(use_log == onn){Print_Log(log_txt);}
   if(use_print == onn){Print(log_txt);}
   Sleep(100);
   ObjectSetInteger(0,min9_btn,OBJPROP_STATE,false);
   ChartRedraw();
   return;
  }

}

//+------------------------------------------------------------------+
//| Функция отрисовки лога на графике                                |
//+------------------------------------------------------------------+
void Print_Log(string log_txt)
{
 log_sz++;
 ArrayResize(log_mass,log_sz,0);
 log_mass[log_sz-1] = log_txt;
 string lg_txt =  "\n"+"\n"+ 
                  "В плюс : "     + string(wins)     + "\n" +
                  "В минус : "   + string(losses)   + "\n" +
                  "В плюс_М : "   + string(m_wins)   + "\n" +
                  "В минус_М : " + string(m_losses) + "\n" +
                  "№ колена : "   + string(coleno)   + "\n" +
                  "\n"+
                  ">> LOG << "+"\n"+
                  "================================================" + "\n"+
                   string(log_mass[log_sz-1])+"\n"+
                   string(log_mass[log_sz-2])+"\n"+
                   string(log_mass[log_sz-3])+"\n"+
                   string(log_mass[log_sz-4])+"\n"+
                   string(log_mass[log_sz-5])+"\n"+
                   string(log_mass[log_sz-6])+"\n"+
                   string(log_mass[log_sz-7])+"\n"+
                   string(log_mass[log_sz-8])+"\n"+
                   string(log_mass[log_sz-9])+"\n"+
                   string(log_mass[log_sz-10])+"\n";
                   Comment(lg_txt);
}

//+------------------------------------------------------------------+
//| Рисуем уровень цены при старте сигнала                           |
//+------------------------------------------------------------------+ 
void drawEntryLine(bool pIsCall)
{
   string objName="Line"+IntegerToString(mLineObjectsNumber);
   if(!ObjectCreate(ChartID(),objName,OBJ_RECTANGLE,0,Time[1],Bid,Time[0],Bid))
     {
      Print(" Не могу создать линию входа : "+IntegerToString(GetLastError()));
     }
   else
     {
      mLineObjectsNumber++;
      if(pIsCall)
        {
         ObjectSetInteger(ChartID(),objName,OBJPROP_COLOR,clrLime);
         ObjectSetInteger(ChartID(),objName,OBJPROP_BGCOLOR,clrLime);
        }
      else
        {
         ObjectSetInteger(ChartID(),objName,OBJPROP_COLOR,clrRed);
         ObjectSetInteger(ChartID(),objName,OBJPROP_BGCOLOR,clrRed);
        }
      ObjectSetInteger(ChartID(),objName,OBJPROP_BACK,false);
      ObjectSetInteger(ChartID(),objName,OBJPROP_WIDTH,2);

     }
}