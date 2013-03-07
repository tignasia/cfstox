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
		
	<cffunction name="testGetAlertBeanbySymbol" access="public" returntype="void">
		<cfscript>
		var local = structNew();
		local.AlertBean 		= this.AlertService.GetAlertBean("ABX"); 
	 	debug(local.alertBean);
	 	debug(local.alertBean.getMemento());
		</cfscript>
	</cffunction>
	
	<cffunction name="testGetNewAlertBean" access="public" returntype="void">
		<cfscript>
		var local = structNew();
		local.Alert = structNew();
		local.Alert.SYMBOL = "SPY";
		local.Alert.VALUE = "155";
		local.Alert.ACTION = ">";
		local.Alert.ALERTED = "False";
		local.Alert.MESSAGE = "SPY above target go long";
		local.AlertBean = this.AlertService.GetAlertBean(beanData:local.Alert);
		debug(local.AlertBean);
		debug(local.AlertBean.GetMemento());
		</cfscript>
	</cffunction>
	
	<cffunction name="testCheckAlerts" access="public" returntype="void">
		<cfscript>
		var local = structNew();
		local.qryAlerts 		= this.AlertService.CheckAlerts(); 
	 	debug(local.qryAlerts);
		</cfscript>
	</cffunction>
		
	<cffunction name="testCheckAlertList" access="public" returntype="void">
		<!--- checkAlert(QryCurrData:local.qryCurrdata,qryAlert:local.qryAlerts)  --->
		<cfscript>
		var local = structNew();
		local.qryCurrdata 		= session.objects.dataService.getCurrentData(symbollist:"ABX");
		debug(local.qryCurrdata);
		local.qryAlerts 		= this.AlertService.GetAlerts();
		debug(local.qryAlerts);
		local.Checked 		= this.AlertService.CheckAlertList(QryCurrentData:local.qryCurrdata,qryAlerts:local.qryAlerts); 
	 	debug(local.Checked);
		</cfscript>
	</cffunction>
	
	<cffunction name="testGetAlerts" access="public" returntype="void">
		<cfscript>
		var local = structNew();
		local.qryAlerts 		= this.AlertService.GetAlerts(); 
	 	debug(local.qryAlerts);
		</cfscript>
	</cffunction>
	
	<cffunction name="testGetAlertSymbols" access="public" returntype="void">
		<cfscript>
		var local = structNew();
		local.qryAlerts 		= this.AlertService.GetAlerts(); 
	 	debug(local.qryAlerts);
		</cfscript>
	</cffunction>
	
	<cffunction name="testGetAlertList" access="public" returntype="void">
		<cfscript>
		var local = structNew();
		local.alertList = this.AlertService.GetAlertList();
	 	debug(local.alertList);
		</cfscript>
	</cffunction>
		
	<cffunction name="testSendAlert" access="public" returntype="void">
	<!--- <cfset SendAlert(Symbol:local.AlertSymbol,Alert:local.AlertMessage,AlertPrice:Local.AlertPrice) /> --->
		<cfscript>
		var local = structNew();
		local.AlertMail 	= this.AlertService.SendAlert(Symbol:"ABX",Alert:"Alert triggered on ABX : Go Short",AlertPrice:"55",Currprice:"54"); 
	 	debug(local.AlertMail);
		</cfscript>
	</cffunction>
	
	<cffunction name="testUpdateAlert" access="public" returntype="void">
	<!--- <cfset SendAlert(Symbol:local.AlertSymbol,Alert:local.AlertMessage,AlertPrice:Local.AlertPrice) /> --->
		<cfscript>
		var local = structNew();
		local.AlertBean 	= this.AlertService.GetAlertBean("ABX"); 
		local.AlertUpdate 	= this.AlertService.UpdateAlert(local.AlertBean); 
	 	debug(local.AlertUpdate.getMemento());
		</cfscript>
	</cffunction>
	
	<!--- End Specific Test Cases --->
	<cffunction name="tearDown" access="public" returntype="void">
	 <!--- Place tearDown/clean up code here --->
	</cffunction>
	
</cfcomponent>
