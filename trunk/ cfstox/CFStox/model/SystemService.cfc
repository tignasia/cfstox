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
		<!--- todo: change output component to "report" and move headers and methods into it --->
		<!--- todo: add basic candlesticks  --->
		<!--- todo: use yahoo or google data stream --->

		<cfargument name="SystemToRun" required="true"  />
		<cfargument name="qryData" required="true" />
		<cfargument name="ReportType" required="false" default="backtest" hint="backtest,watchlist"/>
		<cfset var local = structnew() />
		<cfset local.results		= session.objects.systemRunner.testSystem(SystemToRun:arguments.systemtorun,qryData:arguments.qryData) >
		<cfset local.ReportHeaders 	= "Date,Open,High,Low,Close,New High Reversal,New High Breakout,R1 Breakout, R2 Breakout,New Low Reversal,New Low Breakdown,S1 Breakdown, S2 Breakdown,RSIStatus,CCIStatus">
		<cfset local.ReportMethods 	= "Date,HKOpen,HKHigh,HKLow,HKClose,NewHighReversal,NewHighBreakout,R1Breakout1Day,R2Breakout1Day,NewLowReversal,NewLowBreakdown,S1Breakdown1Day,S2Breakdown1Day,RSIStatus,CCIStatus">
		<!--- historical technical data  --->
		<cfset session.objects.Output.BeanReportPDF(local) />
		<cfset session.objects.Output.BeanReportExcel(local) />
		<cfset local.ReportHeaders 	= "Date,Long Entry Trade,Long Exit Trade,Short Entry Trade,Short Exit Trade,Entry Price,Entry Date,Exit Price,Exit Date,Profit/loss,Net Profit/Loss">
		<cfset local.ReportMethods 	= "Date,HKGoLong,HKCloseLong,HKGoShort,HKCloseShort,EntryPrice,EntryDate,ExitPrice,ExitDate,ProfitLoss,NetProfitLoss">
		<cfset session.objects.Output.TradeReport(local) />
		<cfset local.ReportHeaders 	= "Date,High,Low,Price,High,Difference">
		<cfset local.ReportMethods 	= "Date,NewLocalHigh,NewLocalLow,HKHigh">
		<!--- todo:fix <cfset session.objects.Output.HiLoReport(local) /> --->
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
		<!--- todo: this should be a digest of individual trade reports  --->
		<!--- todo: remove hard dates --->
		<cfargument name="SystemToRun" required="false" default="test" />
		<cfargument name="ReportType" required="false" default="backtest" hint="backtest,watchlist"/>
		<cfargument name="TargetDate" required="false" default="#dateformat(now()-1,"mm/dd/yyyy")#" />
		<cfset var local = StructNew() />
		<cfset local = StructAppend(local,SetUpVars() )/>
		<cfloop list="#local.watchlist#" index="i">
			<cfscript>
			local.HAdata 		= GetHAStockData(symbol:"#i#",startdate:"10/1/2010",enddate:"1/1/2011"); 
			local.result 		= session.objects.systemRunner.testSystem(SystemToRun:"test",qryData:local.HAdata); 
			local.tradeArray 	= session.objects.Output.TradeReportBuilder(local.result.beancollection);
			if (local.tradeArray.size() )
			{
				local.arrLatestTrade 		= TrimTrades(local.tradeArray);
				for (x=1; x LTE local.arrLatestTrade.size(); x=x+1)
				ArrayAppend(local.arrAllTrades,local.arrLatestTrade[x]); 
			}
			/*trim the trade array and append the trades to the main array (all trades) */
			</cfscript>
		</cfloop>
		<!--- <cfset local.ReportHeaders = "Date,Trade,Entry Price,New High Reversal,New High Breakout,R1 Breakout, R2 Breakout,RSIStatus,CCIStatus">
		<cfset local.ReportMethods = "Date,HKGoLong,EntryPrice,NewHighReversal,NewHighBreakout,R1Breakout1Day,R2Breakout1Day,RSIStatus,CCIStatus"> --->
		<cfset session.objects.Output.WatchListReportPDF(local.arrAllTrades) />  
		<cfreturn local.arrAllTrades  />
	</cffunction>
	
	<cffunction name="TrimTrades" access="private" output="false" returntype="array" >
	<cfargument name="TradeArray" required="true" >
	<cfset var local = structNew() />
	<cfset local.tradetrim = ArrayNew(1) />
	<cfset local.aLen = arguments.TradeArray.size() />
	
	<cfif arguments.tradearray[local.alen].ShortOpen or arguments.tradearray[local.alen].LongOpen>
		<cfset local.tradetrim[1] = arguments.tradearray[local.alen] />
	<cfelse>
		<cfset local.tradetrim[1] = arguments.tradearray[local.alen-1] />
		<cfset local.tradetrim[2] = arguments.tradearray[local.alen] />
	</cfif>
	 <cfreturn local.tradetrim />
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
	
	<cffunction name="GetHAStockData" description="I return a HA data" access="public" displayname="" output="false" returntype="Any" >
		<cfargument name="symbol" required="true" />
		<cfargument name="startdate" required="false"  default="10/8/2010" />
		<cfargument name="enddate" required="false" default="11/15/2010" />
		<cfscript>
		// todo: I stopped here
		local.data = session.objects.DataService.GetStockData(symbol:"#arguments.symbol#",startdate:"#arguments.startdate#",enddate:"#arguments.enddate#"); 
		local.HAData = session.objects.DataService.GetHAStockData();
		return local.HAData;
		</cfscript>
	</cffunction>
	
	<cffunction name="GetOriginalStockData" description="I return original data" access="public" displayname="" output="false" returntype="Any" >
		<cfscript>
		local.OriginalData = session.objects.DataService.GetOriginalStockData();
		return local.OriginalData;
		</cfscript>
	</cffunction>
	
	<cffunction name="GetHigh" description="I return original data" access="public" displayname="" output="false" returntype="Any" >
		<cfscript>
		local.High = session.objects.DataService.GetHigh();
		return local.High;
		</cfscript>
	</cffunction>
	
	<cffunction name="GetLow" description="I return original data" access="public" displayname="" output="false" returntype="Any" >
		<cfscript>
		local.Low = session.objects.DataService.GetLow();
		return local.Low;
		</cfscript>
	</cffunction>
	<cffunction name="GetTradeBeans" description="" access="public" displayname="" output="false" returntype="Any">
		<cfargument name="qryData" required="true" />
		<cfargument name="rownumber" required="true"   />
		<cfset var local = structNew() />
		<cfset local.DataArray[1] = session.objects.Utility.QrytoStruct(query:arguments.qryData,rownumber:arguments.rownumber - 2 ) />
		<cfset local.DataArray[2] = session.objects.Utility.QrytoStruct(query:arguments.qryData,rownumber:arguments.rownumber -1) />
		<cfset local.DataArray[3] = session.objects.Utility.QrytoStruct(query:arguments.qryData,rownumber:arguments.rownumber) />
		<!---- check the conditions such as new local high/low, bollinger bands, MACD bollinsger band deviations, etc. --->
		<!---- use these conditions to populate the rest of the bean--->
		<cfset local.Tradebeans.TB2 = createObject("component","cfstox.model.TradeBean").init(local.DataArray[1]) /> 
		<cfset local.TradeBeans.TB1 = createObject("component","cfstox.model.TradeBean").init(local.DataArray[2]) /> 
		<cfset local.TradeBeans.TB	 = createObject("component","cfstox.model.TradeBean").init(local.DataArray[3]) /> 
		<cfreturn local.TradeBeans />
	</cffunction>
	
	<cffunction name="SetUpVars" description="" access="private" displayname="" output="false" returntype="Struct">
		<cfscript>
		local.start 				= dateformat(now()-30,"mm/dd/yyyy"); 
		local.strBeanCollection 	= structNew();
		local.arrGoLong			= arrayNew(1);
		local.arrGoShort 		= arrayNew(1);
		local.arrHighBreakout 	= arrayNew(1);
		local.arrOpenTrade 		= arrayNew(1);
		local.arrCloseTrade 		= arrayNew(1) ;
		local.arrLowBreakdown 	= arrayNew(1);
		local.arrMoveStop 		= arrayNew(1);
		/* --- array of structurs of arrays */
		local.arrStrBeanSets 	= arrayNew(1);
		local.arrResults 		= arrayNew(1);
		local.arrAllTrades 		= arrayNew(1);
		/* <cfset local.watchlist = 
		"ABX,ADBE,AEM,AKAM,APA,ATI,AXP,BIIB,BK,BP,CAT,CHK,CMED,CRM,CSCO,CSX,DE,DIA,DIG,DIS,DNDN,EEM,EWZ,FAS,FCX,FFIV,FSLR,FWLT,GLD,GMCR,GME,GS,HD,HK,HON,HOT,HPQ,HSY,IOC,IWM,JOYG,LVS,M,MDY,MEE,MMM,MOS,MS,NFLX,NKE,NSC,NUE,ORCL,PG,POT,QLD,QQQQ,RIG,RIMM,RMBS,RTH"
		> */
		if (NOT session.OBJECTS.controller.diagnostics) {
		/* <cfset local.watchlist = 
		"A,ABX,ADBE,AEM,AKAM,APA,ATI,AXP,BIIB,BK,BP,CAT,CHK,CMED,CRM,CSCO,CSX,DE,DIA,DIG,DIS,DNDN,EEM,EWZ,FAS,FCX,FFIV,FSLR,FWLT,GLD,GMCR,GME,GS,HD,HK,HON,HOT,HPQ,HSY,IOC,IWM,JOYG,LVS,M,MDY,MEE,MMM,MOS,MS,NFLX,NKE,NSC,NUE,ORCL,PG,POT,QLD,QQQQ,RIG,RIMM,RMBS,RTH,SNDK,SPG,SPY,SQNM,UNP,USO,WYNN,XL,XLF"
		> */
		local.watchlist = 
		"A,ABX,ADBE,AEM,AKAM,APA,ATI,AXP,BIIB,BK,BP,CAT,CHK,CMED,CRM,CSCO,CSX,DE,DIA,DIG,DIS,DNDN,EEM,EWZ,FAS,FCX,FFIV,FSLR,FWLT,GLD,GMCR,GME,GS,HD,HK,HON,HOT,HPQ,HSY,IOC,IWM,JOYG,LVS,M,MDY,MEE,MMM,MOS,MS,NFLX,NKE,NSC,NUE,ORCL,PG,POT,QLD,QQQQ,RIG,RIMM,RMBS,RTH,SNDK,SPG,SPY,SQNM,UNP,USO,WYNN,XL,XLF";
		}
		else {
		local.watchlist = "AKAM" ;
		}
		local.x = 1;
		return local;
		</cfscript>
	</cffunction>
	
	<cffunction name="dump" description="" access="private" displayname="" output="true" returntype="void">
		<cfargument name="object" required="true" />
		<cfdump var="#arguments.object#">
			<cfreturn />
	</cffunction>
</cfcomponent>