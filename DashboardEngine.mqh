//+------------------------------------------------------------------+
//|                    DashboardEngine.mqh                             |
//|                                                                   |
//| Purpose: Display dashboard on chart showing EA status             |
//|          Shows trend, signal, confidence, and reasons             |
//+------------------------------------------------------------------+

#ifndef DASHBOARD_ENGINE_H
#define DASHBOARD_ENGINE_H

#include "../Utilities/Logger.mqh"
#include "TrendEngine.mqh"

class DashboardEngine
{
private:
    static string dashboardObjectName;
    static int dashboardXOffset;
    static int dashboardYOffset;
    
public:
    // Initialize Dashboard
    static void Init()
    {
        dashboardObjectName = "CRaFt_Dashboard";
        dashboardXOffset = 20;
        dashboardYOffset = 20;
    }
    
    // Update Dashboard Display
    static void Update(double ema20, double ema50, double ema200, 
                      double rsi14, double atr14, 
                      double bid, double ask, double spread,
                      ENUM_TREND trend)
    {
        // Build Dashboard Text
        string dashboardText = BuildDashboardText(ema20, ema50, ema200, rsi14, atr14, spread, trend);
        
        // Display on Chart
        DisplayText(dashboardText);
    }
    
private:
    // Build Dashboard Text
    static string BuildDashboardText(double ema20, double ema50, double ema200, 
                                     double rsi14, double atr14, double spread,
                                     ENUM_TREND trend)
    {
        string text = "";
        
        text += "╔════════════════════════════════════════════════════════════╗\n";
        text += "║        CRaFt AI GOLD EA V4 PRO - BUILD 001              ║\n";
        text += "║           Framework Phase - MONITORING                  ║\n";
        text += "╚════════════════════════════════════════════════════════════╝\n";
        text += "\n";
        
        text += "STATUS:         ✓ RUNNING\n";
        text += "PAIR:           " + _Symbol + "\n";
        text += "TIMEFRAME:      " + TrendEngine::GetTimeframeString() + "\n";
        text += "\n";
        
        text += "═══════════════════════════════════════════════════════════\n";
        text += "TREND:          " + TrendEngine::TrendToString(trend) + "\n";
        text += "═══════════════════════════════════════════════════════════\n";
        text += "\n";
        
        text += "INDICATORS:\n";
        text += "  EMA20:        " + DoubleToString(ema20, 5) + "\n";
        text += "  EMA50:        " + DoubleToString(ema50, 5) + "\n";
        text += "  EMA200:       " + DoubleToString(ema200, 5) + "\n";
        text += "  RSI14:        " + DoubleToString(rsi14, 2) + "\n";
        text += "  ATR14:        " + DoubleToString(atr14, 5) + "\n";
        text += "  SPREAD:       " + DoubleToString(spread, 1) + " pips\n";
        text += "\n";
        
        // Status checks
        text += "CHECKS:\n";
        text += CheckEMAAlignment(ema20, ema50, ema200);
        text += CheckRSI(rsi14);
        text += CheckATR(atr14);
        text += CheckSpread(spread);
        text += "\n";
        
        text += "MESSAGE:        Build 001 - Framework Phase\n";
        text += "                Monitoring Indicators...\n";
        
        return text;
    }
    
    // Check EMA Alignment
    static string CheckEMAAlignment(double ema20, double ema50, double ema200)
    {
        if(ema20 > ema50 && ema50 > ema200)
            return "  ✓ EMA Aligned (BUY)\n";
        if(ema20 < ema50 && ema50 < ema200)
            return "  ✓ EMA Aligned (SELL)\n";
        return "  ✗ EMA Not Aligned\n";
    }
    
    // Check RSI
    static string CheckRSI(double rsi14)
    {
        if(rsi14 > 30 && rsi14 < 70)
            return "  ✓ RSI Normal\n";
        if(rsi14 <= 30)
            return "  ⚠ RSI Oversold\n";
        return "  ⚠ RSI Overbought\n";
    }
    
    // Check ATR
    static string CheckATR(double atr14)
    {
        if(atr14 > 5.0)
            return "  ✓ ATR Good\n";
        return "  ✗ ATR Low\n";
    }
    
    // Check Spread
    static string CheckSpread(double spread)
    {
        if(spread < 20)
            return "  ✓ Spread OK\n";
        return "  ⚠ Spread High\n";
    }
    
    // Display Text on Chart
    static void DisplayText(string text)
    {
        // Delete old object
        ObjectDelete(0, dashboardObjectName);
        
        // Create new text object
        ObjectCreate(0, dashboardObjectName, OBJ_LABEL, 0, 0, 0);
        ObjectSetString(0, dashboardObjectName, OBJPROP_TEXT, text);
        ObjectSetInteger(0, dashboardObjectName, OBJPROP_XDISTANCE, dashboardXOffset);
        ObjectSetInteger(0, dashboardObjectName, OBJPROP_YDISTANCE, dashboardYOffset);
        ObjectSetInteger(0, dashboardObjectName, OBJPROP_CORNER, CORNER_LEFT_UPPER);
        ObjectSetInteger(0, dashboardObjectName, OBJPROP_FONTSIZE, 8);
        ObjectSetString(0, dashboardObjectName, OBJPROP_FONT, "Courier");
        ObjectSetInteger(0, dashboardObjectName, OBJPROP_COLOR, clrWhite);
        
        ChartRedraw();
    }
};

// Static members
string DashboardEngine::dashboardObjectName = "";
int DashboardEngine::dashboardXOffset = 0;
int DashboardEngine::dashboardYOffset = 0;

#endif
