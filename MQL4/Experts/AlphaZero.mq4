//+------------------------------------------------------------------+
//|                                                    investpro.mq4 |
//|                                     Copyright 2023, sopotek ,inc |
//|                   https://www.github.com/nguemechieu/investpro   |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023-2024, sopotek ,inc"
#property link      "https://www.github.com/nguemechieu/alphazero"
#property version   "1.01"
#property strict
#property  icon "\\Images\\alphazero.ico"
// Include machine learning libraries if available
//+------------------------------------------------------------------+
// AlphaZero is an expert advisor designed for MetaTrader 4 that utilizes machine learning techniques for trading in the financial markets.
// It is developed by sopotek ,inc and is available for free use under the specified license.
// The expert advisor implements a strategy based on moving averages, risk management, and trade execution.
// Users can customize parameters such as fast and slow moving average periods, risk percentage per trade, stop loss distance, and maximum open orders.
// AlphaZero supports trading on a list of specified symbols or all available symbols, depending on user preferences.
// It includes functions for calculating lot size, checking trade conditions, and placing trades accordingly.
// The expert advisor is designed to provide a robust and adaptable trading solution for MetaTrader 4 users.
// For more information and updates, visit the project's GitHub repository at https://www.github.com/nguemechieu/alphazero.
// This expert advisor is compatible with MetaTrader 4 platforms and can be used for automated trading in forex and other financial markets.


#property  description " AlphaZero is an expert advisor designed for MetaTrader 4 that utilizes machine learning techniques for trading in the financial markets."
#property  description " It is developed by sopotek ,inc and is available for free use under the specified license."
#property  description  "The expert advisor implements a strategy based on moving averages, risk management, and trade execution."
#property  description  "Users can customize parameters such as fast and slow moving average periods, risk percentage per trade, stop loss distance, and maximum open orders."
#property  description " AlphaZero supports trading on a list of specified symbols or all available symbols, depending on user preferences."
#property  description "It includes functions for calculating lot size, checking trade conditions, and placing trades accordingly."
#property  description " The expert advisor is designed to provide a robust and adaptable trading solution for MetaTrader 4 users."
#property  description "For more information and updates, visit the project's GitHub repository at https://www.github.com/nguemechieu/alphazero."
#property  description " This expert advisor is compatible with MetaTrader 4 platforms and can be used for automated trading in forex and other financial markets."

//The "best" trading strategy can vary greatly depending on factors such as the trader's risk tolerance, trading style, time commitment, market conditions, and financial goals. What works well for one trader may not work as effectively for another. However, here are a few popular trading strategies that traders often consider:

enum TradeMode
  {

   TrendFollowing, //TrendFollowing :This strategy involves identifying and following the prevailing market trend. Traders using this strategy aim to enter trades in the direction of the trend, believing that the trend will continue.

   RangeTrading,//Range-bound :markets exhibit price movements within a defined range. Traders using this strategy aim to buy near the bottom of the range and sell near the top, taking advantage of the price oscillations.

   BreakoutTrading,//Breakout traders look for price movements that break through established support or resistance levels. They aim to enter trades as the price breaks out of the range, expecting a continuation of the breakout movement.

   MeanReversion,//MeanReversion:This strategy involves trading based on the belief that prices will revert to their historical averages over time. Traders using mean reversion strategies look for overbought or oversold conditions to enter trades.

   Scalping,//Scalpers: aim to make small profits from frequent trades throughout the day. They focus on short-term price movements and typically hold positions for a very short duration.

   SwingTrading//Swing : traders hold positions for multiple days or weeks, aiming to capture price swings within a larger trend. They often use technical analysis and market sentiment to identify potential entry and exit points.};

  };
//--- input parameters*
input string   License="XQWE-WERR-1223-ALPHAZERO#";

input ENUM_LICENSE_TYPE License_Type=LICENSE_FREE;
input TradeMode trademode=Scalping;
// Define external variables
input double RiskPercent = 1.0; // Risk per trade as a percentage of account balance
input double StopLossPips = 500.0; // Stop loss distance in pips
input int MaxOpenOrders = 1; // Maximum open orders allowed

