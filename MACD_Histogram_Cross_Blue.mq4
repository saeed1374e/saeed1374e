
//+------------------------------------------------------------------+
//|                                     MACD_Histogram_Cross_Blue.mq4 |
//|   نمایش فلش آبی هنگام کراس سیگنال و هیستوگرام MACD (3,6,2)       |
//+------------------------------------------------------------------+
#property indicator_chart_window
#property indicator_buffers 2
#property indicator_color1 Blue
#property indicator_color2 Blue

extern int FastEMA = 3;
extern int SlowEMA = 6;
extern int SignalSMA = 2;
extern int ArrowCodeUp = 233;   // فلش رو به بالا
extern int ArrowCodeDown = 234; // فلش رو به پایین
extern double ArrowDistance = 10;

double arrowUp[];
double arrowDown[];

int OnInit()
{
    SetIndexBuffer(0, arrowUp);
    SetIndexStyle(0, DRAW_ARROW);
    SetIndexArrow(0, ArrowCodeUp);

    SetIndexBuffer(1, arrowDown);
    SetIndexStyle(1, DRAW_ARROW);
    SetIndexArrow(1, ArrowCodeDown);

    IndicatorShortName("MACD Histogram Cross Signal (Blue Arrows)");

    return(INIT_SUCCEEDED);
}

int start()
{
    int counted_bars = IndicatorCounted();
    int limit = Bars - counted_bars - 1;

    for (int i = limit; i >= 1; i--)
    {
        double macdNow = iMACD(NULL, 0, FastEMA, SlowEMA, SignalSMA, PRICE_CLOSE, MODE_MAIN, i);
        double signalNow = iMACD(NULL, 0, FastEMA, SlowEMA, SignalSMA, PRICE_CLOSE, MODE_SIGNAL, i);
        double histNow = macdNow - signalNow;

        double macdPrev = iMACD(NULL, 0, FastEMA, SlowEMA, SignalSMA, PRICE_CLOSE, MODE_MAIN, i + 1);
        double signalPrev = iMACD(NULL, 0, FastEMA, SlowEMA, SignalSMA, PRICE_CLOSE, MODE_SIGNAL, i + 1);
        double histPrev = macdPrev - signalPrev;

        // کراس صعودی: از منفی به مثبت
        if (histPrev < 0 && histNow > 0)
            arrowUp[i] = Low[i] - ArrowDistance * Point;
        else
            arrowUp[i] = EMPTY_VALUE;

        // کراس نزولی: از مثبت به منفی
        if (histPrev > 0 && histNow < 0)
            arrowDown[i] = High[i] + ArrowDistance * Point;
        else
            arrowDown[i] = EMPTY_VALUE;
    }

    return(0);
}
