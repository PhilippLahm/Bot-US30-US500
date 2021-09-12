//+------------------------------------------------------------------+
//|                                                    MyLibrary.mqh |
//|                                  Copyright 2021, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Ltd."
#property link      "https://www.mql5.com"


#include <Trade\Trade.mqh>
#include <Trade\PositionInfo.mqh>
#include <Trade\SymbolInfo.mqh>  
#include <Trade\AccountInfo.mqh>
#include <Trade\DealInfo.mqh>
#include <Trade\OrderInfo.mqh>
#include <Expert\Money\MoneyFixedMargin.mqh>
#include <Lam\Data.mqh>

CPositionInfo  m_position;                   // trade position object
CTrade         m_trade;                      // trading object
CSymbolInfo    m_symbol;                     // symbol info object
CAccountInfo   m_account;                    // account info wrapper
CDealInfo      m_deal;                       // deals object
COrderInfo     m_order;                      // pending orders object
CMoneyFixedMargin *m_money;

enum ENUM_LOT_OR_RISK
  {
   lot=0,   // Constant lot
   risk=1,  // Risk in percent for a deal
  };
input bool     OpenBUY           = true;     // Buy positions
input bool     OpenSELL          = true;     // Sell positions
input bool     CloseBySignal     = true;     // CloseBySignal
input ushort   InpStopLoss       = 50;       // Stop Loss, in pips (1.00045-1.00055=1 pips)
input ushort   InpTakeProfit     = 50;       // Take Profit, in pips (1.00045-1.00055=1 pips)
input ushort   InpTrailingStop   = 5;        // Trailing Stop (min distance from price to Stop Loss, in pips
input ushort   InpTrailingStep   = 5;        // Trailing Step, in pips (1.00045-1.00055=1 pips)

input int      RSIperiod         = 14;       // RSIperiod
input double               InpOverbought     =  70;            // Overbought
input double               InpOversold       =  30;     
input color                InpColorBullish   =  clrBlue;       // Bullish color
input color                InpColorBearish   =  clrRed;        // Bearish color
input ENUM_APPLIED_PRICE   InpAppliedPrice   =  PRICE_CLOSE;   // Applied price

input ENUM_LOT_OR_RISK IntLotOrRisk=lot;     // Money management: Lot OR Risk
input double   InpVolumeLorOrRisk= 1.0;      // The value for "Money management"
input ulong    m_magic           = 79506350; // Magic number
input bool     InpTimeControl    = true;     // Use time control
input uchar    InpStartHour      = 10;       // Start hour
input uchar    InpEndHour        = 5;        // End hour
input string   InpTradeComment="RSI EA v2";  // InpTradeComment

double         BufferArrowToUP[];
double         BufferLineToUP[];
double         BufferArrowToDN[];
double         BufferLineToDN[];
double         BufferRSI[];
double         BufferATR[];
//--- global variables
double         overbought;
double         oversold;
string         prefix;
//int            period;

//---
ulong  m_slippage=10;                // slippage
double ExtStopLoss      = 0.0;
double ExtTakeProfit    = 0.0;
double ExtTrailingStop  = 0.0;
double ExtTrailingStep  = 0.0;
int    handle_iRSI;                          // variable for storing the handle of the iRSI indicator
int    handle_iATR;   // variable for storing the handle of the iATR indicator
int    handle_iMMT;       // variable for storing the handle of the Momentum indicator           
double m_adjusted_point;                     // point value adjusted for 3 or 5 points
int    handle_iCCI;  // variable for storing the handle of the iATR indicator
int    handle_iDMMT;  // variable for storing the handle of the Momentum indicator with timeframe 1 day

int handle_iMA10; // variable for storing the handle of the MA10 indicator
int handle_iEMA25;  // variable for storing the handle of the EMA25 indicator

int tmp = 0;
ulong tick[];
