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
	<cfset local.qryAlerts 		= GetAlerts() />
	<cfset local.qryCurrdata 	= session.objects.dataService.getCurrentData() />
	<!--- loop over alerts  --->
	<cfloop query="local.qryAlerts" >
		<!--- for each element in alerts, find matching symbol in current data  --->
		
		<!--- check if alert triggered --->
		<cfset local.AlertTriggered = checkAlert(QryCurrData:local.qryCurrdata,qryAlert:local.qryAlerts) />
		<!--- if alert triggered --->
		<cfif local.AlertTriggered>
			<!--- send notification --->
			<cfset SendAlert(Symbol:local.AlertSymbol,Alert:local.AlertMessage,AlertPrice:Local.AlertPrice) />
			<!--- update alert status --->
			<!--- <cfset UpdateAlertStatus(Symbol:local.AlertSymbol,AlertMessage:local.Alert,AlertPrice:Local.AlertPrice) />
		 ---><!--- end if alert triggered --->	
		</cfif>
	<!--- end loop over alerts --->
	</cfloop>
	<cfreturn this />
	</cffunction>	

	<cffunction name="GetAlerts" access="public" returntype="any" output="false"
		hint="This gets the current alerts.">
		<cfset var LOCAL = StructNew() />
		<cfset local.qryAlerts = session.objects.DataDAO.getAlerts() />
		<cfreturn local.qryAlerts />
	</cffunction>
	
	<cffunction name="CheckAlert" description="" access="public" displayname="" output="false" returntype="any">
	<cfargument name="qryCurrData" 	required="true"  />
	<cfargument name="qryAlert" 	required="true"  />
	<cfset var LOCAL = StructNew() />
	<cfset local.AlertSymbol 	= local.qryAlert.Symbol />
	<cfset local.AlertAction 	= local.qryAlert.Action />
	<cfset local.AlertPrice 	= local.qryAlert.Price />
	<cfset local.AlertAlerted 	= local.qryAlert.Alerted />
	<cfset local.result 		= false />
	<cfquery dbtype="query" name="qryAlerts">
	SELECT DateOne,Open,High,Low,Close,Volume,SYMBOL
	<!--->DateOne,Open,High,Low,Close,Volume,SYMBOL--->
	FROM arguments.qryCurrentData
	WHERE arguments.qryCurrentData.Symbol = '#arguments.qryAlert.symbol#'
	</cfquery>
	
	<cfif local.AlertAction EQ "<" >
	</cfif>
	<cfif local.AlertAction EQ ">" >
	</cfif>
	
	<cfif arguments.qryCurrData.close GT arguments.qryAlert.Value>
		<cfset local.result = true />
	</cfif>
	<cfreturn local.result />
	</cffunction>	
	
	<cffunction name="SendAlert" description="" access="public" displayname="" output="false" returntype="any">
	<cfargument name="Symbol" 	required="true"  />
	<cfargument name="Alert" 	required="true"  />
	<cfargument name="AlertPrice" 	required="true"  />
	<cfargument name="CurrPrice" 	required="true"  />		
	<cfset local.AlertMessage = "An alert has been triggered for #arguments.symbol#." />
	<cfset local.AlertMessage = Local.AlertMessage & "The alert is: #arguments.Alert#" />
	<cfset local.AlertMessage = Local.AlertMessage & "Alert Price: #arguments.AlertPrice#" >
	<cfset local.AlertMessage = Local.AlertMessage & "Current Price: #arguments.Currprice#" >
	<cfset local.sendMail = session.objects.MailService.SendMail(subject:"Alert Triggered: #arguments.symbol#",emailBody:local.AlertMessage) >
	<cfreturn  />
	</cffunction>	

</cfcomponent>