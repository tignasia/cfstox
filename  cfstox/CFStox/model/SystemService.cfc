<cfcomponent  displayname="SystemService" output="true">

	<cffunction name="init" description="init method" access="public" displayname="init" output="true" returntype="SystemService">
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
		<cfset local.ReportHeaders = "Date,Long Entry Trade,Long Exit Trade,Short Entry Trade,Short Exit Trade,Entry Price,Entry Date,Exit Price,Exit Date,Profit/loss,Net Profit/Loss">
		<cfset local.ReportMethods = "Date,HKGoLong,HKCloseLong,HKGoShort,HKCloseShort,EntryPrice,EntryDate,ExitPrice,ExitDate,ProfitLoss,NetProfitLoss">
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
	
	<cffunction name="RunWatchlist" description="" access="public" displayname="" output="true" returntype="Any">
		<cfargument name="SystemToRun" required="true"  />
		<cfargument name="ReportType" required="false" default="backtest" hint="backtest,watchlist"/>
		<cfargument name="TargetDate" required="false" default="#dateformat(now()-1,"mm/dd/yyyy")#" />
		
		<cfset var local = structnew() />
		<cfset local.start = dateformat(now()-30,"mm/dd/yyyy")>
		<cfset local.strBeanCollection = structNew() />
		<cfset local.arrGoLong = arrayNew(1) />
		<cfset local.arrGoShort = arrayNew(1) />
		<cfset local.arrHighBreakout = arrayNew(1) />
		<cfset local.arrOpenTrade = arrayNew(1) />
		<cfset local.arrCloseTrade = arrayNew(1) />
		<cfset local.arrLowBreakdown = arrayNew(1) />
		<cfset local.arrMoveStop = arrayNew(1) />
		
		<!--- <cfset local.arrGoLong = arrayNew(1) />
		<cfset local.arrHighBreakout = arrayNew(1) />
		<cfset local.arrOpenTrade = arrayNew(1) />
		<cfset local.arrCloseTrade = arrayNew(1) />
		<cfset local.arrLowBreakdown = arrayNew(1) />
		<cfset local.arrMoveStop = arrayNew(1) /> --->
		<!--- array of structurss of arrays --->
		<cfset local.arrStrBeanSets = arrayNew(1)/>
		<cfset local.arrResults = arrayNew(1)/>
		<!--- <cfset local.watchlist = 
"ABX,ADBE,AEM,AKAM,APA,ATI,AXP,BIIB,BK,BP,CAT,CHK,CMED,CRM,CSCO,CSX,DE,DIA,DIG,DIS,DNDN,EEM,EWZ,FAS,FCX,FFIV,FSLR,FWLT,GLD,GMCR,GME,GS,HD,HK,HON,HOT,HPQ,HSY,IOC,IWM,JOYG,LVS,M,MDY,MEE,MMM,MOS,MS,NFLX,NKE,NSC,NUE,ORCL,PG,POT,QLD,QQQQ,RIG,RIMM,RMBS,RTH"
> --->

