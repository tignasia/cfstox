<cfcomponent displayname="controller" output="false">
	<cffunction name="init" description="init method" access="public" displayname="" output="false" returntype="controller">
		<cfset loadObjects() />
		<cfset this.diagnostics = false />
		<cfreturn this/>
	</cffunction>
	
	<cffunction name="historical" description="return historical data" access="public" displayname="" output="false" returntype="Struct">
		<!--- <cfargument name="argumentData"> --->
		<cfset var local = structnew() />
		<cfset local.view = "historical">
		<cfset local.results 			= session.objects.DataService.GetStockData(symbol:"#arguments.Symbol#",startdate:"#arguments.startdate#",enddate:"#arguments.enddate#") />
		<cfset local.returned.HKData 	= session.objects.DataService.GetTechnicalIndicators(query:local.results.HKData) />
		<cfset local.xmldata 			= session.objects.XMLGenerator.GenerateXML(name:"#arguments.Symbol#",symbol:"#arguments.symbol#",qrydata:local.results.CandleData,startdate:"#arguments.startdate#", high:local.results.high, low:local.results.low)>
		<cfset local.xmldataha 			= session.objects.XMLGenerator.GenerateXML(name:"#arguments.Symbol#",symbol:"#arguments.Symbol#",qrydata:local.returned.HKData ,startdate:"#arguments.startdate#", high:local.results.high, low:local.results.low)>
		<cfset structAppend(request,local) />
		<cfset structAppend(request,arguments) />
		<cfreturn local />
	</cffunction>
	
	<cffunction name="summary" description="provide trading actions and analysis" access="public" displayname="" output="false" returntype="struct">
		<cfargument name="argumentData">
		<cfset var local = structnew() />
		<cfreturn this/>
	</cffunction>

	<cffunction name="backtest" description="provide results using given system" access="public" displayname="" output="false" returntype="struct">
		<!---- todo: add entry exit excel output ---->
		<!--- <cfargument name="argumentData"> --->
		<!--- the query is loaded with all indicators/rules run. this simplifies the application of a 
		particular set of rules in the trading system. We also can display on a chart the indicator values
		ie how much it went outside the bollinger band, went over under pivot points, etc
		 --->
		<cfset var local = structnew() />
		<cfset local.returndata = historical(Symbol:arguments.symbol,startdate:arguments.startdate,enddate:arguments.enddate,hkconvert:"true") />
		<cfset local.stockdata = local.returndata.returned.HKData />
		<!--- <cfset local.stockdata = session.objects.system.System_hekin_ashiII(queryData:local.stockdata ) /> --->
	 	<cfset local.exceldata = session.objects.utility.genExcel(exceldata:local.stockdata) />  
		<cfset session.objects.Utility.writedata(filepath:"..\data\excel", filename:"#arguments.symbol#.xls", filedata:local.exceldata) /> 
		<cfset local.view = "backtest">
		<cfset structAppend(request,local.returndata) />
		<cfset structAppend(request,arguments) />
		<cfset request.stockdata = local.stockdata /> 
		<cfreturn local />
	</cffunction>
	
	<cffunction name="watchlist" description="run systems against watchlist" access="public" displayname="" output="false" returntype="struct">
		<cfargument name="argumentData">
		<cfset var local = structnew() />
		<cfset local.view = "watchlist">
		<!--- <cfset local.theList = 
"A,ABX,ADBE,AEM,AKAM,APA,ATI,AXP,BIIB,BK,BP,CAT,CHK,CMED,CRM,CSCO,CSX,DE,DIA,DIG,DIS,DNDN,EEM,EWZ,FAS,FCX,FFIV,FSLR,FWLT,GLD,GMCR,GME,GS,HD,HK,HON,HOT,HPQ,HSY,IOC,IWM,JOYG,LVS,M,MDY,MEE,MMM,MOS,MS,NFLX,NKE,NSC,NUE,ORCL,PG,POT,QLD,QQQQ,RIG,RIMM,RMBS,RTH"
> --->
<cfset local.theList = 
"A,ABX,ADBE,AEM,AKAM,APA,ATI,AXP,BIIB,BK,BP,CAT,CHK,CMED,CRM"
>
	<!--- SNDK,SPG,SPY,SQNM,UNP,USO,WYNN,XL,XLF --->
		<cfset local.startDate = dateformat(now()-30,"mm/dd/yyyy") />
		<cfset local.endDate = dateformat(now(),"mm/dd/yyyy") />
		<cfset request.data = session.objects.systemservice.RunWatchList(SystemToRun:"test") />
		<cfreturn local />
	</cffunction>

	<cffunction name="loadObjects" description="I load objects" access="private" displayname="" output="false" returntype="void">
	<!--- load the objects that we might need if not already loaded and set the loaded flag in session --->
	<cfset session.objects.XMLGenerator = createobject("component","cfstox.model.XMLGenerator").init() />
	<cfset session.objects.Indicators 	= createobject("component","cfstox.model.Indicators").init() />
	<cfset session.objects.Utility 		= createobject("component","cfstox.model.Utility").init() />
	<cfset session.objects.ta 		= createObject("component","cfstox.model.ta").init() />
	<cfset session.objects.http 	= createObject("component","cfstox.model.http").init() />
	<cfset session.objects.System 	= createObject("component","cfstox.model.system").init() />
	<cfset session.objects.DataService 	= createObject("component","cfstox.model.Dataservice").init() />
	<cfset session.objects.SystemService 	= createObject("component","cfstox.model.SystemService").init() />
	<cfset session.objects.SystemRunner 	= createObject("component","cfstox.model.SystemRunner").init() />
	<cfset session.objects.Output 	= createObject("component","cfstox.model.Output").init() />
	<cfreturn />
	</cffunction>	

</cfcomponent>