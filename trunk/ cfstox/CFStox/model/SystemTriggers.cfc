<cfcomponent  displayname="system" hint="I contain the entry and exit filters and triggers" output="false">

	<cffunction name="init" description="init method" access="public" displayname="init" output="false" returntype="systemTriggers">
		<!--- persistent variable to store trades and results --->
		<cfreturn this/>
	</cffunction>
		<!--- 
		UpsideBreakout 
		DownsideBreakdown
		LongEntryStopTriggered
		ShortEntryStopTriggered
		LongExitStopTriggered
		ShortExitStopTriggered
		NewLocalHigh
		NewLocalLow
		Weakness
		HighVolume
		SMAUp
		SMADown
		--->
	
	<cffunction name="TestIndicator" description="test indicatior state" access="public" displayname="TestIndicator" output="false" returntype="Any">
		<cfargument name="Beans" required="true" />
		<cfargument name="Indicator" required="true" />
		<cfinvoke method="#arguments.Indicator#"  argumentcollection="#arguments#"  returnvariable="State" /> 
		<cfreturn State />
	</cffunction>
	
	<cffunction name="EntryLongDates" description="called from system" access="public" displayname="EntryLongDates" output="false" returntype="boolean">
		<cfargument name="Beans" required="true" />
		<cfargument name="Overbought" required="false" default=80 />
		<cfscript>
		if (ListFind("08/01/2011,08/22/2011,09/12/2011",dateformat(arguments.beans.DataBeanToday.Get("Date"),"mm/dd/yyyy"))) 
		{ return true;  }
		else
		{ return false; }
		</cfscript>
	</cffunction>
	
	<cffunction name="EntryShortDates" description="called from system" access="public" displayname="EntryShortDates" output="false" returntype="boolean">
		<cfargument name="Beans" required="true" />
		<cfargument name="Overbought" required="false" default=80 />
		<cfscript>
		if (ListFind("08/02/2011,08/19/2011,10/04/2011",dateformat(arguments.beans.DataBeanToday.Get("Date"),"mm/dd/yyyy"))) 
		{ return true;  }
		else
		{ return false; }
		</cfscript>
	</cffunction>
	
	<cffunction name="ExitLongDates" description="called from system" access="public" displayname="ExitLongDates" output="false" returntype="boolean">
		<cfargument name="Beans" required="true" />
		<cfargument name="Overbought" required="false" default=80 />
		<cfscript>
		if (ListFind("07/26/2011,08/18/2011,09/14/2011",dateformat(arguments.beans.DataBeanToday.Get("Date"),"mm/dd/yyyy"))) 
		{ return true;  }
		else
		{ return false; }
		</cfscript>
	</cffunction>
	
	<cffunction name="ExitShortDates" description="called from system" access="public" displayname="ExitShortDates" output="false" returntype="boolean">
		<cfargument name="Beans" required="true" />
		<cfargument name="Overbought" required="false" default=80 />
		<cfscript>
		if (ListFind("08/10/2011,09/01/2011,10/11/2011",dateformat(arguments.beans.DataBeanToday.Get("Date"),"mm/dd/yyyy"))) 
		{ return true;  }
		else
		{ return false; }
		</cfscript>
	</cffunction>
	
	<cffunction name="LRS10setup" description="called from system" access="public" displayname="LRS10setup" output="false" returntype="boolean">
		<cfargument name="Beans" required="true" />
		<cfargument name="LRSLevel" required="false" default=1 />
		<cfscript>
		var local = StructNew(); 
		if (arguments.beans.get("LinearRegSlope10") GT arguments.LRSLevel) 
		{
		return true;
		}
		else
		{
		return false;
		}
		</cfscript>
	</cffunction>
	
	<cffunction name="RSIoverbought" description="called from system" access="public" displayname="RSIoverbought" output="false" returntype="boolean">
		<cfargument name="Beans" required="true" />
		<cfargument name="Overbought" required="false" default=60 />
		<cfscript>
		if (arguments.beans.DataBeanToday.get("RSI") GTE arguments.Overbought AND arguments.beans.DataBean1.get("RSI") LT arguments.Overbought) 
		{ return true;  }
		else
		{ return false; }
		</cfscript>
	</cffunction>
	
	<cffunction name="CCIoverboughtCross" description="called from system" access="public" displayname="RSIoverbought" output="false" returntype="boolean">
		<cfargument name="Beans" required="true" />
		<cfargument name="Overbought" required="false" default=80 />
		<cfscript>
		if (arguments.beans.DataBeanToday.get("CCI") GTE arguments.Overbought AND arguments.beans.DataBean1.get("CCI") LT arguments.Overbought) 
		{ return true;  }
		else
		{ return false; }
		</cfscript>
	</cffunction>
	
	<cffunction name="CCIoverbought" description="called from system" access="public" displayname="RSIoverbought" output="false" returntype="boolean">
		<cfargument name="Beans" required="true" />
		<cfargument name="Overbought" required="false" default=80 />
		<cfscript>
		if (arguments.beans.DataBeanToday.get("CCI5") GTE arguments.Overbought) 
		{ return true;  }
		else
		{ return false; }
		</cfscript>
	</cffunction>
	
	<cffunction name="PreviousLow" description="called from system" access="public" displayname="PreviousLow" output="false" returntype="boolean">
		<!--- low below previous low  --->
		<cfargument name="Beans" required="true" />
		<cfargument name="Overbought" required="false" default=80 />
		<cfscript>
		if (arguments.beans.DataBeanToday.get("low") LTE arguments.beans.DataBean1.get("low")) 
		{ return true;  }
		else
		{ return false; }
		</cfscript>
	</cffunction>
	
	
	<cffunction name="SupportTriggered" description="called from system" access="public" displayname="BrokenLow" output="false" returntype="boolean">
		<!--- rise above previous low  --->
		<cfargument name="Beans" required="true" />
		<cfargument name="Overbought" required="false" default=80 />
		<cfscript>
		if (arguments.beans.DataBeanToday.get("High") GTE arguments.beans.DataBean1.get("open")) 
		{ return true;  }
		else
		{ return false; }
		</cfscript>
	</cffunction>
	
	<cffunction name="S1Break" description="called from system" access="public" displayname="S1Break" output="false" returntype="boolean">
		<cfargument name="Beans" required="true" />
		<!--- todo: this doesnt look exactly right - fix 8/21/2011 --->
		<!--- <cfdump label="Beans" var="#arguments.beans#">
		<cfabort> --->
		<cfscript>
		//var local = StructNew(); 
		if (arguments.beans.DataBeanToday.get("Low") LT arguments.beans.DataBean4.get("S1") ) 
		{
		return true;
		}
		else
		{
		return false;
		}
		</cfscript>
	</cffunction>
	
	<!---- todo:delete all this crap --->	
	
	<cffunction name="UpsideBreakout" description="called from system" access="public" displayname="UpsideBreakout" output="false" returntype="boolean">
		<!--- based on optimum trades in X - US Steel --->
		<!--- <cfargument name="TradeBeanTwo" required="true" />
		<cfargument name="TradeBeanOne" required="true" />
		<cfargument name="DataBeanToday" required="true" />
		<cfargument name="TrackingBean" required="true" /> --->
		<cfargument name="BeanCollection" required="true" />
		<cfscript>
		var local = StructNew(); 
		local.boolGoLong = true;
		local.boolGoShort = true;
		local.Patterns = CandlePattern(TB2:DataBean2, TB1:DataBean1, TB:DataBeanToday ); 
		</cfscript>
	</cffunction>
	
	<cffunction name="System_ha_longII" description="called from systemRunner - heiken-ashi system" access="public" displayname="test" output="false" returntype="Any">
		<!--- based on optimum trades in X - US Steel --->
		<!--- based on two down days followed by up day --->
		<cfargument name="DataBean2" required="true" />
		<cfargument name="DataBean1" required="true" />
		<cfargument name="DataBeanToday" required="true" />
		<cfargument name="TrackingBean" required="true" />
		<cfset var local = StructNew() />
		<cfset local.boolGoLong = true />
		<cfset local.boolGoShort = true />
		<cfset local.Patterns = CandlePattern(TB2:DataBean2, TB1:DataBean1, TB:DataBeanToday ) />
		<cfif local.Patterns.OCpattern EQ "LLH"
			AND arguments.DataBeanToday.Get("HKHigh") GT arguments.DataBean1.Get("R2")>
			<cfset DataBeanToday.Set("HKGoLong",true) />
			<cfset DataBeanToday.Set("UseR2Entry",true) />
		</cfif> 
		<cfif arguments.DataBeanToday.Get("HKClose") LT arguments.DataBeanToday.Get("HKOpen")>
			<cfset DataBeanToday.Set("HKCloseLong",true) />
			<cfset DataBeanToday.Set("UseS2Entry",true) />
		</cfif>  
		<!--- go short --->
		<cfif local.Patterns.OCpattern EQ "HHL"
		AND arguments.DataBeanToday.Get("HKLow") LT arguments.DataBean1.Get("S2")>
			<cfset DataBeanToday.Set("HKGoShort",true) />
			<cfset DataBeanToday.Set("UseR2Entry",true) />
		</cfif> 
		<cfif arguments.DataBeanToday.Get("HKClose") GT arguments.DataBeanToday.Get("HKOpen")>
			<cfset DataBeanToday.Set("HKCloseShort",true) />
			<cfset DataBeanToday.Set("UseS2Entry",true) />
		</cfif>     	   		
		<cfreturn DataBeanToday />
	</cffunction>
	
	<cffunction name="System_Short_Stops" description="called from systemRunner - short w/tight stops" access="public" displayname="test" output="false" returntype="Any">
		<!--- based on optimum trades in X - US Steel --->
		<!--- based on two down days followed by up day --->
		<cfargument name="DataBean2" required="true" />
		<cfargument name="DataBean1" required="true" />
		<cfargument name="DataBeanToday" required="true" />
		<cfargument name="TrackingBean" required="true" />
		<cfset var local = StructNew() />
		<!--- todo:remove and pass as argument --->
		<cfset local.Patterns = CandlePattern(TB2:DataBean2, TB1:DataBean1, TB:DataBeanToday ) />
		<cfif local.Patterns.OCpattern EQ "LLH">
			<cfset arguments.TrackingBean.Set("ShortEntryStop",false) />
		</cfif> 
		<cfif local.Patterns.OCpattern EQ "HLL">
			<cfset arguments.TrackingBean.Set("ShortEntryStop",true) />
			<cfset arguments.TrackingBean.Set("ShortEntryStopDays",0) />
			<cfset arguments.TrackingBean.Set("ShortEntryStopLevel",arguments.DataBeanToday.get("S1")) />
		</cfif> 
		<cfif arguments.DataBeanToday.Get("HKClose") LT arguments.DataBeanToday.Get("HKOpen")>
			<cfset DataBeanToday.Set("HKCloseLong",true) />
			<cfset DataBeanToday.Set("UseS2Entry",true) />
		</cfif>  
		<cfreturn DataBeanToday />
	</cffunction>
	
	<cffunction name="AKAMShort_S1entry_R1Exit" description="called from systemRunner - short w/tight stops" access="public" displayname="test" output="false" returntype="Any">
		<!--- based on optimum trades in AKAM Short --->
		<!--- based on two down days enter at break of S1 --->
		<cfargument name="DataBean2" required="true" />
		<cfargument name="DataBean1" required="true" />
		<cfargument name="DataBeanToday" required="true" />
		<cfargument name="TrackingBean" required="true" />
		<cfset var local = StructNew() />
		<!--- todo:remove and pass as argument --->
		<cfset local.Patterns = CandlePattern(TB2:DataBean2, TB1:DataBean1, TB:DataBeanToday ) />
		<!--- this system always has a short entry stop  --->
		<cfif local.Patterns.OCpattern EQ "HLL">
			<cfset arguments.TrackingBean.Set("ShortEntryStop",true) />
			<cfset arguments.TrackingBean.Set("ShortEntryStopDays",0) />
			<cfset arguments.TrackingBean.Set("ShortEntryStopLevel",arguments.DataBeanToday.get("S1")) />
		</cfif> 
		<cfif arguments.DataBeanToday.Get("HKClose") LT arguments.DataBeanToday.Get("HKOpen")>
			<cfset DataBeanToday.Set("HKCloseLong",true) />
			<cfset DataBeanToday.Set("UseS2Entry",true) />
		</cfif>  
		<cfreturn DataBeanToday />
	</cffunction>
	
	<cffunction name="System_ha_longIII" description="called from systemRunner - heiken-ashi system" access="public" displayname="test" output="false" returntype="Any">
		<!--- based on optimum trades in X - US Steel --->
		<!--- based on two down days followed by up day --->
		<cfargument name="DataBean2" required="true" />
		<cfargument name="DataBean1" required="true" />
		<cfargument name="DataBeanToday" required="true" />
		<cfargument name="TrackingBean" required="true" />
		<cfset var local = StructNew() />
		<cfset local.boolGoLong = true>
		<cfif arguments.DataBean2.Get("HKClose") GT arguments.DataBean2.Get("HKOpen")>
			<cfset local.boolGoLong = false />
		</cfif>   
		<cfif local.boolGoLong AND arguments.DataBean1.Get("HKClose") GT arguments.DataBean1.Get("HKOpen")>
			<cfset local.boolGoLong = false />
		</cfif>
		<cfif local.boolGoLong AND arguments.DataBeanToday.Get("HKClose") GT arguments.DataBeanToday.Get("HKOpen")>
			<cfset DataBeanToday.Set("HKGoLong",true) />
			<cfset DataBeanToday.Set("UseR2Entry",true) />
		</cfif> 
		<cfif arguments.DataBeanToday.Get("HKClose") LT arguments.DataBeanToday.Get("HKOpen")>
			<cfset DataBeanToday.Set("HKCloseLong",true) />
			<cfset DataBeanToday.Set("UseS2Entry",true) />
		</cfif>     		
		<cfreturn DataBeanToday />
	</cffunction>
	
	<cffunction name="System_ha_III" description="called from systemRunner - heiken-ashi system" access="public" displayname="test" output="false" returntype="Any">
		<!--- based on optimum trades in X - US Steel --->
		<!--- based on two down days followed by up day --->
		<cfargument name="DataBean2" required="true" />
		<cfargument name="DataBean1" required="true" />
		<cfargument name="DataBeanToday" required="true" />
		<cfargument name="TrackingBean" required="true" />
		<cfset var local = StructNew() />
		<cfscript>
		local.boolGoLong = false;
		local.tb2open = arguments.DataBean2.Get("HKOpen");
		local.tb2close = arguments.DataBean2.Get("HKClose");
		local.tb1open = arguments.DataBean1.Get("HKOpen");
		local.tb1close = arguments.DataBean1.Get("HKClose");
		local.tbopen = arguments.DataBeanToday.Get("HKOpen");
		local.tbclose = arguments.DataBeanToday.Get("HKClose");
		if (
		local.tb2open GT local.tb2close AND  
		local.tb1open LT local.tb1close //AND 
		//local.tbopen LT local.tbclose 
		) 
		{
			local.boolGoLong = true;
			DataBeanToday.Set("HKGoLong",true); 
			DataBeanToday.Set("UseR2Entry",true); 
		}
		
		if (
		//local.tb2open LT local.tb2close 
		//AND  
		//local.tb1open GT local.tb1close AND 
		local.tbopen GT local.tbclose 
		) 
		{
			local.boolGoShort = true;
			DataBeanToday.Set("HKCloseLong",true); 
			DataBeanToday.Set("UseR2Entry",true); 
		}
		</cfscript>
		<cfreturn DataBeanToday />
	</cffunction>
	
	<cffunction name="System_hekin_ashi_short" description="called from SystemRunner - heiken-ashi system" access="public" displayname="test" output="false" returntype="Any">
		<cfargument name="DataBean2" required="true" />
		<cfargument name="DataBean1" required="true" />
		<cfargument name="DataBeanToday" required="true" />
		<cfif DataBean2.Get("HKHigh") LT DataBean1.Get("HKHigh") AND DataBeanToday.Get("HKHigh") GT DataBean1.Get("HKHigh")>		
			<cfset DataBeanToday.Set("HKGoShort",true) />
		</cfif>
		<cfreturn DataBeanToday />
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

	<cffunction name="System_NewHighLow" description="I find new highs and lows" access="public" displayname="" output="false" returntype="Void">
		<cfargument name="TBeanTwoDaysAgo" required="true" />
		<cfargument name="TBeanOneDayAgo" required="true" />
		<cfargument name="TBeanToday" required="true" />
		<cfargument name="TrackingBean" required="false" />
		<cfargument name="HighPattern" required="false">
		<cfargument name="LowPattern" required="false">
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
		<!--- new local high ---->
		<!--- <cfif  arguments.TBeanToday.Get("HKhigh") GT arguments.TrackingBean.get("PreviousLocalHigh")
				AND NOT arguments.TrackingBean.get("NewHighBreakout")>
			<cfset arguments.TrackingBean.set("NewHighBreakout",true)>
			<cfset arguments.TBeanToday.set("NewHighBreakout",true)>
			<cfset arguments.TBeanToday.set("PreviousLocalHigh",arguments.TrackingBean.get("PreviousLocalHigh") >
			<cfset arguments.TBeanToday.set("PreviousLocalHighDate",arguments.TrackingBean.get("PreviousLocalHighDate")>	
		</cfif>
		<cfif  arguments.TBeanToday.Get("HKlow") LT arguments.TrackingBean.get("PreviousLocalLow")
				AND NOT arguments.TrackingBean.get("NewLowBreakdown")>
			<cfset arguments.TrackingBean.set("NewLowBreakdown",true)>
			<cfset arguments.TBeanToday.set("NewLowBreakdown",true)>
			<cfset arguments.TBeanToday.set("PreviousLocalLow",arguments.TrackingBean.get("PreviousLocalLow") >
			<cfset arguments.TBeanToday.set("PreviousLocalLowDate",arguments.TrackingBean.get("PreviousLocalLowDate")>	
		</cfif> --->
		<!--- todo:use TrackingBean for this --->
		<cfif arguments.TBeanTwoDaysAgo.get("HKhigh") LT arguments.TBeanOneDayAgo.get("HKhigh") AND
				arguments.TBeanOneDayAgo.Get("HKhigh") GT arguments.TBeanToday.Get("HKhigh")  >
				<cfset arguments.TBeanToday.set("NewHighReversal",true)>	
		</cfif>
		<!--- <cfif (variables.arraycounter -1) AND  arguments.TBeanToday.Get("HKhigh") GT variables.HLData[variables.arrayCounter-1][2]
				AND arguments.TBeanOneDayAgo.get("HKhigh") LT variables.HLData[variables.arrayCounter-1][2] >
			<cfset arguments.TBeanToday.set("NewHighBreakout",true)>
			<cfset arguments.TBeanToday.set("PreviousLocalHigh",variables.HLData[variables.arrayCounter-1][2])>
			<cfset arguments.TBeanToday.set("PreviousLocalHighDate",variables.HLData[variables.arrayCounter-1][3])>	
		</cfif> --->
		
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
		<!--- lows  --->
		<cfif arguments.TBeanToday.Get("HKlow") LT arguments.TBeanOneDayAgo.get("S1") >
			<cfset arguments.TBeanToday.set("S1Breakdown1Day",true)>	
		</cfif>
		<cfif arguments.TBeanToday.Get("HKlow") LT arguments.TBeanOneDayAgo.get("S2") >
			<cfset arguments.TBeanToday.set("S2Breakdown1Day",true)>	
		</cfif>
		<cfif arguments.TBeanToday.Get("HKlow") LT arguments.TBeanTwoDaysAgo.get("S1") >
			<cfset arguments.TBeanToday.set("S1Breakdown2Day",true)>	
		</cfif>
		<cfif arguments.TBeanToday.Get("HKlow") LT arguments.TBeanTwoDaysAgo.get("S2") >
			<cfset arguments.TBeanToday.set("S2Breakout2Day",true)>	
		</cfif>
		<cfreturn  />
	</cffunction>
	
	<cffunction name="CandlePattern" description="called from system - heiken-ashi system" access="public" displayname="test" output="false" returntype="Any">
		<!--- Takes TradeBeans as arguments --->
		<!--- based on two down days followed by up day --->
		<cfargument name="TB4" required="false" />
		<cfargument name="TB3" required="false" />
		<cfargument name="TB2" required="false" />
		<cfargument name="TB1" required="false" />
		<cfargument name="TB" required="false" />
		<cfscript>
		var local = StructNew();
			
		local.OCpattern = "";
		local.OpenPattern = "";
		local.HighPattern = "";
		local.LowPattern = "";
		local.ClosePattern = "";
		if(arguments.TB2.Get("HKClose") GT arguments.TB2.Get("HKOpen")){
		local.OCpattern = Local.OCpattern & "H";
		}	   
		else {
		local.OCpattern = Local.OCpattern & "L";
		}
		
		if(arguments.TB1.Get("HKClose") GT arguments.TB1.Get("HKOpen")){
		local.OCpattern = Local.OCpattern & "H";
		}
		else {
		local.OCpattern = Local.OCpattern & "L";
		}	
		if(arguments.TB.Get("HKClose") GT arguments.TB.Get("HKOpen")){
		local.OCpattern = Local.OCpattern & "H";
		}
		else{
		local.OCpattern = Local.OCpattern & "L";
		}	
		// close pattern  
		if(arguments.TB2.Get("HKClose") GT arguments.TB1.Get("HKClose")){
		local.ClosePattern = Local.ClosePattern & "L";
		} else {
		local.ClosePattern = Local.ClosePattern & "H";
		}	   
		if(arguments.TB1.Get("HKClose") GT arguments.TB.Get("HKClose")){
		local.ClosePattern = Local.ClosePattern & "L";
		} else {
		local.ClosePattern = Local.ClosePattern & "H";
		}	
		
		// open pattern  
		if(arguments.TB2.Get("HKOpen") GT arguments.TB1.Get("HKOpen")){
		local.OpenPattern = Local.OpenPattern & "L";
		} else {
		local.OpenPattern = Local.OpenPattern & "H";
		}	   
		if(arguments.TB1.Get("HKOpen") GT arguments.TB.Get("HKOpen")){
		local.OpenPattern = Local.OpenPattern & "L";
		} else {
		local.OpenPattern = Local.OpenPattern & "H";
		}	
		
		// high pattern  
		if(arguments.TB2.Get("HKHigh") GT arguments.TB1.Get("HKHigh")){
		local.HighPattern = Local.HighPattern & "L";
		} else {
		local.HighPattern = Local.HighPattern & "H";
		}	   
		if(arguments.TB1.Get("HKHigh") GT arguments.TB.Get("HKHigh")){
		local.HighPattern = Local.HighPattern & "L";
		} else {
		local.HighPattern = Local.HighPattern & "H";
		}	
		
		// low pattern  
		if(arguments.TB2.Get("HKLow") GT arguments.TB1.Get("HKLow")){
		local.LowPattern = Local.LowPattern & "L";
		} else {
		local.LowPattern = Local.LowPattern & "H";
		}	   
		if(arguments.TB1.Get("HKLow") GT arguments.TB.Get("HKLow")){
		local.LowPattern = Local.LowPattern & "L";
		} else {
		local.LowPattern = Local.LowPattern & "H";
		}
		return local;			
		</cfscript>
	</cffunction>
</cfcomponent>