<cfif NOT session.OBJECTS.controller.diagnostics>
<!--- <cfset local.watchlist = 
"A,ABX,ADBE,AEM,AKAM,APA,ATI,AXP,BIIB,BK,BP,CAT,CHK,CMED,CRM,CSCO,CSX,DE,DIA,DIG,DIS,DNDN,EEM,EWZ,FAS,FCX,FFIV,FSLR,FWLT,GLD,GMCR,GME,GS,HD,HK,HON,HOT,HPQ,HSY,IOC,IWM,JOYG,LVS,M,MDY,MEE,MMM,MOS,MS,NFLX,NKE,NSC,NUE,ORCL,PG,POT,QLD,QQQQ,RIG,RIMM,RMBS,RTH,SNDK,SPG,SPY,SQNM,UNP,USO,WYNN,XL,XLF"
> --->
<cfset local.watchlist = 
"A,ABX,ADBE,AEM,AKAM,APA,SPY,XLF"
>
<cfelse>
<cfset local.watchlist = "AKAM" />
</cfif>
		<cfset local.x = 1>
		<cfloop list="#local.watchlist#" index="i">
			<cfset local.data = session.objects.DataService.GetStockData(symbol:"#i#",startdate:"#local.start#",enddate:"12/28/2010") /> 
			<cfset local.data = session.objects.DataService.GetTechnicalIndicators(query:local.data.HKData) />
			<cfset local.results = session.objects.systemRunner.testSystem(SystemToRun:arguments.systemtorun,qryData:local.data) >
			
			<cfset local.Eventsx = processBeanCollection(beancollection:local.results.BeanCollection,TargetDate:arguments.TargetDate) />
			<!--- <cftry>
			<cfdump label="from systemservice:processing symbol " var="#i#">
			<cfdump label="from systemservice:local.eventsx " var="#local.Eventsx#">
			
			<cfset local.sym = local.eventsx["golong"].Get("Symbol") />
			 ---><!--- <cfdump label="from systemservice:local.eventsx symbol " var="#local.sym#">
			<cfcatch type="any">
				<cfdump label="in cfcatch sym:#i#" var="#local.eventsx#">
			</cfcatch>
			</cftry> --->
			<cfset local.arrStrBeanSets[local.x] = local.eventsx />
			<cfset local.x = local.x + 1>
		<!--- HKGoLong, NewHighBreakout, OpenTrade, CloseTrade, HKGoShort, NewLowBreakdown, MoveStop --->
		<!--- Loop over BeanArray and move beans to correct category --->
		</cfloop>
		<!--- <cfdump label="from systemservice out of loop : eventgsx final" var="#local.Eventsx#">
		<cfdump label="from systemservice out of loop : local.arrStrBeanSets " var="#local.arrStrBeanSets#">
		<cfabort>
		 --->
		<!--- <cfloop array="#local.arrStrBeanSets#" index="j">
			<cfif j["golong"].size()  >
				<cfset local.arrGoLong[x] = j["golong"]>
				<cfset x = x + 1>
			</cfif>
			<cfif j["HighBreakOut"].size() >
				 <cfset local.arrHighBreakout[y] = j["highbreakOut"]>
				 <cfset y = y+1>
			</cfif> 
			<!--- <cfif i.get("OpenTrade")>
				 <cfset local.arrOpenTrade[local.arrGoLong.Size() +1] = i>
			</cfif>
			<cfif i.get("CloseTrade")>
				 <cfset local.arrCloseTrade[local.arrGoLong.Size() +1] = i>
			</cfif> --->
			<cfif j["GoShort"].Size() >
				 <cfset local.arrGoShort[local.arrGoShort +1] = j["GoShort"] />
			</cfif>
			<!--- <cfif i["LowBreakdown"].Size() >
				 <cfset local.arrLowBreakdown[local.arrLowBreakdown +1] = i>
			</cfif>  --->
			<!--- <cfif i.get("MoveStop")>
				 <cfset local.arrGoLong[arrGoLong.Size +1] = i>
			</cfif> --->
		
		</cfloop>
		<cfreturn local.arrGoLong />
		<cfset local.strBeanCollection.goLong 		= local.arrGoLong />
		<cfset local.strBeanCollection.HighBreakOut = local.arrHighBreakout />
		<cfset local.strBeanCollection.OpenTrade 	= local.arrOpenTrade>
		<cfset local.strBeanCollection.CloseTrade 	= local.arrCloseTrade>
		<cfset local.strBeanCollection.GoShort		= local.arrGoShort> --->
		<cfset local.ReportHeaders = "Date,Trade,Entry Price,New High Reversal,New High Breakout,R1 Breakout, R2 Breakout,RSIStatus,CCIStatus">
		<cfset local.ReportMethods = "Date,HKGoLong,EntryPrice,NewHighReversal,NewHighBreakout,R1Breakout1Day,R2Breakout1Day,RSIStatus,CCIStatus">
		<cfset session.objects.Output.WatchlistReport(local.arrStrBeanSets ) /> 
		<cfset request.data = local.arrStrBeanSets />   
		<cfreturn local.arrStrBeanSets  />
	</cffunction>
	
	<cffunction name="ProcessBeanCollection" description="" access="private" displayname="" output="true" returntype="Any">
		<cfargument name="TargetDate" required="false" default="#dateformat(now()-1,"mm/dd/yyyy")#" />
		<cfargument name="beancollection" required="true" />
		<cfset var local = structnew() />
		<cfset local.GoLong = "" />
		<cfset local.GoShort = "" />
		<cfset local.HighBreakout = "" />
		<cfset local.OpenTrade = "" />
		<cfset local.CloseTrade = "" />
		<cfset local.LowBreakdown = "" />
		<cfset local.arrMoveStop = "" />
		<cfset local.strBeanCollection1 = structNew() />
		<cfset local.highbreakout = "">
		<cfset local.getlong = ""/>
		<cfset local.getshort = ""/>
		<cfdump  label="in processbean:beancollection "  var="#arguments.beancollection#">
		<!--- HKGoLong, NewHighBreakout, OpenTrade, CloseTrade, HKGoShort, NewLowBreakdown, MoveStop --->
		<!--- Loop over BeanArray and move beans to correct category --->
		<!--- add symbol --->
		<cfset x = 1 >
		<cfset y = 1 >
		<cfset z = 1 >
		<cfloop  array="#arguments.beancollection#" index="m">
			<cfif x EQ 1>
				<cfset local.getlong = m>
			</cfif>
			<cfif 
			<!---m.get("Date") GTE dateformat(arguments.targetdate,"mm/dd/yyyy") AND --->
			m.get("HKGoLong")>
				<cfset mvars = m.getmemento() />
				<cfdump  label="in processbean:memvars "  var="#mvars#">
				<cfset local.getlong = m>
			</cfif>
			<cfif x EQ 1>
				 <cfset local.HighBreakout = m />
			</cfif>
			<cfif m.get("NewHighBreakout") AND  m.get("Date") GTE dateformat(arguments.targetdate,"mm/dd/yyyy")>
				 <cfset local.HighBreakout = m />
			</cfif>
			<cfif x EQ 1>
				<cfset local.getshort = m />
			</cfif>
			<cfif 
			<!--- m.get("Date") GTE dateformat(arguments.targetdate,"mm/dd/yyyy") AND  --->
			m.get("HKGoShort")
			>	
				<cfset local.getShort = m />
			</cfif>
			<!--- <cfif i.get("OpenTrade")>
				 <cfset local.arrOpenTrade[local.arrGoLong.Size() +1] = i>
			</cfif>
			<cfif i.get("CloseTrade")>
				 <cfset local.arrCloseTrade[local.arrGoLong.Size() +1] = i>
			</cfif> --->
			<!--- <cfif i.get("HKGoShort") AND i.get("Date") EQ dateformat(arguments.targetdate,"mm/dd/yyyy")>
				 <cfset local.arrGoShort[local.arrGoShort.size() +1] = i>
			</cfif>
			<cfif i.get("NewLowBreakdown") AND i.get("Date") EQ dateformat(arguments.targetdate,"mm/dd/yyyy")>
				 <cfset local.arrLowBreakdown[local.arrLowBreakdown.size() +1] = i>
			</cfif> --->
			<!--- <cfif i.get("MoveStop")>
				 <cfset local.arrGoLong[arrGoLong.Size +1] = i>
			</cfif> --->
			<cfset x = x + 1 />
		</cfloop>
		
		<!--- <cfloop  array="#arguments.beancollection#" index="n" >
			<cfset xdate = m.get("date") />
			<cfdump label="loop over tradebeans:" var="#xdate#" >
		</cfloop> --->
		<cfset local.strBeanCollection1.goLong 		= local.getLong />
		<cfset local.strBeanCollection1.HighBreakOut = local.HighBreakout />
		<cfset local.strBeanCollection1.OpenTrade 	= local.OpenTrade>
		<cfset local.strBeanCollection1.CloseTrade 	= local.CloseTrade>
		<cfset local.strBeanCollection1.GoShort		= local.getShort>
		
		<cfreturn local.strBeanCollection1 />
	</cffunction>
	
</cfcomponent>