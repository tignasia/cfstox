<cfcomponent displayname="mxunit.framework.MyComponentTest"  extends="mxunit.framework.TestCase">

	<cffunction name="setUp" access="public" returntype="void">
	 <!---  <cfset super.TestCase(this) /> --->
	  <!--- Place additional setUp and initialization code here --->
		<cfscript>
		this.System = createObject("component","cfstox.model.System").init();
		this.http = createObject("component","cfstox.model.http").init();
		this.indicators = createObject("component","cfstox.model.indicators").init();
		this.controller = createObject("component","cfstox.controllers.controller").init();
		</cfscript>
	</cffunction>

	<cffunction name="testSystemTrackTrades" access="public" returntype="void">
		<cfscript>
		var local = structNew();
		local.data = this.http.gethttp("ABX");
		local.data = this.System.System_hekin_ashi(queryData: local.data);
		local.query = this.System.TrackTrades(queryData: local.data);
		debug(local.query);
		</cfscript>
	</cffunction>

	<cffunction name="testSystemNewHighLow" access="public" returntype="void">
		<cfscript>
		var local = structNew();
		local.dataarray = this.controller.historical(Symbol:"ABX",startdate:"1/1/2009",enddate:"10/5/2010",hkconvert:"true");
		local.data = local.dataarray.stockdata;
		</cfscript>
		<cfquery   dbtype="query"  name="local.reverse">
			select * from [local].data order by DateOne asc
		</cfquery>
		<cfscript>
		local.data = local.reverse; 
		local.data = this.System.System_hekin_ashi(queryData: local.data);
		local.query = this.System.NewHighLow(queryData: local.data);
		debug(local.query);
		</cfscript>
	</cffunction>

	<!--- End Specific Test Cases --->
	<cffunction name="tearDown" access="public" returntype="void">
	 <!--- Place tearDown/clean up code here --->
	</cffunction>

</cfcomponent>
