//--- Basic interface for describing animals
class IOrder
  {
    bool BuyOrderByindicate(const ENUM_POSITION_TYPE pos_type,double stop_level,double mylot);
    bool SellOrderByindicate();
    bool CloseOrderByindicate();
    int CheckRefreshRate();
    bool CheckIndicate();
  };
//+------------------------------------------------------------------+
//|  The CCat class is inherited from the IAnimal interface          |
//+------------------------------------------------------------------+