input bool UseAllSymbol =false;
input bool UseList =false;
input string list ="EURUSD,USDCAD";//symbol list
string symbollist[];

// Define constants
enum TradeType { BUY=1, SELL=2,NONE=0 }; //buy, sell
// PlaceTrade
// Define buffer indices
double MA_Buffer[];

// Initialize variables
double Lots = 0.01; // Initial lot size
double AccountBalances = AccountBalance(); // Get account balance
double RiskAmount = AccountBalances*RiskPercent/100/AccountEquity(); // Calculate risk amount
int OrderTickets = 0; // Order ticket


// Input parameters
input int FastMAPeriod = 5;    // Period for fast moving average
input int SlowMAPeriod = 20;   // Period for slow moving average
input int RSIPeriod = 14;      // Period for RSI indicator
input int OverboughtLevel = 70; // RSI overbought level
input int OversoldLevel = 30;   // RSI oversold level
input double LotSize = 0.1;     // Lot size for trades



//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnTick()
  {
// Set the trade mode


// Execute the selected strategy


   string symbol=Symbol();

   if(UseList==false&& UseAllSymbol==true)
     {
      for(int i = 0; i < SymbolsTotal(false); i++)
        {
         symbol = SymbolName(i, false);
         if(StringFind(symbol, "USD") < 0 && StringFind(symbol, "EUR") < 0)  // Filter symbols if needed
            continue;

         if(!IsTradeAllowed(symbol, Time[0]))
            continue;

         SymbolSelect(symbol, false);

         ExecuteStrategy(trademode,symbol);
        }

     }
   else
      if(UseList==true&& UseAllSymbol==false)
        {




         int size=StringSplit(list,',',symbollist);
         for(int i = 0; i < ArraySize(symbollist); i++)
           {
            symbol = symbollist[i];
            if(StringFind(symbol, "USD") < 0 && StringFind(symbol, "EUR") < 0)  // Filter symbols if needed
               continue;

            if(!IsTradeAllowed(symbol, Time[0]))
               continue;

            SymbolSelect(symbol, false);
            ExecuteStrategy(trademode,symbol);
           }
        }
      else
        {





         SymbolSelect(symbol, false);
         ExecuteStrategy(trademode,symbol);












        }
  }

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
// Define external variables
input int RangePeriod = 10;  // Period for calculating the range
input double RangeThreshold = 0.001;  // Threshold for determining the range

// Define global variables
double RangeHigh[];
double RangeLow[];

// Initialize function

// Define external variables
input int BreakoutPeriod = 20;  // Period for calculating the breakout
input double BreakoutThreshold = 0.001;  // Threshold for determining the breakout

// Define global variables
double BreakoutHigh[];
double BreakoutLow[];
int SignalBuffer[];

// Calculate function
void OnCalculateBreakOut(string sym)
  {
   int rates_total=0;
   double price[];
// Calculate breakout
   for(int i = 0; i < rates_total; i++)
     {
      double high = iHigh(sym, 0, i);
      double low = iLow(sym, 0, i);
      double range = high - low;

      BreakoutHigh[i] = high + BreakoutThreshold * range;
      BreakoutLow[i] = low - BreakoutThreshold * range;
     }

// Generate signals based on breakout conditions
   for(int i = 1; i < rates_total; i++)
     {
      if(price[i] > BreakoutHigh[i - 1])
        {
         SignalBuffer[i] = 1;  // Buy signal
         PlaceTrade(BUY,sym);
        }
      else
         if(price[i] < BreakoutLow[i - 1])
           {
            SignalBuffer[i] = -1;  // Sell signal
            PlaceTrade(SELL,sym);
           }
         else
           {
            SignalBuffer[i] = 0;  // No signal
           }
     }
  }
