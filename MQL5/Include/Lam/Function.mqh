//+------------------------------------------------------------------+
//|                                                        Valid.mqh |
//|                                  Copyright 2021, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Ltd."
#property link      "https://www.mql5.com"

#include <Lam/MyLibrary.mqh>



  
//+------------------------------------------------------------------+
//| Get lot to open volume                              |
//+------------------------------------------------------------------+
int mulProfit = 40;  // Total Lot * mulProfit => when total profit equal 
int cPos = 0;
double firstLot = 2;
double secondLot = 1;
double  maxLost = 0.0;
double GetLotToBuy(){
     double mylot = 0.0;
     tmp  = 0; // use to count number Ticket
     cPos = 0;
     ArrayResize(tick,0,0);
     for(int k=PositionsTotal()-1;k>=0;k--) // returns the number of open positions
     {
         if(m_position.SelectByIndex(k)){
             if(m_position.Symbol()==m_symbol.Name())
              {   
                if(m_position.PositionType()==POSITION_TYPE_BUY)
                {
                        ArrayResize(tick,tmp+1);
                        tick[tmp] = m_position.Ticket();
                        tmp++;  
                }
              }
         }
     }
   cPos = ArraySize(tick);
   if(cPos == 0) {
      return  firstLot;
   }
   else
   {
      if(cPos == 1)
      {
        if(m_position.SelectByTicket(tick[0])){
                  double volume = m_position.Volume();
                  mylot = volume + secondLot;
         }
      }
      else
      {
         mylot =0.0;
         for(int i =0 ; i<2;i++){
             if(m_position.SelectByTicket(tick[i])){
                  double volume = m_position.Volume();
                  mylot += volume;
             }
         }
      }
   }
   return mylot;
   
}
//+------------------------------------------------------------------+
//| Check Position to open volume                                 |
//+------------------------------------------------------------------+
bool CheckPosToOpen()
{  
   if(cPos > 0)
   {
        
        if(cPos == 1){ // đã có sẵn 1 lệnh => vào lệnh 2
          if(m_position.SelectByTicket(tick[0])){
               double cur = m_position.PriceCurrent();
               double open1 = m_position.PriceOpen();
               if((open1-cur) >= 30 ){
                  return true;
               }
          }
        }
        else if(cPos == 2) // đã có sẵn 2 lệnh => vào lệnh 3
        {
            if(m_position.SelectByTicket(tick[0])){
               double cur = m_position.PriceCurrent();
               double open1 = m_position.PriceOpen();
               if((open1 - cur) >= 70 ){
                  return true;
               }
            }
        }
       else
       {
         double open[3];
         double cur = 0;
          for(int i =0 ; i<3;i++){
             if(m_position.SelectByTicket(tick[i])){
                 open[i] = m_position.PriceOpen();
                 cur = m_position.PriceCurrent();
             }
          }
          if( (open[0] - cur) >= ((open[2] - open[1]) + (open[1]- open[0])) && (open[0] - cur) > 100 ){
               return true;
          }
       }
   }
   else return false;
    
   return false;
}  



//+------------------------------------------------------------------+
//| Refreshes the symbol quotes data                                 |
//+------------------------------------------------------------------+
bool RefreshRates(void)
{
//--- refresh rates
   if(!m_symbol.RefreshRates())
     {
      Print("RefreshRates error");
      return(false);
     }
//--- protection against the return value of "zero"
   if(m_symbol.Ask()==0 || m_symbol.Bid()==0)
      return(false);
//---
   return(true);
}


//+------------------------------------------------------------------+
//| Get Profit                                                      |
//+------------------------------------------------------------------+
bool GetTotalPrfit()
  {
     double profit = 0.0;
     double volume =0.0;
     

     string strMaxLost = "Show MaxLost :";
   
      
   
      // Create text object with given name
   
      ObjectCreate(strMaxLost, OBJ_LABEL, 0, 0, 0, 0);
      // Set pixel co-ordinates from top left corner (use OBJPROP_CORNER to set a different corner)

   
     
     
     for(int k=PositionsTotal()-1;k>=0;k--) // returns the number of open positions
     {
         if(m_position.SelectByIndex(k)){
            if(m_position.Symbol()==m_symbol.Name()){
               
                  profit += m_position.Profit();
                  volume += m_position.Volume();
               
            }
         }
     }
     if(profit < maxLost )
     {
         maxLost = profit;
         strMaxLost = strMaxLost +  ": " +DoubleToString(maxLost);
               ObjectSetString(0,strMaxLost,OBJPROP_FONT,"Wingdings");
               //--- define font size
               ObjectSetInteger(0,strMaxLost,OBJPROP_FONTSIZE,10);
               // Set text, font, and colour for object
               Comment("\n \n " + strMaxLost);
     }
     if(profit > 0 && profit >= (volume *mulProfit) ) return true;
     
   return false;
  }
