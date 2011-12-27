<cfcomponent  displayname="SystemService" output="false">
<!--- 
SystemService sets up data and calls SystemRunner 
SytemRunner Calls System, which contains system definitions
The system definitions consists of sets of triggers defined in systemTriggers
The triggers are granular conditions such as RSI above a certain amount
--->
	<cffunction name="init" description="init method" access="public" displayname="init" output="false" returntype="SystemService">
	<!--- persistent variable to store trades and results --->
		<cfreturn this/>
	</cffunction>
	
	<cffunction name="RunSystem" description="" access="public" displayname="" output="false" returntype="Any">
		<cfargument name="SystemName" required="false"  default="ShortEntryRVBD" />
		<cfargument name="qryData" required="true" />
		<cfscript>
		var local = StructNew();
		local.qryDataOriginal 		= arguments.qryData.qryDataOriginal ;
		local.qryDataHA 			= arguments.qryData.qryDataHA ;
		local.TestData			 	= SetupSystem(qryData:arguments.qryData);
		local.TestData.TradeBean.Set("SystemName",arguments.systemName);
		local.results 				= FindTrades(qryData:local,TestData:local.TestData);
		return local.results;
		</cfscript>
	</cffunction>
	
	<cffunction name="SetUpSystem" description="" access="private" displayname="" output="false" returntype="Any">
		<!---  
		We set up the data in the beans 
		then we loop over the data and populate the beans and send them to the systemRunner
		the SystemRunner checks the conditions in the system and sets flags in the bean
		SystemRunner is also responsible for recording the trades
		SystemRunner examines the flags in the bean to see if a trade has been opened or closed
		After the system is run we have a list of open and closed trades along with the
		price the trade was executed at and the profit or loss
		This is returned to the controller which passes it the reportService for output as an excel spreadsheet 
		--->
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
		<!--- todo: remove duplicate methods from systemrunner; remove systemrunner altogether--->
		
		<!---  
		1. set up the initial data
		2. send everything to testing function. loops over the data and tests system conditions
		performs action based on system conditions and current state/trades
		records actions in arrays which are appended to the orgdata query 
		actions 
		openlong, setlongentry, longstop, closelong  
		openshort, setshortentry, shortstop, closeshort
		--->
		<cfargument name="SystemName" required="false"  default="No System" />
		<cfargument name="qryData" required="true" />
		<!--- 
		databean has data for given day 
		trackingbean keeps track of state of system - persistent singleton
		tradebean keeps track of the trades and the results - this should prob be in a simple array
		--->
		<cfscript>
		var local = structnew();
		local.qryDataOriginal = arguments.qryData.qryDataOriginal ;
		local.qryDataHA = arguments.qryData.qryDataHA ;
		local.strData = session.objects.Utility.QrytoStruct(query:local.qryDataOriginal,rownumber:1);
		local.TestData = GetBeans(strData:local.strData,systemName:arguments.systemName);
		return local.testData;
		</cfscript>
	</cffunction>
	
	<cffunction name="GetBeans" description="Returns trading beans" access="private" displayname="" output="false" returntype="Struct">
		<cfargument name="strData" required="true" />
		<cfargument name="systemName" required="false" default="No System" />
		<cfscript>
		local.TestData 					= StructNew(); 		
		local.TestData.Databeans 		= StructNew(); 		
		local.TestData.TrackingBean 	= createObject("component","cfstox.model.TrackingBean").init(arguments.strData);
		local.TestData.TradeBean 		= createObject("component","cfstox.model.TradeBean").init(strData:arguments.strData,systemName:arguments.systemName);
		return local.TestData;
		</cfscript>
	</cffunction>
	
	<cffunction name="FindTrades" description="Runs the named system" access="private" displayname="" output="false" returntype="Any">
		<cfargument name="qryData" required="true"  />
		<cfargument name="TestData" required="true"  />
		<cfscript>
		var local = structnew();
		local.systemName = arguments.TestData.TradeBean.Get("SystemName");
		local.qryDataOriginal = arguments.qryData.qryDataOriginal ;
		local.qryDataHA = arguments.qryData.qryDataHA ;
		local.Beans.TrackingBean = arguments.TestData.TrackingBean;
		local.beans.TradeBean = arguments.TestData.TradeBean;
		</cfscript>
		<cfloop  query="local.qryDataOriginal" startrow="6">
			<cfscript>
			local.rowcounter = local.qryDataOriginal.currentrow;
			//array five data beans 
			//todo: use one data bean to store original and HA data
			//todo: fix currentrow 
			local.Beans.Databeans.HA_DataBeans 			= SetupDataBeans(qryData:local.qryDataHA,rowcounter:local.rowcounter);
			local.Beans.Databeans.Original_DataBeans 	= SetupDataBeans(qryData:local.qryDataOriginal,rowcounter:local.rowcounter);
			local.DataBeanToday = session.objects.system.runSystem(beans:local.Beans,systemName:"#local.systemName#");
			//dump(local.databeantoday);
			//session.objects.utility.trace(local.Beans.Databeans,"Local.beans.databeans from systemService");
			arguments.TestData.TradeBean.ProcessTrades(local.DataBeanToday);
			</cfscript>
		</cfloop>
		<!--- trades are stored in the tradehistory --->
		<cfreturn arguments.TestData.TradeBean />
	</cffunction>
		
	<cffunction name="SetupDataBeans" description="sets up data elements" access="private" displayname="" output="false" returntype="Any">
		<cfargument name="qryData" required="true" />
		<cfargument name="rowcounter" required="true" />
		<cfscript>
		var data = structNew();
		data.dataArray = ArrayNew(1);
		data.rowcount = arguments.qryData.currentrow;
		/* for x = 1 to x = 5  */
		data.DataArray[6] = session.objects.Utility.QrytoStruct(query:arguments.qryData,rownumber:arguments.rowcounter-5);
		data.DataArray[5] = session.objects.Utility.QrytoStruct(query:arguments.qryData,rownumber:arguments.rowcounter-4);
		data.DataArray[4] = session.objects.Utility.QrytoStruct(query:arguments.qryData,rownumber:arguments.rowcounter-3);
		data.DataArray[3] = session.objects.Utility.QrytoStruct(query:arguments.qryData,rownumber:arguments.rowcounter-2);
		data.DataArray[2] = session.objects.Utility.QrytoStruct(query:arguments.qryData,rownumber:arguments.rowcounter-1);
		data.DataArray[1] = session.objects.Utility.QrytoStruct(query:arguments.qryData,rownumber:arguments.rowcounter);
		data.DataBean5 = createObject("component","cfstox.model.DataBean").init(data.DataArray[6]);
		data.DataBean4 = createObject("component","cfstox.model.DataBean").init(data.DataArray[5]);
		data.DataBean3 = createObject("component","cfstox.model.DataBean").init(data.DataArray[4]); 
		data.DataBean2 = createObject("component","cfstox.model.DataBean").init(data.DataArray[3]); 
		data.DataBean1 = createObject("component","cfstox.model.DataBean").init(data.DataArray[2]);  
		data.DataBeanToday 	= createObject("component","cfstox.model.DataBean").init(data.DataArray[1]); 
		</cfscript>
		<cfreturn data />
	</cffunction>
		
	<cffunction name="Dump" description="utility" access="public" displayname="test" output="false" returntype="Any">
		<cfargument name="object" required="true" />
		<cfargument name="label" required="false" default="bean:"/>
		<cfargument name="abort" required="false"  default="true" />
		<cfdump label="#arguments.label#" var="#arguments.object#">
		<cfif arguments.abort>
			<cfabort>
		</cfif>
	</cffunction>
		
</cfcomponent>