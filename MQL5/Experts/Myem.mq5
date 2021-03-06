//+------------------------------------------------------------------+
//|                                                         Myem.mq5 |
//|                                  Copyright 2021, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, HÀ NGỌC LÂM"
#property link      "https://www.facebook.com/ngoclam.ha.714049/"
#property version   "1.00"
#property description   "Specialized bot to trade US500"

#include <Lam/Function.mqh>
#include <Lam/RSI_LAM.mqh>
#include <Lam/CCI_LAM.mqh>
#include <Lam/Momentum_LAM.mqh>
#include <Lam/Doji_Lam.mqh>
#include <Lam/MA_LAM.mqh>
#include <Lam/Data.mqh>

CCCI m_cci;
CMomentum m_mmt;
CRSI m_rsi; 
CDoji m_doji;
CMA m_MA;




//void OnStart ()
//  {
// //--- 
//      m_trade.Buy( 1.0 ); // open Buy position, volume 1.0 lot 
//  }

int OnInit()
  {
      if(InpTrailingStop!=0 && InpTrailingStep==0)
      {
         string err_text;
         if(MQLInfoInteger(MQL_TESTER))
         {
               Print(__FUNCTION__,", ERROR: ",err_text);
               return(INIT_FAILED);
         }
         else // if the Expert Advisor is run on the chart, tell the user about the error
         {
               Alert(__FUNCTION__,", ERROR: ",err_text);
               return(INIT_PARAMETERS_INCORRECT);
         }
      }
   
   
      //---
         if(!m_symbol.Name(Symbol())) // sets symbol 
            return(INIT_FAILED);
         RefreshRates();
      //---
         m_trade.SetExpertMagicNumber(m_magic);
         m_trade.SetMarginMode();
         m_trade.SetTypeFillingBySymbol(m_symbol.Name());
      //---
         m_trade.SetDeviationInPoints(m_slippage);
      //--- tuning for 3 or 5 digits
         int digits_adjust=1;
         if(m_symbol.Digits()==3 || m_symbol.Digits()==5)
            digits_adjust=10;
         m_adjusted_point=m_symbol.Point()*digits_adjust;
      
         ExtStopLoss       = InpStopLoss        * m_adjusted_point;
         ExtTakeProfit     = InpTakeProfit      * m_adjusted_point;
         ExtTrailingStop   = InpTrailingStop    * m_adjusted_point;
         ExtTrailingStep   = InpTrailingStep    * m_adjusted_point;
      //--- check the input parameter "Lots"
         string err_text="";
         if(IntLotOrRisk==lot)
           {
            if(!CheckVolumeValue(InpVolumeLorOrRisk,err_text))
              {
               //--- when testing, we will only output to the log about incorrect input parameters
               if(MQLInfoInteger(MQL_TESTER))
                 {
                  Print(__FUNCTION__,", ERROR: ",err_text);
                  return(INIT_FAILED);
                 }
               else // if the Expert Advisor is run on the chart, tell the user about the error
                 {
                  Alert(__FUNCTION__,", ERROR: ",err_text);
                  return(INIT_PARAMETERS_INCORRECT);
                 }
              }
           }
         else
           {
            if(m_money!=NULL)
               delete m_money;
            m_money=new CMoneyFixedMargin;
            if(m_money!=NULL)
              {
               if(!m_money.Init(GetPointer(m_symbol),Period(),m_symbol.Point()*digits_adjust))
                  return(INIT_FAILED);
               m_money.Percent(InpVolumeLorOrRisk);
              }
            else
              {
               Print(__FUNCTION__,", ERROR: Object CMoneyFixedMargin is NULL");
               return(INIT_FAILED);
              }
           }
           
      
      InitForRSI(); 
      InitForCCI();
      InitForMomemtum();
      InitForATR();
      InitForMA();
      
      int checkhandle = CheckHandleIndicater(handle_iRSI);
      checkhandle = CheckHandleIndicater(handle_iCCI);
      checkhandle = CheckHandleIndicater(handle_iMMT);
      checkhandle = CheckHandleIndicater(handle_iATR);
      checkhandle = CheckHandleIndicater(handle_iATR);
      checkhandle = CheckHandleIndicater(handle_iMA10);
      checkhandle = CheckHandleIndicater(handle_iEMA25);
      
      
      return checkhandle;
  }
  
  
 
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   if(m_money!=NULL)
      delete m_money;
  }



