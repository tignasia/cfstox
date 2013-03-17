<cfcomponent output="false">
<!--- todo: init --->
<!--- todo: get actions from database --->
<!--- todo: check if action condition was triggered --->
<!--- todo: action:send mail alert --->
<!--- todo: action:send sms text message alert --->
<!--- todo: action:place trade --->

<!--- from list todo: 
send mail every 15 minutes
add interface to add alert
symbol, greater than, less than, price, message to send, sent or not field, notification methods
add ablity for multiple notification types
add systems; system name from dropdown, watchlist to apply to 
add TK API interface
eventually add trade table in database to trake trades, profit/loss
--->
<cffunction name="Init" description="" access="public" displayname="" output="false" returntype="AlertService">
	<cfreturn this />
</cffunction>	

	<cffunction name="CheckAlerts" description="" access="public" displayname="" output="false" returntype="any">
	<cfset var local = structNew() />
	<!--- get alerts --->
	<cfset local.qryAlerts 			= GetAlerts() />
	<cfset local.AlertSymbolList	= GetAlertList(local.qryAlerts) />
	<cfset local.qryCurrentdata = session.objects.dataService.getCurrentData(SymbolList:local.AlertSymbolList) />
	<cfset local.AlertList =  checkAlertList(QryCurrentData:local.qryCurrentdata,qryAlerts:local.qryAlerts) />
	<!--- loop over alerts  --->
	<cfloop array=#local.AlertList#  index="i" >
			<cfif i.AlertTriggered>
			<cfset SendAlert(Symbol:i.Symbol,Alert:i.Message,AlertPrice:i.value,CurrPrice:i.Currprice) />
			<cfset local.AlertBean = GetAlertBean(Symbol:i.symbol) /> 
			<cfset local.AlertBean.SetAlerted("True") />
			<cfset UpdateAlert(local.AlertBean) />
		 </cfif>
	<!--- end loop over alerts --->
	</cfloop>
	<cfreturn local />
	</cffunction>	
	
	<cffunction name="CheckAlertList" description="I return an array of structs for the alerts">
	<cfargument name="qryCurrentData" required="true">
	<cfargument name="qryAlerts" required="true">
	<cfset var local = StructNew() />
	<cfset local.AlertArray = arrayNew(1) >
	<!--- loop over alerts  --->
	<cfloop  query="arguments.qryAlerts"  >
		<!--- todo: put this is a seperate function  --->
		<cfset local.AlertArray[arguments.qryAlerts.currentRow] = StructNew() />
		<cfset local.AlertArray[arguments.qryAlerts.currentRow].SYMBOL 	= arguments.qryAlerts.symbol />
		<cfset local.AlertArray[arguments.qryAlerts.currentRow].VALUE 	= arguments.qryAlerts.value />
		<cfset local.AlertArray[arguments.qryAlerts.currentRow].ACTION 	= arguments.qryAlerts.Action  />
		<cfset local.AlertArray[arguments.qryAlerts.currentRow].ALERTED 	= arguments.qryAlerts.Alerted  />
		<cfset local.AlertArray[arguments.qryAlerts.currentRow].MESSAGE 	= arguments.qryAlerts.Message  />
		<cfset local.results = checkAlert(QryCurrentData:arguments.qryCurrentdata,qryAlert:arguments.qryAlerts) />
		<cfset local.AlertArray[arguments.qryAlerts.currentRow].AlertTriggered = local.results.AlertTriggered />
		<cfset local.AlertArray[arguments.qryAlerts.currentRow].Currprice = local.results.Currprice />
		
	</cfloop>
	<cfreturn local.AlertArray />
	</cffunction>
	
	<cffunction name="GetAlerts" access="public" returntype="any" output="false"
		hint="This gets the current alerts.">
		<cfset var LOCAL = StructNew() />
		<cfset local.qryAlerts = session.objects.AlertDAO.getAlerts() />
		<cfreturn local.qryAlerts />
	</cffunction>
	
	<cffunction name="GetAlertList" access="public" returntype="any" output="false"
		hint="This gets the current alerts.">
		<cfset var LOCAL = StructNew() />
		<cfset local.qry = session.objects.AlertDAO.GetAlertSymbols() />
		<cfset local.AlertList = ValueList(local.qry.Symbol) />
		<cfreturn local.AlertList />
	</cffunction>
	
	<cffunction name="UpdateAlert" access="public" returntype="any" output="false"
		hint="This updates the current alerts.">
		<cfargument name="AlertBean" 	required="true"  />
		<cfargument name="alertStatus" required="false" default="true">
		<cfset var LOCAL = StructNew() />
		<cfset arguments.AlertBean.SetAlerted(arguments.AlertStatus)>
		<cfset local.qryAlerts = session.objects.AlertDAO.UpdateAlert(alertBean:arguments.AlertBean) />
		<cfreturn arguments.alertBean />
	</cffunction>
	
	<cffunction name="SetAlert" access="public" returntype="any" output="false"
		hint="This updates the current alerts.">
		<cfargument name="AlertBean" 	required="true"  />
		<cfargument name="alertStatus" required="false" default="false">
		<cfset var LOCAL = StructNew() />
		<cfset arguments.AlertBean.SetAlerted(arguments.AlertStatus)>
		<cfset local.qryAlerts = session.objects.AlertDAO.AddAlert(alertBean:arguments.AlertBean) />
		<cfreturn arguments.alertBean />
	</cffunction>
	
	<cffunction name="CheckAlert" description="" access="public" displayname="" output="false" returntype="any">
	<cfargument name="qryCurrentData" 	required="true"  />
	<cfargument name="qryAlert" 	required="true"  />
	<cfset var LOCAL = StructNew() />
	<cfset local.AlertSymbol 	= arguments.qryAlert.Symbol />
	<cfset local.result 		= StructNew() />
	<cfset local.result.AlertTriggered = false />
	<cfquery dbtype="query" name="local.qryCurrentSymbol">
	SELECT 
	[DateOne]
	,[Open]
	,[High]
	,[Low]
	,[Close]
	,[SYMBOL]
	FROM qryCurrentData
	WHERE qryCurrentData.Symbol = '#local.AlertSymbol#'  
	</cfquery>
	<cfset local.result.Currprice = local.qryCurrentSymbol.close />
	<cfif arguments.qryAlert.Action EQ "<" AND local.qryCurrentSymbol.close LT arguments.qryAlert.value >
		<cfset local.result.AlertTriggered = true />
	</cfif>
	<cfif arguments.qryAlert.Action EQ ">" AND local.qryCurrentSymbol.close GT arguments.qryAlert.value >
		<cfset local.result.AlertTriggered = true />
	</cfif>
	<cfreturn local.result />
	</cffunction>	
	
	<cffunction name="SendAlert" description="" access="public" displayname="" output="false" returntype="any">
	<cfargument name="Symbol" 	required="true"  />
	<cfargument name="Alert" 	required="true"  />
	<cfargument name="AlertPrice" 	required="true"  />
	<cfargument name="CurrPrice" 	required="true"  />	
	<cfset CrLf = Chr(13) & Chr(10)> 	
	<cfset local.AlertMessage = "An alert has been triggered for #arguments.symbol#. " />
	<cfset local.AlertMessage &= "The alert is: #arguments.Alert# #Crlf#" />
	<cfset local.AlertMessage &= "Alert Price: #arguments.AlertPrice# " />
	<cfset local.AlertMessage &= "Current Price: #arguments.Currprice# #CrLf#" >
	<cfset local.AlertMessage &= "Link: http://stockcharts.com/h-sc/ui?s=#arguments.symbol# " >
	<cfset local.sendMail = session.objects.MailService.SendMail(subject:"Alert Triggered: #arguments.symbol#",emailBody:local.AlertMessage) >
	<cfreturn  />
	</cffunction>	

	<cffunction name="GetAlertBean" description="Get an alert bean and populate it" access="public" displayname="" output="false" returntype="any">
	<cfargument name="Symbol" 	required="false"  />
	<cfargument name="beanData" 	required="false"  />
	<!---- 
	beandata:
	local.Alert.SYMBOL = "SPY";
	local.Alert.VALUE = "155";
	local.Alert.ACTION = ">";
	local.Alert.ALERTED = "False";
	local.Alert.MESSAGE = "SPY above target go long";
	---->
	<cfset var local = structNew() />
	<!---- get alert data and populate an alert bean --->
	<cfif structKeyExists(arguments,"Symbol")>
		<cfset local.qryAlerts = session.objects.AlertDAO.getAlerts(symbol:arguments.symbol) />
		<cfset local.Alert.SYMBOL 	= local.qryAlerts.symbol />
		<cfset local.Alert.VALUE 	= local.qryAlerts.value />
		<cfset local.Alert.ACTION 	= local.qryAlerts.Action  />
		<cfset local.Alert.ALERTED 	= local.qryAlerts.Alerted  />
		<cfset local.Alert.MESSAGE 	= local.qryAlerts.Message  />
		<cfset local.AlertBean = createObject("component","cfstox.model.AlertBean").init(argumentcollection:local.Alert) />
	</cfif>
	<cfif structKeyExists(arguments,"beanData")>
		<cfset local.AlertBean = createObject("component","cfstox.model.AlertBean").init(argumentcollection:arguments.beanData) />
	<cfelse>
		<cfset local.AlertBean = createObject("component","cfstox.model.AlertBean").init() />
	</cfif>
	<cfreturn  local.AlertBean />
	</cffunction>
		
</cfcomponent>