// Initialize function
void OnInit()
  {



// Define indicator properties TrendFollowing
   IndicatorSetInteger(INDICATOR_DIGITS, 5);
   SetIndexBuffer(0, FastMA_Buffer);
   SetIndexBuffer(1, SlowMA_Buffer);
   SetIndexStyle(0, DRAW_LINE);
   SetIndexStyle(1, DRAW_LINE);
   SetIndexLabel(0, "Fast MA");
   SetIndexLabel(1, "Slow MA");


// Define indicator properties Breakout
   IndicatorSetInteger(INDICATOR_DIGITS, 5);
   SetIndexBuffer(0, BreakoutHigh);
   SetIndexBuffer(1, BreakoutLow);
// SetIndexBuffer(2, SignalBuffer);
   SetIndexStyle(0, DRAW_LINE);
   SetIndexStyle(1, DRAW_LINE);
   SetIndexStyle(2, DRAW_ARROW);
   SetIndexLabel(0, "Breakout High");
   SetIndexLabel(1, "Breakout Low");
   SetIndexLabel(2, "Signal");

// Set indicator colors
   SetIndexBuffer(0, BreakoutHigh);
   SetIndexBuffer(1, BreakoutLow);
//SetIndexBuffer(2, SignalBuffer);
   SetIndexStyle(0, DRAW_LINE);
   SetIndexStyle(1, DRAW_LINE);
   SetIndexStyle(2, DRAW_ARROW);
   SetIndexLabel(0, "Breakout High");
   SetIndexLabel(1, "Breakout Low");
   SetIndexLabel(2, "Signal");


// Define indicator properties
   IndicatorSetInteger(INDICATOR_DIGITS, 5);
   SetIndexBuffer(0, RangeHigh);
   SetIndexBuffer(1, RangeLow);
   SetIndexStyle(0, DRAW_LINE);
   SetIndexStyle(1, DRAW_LINE);
   SetIndexLabel(0, "Range High");
   SetIndexLabel(1, "Range Low");

// Set indicator colors
   SetIndexBuffer(0, RangeHigh);
   SetIndexBuffer(1, RangeLow);
   SetIndexStyle(0, DRAW_LINE);
   SetIndexStyle(1, DRAW_LINE);
   SetIndexLabel(0, "Range High");
   SetIndexLabel(1, "Range Low");


// Define indicator properties
   IndicatorSetInteger(INDICATOR_DIGITS, 5);
   SetIndexBuffer(0, RsiBuffer);
   SetIndexStyle(0, DRAW_LINE);
   SetIndexLabel(0, "RSI");

// Set indicator colors
   SetIndexBuffer(0, RsiBuffer);
   SetIndexStyle(0, DRAW_LINE);
   SetIndexLabel(0, "RSI");









//scalping

// Define indicator properties
   IndicatorSetInteger(INDICATOR_DIGITS, 5);
   SetIndexBuffer(0, FastMA_Buffer);
   SetIndexBuffer(1, SlowMA_Buffer);
   SetIndexStyle(0, DRAW_LINE);
   SetIndexStyle(1, DRAW_LINE);
   SetIndexLabel(0, "Fast MA");
   SetIndexLabel(1, "Slow MA");





// Define indicator properties for Swing Trading
   IndicatorSetInteger(INDICATOR_DIGITS, 5);
   SetIndexBuffer(0, FastMA_Buffer);
   SetIndexBuffer(1, SlowMA_Buffer);
   SetIndexStyle(0, DRAW_LINE);
   SetIndexStyle(1, DRAW_LINE);
   SetIndexLabel(0, "Fast MA");
   SetIndexLabel(1, "Slow MA");








  }
  
 // Define external variables scalping
input int FastMA = 5;  // Fast moving average period
input int SlowMA = 10;  // Slow moving average period
// Define global variables
double FastMA_Buffer[];
double SlowMA_Buffer[];
// Define external variables
input int RsiPeriod = 14;  // Period for calculating RSI

// Define global variables
double RsiBuffer[];

