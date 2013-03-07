<cfcomponent displayname="mxunit.framework.MyComponentTest"  extends="mxunit.framework.TestCase">

	<cffunction name="setUp" access="public" returntype="void">
	 <!---  <cfset super.TestCase(this) /> --->
	  <!--- Place additional setUp and initialization code here --->
		<cfscript>
		application.dsn 	= "cfstoxcloud";
		this.controller 	= createObject("component","cfstox.controllers.controller").init();
		this.AlertDAO 		= createObject("component","cfstox.model.AlertDAO").init();
		this.AlertService	= createObject("component","cfstox.model.AlertService").init();
		</cfscript>
	</cffunction>
	
	<cffunction name="testAddAlert" access="public" returntype="void">
		<cfscript>
		var local = structNew();
		local.Alert = structNew();
		local.Alert.SYMBOL = "ABX";
		local.Alert.VALUE = "29";
		local.Alert.ACTION = ">";
		local.Alert.ALERTED = "False";
		local.Alert.MESSAGE = "Test for ABX";
		local.AlertBean = this.AlertService.GetAlertBean(beanData:local.Alert);
		debug(local.AlertBean);
		debug(local.AlertBean.GetMemento());
		local.qryAddAlert = this.AlertDAO.AddAlert(local.AlertBean);
		debug(local.qryAddAlert);
		</cfscript>
	</cffunction>
	
	<cffunction name="testGetAlert" access="public" returntype="void">
		<cfscript>
		var local = structNew();
		local.qryAddAlert = this.AlertDAO.GetAlerts(symbol:"ABX");
		debug(local.qryAddAlert);
		</cfscript>
	</cffunction>
	
	<cffunction name="testGetSymbols" access="public" returntype="void">
		<cfscript>
		var local = structNew();
		local.qryAddAlert = this.AlertDAO.GetAlertSymbols();
		debug(local.qryAddAlert);
		</cfscript>
	</cffunction>
	
	<cffunction name="testGetAllAlerts" access="public" returntype="void">
		<cfscript>
		var local = structNew();
		local.qryAddAlert = this.AlertDAO.GetAlerts();
		debug(local.qryAddAlert);
		</cfscript>
	</cffunction>
	
	<cffunction name="testUpdateAlert" access="public" returntype="void">
		<cfscript>
		var local = structNew();
		debug(session);
		</cfscript>
	</cffunction>
	
	<cffunction name="testDeleteAlert" access="public" returntype="void">
		<cfscript>
		var local = structNew();
		debug(session);
		</cfscript>
	</cffunction>
	
	<!--- End Specific Test Cases --->
	<cffunction name="tearDown" access="public" returntype="void">
	 <!--- Place tearDown/clean up code here --->
	</cffunction>
	
</cfcomponent>
