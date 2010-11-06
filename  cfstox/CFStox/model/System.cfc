<cfcomponent  displayname="system" hint="I test systems using given data" output="false">

<cffunction name="init" description="init method" access="public" displayname="init" output="false" returntype="system">
	<cfreturn this/>
</cffunction>

<!--- 
loop through the query and determine when the given conditions are true 
When they are true , put "open" in the results field.
When the close condition is activated, put "close" in the field
this function expects a single query row as an argument
--->
<cffunction name="testSystem" description="I test the system" access="public" displayname="test" output="false" returntype="Any">
	<cfargument name="qryData" required="true" />
	<cfargument name="fieldnames" required="true" />
	<cfset var local = structnew() />
	<cfset local.boolResult = true>
	<cfset local.counter = 1 />
	<cfset local.qryLen = arguments.qryData.recordcount />
	<!--- init array of last 30 results --->
	<!--- typically our systems will look for crossovers, values greater than or less than something. --->
	<!--- test if linear regression slope is less than .25 and stock made a new two week low --->
	<cfloop from="1" to="#local.qryLen#" index="i">
		<cfif NOT arguments.qrydata.LSRdelta[i] LTE -.25> 
			<cfset local.boolResult = false>
		</cfif>
		<cfif NOT arguments.qrydata.newOneWeekLow[i] > 
			<cfset local.boolResult = false>
		</cfif>
		<cfset local.counter = local.counter + 1 >
		<cfset arguments.qrydata.testresult[i] = local.boolResult />
	</cfloop>
	<cfreturn local.boolResult />
</cffunction>

<cffunction name="testSystem2" description="I test the system" access="public" displayname="test" output="false" returntype="Any">
	<cfargument name="theQuery" required="true" />
	<cfargument name="fieldnames" required="true" />
	<cfargument name="conditions" required="true" />
	<cfset var local = structNew() />
	<cfset indicator1 = arraynew(1) />
	<!--- typically our systems will look for crossovers, values greater than or less than something. --->
	<cfloop  query="arguments.theQuery">
		<cfset local.currRow = arguments.theQuery.currentrow />
		<cfif local.currow LTE 3>
			<cfset indicator1[local.currRow] = arguments.theQuery.fieldname />
		<cfelse>
			<cfset indicator1[1] =  indicator1[2] />
			<cfset indicator1[2] =  indicator1[3] />
			<cfset indicator1[3] =  arguments.theQuery.fieldname />
		</cfif>
	</cfloop>
	<cfreturn />
</cffunction>
	
