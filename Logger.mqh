//+------------------------------------------------------------------+
//|                      Logger.mqh                                    |
//|                                                                   |
//| Purpose: Log all EA decisions and events for debugging             |
//+------------------------------------------------------------------+

#ifndef LOGGER_H
#define LOGGER_H

class Logger
{
private:
    static string logFileName;
    static bool isInitialized;
    
public:
    // Initialize Logger
    static void Init(string eaName)
    {
        logFileName = eaName + "_" + TimeToString(TimeCurrent(), TIME_DATE) + ".log";
        isInitialized = true;
        
        Log("═════════════════════════════════════════════════════════════════");
        Log("Logger Initialized: " + eaName);
        Log("Date: " + TimeToString(TimeCurrent(), TIME_DATE | TIME_MINUTES));
        Log("═════════════════════════════════════════════════════════════════");
    }
    
    // Log Message
    static void Log(string message)
    {
        if(!isInitialized)
            return;
        
        // Print to Journal
        Print("[" + TimeToString(TimeCurrent(), TIME_MINUTES | TIME_SECONDS) + "] " + message);
    }
    
    // Log Trend Change
    static void LogTrendChange(string oldTrend, string newTrend)
    {
        Log("TREND CHANGED: " + oldTrend + " -> " + newTrend);
    }
    
    // Get Log File Name
    static string GetLogFileName()
    {
        return logFileName;
    }
};

// Static members
string Logger::logFileName = "";
bool Logger::isInitialized = false;

#endif
