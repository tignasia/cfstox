<cfcomponent  displayname="systemconditions" hint="I store the actual systems" output="false">

	<cffunction name="init" description="init method" access="public" displayname="init" output="false" returntype="system">
		<!--- persistent variable to store trades and results --->
		<cfreturn this/>
	</cffunction>
		
	<cffunction name="reset" description="init method" access="public" displayname="init" output="false" returntype="system">
		<!--- persistent variable to store trades and results --->
		<cfreturn this/>
	</cffunction>
	
	<cffunction name="RunSystem" description="runs the specified system" access="public" displayname="test" output="false" returntype="Any">
		<cfargument name="Beans" required="true" />
		<cfargument name="SystemName" required="true" />
		<cfscript>
		var local = structNew();
		local.beans = SetTrades(Beans:Arguments.Beans, systemName:Arguments.systemName); 	
		return local.beans;
		</cfscript>
	</cffunction>
	
	<cffunction name="SetTrades" description="run the system" access="private" displayname="SetTrades" output="false" returntype="Any">
		<cfargument name="Beans" required="true" />
		<cfargument name="SystemName" required="true" />
		<!--- 
		arguments.beans.TrackingBean 
		arguments.beans.TradeBean
		arguments.beans.Databeans.DataBeanToday
		arguments.beans.Databeans.DataBean1
		--->
		<cfset var local = StructNew() />
		<cfscript>
		local.HKdatabeantoday 	= arguments.beans.Databeans.HA_DataBeans.DataBeanToday;
		local.HKbeans 			= arguments.beans.Databeans.HA_DataBeans;
		local.databeantoday 	= arguments.beans.Databeans.original_databeans.DataBeanToday;
		local.beans 			= arguments.beans.Databeans.original_databeans;
		local.TrackingBean 		= arguments.beans.TrackingBean;
		local.triggers 			= StructNew();
		local.triggers.boolOpenShort 	= false;
		local.triggers.boolCloseShort 	= false;
		local.triggers.boolOpenLong 	= false;
		local.triggers.boolCloseLong 	= false;
		local.triggers.ShortEntryPoint 	= "";
		local.triggers.ShortExitPoint 	= "";
		local.triggers.LongEntryPoint 	= "";
		local.triggers.LongExitPoint 	= "";		
		</cfscript>
		<cfinvoke method="#arguments.SystemName#"  argumentcollection="#local#"  returnvariable="triggers" />
		<cfscript>
		local.strStatus = StructNew();
		local.strStatus.initialStatus = arguments.beans.TrackingBean.Get("Status");
		SetEntryExit(beans:local.beans,triggers:local.triggers);			
		if (arguments.beans.TrackingBean.Get("Status") EQ "Short" AND local.triggers.boolCloseShort)
		{	// short exit
			local.databeantoday.Set("TradeType","CloseShort");	
			arguments.beans.TrackingBean.Set("Status","");
			local.strStatus.Status1 = arguments.beans.TrackingBean.Get("Status");
		}
				
		if (local.strStatus.initialStatus EQ "" AND NOT triggers.boolCloseShort AND local.triggers.boolOpenShort)
		{ // short entry
			local.databeantoday.Set("tradeType","OpenShort");	
			arguments.beans.TrackingBean.Set("Status","Short");
			local.strStatus.Status2 = arguments.beans.TrackingBean.Get("Status");
		}
		
		if (arguments.beans.TrackingBean.Get("Status") EQ "Long" AND triggers.boolCloseLong)
			{ //long exit
			local.databeantoday.Set("TradeType","CloseLong");	
			arguments.beans.TrackingBean.Set("Status","");
			local.strStatus.Status3 = arguments.beans.TrackingBean.Get("Status");
			}
			
		if (arguments.beans.TrackingBean.Get("Status") EQ "" AND NOT triggers.boolCloseLong AND triggers.boolOpenLong)
			{
			local.databeantoday.Set("TradeType","OpenLong");	
			arguments.beans.TrackingBean.Set("Status","Long");
			local.strStatus.Status4 = arguments.beans.TrackingBean.Get("Status");
			}
		
		// check for close long and open short
		if (triggers.boolOpenLong AND triggers.boolCloseShort AND arguments.beans.TrackingBean.Get("Status") NEQ "Long")
		{
		local.databeantoday.Set("TradeType","OpenLongCloseShort");	
		arguments.beans.TrackingBean.Set("Status","Long");
		local.strStatus.Status5 = arguments.beans.TrackingBean.Get("Status");
		} 
			// check for close long and open short 
		if (triggers.boolOpenShort AND triggers.boolCloseLong AND arguments.beans.TrackingBean.Get("Status") NEQ "Short")
		{
		local.databeantoday.Set("TradeType","OpenShortCloseLong");	
		arguments.beans.TrackingBean.Set("Status","Short");
		local.strStatus.Status6 = arguments.beans.TrackingBean.Get("Status");
		}
		
		if (local.strStatus.initialStatus EQ arguments.beans.TrackingBean.Get("Status"))
		{
			local.tradelength = arguments.beans.TrackingBean.Get("Tradelength");
			arguments.beans.TrackingBean.Set("Tradelength",local.tradelength + 1);
		}
		else
		{
		arguments.beans.TrackingBean.Set("Tradelength",0);
		}
		local.databeantoday.Set("TBStatusChange",local.strStatus);			
		</cfscript>
		<cfreturn local.databeantoday />	
	</cffunction>
	
	<cffunction name="ShortEntryRVBD" description="Max profit from riverbed drops" access="public" displayname="test" output="false" returntype="Any">
		<!--- system description:  
		high relative to mean
		close less than open - red candle previous day
		entry less than prev low
		CCI values 74, 83, 74, 122
		RSI values 47, 49, 62, 63 
		LRI 22 24 29 28
		LR slope < prev linear reg slope
		local high 
		R1 break    
		--->
		<cfargument name="triggers" required="true" />
		<cfargument name="beans" required="true" />
		<cfscript>
		var local = StructNew();
		local.triggers 	=	arguments.triggers;
		local.beans 	=	arguments.Beans;	
		local.triggers.boolCloseShort = session.objects.SystemTriggers.PreviousHighBreak(beans:local.beans);
		local.triggers.boolOpenShort = session.objects.SystemTriggers.LRS10setup(beans:local.beans);
		local.triggers.boolOpenShort = session.objects.SystemTriggers.S1Break(beans:local.beans);
		//local.triggers.boolCloseLong = session.objects.SystemTriggers.CCICrossDown(beans:beans);
		//local.triggers.boolOpenLong = session.objects.SystemTriggers.CCIOverSold(beans:beans);
		//if (local.triggers.boolOpenLong){
		//local.triggers.boolOpenLong = session.objects.SystemTriggers.PreviousHighBreak(beans:local.Beans);
		//}
		return local.triggers;
		</cfscript> 
	</cffunction>
	
	<cffunction name="PivotSystem" description="System based on piviot points" access="private" displayname="PivotSystem" output="false" returntype="Any">
		<!--- system description:  
		short entry:
		high previously above R2
		break below previous s2
		short exit:
		break above previous r1  
		--->
		<cfargument name="triggers" required="true" />
		<cfargument name="beans" required="true" />
		<cfscript>
		var local = StructNew();
		local.triggers 	=	arguments.triggers;
		local.beans 	=	arguments.Beans;
		//local.triggers.boolCloseShort = session.objects.SystemTriggers.PreviousHighBreakP50(beans:local.beans);
		local.triggers.boolCloseShort = session.objects.SystemTriggers.PivotBreak(beans:local.beans,PivotPoint:"R1");
		//local.triggers.boolOpenShort = session.objects.SystemTriggers.CheckR2Status(beans:local.beans);
		//if (local.triggers.boolOpenShort){
		local.triggers.boolOpenShort = session.objects.SystemTriggers.S2Break(beans:local.beans);
		//}
		if (local.triggers.boolOpenShort){
			local.triggers.ShortEntryPoint 	= "S2_1";
		}
		if (local.triggers.boolCloseShort){
			local.triggers.ShortExitPoint 	= "R1_1";	
		}
		return local.triggers;
		</cfscript> 
	</cffunction>
	
	<cffunction name="TestSystemABX" description="Used as test system as part of unit tests" access="private" displayname="TestSystem" output="false" returntype="Any">
		<cfargument name="Beans" required="true" />
		<cfset var local = StructNew() />
		<cfscript>
		// local.TestData = this.SystemService.SetupSystem(systemName:"TestSystemABX",qryData:this.data);
		//	local.Results = this.SystemService.FindTrades(qryData:this.data,TestData:local.TestData	);
		local.databeantoday = arguments.beans.Databeans.original_databeans.DataBeanToday;
		local.boolGoShort = false;
		// <!--- entry filter:  ----->
		local.boolGoShort = session.objects.SystemTriggers.CCIOverbought(beans:arguments.Beans.DataBeans.Original_DataBeans);
		if (local.boolGoShort) 
		{
		local.databeantoday.Set("OpenShort",true);
		}
		// <!--- open trade condition:  ----->
		// <!--- stop loss condition:  ----->
		// <!--- exit condition:  ----->
		</cfscript>
		<cfreturn local.databeantoday />
	</cffunction>
	
	<cffunction name="CCISystem" description="" access="private" displayname="CCISystem" output="false" returntype="Struct">
		<cfargument name="triggers" required="true" />
		<cfargument name="beans" required="true" />
		<cfscript>
		var local = StructNew();
		local.triggers = arguments.triggers;
		local.beans =    arguments.Beans;	
		local.triggers.boolCloseShort = session.objects.SystemTriggers.PreviousHighBreak(beans:local.beans);
		local.triggers.boolOpenShort = session.objects.SystemTriggers.CCIOverbought(beans:local.beans);
		if (local.triggers.boolOpenShort){
		local.triggers.boolOpenShort = session.objects.SystemTriggers.PreviousLowBreak(beans:local.Beans);
		}
		//local.triggers.boolCloseLong = session.objects.SystemTriggers.CCICrossDown(beans:beans);
		//local.triggers.boolOpenLong = session.objects.SystemTriggers.CCIOverSold(beans:beans);
		//if (local.triggers.boolOpenLong){
		//local.triggers.boolOpenLong = session.objects.SystemTriggers.PreviousHighBreak(beans:local.Beans);
		//}
		return local.triggers;
		</cfscript> 
	</cffunction>
	
	
	
	<cffunction name="HeikenAshiPivotSystem" description="System based on piviot points" access="private" displayname="PivotSystem" output="false" returntype="Any">
		<!--- system description:  
		short entry:
		high previously above R2
		break below previous s2
		short exit:
		break above previous r1  
		--->
		<cfargument name="triggers" required="true" />
		<cfargument name="beans" required="true" />
		<cfargument name="HKdatabeantoday" required="true" />
		<cfargument name="HKbeans" required="true" />
		<cfscript>
		var local = StructNew();
		local.triggers 	=	arguments.triggers;
		local.beans 	=	arguments.Beans;
		//close short position if high > previous pivot point 
		local.triggers.boolCloseShort = session.objects.SystemTriggers.CheckHKStops(beans:local.beans,PivotPoint:"R1");
		// enter short position if previous HK candle is red and s1 broken 
		local.triggers.boolOpenShort = session.objects.SystemTriggers.HKTrendchange(HKdatabeantoday:arguments.HKdatabeantoday,HKbeans:arguments.HKbeans,Position:"Short");
		if (local.triggers.boolOpenShort){
			local.triggers.boolOpenShort = session.objects.SystemTriggers.CheckHKStops(beans:local.beans,PivotPoint:"S1");
		}
		
		if (local.triggers.boolOpenShort){
			local.triggers.ShortEntryPoint 	= "S1_1";
		}
		if (local.triggers.boolCloseShort){
			local.triggers.ShortExitPoint 	= "PP";	
		}
		return local.triggers;
		</cfscript> 
	</cffunction>
	
	<cffunction name="SetEntryExit" description="" access="private" displayname="CCISystem" output="false" returntype="Struct">
		<cfargument name="triggers" required="true" />
		<cfargument name="beans" required="true" />
		<cfscript>
		var local = StructNew();
		//</cfscript>
		//<cfdump label="beans" var="#arguments.beans#">
		//<cfabort>
		//<cfscript> 
		local.triggers 	= arguments.triggers;
		local.beans 	=    arguments.Beans;	
		local.TradePrice 	= "";
			
		if(local.triggers.ShortEntryPoint NEQ "")
		{
		local.TradePrice = local.triggers.ShortEntryPoint;
		}
		if(local.triggers.ShortExitPoint NEQ "")
		{
		local.TradePrice = local.triggers.ShortExitPoint;
		}
		if(local.triggers.LongEntryPoint NEQ "")
		{
		local.TradePrice = local.triggers.LongEntryPoint;
		}
		if(local.triggers.LongExitPoint NEQ "")
		{
		local.TradePrice = local.triggers.LongExitPoint;
		}
		
		switch(local.TradePrice){
			case "R2_1":
			arguments.Beans.DatabeanToday.Set("TradePrice", arguments.beans.DataBean1.get("R2") );
			break;
			case "R2p5_1":
			arguments.Beans.DatabeanToday.Set("TradePrice", arguments.beans.DataBean1.get("R2") + .50 );
			break;
			case "R1_1":
			arguments.Beans.DatabeanToday.Set("TradePrice", arguments.beans.DataBean1.get("R1") );
			break;
			case "S2_1":
			arguments.Beans.DatabeanToday.Set("TradePrice", arguments.beans.DataBean1.get("S2") );
			break;
			case "S1_1":
			arguments.Beans.DatabeanToday.Set("TradePrice", arguments.beans.DataBean1.get("S1") );
			break;
			case "H_1":
			arguments.Beans.DatabeanToday.Set("TradePrice", arguments.beans.DataBean1.get("High") );
			break;
			case "PP":
			arguments.Beans.DatabeanToday.Set("TradePrice", arguments.beans.DataBean1.get("PP") );
			break;
			}
		return local.triggers;
		</cfscript> 
	</cffunction>
	
	<cffunction name="ShortAMZN" description="Go Short AMZN when overbought and drops" access="private" displayname="ShortAMZN" output="false" returntype="Any">
		<cfargument name="Beans" required="true" />
		<!--- 
		arguments.beans.TrackingBean 
		arguments.beans.TradeBean
		arguments.beans.Databeans.DataBeanToday
		arguments.beans.Databeans.DataBean1
		--->
		<cfset var local = StructNew() />
		<!--- 
		arguments.beans.TrackingBean 
		arguments.beans.TradeBean
		arguments.beans.Databeans.DataBeanToday
		arguments.beans.Databeans.DataBean1
		
		todo:need system processing seperate from triggers 
		--->
		<cfscript>
		local.databeantoday 	= arguments.beans.Databeans.original_databeans.DataBeanToday;
		local.boolOpenShort 	= false;
		local.boolCloseShort 	= false;
		local.boolOpenLong 		= false;
		local.boolCloseLong 	= false;
		// SHORT 
			
		local.strStatus = StructNew();
		local.strStatus.initialStatus = arguments.beans.TrackingBean.Get("Status");
					
		if (arguments.beans.TrackingBean.Get("Status") EQ "Short")
		{
			local.boolCloseShort = session.objects.SystemTriggers.CCICrossUp(beans:arguments.Beans.DataBeans.Original_DataBeans);
		} 
			// exit
			if (local.boolCloseShort) 
			{
			local.databeantoday.Set("TradeType","CloseShort");	
			local.databeantoday.Set("CloseShort",true);
			arguments.beans.TrackingBean.Set("Status","");
			local.strStatus.Status1 = arguments.beans.TrackingBean.Get("Status");
			}
		
		// <!--- entry filter: Overbought ----->
		// If we are not already short 
		if (arguments.beans.TrackingBean.Get("Status") EQ "" AND NOT local.boolCloseShort)
		{
		local.boolOpenShort = session.objects.SystemTriggers.CCIOverbought(beans:arguments.Beans.DataBeans.Original_DataBeans);
		} 
		If (local.boolOpenShort AND session.objects.SystemTriggers.PreviousLowBreak(beans:arguments.Beans.DataBeans.Original_DataBeans))
			{
			local.databeantoday.Set("tradeType","OpenShort");	
			arguments.beans.TrackingBean.Set("Status","Short");
			local.strStatus.Status2 = arguments.beans.TrackingBean.Get("Status");
			}

		// LONG
		if (arguments.beans.TrackingBean.Get("Status") EQ "Long")
		{
			local.boolCloseLong = session.objects.SystemTriggers.CCICrossDown(beans:arguments.Beans.DataBeans.Original_DataBeans);
		} 
			// exit
			if (local.boolCloseLong) 
			{
			local.databeantoday.Set("TradeType","CloseLong");	
			arguments.beans.TrackingBean.Set("Status","");
			local.strStatus.Status3 = arguments.beans.TrackingBean.Get("Status");
			}
		
		// <!--- entry filter: Overbought ----->
		// If we are not already short 
		if (arguments.beans.TrackingBean.Get("Status") EQ "" AND NOT local.boolCloseLong)
		{
		local.boolOpenLong = session.objects.SystemTriggers.CCIOverSold(beans:arguments.Beans.DataBeans.Original_DataBeans);
		} 
			if (local.boolOpenLong) 
			{
			local.databeantoday.Set("TradeType","OpenLong");	
			arguments.beans.TrackingBean.Set("Status","Long");
			local.strStatus.Status4 = arguments.beans.TrackingBean.Get("Status");
			}
		
		// check for close long and open short
		if (local.boolOpenLong AND local.boolCloseShort)
		{
		local.databeantoday.Set("TradeType","OpenLongCloseShort");	
		arguments.beans.TrackingBean.Set("Status","Long");
		local.strStatus.Status5 = arguments.beans.TrackingBean.Get("Status");
		} 
		
		// check for close long and open short 
		if (local.boolOpenShort AND local.boolCloseLong)
		{
		local.databeantoday.Set("TradeType","OpenShortCloseLong");	
		arguments.beans.TrackingBean.Set("Status","Short");
		local.strStatus.Status6 = arguments.beans.TrackingBean.Get("Status");
		}
		
		local.databeantoday.Set("TBStatusChange",local.strStatus);			
		</cfscript>
		<cfreturn local.databeantoday />	
	</cffunction>
	
	<cffunction name="ShortDates" description="test of entries and exits using dates" access="private" displayname="ShortAMZN" output="false" returntype="Any">
		<cfargument name="Beans" required="true" />
		<!--- 
		arguments.beans.TrackingBean 
		arguments.beans.TradeBean
		arguments.beans.Databeans.DataBeanToday
		arguments.beans.Databeans.DataBean1
		--->
		<cfset var local = StructNew() />
		<cfscript>
		local.databeantoday = arguments.beans.Databeans.original_databeans.DataBeanToday;
		local.boolOpenShort = false;
		local.boolCloseShort = false;
		local.boolOpenLong = false;
		local.boolCloseLong = false;
		// SHORT 
		if (arguments.beans.TrackingBean.Get("Status") EQ "Short")
		{
			local.boolCloseShort = session.objects.SystemTriggers.ExitShortDates(beans:arguments.Beans.DataBeans.Original_DataBeans);
		} 
			// exit
			if (local.boolCloseShort) 
			{
			local.databeantoday.Set("CloseShort",true);
			arguments.beans.TrackingBean.Set("Status","");
			}
		
		// <!--- entry filter: Overbought ----->
		// If we are not already short 
		if (arguments.beans.TrackingBean.Get("Status") EQ "" AND NOT local.boolCloseShort)
		{
		local.boolOpenShort = session.objects.SystemTriggers.EntryShortDates(beans:arguments.Beans.DataBeans.Original_DataBeans);
		} 
			if (local.boolOpenShort) 
			{
			local.databeantoday.Set("OpenShort",true);
			arguments.beans.TrackingBean.Set("Status","Short");
			}
		
		// LONG
		if (arguments.beans.TrackingBean.Get("Status") EQ "Long")
		{
			local.boolCloseLong = session.objects.SystemTriggers.ExitLongDates(beans:arguments.Beans.DataBeans.Original_DataBeans);
		} 
			// exit
			if (local.boolCloseLong) 
			{
			local.databeantoday.Set("CloseLong",true);
			arguments.beans.TrackingBean.Set("Status","");
			}
		
		// <!--- entry filter: Overbought ----->
		// If we are not already short 
		if (arguments.beans.TrackingBean.Get("Status") EQ "" AND NOT local.boolCloseLong)
		{
		local.boolOpenLong = session.objects.SystemTriggers.EntryLongDates(beans:arguments.Beans.DataBeans.Original_DataBeans);
		} 
			if (local.boolOpenLong) 
			{
			local.databeantoday.Set("OpenLong",true);
			arguments.beans.TrackingBean.Set("Status","Long");
			}		
		</cfscript>
		<cfreturn local.databeantoday />
	</cffunction>
	
	<cffunction name="ShortEntryLSRSys1" description="drop when LR is positive - overbought" access="public" displayname="test" output="false" returntype="Any">
		<!--- system description: stock overbought and price drops below S1 --->
		<cfargument name="Beans" required="true" />
		<cfset var local = StructNew() />
		<!--- <cfdump label="arguments" var="#arguments#">
		<cfabort> --->
		
		<cfscript>
		local.databeantoday = arguments.beans.Databeans.original_databeans.DataBeanToday;
		local.boolGoShort = false;
		// <!--- entry filter:  ----->
		local.boolGoShort = session.objects.SystemTriggers.LRS10setup(beans:arguments.Beans.DataBeans.Original_DataBeans.DataBeanToday);
		// <!--- entry criteria:  ----->
		local.boolGoShort = session.objects.SystemTriggers.S1Break(beans:arguments.Beans.Databeans.Original_DataBeans);
		if (local.boolGoShort) 
		{
		local.databeantoday.Set("OpenShort",true);
		}
		</cfscript>
		<cfreturn local.databeantoday />
	</cffunction>
	
	<cffunction name="all_long_entry" description="" access="public" displayname="test" output="false" returntype="Any">
		<!--- based on optimum trades in X - US Steel --->
		<!--- based on two down days followed by up day --->
		<cfargument name="arrDataBeans" required="true" />
		<cfset var local = StructNew() />
		<cfset local.Patterns = GetCandlePatterns(argumentcollection:arguments) />
		<cfreturn arguments.arrDataBeans />
	</cffunction>
	
	<cffunction name="long_entry_HA" description="" access="public" displayname="test" output="false" returntype="Any">
		<!--- based on optimum trades in X - US Steel --->
		<!--- based on two down days followed by up day --->
		<cfargument name="arrDataBeans" required="true" />
		<cfset var local = StructNew() />
		<cfset local.Patterns = GetCandlePatterns(argumentcollection:arguments) />
		<cfif local.Patterns.OCpattern EQ "LLH">
		</cfif> 
		<cfif local.Patterns.OCpattern EQ "HLL">
		</cfif> 
		<cfreturn arguments.arrDataBeans />
	</cffunction>
	
	<cffunction name="AKAMShort_S1entry_R1Exit" description="called from systemRunner - short w/tight stops" access="public" displayname="test" output="false" returntype="Any">
		<!--- based on optimum trades in AKAM Short --->
		<!--- based on two down days enter at break of S1 --->
		<cfargument name="DataBean3" required="true" />
		<cfargument name="DataBean2" required="true" />
		<cfargument name="DataBeanToday" required="true" />
		<cfargument name="TrackingBean" required="true" />
		<cfset var local = StructNew() />
		<!--- todo:remove and pass as argument --->
		<cfset local.Patterns = CandlePattern(TB2:DataBean3, TB1:DataBean2, TB:DataBeanToday ) />
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
	
	<cffunction name="Open_Long_R2_Break" description="high greater than R2 two days ago" access="public" displayname="test" output="false" returntype="Any">
		<cfargument name="Beans" required="true" />
		<!--- <cfargument name="Beans.DataBean4" required="true" />
		<cfargument name="Beans.DataBean3" required="true" />
		<cfargument name="Beans.DataBean2" required="true" />
		<cfargument name="Beans.DataBean1" required="true" />
		<cfargument name="Beans.DataBeanToday" required="true" />
		<cfargument name="Beans.TrackingBean" required="true" /> --->
		<cfset var local = StructNew() />
		<cfset local.up = false />
		<cfset local.reversal = false />
		<cfset local.Patterns = GetCandlePatterns(argumentcollection:arguments) />
		<!---- Open new long position  --->
		<cfif arguments.Beans.DataBeanToday.Get("HKClose") GT arguments.Beans.DataBeanToday.Get("HKOpen")
			AND Beans.DataBeanToday.Get("High") GT Beans.DataBean2.Get("R2")	>
			<cfset Beans.DataBeanToday.Set("OpenLongAlert",true) />
			<!--- <cfset Beans.DataBeanToday.Set("CloseShortAlert",true) />
		<cfelse>
			<cfset Beans.DataBeanToday.Set("OpenShortAlert",true) />
			<cfset Beans.DataBeanToday.Set("CloseLongAlert",true) /> --->
		</cfif> 
		<cfreturn Beans.DataBeanToday />
	</cffunction>
	
	<cffunction name="System_ha_longIII" description="called from systemRunner - heiken-ashi system" access="public" displayname="test" output="false" returntype="Any">
		<cfargument name="Beans" required="true" />
		<!--- <cfargument name="Beans.DataBean4" required="true" />
		<cfargument name="Beans.DataBean3" required="true" />
		<cfargument name="Beans.DataBean2" required="true" />
		<cfargument name="Beans.DataBean1" required="true" />
		<cfargument name="Beans.DataBeanToday" required="true" />
		<cfargument name="Beans.TrackingBean" required="true" /> --->
		<cfset var local = StructNew() />
		<cfset local.up = false />
		<cfset local.reversal = false />
		<cfset local.Patterns = GetCandlePatterns(argumentcollection:arguments) />
		<!---- Open new long position  --->
		<cfif arguments.Beans.DataBeanToday.Get("HKClose") GT arguments.Beans.DataBeanToday.Get("HKOpen")
			AND Beans.DataBeanToday.Get("High") GT Beans.DataBean1.Get("R1")	>
			<cfset Beans.DataBeanToday.Set("OpenLongAlert",true) />
			<!--- <cfset Beans.DataBeanToday.Set("CloseShortAlert",true) />
		<cfelse>
			<cfset Beans.DataBeanToday.Set("OpenShortAlert",true) />
			<cfset Beans.DataBeanToday.Set("CloseLongAlert",true) /> --->
		</cfif> 
		<cfif arguments.Beans.DataBeanToday.Get("HKClose") GT arguments.Beans.DataBeanToday.Get("HKOpen")
			AND Beans.DataBeanToday.Get("High") GT Beans.DataBean1.Get("R1")	>
			<cfset Beans.DataBeanToday.Set("OpenLongAlert",true) />
			<!--- <cfset Beans.DataBeanToday.Set("CloseShortAlert",true) />
		<cfelse>
			<cfset Beans.DataBeanToday.Set("OpenShortAlert",true) />
			<cfset Beans.DataBeanToday.Set("CloseLongAlert",true) /> --->
		</cfif> 
		
		<cfreturn Beans.DataBeanToday />
	</cffunction>
	
	<cffunction name="System_ha_III" description="called from systemRunner - heiken-ashi system" access="public" displayname="test" output="false" returntype="Any">
		<!--- based on optimum trades in X - US Steel --->
		<!--- based on two down days followed by up day --->
		<cfargument name="DataBean3" required="true" />
		<cfargument name="DataBean2" required="true" />
		<cfargument name="DataBeanToday" required="true" />
		<cfargument name="TrackingBean" required="true" />
		<cfset var local = StructNew() />
		<cfscript>
		local.boolGoLong = false;
		local.tb2open = arguments.DataBean3.Get("HKOpen");
		local.tb2close = arguments.DataBean3.Get("HKClose");
		local.tb1open = arguments.DataBean2.Get("HKOpen");
		local.tb1close = arguments.DataBean2.Get("HKClose");
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
		<cfargument name="DataBean3" required="true" />
		<cfargument name="DataBean2" required="true" />
		<cfargument name="DataBeanToday" required="true" />
		<cfif DataBean3.Get("HKHigh") LT DataBean2.Get("HKHigh") AND DataBeanToday.Get("HKHigh") GT DataBean2.Get("HKHigh")>		
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
		<!--- todo:experiment with using real body, shadow body, or a combination --->
		<cfif arguments.TBeanTwoDaysAgo.get("HKhigh") LT arguments.TBeanOneDayAgo.get("HKhigh") AND
				arguments.TBeanToday.Get("HKhigh") LT arguments.TBeanOneDayAgo.Get("HKhigh") >
				<cfset arguments.TBeanToday.set("NewHighReversal",true)>	
		</cfif>
		<cfif arguments.TBeanTwoDaysAgo.get("HKlow") GT arguments.TBeanOneDayAgo.get("HKlow") AND
				arguments.TBeanToday.Get("HKlow") GT arguments.TBeanOneDayAgo.Get("HKlow") >
				<cfset arguments.TBeanToday.set("NewLowReversal",true)>	
		</cfif>
	<cfreturn />
	</cffunction>
	
	<cffunction name="System_Breakout" description="I find new highs and lows" access="public" displayname="" output="false" returntype="Void">
		<cfargument name="TBeanOneDayAgo" required="true" />
		<cfargument name="TBeanToday" required="true" />
		<cfset var local = Structnew() />
		<cfif 	arguments.TBeanToday.Get("HKhigh") GT arguments.TBeanOneDayAgo.Get("HKhigh") >
				<cfset arguments.TBeanToday.set("NewHigh",true)>	
		</cfif>
		<cfif  arguments.TBeanToday.Get("HKlow") LT arguments.TBeanOneDayAgo.Get("HKlow") >
				<cfset arguments.TBeanToday.set("NewLow",true)>	
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
	
	<cffunction name="GetCandlePatterns" description="called from system - heiken-ashi system" access="public" displayname="test" output="false" returntype="Any">
		<!--- Takes TradeBeans as arguments --->
		<!--- Returns the hekien-ashi candlestick open high low and close for past 5 days--->
		<cfargument name="DataBean4" required="false" />
		<cfargument name="DataBean3" required="false" />
		<cfargument name="DataBean2" required="false" />
		<cfargument name="DataBean1" required="false" />
		<cfargument name="DataBeanToday" required="false" />
		<cfscript>
		var local = StructNew();
		local.arrDataBean = arrayNew(1);
		local.arrDataBean[1] = arguments.DataBean4;
		local.arrDataBean[2] = arguments.DataBean3;
		local.arrDataBean[3] = arguments.DataBean2;
		local.arrDataBean[4] = arguments.DataBean1;
		local.arrDataBean[5] = arguments.DataBeanToday;
		local.arrData = ArrayNew(2);
		local.strData = "HKOpen,HKHigh,HkLow,HKClose";
		
		for (local.x = 1; local.x <= 4; local.x++) { 
		try {
		local.arrData[local.x][1] =  local.arrDataBean[local.x].Get("HKClose");
		local.arrData[local.x][2] =  local.arrDataBean[local.x+1].Get("HKOpen");
			}
		catch (Any e) {
		WriteOutput("Error: " & e.message);
		dump(e.message, local.arrDataBean[local.x]);
		}
		}
		local.OCpattern = CandlePattern(local.arrData);
		//local.OpenPattern = "";
		
		for (local.xx = 1; local.xx <= 4; local.xx++) { 

			for (local.x = 1; local.x <= 3; local.x++) { 
			try {
			local.listItem = JavaCast("String",ListGetAt(local.strData,local.x));
			local.arrData[local.x][1] =  local.arrDataBean[local.x].Get("#local.listitem#");
			local.arrData[local.x][2] =  local.arrDataBean[local.x+1].Get("#local.listitem#");
			}
			catch (Any e) {
			WriteOutput("Error: " & e.message);
			dump(error:e.message, object:local.arrDataBean[local.x+1]);
			}
			}
		
			switch(local.xx){
			case 1:
			local.OpenPattern = CandlePattern(local.arrData);
			break;
			case 2:
			local.HighPattern = CandlePattern(local.arrData);
			break;
			case 3:
			local.LowPattern = CandlePattern(local.arrData);
			break;
			case 4:
			local.ClosePattern = CandlePattern(local.arrData);
			break;
			}
		}
		return local; 
		</cfscript>
	</cffunction>
	
	<cffunction name="CandlePattern" description="called from system - heiken-ashi system" access="public" displayname="test" output="false" returntype="Any">
		<!--- Takes TradeBeans as arguments --->
		<!--- Returns the hekien-ashi candlestick open high low and close for past 5 days--->
		<cfargument name="dataArray" required="true" />
		<cfscript>
		var local = StructNew();
		local.pattern = "";
		local.x = 1;
		// open-close
		for (local.x = 1; local.x <= 4; local.x++ ) {
			if(arguments.dataArray[local.x][1] GT arguments.dataArray[local.x][2]){
			local.pattern = Local.pattern & "H";
			}	   
			else {
			local.pattern = Local.pattern & "L";
			}
		}
		return local.pattern;			
		</cfscript>
	</cffunction>
	
	<cffunction name="Dump" description="utility" access="public" displayname="test" output="false" returntype="Any">
		<!--- Takes TradeBeans as arguments --->
		<!--- Returns the hekien-ashi candlestick open high low and close for past 5 days--->
		<cfargument name="error" required="true" />
		<cfargument name="object" required="true" />
		<cfdump label="error:" var="#arguments.error#">
		<cfdump label="bean:" var="#arguments.object.GetMemento()#">
		<cfabort>
	</cffunction>
</cfcomponent>