<cffunction name="System_hekin_ashi" description="heiken-ashi system" access="public" displayname="test" output="false" returntype="Any">
	<cfargument name="QueryData" required="true" />
	<cfset var local = structNew() />
	<cfset local.longtrade = false />
	<cfset local.shorttrade = false />
	<cfset local.longentry 	= 0 />
	<cfset local.longexit 	= 0 />
	<cfset local.shortentry = 0 />
	<cfset local.shortexit 	= 0 />
	<cfset local.tlongp 	= 0 />
	<cfset local.tshortp 	= 0 />
	<cfset queryAddColumn(arguments.QueryData, "hklong"  ,'cf_sql_varchar', arrayNew( 1 ) ) />
	<cfset queryAddColumn(arguments.QueryData, "hkshort" ,'cf_sql_varchar', arrayNew( 1 ) ) />
	<cfset queryAddColumn(arguments.QueryData, "longp"  ,'cf_sql_varchar', arrayNew( 1 ) ) />
	<cfset queryAddColumn(arguments.QueryData, "shortp" ,'cf_sql_varchar', arrayNew( 1 ) ) />
	<cfset queryAddColumn(arguments.QueryData, "longe"  ,'cf_sql_varchar', arrayNew( 1 ) ) />
	<cfset queryAddColumn(arguments.QueryData, "shorte" ,'cf_sql_varchar', arrayNew( 1 ) ) />
	<cfset queryAddColumn(arguments.QueryData, "tlongp" ,'cf_sql_varchar', arrayNew( 1 ) ) />
	<cfset queryAddColumn(arguments.QueryData, "tshortp" ,'cf_sql_varchar', arrayNew( 1 ) ) />
	<!--- typically our systems will look for crossovers, values greater than or less than something. --->
	<cfloop  query="arguments.QueryData">
		<cfif arguments.QueryData.currentrow GTE 3>
			<!--- close greater than open; go long --->
			<cfif arguments.QueryData.close GT arguments.QueryData.open>
				<cfif local.longentry EQ 0>
					<cfset local.longentry 	= arguments.QueryData.open />
				</cfif>
				<cfif local.shorttrade >
					<cfset local.shortexit 	= arguments.QueryData.open>
					<cfset arguments.queryData["shortp"][arguments.queryData.currentrow] = local.shortentry - local.shortexit />
					<cfset arguments.queryData["shorte"][arguments.queryData.currentrow] = local.shortentry />
					<cfset local.shortentry = 0 />
					<cfset local.tshortp =  local.tshortp + arguments.queryData["shortp"][arguments.queryData.currentrow] />
				</cfif>
				<cfset local.longtrade = "true" />
				<cfset local.shorttrade = "false" />
			</cfif>
			<!---- close less than open; go short ---->
			<cfif arguments.QueryData.close LT arguments.QueryData.open>
				<cfif local.shortentry EQ 0>
					<cfset local.shortentry = arguments.QueryData.open />
				</cfif>
				<cfif local.longtrade >
					<cfset local.longexit	= arguments.QueryData.open /> 
					<cfset arguments.queryData["longp"][arguments.queryData.currentrow] = local.longexit - local.longentry  />
					<cfset arguments.queryData["longe"][arguments.queryData.currentrow] = local.longentry  />
					<cfset local.longentry 	= 0 />
					<cfset local.tlongp = local.tlongp + arguments.queryData["longp"][arguments.queryData.currentrow] />
				</cfif>
				<cfset local.shorttrade = "true" />
				<cfset local.longtrade 	= "false" />
			</cfif>
			<cfset arguments.queryData["hklong"][arguments.queryData.currentrow] = local.longtrade />
			<cfset arguments.queryData["hkshort"][arguments.queryData.currentrow] =  local.shorttrade />
		</cfif>
		<cfset arguments.queryData["tlongp"][arguments.queryData.currentrow] = local.tlongp /> 
		<cfset arguments.queryData["tshortp"][arguments.queryData.currentrow] = local.tshortp />					
	</cfloop>
			
	<cfreturn arguments.QueryData />
</cffunction>

<cffunction name="TrackTrades" description="I extract the trades from the querydata" access="public" displayname="TrackTrades" output="false" returntype="Query">
	<cfargument name="QueryData" required="true" />
	<cfset var local = structNew() />
	<cfset local.QueryData = duplicate(arguments.QueryData) />
	<!--- <cfset local.qry_Trades  = queryAddColumn(local.queryData, CF_SQL_VARCHAR)> --->
		
	<cfloop index = "currentRow" from = "#local.QueryData.recordCount#" to = "1" step = "-1">
		<!--- if no trade, delete row --->
		<cfif local.QueryData.longe EQ "" AND local.QueryData.shorte EQ "" >
			<cfset local.QueryData.removeRows( JavaCast( "int", (local.QueryData.CurrentRow - 1) ),  JavaCast( "int", 1 )  ) />	
		</cfif>
	</cfloop>
	<cfreturn local.QueryData />
</cffunction>

