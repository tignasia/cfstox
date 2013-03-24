<cfcomponent name="SystemServiceTest" extends="mxunit.framework.TestCase">
	<!--- Begin specific tests --->
	
	<!--- setup and teardown --->
	<cffunction name="setUp" returntype="void" access="public">
		<!--- 
		load all the crap we'll need for testing  
		there should be a better way to do this
		--->
		<cfscript>
			createObject("component","cfstox.controllers.Controller").init();
			this.DataService 	= createObject("component","cfstox.model.DataService").init();
			this.Utility 		= createObject("component","cfstox.model.Utility").init();
			this.SystemService 	= createObject("component","cfstox.model.SystemService").init();
			this.data = this.DataService.GetStockData(symbol:"UA",startdate:"09/01/2012",enddate:"03/20/2013");
			//debug(data);
			
		</cfscript>
	</cffunction>
		
	<cffunction name="testGetStrData" returntype="void" access="public">
		<cfscript>
		var local = structNew(); 
		local.strData = this.Utility.QrytoStruct(query:this.data.qryDataOriginal,rownumber:1);
		debug(local.strData);
		</cfscript>	
	</cffunction>
			
	<cffunction name="testSetUpSystem" returntype="void" access="public">
		<cfscript>
		var local = structNew(); 
		makePublic(this.SystemService,"SetUpSystem");
		local.Results = this.SystemService.SetupSystem(systemName:"test",qryData:this.data);
		debug(local.Results);
		</cfscript>	
	</cffunction>
	
	<cffunction name="testSetupDataBeans" returntype="void" access="public">
		<cfscript>
		var local = structNew(); 
		makePublic(this.SystemService,"SetupDataBeans");
		local.Results = this.SystemService.SetupDataBeans(qryData:this.data.qryDataOriginal,rowcounter:10);
		debug(local.Results);
		</cfscript>	
	</cffunction>
	
	<cffunction name="testProcessData" returntype="void" access="public">
		<cfscript>
		var local = structNew();
		makePublic(this.SystemService,"ProcessData");
		local.Results = this.SystemService.ProcessData(qryData:this.data);
		debug(local.Results);
		</cfscript>	
	</cffunction>
	
	<cffunction name="testSetUpBeans" returntype="void" access="public">
		<cfscript>
		var local = structNew();
		makePublic(this.SystemService,"ProcessData");
		local.Data = this.SystemService.ProcessData(qryData:this.data);
		makePublic(this.SystemService,"SetUpBeans");
		local.Beans = this.SystemService.SetUpBeans(Data:local.data);
		debug(local.Beans);
		</cfscript>	
	</cffunction>
	
	<cffunction name="testFindTrades" returntype="void" access="public">
		<cfscript>
		var local = structNew();
		makePublic(this.SystemService,"ProcessData");
		local.Data = this.SystemService.ProcessData(qryData:this.data);
		makePublic(this.SystemService,"SetUpBeans");
		local.Beans = this.SystemService.SetupBeans(Data:local.data);
		local.Beans.TradeBean.Set("SystemName","BearishCandles");
		makePublic(this.SystemService,"FindTrades");
		local.Results = this.SystemService.FindTrades(Data:local.data,Beans:local.Beans);
		// trades are stored in the tradehistory
		debug(local.Results.GetMemento());
		</cfscript>	
	</cffunction>
			
	<cffunction name="tearDown" returntype="void" access="public">
		<!--- Any code needed to return your environment to normal goes here --->
	</cffunction>

</cfcomponent>

