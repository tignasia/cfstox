<cfcomponent  displayname="systemRunner" hint="I test systems using given data" output="false">

	<cffunction name="init" description="init method" access="public" displayname="init" output="false" returntype="systemRunner">
		<!--- persistent variable to store trades and results --->
		<cfset variables.tradeArray = ArrayNew(2) />
		<cfreturn this/>
	</cffunction>
	
	<cffunction name="TestSystem" description="called from SystemService.RunSystem" access="public" displayname="" output="false" returntype="Any">
		<cfargument name="qryData" required="true" />
		<cfargument name="SystemToRun" required="true" />
		<cfset var local = structNew() />
		<cfset local.boolResult = false />
		<cfset local.dataArray = ArrayNew(1) />
		<cfloop  query="arguments.qryData" startrow="3">
			<cfset local.rowcount = arguments.qryData.currentrow />
			<cfset local.DataArray[1] = session.objects.Utility.QrytoStruct(query:arguments.qryData,rownumber:local.rowcount-2) />
			<cfset local.DataArray[2] = session.objects.Utility.QrytoStruct(query:arguments.qryData,rownumber:local.rowcount-1) />
			<cfset local.DataArray[3] = session.objects.Utility.QrytoStruct(query:arguments.qryData,rownumber:local.rowcount) />
			<cfset local.TradeBeanTwoDaysAgo = createObject("component","cfstox.model.TradeBean").init(local.DataArray[1]) /> 
			<cfset local.TradeBeanOneDayAgo = createObject("component","cfstox.model.TradeBean").init(local.DataArray[2]) /> 
			<cfset local.TradeBeanToday 	= createObject("component","cfstox.model.TradeBean").init(local.DataArray[3]) /> 
			<cfset session.objects.system.System_hekin_ashi_long(local.TradeBeanTwoDaysAgo,local.TradeBeanOneDayAgo,local.TradeBeanToday)>
			<!--- record system name, date, entry price --->
			<cfset recordTrades(local.TradeBeanToday) /> 
		</cfloop>
		<!--- return the action results ---->
		<cfset local.trades = variables.TradeArray />
		<cfreturn local />
	</cffunction>

	<cffunction name="RecordTrades" description="" access="private" displayname="" output="false" returntype="Any">
		<cfargument name="TradeBean" required="true" />
		<cfset var local = StructNew() />
		<cfif arguments.TradeBean.Get("HKGoLong",true) >
		<cfset local.aLength = variables.TradeArray.Size() + 1 />
		<cfset variables.TradeArray[#local.alength#][1] = "HKGoLong" /> <!--- Action --->
		<cfset variables.TradeArray[#local.alength#][2] = "open" /> <!--- trade type --->
		<cfset variables.TradeArray[#local.alength#][3] = TradeBean.Get("Date") /> <!--- date --->
		<cfset variables.TradeArray[#local.alength#][4] = TradeBean.Get("HKClose") /> <!--- price --->
		</cfif>
		<cfreturn />
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