void OnTick()
  {
      int rates = 500;
      MqlTick Tick;
      
      //m_mmt.CheckClosePosition() == 1 ||
      
      if(GetTotalPrfit()) {
      
         for(int i=PositionsTotal()-1; i>=0; i--)                  //---Look at all positions
         {
            if(m_position.Symbol()==Symbol())
            {
               if(m_position.SelectByIndex(i))                       // selects the position by index for further access to its properties
               {
                  m_trade.PositionClose(m_position.Ticket());
               }
            }
         }
      } 
      
      //int xx = m_rsi.CheckClosePosition();
      //if( xx == 1)
      //{
      //   m_trade.PositionClose(_Symbol);
      //}

      double mylot = GetLotToBuy();
      double stop_level = 500;
      
      double closeArry[];
      double openArry[];
      double highArry[];
      double lowArry[];
      
      CopyClose(m_symbol.Name(),PERIOD_CURRENT,0,rates,closeArry);
      ArrayReverse(closeArry,0,rates);
      CopyClose(m_symbol.Name(),PERIOD_CURRENT,0,rates,openArry);
      ArrayReverse(openArry,0,rates);
      CopyClose(m_symbol.Name(),PERIOD_CURRENT,0,rates,highArry);
      ArrayReverse(highArry,0,rates);
      CopyClose(m_symbol.Name(),PERIOD_CURRENT,0,rates,lowArry);
      ArrayReverse(lowArry,0,rates);
 
            Print("Symbol :" +  _Symbol + " TotalPosition of Symbol :" + cPos);
            if( ( m_rsi.CheckIndicate() || 
                  m_doji.CheckIndicate(openArry,highArry,lowArry,lowArry) ||  
                  m_mmt.CheckIndicate() ) && cPos == 0  && m_cci.CheckIndicate() 
                   ) // Open first position
            {
                if(m_trade.PositionOpen(_Symbol,ORDER_TYPE_BUY,mylot,Tick.ask,0.0,m_symbol.Ask()+5000,"")) // open Buy position, volume 1.0 lot 
                  {
                        Print("ôtke");
                  }
                  else
                  {
                         Print("#1 Lam Buy -> false. Result Retcode: ",m_trade.ResultRetcode(),
                              ", description of result: ",m_trade.ResultRetcodeDescription());
                  }
            }
            else
            {
               Print("#1 Lam Buy -> No satisfy condition");
            }
            if(cPos < 10 && cPos > 0)
            {
               if( (m_doji.CheckIndicate(openArry,highArry,lowArry,lowArry) || m_rsi.CheckIndicate() ||  m_mmt.CheckIndicate()) 
                  &&CheckPosToOpen() 
                  && m_cci.CheckIndicate()
                  && m_mmt.CheckIndicateDayTime()
                  ){ // just use for second position && m_MA.CheckIndicateEMA25(openArry,highArry,lowArry,lowArry)
                    if(m_trade.PositionOpen(_Symbol,ORDER_TYPE_BUY,mylot,Tick.ask,0.0,m_symbol.Ask()+5000,"")) // open Buy position, volume 1.0 lot 
                     {
                           Print("#1 Lam Buy -> true. Result Retcode: ",m_trade.ResultRetcode(),
                                 ", description of result: ",m_trade.ResultRetcodeDescription());
                     }
                     else
                     {
                            Print("#1 Lam Buy -> false. Result Retcode: ",m_trade.ResultRetcode(),
                                 ", description of result: ",m_trade.ResultRetcodeDescription());
                     }
               }
               else
               {
                  Print("#1 Lam Buy -> No satisfy condition");
               }
           }
  }
  
  //&& !m_cci.CheckIndicate()


