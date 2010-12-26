<cfcomponent output="false">

	<cffunction name="init" description="init method" access="public" displayname="init" output="false" returntype="SystemService">
	<!--- persistent variable to store trades and results --->
		<cfreturn this/>
	</cffunction>
	
	<cffunction name="RunSystem" description="" access="public" displayname="" output="false" returntype="Any">
		<!--- System.cfc contains the system rules for entering and exiting long and short trades 
		if the entry or exit is a stop limit the system will indicate if the stop was hit --->
		<cfargument name="SystemToRun" required="true"  />
		<cfargument name="qryData" required="true" />
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
		<cfreturn local.results />
	</cffunction>
	
	
</cfcomponent>