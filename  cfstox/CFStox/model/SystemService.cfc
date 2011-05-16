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
		<!--- todo: change output component to "report" and move headers and methods into it --->
		<!--- todo: add basic candlesticks  --->
		<!--- todo: use yahoo or google data stream --->
		<!--- todo: create custom HA bars and custom indicators --->
		<!--- todo: add breakout, real body height and volume data to query --->
		<!--- todo: fix the various getstockdata methods --->
		<cfargument name="SystemName" required="true"  />
		<cfargument name="qryDataHA" required="true" />
		<cfargument name="qryDataOriginal" required="true" />
		<cfargument name="ReportType" required="false" default="backtest" hint="backtest,watchlist"/>
		<cfargument name="summary" required="false" default="true" />
		<cfset var local = structnew() />
		<!--- returns a tradebean with results of system --->
		<cfset local.results = session.objects.systemRunner.testSystem(SystemName:arguments.systemName,qryDataHA:arguments.qryDataHA,qryDataOriginal:arguments.qryDataOriginal,summary:arguments.summary) >
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
		<!--- todo: this should be a digest of individual trade reports  --->
		<!--- todo: remove hard dates --->
		<cfargument name="SystemToRun" required="false" default="test" />
		<cfargument name="ReportType" required="false" default="backtest" hint="backtest,watchlist"/>
		<cfargument name="startdate" required="false" default="#dateformat(now()-60,"mm/dd/yyyy")#">
		<cfargument name="enddate" required="false" default="#dateformat(now(),"mm/dd/yyyy")#">
		<cfargument name="TargetDate" required="false" default="#dateformat(now(),"mm/dd/yyyy")#" />
		<cfargument name="watchlist" required="false" default="1">
		<cfset var local = structNew() />	
		<cfset StructAppend(local,SetUpVars(),"no" ) />
		<!--- todo:wtf --->
			
		<cfswitch  expression="#arguments.watchlist#">
			<cfcase value="1">
				<cfset local.watchlist = local.watchlist1>
			</cfcase>
			<cfcase value="2">
				<cfset local.watchlist = local.watchlist2>
			</cfcase>
			<cfcase value="3">
				<cfset local.watchlist = local.watchlist3>
			</cfcase>
			<cfcase value="4">
				<cfset local.watchlist = local.watchlist4>
			</cfcase>
		</cfswitch>	
		
		<!--- <cfdump var="#arguments#"> --->
		
		<cfloop list="#local.watchlist#" index="i">
			<cfscript>
			local.HAdata 		= GetHAStockDataGoogle(symbol:"#i#",startdate:"#arguments.startdate#",enddate:"#arguments.enddate#"); 
			local.result 		= session.objects.systemRunner.testSystem(SystemToRun:"test",qryData:local.HAdata); 
			// this now produces two reports, a trade report and an activity report
			local.tradeArray 	= session.objects.ReportService.TradeReportBuilder(local.result.beancollection);
			
			if (local.tradeArray.size() )
			{
				
				local.arrLatestTrade 	= TrimTrades(local.tradeArray);
				for (x=1; x LTE local.arrLatestTrade.size(); x=x+1)
					ArrayAppend(local.arrAllTrades,local.arrLatestTrade[x]); 		
				if (local.arrLatestTrade.size() EQ 2 ){
					for (y=1; y LTE local.arrLatestTrade.size(); y=y+1)
					ArrayAppend(local.arrClosedTrades,local.arrLatestTrade[y]); 			
					}
				else {
					ArrayAppend(local.arrNewTrades,local.arrLatestTrade[1]); 		
					}
			
			}
			/*trim the trade array and append the trades to the main array (all trades) */
			</cfscript>
		</cfloop>
		<!--- <cfset local.ReportHeaders = "Date,Trade,Entry Price,New High Reversal,New High Breakout,R1 Breakout, R2 Breakout,RSIStatus,CCIStatus">
		<cfset local.ReportMethods = "Date,HKGoLong,EntryPrice,NewHighReversal,NewHighBreakout,R1Breakout1Day,R2Breakout1Day,RSIStatus,CCIStatus"> --->
		<cfset session.objects.ReportService.WatchListReportPDF(local.arrNewTrades,arguments.watchlist) />  
		<cfset request.beanarray = local.arrNewTrades />
		<cfreturn local.arrAllTrades  />
	</cffunction>
	
	<cffunction name="RunBreakoutReport" description="" access="public" displayname="" output="false" returntype="Any">
		<cfargument name="Symbol" required="true" />
		<cfargument name="startdate" required="false" default="#dateformat(now()-60,"mm/dd/yyyy")#">
		<cfargument name="enddate" required="false" default="#dateformat(now(),"mm/dd/yyyy")#">
		<cfscript>
		var local = structNew(); 	
		local.data 		= session.objects.DataService.GetStockDataGoogle(symbol:"#arguments.symbol#",startdate:"#arguments.startdate#",enddate:"#arguments.enddate#"); 
		local.arrResult = session.objects.systemRunner.RunBreakOutReport(qryData:local.data.OriginalData); 
		//session.objects.ReportService.BreakOutReport(symbol:arguments.symbol,data:local.arrResult); 
		return local.arrResult;
		</cfscript>
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
		var local = structNew();
		local.start 				= dateformat(now()-30,"mm/dd/yyyy"); 
		local.strBeanCollection 	= structNew();
		local.arrGoLong			= arrayNew(1);
		local.arrGoShort 		= arrayNew(1);
		local.arrHighBreakout 	= arrayNew(1);
		local.arrOpenTrade 		= arrayNew(1);
		local.arrCloseTrade 	= arrayNew(1) ;
		local.arrLowBreakdown 	= arrayNew(1);
		local.arrMoveStop 		= arrayNew(1);
		/* --- array of structurs of arrays */
		local.arrStrBeanSets 	= arrayNew(1);
		local.arrResults 		= arrayNew(1);
		local.arrAllTrades 		= arrayNew(1);
		local.arrClosedTrades 	= arrayNew(1);
		local.arrNewTrades 		= arrayNew(1);
		/* <cfset local.watchlist = 
		"ABX,ADBE,AEM,AKAM,APA,ATI,AXP,BIIB,BK,BP,CAT,CHK,CMED,CRM,CSCO,CSX,DE,DIA,DIG,DIS,DNDN,EEM,EWZ,FAS,FCX,FFIV,FSLR,FWLT,GLD,GMCR,GME,GS,HD,HK,HON,HOT,HPQ,HSY,IOC,IWM,JOYG,LVS,M,MDY,MEE,MMM,MOS,MS,NFLX,NKE,NSC,NUE,ORCL,PG,POT,QLD,QQQQ,RIG,RIMM,RMBS,RTH"
		> */
		
		/* <cfset local.watchlist = 
		"A,ABX,ADBE,AEM,AKAM,APA,ATI,AXP,BIIB,BK,BP,CAT,CHK,CMED,CRM,CSCO,CSX,DE,DIA,DIG,DIS,DNDN,EEM,EWZ,FAS,FCX,FFIV,FSLR,FWLT,GLD,GMCR,GME,GS,HD,HK,HON,HOT,HPQ,HSY,IOC,IWM,JOYG,LVS,M,MDY,MEE,MMM,MOS,MS,NFLX,NKE,NSC,NUE,ORCL,PG,POT,QLD,NASDAQ:QQQQ,RIG,RIMM,RMBS,RTH,SNDK,SPG,SPY,SQNM,UNP,USO,WYNN,XL,XLF"
		> */
		if (NOT session.OBJECTS.controller.diagnostics) {
		local.watchlist1 = 
		"ABX,ADBE,AEM,AKAM,APA,ATI,AXP,BIIB,BK,BP,CAT,CHK,CMED,CRM,CSCO";
		local.watchlist2 = 
		"CSX,DE,DIA,DIG,DIS,DNDN,EEM,EWZ,FAS,FCX,FFIV,FSLR,FWLT";
		local.watchlist3 = 
		"GLD,GMCR,GME,GS,HD,HK,HON,HOT,HPQ,HSY,NYSE:IOC,IWM,JOYG,LVS,M,MDY,MEE";
		local.watchlist4 = 
		"MMM,MOS,MS,NFLX,NKE,NSC,NUE,ORCL,PG,POT,QLD,NASDAQ:QQQQ,RIG,RIMM,RMBS,RTH,SNDK,SPG,SPY,SQNM,UNP,USO,WYNN,XL,XLF";
		
		}
		else {
		local.watchlist1 = "ABX" ;
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
	
	<cffunction name="functionOne" description="" access="public" displayname="" output="true" returntype="Any">
		<cfargument name="ArgumentStatus" required="false" default="everythings great!" />
		<cfdump label="before append:local" var="#local#">
		<cfdump label="before append:arguments" var="#arguments#">
		<cfset  local2 = FunctionTwo() />
		<cfset StructAppend(local,local2)> 
		<cfdump label="after append:local" var="#local#">
		<cfdump label="after append:arguments" var="#arguments#">
		<cfreturn local/>
	</cffunction>
	
	<cffunction name="functionTwo" description="" access="private" displayname="" output="true" returntype="Any">
		<cfargument name="ArgumentStatusfromFunctionTwo" required="false" default="Ha youre so screwed!" />
		<!--- Common in pre 8 code, this should blow away the existing local scope, right? Yeah well guess what.. It's actually worse than useless--->
		<cfset var local = StructNew()> 
		<cfreturn local/>
	</cffunction>
		
</cfcomponent>