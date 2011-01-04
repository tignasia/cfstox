<cfcomponent  displayname="DataService" output="false" hint="I process and store the data ">

<cffunction name="Init" description="" access="public" displayname="" output="true" returntype="DataService">
	<cfset variables.qryDataOrg = "" />
	<cfset variables.qryDataHA = "" />
	<cfset variables.high = "" />
	<cfset variables.low = "" />
	<cfreturn this />
</cffunction>	

	<cffunction name="GetStockData" description="I return a stock data bean" access="public" displayname="GetStockData" output="false" returntype="Any">
		<cfargument name="Symbol" 		required="true"  />
		<cfargument name="startdate" 	required="false" default=#CreateDate(2009,1,1)# />
		<cfargument name="enddate" 		required="false" default=#now()# />
		<cfset var local = structnew() />
		<cftry>
		<cfset results = session.objects.http.gethttp(sym:"#arguments.Symbol#",startdate:"#arguments.startdate#",enddate:"#arguments.enddate#") />
		<cfcatch>
			<cfoutput> HTTP request failed</cfoutput>
			<cfdump var="#arguments.symbol#">
			<cfdump var="#variables#">
			<cfdump var="#arguments#">
			<cfabort>
		</cfcatch>
		</cftry>
		<cfquery   dbtype="query"  name="resorted" >
			select * from results order by DateOne asc
		</cfquery>
		<!--- used to display chart  --->
		<cfquery   dbtype="query"  name="high1" >
			select high from results order by high desc
		</cfquery>
		<cfquery   dbtype="query"  name="low1" >
			select low from results order by low asc
		</cfquery>
		<cfset variables.high = high1.high />
		<cfset variables.low = low1.low />	
		<!--- raw data  --->
		<cfset local.OrgData = resorted />
		<!--- HAData --->
		<cfset local.HKData = session.objects.TA.convertHK(qrydata:resorted) />
		<cfset local.symbolArray = ArrayNew(1) >
		<cfloop from="1" to="#local.HKData.recordcount#" index="i">
			<cfset local.symbolArray[i] = arguments.symbol>
		</cfloop>
		<cfset queryAddColumn(local.HKData,"Symbol",'VarChar',local.symbolArray) > 
		<cfset queryAddColumn(local.OrgData,"Symbol",'VarChar',local.symbolArray) > 
		<cfset variables.qryDataOrg = GetTechnicalIndicators(query:local.OrgData)  />
		<cfset variables.qryDataHA = GetTechnicalIndicators(query:local.HKData)  />
		<cfreturn local />
	</cffunction>

	<cffunction name="GetTechnicalIndicators" description="I populate a query with technical data" access="public" displayname="GetTechnicalData" output="false" returntype="Any">
		<cfargument name="query" required="true" />
		<cfset local.num = session.objects.TA.GetIndicator(Indicator:"linearReg",qryPrices:arguments.query) />
		<cfset queryAddColumn(arguments.query,"linearReg",'Decimal',local.num) > 
		<cfset local.num = session.objects.TA.GetIndicator(Indicator:"linearRegAngle",qryPrices:arguments.query) />
		<cfset queryAddColumn(arguments.query,"linearRegAngle",'Decimal',local.num) >
		<cfset local.num = session.objects.TA.GetIndicator(Indicator:"linearRegSlope",qryPrices:arguments.query) />
		<cfset queryAddColumn(arguments.query,"linearRegSlope",'Decimal',local.num) >
		<cfset local.num = session.objects.TA.GetIndicator(Indicator:"linearRegIntercept",qryPrices:arguments.query) />
		<cfset queryAddColumn(arguments.query,"linearRegIntercept",'Decimal',local.num) >
		<cfset local.LRSArray = session.objects.TA.LRSDelta(qryData:arguments.query) />
		<cfset queryAddColumn(arguments.query,"LRSdelta","Decimal", local.LRSarray) >
		<cfset local.num = session.objects.TA.GetIndicator(Indicator:"Momentum",qryPrices:arguments.query) />
		<cfset queryAddColumn(arguments.query,"Momentum",'Decimal',local.num) >
		<cfset local.num = session.objects.TA.GetIndicator(Indicator:"RSI",qryPrices:arguments.query) />
		<cfset queryAddColumn(arguments.query,"RSI",'Decimal',local.num) >
		<cfset local.num = session.objects.TA.GetIndicator(Indicator:"ADX",qryPrices:arguments.query) />
		<cfset queryAddColumn(arguments.query,"ADX",'Decimal',local.num) >
		<cfset local.num = session.objects.TA.GetIndicator(Indicator:"CCI",qryPrices:arguments.query) />
		<cfset queryAddColumn(arguments.query,"CCI",'Decimal',local.num) >
		<cfset local.Pivots = session.objects.TA.PivotPoints(qryData:arguments.query) />
		<cfset queryAddColumn(arguments.query,"PP",'Decimal',local.pivots.pp) >
		<cfset queryAddColumn(arguments.query,"R1",'Decimal',local.pivots.r1) >
		<cfset queryAddColumn(arguments.query,"R2",'Decimal',local.pivots.r2) >
		<cfset queryAddColumn(arguments.query,"S1",'Decimal',local.pivots.s1) >
		<cfset queryAddColumn(arguments.query,"S2",'Decimal',local.pivots.s2) >
		<cfset local.falseArray = ArrayNew(1) >
		<cfloop from="1" to="#arguments.query.recordcount#" index="i">
			<cfset local.falseArray[i] = "false">
		</cfloop>
		<cfset queryAddColumn(arguments.query,"TestResult","VarChar",local.falsearray) />
		<cfreturn arguments.query />	
	</cffunction>

	<cffunction name="GetOriginalStockData" description="" access="public" displayname="" output="false" returntype="Any">
	<cfreturn variables.qryDataOrg />
	</cffunction>
	
	<cffunction name="GetHAStockData" description="" access="public" displayname="" output="false" returntype="Any">
	<cfreturn variables.qryDataHA />
	</cffunction>
	
	<cffunction name="GetHigh" description="" access="public" displayname="" output="false" returntype="Any">
	<cfreturn variables.high />
	</cffunction>
	
	<cffunction name="GetLow" description="" access="public" displayname="" output="false" returntype="Any">
	<cfreturn variables.low />
	</cffunction>
	
	
</cfcomponent>