#include <Lam/Indicaters.mqh>
#include <Lam/Function.mqh>

class CCCI : public IOrder
  {
public:
                     CCCI(void) { Print("OpenRSI"); }
                    ~CCCI(void) { Print("CLoseRSI");  } 
                    
                    
                     //bool          BuyOrderByindicate(const ENUM_POSITION_TYPE pos_type,double stop_level) const;
                     //bool          SellOrderByindicate(void) const;
                     //bool          CloseOrderByindicate(void) const;
                     //int           CheckRefreshRate(void) const;   
                     //bool          CheckRSI(void) const;
   
   
   int CCCI::CheckRefreshRate(void)
   {
      if(!RefreshRates() || !m_symbol.Refresh())
            return 1 ;
      else return 0;
   }
   
   
   int CCCI::CheckClosePosition(void){
        int val = 10; // 10: normal ; 1: close ; 2 : no order 
        int tmp = 0;
      return val;
   }
   
   
   
   // just use for timeframe day
   bool CCCI::CheckIndicate(void) {
     bool flag = true;
      if (tmp >= 0 ){ // just usi RSI for the first position 
         double cci_1   = iCCIGet(1);
         double cci_0   = iCCIGet(0);
         if(cci_1  < -100) flag =  false;
         
          //if(cci_1  < -205 && cci_0> -205)  flag =  false;
         

      }
      return flag;
   }
   double iCCIGet(const int index)
    {
      double CCI[1];
   //--- reset error code 
      ResetLastError();
   //--- fill a part of the iRSI array with values from the indicator buffer that has 0 index 
      if(CopyBuffer(handle_iCCI,0,index,1,CCI)<0)
        {
         //--- if the copying fails, tell the error code 
         PrintFormat("Failed to copy data from the iRSI indicator, error code %d",GetLastError());
         //--- quit with zero result - it means that the indicator is considered as not calculated 
         return(0.0);
        }
      return(CCI[0]);
    }

  
  };
//+------------------------------------------------------------------+
//|  The CDog class is inherited from the IAnimal interface          |
//+------------------------------------------------------------------+
  