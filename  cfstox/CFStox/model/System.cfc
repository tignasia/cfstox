<cfcomponent  displayname="system" hint="I test systems using given data" output="false">

<cffunction name="init" description="init method" access="public" displayname="init" output="false" returntype="system">
	<!--- persistent variable to store trades and results --->
	<cfset variables.TradeArray = ArrayNew(2) />
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
	<cfset local.longprofit 	= 0 />
	<cfset local.shortprofit 	= 0 />
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
		<cfset local.rowcount = arguments.QueryData.currentrow />
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

<cffunction name="SystemHKBreakdown" description="catch drops in stocks" access="public" displayname="SystemHKBreakdown" output="false" returntype="Any">
	<!--watch for two red candles and inside day ; set short entry at S1 pivot point of the two candles combined 
	use reverse SAR as exit (give it more room the longer the move lasts) --->
	<cfreturn />
</cffunction>

<cffunction name="TrackTrades" description="I extract the trades from the querydata" access="public" displayname="TrackTrades" output="false" returntype="Query">
	<cfargument name="QueryData" required="true" />
	<cfset var local = structNew() />
	<cfset local.QueryData = duplicate(arguments.QueryData) />
	<cfloop index = "currentRow" from = "#local.QueryData.recordCount#" to = "1" step = "-1">
		<!--- if no trade, delete row --->
		<cfif local.QueryData.longe EQ "" AND local.QueryData.shorte EQ "" >
			<cfset local.QueryData.removeRows( JavaCast( "int", (local.QueryData.CurrentRow - 1) ),  JavaCast( "int", 1 )  ) />	
		</cfif>
	</cfloop>
	<cfreturn local.QueryData />
</cffunction>

<cffunction name="NewHL3" description="I find new highs and lows" access="public" displayname="" output="false" returntype="Array">
	<cfargument name="queryData" required="true"  />
	<cfset var local = Structnew() />
	<cfset local.HLData = arrayNew(2) />
	<cfset local.arrayCounter= 1 />
	<cfset local.PrevHigh 	= 0 />
	<cfset local.PrevLow 	= 10000 />
	<!--- New High Low algorythm 
	If low -2 > low-1 AND low -1 < low, save low -1 and date to array
	If low -1 < last saved value, flag as breakdown 
	If high -2 < high-1 AND high -1 > high, save high -1 and date to array
	If high -1 > last saved value, flag as breakout 
	--->
	<cfloop  query="arguments.QueryData" startrow="3">
		<cfset local.rowcount = arguments.QueryData.currentrow />
		<cfif arguments.queryData.high[local.rowcount-2] LT arguments.queryData.high[local.rowcount-1] AND
			arguments.queryData.high[local.rowcount-1] GT arguments.queryData.high  >
			<cfset local.HLData[local.arrayCounter][1] = "high" />
			<cfset local.HLData[local.arrayCounter][2] = arguments.queryData.high[local.rowcount-1] />
			<cfset local.HLData[local.arrayCounter][3] = arguments.queryData.DateOne[local.rowcount-1] />	
			<!--- check for breakout --->
			<cfif arguments.queryData.high[local.rowcount-1] GT local.prevHigh >
				<cfset local.HLData[local.arrayCounter][4] = "breakout" />
			</cfif>
		   <cfset local.prevHigh = arguments.queryData.high[local.rowcount-1] />
		   <cfset local.arrayCounter = local.arrayCounter + 1 />
		</cfif>
		<cfif arguments.queryData.low[local.rowcount-2] GT arguments.queryData.low[local.rowcount-1] AND
			arguments.queryData.low[local.rowcount-1] LT arguments.queryData.low  >
			<cfset local.HLData[local.arrayCounter][1] = "low" />
			<cfset local.HLData[local.arrayCounter][2] = arguments.queryData.low[local.rowcount-1] />
			<cfset local.HLData[local.arrayCounter][3] = arguments.queryData.DateOne[local.rowcount-1] />	
			<!--- check for breakout --->
			<cfif arguments.queryData.low[local.rowcount-1] LT local.prevLow >
				<cfset local.HLData[local.arrayCounter][4] = "breakdown" />
			</cfif>
		   <cfset local.prevLow = arguments.queryData.low[local.rowcount-1] />
		   <cfset local.arrayCounter = local.arrayCounter + 1 />
		</cfif>
	</cfloop>
	<cfreturn local.hldata />
</cffunction>


</cfcomponent>