//+------------------------------------------------------------------+
//| Lot Check                                                        |
//+------------------------------------------------------------------+
double LotCheck(double lots)
  {
//--- calculate maximum volume
   double volume=NormalizeDouble(lots,2);
   double stepvol=m_symbol.LotsStep();
   if(stepvol>0.0)
      volume=stepvol*MathFloor(volume/stepvol);
//---
   double minvol=m_symbol.LotsMin();
   if(volume<minvol)
      volume=0.0;
//---
   double maxvol=m_symbol.LotsMax();
   if(volume>maxvol)
      volume=maxvol;
   return(volume);
  }
//+------------------------------------------------------------------+
//| Trailing                                                         |
//|   InpTrailingStop: min distance from price to Stop Loss          |
//+------------------------------------------------------------------+
void Trailing(const double stop_level,int &count_buys,int &count_sells)
  {
   count_buys=0;
   count_sells=0;
/*
     Buying is done at the Ask price                 |  Selling is done at the Bid price
   ------------------------------------------------|----------------------------------
   TakeProfit        >= Bid                        |  TakeProfit        <= Ask
   StopLoss          <= Bid	                     |  StopLoss          >= Ask
   TakeProfit - Bid  >= SYMBOL_TRADE_STOPS_LEVEL   |  Ask - TakeProfit  >= SYMBOL_TRADE_STOPS_LEVEL
   Bid - StopLoss    >= SYMBOL_TRADE_STOPS_LEVEL   |  StopLoss - Ask    >= SYMBOL_TRADE_STOPS_LEVEL
*/
//if(InpTrailingStop==0)
//   return;
   for(int i=PositionsTotal()-1;i>=0;i--) // returns the number of open positions
      if(m_position.SelectByIndex(i))
         if(m_position.Symbol()==m_symbol.Name() && m_position.Magic()==m_magic)
           {
            if(m_position.PositionType()==POSITION_TYPE_BUY)
              {
               count_buys++;
               if(m_position.PriceCurrent()-m_position.PriceOpen()>ExtTrailingStop+ExtTrailingStep)
                  if(m_position.StopLoss()<m_position.PriceCurrent()-(ExtTrailingStop+ExtTrailingStep))
                     if(ExtTrailingStop>=stop_level)
                       {
                        if(!m_trade.PositionModify(m_position.Ticket(),
                           m_symbol.NormalizePrice(m_position.PriceCurrent()-ExtTrailingStop),
                           m_position.TakeProfit()))
                           Print("Modify ",m_position.Ticket(),
                                 " Position -> false. Result Retcode: ",m_trade.ResultRetcode(),
                                 ", description of result: ",m_trade.ResultRetcodeDescription());
                        RefreshRates();
                        m_position.SelectByIndex(i);
                        PrintResultModify(m_trade,m_symbol,m_position);
                        continue;
                       }
              }
            else
              {
               count_sells++;
               if(m_position.PriceOpen()-m_position.PriceCurrent()>ExtTrailingStop+ExtTrailingStep)
                  if((m_position.StopLoss()>(m_position.PriceCurrent()+(ExtTrailingStop+ExtTrailingStep))) || 
                     (m_position.StopLoss()==0))
                     if(ExtTrailingStop>=stop_level)
                       {
                        if(!m_trade.PositionModify(m_position.Ticket(),
                           m_symbol.NormalizePrice(m_position.PriceCurrent()+ExtTrailingStop),
                           m_position.TakeProfit()))
                           Print("Modify ",m_position.Ticket(),
                                 " Position -> false. Result Retcode: ",m_trade.ResultRetcode(),
                                 ", description of result: ",m_trade.ResultRetcodeDescription());
                        RefreshRates();
                        m_position.SelectByIndex(i);
                        PrintResultModify(m_trade,m_symbol,m_position);
                       }
              }

           }
  }
  
 bool CheckVolumeValue(double volume,string &error_description)
 {
//--- minimal allowed volume for trade operations
   double min_volume=m_symbol.LotsMin();
   if(volume<min_volume)
     {
      if(TerminalInfoString(TERMINAL_LANGUAGE)=="VietNam")
         error_description=StringFormat("Khối lượng ít hơn mức tối thiểu cho phép SYMBOL_VOLUME_MIN=%.2f",min_volume);
      else
         error_description=StringFormat("Volume is less than the minimal allowed SYMBOL_VOLUME_MIN=%.2f",min_volume);
      return(false);
     }
//--- maximal allowed volume of trade operations
   double max_volume=m_symbol.LotsMax();
   if(volume>max_volume)
     {
      if(TerminalInfoString(TERMINAL_LANGUAGE)=="VietNam")
         error_description=StringFormat("Khối lượng lớn hơn mứa tối đa cho phép SYMBOL_VOLUME_MAX=%.2f",max_volume);
      else
         error_description=StringFormat("Volume is greater than the maximal allowed SYMBOL_VOLUME_MAX=%.2f",max_volume);
      return(false);
     }
//--- get minimal step of volume changing
   double volume_step=m_symbol.LotsStep();
   int ratio=(int)MathRound(volume/volume_step);
   if(MathAbs(ratio*volume_step-volume)>0.0000001)
     {
      if(TerminalInfoString(TERMINAL_LANGUAGE)=="VietNam")
         error_description=StringFormat("Khôi lượng không phải là bội số của mức tối thiểu SYMBOL_VOLUME_STEP=%.2f, ближайший правильный объем %.2f",
                                        volume_step,ratio*volume_step);
      else
         error_description=StringFormat("Volume is not a multiple of the minimal step SYMBOL_VOLUME_STEP=%.2f, the closest correct volume is %.2f",
                                        volume_step,ratio*volume_step);
      return(false);
     }
   error_description="Correct volume value";
   return(true);
  }
  
