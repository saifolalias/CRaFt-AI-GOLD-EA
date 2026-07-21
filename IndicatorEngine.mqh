//+------------------------------------------------------------------+
//|                     IndicatorEngine.mqh                            |
//|                                                                   |
//| Purpose: Read and store indicator values                         |
//|          No decisions are made here                              |
//+------------------------------------------------------------------+

#ifndef INDICATOR_ENGINE_H
#define INDICATOR_ENGINE_H

class IndicatorEngine
{
public:
    // Indicator Buffers
    static double ema20[];
    static double ema50[];
    static double ema200[];
    static double rsi14[];
    static double atr14[];
    
    // Initialize Arrays
    static void Init()
    {
        ArrayResize(ema20, 100);
        ArrayResize(ema50, 100);
        ArrayResize(ema200, 100);
        ArrayResize(rsi14, 100);
        ArrayResize(atr14, 100);
        
        ArraySetAsSeries(ema20, true);
        ArraySetAsSeries(ema50, true);
        ArraySetAsSeries(ema200, true);
        ArraySetAsSeries(rsi14, true);
        ArraySetAsSeries(atr14, true);
    }
    
    // Get EMA20
    static double GetEMA20()
    {
        return ema20[0];
    }
    
    // Get EMA50
    static double GetEMA50()
    {
        return ema50[0];
    }
    
    // Get EMA200
    static double GetEMA200()
    {
        return ema200[0];
    }
    
    // Get RSI14
    static double GetRSI14()
    {
        return rsi14[0];
    }
    
    // Get ATR14
    static double GetATR14()
    {
        return atr14[0];
    }
};

// Static members
double IndicatorEngine::ema20[];
double IndicatorEngine::ema50[];
double IndicatorEngine::ema200[];
double IndicatorEngine::rsi14[];
double IndicatorEngine::atr14[];

#endif
