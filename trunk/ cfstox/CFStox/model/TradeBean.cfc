<cfcomponent  displayname="TradeBean" output="false"  hint="I represent the values and indicators for a given day" >

	<cffunction name="init" description="init method" access="public" displayname="init" output="false" returntype="TradeBean">
		<cfargument name="strData"  />
		<cfargument name="SystemName"  />
		<cfscript>
		set("Symbol",strData.Symbol);	
		set("Date",strData.DateOne);	
		set("HKOpen",strData.Open);
		set("HKHigh",strData.High);
		set("HKLow",strData.Low);
		set("HKClose",strData.Close);
		set("HKVolume",strData.Volume);
		set("Open",strData.Open);
		set("High",strData.High);
		set("Low",strData.Low);
		set("Close",strData.Close);
		set("Volume",strData.Volume);
		set("ADX",strData.ADX);
		set("CCI",strData.CCI);
		set("RSI",strData.RSI); 
		set("LinearReg",strData.LinearReg);
		set("LinearRegAngle",strData.LinearRegAngle);
		set("LinearRegIntercept",strData.LinearRegIntercept);
		set("LinearRegSlope",strData.LinearRegSlope);
		set("LRSDelta",strData.LRSDelta);
		set("Momentum",strData.Momentum);
		set("S1","");
		set("S2","");
		set("R1","");
		set("R2",""); 
		// trade info
		Set("NewHighBreakout","false"); //high greater than prev local high
		Set("NewHighReversal","false"); // bounce off new local high 
		Set("NewLowBreakDown","false"); //new low greater than previous local low
		Set("NewLowReversal","false"); // bounce off new local low
		Set("PreviousLocalHigh",0);
		Set("PreviousLocalLow",0);
		Set("PreviousLocalHighDate","00/00/0000");
		Set("PreviousLocalLowDate","00/00/0000");
		Set("NewLocalLow",false);
		Set("NewLocalHigh",false);
		Set("NewLow",false);
		Set("NewHigh",false);
		Set("OpenLongAlert","false");
		Set("OpenLong","false");
		Set("LongPosition","false");
		Set("OpenShortAlert","false");
		Set("OpenShort","false");
		Set("ShortPosition","false");
		Set("CloseLongAlert","false");
		Set("CloseLong","false");
		Set("CloseShortAlert","false");
		Set("CloseShort","false");
		Set("HKGoShort","false");
		Set("HKCloseShort","false");
		Set("HKGoLong","false");
		Set("HKCloseLong","false");
		Set("UseR1Entry","false");
		Set("UseR2Entry","false");
		Set("UseS1Entry","false");
		Set("UseS2Entry","false");
		Set("EntryDate","00/00/0000");
		Set("EntryPrice",0);
		Set("EntryPoint","R2");
		Set("ExitDate","00/00/0000");
		Set("ExitPrice",0);
		Set("ExitPoint","S1");
		Set("ProfitLoss",0);
		Set("NetProfitLoss",0);
		Set("StopLossPrice",0);
		Set("StopLossTriggered",false);
		Set("RSIstatus","");
		Set("CCIstatus","");
		Set("MomentumStatus","");
		Set("BolBandStatus","");
		Set("MACDStatus","");
		Set("R1Breakout1Day",false);
		Set("R1BreakOut2Days",false);
		Set("R2Breakout1Day",false);
		Set("R2BreakOut2Days",false);
		Set("S1Breakdown1Day",false);
		Set("S1Breakdown2Days",false);
		Set("S2Breakdown1Day",false);
		Set("S2Breakdown2Days",false);
		Set("R1Status","");
		Set("R2Status","");
		Set("S1Status","");
		Set("S2Status","");
		Set("SystemName",arguments.systemName);
		variables.tracker = StructNew();
		variables.trackhistory = ArrayNew(1);
		
		variables.trade = StructNew();
		variables.trade.date = "";
		variables.trade.TradeDescription = "";
		variables.trade.TradeEntryExitPoint = "";
		variables.trade.TradePrice = "";
		variables.tradeHistory = ArrayNew(1);
		return this;
		</cfscript>
	</cffunction>
	
	<cffunction name="getMemento" description="" access="public" displayname="" output="false" returntype="Any">
		<cfreturn variables />
	</cffunction>
	
	<cffunction name="Set" description="" access="public" displayname="" output="false" returntype="void">
		<cfargument name="fieldname" required="true"  />
		<cfargument name="data" required="true"  />
		<cfset variables[#fieldname#] = arguments.data />
		<cfreturn />
	</cffunction>	
	
	<cffunction name="Get" description="" access="public" displayname="" output="false" returntype="Any">
		<cfargument name="fieldname" required="true"  />
		<cfreturn variables[#fieldname#] />
	</cffunction>	
	
	<cffunction name="ProcessTrades" description="" access="public" displayname="" output="false" returntype="Any">
		<cfargument name="DataBeanToday" required="true"  />
		<!--- Set("OpenLongAlert","false");
		Set("OpenLong","false");
		Set("OpenShortAlert","false");
		Set("OpenShort","false");
		Set("CloseLongAlert","false");
		Set("CloseLong","false");
		Set("CloseShortAlert","false");
		Set("CloseShort","false"); --->
		<cfscript>
		var local = structNew();
		local.tradeType = "";
		
		local.tracker1 = Duplicate(variables.tracker);
		local.tracker1.date = arguments.DataBeanToday.get("Date");
		local.tracker1.tbstatusChange = arguments.DataBeanToday.get("TBStatusChange");	
		// open long alert places a long trade if condition is met
		// the condition is part of the system
		// process exisiting trades
		//dump(arguments.DataBeanToday.GetMemento());
		// the databean should ask the trackingbean for this info. This is part of the system and should not be in the tradebean
		// the tradebean should only be resp for implementing the system calls
		//
		/* local.TradeType = DataBeanToday.get("TradeType")
		switch(local.TradeType){
			case "OpenLong":
			local.OpenPattern = CandlePattern(local.arrData);
			break;
			case "OpenShort":
			local.HighPattern = CandlePattern(local.arrData);
			break;
			case "CloseLong":
			local.LowPattern = CandlePattern(local.arrData);
			break;
			case "CloseShort":
			local.ClosePattern = CandlePattern(local.arrData);
			break;
			} */
		
		local.TradeType = DataBeanToday.get("TradeType");
		switch(local.TradeType){
			case "OpenLong":
				set("OpenLong",true);
				local.tradeType = "OpenLong";
				local.tracker1.TradeDescription = local.tradeType;
			break;
			case "OpenShort":
				set("OpenShort",true);
				local.tradeType = "OpenShort";
				local.tracker1.TradeDescription = local.tradeType;
			break;
			case "CloseLong":
				set("CloseLong",true);
				local.tradeType = "CloseLong";
				local.tracker1.TradeDescription = local.tradeType;
			break;
			case "CloseShort":
				set("CloseShort",true);
				local.tradeType = "CloseShort";
				local.tracker1.TradeDescription = local.tradeType;
			break;
			case "OpenLongCloseShort":
				set("OpenLongCloseShort",true);
				local.tradeType = "OpenLongCloseShort";
				local.tracker1.TradeDescription = local.tradeType;
			break;
			case "OpenShortCloseLong":
				set("OpenShortCloseLong",true);
				local.tradeType = "OpenShortCloseLong";
				local.tracker1.TradeDescription = local.tradeType;
			break;
			}
				
		if(local.tradeType NEQ "")
		{
		local.trade1 = Duplicate(variables.trade);
		local.trade1.date = arguments.DataBeanToday.get("Date");
		local.trade1.TradeDescription = local.tradeType;
		local.trade1.TradePrice = arguments.DataBeanToday.get("Close") ;
		local.nextindex = variables.tradeHistory.size();
		variables.tradeHistory[local.nextindex+1] = local.trade1;
		}
		
		local.nextindex1 = variables.trackHistory.size();
		variables.trackHistory[local.nextindex1+1] = local.tracker1;
		return;
		</cfscript>
	</cffunction>	
	
	<cffunction name="RecordTrades" description="" access="public" displayname="" output="false" returntype="Any">
		<cfargument name="DataBeanToday" required="true" />
		<cfscript>
		var local = StructNew();
		//dump(arguments.dataBeanToday.getMemento());
		// open long alert places a long trade if condition is met
		// the condition is part of the system
		// process exisiting trades
		if(get("OpenLong") /* AND NOT get("LongPosition") */ )
		{
		local.trade1 = Duplicate(variables.trade);
		set("LongPosition",true);
		local.trade1.date = arguments.DataBeanToday.get("Date");
		local.trade1.TradeDescription = "Open Long position";
		local.trade1.TradeEntryExitPoint = "R1: #get("R1")# high:#arguments.DataBeanToday.get("high")#" ;
		// todo:fix 
		local.trade1.TradePrice = arguments.DataBeanToday.get("R1");
		local.nextindex = variables.tradeHistory.size();
		variables.tradeHistory[local.nextindex+1] = local.trade1;
		}
		if(get("OpenShort") /* AND NOT get("OpenShort") */)
		{
		local.trade2 = Duplicate(variables.trade);
		set("ShortPosition",true);
		local.trade2.date = arguments.DataBeanToday.get("Date");
		local.trade2.TradeDescription = "Open Short position";
		local.trade2.TradeEntryExitPoint = "S1: #get("S1")# low:#arguments.DataBeanToday.get("low")#";
		local.trade2.TradePrice = arguments.DataBeanToday.get("S1");
		local.nextindex = variables.tradeHistory.size();
		variables.tradeHistory[local.nextindex+1] = local.trade2;
		}
		if(get("CloseLong") )
		{
		local.trade3 = Duplicate(variables.trade);
		set("OpenLong",false);
		set("LongPosition",false);
		local.trade3.date = arguments.DataBeanToday.get("Date");
		local.trade3.TradeDescription = "Close Long position";
		local.trade3.TradeEntryExitPoint = "S1";
		local.trade3.TradePrice = arguments.DataBeanToday.get("S1");
		local.nextindex = variables.tradeHistory.size();
		variables.tradeHistory[local.nextindex+1] = local.trade3;
		}
		if(get("CloseShort") )
		{
		local.trade4 = Duplicate(variables.trade);
		set("OpenShort",false);
		set("ShortPosition",false);
		local.trade4.date = arguments.DataBeanToday.get("Date");
		local.trade4.tradeDescription = "Close Short position";
		local.trade4.tradeEntryExitPoint = "R1";
		local.trade4.TradePrice = arguments.DataBeanToday.get("R1");
		local.nextindex = variables.tradeHistory.size();
		variables.tradeHistory[local.nextindex+1] = local.trade4;
		}
		
		return;
		</cfscript>
	</cffunction>	
	
	<cffunction name="Dump" description="utility" access="public" displayname="test" output="false" returntype="Any">
		<cfargument name="object" required="true" />
		<cfdump label="bean:" var="#arguments.object#">
		<cfabort>
	</cffunction>
		
</cfcomponent>