//+------------------------------------------------------------------+
//| TimeControl                                                      |
//+------------------------------------------------------------------+


//+------------------------------------------------------------------+
//| CheckHandleIndicater                                             |
//+------------------------------------------------------------------+
int CheckHandleIndicater(int handleIndicate)
{
    if(handleIndicate==INVALID_HANDLE)
           {
            //--- tell about the failure and output the error code 
            PrintFormat("Failed to create handle of the iRSI indicator for the symbol %s/%s, error code %d",
                        m_symbol.Name(),
                        EnumToString(Period()),
                        GetLastError());
            //--- the indicator is stopped early 
            return(INIT_FAILED);
           }
    return(INIT_SUCCEEDED);
}
 
 //+------------------------------------------------------------------+
//| TimeControl                                                      |
//+------------------------------------------------------------------+
bool TimeControl(void)
  {
   if(!InpTimeControl)
      return(true);
   MqlDateTime STimeCurrent;
   datetime time_current=TimeCurrent();
   if(time_current==D'1970.01.01 00:00')
      return(false);
   TimeToStruct(time_current,STimeCurrent);
   if(InpStartHour<InpEndHour) // intraday time interval
     {
/*
Example:
input uchar    InpStartHour      = 5;        // Start hour
input uchar    InpEndHour        = 10;       // End hour
0  1  2  3  4  5  6  7  8  9  10 11 12 13 14 15 16 17 18 19 20 21 22 23 0  1  2  3  4  5  6  7  8  9  10 11 12 13 14 15
_  _  _  _  _  +  +  +  +  +  _  _  _  _  _  _  _  _  _  _  _  _  _  _  _  _  _  _  _  +  +  +  +  +  _  _  _  _  _  _
*/
      if(STimeCurrent.hour>=InpStartHour && STimeCurrent.hour<InpEndHour)
         return(true);
     }
   else if(InpStartHour>InpEndHour) // time interval with the transition in a day
     {
/*
Example:
input uchar    InpStartHour      = 10;       // Start hour
input uchar    InpEndHour        = 5;        // End hour
0  1  2  3  4  5  6  7  8  9  10 11 12 13 14 15 16 17 18 19 20 21 22 23 0  1  2  3  4  5  6  7  8  9  10 11 12 13 14 15
_  _  _  _  _  _  _  _  _  _  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  +  _  _  _  _  _  +  +  +  +  +  +
*/
      if(STimeCurrent.hour>=InpStartHour || STimeCurrent.hour<InpEndHour)
         return(true);
     }
   else
      return(false);
//---
   return(false);
  }
  
  
  //+------------------------------------------------------------------+
