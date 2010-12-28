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
		<!--- make seperate containers for breakouts, breakdowns, each report category
		loop backwards over the array and find the last two entry/exit setups 
		delete everything above them and do a structappend to the watchlist struct
		once all symbols have been run, fire off the Watchlist Report and send it the watchlist struct--->
		</cfif>
		<cfreturn local.results />
	</cffunction>
	
	<cffunction name="RunWatchlist" description="" access="public" displayname="" output="false" returntype="Any">
		<cfargument name="SystemToRun" required="true"  />
		<cfargument name="ReportType" required="false" default="backtest" hint="backtest,watchlist"/>
		<cfargument name="TargetDate" required="false" default="#dateformat(now()-1,"mm/dd/yyyy")#" />
		<cfset var local = structnew() />
		<!--- <cfset local.arrGoLong = arrayNew(1) />
		<cfset local.arrHighBreakout = arrayNew(1) />
		<cfset local.arrOpenTrade = arrayNew(1) />
		<cfset local.arrCloseTrade = arrayNew(1) />
		<cfset local.arrLowBreakdown = arrayNew(1) />
		<cfset local.arrMoveStop = arrayNew(1) /> --->
		<!--- array of structurss of arrays --->
		<cfset local.arrStrBeanSets = arrayNew(1)/>
		<cfset local.watchlist = 
"A,ABX,ADBE,AEM,AKAM,APA,ATI,AXP,BIIB,BK,BP,CAT,CHK,CMED,CRM,CSCO,CSX"
>
		
		<cfloop list="#local.watchlist#" index="i">
			<cfset local.data = session.objects.DataService.GetStockData(symbol:"#i#",startdate:"7/01/2010",enddate:"12/28/2010") /> 
			<cfset local.data = session.objects.DataService.GetTechnicalIndicators(query:local.data.HKData) />
			<cfset local.results = session.objects.systemRunner.testSystem(SystemToRun:arguments.systemtorun,qryData:local.data) >
			<cfset local.Events = processBeanCollection(beancollection:local.results.BeanCollection,TargetDate:arguments.TargetDate) />
			<cfset local.arrStrBeanSets[local.arrStrBeanSets.size() + 1] = local.events />
		<!--- HKGoLong, NewHighBreakout, OpenTrade, CloseTrade, HKGoShort, NewLowBreakdown, MoveStop --->
		<!--- Loop over BeanArray and move beans to correct category --->
		</cfloop>
		<cfreturn local.arrStrBeanSets />
	</cffunction>
	
	<cffunction name="ProcessBeanCollection" description="" access="private" displayname="" output="false" returntype="Any">
		<cfargument name="TargetDate" required="false" default="#dateformat(now()-1,"mm/dd/yyyy")#" />
		<cfargument name="beancollection" required="true" />
		<cfset var local = structnew() />
		<cfset local.arrGoLong = arrayNew(1) />
		<cfset local.arrGoShort = arrayNew(1) />
		<cfset local.arrHighBreakout = arrayNew(1) />
		<cfset local.arrOpenTrade = arrayNew(1) />
		<cfset local.arrCloseTrade = arrayNew(1) />
		<cfset local.arrLowBreakdown = arrayNew(1) />
		<cfset local.arrMoveStop = arrayNew(1) />
		<cfset local.strBeanCollection = structNew() />
		
		<!--- HKGoLong, NewHighBreakout, OpenTrade, CloseTrade, HKGoShort, NewLowBreakdown, MoveStop --->
		<!--- Loop over BeanArray and move beans to correct category --->
		<!--- add symbol --->
		<cfloop  array="#arguments.beancollection#" index="i">
			<cfif i.get("HKGoLong") AND i.get("Date") EQ dateformat(arguments.targetdate,"mm/dd/yyyy") >
				<cfset local.arrGoLong[local.arrGoLong.Size() +1] = i>
			</cfif>
			<cfif i.get("NewHighBreakout") AND i.get("Date") EQ dateformat(arguments.targetdate,"mm/dd/yyyy")>
				 <cfset local.arrHighBreakout[local.arrHighBreakout.Size() +1] = i>
			</cfif>
			<!--- <cfif i.get("OpenTrade")>
				 <cfset local.arrOpenTrade[local.arrGoLong.Size() +1] = i>
			</cfif>
			<cfif i.get("CloseTrade")>
				 <cfset local.arrCloseTrade[local.arrGoLong.Size() +1] = i>
			</cfif> --->
			<cfif i.get("HKGoShort") AND i.get("Date") EQ dateformat(arguments.targetdate,"mm/dd/yyyy")>
				 <cfset local.arrGoShort[local.arrGoShort +1] = i>
			</cfif>
			<cfif i.get("NewLowBreakdown") AND i.get("Date") EQ dateformat(arguments.targetdate,"mm/dd/yyyy")>
				 <cfset local.arrLowBreakdown[local.arrLowBreakdown +1] = i>
			</cfif>
			<!--- <cfif i.get("MoveStop")>
				 <cfset local.arrGoLong[arrGoLong.Size +1] = i>
			</cfif> --->
		</cfloop>
		<cfset local.strBeanCollection.goLong 		= local.arrGoLong />
		<cfset local.strBeanCollection.HighBreakOut = local.arrHighBreakout />
		<cfset local.strBeanCollection.OpenTrade 	= local.arrOpenTrade>
		<cfset local.strBeanCollection.CloseTrade 	= local.arrCloseTrade>
		<cfset local.strBeanCollection.GoShort		= local.arrGoShort>
		<cfset local.strBeanCollection.GoLong  		= local.arrGoLong>
		<cfreturn local.strBeanCollection />
	</cffunction>
	
</cfcomponent>