// Calculate function
void OnCalculateMeanReversion(string sym)
  {
   int rates_total=0;
   double price[];
// Calculate RSI
   int start_index = rates_total - RsiPeriod;
   int counted_bars = IndicatorCounted();
   if(counted_bars < 0)
     {
      start_index = RsiPeriod - 1;
     }
   else
      if(counted_bars > 0)
        {
         start_index = rates_total - counted_bars - 1;
        }

   for(int i = start_index; i >= 0; i--)
     {
      RsiBuffer[i] = iRSI(NULL, 0, RsiPeriod, PRICE_CLOSE, i);
     }

// Generate signals based on RSI conditions
   for(int i = 1; i < rates_total; i++)
     {
      if(RsiBuffer[i - 1] > OverboughtLevel && RsiBuffer[i] <= OverboughtLevel)
        {
         // Sell signal when RSI crosses below overbought level
         ObjectCreate("SellSignalArrow", OBJ_ARROW, 0, Time[i], Low[i]);
         ObjectSetInteger(0, "SellSignalArrow", OBJPROP_COLOR, Red);
         ObjectSetInteger(0, "SellSignalArrow", OBJPROP_ARROWCODE, 233);

         PlaceTrade(BUY,sym);
        }
      else
         if(RsiBuffer[i - 1] < OversoldLevel && RsiBuffer[i] >= OversoldLevel)
           {
            // Buy signal when RSI crosses above oversold level
            ObjectCreate("BuySignalArrow", OBJ_ARROW, 0, Time[i], High[i]);
            ObjectSetInteger(0, "BuySignalArrow", OBJPROP_COLOR, Green);
            ObjectSetInteger(0, "BuySignalArrow", OBJPROP_ARROWCODE, 234);
            PlaceTrade(SELL,sym);
           }
     }
  }
// Calculate function
void OnCalculateRange(string sym)
  {
   int rates_total=0;
   double price[];
// Calculate range
   for(int i = 0; i < rates_total; i++)
     {
      double high = iHigh(sym, 0, i);
      double low = iLow(sym, 0, i);
      double range = high - low;

      RangeHigh[i] = high + RangeThreshold * range;
      RangeLow[i] = low - RangeThreshold * range;
     }

// Generate signals based on range boundaries
   for(int i = 1; i < rates_total; i++)
     {
      if(price[i] > RangeHigh[i - 1])
        {
         SignalBuffer[i] = BUY;  // Buy signal
         PlaceTrade(BUY,sym);
        }
      else
         if(price[i] < RangeLow[i - 1])
           {
            SignalBuffer[i] = SELL;  // Sell signal
            PlaceTrade(SELL,sym);

           }
         else
           {
            SignalBuffer[i] = NONE;  // No signal
           }
     }
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
// Your deinitialization code here
ObjectsDeleteAll();

ExpertRemove();
  }

//+------------------------------------------------------------------+
//| ChartEvent function                                              |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
  {
// Your chart event handling code here
  }

//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
void OnTimer()
  {
// Your timer function code here
  }
//+------------------------------------------------------------------+


// Function to calculate lot size based on account balance, risk percentage, stop-loss distance, and pip value
double CalculateLotSize(double accountBalance, double riskPercentage, double stopLossPips, double pipValue)
  {
// Calculate the lot size using the formula
   return (accountBalance * riskPercentage) / (stopLossPips * MarketInfo(Symbol(),MODE_POINT))/1000000;

  }
// Function to calculate pip value

// Place a trade
void PlaceTrade(TradeType tradeType, string sym)
  {
   double EntryPrice = 0.0;
   double StopLossPrice = 0.0;

   int openOrders = OrdersTotal();

   if(openOrders >= MaxOpenOrders)
     {
      Alert("Max open orders reached. Cannot place new trades.");
      return;
     }

   if(tradeType == BUY)
     {
      EntryPrice = MarketInfo(sym, MODE_ASK);
      StopLossPrice = EntryPrice - StopLossPips * MarketInfo(sym, MODE_POINT);
      Lots = CalculateLotSize(AccountBalance(),RiskPercent, StopLossPips,MarketInfo(sym, MODE_ASK));
      OrderTickets = OrderSend(sym, OP_BUYLIMIT, Lots, EntryPrice, 2, StopLossPrice, EntryPrice + StopLossPips *  MarketInfo(sym, MODE_POINT), "Buy Order", 0, 0, Green);
     }
   else
      if(tradeType == SELL)
        {
         EntryPrice =  MarketInfo(sym, MODE_BID);
         StopLossPrice = EntryPrice + StopLossPips *  MarketInfo(sym, MODE_POINT);
         Lots = CalculateLotSize(AccountBalance(),RiskPercent, StopLossPips, MarketInfo(sym, MODE_ASK));
         OrderTickets = OrderSend(sym, OP_SELLLIMIT,Lots, EntryPrice, 2, StopLossPrice, EntryPrice - StopLossPips *  MarketInfo(sym, MODE_POINT), "Sell Order", 0, 0, Red);
        }

   if(OrderTickets > 0)
     {

      Print("Trade placed successfully. Ticket: ", OrderTickets);
     }
   else
     {
      Print("Error placing trade: ", GetLastError());
     }
  }
