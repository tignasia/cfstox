<cfcomponent  displayname="system" hint="I test systems using given data" output="false">

<cffunction name="init" description="init method" access="public" displayname="init" output="false" returntype="system">
	<!--- persistent variable to store trades and results --->
	<cfreturn this/>
</cffunction>
	
<cffunction name="System_hekin_ashi_long" description="heiken-ashi system" access="public" displayname="test" output="false" returntype="Any">
	<cfargument name="TradeBeanTwoDaysAgo" required="true" />
	<cfargument name="TradeBeanOneDayAgo" required="true" />
	<cfargument name="TradeBeanToday" required="true" />
	<cfif TradeBeanTwoDaysAgo.Get("HKLow") GT TradeBeanOneDayAgo.Get("HKLow") AND TradeBeanToday.Get("HKLow") GT TradeBeanOneDayAgo.Get("HKLow")>		
		<cfset TradeBeanToday.Set("HKGoLong",true) />
	</cfif>
	<cfreturn TradeBeanToday />
</cffunction>

<cffunction name="System_hekin_ashi_short" description="heiken-ashi system" access="public" displayname="test" output="false" returntype="Any">
	<cfargument name="TradeBean" required="true" />
	<cfif TradeBean.GetHKLowTwoDaysAgo() LT TradeBean.GetHKLowOneDayAgo() AND TradeBean.GetHKLowToday() LT TradeBean.GetHKLowOneDayAgo()>		
		<cfset TradeBean.SetHKGoShort(true) />
	</cfif>
	<cfreturn TradeBean />
</cffunction>

<cffunction name="System_hekin_ashiII" description="heiken-ashi system" access="public" displayname="test" output="false" returntype="Any">
	<cfargument name="QueryData" required="true" />
	<cfset var local = structNew() />
	<!--- used to track trades  --->
	<cfset variables.TradeArray = ArrayNew(2) />
	<cfset local.dataArray = structNew() />
	<cfset local.longOpenResult = false />
	<cfset local.longCloseResult = false />
	<!--- typically our systems will look for crossovers, values greater than or less than something. --->
	<cfloop  query="arguments.QueryData" startrow="3">
		<cfset local.rowcount = arguments.QueryData.currentrow />
		<cfset local.DataArray[1] = session.objects.Utility.QrytoStruct(query:arguments.QueryData,rownumber:local.rowcount-2) />
		<cfset local.DataArray[2] = session.objects.Utility.QrytoStruct(query:arguments.QueryData,rownumber:local.rowcount-1) />
		<cfset local.DataArray[3] = session.objects.Utility.QrytoStruct(query:arguments.QueryData,rownumber:local.rowcount) />
		<!--- close greater than open; go long --->
		<cfif testHKLongOpen(local.dataArray) >
			<cfset makeTrade(tradetype:"long",action:"open", date:local.DataArray[3].dateOne, price:local.DataArray[3].close )>
		</cfif>
		<cfif testHKLongClose(local.dataArray) >
			<cfset makeTrade(tradetype:"long",action:"close", date:local.DataArray[3].dateOne, price:local.DataArray[3].close )>
		</cfif>
		<!---- close less than open; go short ---->
	</cfloop>
	<cfreturn variables.TradeArray />
</cffunction>

<cffunction name="testHKLongOpen" description="I open a long position" access="private" displayname="" output="false" returntype="boolean">
	<cfargument name="aryData" required="true" />
	<cfset var local = structNew() />
	<cfset local.longopen = false />
	<cfif arguments.AryData[1].close LT arguments.AryData[1].open 
		AND arguments.AryData[2].close GT arguments.AryData[2].open AND
		arguments.AryData[3].close GT arguments.AryData[3].open >
		<cfset local.longopen = true />
	</cfif>
	<cfreturn local.longopen />
</cffunction>

<cffunction name="testHKLongClose" description="I close a long position" access="private" displayname="" output="false" returntype="boolean">
	<cfargument name="aryData" required="true" />
	<cfset var local = structNew() />
	<cfset local.longclose = false />
	<cfif arguments.AryData[1].open LT arguments.AryData[1].close 
		AND arguments.AryData[2].open GT arguments.AryData[2].close AND
		arguments.AryData[3].open GT arguments.AryData[3].close >
		<cfset local.longclose = true />
	</cfif>
	<cfreturn local.longclose />
</cffunction>

