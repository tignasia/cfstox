<cfcomponent output="false">

	<cffunction name="init" description="init method" access="public" displayname="init" output="false" returntype="SystemService">
	<!--- persistent variable to store trades and results --->
		<cfreturn this/>
	</cffunction>
	
	<cffunction name="RunSystem" description="" access="public" displayname="" output="false" returntype="Any">
		<!--- System.cfc contains the system rules for entering and exiting long and short trades 
		if the entry or exit is a stop limit the system will indicate if the stop was hit --->
		<cfargument name="SystemToRun" required="true"  />
		<cfargument name="qryData" required="true" />
		<cfset var local = structnew() />
		<cfset local.results = session.objects.systemRunner.testSystem(SystemToRun:arguments.systemtorun,qryData:arguments.qryData) >
		<cfset local.ReportHeaders = "Date,Entry Price,NewHighReversal,RSIStatus,CCIStatus">
		<cfset local.ReportMethods = "Date,EntryPrice,NewHighReversal,RSIStatus,CCIStatus">
		<cfset session.objects.Output.TradeReport(local) />
		<cfreturn local.results />
	</cffunction>
	
	
</cfcomponent>