//| Print CTrade result                                              |
//+------------------------------------------------------------------+
void PrintResultTrade(CTrade &trade,CSymbolInfo &symbol)
  {
   Print("File: ",__FILE__,", symbol: ",m_symbol.Name());
   Print("Code of request result: "+IntegerToString(trade.ResultRetcode()));
   Print("code of request result as a string: "+trade.ResultRetcodeDescription());
   Print("Deal ticket: "+IntegerToString(trade.ResultDeal()));
   Print("Order ticket: "+IntegerToString(trade.ResultOrder()));
   Print("Volume of deal or order: "+DoubleToString(trade.ResultVolume(),2));
   Print("Price, confirmed by broker: "+DoubleToString(trade.ResultPrice(),symbol.Digits()));
   Print("Current bid price: "+DoubleToString(symbol.Bid(),symbol.Digits())+" (the requote): "+DoubleToString(trade.ResultBid(),symbol.Digits()));
   Print("Current ask price: "+DoubleToString(symbol.Ask(),symbol.Digits())+" (the requote): "+DoubleToString(trade.ResultAsk(),symbol.Digits()));
   Print("Broker comment: "+trade.ResultComment());
   Print("Freeze Level: "+DoubleToString(m_symbol.FreezeLevel(),2));
   Print("Stops Level: "+DoubleToString(m_symbol.StopsLevel(),2));
  }
//+------------------------------------------------------------------+
//| Print CTrade result                                              |
//+------------------------------------------------------------------+
void PrintResultModify(CTrade &trade,CSymbolInfo &symbol,CPositionInfo &position)
  {
   Print("File: ",__FILE__,", symbol: ",m_symbol.Name());
   Print("Code of request result: "+IntegerToString(trade.ResultRetcode()));
   Print("code of request result as a string: "+trade.ResultRetcodeDescription());
   Print("Deal ticket: "+IntegerToString(trade.ResultDeal()));
   Print("Order ticket: "+IntegerToString(trade.ResultOrder()));
   Print("Volume of deal or order: "+DoubleToString(trade.ResultVolume(),2));
   Print("Price, confirmed by broker: "+DoubleToString(trade.ResultPrice(),symbol.Digits()));
   Print("Current bid price: "+DoubleToString(symbol.Bid(),symbol.Digits())+" (the requote): "+DoubleToString(trade.ResultBid(),symbol.Digits()));
   Print("Current ask price: "+DoubleToString(symbol.Ask(),symbol.Digits())+" (the requote): "+DoubleToString(trade.ResultAsk(),symbol.Digits()));
   Print("Broker comment: "+trade.ResultComment());
   Print("Freeze Level: "+DoubleToString(m_symbol.FreezeLevel(),2));
   Print("Stops Level: "+DoubleToString(m_symbol.StopsLevel(),2));
   Print("Price of position opening: "+DoubleToString(position.PriceOpen(),symbol.Digits()));
   Print("Price of position's Stop Loss: "+DoubleToString(position.StopLoss(),symbol.Digits()));
   Print("Price of position's Take Profit: "+DoubleToString(position.TakeProfit(),symbol.Digits()));
   Print("Current price by position: "+DoubleToString(position.PriceCurrent(),symbol.Digits()));
  }
  
  
  
  void InitForRSI(){

         handle_iRSI=iRSI(m_symbol.Name(),Period(),RSIperiod,PRICE_CLOSE);
  }   
  
  void InitForATR()
  {
         handle_iATR =iATR(m_symbol.Name(),PERIOD_CURRENT,14);
  
  }
  void InitForMomemtum()
  {
         handle_iMMT =iMomentum(m_symbol.Name(),PERIOD_CURRENT,10,PRICE_CLOSE);     
         handle_iDMMT =iMomentum(m_symbol.Name(),PERIOD_D1,10,PRICE_CLOSE);        
  }
   void InitForCCI()
  {
         handle_iCCI = iCCI(m_symbol.Name(),PERIOD_D1,20,PRICE_CLOSE);         
         
  }
  
  void InitForMA()
  {
         handle_iMA10 = iMA(m_symbol.Name(),PERIOD_CURRENT,10,0,MODE_SMA,PRICE_CLOSE);         
         handle_iEMA25 = iMA(m_symbol.Name(),PERIOD_CURRENT,25,0,MODE_EMA,PRICE_CLOSE);   
  }
  
  