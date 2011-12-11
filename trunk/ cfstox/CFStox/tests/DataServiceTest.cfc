<cfcomponent displayname="mxunit.framework.MyComponentTest"  extends="mxunit.framework.TestCase">

	<cffunction name="setUp" access="public" returntype="void">
	 <!---  <cfset super.TestCase(this) /> --->
	  <!--- Place additional setUp and initialization code here --->
		<cfscript>
		this.System 	= createObject("component","cfstox.model.system").init();
		this.DataService 	= createObject("component","cfstox.model.DataService").init();
		this.http 		= createObject("component","cfstox.model.http").init();
		this.indicators = createObject("component","cfstox.model.indicators").init();
		this.controller = createObject("component","cfstox.controllers.controller").init();
		session.objects.DataDAO = createObject("component","cfstox.model.DataDao").init("CFStox");
		</cfscript>
	</cffunction>

<!---  
SetDates
GetRawData
GetStockData
GetStockDataGoogle
--->

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
		local.Googledata = this.DataService.GetRawData(source:"Google",symbol:"ABX",startdate:"2/1/2010",enddate:"6/10/2010");
		debug(local.Googledata);
		</cfscript>
	</cffunction>
	
	<cffunction name="testGetRawDataYahoo" access="public" returntype="void">
		<cfscript>
		var local = structNew();
		local.Yahoodata = this.DataService.GetRawData(source:"Yahoo",symbol:"ABX",startdate:"2/1/2010",enddate:"6/10/2010");
		debug(local.Yahoodata);
		</cfscript>
	</cffunction>
	
	<cffunction name="testGetStockData" access="public" returntype="void">
		<cfscript>
		var local = structNew();
		local.data = this.DataService.GetStockData(symbol:"ABX",startdate:"2/1/2010",enddate:"6/10/2010");
		debug(local.data);
		//local.data = this.DataService.GetHAStockData();
		//debug(local.data);
		</cfscript>
	</cffunction>
			
	<!--- <cffunction name="testGetStockDataGoogle" access="public" returntype="void">
		<cfscript>
		var local = structNew();
		local.data = this.DataService.GetStockDataGoogle(symbol:"ABX",startdate:"2/1/2010",enddate:"6/10/2010");
		debug(local.data);
		</cfscript>
	</cffunction>
	 --->
	<!--- <cffunction name="testGetStockDataSDate" access="public" returntype="void">
		<cfscript>
		var local = structNew();
		local.data = this.DataService.GetStockData(symbol:"ABX",startdate:"1/1/2010");
		assert(local.data.DateOne[1] EQ "1/1/2010" );
		</cfscript>
	</cffunction>
	
	<cffunction name="testGetStockDataEDate" access="public" returntype="void">
		<cfscript>
		var local = structNew();
		local.data = this.DataService.GetStockData(symbol:"ABX",enddate:"5/10/2010");
		debug(local.data);
		</cfscript>
	</cffunction>
	
	<cffunction name="testGetStockDataSEDate" access="public" returntype="void">
		<cfscript>
		var local = structNew();
		local.data = this.DataService.GetStockData(symbol:"ABX",startdate:"2/1/2010",enddate:"6/10/2010");
		debug(local.data);
		</cfscript>
	</cffunction>
	 --->
	

	<!--- End Specific Test Cases --->
	<cffunction name="tearDown" access="public" returntype="void">
	 <!--- Place tearDown/clean up code here --->
	</cffunction>

</cfcomponent>