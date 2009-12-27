Analyses selected stocks and gives buy/sell orders.
1. get data from yahoo 
2. calculate historical technical indicators for data
2. analyse data accoding to rules
3. issue buy sell orders and limits and alert settings 
4. dont get carried away, just make version .01 work 

future enhancements:
store data in Derby
get associated options data
give historical performance
use unit tests
display output of technical alerts
heiken-ashi on new tab
use ta-lib  in future for now just write indicator functions

cf stox automatic web-based stock trader
pulls data from yahoo, quotemedia
accepts imports from stockfetcher 
automatically determines entry/exit points 
implements maxwell's demon trading system

RSI greater than 60
consecutive up trend 
catch drop using stop order 
automatic stop loss

get some symbols to follow (manual for v.1)
get historical data (manual for v.1)
analyse entry points
run backtest (manual for v.1, excel, TorS)


program:
dispay data in datagrid


based on readings give alert prices, entry and exit stops 

diff = ma(10) - ema(5)
diff2 = diff - diff on day ago
diff3 slope diff
diff4 diff3 - diff 3 one day ago 

smoothed DI based system

1 get di indicator working 
2 write out xml data
3 add di to datagrid, chart
4 add csv output
5 add system test

    