<cffunction name="maketrade" description="" access="private" displayname="" output="false" returntype="void">
	<cfargument name="action" required="true" /> <!---- open/close --->
	<cfargument name="tradetype" required="true" /> <!---- long/short --->
	<cfargument name="date" required="true" />
	<cfargument name="price" required="true"  />
	<cfset var aLength = variables.TradeArray.Size() + 1 />
	<cfset variables.TradeArray[#alength#][1] = arguments.action />
	<cfset variables.TradeArray[#alength#][2] = arguments.tradetype />
	<cfset variables.TradeArray[#alength#][3] = arguments.date />
	<cfset variables.TradeArray[#alength#][4] = arguments.price />
	<cfreturn />
</cffunction>

<cffunction name="SystemHKBreakdown" description="catch drops in stocks" access="public" displayname="SystemHKBreakdown" output="false" returntype="Any">
	<!--watch for two red candles and inside day ; set short entry at S1 pivot point of the two candles combined 
	use reverse SAR as exit (give it more room the longer the move lasts) --->
	<cfreturn />
</cffunction>

<cffunction name="TrackTrades" description="I extract the trades from the querydata" access="public" displayname="TrackTrades" output="false" returntype="Query">
	<cfargument name="QueryData" required="true" />
	<cfset var local = structNew() />
	<cfset local.QueryData = duplicate(arguments.QueryData) />
	<cfloop index = "currentRow" from = "#local.QueryData.recordCount#" to = "1" step = "-1">
		<!--- if no trade, delete row --->
		<cfif local.QueryData.longe EQ "" AND local.QueryData.shorte EQ "" >
			<cfset local.QueryData.removeRows( JavaCast( "int", (local.QueryData.CurrentRow - 1) ),  JavaCast( "int", 1 )  ) />	
		</cfif>
	</cfloop>
	<cfreturn local.QueryData />
</cffunction>

<cffunction name="NewHL3" description="I find new highs and lows" access="public" displayname="" output="false" returntype="Array">
	<cfargument name="queryData" required="true"  />
	<cfset var local = Structnew() />
	<cfset local.HLData = arrayNew(2) />
	<cfset local.arrayCounter= 1 />
	<cfset local.PrevHigh 	= 0 />
	<cfset local.PrevLow 	= 10000 />
	<!--- New High Low algorythm 
	If low -2 > low-1 AND low -1 < low, save low -1 and date to array
	If low -1 < last saved value, flag as breakdown 
	If high -2 < high-1 AND high -1 > high, save high -1 and date to array
	If high -1 > last saved value, flag as breakout 
	--->
	<cfloop  query="arguments.QueryData" startrow="3">
		<cfset local.rowcount = arguments.QueryData.currentrow />
		<cfif arguments.queryData.high[local.rowcount-2] LT arguments.queryData.high[local.rowcount-1] AND
			arguments.queryData.high[local.rowcount-1] GT arguments.queryData.high  >
			<cfset local.HLData[local.arrayCounter][1] = "high" />
			<cfset local.HLData[local.arrayCounter][2] = arguments.queryData.high[local.rowcount-1] />
			<cfset local.HLData[local.arrayCounter][3] = arguments.queryData.DateOne[local.rowcount-1] />	
			<!--- check for breakout --->
			<cfif arguments.queryData.high[local.rowcount-1] GT local.prevHigh >
				<cfset local.HLData[local.arrayCounter][4] = "breakout" />
			</cfif>
		   <cfset local.prevHigh = arguments.queryData.high[local.rowcount-1] />
		   <cfset local.arrayCounter = local.arrayCounter + 1 />
		</cfif>
		<cfif arguments.queryData.low[local.rowcount-2] GT arguments.queryData.low[local.rowcount-1] AND
			arguments.queryData.low[local.rowcount-1] LT arguments.queryData.low  >
			<cfset local.HLData[local.arrayCounter][1] = "low" />
			<cfset local.HLData[local.arrayCounter][2] = arguments.queryData.low[local.rowcount-1] />
			<cfset local.HLData[local.arrayCounter][3] = arguments.queryData.DateOne[local.rowcount-1] />	
			<!--- check for breakout --->
			<cfif arguments.queryData.low[local.rowcount-1] LT local.prevLow >
				<cfset local.HLData[local.arrayCounter][4] = "breakdown" />
			</cfif>
		   <cfset local.prevLow = arguments.queryData.low[local.rowcount-1] />
		   <cfset local.arrayCounter = local.arrayCounter + 1 />
		</cfif>
	</cfloop>
	<cfreturn local.hldata />
</cffunction>

</cfcomponent>