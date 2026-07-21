     //+------------------------------------------------------------------+\
|\n//|               SignalEngine.mqh                             |\n//|                                                                  
|\n//|       Purpose: Generate trading signals based on confidence score      
|\n//|          Confidence Score = Weighted combination of indicators   
|\n//+------------------------------------------------------------------+\n\n
#ifndef SIGNAL_ENGINE_H\n#define SIGNAL_ENGINE_H\n\n
#include \"TrendEngine.mqh\"\n\n// Signal States\nenum ENUM_SIGNAL\n{\n    SIGNAL_BUY_READY = 1,     
// Confidence > 95%\n    SIGNAL_SELL_READY = -1,    // Confidence > 95%\n    SIGNAL_WAIT = 0           
// Confidence < 95%\n};\n\n// Confidence Score Components\nstruct ConfidenceBreakdown\n{\n    double trendScore;         
// 0-30 points\n    double rsiScore;            // 0-20 points\n    double atrScore;           
// 0-20 points\n    double spreadScore;         // 0-15 points\n    double candleScore;        
// 0-15 points\n    double totalScore;          // 0-100 points\n    string reason;             
// Why signal was generated\n};\n\nclass SignalEngine\n{\nprivate:\n   

static ENUM_SIGNAL lastSignal;\n    static ConfidenceBreakdown lastBreakdown;\n    \n   
// Thresholds\n    static const double CONFIDENCE_BUY_THRESHOLD = 95.0;    
// 95% for BUY signal\n    static const double CONFIDENCE_SELL_THRESHOLD = 95.0;   
// 95% for SELL signal\n    static const double RSI_OVERSOLD = 30.0;\n   
static const double RSI_OVERBOUGHT = 70.0;\n    static const double RSI_NEUTRAL_LOW = 40.0;\n    
static const double RSI_NEUTRAL_HIGH = 60.0;\n    static const double ATR_MIN_THRESHOLD = 5.0;           
// Minimum ATR for trading\n    static const double SPREAD_MAX = 20.0;                 
// Maximum spread in pips\n    \npublic:\n   
// Get Signal with full breakdown\n    
static ENUM_SIGNAL GetSignal(double ema20, double ema50, double ema200,\n                                 
double rsi14, double atr14, double spread,\n                                 
ENUM_TREND trend, ConfidenceBreakdown &breakdown)\n    {\n        
// Reset breakdown\n        
breakdown.trendScore = 0;\n        
breakdown.rsiScore = 0;\n       
breakdown.atrScore = 0;\n       
breakdown.spreadScore = 0;\n      
breakdown.candleScore = 0;\n       
breakdown.totalScore = 0;\n      
breakdown.reason = \"\";\n        \n        
// Calculate individual scores\n        
breakdown.trendScore = CalculateTrendScore(trend);\n       
breakdown.rsiScore = CalculateRSIScore(rsi14, trend);\n       
breakdown.atrScore = CalculateATRScore(atr14);\n       
breakdown.spreadScore = CalculateSpreadScore(spread);\n        
breakdown.candleScore = CalculateCandleScore(rsi14, trend);  
// Placeholder: RSI-based\n        \n        
// Calculate total confidence score\n        
breakdown.totalScore =
      breakdown.trendScore
    + breakdown.rsiScore
    + breakdown.atrScore
    + breakdown.spreadScore
    + breakdown.candleScore;\n        \n        
// Determine signal based on trend and confidence\n        
ENUM_SIGNAL signal = SIGNAL_WAIT;\n        \n        
if(trend == TREND_BUY && breakdown.totalScore >= CONFIDENCE_BUY_THRESHOLD)\n       
{\n            signal = SIGNAL_BUY_READY;\n           
breakdown.reason = \"BUY SETUP CONFIRMED\";\n           
lastSignal = signal;\n            
lastBreakdown = breakdown;\n            
return signal;\n        }\n        
else if(trend == TREND_SELL && breakdown.totalScore >= CONFIDENCE_SELL_THRESHOLD)\n       
{\n            signal = SIGNAL_SELL_READY;\n            
breakdown.reason = \"SELL SETUP CONFIRMED\";\n           
lastSignal = signal;\n            
lastBreakdown = breakdown;\n            
return signal;\n        }\n        
else if(breakdown.totalScore >= 65.0)\n       
{\n            breakdown.reason = \"CONFIDENCE TOO LOW - WAITING\";\n        }\n        else\n     
{\n          breakdown.reason = GetBlockReason(trend, rsi14, atr14, spread);\n        }\n        \n       
lastSignal = SIGNAL_WAIT;\n        
lastBreakdown = breakdown;\n        
return SIGNAL_WAIT;\n    }\n    \n   
// Get Last Signal\n    
static ENUM_SIGNAL GetLastSignal()\n    {\n        return lastSignal;\n    }\n    \n   
// Get Last Breakdown\n    static ConfidenceBreakdown GetLastBreakdown()\n    {\n        return lastBreakdown;\n    }\n    \n    
// Convert Signal to String\n    
static string SignalToString(ENUM_SIGNAL signal)
{
   switch(signal)
   {
      case SIGNAL_BUY:  return "BUY";
      case SIGNAL_SELL: return "SELL";
      default:          return "WAIT";
   }
}
static string SignalToString(ENUM_SIGNAL signal)\n    {\n       
switch(signal)\n        {\n           
case SIGNAL_BUY_READY:\n                
return \"BUY READY\";\n          
case SIGNAL_SELL_READY:\n                
return \"SELL READY\";\n           
case SIGNAL_WAIT:\n             
return \"WAIT\";\n           
default:\n                
return \"UNKNOWN\";\n        }\n    }\n    \n   
// Get Signal Color\n    static color GetSignalColor(ENUM_SIGNAL signal)\n    {\n        switch(signal)\n        {\n         
case SIGNAL_BUY_READY:\n          
return clrLime;          
// Green for BUY\n          
case SIGNAL_SELL_READY:\n         
return clrRed;           
// Red for SELL\n           
case SIGNAL_WAIT:\n                
return clrGray;         
// Gray for WAIT\n           
default:\n                
return clrWhite;\n        }\n    }\n    \nprivate:\n    
// Calculate Trend Score (0-30 points)\n    static double CalculateTrendScore(ENUM_TREND trend)\n    
{\n        if(trend == TREND_BUY || trend == TREND_SELL)\n        
return 30.0;  // Full points if trend confirmed\n        return 0.0;       
// No points if WAIT trend\n    }\n    \n   
// Calculate RSI Score (0-20 points)\n   
// BUY: RSI < 50 (not overbought)\n    
// SELL: RSI > 50 (not oversold)\n    static double CalculateRSIScore(double rsi14, ENUM_TREND trend)\n   
{\n        double score = 0.0;\n        \n        if(trend == TREND_BUY)\n        {\n            if(rsi14 < RSI_OVERSOLD)\n                score = 0.0;         
// Too oversold\n            else if(rsi14 < RSI_NEUTRAL_LOW)\n                score = 10.0;         
// Oversold area\n            else if(rsi14 < RSI_NEUTRAL_HIGH)\n                score = 20.0;        
// Perfect zone\n            else if(rsi14 < RSI_OVERBOUGHT)\n                score = 15.0;        
// Approaching overbought\n            else\n                score = 0.0;         
// Overbought, don't buy\n        }\n        else if(trend == TREND_SELL)\n        {\n            if(rsi14 > RSI_OVERBOUGHT)\n                score = 0.0;           
// Too overbought\n            else if(rsi14 > RSI_NEUTRAL_HIGH)\n                score = 10.0;          
// Overbought area\n            else if(rsi14 > RSI_NEUTRAL_LOW)\n                score = 20.0;         
// Perfect zone\n            else if(rsi14 > RSI_OVERSOLD)\n                score = 15.0;        
// Approaching oversold\n            else\n                score = 0.0;        
// Oversold, don't sell\n        }\n        \n        return score;\n    }\n    \n    
// Calculate ATR Score (0-20 points)\n    
// Higher ATR = more volatility = good for trading\n    static double CalculateATRScore(double atr14)\n    {\n        if(atr14 < ATR_MIN_THRESHOLD)\n            return 0.0;            
// Too low volatility\n        else if(atr14 < 7.0)\n            return 10.0;             
// Low volatility\n        else if(atr14 < 10.0)\n            return 15.0;            
// Medium volatility\n        else\n            return 20.0;           
// High volatility\n    }\n    \n    
// Calculate Spread Score (0-15 points)\n    
// Lower spread = better for trading\n    static double CalculateSpreadScore(double spread)\n    {\n        if(spread > SPREAD_MAX)\n            return 0.0;             
// Spread too high\n        else if(spread > 15.0)\n            return 5.0;              
// High spread\n        else if(spread > 10.0)\n            return 10.0;           
// Medium spread\n        else\n            return 15.0;             
// Good spread\n    }\n    \n    
// Calculate Candle Score (0-15 points)\n    
// Placeholder: Based on RSI momentum\n    static double CalculateCandleScore(double rsi14, ENUM_TREND trend)\n    {\n       
// For Build 002, we'll use RSI momentum as proxy\n        
// In future builds, we'll analyze actual candle patterns\n        \n        if(trend == TREND_BUY)\n        {\n            
// BUY candle score: RSI rising (above midpoint)\n            if(rsi14 > 50.0)\n                return 15.0;  
// RSI rising in BUY trend\n            else\n                return 7.5;   
// RSI falling in BUY trend\n        }\n        else if(trend == TREND_SELL)\n        {\n            
// SELL candle score: RSI falling (below midpoint)\n            if(rsi14 < 50.0)\n                return 15.0;  
// RSI falling in SELL trend\n            else\n                return 7.5;   
// RSI rising in SELL trend\n        }\n        \n        return 0.0;\n    }\n    \n    
// Get reason for signal block\n    static string GetBlockReason(ENUM_TREND trend, double rsi14, double atr14, double spread)\n    {\n        
string reason = \"\";\n        \n       
if(trend == TREND_WAIT)\n         
reason += \"TREND_NOT_CONFIRMED \";\n        \n       
if(atr14 < ATR_MIN_THRESHOLD)\n           
reason += \"ATR_TOO_LOW \";\n        \n       
if(spread > SPREAD_MAX)\n            
reason += \"SPREAD_TOO_HIGH \";\n        \n        
if(trend == TREND_BUY && rsi14 > RSI_OVERBOUGHT)\n            
reason += \"RSI_OVERBOUGHT \";\n        \n        
if(trend == TREND_SELL && rsi14 < RSI_OVERSOLD)\n            
reason += \"RSI_OVERSOLD \";\n        \n        
if(reason == \"\")\n            
reason = \"CONFIDENCE_SCORE_LOW\";\n        \n       
return reason;\n    }\n};\n\n
// Static members\nENUM_SIGNAL SignalEngine::lastSignal = SIGNAL_WAIT;\nConfidenceBreakdown SignalEngine::lastBreakdown = {0, 0, 0, 0, 0, 0, \"\"};\n\n#endif\n"
