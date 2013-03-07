<cfcomponent displayname="mxunit.framework.MyComponentTest"  extends="mxunit.framework.TestCase">

	<cffunction name="setUp" access="public" returntype="void">
	 <!---  <cfset super.TestCase(this) /> --->
	  <!--- Place additional setUp and initialization code here --->
		<cfscript>
		application.dsn = "cfstoxcloud";
		this.DataService 	= createObject("component","cfstox.model.DataService").init();
		this.DataDAO 		= createObject("component","cfstox.model.DataDao").init();
		this.AlertService	= createObject("component","cfstox.model.AlertService").init();
		this.http 		= createObject("component","cfstox.model.http").init();
		this.indicators = createObject("component","cfstox.model.indicators").init();
		this.controller = createObject("component","cfstox.controllers.controller").init();
		this.symbol 	= "ABX";
		this.startDate	= "01/01/2013";
		this.enddate	= dateformat(now()-1,"mm/dd/yyyy");
		</cfscript>
	</cffunction>

	<!--- <cffunction name="testSetDates" access="public" returntype="void">
		<cfscript>
		var local = structNew();
		local.data = this.DataService.SetDates(startdate:"2/1/2010",enddate:"6/10/2010");
		debug(local.data);
		</cfscript>
	</cffunction> --->

	<cffunction name="testGetRawDataGoogle" access="public" returntype="void">
		<cfscript>
		var local = structNew();
		local.Googledata = this.DataService.GetRawData(source:"Google",symbol:#this.symbol#,startdate:#this.startdate#,enddate:#this.enddate#);
		debug(local.Googledata);
		</cfscript>
	</cffunction>
	
	<cffunction name="testGetRawDataYahoo" access="public" returntype="void">
		<cfscript>
		var local = structNew();
		local.Yahoodata = this.DataService.GetRawData(source:"Yahoo",symbol:#this.symbol#,startdate:#this.startdate#,enddate:#this.enddate#);
		debug(local.Yahoodata);
		</cfscript>
	</cffunction>
	
	<cffunction name="testGetStockData" access="public" returntype="any">
		<cfscript>
		var local = structNew();
		local.data = this.DataService.GetStockData(symbol:#this.symbol#,startdate:#this.startdate#,enddate:#this.enddate#);
		debug(local.data);
		//local.data = this.DataService.GetHAStockData();
		//debug(local.data);
		return local.data;
		</cfscript>
	</cffunction>
			
	<cffunction name="testGetCurrentData" access="public" returntype="void">
		<cfscript>
		var local = structNew();
		local.theList = "ABX,X,SBUX,PBMD";
		local.data = this.DataService.GetCurrentData(SymbolList:local.theList);
		debug(local.data);
		</cfscript>
	</cffunction>
	
	<cffunction name="testGetAlerts" access="public" returntype="void">
		<cfscript>
		var local = structNew();
		local.data = this.AlertService.GetAlerts();
		debug(local.data);
		</cfscript>
	</cffunction>
		
	<cffunction name="testGetCurrentDataForSymbol" access="public" returntype="void">
		<cfscript>
		var local = structNew();
		testGetCurrentData();
		local.data = this.DataService.GetCurrentDataForSymbol("ABX");
		debug(local.data);
		</cfscript>
	</cffunction>
	
	<cffunction name="testCheckAlert" access="public" returntype="void">
		<cfscript>
		var local = structNew();
		testGetCurrentData();
		local.qryCurrData = this.DataService.GetCurrentDataForSymbol("ABX");
		local.qryAlerts = this.AlertService.GetAlerts();
		debug(local.qryCurrData);
		debug(local.qryAlerts);
		local.AlertTrigger = this.AlertService.checkAlert(QryCurrData:local.qryCurrdata,qryAlert:local.qryAlerts);
		debug(local.AlertTrigger);
		</cfscript>
	</cffunction>
	
	<cffunction name="testSendAlert" access="public" returntype="void">
		<cfscript>
		var local = structNew();
		local.AlertTrigger = this.AlertService.SendAlert(
		Symbol:"ABX"
		,Alert:"Stock has risen above resistance"
		,AlertPrice:"31"
		,currprice:"32"
		);
		</cfscript>
	</cffunction>
	
	<cffunction name="testGetSession" access="public" returntype="void">
		<cfscript>
		var local = structNew();
		debug(session);
		</cfscript>
	</cffunction>
	
	<cffunction name="testGetCurrentRawData" access="public" returntype="void">
		<cfscript>
		var local = structNew();
		local.theList = "ABX,X,SPY";
		local.data = this.DataService.GetCurrentRawData(SymbolList:local.theList);
		/* local.year = DatePart("yyyy",now());
		local.year = local.year - "1970";
		local.formatter = createObject("java","java.text.SimpleDateFormat"); 
		local.formatter.init("MMM dd,hh:mmaa zzz"); 
		local.date = local.formatter.Parse(local.data[1]["lt"]);
		local.date = DateAdd("yyyy",local.year,local.date ); 
		debug(local.date); */
		debug(local.data);
		debug(local.data[1]);
		debug(local.data[1].t);
		</cfscript>
	</cffunction>
	
	<cffunction name="testMergeData" access="public" returntype="void">
		<cfscript>
		var local = structNew();
		local.theList = "ABX,X,SBUX,PBMD";
		local.Currentdata = this.DataService.GetCurrentData(SymbolList:local.theList);
		//debug(local.Currentdata);
		local.results = this.DataService.GetRawData(symbol:"ABX",startdate:#this.startdate#,enddate:#this.enddate#);
		//debug(local.results);
		local.results = this.DataService.MergeData(Symbol:"ABX",Historical:local.results,Current:local.currentData);
		debug(local.results);
		</cfscript>
	</cffunction>
	
	<cffunction name="testCompareDates" access="public" returntype="void">
		<cfscript>
		var local = structNew();
		local.theList = "ABX,X,SBUX,PBMD";
		local.Currdata = this.DataService.GetCurrentData(SymbolList:local.theList);
		debug(local.Currdata);
		local.Data = this.DataService.GetStockData(symbol:#this.symbol#,startdate:#this.startdate#,enddate:#this.enddate#);
		debug(local.data);
		local.DateOne =DateFormat(local.data.orgData.dateOne[local.hdata.orgdata.recordcount],"mm-dd-yyyy");
		local.DateTwo =DateFormat(local.Currdata.dateOne,"mm-dd-yyyy");  
		debug(local.dateone);
		debug(local.datetwo);
		if (local.dateOne EQ local.DateTwo) {
		local.txtresult = "match!";
		}
		else{
		local.txtResult = "Different!";
		}
		debug(local.txtresult);
		</cfscript>
	</cffunction>
	
	<!--- End Specific Test Cases --->
	<cffunction name="tearDown" access="public" returntype="void">
	 <!--- Place tearDown/clean up code here --->
	</cffunction>
	
</cfcomponent>
