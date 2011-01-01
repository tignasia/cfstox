<cfcomponent displayname="mxunit.framework.MyComponentTest"  extends="mxunit.framework.TestCase">

	<cffunction name="setUp" access="public" returntype="void">
	 <!---  <cfset super.TestCase(this) /> --->
	  <!--- Place additional setUp and initialization code here --->
		<cfscript>
		this.Output 	= createObject("component","cfstox.model.Output").init();
		this.SystemService 	= createObject("component","cfstox.model.systemService").init();
		this.SystemRunner 	= createObject("component","cfstox.model.systemRunner").init();
		this.DataService 	= createObject("component","cfstox.model.DataService").init();
		this.http 		= createObject("component","cfstox.model.http").init();
		this.indicators = createObject("component","cfstox.model.indicators").init();
		this.controller = createObject("component","cfstox.controllers.controller").init();
		session.objects.controller = createObject("component","cfstox.controllers.controller").init();
		</cfscript>
	</cffunction>

	<cffunction name="testSystemService" access="public" returntype="void">
		<cfscript>
		var local = structNew();
		local.data = this.DataService.GetStockData(symbol:"MEE",startdate:"12/01/2009",enddate:"12/15/2010"); 
		local.data = this.DataService.GetTechnicalIndicators(query:local.data.HKData); 
		//debug(local.data);
		local.result = this.SystemService.RunSystem(SystemToRun:"test",qryData: local.data);
		//local.query = this.System.TrackTrades(queryData: local.data);
		//debug(local.result);
		</cfscript>
	</cffunction>

	<cffunction name="testTestRunner" access="public" returntype="void">
		<cfscript>
		var local = structNew();
		local.data = this.DataService.GetStockData(symbol:"AKAM",startdate:"07/01/2010",enddate:"12/15/2010"); 
		//debug(local.data);
		local.data = this.DataService.GetTechnicalIndicators(query:local.data.HKData); 
		//debug(local.data);
		local.result = this.SystemRunner.TestSystem(SystemToRun:"test",qryData: local.data);
		//local.query = this.System.TrackTrades(queryData: local.data);
		//local.beandata = local.result.;
		//debug(local.result);
		</cfscript>
	</cffunction>
	
	<cffunction name="testOutputPath" access="public" returntype="void">
		<cfscript>
		var local = structNew();
		local.data = this.DataService.GetStockData(symbol:"ABX",startdate:"11/01/2010",enddate:"12/15/2010"); 
		//debug(local.data);
		local.data = this.DataService.GetTechnicalIndicators(query:local.data.HKData); 
		///debug(local.data);
		local.result = this.SystemRunner.TestSystem(SystemToRun:"test",qryData: local.data);
		debug(local.result);
		local.outputpath = this.Output.GetPDFPath(data:local.result);
		debug(local.outputpath);
		//local.query = this.System.TrackTrades(queryData: local.data);
		//local.beandata = local.result.;
		</cfscript>
	</cffunction>
	
	<cffunction name="testRunSystem" access="public" returntype="void">
		<cfscript>
		var local = structNew();
		local.data = this.DataService.GetStockData(symbol:"AKAM",startdate:"7/01/2010",enddate:"12/15/2010"); 
		//debug(local.data);
		local.data = this.DataService.GetTechnicalIndicators(query:local.data.HKData); 
		///debug(local.data);
		local.result = this.SystemService.RunSystem(SystemToRun:"test",qryData: local.data);
		debug(local.result);
		//local.query = this.System.TrackTrades(queryData: local.data);
		//local.beandata = local.result.;
		</cfscript>
	</cffunction>
	
	<cffunction name="testRunWatchlist" access="public" returntype="void">
		<cfscript>
		var local = structNew();
		///debug(local.data);
		local.result = this.SystemService.RunWatchlist(SystemToRun:"test");
		debug(local.result);
		
		//local.query = this.System.TrackTrades(queryData: local.data);
		//local.beandata = local.result.;
		local.result1 = local.result[2]["golong"].GetMemento();
		local.result2 = local.result[3]["golong"].GetMemento();
		local.result3 = local.result[4]["golong"].GetMemento();
		debug(local.result1);
		debug(local.result2);
		debug(local.result3);
		</cfscript>
	</cffunction>
	
	<cffunction name="testCandlePattern" access="public" returntype="void">
		<!--- allow at least two days for HA data to be accurate --->
		<cfscript>
		var local = structNew();
		local.data = this.DataService.GetStockData(symbol:"ABX",startdate:"10/8/2010",enddate:"11/15/2010"); 
		//debug(local.data);
		local.DataArray[1] = session.objects.Utility.QrytoStruct(query:local.data,rownumber:4);
		local.DataArray[2] = session.objects.Utility.QrytoStruct(query:local.data,rownumber:5);
		local.DataArray[3] = session.objects.Utility.QrytoStruct(query:local.data,rownumber:6);
		local.TBean2 	= createObject("component","cfstox.model.TradeBean").init(local.DataArray[1]); 
		local.TBean1 	= createObject("component","cfstox.model.TradeBean").init(local.DataArray[2]); 
		local.TB 		= createObject("component","cfstox.model.TradeBean").init(local.DataArray[3]); 
		local.patterns 	= this.SystemRunner.CandlePattern(tb2:local.TBean2 ,tb1:local.TBean1 ,tb:local.TB );
		debug(local.patterns);
		//debug(local.DataArray[1]);
		debug(local.DataArray[2]);
		debug(local.DataArray[3]);
		//local.query = this.System.TrackTrades(queryData: local.data);
		//local.beandata = local.result.;
		</cfscript>
	</cffunction>
	
	<!--- 
<cffunction name="testSystemHKII" access="public" returntype="void">
		<cfscript>
		var local = structNew();
		local.data = this.DataService.GetStockData(symbol:"APA",startdate:"2/1/2010",enddate:"11/10/2010");
		debug(local.data);
		local.data2 = this.System.System_hekin_ashiII(queryData: local.data.hkdata);
		debug(local.data2);
		</cfscript>
	</cffunction>

	<cffunction name="testSystemNewHighLow" access="public" returntype="void">
		<cfscript>
		var local = structNew();
		local.dataarray = this.controller.historical(Symbol:"akam",startdate:"5/1/2010",enddate:"11/10/2010",hkconvert:"true");
		local.data = local.dataarray.stockdata;
		</cfscript>
		<cfquery   dbtype="query"  name="local.reverse">
			select * from [local].data order by DateOne asc
		</cfquery>
		<cfscript>
		local.data = local.reverse; 
		local.data = this.System.System_hekin_ashi(queryData: local.data);
		local.query = this.System.NewHL3(queryData: local.data);
		debug(local.query);
		</cfscript>
	</cffunction>
 --->

	<!--- End Specific Test Cases --->
	<cffunction name="tearDown" access="public" returntype="void">
	 <!--- Place tearDown/clean up code here --->
	</cffunction>

</cfcomponent>