// Function to execute trading strategies based on the selected mode
void ExecuteStrategy(TradeMode mode,string sym)
  {
   switch(mode)
     {
      case TrendFollowing:
         // Execute Trend Following strategy
         OnCalculateTrendFollowing(sym);
         break;
      case RangeTrading:
         // Execute Range Trading strategy
         OnCalculateRange(sym);
         break;
      case BreakoutTrading:
         // Execute Breakout Trading strategy
         OnCalculateBreakOut(sym);
         break;
      case MeanReversion:
         // Execute Mean Reversion strategy
         OnCalculateMeanReversion(sym);
         break;
      case Scalping:
         // Execute Scalping strategy
         OnCalculateScalping(sym);
         break;
      case SwingTrading:
         // Execute Swing Trading strategy
         OnCalculateSwingTrading(sym);
         break;
      default:
         Print("Invalid trade mode.");
         break;
     }
  }







// Calculate function
void OnCalculateTrendFollowing(string sym)
  {
   int rates_total=0;
   double price[];
// Calculate moving average
   int start_index = rates_total - SlowMA - 1;
   int counted_bars = IndicatorCounted();
   if(counted_bars < 0)
     {
      start_index = SlowMA - 1;
     }
   else
      if(counted_bars > 0)
        {
         start_index = rates_total - counted_bars - 1;
        }
   ArrayResize(FastMA_Buffer,start_index+1,0);
   ArrayResize(SlowMA_Buffer,start_index+1,0);
   for(int i = start_index; i >= 0; i--)
     {
      FastMA_Buffer[i] = iMA(sym, 0, FastMA, 0, MODE_SMA, PRICE_CLOSE, i);
      SlowMA_Buffer[i] = iMA(sym, 0, SlowMA, 0, MODE_SMA, PRICE_CLOSE, i);
     }

// Generate signals based on moving averages crossover
   for(int i = 1; i < rates_total; i++)
     {
      if(FastMA_Buffer[i] > SlowMA_Buffer[i] && FastMA_Buffer[i - 1] <= SlowMA_Buffer[i - 1])
        {
         // Buy signal when fast MA crosses above slow MA
         ObjectCreate("BuySignalArrow", OBJ_ARROW, 0, Time[i], Low[i] - 10 * Point);
         ObjectSetInteger(0, "BuySignalArrow", OBJPROP_COLOR, Green);
         ObjectSetInteger(0, "BuySignalArrow", OBJPROP_ARROWCODE, 233);
         PlaceTrade(BUY,sym);
        }
      else
         if(FastMA_Buffer[i] < SlowMA_Buffer[i] && FastMA_Buffer[i - 1] >= SlowMA_Buffer[i - 1])
           {
            // Sell signal when fast MA crosses below slow MA
            ObjectCreate("SellSignalArrow", OBJ_ARROW, 0, Time[i], High[i] + 10 * Point);
            ObjectSetInteger(0, "SellSignalArrow", OBJPROP_COLOR, Red);
            ObjectSetInteger(0, "SellSignalArrow", OBJPROP_ARROWCODE, 234);
            PlaceTrade(SELL,sym);
           }
     }
  }



