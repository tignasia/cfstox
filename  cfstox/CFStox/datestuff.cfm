<cfoutput>
<cfset session.objects.XMLGenerator 	= createobject("component","cfstox.model.XMLGenerator").init() />
	<cfset session.objects.Indicators 		= createobject("component","cfstox.model.Indicators").init() />
	<cfset session.objects.Utility 			= createobject("component","cfstox.model.Utility").init() />
	<cfset session.objects.ta 				= createObject("component","cfstox.model.ta").init() />
	<cfset session.objects.http 			= createObject("component","cfstox.model.http").init() />
	<cfset session.objects.System 			= createObject("component","cfstox.model.system").init() />
	<cfset session.objects.DataService 		= createObject("component","cfstox.model.Dataservice").init() />
	<cfset session.objects.SystemService 	= createObject("component","cfstox.model.SystemService").init() />
	<cfset session.objects.SystemRunner 	= createObject("component","cfstox.model.SystemRunner").init() />
	<cfset session.objects.SystemTriggers	= createObject("component","cfstox.model.SystemTriggers").init() />
	<cfset session.objects.ReportService	= createObject("component","cfstox.model.ReportService").init() />
	<cfset session.objects.DataDAO			= createObject("component","cfstox.model.DataDAO").init() />
<!--- load SPY  --->
<cfset startdate = "11/01/2011" />
<cfset enddate = now() />
<cfset symbol = "SPY" />
<cfset qrySPYdata = session.objects.DataService.GetStockDataGoogle(symbol:"SPY",startdate:"#startdate#",enddate:"#enddate#")/>  
<cfdump label="SPYdata" var="#qrySPYdata.googledata#">	
<!--- delete existing --->
<cfset local.qryStock = session.objects.DataDAO.Delete(symbol:"SPY") />
<!--- insert new --->
<cfset local.symbolArray = ArrayNew(1) >
<cfloop from="1" to="#qrySPYdata.googledata.recordcount#" index="i">
 <cfset local.symbolArray[i] = symbol>
</cfloop>
<cfset queryAddColumn(qrySPYdata.googledata,"Symbol",'VarChar',local.symbolArray) > 
<cfloop query="qrySPYdata.googledata" >
	<!--- <cfset local.qryStock = session.objects.DataDAO.Create(local.qryStock.currentrow) /> --->
	<cfset crow = session.objects.utility.QrytoStruct(qrySPYdata.googledata,qrySPYdata.googledata.currentrow) />
	<cfset local.qryStock = session.objects.DataDAO.Create(crow) />
</cfloop>
<!--- read back  --->
<cfset local.qryStock = session.objects.DataDAO.Read(symbol:"SPY") />
<cfdump label="result:" var="#local.qryStock#">
</cfoutput>	
<!--- 
<cfset startdate = "05/01/1958">
#startdate#<br/>
<cfset startdate = DateAdd('d',-1,startdate) />
DateAdd: #startdate#<br/>
<cfset startDate = DateFormat(startdate,"mm-dd-yyyy")>
DateFormat: #startdate#<br/>
<cfset startdate = DateAdd('d',-1,startdate) />
DateAdd: #startdate#<br/>
DayofWeek:#DayofWeek(startdate)#<br/>
Mydate:<br/>
<cfset mydate = Now() />
#mydate#<br/>
<cfset mydate = DateAdd('d',-1,mydate) />
#mydate#<br/>
</cfoutput>

<cfset local.MarketFlag = false>
		<cfset arguments.startDate = DateFormat(arguments.startdate, "mm-dd-yyyy")>
		<cfset local.DayofWeek = DayofWeek("#arguments.startdate#") />
		<!--- see if we have data for the startdate --->
		<cfset local.qryStock = session.objects.DataDAO.Read(symbol:"SPY",date:"arguments.startdate") />
		<cfif local.qryStock.recordcount EQ 1> <!--- market was open --->
			<cfset local.MarketFlag = true />		
		</cfif>
		<cfif local.MarketFlag EQ FALSE >
			<cfloop from="-1" to="-14" index="i" step="-1">
	  			<cfset arguments.StartDate = DateAdd('d',i,arguments.startdate) /> 
	  			<cfset local.qryStock = session.objects.DataDAO.Read(symbol:"SPY",date:"arguments.startdate") />
	  			<cfif local.qryStock.recordcount EQ 1> <!--- market was open --->
					<cfset local.MarketFlag = true />		
					<cfbreak>
				</cfif>
			</cfloop>
		</cfif>
 --->
