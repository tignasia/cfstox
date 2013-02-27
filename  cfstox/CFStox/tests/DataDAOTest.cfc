<cfcomponent displayname="mxunit.framework.MyComponentTest"  extends="mxunit.framework.TestCase">

	<cffunction name="setUp" access="public" returntype="void">
	 <!---  <cfset super.TestCase(this) /> --->
	  <!--- Place additional setUp and initialization code here --->
		<cfscript>
		application.dsn = "cfstoxcloud";
		this.DataDAO 		= createObject("component","cfstox.model.DataDao").init();
		</cfscript>
	</cffunction>
			
	<cffunction name="testGetAlerts" access="public" returntype="void">
		<cfscript>
		var local = structNew();
		local.data = this.DataDAO.GetAlerts();
		debug(local.data);
		</cfscript>
	</cffunction>
	
	<cffunction name="testGetWatchlist" access="public" returntype="void">
		<cfscript>
		var local = structNew();
		local.data = this.DataDAO.GetWatchlist();
		debug(local.data);
		</cfscript>
	</cffunction>
		
	<!--- End Specific Test Cases --->
	<cffunction name="tearDown" access="public" returntype="void">
	 <!--- Place tearDown/clean up code here --->
	</cffunction>
	
</cfcomponent>