// Calculate function
void OnCalculateSwingTrading(string sym)
  {
   int rates_total=0;
   double price[];
// Calculate moving averages
   int start_index = rates_total - SlowMA - 1;
   int counted_bars = IndicatorCounted();
   if(counted_bars < 0)
     {
      start_index = SlowMA - 1;
     }
   else
      if(counted_bars > 0)
        {
         start_index = rates_total - counted_bars - 1;
        }

   for(int i = start_index; i >= 0; i--)
     {
      FastMA_Buffer[i] = iMA(sym, 0, FastMA, 0, MODE_SMA, PRICE_CLOSE, i);
      SlowMA_Buffer[i] = iMA(sym, 0, SlowMA, 0, MODE_SMA, PRICE_CLOSE, i);
     }

// Generate signals based on moving averages crossover
   for(int i = 1; i < rates_total; i++)
     {
      if(FastMA_Buffer[i] > SlowMA_Buffer[i] && FastMA_Buffer[i - 1] <= SlowMA_Buffer[i - 1])
        {
         // Buy signal when fast MA crosses above slow MA
         ObjectCreate("BuySignalArrow", OBJ_ARROW, 0, Time[i], Low[i] - StopLossPips * Point);
         ObjectSetInteger(0, "BuySignalArrow", OBJPROP_COLOR, Green);
         ObjectSetInteger(0, "BuySignalArrow", OBJPROP_ARROWCODE, 233);
         PlaceTrade(BUY,sym);
        }
      else
         if(FastMA_Buffer[i] < SlowMA_Buffer[i] && FastMA_Buffer[i - 1] >= SlowMA_Buffer[i - 1])
           {
            // Sell signal when fast MA crosses below slow MA
            ObjectCreate("SellSignalArrow", OBJ_ARROW, 0, Time[i], High[i] + StopLossPips * Point);
            ObjectSetInteger(0, "SellSignalArrow", OBJPROP_COLOR, Red);
            ObjectSetInteger(0, "SellSignalArrow", OBJPROP_ARROWCODE, 234);
            PlaceTrade(SELL,sym);
           }
     }
  }


// Calculate function
void OnCalculateScalping(string sym)
  {

   int rates_total=0;
   double price[];
// Calculate moving averages
   int start_index = rates_total - SlowMA - 1;
   int counted_bars = IndicatorCounted();
   if(counted_bars < 0)
     {
      start_index = SlowMA - 1;
     }
   else
      if(counted_bars > 0)
        {
         start_index = rates_total - counted_bars - 1;
        }
        
      ArrayResize( FastMA_Buffer,start_index+1,0);

      ArrayResize( SlowMA_Buffer,start_index+1,0);

   for(int i = start_index; i >= 0; i--)
     {
      FastMA_Buffer[i] = iMA(sym, 0, FastMA, 0, MODE_SMA, PRICE_CLOSE, i);
      SlowMA_Buffer[i] = iMA(sym, 0, SlowMA, 0, MODE_SMA, PRICE_CLOSE, i);
     }

// Generate signals based on moving averages crossover
   for(int i = 1; i < rates_total; i++)
     {
      if(FastMA_Buffer[i] > SlowMA_Buffer[i] && FastMA_Buffer[i - 1] <= SlowMA_Buffer[i - 1])
        {
         // Buy signal when fast MA crosses above slow MA
         ObjectCreate("BuySignalArrow", OBJ_ARROW, 0, Time[i], Low[i] - StopLossPips * Point);
         ObjectSetInteger(0, "BuySignalArrow", OBJPROP_COLOR, Green);
         ObjectSetInteger(0, "BuySignalArrow", OBJPROP_ARROWCODE, 233);
         PlaceTrade(BUY,sym);
        }
      else
         if(FastMA_Buffer[i] < SlowMA_Buffer[i] && FastMA_Buffer[i - 1] >= SlowMA_Buffer[i - 1])
           {
            // Sell signal when fast MA crosses below slow MA
            ObjectCreate("SellSignalArrow", OBJ_ARROW, 0, Time[i], High[i] + StopLossPips * Point);
            ObjectSetInteger(0, "SellSignalArrow", OBJPROP_COLOR, Red);
            ObjectSetInteger(0, "SellSignalArrow", OBJPROP_ARROWCODE, 234);
            PlaceTrade(SELL,sym);
           }
     }
  }
