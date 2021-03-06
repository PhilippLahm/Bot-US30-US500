#include <Lam/Indicaters.mqh>
#include <Lam/Function.mqh>

int Doji = 0; // 0: normal ; 1: doji dragon
class CDoji : public IOrder
  {
public:
                     CDoji(void) { Print("OpenRSI"); }
                    ~CDoji(void) { Print("CLoseRSI");  } 
                                   
   
   int CDoji::CheckRefreshRate(void) const
   {
      if(!RefreshRates() || !m_symbol.Refresh())
            return 1 ;
      else return 0;
   }
   
   
   bool CDoji::CheckIndicate(const double &open[],const double &high[],const double &low[],const double &close[]){
      
      if( (high[1] - open[1] < 1) && (high[1] - close[1] < 1) && (high[1] - low[1] > 3.9 ) )
      {
         Doji = 1;
         return true;
      }
      return false;
   }
//   
//   

//   

  
  };
//+------------------------------------------------------------------+
//|  The CDog class is inherited from the IAnimal interface          |
//+------------------------------------------------------------------+
  