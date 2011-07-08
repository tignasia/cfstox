<cfcomponent  displayname="systemRunner" hint="I test systems using given data" output="false">

	<cffunction name="init" description="init method" access="public" displayname="init" output="false" returntype="systemRunner">
		<!--- persistent variable to store trades and results --->
		<cfset variables.trackHighLows = StructNew() />
		<cfset variables.tradeArray = ArrayNew(2) />
		<cfset variables.BeanArray = arraynew(1) />
		<cfset variables.HiLoBeanArray = arraynew(1) />
		<cfreturn this/>
	</cffunction>
	
	<cffunction name="reset" description="init method" access="public" displayname="init" output="false" returntype="void">
		<!--- persistent variable to store trades and results --->
		<cfscript>
		variables.trackHighLows = StructNew(); 
		variables.tradeArray = ArrayNew(2);
		variables.BeanArray = arraynew(1); 
		variables.HiLoBeanArray = arraynew(1);
		session.objects.system.reset();
		return; 
		</cfscript>
	</cffunction>
	
	<cffunction name="TestSystem" description="called from SystemService.RunSystem" access="public" displayname="" output="false" returntype="Any">
		<cfargument name="qryDataHA" required="true" />
		<cfargument name="qryDataOriginal" required="true" />
		<cfargument name="SystemName" required="true" />
		<cfargument name="summary" 	 required="false" default="true" />
		<!---  
		DataBean: stores data for a particular date, actions defined by system
		TrackingBean: tracks the previous status of the stock ie preev high/low, R1, S1
		TradeBean: resp for trading based on flags in the databean
		--->
		<cfscript>
		var local = StructNew();	
		//var local = InitTestSystem(argumentCollection:arguments);
		// load with data so doesnt error
		local.strData = session.objects.Utility.QrytoStruct(query:arguments.qryDataOriginal,rownumber:1);
		//dump(local.strData);
		local.Beans = StructNew(); 		
		local.Beans.Databeans = StructNew(); 		
		local.Beans.TrackingBean 	= createObject("component","cfstox.model.TrackingBean").init(local.strData);
		local.Beans.TradeBean 	= createObject("component","cfstox.model.TradeBean").init(local.strData);
		</cfscript>
		<cfloop  query="arguments.qryDataHA" startrow="5">
			<cfscript>
			//array five data beans 
			//todo: use one data bean to store original and HA data
			//todo: fix currentrow 
			local.Beans.Databeans.HA_DataBeans = SetupTestData(qryData:arguments.qryDataHA);
			local.Beans.Databeans.Original_DataBeans = SetupTestData(qryData:arguments.qryDataOriginal);
			</cfscript>
			<cfinvoke component="#session.objects.system#" method="Open_Long_R2_Break"  argumentcollection="#local.Beans#"  returnvariable="DataBeanToday" /> 
			<!--- <cfset ProcessTrackingBean(TrackingBean:local.TrackingBean,dataBeans:DataBeans) /> --->
			<!--- <cfset arguments.trackingBean.processDailyData(DataBeanToday) /> --->
			<cfscript>
			local.Beans.TradeBean.ProcessTrades(DataBeanToday);
			</cfscript>
		</cfloop>
		<cfreturn local.Beans.TradeBean />
	</cffunction>
	
	<cffunction name="InitTestSystem" description="called from SystemService.RunSystem" access="public" displayname="" output="false" returntype="Any">
		<cfargument name="qryDataHA" required="true" />
		<cfargument name="qryDataOriginal" required="true" />
		<cfargument name="SystemName" required="true" />
		<cfargument name="summary" 	 required="false" default="false" />
		<cfscript>
		var local = structNew();
		reset();
		local.bResult = false;
		local.dataArray = ArrayNew(1);
		local.dataArrayHA = ArrayNew(1);
		local.dataArrayOriginal = ArrayNew(1);
		local.DataArrayHA[1] = session.objects.Utility.QrytoStruct(query:arguments.qryDataHA,rownumber:1);
		local.DataArrayOriginal[1] = session.objects.Utility.QrytoStruct(query:arguments.qryDataOriginal,rownumber:1);
		// the trackingbean saves the system state ie if we are long 
		if(arguments.summary){
		local.startrow = arguments.qryDataHA.recordcount - 14;
		}
		else{
		local.startrow =5;
		}
		</cfscript>
		<cfreturn local />
	</cffunction>
	
	<cffunction name="SetupTestData" description="sets up data elements" access="public" displayname="" output="false" returntype="Any">
		<cfargument name="qryData" required="true" />
		<cfscript>
		var data = structNew();
		data.dataArray = ArrayNew(1);
		data.rowcount = arguments.qryData.currentrow;
		/* for x = 1 to x = 5  */
		data.DataArray[5] = session.objects.Utility.QrytoStruct(query:arguments.qryData,rownumber:data.rowcount-4);
		data.DataArray[4] = session.objects.Utility.QrytoStruct(query:arguments.qryData,rownumber:data.rowcount-3);
		data.DataArray[3] = session.objects.Utility.QrytoStruct(query:arguments.qryData,rownumber:data.rowcount-2);
		data.DataArray[2] = session.objects.Utility.QrytoStruct(query:arguments.qryData,rownumber:data.rowcount-1);
		data.DataArray[1] = session.objects.Utility.QrytoStruct(query:arguments.qryData,rownumber:data.rowcount);
		data.DataBean4 = createObject("component","cfstox.model.DataBean").init(data.DataArray[5]);
		data.DataBean3 = createObject("component","cfstox.model.DataBean").init(data.DataArray[4]); 
		data.DataBean2 = createObject("component","cfstox.model.DataBean").init(data.DataArray[3]); 
		data.DataBean1 = createObject("component","cfstox.model.DataBean").init(data.DataArray[2]);  
		data.DataBeanToday 	= createObject("component","cfstox.model.DataBean").init(data.DataArray[1]); 
		//dump(data.DataArray[1],true);
		//dump(data.DataBeanToday.getMemento(),true); 
		</cfscript>
		<cfreturn data />
	</cffunction>
	
	<cffunction name="RunBreakOutReport"description="called from SystemService.RunBreakOutReport" access="public" displayname="" output="false" returntype="Any">
		<cfargument name="qryData" required="true" />
		<!--- only run for recent activity. false for backtesting --->
		<cfargument name="summary" 	 required="false" default="false" />
		<cfscript>
		var local = structNew();
		reset();
		session.objects.system.reset();
		local.boolResult = false;
		local.dataArray = ArrayNew(1);
		local.highLowArray = ArrayNew(2);
		local.arrayCount = 1;
		local.DataArray[1] = session.objects.Utility.QrytoStruct(query:arguments.qryData,rownumber:1);
		local.TrackingBean 	= createObject("component","cfstox.model.TrackingBean").init(); 
		local.DataBean2 = createObject("component","cfstox.model.TradeBean").init(local.DataArray[1]); 
		local.DataBean1 = createObject("component","cfstox.model.TradeBean").init(local.DataArray[1]); 
		local.DataBeanToday 	= createObject("component","cfstox.model.TradeBean").init(local.DataArray[1]);
		local.newLocalHigh = false;
		local.newLocalLow = false; 
		if(arguments.summary){
		local.startrow = arguments.qryData.recordcount - 7; 
		}
		else{
		local.startrow = 3;
		}
		// init the tracking bean
		local.DataArray[1] = session.objects.Utility.QrytoStruct(query:arguments.qryData,rownumber:local.startrow);
		local.trackingBean.Set("PreviousLocalHigh",local.DataArray[1].High);
		local.trackingBean.Set("PreviousLocalLow",local.DataArray[1].Low);
		local.trackingBean.Set("PreviousLocalHighDate",local.DataArray[1].DateOne);
		local.trackingBean.Set("PreviousLocalLowDate",local.DataArray[1].DateOne);
		</cfscript>
		<!--- 
		so we set our inital settings
		we get a new high so we reset the prevhigh;	prevlow stays in place
		we start dropping and bounce off the drop; 
			record the prev high
			record the prev low
			reset prev low
		--->
		<cfloop  query="arguments.qryData" startrow="#local.startrow#">
			<cfscript>
			local.rowcount = arguments.qryData.currentrow;
			local.DataArray[1] = session.objects.Utility.QrytoStruct(query:arguments.qryData,rownumber:local.rowcount-2);
			local.DataArray[2] = session.objects.Utility.QrytoStruct(query:arguments.qryData,rownumber:local.rowcount-1);
			local.DataArray[3] = session.objects.Utility.QrytoStruct(query:arguments.qryData,rownumber:local.rowcount);
			local.DataBean2 = createObject("component","cfstox.model.TradeBean").init(local.DataArray[1]); 
			local.DataBean1 = createObject("component","cfstox.model.TradeBean").init(local.DataArray[2]); 
			local.DataBeanToday 	= createObject("component","cfstox.model.TradeBean").init(local.DataArray[3]); 
			session.objects.system.System_BreakOut(local.DataBean1,local.DataBeanToday);
			session.objects.system.System_NewHighLow(local.DataBean2,local.DataBean1,local.DataBeanToday);
			if(local.DataBeanToday.Get("NewHigh") AND local.trackingBean.Get("PreviousLocalHigh") LT local.DataBeanToday.Get("High") )
			{//set new local low flag so we dont keep flagging it
				//local.trackingBean.Set("PreviousLocalHigh",local.DataBeanToday.Get("High"));
				//local.trackingBean.Set("PreviousLocalHighDate",local.DataBeanToday.Get("Date"));
				if (NOT local.newLocalLow)
				{
				local.highLowArray[local.arrayCount][1] = "Breakout";
				local.highLowArray[local.arrayCount][2] = "PreviousLocalHigh";
				local.highLowArray[local.arrayCount][3] = local.trackingBean.Get("PreviousLocalHigh");
				local.highLowArray[local.arrayCount][4] = "PreviousLocalHighDate";
				local.highLowArray[local.arrayCount][5] = local.trackingBean.Get("PreviousLocalHighDate");
				local.highLowArray[local.arrayCount][6] = local.DataBeanToday.Get("High");
				local.highLowArray[local.arrayCount][7] = local.DataBeanToday.Get("Date");
				local.arrayCount = local.arrayCount + 1; 
				}
			local.newLocalhigh = false;
			local.newLocallow = true;		
			}
			if(local.DataBeanToday.Get("NewLow") AND local.trackingBean.Get("PreviousLocalLow") GT local.DataBeanToday.Get("Low"))
			{//set new local high flag so we dont keep flagging it
				//local.trackingBean.Set("PreviousLocalLow",local.DataBeanToday.Get("Low"));
				//local.trackingBean.Set("PreviousLocalLowDate",local.DataBeanToday.Get("Date"));
				if (NOT local.newLocalHigh)
				{
				local.highLowArray[local.arrayCount][1] = "Breakdown";
				local.highLowArray[local.arrayCount][2] = "PreviousLocalLow";
				local.highLowArray[local.arrayCount][3] = local.trackingBean.Get("PreviousLocalLow");
				local.highLowArray[local.arrayCount][4] = "PreviousLocalLowDate";
				local.highLowArray[local.arrayCount][5] = local.trackingBean.Get("PreviousLocalLowDate");
				local.highLowArray[local.arrayCount][6] = local.DataBeanToday.Get("Low");
				local.highLowArray[local.arrayCount][7] = local.DataBeanToday.Get("Date");
				local.arrayCount = local.arrayCount + 1; 
				}
			local.newLocalhigh = true;
			local.newLocallow = false;		
			}
			if(local.DataBeanToday.Get("NewHighReversal") )
			{//set new local low flag so we dont keep flagging it
				local.trackingBean.Set("PreviousLocalHigh",local.DataBean1.Get("High"));
				local.trackingBean.Set("PreviousLocalHighDate",local.DataBean1.Get("Date"));
			}
			
			if(local.DataBeanToday.Get("NewLowReversal") )
			{//set new local high flag so we dont keep flagging it
				local.trackingBean.Set("PreviousLocalLow",local.DataBean1.Get("Low"));
				local.trackingBean.Set("PreviousLocalLowDate",local.DataBean1.Get("Date"));
			}
			</cfscript> 
		</cfloop>
		<cfreturn local.highLowArray />
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

	<cffunction name="Dump" description="utility" access="public" displayname="test" output="false" returntype="Any">
		<cfargument name="object" required="true" />
		<cfargument name="abort" required="false"  default="true"/>
		<cfdump label="bean:" var="#arguments.object#">
		<cfif arguments.abort>
			<cfabort>
		</cfif>
	</cffunction>
	
</cfcomponent>