/***************************************************************************************************************************
 * MIT License
 *
 * @copyright (c) - 2021 - Thomas Carr
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
 * documentation files (the "Software"), to deal in the Software without restriction, including without limitation the
 * rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit
 * persons to whom the Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all copies or substantial portions of the
 * Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
 * WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
 * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
 * OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 **************************************************************************************************************************/
#property copyright "MIT License - 2021 - Thomas Carr"
#property version   "1.00"
#property description ""
#property strict

/***************************************************************************************************************************
 * INCLUDES
 **************************************************************************************************************************/

/***************************************************************************************************************************
 * TYPE DEFINITIONS
 **************************************************************************************************************************/
enum SL_MODE
{
    MA_LOW,
    MA_MED,
    MA_HIGH
};

/***************************************************************************************************************************
 * VARIABLE DEFINITION
 **************************************************************************************************************************/
double THRESHOLD_RSI_MIDPOINT = 50;

/***************************************************************************************************************************
 * EXTERNAL VARIABLE DEFINITION
 **************************************************************************************************************************/
input string          TIME_BASE_SEPERATOR = "* * * Time Base Seperator * * *";
input ENUM_TIMEFRAMES TIME_BASE = PERIOD_M1;
input int             SESSION_TIME_START = 6;
input int             SESSION_TIME_STOP = 19;

input string MOVING_AVERAGE_SEPERATOR = "* * * Moving Average Seperator * * *";
input int    MA_PERIOD_SHORT = 21;
input int    MA_PERIOD_MEDIUM = 50;
input int    MA_PERIOD_LONG = 200;
input double MIN_MA_DISTANCE_PIPS = 10;

input string RSI_SEPERATOR = "* * * RSI Seperator * * *";
input int    RSI_PERIOD = 14;
input bool   RSI_PROCESS_CROSSOVER = false;
input int    RSI_AVERAGED_PERIOD = 15;

input string RANGING_SEPERATOR = "* * * Ranging Seperator * * *";
input bool   RANGING_CHECK = true;
input int    RANGING_NO_SAMPLES = 5;

input string TRAILING_SL_SEPERATOR = "* * * Trailing SL Seperator * * *";
input bool   MODIFY_ENABLED = true;
input double TRADING_TRAILING_STOP = 15;
input bool   TRADING_REMOVE_TP_ON_TRAILING_STOP = true;

input string  TRADING_SEPERATOR = "* * * Trading Seperator * * *";
input int     MAX_ORDERS = 5;
input double  TRADING_TP_MULTIPLIER = 1.5;
input bool    TRADING_LOT_SIZE_FIXED = false;
input double  TRADING_LOT_SIZE_FIXED_VALUE = 0.01;
input double  TRADING_PERCENTAGE_FREE_MARGIN = 1;
input string  TRADING_COMMENT = "MA Fractals RSI Trader EA";
input int     TRADING_MAGIC_NUMBER = 123;
input SL_MODE STOP_LOSS_MODE = MA_LOW;

input string DEBUG_SEPERATOR = "* * * Debug Seperator * * *";
input bool   DEBUG_PRINT = true;

/***************************************************************************************************************************
 * @brief     Init Function
 **************************************************************************************************************************/
int OnInit()
{
    return(INIT_SUCCEEDED);
}



/***************************************************************************************************************************
 * @brief     DeInit Function
 **************************************************************************************************************************/
void OnDeinit(const int reason)
{

}



/***************************************************************************************************************************
 * @brief     Interface to MA function
 **************************************************************************************************************************/
double GetMA(int samplePeriod, int offset)
{
    return iMA(Symbol(),
               TIME_BASE,
               samplePeriod,
               0,
               MODE_SMMA,
               PRICE_CLOSE,
               offset);
}



/***************************************************************************************************************************
 * @brief     Interface to Fractals function
 **************************************************************************************************************************/
double GetFractals(int mode, int offset)
{
    return iFractals(Symbol(),
                     TIME_BASE,
                     mode,
                     offset);
}



/***************************************************************************************************************************
 * @brief     Interface to RSI function
 **************************************************************************************************************************/
double GetRSI(int offset)
{
    return iRSI(Symbol(),
                TIME_BASE,
                RSI_PERIOD,
                PRICE_CLOSE,
                offset);
}



/***************************************************************************************************************************
 * @brief     Interface to Close function
 **************************************************************************************************************************/
double GetClose(int offset)
{
    return iClose(Symbol(),
                  TIME_BASE,
                  offset);
}



/***************************************************************************************************************************
 * @brief     Interface to High function
 **************************************************************************************************************************/
double GetHigh(int offset)
{
    return iHigh(Symbol(),
                 TIME_BASE,
                 offset);
}



