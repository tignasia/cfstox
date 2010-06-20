<cfcomponent displayname="controller" output="false">
	<cffunction name="init" description="init method" access="public" displayname="" output="false" returntype="controller">
		<cfset loadObjects() />
		<cfreturn this/>
	</cffunction>
	
	<cffunction name="historical" description="return historical data" access="public" displayname="" output="false" returntype="Struct">
		<cfargument name="argumentData">
		<cfset var local = structnew() />
		<cfset local.view = "historical">
		<!--- get historical data ---->
		<cfset local.results = session.objects.http.gethttp(sym:"#arguments.Symbol#",startdate:"#arguments.startdate#") />
		<cfquery   dbtype="query"  name="yahoo" >
			select * from [local].results order by DateOne asc
		</cfquery>
		
		<cfset local.stockdata = duplicate(yahoo) />
		<cfset local.num = session.objects.TA.GetIndicator(Indicator:"linearReg",qryPrices:yahoo) />
		<cfset queryAddColumn(local.stockdata,"linearReg",'Decimal',local.num) > 
		<cfset local.num = session.objects.TA.GetIndicator(Indicator:"linearRegAngle",qryPrices:yahoo) />
		<cfset queryAddColumn(local.stockdata,"linearRegAngle",'Decimal',local.num) >
		<cfset local.num = session.objects.TA.GetIndicator(Indicator:"linearRegSlope",qryPrices:yahoo) />
		<cfset queryAddColumn(local.stockdata,"linearRegSlope",'Decimal',local.num) >
		<cfset local.num = session.objects.TA.GetIndicator(Indicator:"linearRegIntercept",qryPrices:yahoo) />
		<cfset queryAddColumn(local.stockdata,"linearRegIntercept",'Decimal',local.num) >
		<cfset local.LRSArray = session.objects.TA.LRSDelta(qryData:local.stockdata) />
		<cfset queryAddColumn(local.stockdata,"LRSdelta","Decimal", local.LRSarray) >
		<cfset local.num = session.objects.TA.GetIndicator(Indicator:"Momentum",qryPrices:yahoo) />
		<cfset queryAddColumn(local.stockdata,"Momentum",'Decimal',local.num) >
		<cfset local.num = session.objects.TA.GetIndicator(Indicator:"RSI",qryPrices:yahoo) />
		<cfset queryAddColumn(local.stockdata,"RSI",'Decimal',local.num) >
		<cfset local.num = session.objects.TA.GetIndicator(Indicator:"ADX",qryPrices:yahoo) />
		<cfset queryAddColumn(local.stockdata,"ADX",'Decimal',local.num) >
		<cfset local.num = session.objects.TA.GetIndicator(Indicator:"CCI",qryPrices:yahoo) />
		<cfset queryAddColumn(local.stockdata,"CCI",'Decimal',local.num) >
		
		<cfset local.falseArray = ArrayNew(1) >
		<cfloop from="1" to="#yahoo.recordcount#" index="i">
			<cfset local.falseArray[i] = "false">
		</cfloop>
		<cfset queryAddColumn(local.stockdata,"TestResult","VarChar",local.falsearray) >
		
		<cfquery   dbtype="query"  name="stockdata" >
			select * from [local].stockdata order by DateOne desc
		</cfquery>
		
		<cfset local.stockdata = stockdata />
		<cfset local.xmldata = session.objects.XMLGenerator.GenerateXML(name:"#arguments.Symbol#",symbol:"#arguments.symbol#",qrydata:yahoo,startdate:"#arguments.startdate#")>
		<cfset local.xmldataHA = session.objects.XMLGenerator.GenerateXMLha(name:"#arguments.Symbol#",symbol:"#arguments.Symbol#",qrydata:yahoo,startdate:"#arguments.startdate#")>
		<cfset structAppend(request,local) />
		<cfset structAppend(request,arguments) />
		<cfreturn local />
	</cffunction>
	
	<cffunction name="summary" description="provide trading actions and analysis" access="public" displayname="" output="false" returntype="controller">
		<cfargument name="argumentData">
		<cfset var local = structnew() />
		<cfreturn this/>
	</cffunction>

	<cffunction name="backtest" description="provide results using given system" access="public" displayname="" output="false" returntype="controller">
		<cfargument name="argumentData">
		<cfset var local = structnew() />
		<cfreturn this/>
	</cffunction>
	
	<cffunction name="watchlist" description="run systems agains watchlist" access="public" displayname="" output="false" returntype="controller">
		<cfargument name="argumentData">
		<cfset var local = structnew() />
		<cfreturn this/>
	</cffunction>

	<cffunction name="loadObjects" description="I load objects" access="private" displayname="" output="false" returntype="void">
	<!--- load the objects that we might need if not already loaded and set the loaded flag in session --->
	<cfset session.objects.XMLGenerator = createobject("component","cfstox.model.XMLGenerator").init() />
	<cfset session.objects.Indicators 	= createobject("component","cfstox.model.Indicators").init() />
	<cfset session.objects.Utility 		= createobject("component","cfstox.model.Utility").init() />
	<cfset session.objects.ta 		= createObject("component","cfstox.model.ta").init() />
	<cfset session.objects.http 	= createObject("component","cfstox.model.http").init() />
	<cfreturn />
	</cffunction>	

</cfcomponent>