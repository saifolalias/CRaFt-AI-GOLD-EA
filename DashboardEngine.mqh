#ifndef DASHBOARD_ENGINE_H
#define DASHBOARD_ENGINE_H

#include "../Utilities/Logger.mqh"
#include "TrendEngine.mqh"
#include "SignalEngine.mqh"

class DashboardEngine
{
private:
    static string dashboardObjectName;
    static int dashboardXOffset;
    static int dashboardYOffset;

public:
    static void Init()
    {
        dashboardObjectName = "CRaFt_Dashboard";
        dashboardXOffset = 20;
        dashboardYOffset = 20;
    }

    static void UpdateBuild002(
        double ema20,
        double ema50,
        double ema200,
        double rsi14,
        double atr14,
        double bid,
        double ask,
        double spread,
        ENUM_TREND trend,
        ENUM_SIGNAL signal,
        const ConfidenceBreakdown &breakdown
    )
    {
        string dashboardText = BuildDashboardText(
            ema20, ema50, ema200, rsi14, atr14, spread, trend, signal, breakdown
        );
        DisplayText(dashboardText);
    }

private:
    static string BuildDashboardText(
        double ema20,
        double ema50,
        double ema200,
        double rsi14,
        double atr14,
        double spread,
        ENUM_TREND trend,
        ENUM_SIGNAL signal,
        const ConfidenceBreakdown &breakdown
    )
    {
        string text = "";
        text += "╔════════════════════════════════════════════════════════════╗\n";
        text += "║        CRaFt AI GOLD EA V4 PRO - BUILD 002              ║\n";
        text += "║           Decision Engine - MONITORING                  ║\n";
        text += "╚════════════════════════════════════════════════════════════╝\n\n";

        text += "STATUS:         ✓ RUNNING\n";
        text += "PAIR:           " + _Symbol + "\n";
        text += "TIMEFRAME:      " + TrendEngine::GetTimeframeString() + "\n\n";

        text += "TREND:          " + TrendEngine::TrendToString(trend) + "\n";
        text += "SIGNAL:         " + SignalEngine::SignalToString(signal) + "\n\n";

        text += "CONFIDENCE:\n";
        text += "  Trend:        " + DoubleToString(breakdown.trendScore, 0) + "/30\n";
        text += "  RSI:          " + DoubleToString(breakdown.rsiScore, 0) + "/20\n";
        text += "  ATR:          " + DoubleToString(breakdown.atrScore, 0) + "/20\n";
        text += "  Spread:       " + DoubleToString(breakdown.spreadScore, 0) + "/15\n";
        text += "  Candle:       " + DoubleToString(breakdown.candleScore, 0) + "/15\n";
        text += "  TOTAL:        " + DoubleToString(breakdown.totalScore, 0) + "/100\n\n";

        text += "INDICATORS:\n";
        text += "  EMA20:        " + DoubleToString(ema20, 5) + "\n";
        text += "  EMA50:        " + DoubleToString(ema50, 5) + "\n";
        text += "  EMA200:       " + DoubleToString(ema200, 5) + "\n";
        text += "  RSI14:        " + DoubleToString(rsi14, 2) + "\n";
        text += "  ATR14:        " + DoubleToString(atr14, 5) + "\n";
        text += "  SPREAD:       " + DoubleToString(spread, 1) + "\n\n";

        text += "REASON:         " + breakdown.reason + "\n";
        return text;
    }

    static void DisplayText(string text)
    {
        ObjectDelete(0, dashboardObjectName);
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

string DashboardEngine::dashboardObjectName = "";
int DashboardEngine::dashboardXOffset = 0;
int DashboardEngine::dashboardYOffset = 0;

#endif
