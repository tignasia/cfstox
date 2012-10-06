<cfcomponent displayname="mxunit.framework.MyComponentTest"  extends="mxunit.framework.TestCase">

	<cffunction name="setUp" access="public" returntype="void">
	 <!---  <cfset super.TestCase(this) /> --->
	  <!--- Place additional setUp and initialization code here --->
		<cfscript>
		this.DataService 	= createObject("component","cfstox.model.DataService").init();
		this.http 		= createObject("component","cfstox.model.http").init();
		this.indicators = createObject("component","cfstox.model.indicators").init();
		this.controller = createObject("component","cfstox.controllers.controller").init();
		this.symbol 	= "RVBD";
		this.startDate	= "02/01/2012";
		this.enddate	= "03/01/2012"
		</cfscript>
	</cffunction>

	<cffunction name="testSetDates" access="public" returntype="void">
		<cfscript>
		var local = structNew();
		local.data = this.DataService.SetDates(startdate:"2/1/2010",enddate:"6/10/2010");
		debug(local.data);
		</cfscript>
	</cffunction>

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
	
	<cffunction name="testGetStockData" access="public" returntype="void">
		<cfscript>
		var local = structNew();
		local.data = this.DataService.GetStockData(symbol:#this.symbol#,startdate:#this.startdate#,enddate:#this.enddate#);
		debug(local.data);
		//local.data = this.DataService.GetHAStockData();
		//debug(local.data);
		</cfscript>
	</cffunction>
				
	<cffunction name="testGetStockDataGoogle" access="public" returntype="void">
		<cfscript>
		var local = structNew();
		local.data = this.DataService.GetStockDataGoogle(symbol:"ABX",startdate:"2/1/2010",enddate:"6/10/2010");
		debug(local.data);
		</cfscript>
	</cffunction>
		
	<!--- End Specific Test Cases --->
	<cffunction name="tearDown" access="public" returntype="void">
	 <!--- Place tearDown/clean up code here --->
	</cffunction>

</cfcomponent>