/***************************************************************************************************************************
 * @brief    Interface to Low function
 **************************************************************************************************************************/
double GetLow(int offset)
{
    return iLow(Symbol(),
                TIME_BASE,
                offset);
}



/***************************************************************************************************************************
 * @brief     Interface to Open function
 **************************************************************************************************************************/
double GetOpen(int offset)
{
    return iOpen(Symbol(),
                 TIME_BASE,
                 offset);
}



/***************************************************************************************************************************
 * @brief     Get number of orders open that match the magic number
 **************************************************************************************************************************/
int CalculateCurrentOrders(void)
{
    int orders = 0;

    for (int i = 0; i < OrdersTotal(); ++i)
    {
        if (false == OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
        {
            break;
        }

        if (TRADING_MAGIC_NUMBER == OrderMagicNumber())
        {
            if (  (OP_BUY == OrderType())
               || (OP_SELL == OrderType()))
            {
                ++orders;
            }
        }
    }

    return orders;
}



/***************************************************************************************************************************
 * @brief     Check for a buy entry
 **************************************************************************************************************************/
bool CheckBuy(double EMAShort,
              double EMAMedium,
              double EMALong,
              double closeValue,
              double fractalsLow,
              double fractalsHigh,
              double RSI)
{
    bool retVal = false;

    if (  EMAShort > EMAMedium
       && EMAMedium > EMALong
       && closeValue > EMAShort
       && fractalsLow > 0
       && 0 == fractalsHigh
       && RSI > 50)
    {
        retVal = true;
    }

    return retVal;
}



/***************************************************************************************************************************
 * @brief     Check for a sell entry
 **************************************************************************************************************************/
bool CheckSell(double EMAShort,
               double EMAMedium,
               double EMALong,
               double closeValue,
               double fractalsLow,
               double fractalsHigh,
               double RSI)
{
    bool retVal = false;

    if (  EMAShort < EMAMedium
       && EMAMedium < EMALong
       && closeValue < EMAShort
       && fractalsHigh > 0
       && 0 == fractalsLow
       && RSI < 50)
    {
        retVal = true;
    }

    return retVal;
}



/***************************************************************************************************************************
 * @brief     Get lots to bet from percentage margin
 **************************************************************************************************************************/
double GetLotsToBet(double stopLoss)
{
    double retVal = TRADING_LOT_SIZE_FIXED_VALUE;
    double minLot = MarketInfo(Symbol(), MODE_MINLOT);
    double maxLot = MarketInfo(Symbol(), MODE_MAXLOT);

    if (!TRADING_LOT_SIZE_FIXED)
    {
        double free = AccountFreeMargin();
        double tickValue = MarketInfo(Symbol(), MODE_TICKVALUE);
        double riskPerTrade = NormalizeDouble((TRADING_PERCENTAGE_FREE_MARGIN / 100.0), 2);
        retVal = NormalizeDouble((free * riskPerTrade) / ((stopLoss * MathPow(10.0, Digits)) * tickValue), 2);

        if (0 == retVal)
        {
            retVal = minLot;
        }
        else if (retVal > maxLot)
        {
            retVal = maxLot;
        }
    }

    return retVal;
}



/***************************************************************************************************************************
 * @brief     Manage entry into a long
 **************************************************************************************************************************/
void EnterBuy(double MAValue)
{
    int    res;
    double stopLoss = MAValue;
    double stopLevelPoints = MarketInfo(Symbol(), MODE_STOPLEVEL) * Point;
    double takeProfit = 0;
    double lots = 0;

    if (Ask - stopLevelPoints < stopLoss)
    {
        stopLoss = Ask - stopLevelPoints;
    }

    takeProfit = Ask + ((Ask - stopLoss) * TRADING_TP_MULTIPLIER);
    lots = GetLotsToBet(stopLoss);

    if (DEBUG_PRINT)
    {
        printf("BUY: tp: %f, sl: %f, ask: %f, EMA: %f, slpoint: %f, lots: %f",
               takeProfit,
               stopLoss,
               Ask,
               MAValue,
               stopLevelPoints,
               lots);
    }

    res = OrderSend(Symbol(),
                    OP_BUY,
                    lots,
                    Ask,
                    3,
                    stopLoss,
                    takeProfit,
                    TRADING_COMMENT,
                    TRADING_MAGIC_NUMBER,
                    0,
                    Blue);
}



/***************************************************************************************************************************
 * @brief     Manage entry into a short
 **************************************************************************************************************************/
void EnterSell(double MAValue)
{
    int    res;
    double stopLoss = MAValue;
    double stopLevelPoints = MarketInfo(Symbol(), MODE_STOPLEVEL) * Point;
    double takeProfit = 0;
    double lots = 0;

    if (Bid + stopLevelPoints > stopLoss)
    {
        stopLoss = Bid + stopLevelPoints;
    }

    takeProfit = Bid - ((stopLoss - Bid) * TRADING_TP_MULTIPLIER);
    lots = GetLotsToBet(stopLoss);

    if (DEBUG_PRINT)
    {
        printf("SELL: tp: %f, sl: %f, bid: %f, EMA: %f, SLpoints: %f, lots: %f",
               takeProfit,
               stopLoss,
               Bid,
               MAValue,
               stopLevelPoints,
               lots);
    }

    res = OrderSend(Symbol(),
                    OP_BUY,
                    lots,
                    Ask,
                    3,
                    stopLoss,
                    takeProfit,
                    TRADING_COMMENT,
                    TRADING_MAGIC_NUMBER,
                    0,
                    Blue);
}



/***************************************************************************************************************************
 * @brief     Check if the market is ranging
 **************************************************************************************************************************/
bool CheckRangingMarket(int direction)
{
    bool retVal = false;

    double MAShort = 0;
    double MAMedium = 0;
    double MALong = 0;
    double high = 0;
    double low = 0;

    for (int i = 0; i < RANGING_NO_SAMPLES; ++i)
    {
        MAShort = GetMA(MA_PERIOD_SHORT, i + 1);
        MAMedium = GetMA(MA_PERIOD_MEDIUM, i + 1);
        MALong = GetMA(MA_PERIOD_LONG, i + 1);
        high = GetHigh(i + 1);
        low = GetLow(i + 1);

        if (1 == direction)
        {
            if (  MAShort < MAMedium
               || MAMedium < MALong
               || low < MALong)
            {
                retVal = true;
                break;
            }
        }

        if (-1 == direction)
        {
            if (  MAShort > MAMedium
               || MAMedium > MALong
               || high > MALong)
            {
                retVal = true;
                break;
            }
        }
    }

    return retVal;
}



/***************************************************************************************************************************
 * @brief    Get the average of previous RSI values
 **************************************************************************************************************************/
double GetRSIAverage(void)
{
    double total = 0;
    double currentRSI = 0;
    int    direction = 0;

    for (int i = 0; i < RSI_AVERAGED_PERIOD; ++i)
    {
        currentRSI = GetRSI(i + 1);
        total += currentRSI;

        if (currentRSI > THRESHOLD_RSI_MIDPOINT)
        {
            if (-1 == direction)
            {
                if (RSI_PROCESS_CROSSOVER)
                {
                    return 0;
                }
            }
            else
            {
                direction = 1;
            }
        }
        else if (currentRSI < THRESHOLD_RSI_MIDPOINT)
        {
            if (1 == direction)
            {
                if (RSI_PROCESS_CROSSOVER)
                {
                    return 0;
                }
            }
            else
            {
                direction = -1;
            }
        }
    }

    return total / RSI_AVERAGED_PERIOD;
}



/***************************************************************************************************************************
 * @brief     Manage the check and entry into a trade
 **************************************************************************************************************************/
void ManageEntry(void)
{
    double MAShort = GetMA(MA_PERIOD_SHORT, 1);
    double MAMedium = GetMA(MA_PERIOD_MEDIUM, 1);
    double MALong = GetMA(MA_PERIOD_LONG, 1);
    double closeValue = GetClose(1);
    double fractalsLow = GetFractals(MODE_LOW, 2);
    double fractalsHigh = GetFractals(MODE_HIGH, 2);
    double RSIValue = GetRSIAverage();

    if (  MIN_MA_DISTANCE_PIPS > 0
       && MathAbs(MALong - MAShort) < (MIN_MA_DISTANCE_PIPS * 10 * Point))
    {
        return;
    }

    if (0 == RSIValue)
    {
        return;
    }

    if (CheckBuy(MAShort,
                 MAMedium,
                 MALong,
                 closeValue,
                 fractalsLow,
                 fractalsHigh,
                 RSIValue))
    {
        if (  RANGING_CHECK
           && CheckRangingMarket(1))
        {
            return;
        }

        switch (STOP_LOSS_MODE)
        {
            case MA_LOW:
            {
                EnterBuy(MAShort);
                break;
            }
            case MA_MED:
            {
                EnterBuy(MAMedium);
                break;
            }
            case MA_HIGH:
            {
                EnterBuy(MALong);
                break;
            }
        }

        return;
    }

    if (CheckSell(MAShort,
                  MAMedium,
                  MALong,
                  closeValue,
                  fractalsLow,
                  fractalsHigh,
                  RSIValue))
    {
        if (  RANGING_CHECK
           && CheckRangingMarket(-1))
        {
            return;
        }

        switch (STOP_LOSS_MODE)
        {
            case MA_LOW:
            {
                EnterSell(MAShort);
                break;
            }
            case MA_MED:
            {
                EnterSell(MAMedium);
                break;
            }
            case MA_HIGH:
            {
                EnterSell(MALong);
                break;
            }
        }

        return;
    }

}



/***************************************************************************************************************************
 * @brief     Manage a modify of an order
 **************************************************************************************************************************/
void ManageModify(void)
{
    for (int i = 0; i < OrdersTotal(); ++i)
    {
        if (false == OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
        {
            break;
        }

        if (  (TRADING_MAGIC_NUMBER != OrderMagicNumber())
           || (OrderSymbol() != Symbol()))
        {
            continue;
        }

        if (  OP_BUY == OrderType()
           && TRADING_TRAILING_STOP > 0)
        {
            if (  (Bid - OrderOpenPrice()) > (Point * TRADING_TRAILING_STOP)
               && (Bid - MarketInfo(Symbol(), MODE_STOPLEVEL) > Bid - OrderOpenPrice()))
            {
                if (OrderStopLoss() < (Bid - (Point * TRADING_TRAILING_STOP)))
                {
                    if (TRADING_REMOVE_TP_ON_TRAILING_STOP)
                    {
                        if (!OrderModify(OrderTicket(),
                                         OrderOpenPrice(),
                                         Bid - (Point * TRADING_TRAILING_STOP),
                                         0,
                                         0,
                                         Green))
                        {
                            Print("OrderModify error ", GetLastError());
                        }
                    }
                    else
                    {
                        if (!OrderModify(OrderTicket(),
                                         OrderOpenPrice(),
                                         Bid - (Point * TRADING_TRAILING_STOP),
                                         OrderTakeProfit(),
                                         0,
                                         Green))
                        {
                            Print("OrderModify error ", GetLastError());
                        }
                    }

                    return;
                }
            }

            break;
        }

        if (OP_SELL == OrderType())
        {
            if (TRADING_TRAILING_STOP > 0)
            {
                if (  (OrderOpenPrice() - Ask) > (Point * TRADING_TRAILING_STOP)
                   && (Ask + MarketInfo(Symbol(), MODE_STOPLEVEL) < OrderOpenPrice() - Ask))
                {
                    if (  (OrderStopLoss() > (Ask + (Point * TRADING_TRAILING_STOP)))
                       || (0 == OrderStopLoss()))
                    {
                        if (TRADING_REMOVE_TP_ON_TRAILING_STOP)
                        {
                            if (!OrderModify(OrderTicket(),
                                             OrderOpenPrice(),
                                             Ask + (Point * TRADING_TRAILING_STOP),
                                             0,
                                             0,
                                             Red))
                            {
                                Print("OrderModify error ", GetLastError());
                            }
                        }
                        else
                        {
                            if (!OrderModify(OrderTicket(),
                                             OrderOpenPrice(),
                                             Ask + (Point * TRADING_TRAILING_STOP),
                                             OrderTakeProfit(),
                                             0,
                                             Red))
                            {
                                Print("OrderModify error ", GetLastError());
                            }
                        }

                        return;
                    }
                }

                break;
            }
        }
    }
}



/***************************************************************************************************************************
 * @brief    Manage the tick
 **************************************************************************************************************************/
void OnTick()
{
    static double lastCandleHigh = 0;
    static double lastCandleLow = 0;
    static double lastCandleOpen = 0;
    static double lastCandleClose = 0;
    double        currentCandleHigh = GetHigh(1);
    double        currentCandleLow = GetLow(1);
    double        currentCandleOpen = GetOpen(1);
    double        currentCandleClose = GetClose(1);
    int           currentOrders = CalculateCurrentOrders();
    datetime      currentTime = TimeGMT();

    if (  TimeHour(currentTime) > SESSION_TIME_START
       && TimeHour(currentTime) < SESSION_TIME_STOP)
    {
        // Only check entry on a new candle, regardless of timeframe
        if (  lastCandleHigh != currentCandleHigh
           && lastCandleLow != currentCandleLow
           && lastCandleOpen != currentCandleOpen
           && lastCandleClose != currentCandleClose)
        {
            lastCandleHigh = currentCandleHigh;
            lastCandleLow = currentCandleLow;
            lastCandleOpen = currentCandleOpen;
            lastCandleClose = currentCandleClose;

            if (currentOrders < MAX_ORDERS)
            {
                ManageEntry();
            }
        }
    }

    if (  MODIFY_ENABLED
       && currentOrders > 0)
    {
        ManageModify();
    }
}
