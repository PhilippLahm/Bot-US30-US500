#include <Lam/Indicaters.mqh>
#include <Lam/Function.mqh>

class CMA : public IOrder
  {
public:
                     CMA(void) { Print("OpenRSI"); }
                    ~CMA(void) { Print("CLoseRSI");  } 
                    
                    
                     //bool          BuyOrderByindicate(const ENUM_POSITION_TYPE pos_type,double stop_level) const;
                     //bool          SellOrderByindicate(void) const;
                     //bool          CloseOrderByindicate(void) const;
                     //int           CheckRefreshRate(void) const;   
                     //bool          CheckRSI(void) const;
   
   
   int CMA::CheckRefreshRate(void)
   {
      if(!RefreshRates() || !m_symbol.Refresh())
            return 1 ;
      else return 0;
   }
   
   
   int CMA::CheckClosePosition(void){
        int val = 10; // 10: normal ; 1: close ; 2 : no order 
        int tmp = 0;
      return val;
   }
   
   
   
   // just use for timeframe day
   bool CMA::CheckIndicateMA10(const double &open[],const double &high[],const double &low[],const double &close[]) {
     bool flag = true;
     
     double cma_1   = iMA10Get(1);
     double cma_0   = iMA10Get(0);
      

      return flag;
   }
   
   
   bool CMA::CheckIndicateEMA25(const double &open[],const double &high[],const double &low[],const double &close[]) {
     bool flag = true;
     
     double cema_1   = iEMA25Get(1);
     if(close[1] < cema_1) flag = false;
      

      return flag;
   }
   double iMA10Get(const int index)
    {
      double aMA[1];
   //--- reset error code 
      ResetLastError();
   //--- fill a part of the iRSI array with values from the indicator buffer that has 0 index 
      if(CopyBuffer(handle_iMA10,0,index,1,aMA)<0)
        {
         //--- if the copying fails, tell the error code 
         PrintFormat("Failed to copy data from the iMA10 indicator, error code %d",GetLastError());
         //--- quit with zero result - it means that the indicator is considered as not calculated 
         return(0.0);
        }
      return(aMA[0]);
    }
    
    
    double iEMA25Get(const int index)
    {
      double aEMA[1];
   //--- reset error code 
      ResetLastError();
   //--- fill a part of the iRSI array with values from the indicator buffer that has 0 index 
      if(CopyBuffer(handle_iEMA25,0,index,1,aEMA)<0)
        {
         //--- if the copying fails, tell the error code 
         PrintFormat("Failed to copy data from the iMA10 indicator, error code %d",GetLastError());
         //--- quit with zero result - it means that the indicator is considered as not calculated 
         return(0.0);
        }
      return ( aEMA[0] );
    }

  
  };
//+------------------------------------------------------------------+
//|  The CDog class is inherited from the IAnimal interface          |
//+------------------------------------------------------------------+
  