<cfcomponent  displayname="SystemService" output="false">

	<cffunction name="init" description="init method" access="public" displayname="init" output="false" returntype="SystemService">
	<!--- persistent variable to store trades and results --->
		<cfreturn this/>
	</cffunction>
	
	<cffunction name="RunSystem" description="" access="public" displayname="" output="false" returntype="Any">
		<!--- System.cfc contains the system rules for entering and exiting long and short trades 
		if the entry or exit is a stop limit the system will indicate if the stop was hit 
		the exit can also be a profit target 
		the exit can also be a slowing of momentum --->
		<!--- todo: system must use raw data for trades --->
		<!--- todo: system must loop over symbol set and return trades and entry/exit points --->
		<!--- todo: system must use pivot points to enter trades  --->
		<!--- todo: add stop adjustment for open trades  --->
		<!--- todo: add alert if near support/resistance levels --->
		<!--- todo: add fib analysis  --->
		<!--- todo: add trading range - results of last trades  --->
		<!--- todo: add notes capablity --->
		<!--- todo: use yahoo or google data stream --->
		<cfargument name="SystemToRun" required="true"  />
		<cfargument name="qryData" required="true" />
		<cfargument name="ReportType" required="false" default="backtest" hint="backtest,watchlist"/>
		<cfset var local = structnew() />
		<cfset local.results = session.objects.systemRunner.testSystem(SystemToRun:arguments.systemtorun,qryData:arguments.qryData) >
		<cfset local.ReportHeaders = "Date,Trade,Entry Price,New High Reversal,New High Breakout,R1 Breakout, R2 Breakout,RSIStatus,CCIStatus">
		<cfset local.ReportMethods = "Date,HKGoLong,EntryPrice,NewHighReversal,NewHighBreakout,R1Breakout1Day,R2Breakout1Day,RSIStatus,CCIStatus">
		<cfset session.objects.Output.BeanReport(local) />
		<cfset local.ReportHeaders = "Date,Entry Trade,Exit Trade,Entry Price,Entry Date,Exit Price,Exit Date,Profit/loss,Net Profit/Loss">
		<cfset local.ReportMethods = "Date,HKGoLong,HKCloseLong,EntryPrice,EntryDate,ExitPrice,ExitDate,ProfitLoss,NetProfitLoss">
		<cfset session.objects.Output.TradeReport(local) />
		<cfset local.ReportHeaders = "Date,High,Low,Price,High,Difference">
		<cfset local.ReportMethods = "Date,NewLocalHigh,NewLocalLow,HKHigh">
		<cfset session.objects.Output.HiLoReport(local) />
		<!--- this belongs in a watchlist runner method --->
		<cfif arguments.ReportType EQ "watchlist">
		<!---- loop over the BeanArray and get open and close setups and entries/exits--->
		<!--- loop backwards over the array and find the last two entry/exit setups 
		delete everything above them and do a structappend to the watchlist struct
		once all symbols have been run, fire off the Watchlist Report and send it the watchlist struct--->
		</cfif>
		<cfreturn local.results />
	</cffunction>
	
	
</cfcomponent>