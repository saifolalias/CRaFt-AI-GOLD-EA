//+------------------------------------------------------------------+
//|                      TrendEngine.mqh                               |
//|                                                                   |
//| Purpose: Determine trend based on EMA values                     |
//|          Only 3 states: BUY, SELL, WAIT                          |
//+------------------------------------------------------------------+

#ifndef TREND_ENGINE_H
#define TREND_ENGINE_H

enum ENUM_TREND
{
    TREND_BUY = 1,
    TREND_SELL = -1,
    TREND_WAIT = 0
};

class TrendEngine
{
private:
    static ENUM_TREND lastTrend;
    
public:
    // Get Current Trend
    static ENUM_TREND GetTrend(double ema20, double ema50, double ema200)
    {
        // BUY: EMA20 > EMA50 > EMA200
        if(ema20 > ema50 && ema50 > ema200)
        {
            lastTrend = TREND_BUY;
            return TREND_BUY;
        }
        
        // SELL: EMA20 < EMA50 < EMA200
        if(ema20 < ema50 && ema50 < ema200)
        {
            lastTrend = TREND_SELL;
            return TREND_SELL;
        }
        
        // WAIT: Everything else
        lastTrend = TREND_WAIT;
        return TREND_WAIT;
    }
    
    // Get Last Trend (without recalculating)
    static ENUM_TREND GetLastTrend()
    {
        return lastTrend;
    }
    
    // Convert Trend to String
    static string TrendToString(ENUM_TREND trend)
    {
        switch(trend)
        {
            case TREND_BUY:
                return "BUY";
            case TREND_SELL:
                return "SELL";
            case TREND_WAIT:
                return "WAIT";
            default:
                return "UNKNOWN";
        }
    }
    
    // Get Timeframe String
    static string GetTimeframeString()
    {
        switch(_Period)
        {
            case PERIOD_M1:  return "M1";
            case PERIOD_M5:  return "M5";
            case PERIOD_M15: return "M15";
            case PERIOD_M30: return "M30";
            case PERIOD_H1:  return "H1";
            case PERIOD_H4:  return "H4";
            case PERIOD_D1:  return "D1";
            default:         return "UNKNOWN";
        }
    }
};

// Static member
ENUM_TREND TrendEngine::lastTrend = TREND_WAIT;

#endif