<cffunction name="NewHighLow" description="I find new highs and lows" access="public" displayname="" output="false" returntype="Array">
	<cfargument name="queryData" required="true"  />
	<cfset var local = Structnew() />
	<cfset local.previousHighValue 	= 0 />
	<cfset local.newHighDate 	= 0 />
	<cfset local.previousLowValue 	= 1000 />
	<cfset local.newLowDate 	= 0 />
	<cfset local.previousNewHigh = 0 />
	<cfset local.previousNewLow	 = 0 />
	<cfset local.newHighFlag = true />
	<cfset local.newLowFlag = true />
	<cfset local.HLData 		= arrayNew(2) />
	<cfset local.BreakOutData	= arrayNew(2) />
	<cfset local.BreakOutFlag	= false />
	<cfset local.arrayCounter 	= 1 />
	<cfset local.breakoutCounter 	= 1 />
	<!--- New High Low algorythm 
	Set NewHighFlag and NewLowFlag
	Use the first bar to establish new high and low starting values
	loop over the data 
	if the high is greater than currentHigh and NewLowFlag reset currentHigh and set NewHighFlag true and NewLowFlag false
	if the low is less than currentLow and NewHighFlag reset currentLow and set NewLowFlag true and newHighFlag false
	--->
	<cfloop  query="arguments.QueryData">
		<cfif arguments.queryData.high GT local.previousHighValue >
			<cfset local.newHighValue = arguments.queryData.high />
			<cfset local.newHighDate = arguments.queryData.DateOne />
			<cfset local.newHighFlag = true />
			<!--- <cfif local.newLowFlag> --->
				<cfset local.HLData[local.arrayCounter][1] = "high" />
				<cfset local.HLData[local.arrayCounter][2] = local.newHighValue />
				<cfset local.HLData[local.arrayCounter][3] = local.newHighDate />	
				<cfset local.arrayCounter = local.arrayCounter + 1 />
			<!--- </cfif> --->
			<!--- check for breakout 
				<cfif arguments.querydata.high GT local.previousNewHigh and NOT local.breakoutFlag>
					<cfset local.breakoutdata[local.breakoutCounter][1] = "new high" />
					<cfset local.breakoutdata[local.breakoutCounter][2] =  arguments.querydata.DateOne />
					<cfset local.breakoutdata[local.breakoutCounter][3] =  arguments.querydata.high />
					<cfset local.breakoutCounter = local.breakoutCounter + 1 />
					<cfset local.breakoutFlag = true />
					<cfset local.previousNewHigh = arguments.querydata.high />
				<cfelse>
					<cfset breakoutFlag = false />
				</cfif>   --->
		</cfif>
		<cfif arguments.queryData.low GT local.previouslowValue >
			<cfset local.newlowValue = arguments.queryData.low />
			<cfset local.newlowDate = arguments.queryData.DateOne />
			<cfset local.newlowFlag = true />
			<!--- <cfif local.newLowFlag> --->
				<cfset local.HLData[local.arrayCounter][1] = "low" />
				<cfset local.HLData[local.arrayCounter][2] = local.newlowValue />
				<cfset local.HLData[local.arrayCounter][3] = local.newlowDate />	
				<cfset local.arrayCounter = local.arrayCounter + 1 />
			<!--- </cfif> --->
			<!--- check for breakout 
				<cfif arguments.querydata.high GT local.previousNewHigh and NOT local.breakoutFlag>
					<cfset local.breakoutdata[local.breakoutCounter][1] = "new high" />
					<cfset local.breakoutdata[local.breakoutCounter][2] =  arguments.querydata.DateOne />
					<cfset local.breakoutdata[local.breakoutCounter][3] =  arguments.querydata.high />
					<cfset local.breakoutCounter = local.breakoutCounter + 1 />
					<cfset local.breakoutFlag = true />
					<cfset local.previousNewHigh = arguments.querydata.high />
				<cfelse>
					<cfset breakoutFlag = false />
				</cfif>   --->
		</cfif>
		<cfset local.previousHighValue = arguments.queryData.high />
		<cfset local.previousLowValue = arguments.queryData.low />
		</cfloop>
	<cfreturn local.hldata />
</cffunction>

</cfcomponent>