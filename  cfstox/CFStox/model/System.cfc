<cfcomponent  displayname="system" hint="I test systems using given data" output="false">

	<cffunction name="init" description="init method" access="public" displayname="init" output="false" returntype="system">
		<!--- persistent variable to store trades and results --->
		<cfset variables.HLData = arrayNew(2) />
		<cfset variables.arrayCounter= 1 />
		<cfset variables.PrevHigh 	= 0 />
		<cfset variables.PrevLow 	= 10000 />
		<cfreturn this/>
	</cffunction>
	
	<cffunction name="System_hekin_ashi_long" description="called from systemRunner - heiken-ashi system" access="public" displayname="test" output="false" returntype="Any">
		<!--- based on new lower high --->
		<cfargument name="TradeBeanTwoDaysAgo" required="true" />
		<cfargument name="TradeBeanOneDayAgo" required="true" />
		<cfargument name="TradeBeanToday" required="true" />
		<cfargument name="TrackingBean" required="true" />
		<cfif TradeBeanTwoDaysAgo.Get("HKLow") GT TradeBeanOneDayAgo.Get("HKLow") AND TradeBeanToday.Get("HKLow") GT TradeBeanOneDayAgo.Get("HKLow")>		
			<cfset TradeBeanToday.Set("HKGoLong",true) />
		</cfif>
		<cfif TradeBeanTwoDaysAgo.Get("HKLow") LT TradeBeanOneDayAgo.Get("HKLow") AND TradeBeanToday.Get("HKLow") LT TradeBeanOneDayAgo.Get("HKLow")>		
			<cfset TradeBeanToday.Set("HKCloseLong",true) />
		</cfif>
		<cfreturn TradeBeanToday />
	</cffunction>

	<cffunction name="System_ha_longII" description="called from systemRunner - heiken-ashi system" access="public" displayname="test" output="false" returntype="Any">
		<!--- based on optimum trades in X - US Steel --->
		<!--- based on two down days followed by up day --->
		<cfargument name="TradeBeanTwoDaysAgo" required="true" />
		<cfargument name="TradeBeanOneDayAgo" required="true" />
		<cfargument name="TradeBeanToday" required="true" />
		<cfargument name="TrackingBean" required="true" />
		<cfset var local = StructNew() />
		<cfset local.boolGoLong = true>
		<cfset local.boolGoShort = true>
		<cfif arguments.TradeBeanTwoDaysAgo.Get("HKClose") GT arguments.TradeBeanTwoDaysAgo.Get("HKOpen")>
			<cfset local.boolGoLong = false />
		</cfif>   
		<cfif local.boolGoLong AND arguments.TradeBeanOneDayAgo.Get("HKClose") GT arguments.TradeBeanOneDayAgo.Get("HKOpen")>
			<cfset local.boolGoLong = false />
		</cfif>
		<cfif local.boolGoLong AND arguments.TradeBeanToday.Get("HKClose") GT arguments.TradeBeanToday.Get("HKOpen")
		AND arguments.TradeBeanToday.Get("HKHigh") GT arguments.TradeBeanOneDayAgo.Get("R2")>
			<cfset TradeBeanToday.Set("HKGoLong",true) />
			<cfset TradeBeanToday.Set("UseR2Entry",true) />
		</cfif> 
		<cfif arguments.TradeBeanToday.Get("HKClose") LT arguments.TradeBeanToday.Get("HKOpen")>
			<cfset TradeBeanToday.Set("HKCloseLong",true) />
			<cfset TradeBeanToday.Set("UseS2Entry",true) />
		</cfif>  
		<!--- go short --->
		<cfif arguments.TradeBeanTwoDaysAgo.Get("HKClose") LT arguments.TradeBeanTwoDaysAgo.Get("HKOpen")>
			<cfset local.boolGoShort = false />
		</cfif>   
		<cfif local.boolGoShort AND arguments.TradeBeanOneDayAgo.Get("HKClose") LT arguments.TradeBeanOneDayAgo.Get("HKOpen")>
			<cfset local.boolGoSHort = false />
		</cfif>
		<cfif local.boolGoShort AND arguments.TradeBeanToday.Get("HKClose") LT arguments.TradeBeanToday.Get("HKOpen")
		AND arguments.TradeBeanToday.Get("HKLow") LT arguments.TradeBeanOneDayAgo.Get("S2")>
			<cfset TradeBeanToday.Set("HKGoShort",true) />
			<cfset TradeBeanToday.Set("UseR2Entry",true) />
		</cfif> 
		<cfif arguments.TradeBeanToday.Get("HKClose") GT arguments.TradeBeanToday.Get("HKOpen")>
			<cfset TradeBeanToday.Set("HKCloseShort",true) />
			<cfset TradeBeanToday.Set("UseS2Entry",true) />
		</cfif>     	   		
		<cfreturn TradeBeanToday />
	</cffunction>
	
	<cffunction name="System_ha_longIII" description="called from systemRunner - heiken-ashi system" access="public" displayname="test" output="false" returntype="Any">
		<!--- based on optimum trades in X - US Steel --->
		<!--- based on two down days followed by up day --->
		<cfargument name="TradeBeanTwoDaysAgo" required="true" />
		<cfargument name="TradeBeanOneDayAgo" required="true" />
		<cfargument name="TradeBeanToday" required="true" />
		<cfargument name="TrackingBean" required="true" />
		<cfset var local = StructNew() />
		<cfset local.boolGoLong = true>
		<cfif arguments.TradeBeanTwoDaysAgo.Get("HKClose") GT arguments.TradeBeanTwoDaysAgo.Get("HKOpen")>
			<cfset local.boolGoLong = false />
		</cfif>   
		<cfif local.boolGoLong AND arguments.TradeBeanOneDayAgo.Get("HKClose") GT arguments.TradeBeanOneDayAgo.Get("HKOpen")>
			<cfset local.boolGoLong = false />
		</cfif>
		<cfif local.boolGoLong AND arguments.TradeBeanToday.Get("HKClose") GT arguments.TradeBeanToday.Get("HKOpen")>
			<cfset TradeBeanToday.Set("HKGoLong",true) />
			<cfset TradeBeanToday.Set("UseR2Entry",true) />
		</cfif> 
		<cfif arguments.TradeBeanToday.Get("HKClose") LT arguments.TradeBeanToday.Get("HKOpen")>
			<cfset TradeBeanToday.Set("HKCloseLong",true) />
			<cfset TradeBeanToday.Set("UseS2Entry",true) />
		</cfif>     		
		<cfreturn TradeBeanToday />
	</cffunction>
	
	<cffunction name="System_ha_III" description="called from systemRunner - heiken-ashi system" access="public" displayname="test" output="false" returntype="Any">
		<!--- based on optimum trades in X - US Steel --->
		<!--- based on two down days followed by up day --->
		<cfargument name="TradeBeanTwoDaysAgo" required="true" />
		<cfargument name="TradeBeanOneDayAgo" required="true" />
		<cfargument name="TradeBeanToday" required="true" />
		<cfargument name="TrackingBean" required="true" />
		<cfset var local = StructNew() />
		<cfscript>
		local.boolGoLong = false;
		local.tb2open = arguments.TradeBeanTwoDaysAgo.Get("HKOpen");
		local.tb2close = arguments.TradeBeanTwoDaysAgo.Get("HKClose");
		local.tb1open = arguments.TradeBeanOneDayAgo.Get("HKOpen");
		local.tb1close = arguments.TradeBeanOneDayAgo.Get("HKClose");
		local.tbopen = arguments.TradeBeanToday.Get("HKOpen");
		local.tbclose = arguments.TradeBeanToday.Get("HKClose");
		if (
		local.tb2open GT local.tb2close AND  
		local.tb1open LT local.tb1close //AND 
		//local.tbopen LT local.tbclose 
		) 
		{
			local.boolGoLong = true;
			TradeBeanToday.Set("HKGoLong",true); 
			TradeBeanToday.Set("UseR2Entry",true); 
		}
		
		if (
		//local.tb2open LT local.tb2close 
		//AND  
		//local.tb1open GT local.tb1close AND 
		local.tbopen GT local.tbclose 
		) 
		{
			local.boolGoShort = true;
			TradeBeanToday.Set("HKCloseLong",true); 
			TradeBeanToday.Set("UseR2Entry",true); 
		}
		</cfscript>
		<cfreturn TradeBeanToday />
	</cffunction>
	
	<cffunction name="System_hekin_ashi_short" description="called from SystemRunner - heiken-ashi system" access="public" displayname="test" output="false" returntype="Any">
		<cfargument name="TradeBeanTwoDaysAgo" required="true" />
		<cfargument name="TradeBeanOneDayAgo" required="true" />
		<cfargument name="TradeBeanToday" required="true" />
		<cfif TradeBeanTwoDaysAgo.Get("HKHigh") LT TradeBeanOneDayAgo.Get("HKHigh") AND TradeBeanToday.Get("HKHigh") GT TradeBeanOneDayAgo.Get("HKHigh")>		
			<cfset TradeBeanToday.Set("HKGoShort",true) />
		</cfif>
		<cfreturn TradeBeanToday />
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

	<cffunction name="System_NewHigh" description="I find new highs and lows" access="public" displayname="" output="false" returntype="Void">
		<cfargument name="TBeanTwoDaysAgo" required="true" />
		<cfargument name="TBeanOneDayAgo" required="true" />
		<cfargument name="TBeanToday" required="true" />
		<cfargument name="TrackingBean" required="false" />
		<cfset var local = Structnew() />
		<!--- New High Low algorythm 
		If low -2 > low-1 AND low -1 < low, save low -1 and date to array
		If low -1 < last saved value, flag as breakdown 
		If high -2 < high-1 AND high -1 > high, save high -1 and date to array
		If high -1 > last saved value, flag as breakout 
		Set("NewHighReversal","false");
		Set("NewHighBreakout","false");
		Set("NewLowBreakDown","false");
		Set("NewLowReversal","false");
		--->
		<!--- new local high ---->
		<cfif (variables.arraycounter -1) AND  arguments.TBeanToday.Get("HKhigh") GT variables.HLData[variables.arrayCounter-1][2]
				AND arguments.TBeanOneDayAgo.get("HKhigh") LT variables.HLData[variables.arrayCounter-1][2] >
			<cfset arguments.TBeanToday.set("NewHighBreakout",true)>
			<cfset arguments.TBeanToday.set("PreviousLocalHigh",variables.HLData[variables.arrayCounter-1][2])>
			<cfset arguments.TBeanToday.set("PreviousLocalHighDate",variables.HLData[variables.arrayCounter-1][3])>	
		</cfif>
		<cfif arguments.TBeanTwoDaysAgo.get("HKhigh") LT arguments.TBeanOneDayAgo.get("HKhigh") AND
				arguments.TBeanOneDayAgo.Get("HKhigh") GT arguments.TBeanToday.Get("HKhigh")  >
			<cfset variables.HLData[variables.arrayCounter][1] = "high" />
			<cfset variables.HLData[variables.arrayCounter][2] = arguments.TBeanOneDayAgo.get("HKhigh") />
			<cfset variables.HLData[variables.arrayCounter][3] = arguments.TBeanOneDayAgo.get("date") />
			<cfset arguments.TBeanToday.set("NewHighReversal",true)>	
			<cfset variables.arrayCounter = variables.arrayCounter + 1 />
		</cfif>
	<cfreturn />
	</cffunction>
	
	<cffunction name="System_Max_Profit" description="I find optimum entries and exits" access="public" displayname="" output="false" returntype="any">
		<cfargument name="TBeanTwoDaysAgo" required="true" />
		<cfargument name="TBeanOneDayAgo" required="true" />
		<cfargument name="TBeanToday" required="true" />
		
		<cfset var local = Structnew() />
		<!--- New High Low algorythm 
		If low -2 > low-1 AND low -1 < low, save low -1 and date to array
		If low -1 < last saved value, flag as breakdown 
		If high -2 < high-1 AND high -1 > high, save high -1 and date to array
		If high -1 > last saved value, flag as breakout 
		Set("NewHighReversal","false");
		Set("NewHighBreakout","false");
		Set("NewLowBreakDown","false");
		Set("NewLowReversal","false");
		--->
		<!--- new local high ---->
		<cfif  arguments.TBeanTwoDaysAgo.Get("HKlow") GT arguments.TBeanOneDayAgo.get("HKlow")
				AND arguments.TBeanOneDayAgo.get("HKlow") LT arguments.TBeanToday.get("HKlow") >
			<cfset arguments.TBeanOneDayAgo.set("NewLocalLow",true) />
		</cfif>
		<cfif  arguments.TBeanTwoDaysAgo.Get("HKhigh") LT arguments.TBeanOneDayAgo.get("HKHigh")
				AND arguments.TBeanOneDayAgo.get("HKHigh") GT arguments.TBeanToday.get("HKHigh") >
			<cfset arguments.TBeanOneDayAgo.set("NewLocalHigh",true) />	
		</cfif>
		<cfreturn  arguments.TBeanToday />
	</cffunction>
	
	<cffunction name="System_PivotPoints" description="I find new highs and lows" access="public" displayname="" output="false" returntype="Void">
		<cfargument name="TBeanTwoDaysAgo" required="true" />
		<cfargument name="TBeanOneDayAgo" required="true" />
		<cfargument name="TBeanToday" required="true" />
		<cfset var local = Structnew() />
			<!--- new local high ---->
		<cfif arguments.TBeanToday.Get("HKhigh") GT arguments.TBeanOneDayAgo.get("R1") >
			<cfset arguments.TBeanToday.set("R1Breakout1Day",true)>	
		</cfif>
		<cfif arguments.TBeanToday.Get("HKhigh") GT arguments.TBeanOneDayAgo.get("R2") >
			<cfset arguments.TBeanToday.set("R2Breakout1Day",true)>	
		</cfif>
		<cfif arguments.TBeanToday.Get("HKhigh") GT arguments.TBeanTwoDaysAgo.get("R1") >
			<cfset arguments.TBeanToday.set("R1Breakout2Day",true)>	
		</cfif>
		<cfif arguments.TBeanToday.Get("HKhigh") GT arguments.TBeanTwoDaysAgo.get("R2") >
			<cfset arguments.TBeanToday.set("R2Breakout2Day",true)>	
		</cfif>
		<cfreturn  />
	</cffunction>
</cfcomponent>