<cfcomponent displayname="mxunit.framework.MyComponentTest"  extends="mxunit.framework.TestCase">

	<cffunction name="setUp" access="public" returntype="void">
	 <!---  <cfset super.TestCase(this) /> --->
	  <!--- Place additional setUp and initialization code here --->
		<cfscript>
		application.dsn 	= "cfstoxcloud";
		this.controller 	= createObject("component","cfstox.controllers.controller").init();
		this.AlertService 	= createObject("component","cfstox.model.AlertService").init();
		</cfscript>
	</cffunction>
	
	<cffunction name="testCheckSessionIntegrity" access="public" returntype="void">
		<cfscript>
		var local = structNew();
		debug(session);
		</cfscript>
	</cffunction>
			
	<cffunction name="testGetAlerts" access="public" returntype="void">
		<cfscript>
		var local = structNew();
		local.qryAlerts 		= this.AlertService.GetAlerts(); 
	 	local.qryCurrdata 		= session.objects.dataService.getCurrentData();
		debug(local.qryAlerts);
		debug(local.qryCurrentData);
		</cfscript>
	</cffunction>
		
	<!--- End Specific Test Cases --->
	<cffunction name="tearDown" access="public" returntype="void">
	 <!--- Place tearDown/clean up code here --->
	</cffunction>
	
</cfcomponent>
