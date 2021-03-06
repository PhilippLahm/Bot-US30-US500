#include <Lam/Indicaters.mqh>
#include <Lam/Function.mqh>


input int      MTMperiod         = 10;       // Momemtum
//input double               MTMOverbought     =  102;            // Overbought
//input double               MTMOversell       =  98;   // Oversell
input double               MTMmiddle      =  100;   // Oversell

class CMomentum : public IOrder
  {
public:
                     CMomentum(void) { Print("OpenRSI"); }
                    ~CMomentum(void) { Print("CLoseRSI");  } 
                    
                    
                     //bool          BuyOrderByindicate(const ENUM_POSITION_TYPE pos_type,double stop_level) const;
                     //bool          SellOrderByindicate(void) const;
                     //bool          CloseOrderByindicate(void) const;
                     //int           CheckRefreshRate(void) const;   
                     //bool          CheckRSI(void) const;
   
   
   int CMomentum::CheckRefreshRate(void)
   {
      if(!RefreshRates() || !m_symbol.Refresh())
            return 1 ;
      else return 0;
   }
   
   int CMomentum::CheckClosePosition(void){
        int val = 0; // 0: normal ; 1: close 
      if (tmp > 0 ){ // just usi RSI for the first position 
         double mtm_0=iMTMGet(0);
         if(mtm_0 < 98 )
         {
            val =  1;
         }
      }
      return val;
   }
   
   bool CMomentum::CheckIndicate(void){
        bool flag = false;
      if (tmp >= 0 ){ // just use MOMENTUM for the first position 
         // timeframes : h1
         double mtm_0=iMTMGet(0);
         double mtm_1=iMTMGet(1);

         
         if(mtm_0 > MTMmiddle  && mtm_1< MTMmiddle)
         {
            flag =  true;
         }
         
     

      }
      return flag;
   }
   
   bool CMomentum::CheckIndicateDayTime(void){
        bool flag = false;
        if (tmp >= 0 ){ 
            // timeframes : d1
            double mtm_d0=iDMTMGet(0);
            double mtm_d1=iDMTMGet(1);
            double mtm_d2=iDMTMGet(2);
         
            if( mtm_d0 > 96.5)  flag = true;

         }
      return flag;
   }
   
   double iMTMGet(const int index)
   {
   
       double MMT[];

      //--- reset error code 
         ResetLastError();
      //--- fill a part of the iRSI array with values from the indicator buffer that has 0 index 
         if(CopyBuffer(handle_iMMT,0,index,1,MMT)<0)
           {
            //--- if the copying fails, tell the error code 
            PrintFormat("Failed to copy data from the iMMT indicator, error code %d",GetLastError());
            //--- quit with zero result - it means that the indicator is considered as not calculated 
            return(0.0);
           }
         return(MMT[0]);
  } 
  
  double iDMTMGet(const int index)
   {
   
       double MMT[];

      //--- reset error code 
         ResetLastError();
      //--- fill a part of the momentum array with values from the indicator buffer that has 0 index 
         if(CopyBuffer(handle_iDMMT,0,index,1,MMT)<0)
           {
               //--- if the copying fails, tell the error code 
               PrintFormat("Failed to copy data from the iDMMT indicator, error code %d",GetLastError());
               //--- quit with zero result - it means that the indicator is considered as not calculated 
               return(0.0);
           }
         return(MMT[0]);
  } 

  
};
  