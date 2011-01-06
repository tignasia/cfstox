<cfcomponent  displayname="systemRunner" hint="I test systems using given data" output="false">

	<cffunction name="init" description="init method" access="public" displayname="init" output="false" returntype="systemRunner">
		<!--- persistent variable to store trades and results --->
		<cfset variables.trackHighLows = StructNew() />
		<cfset variables.tradeArray = ArrayNew(2) />
		<cfset variables.BeanArray = arraynew(1) />
		<cfset variables.HiLoBeanArray = arraynew(1) />
		<cfreturn this/>
	</cffunction>
	
	<cffunction name="reset" description="init method" access="public" displayname="init" output="false" returntype="systemRunner">
		<!--- persistent variable to store trades and results --->
		<cfset variables.trackHighLows = StructNew() />
		<cfset variables.tradeArray = ArrayNew(2) />
		<cfset variables.BeanArray = arraynew(1) />
		<cfset variables.HiLoBeanArray = arraynew(1) />
		<cfreturn this/>
	</cffunction>
	
	<cffunction name="TestSystem" description="called from SystemService.RunSystem" access="public" displayname="" output="false" returntype="Any">
		<cfargument name="qryData" required="true" />
		<cfargument name="SystemToRun" required="true" />
		<cfset var local = structNew() />
		<cfset reset() />
		<cfset session.objects.system.reset() />
		<cfset local.boolResult = false />
		<cfset local.dataArray = ArrayNew(1) />
		<cfset local.DataArray[1] = session.objects.Utility.QrytoStruct(query:arguments.qryData,rownumber:1) />
		<cfset local.TrackingBean 	= createObject("component","cfstox.model.TradeBean").init(local.DataArray[1]) /> 
		<cfset local.TradeBeanTwoDaysAgo = createObject("component","cfstox.model.TradeBean").init(local.DataArray[1]) /> 
		<cfset local.TradeBeanOneDayAgo = createObject("component","cfstox.model.TradeBean").init(local.DataArray[1]) /> 
		<cfset local.TradeBeanToday 	= createObject("component","cfstox.model.TradeBean").init(local.DataArray[1]) /> 
			
		<cfloop  query="arguments.qryData" startrow="3">
			<cfscript>
			local.rowcount = arguments.qryData.currentrow;
			local.DataArray[1] = session.objects.Utility.QrytoStruct(query:arguments.qryData,rownumber:local.rowcount-2);
			local.DataArray[2] = session.objects.Utility.QrytoStruct(query:arguments.qryData,rownumber:local.rowcount-1);
			local.DataArray[3] = session.objects.Utility.QrytoStruct(query:arguments.qryData,rownumber:local.rowcount);
			// <!---- check the conditions such as new local high/low, bollinger bands, MACD bollinsger band deviations, etc. --->
			// <!---- use these conditions to populate the rest of the bean--->
			local.TradeBeanTwoDaysAgo = createObject("component","cfstox.model.TradeBean").init(local.DataArray[1]); 
			local.TradeBeanOneDayAgo = createObject("component","cfstox.model.TradeBean").init(local.DataArray[2]); 
			local.TradeBeanToday 	= createObject("component","cfstox.model.TradeBean").init(local.DataArray[3]); 
			// local.TradeBeanTwoDaysAgo = local.TradeBeanTwoDaysAgo.init(local.DataArray[1]); 
			// local.TradeBeanOneDayAgo = local.TradeBeanOneDayAgo.init(local.DataArray[2]); 
			// local.TradeBeanToday = local.TradeBeanToday.init(local.DataArray[3]); 
			// <!--- <cfset TrackHighLows(local.TradeBeanTwoDaysAgo,local.TradeBeanOneDayAgo,local.TradeBeanToday)> --->
			// <!--- <cfset local.TradeBeanToday = RecordIndicators(tradeBean:local.TradeBeanToday) /> --->
			session.objects.system.System_ha_longII(local.TradeBeanTwoDaysAgo,local.TradeBeanOneDayAgo,local.TradeBeanToday,local.TrackingBean);
			session.objects.system.System_NewHighLow(local.TradeBeanTwoDaysAgo,local.TradeBeanOneDayAgo,local.TradeBeanToday);
			session.objects.system.System_PivotPoints(local.TradeBeanTwoDaysAgo,local.TradeBeanOneDayAgo,local.TradeBeanToday);
			//session.objects.system.System_Max_Profit(local.TradeBeanTwoDaysAgo,local.TradeBeanOneDayAgo,local.TradeBeanToday);
			//<!--- record system name, date, entry price --->
			local.TradeBeanToday = RecordIndicators(local.TradeBeanToday);
			recordTrades(local.TradeBeanToday,local.trackingBean);
			</cfscript> 
		</cfloop>
		<!--- return the action results ---->
		<cfset local.trades = variables.TradeArray />
		<cfset local.BeanCollection = variables.BeanArray />
		<cfset local.symbol = local.tradeBeanToday.Get("symbol") />
		<cfreturn local />
	</cffunction>
	
	<cffunction name="RecordTrades" description="" access="private" displayname="" output="false" returntype="Any">
		<cfargument name="TradeBean" required="true" />
		<cfargument name="TrackingBean" required="true"  />
		<cfset var local = StructNew() />
		<!--- todo: entering and closing trades on same day is screwing your records up  --->
		<!--- todo: stop closing trades that aren't open --->
		<cfif arguments.TradeBean.Get("HKGoLong") 
		OR arguments.TradeBean.Get("HKGoShort")
		OR arguments.TradeBean.Get("HKCloseLong")
		OR arguments.TradeBean.Get("HKCloseShort")
		<!--- 
		OR arguments.TradeBean.Get("NewHighReversal")
		OR arguments.TradeBean.Get("NewHighBreakout")
		OR arguments.TradeBean.Get("R1Breakout1Day")	
		OR arguments.TradeBean.Get("R2Breakout1Day")
		OR arguments.TradeBean.Get("R1Breakout2Days")
		OR arguments.TradeBean.Get("R2Breakout2Days")	 --->
		>
			<!--- todo:use tracking bean to set entry stop flag; there is always an exit stop on open positions --->
			<!--- cancel long trade if already long --->
			<cfif arguments.TradeBean.Get("HKGoLong") AND arguments.TrackingBean.Get("HKGoLong")>
				<cfscript>
				arguments.TradeBean.Set("HKGoLong",false );
				</cfscript>
			</cfif>
			<!--- must close short position before going long? --->
			<cfif arguments.TradeBean.Get("HKGoLong") AND NOT arguments.TrackingBean.Get("HKGoLong")>
				<cfscript>
				arguments.TrackingBean.Set("HKGoLong",true);
				arguments.TradeBean.Set("EntryDate",arguments.TradeBean.Get("Date") );
				arguments.TradeBean.Set("EntryPrice",arguments.TradeBean.Get("HKClose"));
				arguments.TrackingBean.Set("EntryDate",arguments.TradeBean.Get("Date") );
				arguments.TrackingBean.Set("EntryPrice",arguments.TradeBean.Get("HKClose"));
				</cfscript>
			</cfif>
			<!--- dont try to close non-existant trades--->
			<cfif arguments.TradeBean.Get("HKCloseLong") AND NOT arguments.TrackingBean.Get("HKGoLong")>
				<cfscript>
				arguments.TradeBean.Set("HKCloseLong",false);
				</cfscript>
			</cfif>
			<cfif arguments.TradeBean.Get("HKCloseLong") AND arguments.TrackingBean.Get("HKGoLong")>
				<cfscript>
				arguments.TrackingBean.Set("HKGoLong",false);
				arguments.TrackingBean.Set("ExitDate",arguments.TradeBean.Get("date") );
				arguments.TrackingBean.Set("ExitPrice",arguments.TradeBean.Get("HKClose") );
				local.profitloss =  arguments.TrackingBean.Get("ExitPrice") - arguments.TrackingBean.Get("EntryPrice") ;
				arguments.TrackingBean.Set("ProfitLoss",local.profitloss); 
				local.NetProfitLoss = arguments.TrackingBean.Get("NetProfitLoss") + local.profitloss;
				arguments.TrackingBean.Set("NetProfitLoss",local.Netprofitloss); 
				arguments.TradeBean.Set("EntryDate",arguments.TrackingBean.Get("EntryDate") );
				arguments.TradeBean.Set("EntryPrice",arguments.TrackingBean.Get("EntryPrice"));
				arguments.TradeBean.Set("ExitDate",arguments.TradeBean.Get("date") );
				arguments.TradeBean.Set("ExitPrice",arguments.TradeBean.Get("HKClose") );
				arguments.TradeBean.Set("ProfitLoss",local.profitloss); 
				arguments.TradeBean.Set("NetProfitLoss",local.Netprofitloss); 
				</cfscript>
			</cfif>
			
			<!--- short  --->
			<!--- if we are already short dont re-short --->
			<cfif arguments.TradeBean.Get("HKGoShort") AND arguments.TrackingBean.Get("HKGoSHort")>
				<cfscript>
				arguments.TradeBean.Set("HKGoShort",false );
				</cfscript>
			</cfif>
			<cfif arguments.TradeBean.Get("HKGoShort") AND NOT arguments.TrackingBean.Get("HKGoShort")>
				<cfscript>
				arguments.TrackingBean.Set("HKGoShort",true);
				arguments.TradeBean.Set("EntryDate",arguments.TradeBean.Get("Date") );
				arguments.TradeBean.Set("EntryPrice",arguments.TradeBean.Get("HKClose"));
				arguments.TrackingBean.Set("EntryDate",arguments.TradeBean.Get("Date") );
				arguments.TrackingBean.Set("EntryPrice",arguments.TradeBean.Get("HKClose"));
				</cfscript>
			</cfif>
			<!--- dont try to close non-existant trades--->
			<cfif arguments.TradeBean.Get("HKCloseShort") AND NOT arguments.TrackingBean.Get("HKGoShort")>
				<cfscript>
				arguments.TradeBean.Set("HKCloseShort",false);
				</cfscript>
			</cfif>
			<cfif arguments.TradeBean.Get("HKCloseShort") AND arguments.TrackingBean.Get("HKGoShort")>
				<cfscript>
				arguments.TrackingBean.Set("HKGoShort",false);
				arguments.TrackingBean.Set("ExitDate",arguments.TradeBean.Get("date") );
				arguments.TrackingBean.Set("ExitPrice",arguments.TradeBean.Get("HKClose") );
				local.profitloss =  arguments.TrackingBean.Get("EntryPrice") - arguments.TrackingBean.Get("ExitPrice") ;
				arguments.TrackingBean.Set("ProfitLoss",local.profitloss); 
				local.NetProfitLoss = arguments.TrackingBean.Get("NetProfitLoss") + local.profitloss;
				arguments.TrackingBean.Set("NetProfitLoss",local.Netprofitloss); 
				arguments.TradeBean.Set("EntryDate",arguments.TrackingBean.Get("EntryDate") );
				arguments.TradeBean.Set("EntryPrice",arguments.TrackingBean.Get("EntryPrice"));
				arguments.TradeBean.Set("ExitDate",arguments.TradeBean.Get("date") );
				arguments.TradeBean.Set("ExitPrice",arguments.TradeBean.Get("HKClose") );
				arguments.TradeBean.Set("ProfitLoss",local.profitloss); 
				arguments.TradeBean.Set("NetProfitLoss",local.Netprofitloss); 
				</cfscript>
			</cfif>
		<!--- send the bean to the output component so it can capture the bean state--->
		</cfif>
		<cfscript>	
			local.BeanArrayLen = variables.Beanarray.size() + 1 ;
			variables.BeanArray[#local.BeanArrayLen#] = arguments.tradeBean ;
			</cfscript>
		<cfreturn />
	</cffunction>
	
	<cffunction name="Open_Trade" description="" access="private" displayname="" output="false" returntype="Any">
		<cfargument name="TradeBean" required="true" />
		<cfargument name="TrackingBean" required="true"  />
		<cfset var local = StructNew() />
		<cfif arguments.TradeBean.Get("LongPositionTriggered") >
			<cfscript>
			local.entryPoint = arguments.TradeBean.Get("EntryPoint"); // open,R1,R2
			arguments.TrackingBean.Set("LongPositionTriggered",true);
			arguments.TrackingBean.Set("EntryDate",arguments.TradeBean.Get("Date") );
			arguments.TrackingBean.Set("EntryPrice",arguments.TradeBean.Get("#local.entryPoint#"));
			</cfscript>
		</cfif>
		<cfif arguments.TradeBean.Get("ShortPositionTriggered") >
			<cfscript>
			local.entryPoint = arguments.TradeBean.Get("EntryPoint"); // open,S1,S2
			arguments.TrackingBean.Set("ShortPositionTriggered",true);
			arguments.TrackingBean.Set("EntryDate",arguments.TradeBean.Get("Date") );
			arguments.TrackingBean.Set("EntryPrice",arguments.TradeBean.Get("#local.entryPoint#"));
			</cfscript>
		</cfif>
		<cfreturn />
	</cffunction>
	
	<cffunction name="Close_Trade" description="I update the TrackingBean to keep track of trading state" access="private" displayname="" output="false" returntype="Any">
		<cfargument name="TradeBean" required="true" />
		<cfargument name="TrackingBean" required="true"  />
		<cfset var local = StructNew() />
		<cfset local.exitPoint = arguments.TradeBean.Get("ExitPoint") />  <!--- open,S1,S2,r1,r2 --->
		<cfif arguments.TradeBean.Get("CloseLong") >
			<cfscript>
			arguments.TrackingBean.Set("CloseLong",true);
			arguments.TrackingBean.Set("ExitDate",arguments.TradeBean.Get("Date") );
			arguments.TrackingBean.Set("ExitPrice",arguments.TradeBean.Get("#local.ExitPoint#"));
			</cfscript>
		</cfif>
			
		<cfif arguments.TradeBean.Get("CloseShort") >
			<cfscript>
			arguments.TrackingBean.Set("CloseShort",true);
			arguments.TrackingBean.Set("ExitDate",arguments.TradeBean.Get("date") );
			arguments.TrackingBean.Set("ExitPrice",arguments.TradeBean.Get("#local.ExitPoint#") );
			local.profitloss = arguments.TrackingBean.Get("EntryPrice") - arguments.TrackingBean.Get("ExitPrice")   ;
			arguments.TrackingBean.Set("ProfitLoss",local.profitloss); 
			local.NetProfitLoss = arguments.TrackingBean.Get("NetProfitLoss") + local.profitloss;
			arguments.TrackingBean.Set("NetProfitLoss",local.Netprofitloss); 
			arguments.TradeBean.Set("EntryDate",arguments.TrackingBean.Get("EntryDate") );
			arguments.TradeBean.Set("EntryPrice",arguments.TrackingBean.Get("EntryPrice"));
			arguments.TradeBean.Set("ExitDate",arguments.TradeBean.Get("date") );
			arguments.TradeBean.Set("ExitPrice",arguments.TradeBean.Get("#local.ExitPoint#") );
			arguments.TradeBean.Set("ProfitLoss",local.profitloss); 
			arguments.TradeBean.Set("NetProfitLoss",local.Netprofitloss); 
			</cfscript>
		</cfif>
		<cfreturn />
	</cffunction>
	
	<cffunction name="RecordIndicators" description="" access="private" displayname="" output="false" returntype="tradebean">
		<cfargument name="TradeBean" required="true" />
		<cfset var local = StructNew() />
		<cfset arguments.tradeBean.Set("RSI",decimalFormat(arguments.tradeBean.Get("RSI") )) />
		<cfset arguments.tradeBean.Set("CCI",decimalFormat(arguments.tradeBean.Get("CCI") )) />
		<cfset local.rsi = arguments.tradeBean.Get("RSI") />
		<cfset local.cci = arguments.tradeBean.Get("CCI") />
		<cfif local.rsi GTE 70>
			<cfset tradeBean.Set("RSIStatus","RSI is Overbought at #local.rsi# ")>
		</cfif>
		<cfif local.rsi LTE 30>
			<cfset tradeBean.Set("RSIStatus","RSI is Oversold at #local.rsi# ")>
		</cfif>
		<cfif local.rsi GT 30 AND local.rsi LT 70>
			<cfset tradeBean.Set("RSIStatus","RSI is at #local.rsi# ")>
		</cfif>
		<!--- <cfif tradeBean.Get("Stolchastic") GT 80>
			<cfset tradeBean.Set("STOStatus","Stolchastic is Overbought")>
		</cfif>
		<cfif tradeBean.Get("Stolchastic") LT 20>
			<cfset tradeBean.Set("STOStatus","Stochastic is Oversold")>
		</cfif> --->
		<cfif local.cci GTE 100>
			<cfset tradeBean.Set("CCIStatus","CCI is Overbought at #local.cci#")>
		</cfif>
		<cfif local.cci LTE -100>
			<cfset tradeBean.Set("CCIStatus","CCI is Oversold at #local.cci#")>
		</cfif>
		<cfif local.cci GT -100 AND local.cci LT 100>
			<cfset tradeBean.Set("CCIStatus","CCI is at #local.cci#")>
		</cfif>
		<cfreturn tradebean />
	</cffunction>
	
	<cffunction name="testSystema" description="I test the system" access="public" displayname="test" output="false" returntype="Any">
	<cfargument name="qryData" required="true" />
	<cfargument name="fieldnames" required="true" />
	<cfset var local = structnew() />
	<cfset local.boolResult = true>
	<cfset local.counter = 1 />
	<cfset local.qryLen = arguments.qryData.recordcount />
	<!--- init array of last 30 results --->
	<!--- typically our systems will look for crossovers, values greater than or less than something. --->
	<!--- test if linear regression slope is less than .25 and stock made a new two week low --->
	<cfloop from="1" to="#local.qryLen#" index="i">
		<cfif NOT arguments.qrydata.LSRdelta[i] LTE -.25> 
			<cfset local.boolResult = false>
		</cfif>
		<cfif NOT arguments.qrydata.newOneWeekLow[i] > 
			<cfset local.boolResult = false>
		</cfif>
		<cfset local.counter = local.counter + 1 >
		<cfset arguments.qrydata.testresult[i] = local.boolResult />
	</cfloop>
	<cfreturn local.boolResult />
	</cffunction>

	<cffunction name="testSystem2a" description="I test the system" access="public" displayname="test" output="false" returntype="Any">
	<cfargument name="theQuery" required="true" />
	<cfargument name="fieldnames" required="true" />
	<cfargument name="conditions" required="true" />
	<cfset var local = structNew() />
	<!--- just for storage  
	<cfset local.longtrade = false />
	<cfset local.shorttrade = false />
	<cfset local.longentry 	= 0 />
	<cfset local.longexit 	= 0 />
	<cfset local.shortentry = 0 />
	<cfset local.shortexit 	= 0 />
	<cfset local.longprofit 	= 0 />
	<cfset local.shortprofit 	= 0 />
	<cfset queryAddColumn(arguments.QueryData, "hklong"  ,'cf_sql_varchar', arrayNew( 1 ) ) />
	<cfset queryAddColumn(arguments.QueryData, "hkshort" ,'cf_sql_varchar', arrayNew( 1 ) ) />
	<cfset queryAddColumn(arguments.QueryData, "longp"  ,'cf_sql_varchar', arrayNew( 1 ) ) />
	<cfset queryAddColumn(arguments.QueryData, "shortp" ,'cf_sql_varchar', arrayNew( 1 ) ) />
	<cfset queryAddColumn(arguments.QueryData, "longe"  ,'cf_sql_varchar', arrayNew( 1 ) ) />
	<cfset queryAddColumn(arguments.QueryData, "shorte" ,'cf_sql_varchar', arrayNew( 1 ) ) />
	<cfset queryAddColumn(arguments.QueryData, "tlongp" ,'cf_sql_varchar', arrayNew( 1 ) ) />
	<cfset queryAddColumn(arguments.QueryData, "tshortp" ,'cf_sql_varchar', arrayNew( 1 ) ) />
	--->
		
	<cfset indicator1 = arraynew(1) />
	<!--- typically our systems will look for crossovers, values greater than or less than something. --->
	<cfloop  query="arguments.theQuery">
		<cfset local.currRow = arguments.theQuery.currentrow />
		<cfif local.currow LTE 3>
			<cfset indicator1[local.currRow] = arguments.theQuery.fieldname />
		<cfelse>
			<cfset indicator1[1] =  indicator1[2] />
			<cfset indicator1[2] =  indicator1[3] />
			<cfset indicator1[3] =  arguments.theQuery.fieldname />
		</cfif>
	</cfloop>
	<cfreturn />
	</cffunction>

	
</cfcomponent>