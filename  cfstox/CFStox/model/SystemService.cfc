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
		<cfargument name="SystemName" required="true" />
		<cfargument name="qryData" required="true" />
		<cfscript>
		var local = StructNew();
		variables.Data 			= ProcessData(qryData:arguments.qryData);
		variables.Beans			= SetUpBeans(Data:variables.Data);
		variables.Beans.TradeBean.Set("SystemName",arguments.systemName);
		local.beans		= FindTrades(Data:variables.Data, Beans:variables.Beans);
		return local.Beans;
		</cfscript>
	</cffunction>
	
	<cffunction name="ProcessData" description="Sets up the queries and structures" access="private" displayname="" output="false" returntype="Any">
		<cfargument name="qryData" required="true" />
		<cfscript>
		var local = StructNew();
		local.Data = StructNew();
		local.Data.qryDataOriginal 	= arguments.qryData.qryDataOriginal ;
		local.Data.qryDataHA 		= arguments.qryData.qryDataHA ;
		local.Data.strDataOriginal 	= session.objects.Utility.QrytoStruct(query:local.Data.qryDataOriginal,rownumber:1);
		local.Data.strDataHA 		= session.objects.Utility.QrytoStruct(query:local.Data.qryDataHA,rownumber:1);
		return local.Data;
		</cfscript>
	</cffunction>
	
	<cffunction name="SetUpBeans" description="Sets up the beans" access="private" displayname="" output="false" returntype="Any">
		<cfargument name="Data" required="true" />
		<cfargument name="SystemName" required="true" />
		<cfscript>
		var local 	= StructNew();
		local.Beans = structNew();
		local.Beans.TestDataOriginal	= StructNew();
		local.Beans.TestDataHA 			= StructNew();
		local.Beans.TrackingBean	= createObject("component","cfstox.model.TrackingBean").init(arguments.Data.qryDataOriginal);
		local.Beans.TradeBean		= createObject("component","cfstox.model.TradeBean").init(strData:arguments.Data.qryDataOriginal,systemName:arguments.systemName);
		return local.Beans;
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
		<!--- 
		databean has data for given day 
		trackingbean keeps track of state of system - persistent singleton
		tradebean keeps track of the trades and the results - this should prob be in a simple array
		--->
		<cfscript>
		var local = structnew();
		return local;
		</cfscript>
	</cffunction>
		
	<cffunction name="FindTrades" description="Runs the named system" access="private" displayname="" output="false" returntype="Any">
		<cfargument name="Data" required="true"  />
		<cfargument name="Beans" required="true"  />
		<cfscript>
		var local = structnew();
		local.systemName 		= arguments.Beans.TradeBean.Get("SystemName");
		local.Beans.TrackingBean = arguments.Beans.TrackingBean;
		local.beans.TradeBean 	= arguments.Beans.TradeBean;
		</cfscript>
		<cfloop  query="arguments.Data.qryDataOriginal" startrow="6">
			<cfscript>
			local.rowcounter = arguments.Data.qryDataOriginal.currentrow;
			//array five data beans 
			//todo: use one data bean to store original and HA data
			//todo: fix currentrow 
			local.Beans.HA 			= SetupDataBeans(qryData:arguments.Data.qryDataHA,rowcounter:local.rowcounter);
			local.Beans.Original 	= SetupDataBeans(qryData:arguments.Data.qryDataOriginal,rowcounter:local.rowcounter);
			local.Beans.DataBeanToday 	= session.objects.system.runSystem(beans:local.Beans,systemName:"#local.systemName#");
			//dump(local.databeantoday);
			//session.objects.utility.trace(local.Beans.Databeans,"Local.beans.databeans from systemService");
			arguments.Beans.TradeBean.ProcessTrades(local.Beans.DataBeanToday);
			</cfscript>
		</cfloop>
		<!--- trades are stored in the tradehistory --->
		<cfreturn arguments.Beans.TradeBean />
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