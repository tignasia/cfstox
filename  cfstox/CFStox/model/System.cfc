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
		<cfset local.trade = false />
		<cfset queryAddColumn(arguments.QueryData, "hklong"  ,'cf_sql_varchar', arrayNew( 1 ) ) />
		<cfset queryAddColumn(arguments.QueryData, "hkshort" ,'cf_sql_varchar', arrayNew( 1 ) ) />
		<!--- typically our systems will look for crossovers, values greater than or less than something. --->
		<cfloop  query="arguments.QueryData">
			<cfif arguments.QueryData.currentrow GTE 3>
				<cfif arguments.QueryData.open GT arguments.QueryData.close>
					<cfif arguments.QueryData.open[currentrow-1] LT arguments.QueryData.close[currentrow-1]>
						<cfset local.trade = true>
						<cfset arguments.queryData["hklong"][arguments.queryData.currentrow] = "true">
					</cfif>
				</cfif>
				<cfif arguments.QueryData.open LT arguments.QueryData.close>
					<cfif arguments.QueryData.open[currentrow-1] GT arguments.QueryData.close[currentrow-1]>
						<cfset local.trade = true>
						<cfset arguments.queryData["hklong"][arguments.queryData.currentrow] = "false">
					</cfif>
				</cfif>
			</cfif>			
		</cfloop>
		
		<cfreturn QueryData />
	</cffunction>
</cfcomponent>