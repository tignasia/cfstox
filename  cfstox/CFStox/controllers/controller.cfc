<cfcomponent displayname="controller" output="false">
	<cffunction name="init" description="init method" access="public" displayname="" output="false" returntype="controller">
		<cfset loadObjects() />
		<cfset this.diagnostics = false />
		<cfreturn this/>
	</cffunction>
	
	<cffunction name="RunEvent" description="" access="public" displayname="" output="false" returntype="void">
		<cfscript>
		</cfscript>
		<cfreturn />
	</cffunction>
	
	<cffunction name="Historical" description="Generate historical data reports" access="public" displayname="" output="false" returntype="any">
		<!--- I generate a historical listing of stock prices and indicator readings for a given stock --->
		<cfargument name="symbol" required="true" />
		<cfargument name="startdate" required="true" />
		<cfargument name="enddate" required="true" />
		<cfscript>
		var local = structnew(); 
		//local.mypath =  ExpandPath("../model/ta-lib.jar");
		//dump(local.mypath,"Path to jar file:");
		request.view = "historical";
		request.symbol = "#arguments.symbol#";
		request.method = "Historical";
		
		GetData(argumentcollection:arguments);
		/* 
		request.qryDataOriginal 
		request.qryDataHA 		
		request.xmldata 		
		request.xmldataHA */
		//dump(request);
		session.objects.ReportService.ReportRunner(reportName:"HistoryReport",data:request.qryDataOriginal,symbol:arguments.symbol);
		session.objects.ReportService.ReportRunner(reportName:"PivotReport",data:request.qryDataOriginal,symbol:arguments.symbol);
		session.objects.ReportService.ReportRunner(reportName:"CandleReport",data:request.qryDataOriginal,symbol:arguments.symbol);
		return ;
		</cfscript> 
	</cffunction>
	
	<cffunction name="AnalyseData" description="Generate historical data reports" access="public" displayname="" output="false" returntype="any">
		<!--- I generate a historical listing of stock prices and indicator readings for a given stock --->
		<cfargument name="symbol" required="true" />
		<cfargument name="startdate" required="true" />
		<cfargument name="enddate" required="true" />
		<cfargument name="summaryOnly" required="false" default="false" />
		<cfscript>
		var local = structnew(); 
		request.view = "chart";
		request.symbol = "#arguments.symbol#";
		request.method = "Historical";
		GetData(argumentcollection:arguments);
		/* 
		request.qryDataOriginal 
		request.qryDataHA 		
		request.xmldata 		
		request.xmldataHA */
 		local.ReportArray 		= session.objects.StrategyService.Analyse();
		session.objects.ReportService.AnalyseDataReport(symbol:arguments.symbol,data:local.reportArray,summaryOnly:arguments.summaryOnly);
		// for unit testing 
		return local.ReportArray;
		</cfscript> 
	</cffunction>	

	<cffunction name="loadSQL" description="load the remote SQL table" access="public" displayname="" output="false" returntype="Struct">
		<!--- I generate a hostorical listing of stock prices and indicator readings for a given stock --->
		<cfargument name="symbol" required="true" />
		<cfargument name="startdate" required="true" />
		<cfargument name="enddate" required="true" />
		<cfscript>
		var local = structnew(); 
		local.view = "viewSQL";
		session.objects.DataService.GetStockData(symbol:"#arguments.Symbol#",startdate:"#arguments.startdate#",enddate:"#arguments.enddate#") ; 
		local.qryDataHA		= session.objects.DataService.GetHAStockData(symbol:"#arguments.Symbol#",startdate:"#arguments.startdate#",enddate:"#arguments.enddate#") ; 
		local.qryDataOriginal = session.objects.DataService.GetOriginalStockData();
		structAppend(request,local); 
		structAppend(request,arguments);
		request.method = "loadSQL";
		return local;
		</cfscript> 
	</cffunction>
	
	<cffunction name="Backtest" description="provide results using given system" access="public" displayname="" output="false" returntype="struct">
		<!---- todo: add entry exit excel output ---->
		<!--- <cfargument name="argumentData"> --->
		<!--- the query is loaded with all indicators/rules run. this simplifies the application of a 
		particular set of rules in the trading system. We also can display on a chart the indicator values
		ie how much it went outside the bollinger band, went over under pivot points, etc
		 --->
		<cfargument name="symbol" required="true" />
		<cfargument name="startdate" required="true" />
		<cfargument name="enddate" required="true" />
		<cfargument name="SystemName" required="false" default="BearishCandles">
		<cfscript>
		var local = structnew(); 
		local.view = "historical";
		GetData(argumentcollection:arguments);
		/* 
		request.qryDataOriginal 
		request.qryDataHA 		
		request.xmldata 		
		request.xmldataHA */
		local.data 			= historical(symbol:arguments.symbol,startdate:arguments.startdate,enddate:arguments.enddate);
		local.ReportArray 	= session.objects.StrategyService.Analyse();
		local.result 		= session.objects.SystemService.RunSystem(SystemName:arguments.SystemName,qryData:request);
		// output results of system 
		session.objects.ReportService.ReportRunner(reportName:"BacktestReport",data:local.result.get("tradeHistory"),symbol:arguments.symbol);
		request.method = "backtest";  
		return local;
		</cfscript>
	</cffunction>
	
	<cffunction name="strategyreport" description="provide results using given system" access="public" displayname="" output="false" returntype="struct">
		<!---- todo: add entry exit excel output ---->
		<!--- <cfargument name="argumentData"> --->
		<!--- the query is loaded with all indicators/rules run. this simplifies the application of a 
		particular set of rules in the trading system. We also can display on a chart the indicator values
		ie how much it went outside the bollinger band, went over under pivot points, etc
		 --->
		<cfargument name="symbol" required="true" />
		<cfargument name="startdate" required="true" />
		<cfargument name="enddate" required="true" />
		<cfscript>
		var local = structnew(); 
		local.view = "historical";
		historical(argumentcollection:arguments);
		session.objects.StrategyService.Analyse();
		session.objects.ReportService.ReportRunner(reportName:"StrategyReport");
		return;
		</cfscript>
	</cffunction>
	
	<cffunction name="watchlist" description="run systems against watchlist" access="public" displayname="" output="false" returntype="struct">
		<cfargument name="SummaryOnly" required="false" default="true" />
		<cfset var local = structnew() />
		<cfset local.view = "watchlist">
		<!--- <cfset local.theList = 
		"A,ABX,ADBE,AEM,AKAM,APA,ATI,AXP,BIIB,BK,BP,CAT,CHK,CMED,CRM,CSCO,CSX,DE,DIA,DIG,DIS,DNDN,EEM,EWZ,FAS,FCX,FFIV,FSLR,FWLT,GLD,GMCR,GME,GS,HD,HK,HON,HOT,HPQ,HSY,IOC,IWM,JOYG,LVS,M,MDY,MEE,MMM,MOS,MS,NFLX,NKE,NSC,NUE,ORCL,PG,POT,QLD,QQQQ,RIG,RIMM,RMBS,RTH"
		> --->
		<cfset local.theList = 
		"AAPL,AMZN,DIA,BIDU,SOHU,TLT,F,CSCO,X,SBUX"
		>
		<cfset local.HTMLfilename = "#application.rootpath#Data/" & "MySummary" & ".html"/>
		<cfif FileExists(local.htmlfilename) >
			<cffile action="delete" file="#local.htmlfilename#">
		</cfif>
		<cfset local.startDate = dateformat(now()-60,"mm/dd/yyyy") />
		<cfset local.endDate = dateformat(now(),"mm/dd/yyyy") />
		<!--- get the current data for all the quotes  --->
		<!--- this will change the behavor of the Dataservice component --->
		<cfset request.CurrentData = session.objects.DataService.GetCurrentData(SymbolList:local.theList) />
		<cfloop list="#local.theList#" index="local.i">
			<cfset request.symbol=#local.i#>
			<cfset AnalyseData(symbol:local.i,startDate:local.startDate,endDate:local.enddate,summaryOnly:arguments.summaryOnly) />
		</cfloop>
		<cfinclude template="../Data/MySummary.html" >
		<cfabort>
		<cfreturn local />
	</cffunction>

	<cffunction name="endofday" description="run systems against watchlist" access="public" displayname="" output="false" returntype="struct">
		<cfscript>
		var local 			= structnew();
		local.view 			= "watchlist";
		local.theList 		= session.objects.dataService.GetWatchList();
		local.HTMLfilename 	= "#application.rootpath#Data/" & "DailySummary.html";
		local.startDate 	= dateformat(now()-60,"mm/dd/yyyy");
		local.endDate 		= dateformat(now(),"mm/dd/yyyy");
		request.CurrentData = session.objects.DataService.GetCurrentData(SymbolList:local.theList);
		</cfscript>
		<cfloop list="#local.theList#" index="local.i">
			<cfset request.symbol=#local.i#>
			<cfset AnalyseData(symbol:local.i,startDate:local.startDate,endDate:local.enddate) />
		</cfloop>
		<cfreturn local />
	</cffunction>

	<cffunction name="CheckAlerts" description="check alerts and send email" access="public" displayname="" output="false" returntype="struct">
		<cfscript>
		var local 			= structnew();
		request.view		= "home";
		local.theList 		= session.objects.alertService.CheckAlerts();
		</cfscript>
		<cfreturn local />
	</cffunction>

	<cffunction name="EditAlerts" description="check alerts and send email" access="public" displayname="" output="false" returntype="struct">
		<cfscript>
		var local 			= structnew();
		request.view 		= "alerts";
		request.context 	= structNew();
		rc = request.context;
		rc.queryAlerts 		= session.objects.AlertService.GetAlerts();
		</cfscript>
		<cfreturn local />
	</cffunction>

	<cffunction name="AddAlert" description="add an alert" access="public" displayname="" output="false" returntype="struct">
		<cfscript>
		var local 			= structnew();
		request.view 		= "alerts";
		request.context 	= structNew();
		rc = request.context;
		local.a_symbol 		= ListtoArray(form.Symbol);
		local.a_alerted 	= ListtoArray(form.alerted);
		local.a_delete	 	= ListtoArray(form.delete);
		local.a_action 		= ListtoArray(form.action);
		local.a_message 	= ListtoArray(form.message);
		local.a_value 		= ListtoArray(form.value);
		local.a_strategy 	= ListtoArray(form.strategy);
		session.objects.AlertService.UpdateAlerts(local);
		rc.queryAlerts 		= session.objects.AlertService.GetAlerts(); 
		</cfscript>
		<cfreturn local />
	</cffunction>
	
	<cffunction name="UpdateAlerts" description="update the stored alerts" access="public" displayname="" output="false" returntype="struct">
		<cfscript>
		var local 			= structnew();
		request.view 		= "alerts";
		request.context 	= structNew();
		rc = request.context;
		local.a_symbol 		= ListtoArray(form.Symbol);
		local.a_alerted 	= ListtoArray(form.alerted);
		local.a_delete 		= ListtoArray(form.delete);
		local.a_action 		= ListtoArray(form.action);
		local.a_message 	= ListtoArray(form.message);
		local.a_value 		= ListtoArray(form.value);
		local.a_strategy 	= ListtoArray(form.strategy);
		session.objects.AlertService.DeleteAlerts();
		session.objects.AlertService.UpdateAlerts(local);
		rc.queryAlerts 		= session.objects.AlertService.GetAlerts(); 
		</cfscript>
		<cfreturn local />
	</cffunction>

	<cffunction name="UpdateAlertsTEST" description="check alerts and send email" access="public" displayname="" output="false" returntype="struct">
		<cfscript>
		var local 			= structnew();
		request.view 		= "dumpalerts";
		request.context 	= structNew();
		rc = request.context;
		/* local.a_symbol = ListtoArray(form.Symbol);
		local.a_action = ListtoArray(form.action);
		local.a_message = ListtoArray(form.message);
		local.a_value = ListtoArray(form.value);
		rc.queryAlerts 		= session.objects.AlertService.UpdateAlerts(form);
		rc.queryAlerts 		= session.objects.AlertService.GetAlerts(); */
		</cfscript>
		<cfreturn local />
	</cffunction>
	
	<cffunction name="PopulateData" description="populate the database with stock data" access="public" displayname="" output="false" returntype="struct">
		<cfargument name="symbol" required="true" />
		<cfargument name="startdate" required="true" />
		<cfargument name="enddate" required="true" />
		<cfset var local = structnew() />
		<cfset local.results = session.objects.DataService.putData(symbol:"#arguments.Symbol#",startdate:"#arguments.startdate#",enddate:"#arguments.enddate#") />
		<cfreturn local />
	</cffunction>
	
	<cffunction name="GetData" description="Generate historical data reports" access="public" displayname="" output="false" returntype="void">
		<!--- I generate a hostorical listing of stock prices and indicator readings for a given stock --->
		<cfargument name="symbol" required="true" />
		<cfargument name="startdate" required="true" />
		<cfargument name="enddate" required="true" />
		<cfscript>
		var local = structnew(); 
		session.objects.DataStorage.SetData(DataSet:"Symbol",theData:arguments.symbol);
		session.objects.DataStorage.SetData(DataSet:"startDate",theData:arguments.startDate); 
		session.objects.DataStorage.SetData(DataSet:"endDate",theData:arguments.endDate);
				
		local.stockdata = session.objects.DataService.GetStockData(argumentcollection:arguments);
		session.objects.DataStorage.SetData(DataSet:"qryDataOriginal", theData:local.stockData.qryDataOriginal ); 
		session.objects.DataStorage.SetData(DataSet:"qryDataHA", theData:local.stockData.qryDataHA );
		session.objects.DataStorage.SetData(DataSet:"High", theData:session.objects.DataService.GetHigh()  ); 
		session.objects.DataStorage.SetData(DataSet:"Low", theData:session.objects.DataService.GetLow() ); 
		session.objects.DataStorage.SetData(DataSet:"XMLDataOriginal", theData:session.objects.XMLGenerator.GenerateXML(dataType:"Original") );
		session.Objects.DataStorage.SetData(DataSet:"XMLDataHA", theData:session.objects.XMLGenerator.GenerateXML(dataType:"HeikenAshi") );
				
		request.qryDataOriginal = session.objects.DataStorage.GetData("qryDataOriginal");
		request.qryDataHA 		= session.objects.DataStorage.GetData("qryDataHA");
		request.xmldata 		= session.objects.DataStorage.GetData("XMLDataOriginal");
		request.xmldataHA 		= session.objects.DataStorage.GetData("XMLDataHA");
		return;
		</cfscript> 
	</cffunction>

	<cffunction name="LoadXMLData" description="set up XML Data for Charting" access="private" displayname="" output="false" returntype="any">
		<!--- I generate a hostorical listing of stock prices and indicator readings for a given stock --->
		<cfargument name="symbol" required="true" />
		<cfscript>
		var local = structnew(); 
		session.objects.DataService.GetStockData(symbol:"#arguments.Symbol#",startdate:"#arguments.startdate#",enddate:"#arguments.enddate#"); 
		local.xmldata 		= session.objects.XMLGenerator.GenerateXML(name:"#arguments.Symbol#",symbol:"#arguments.symbol#",qrydata:local.qryDataOriginal,startdate:"#arguments.startdate#", high:local.high, low:local.low);
		local.xmldataha 	= session.objects.XMLGenerator.GenerateXML(name:"#arguments.Symbol#",symbol:"#arguments.Symbol#",qrydata:local.qryDataHA,startdate:"#arguments.startdate#", high:local.high, low:local.low);
		session.objects.ReportService.ReportRunner(reportName:"HistoryReport",data:local.qryDataOriginal,symbol:arguments.symbol);
		session.objects.ReportService.ReportRunner(reportName:"PivotReport",data:local.qryDataOriginal,symbol:arguments.symbol);
		session.objects.ReportService.ReportRunner(reportName:"CandleReport",data:local.qryDataOriginal,symbol:arguments.symbol);
		//session.objects.ReportService.ReportRunner(reportName:"BreakoutReport",data:local.OriginalData,symbol:arguments.symbol);
		structAppend(request,local); 
		structAppend(request,arguments);
		request.method = "historical";
		return local;
		</cfscript> 
	</cffunction>

	<cffunction name="loadObjects" description="I load objects" access="private" displayname="" output="false" returntype="void">
	<!--- load the objects that we might need if not already loaded and set the loaded flag in session --->
	<cfset mypath = ExpandPath("/cfstox/model/ta-lib.jar") />
	<cfdump var="#mypath#">
	<cfset session.objects.XMLGenerator 	= createobject("component","cfstox.model.XMLGenerator").init() />
	<cfset session.objects.Indicators 		= createobject("component","cfstox.model.Indicators").init() />
	<cfset session.objects.Utility 			= createobject("component","cfstox.model.Utility").init() />
	<cfset session.objects.ta 				= createObject("component","cfstox.model.ta").init(mypath) /> 
	<cfset session.objects.http 			= createObject("component","cfstox.model.http").init() />
	<cfset session.objects.System 			= createObject("component","cfstox.model.system").init() />
	<cfset session.objects.DataService 		= createObject("component","cfstox.model.Dataservice").init() />
	<cfset session.objects.SystemService 	= createObject("component","cfstox.model.SystemService").init() />
	<cfset session.objects.SystemRunner 	= createObject("component","cfstox.model.SystemRunner").init() />
	<cfset session.objects.SystemTriggers	= createObject("component","cfstox.model.SystemTriggers").init() />
	<cfset session.objects.ReportService	= createObject("component","cfstox.model.ReportService").init() />
	<cfset session.objects.DataStorage 		= createObject("component","cfstox.model.DataStorage").init() />
	<cfset session.objects.StrategyService	= createObject("component","cfstox.model.StrategyService").init() />
	<cfset session.objects.MailService		= createObject("component","cfstox.model.MailService").init() />
	<cfset session.objects.DataDAO			= createObject("component","cfstox.model.DataDAO").init() />
	<cfset session.objects.AlertDAO			= createObject("component","cfstox.model.AlertDAO").init() />
	<cfset session.objects.AlertService		= createObject("component","cfstox.model.AlertService").init() />
	<cfreturn />
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