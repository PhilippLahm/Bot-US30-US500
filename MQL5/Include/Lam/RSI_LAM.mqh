#include <Lam/Indicaters.mqh>
#include <Lam/Function.mqh>

class CRSI : public IOrder
  {
public:
                     CRSI(void) { Print("OpenRSI"); }
                    ~CRSI(void) { Print("CLoseRSI");  } 
                    
                    
                     //bool          BuyOrderByindicate(const ENUM_POSITION_TYPE pos_type,double stop_level) const;
                     //bool          SellOrderByindicate(void) const;
                     //bool          CloseOrderByindicate(void) const;
                     //int           CheckRefreshRate(void) const;   
                     //bool          CheckRSI(void) const;
   
   
   int CRSI::CheckRefreshRate(void)
   {
      if(!RefreshRates() || !m_symbol.Refresh())
            return 1 ;
      else return 0;
   }
   
   
   int CRSI::CheckClosePosition(void){
        int val = 10; // 10: normal ; 1: close ; 2 : no order 
        double RSI[480];
         if (tmp > 0 ){ // just usi RSI for the first position 
        CopyBuffer(handle_iRSI,0,0,480,RSI);
        for(int j = 0 ; j< 480 ;j++)
        {
            if(RSI[j] < 15)
            {
               val = 1;
               
            }
            break;
        }
         
      }
      return val;
   }
   
   bool CRSI::CheckIndicate(void){
     bool flag = false;
      if (tmp >= 0 ){ // just usi RSI for the first position 
         int tmpCount = 0;
         double rsi_0=iRSIGet(0);
         double rsi_1=iRSIGet(1);
         if(rsi_0 > InpOversold  && rsi_1<InpOversold)
         {
            flag =  true;
         }
         
         
         for(int i = 2 ; i < 20;i++)
         {
             double rsi_n = iRSIGet(i);
             double rsi_n1 = iRSIGet(i+1);
             
            if(rsi_n > InpOversold  && rsi_n1<InpOversold) // kiểm tra 2 lần rsi trong 20 phiên thoa điều kiện - Check 2 condition RSI 
            {
               tmpCount++;
            }
         }
         if( tmpCount > 0 && flag == true) return true;
      }
      return flag;
   }
   double iRSIGet(const int index)
    {
      double RSI[1];
   //--- reset error code 
      ResetLastError();
   //--- fill a part of the iRSI array with values from the indicator buffer that has 0 index 
      if(CopyBuffer(handle_iRSI,0,index,1,RSI)<0)
        {
         //--- if the copying fails, tell the error code 
         PrintFormat("Failed to copy data from the iRSI indicator, error code %d",GetLastError());
         //--- quit with zero result - it means that the indicator is considered as not calculated 
         return(0.0);
        }
      return(RSI[0]);
    }

  
  };
//+------------------------------------------------------------------+
//|  The CDog class is inherited from the IAnimal interface          |
//+------------------------------------------------------------------+
  