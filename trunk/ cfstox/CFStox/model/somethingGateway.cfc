
<cfcomponent displayname="somethingGateway" output="false">
	<cffunction name="init" access="public" output="false" returntype="somethingGateway">
		<cfargument name="dsn" type="string" required="true" />
		<cfset variables.dsn = arguments.dsn />
		<cfreturn this />
	</cffunction>
	
	<cffunction name="getByAttributes" access="public" output="false" returntype="query">
		<cfargument name="Date" type="date" required="false" />
		<cfargument name="Symbol" type="string" required="false" />
		<cfargument name="Open" type="numeric" required="false" />
		<cfargument name="High" type="numeric" required="false" />
		<cfargument name="Low" type="numeric" required="false" />
		<cfargument name="Close" type="numeric" required="false" />
		<cfargument name="Volume" type="numeric" required="false" />
		<cfargument name="orderby" type="string" required="false" />
		
		<cfset var qList = "" />		
		<cfquery name="qList" datasource="#variables.dsn#">
			SELECT
				Date,
				Symbol,
				Open,
				High,
				Low,
				Close,
				Volume
			FROM	Stocks
			WHERE	0=0
		
		<cfif structKeyExists(arguments,"Date") and len(arguments.Date)>
			AND	Date = <cfqueryparam value="#arguments.Date#" CFSQLType="cf_sql_timestamp" />
		</cfif>
		<cfif structKeyExists(arguments,"Symbol") and len(arguments.Symbol)>
			AND	Symbol = <cfqueryparam value="#arguments.Symbol#" CFSQLType="cf_sql_char" />
		</cfif>
		<cfif structKeyExists(arguments,"Open") and len(arguments.Open)>
			AND	Open = <cfqueryparam value="#arguments.Open#" CFSQLType="cf_sql_decimal" />
		</cfif>
		<cfif structKeyExists(arguments,"High") and len(arguments.High)>
			AND	High = <cfqueryparam value="#arguments.High#" CFSQLType="cf_sql_decimal" />
		</cfif>
		<cfif structKeyExists(arguments,"Low") and len(arguments.Low)>
			AND	Low = <cfqueryparam value="#arguments.Low#" CFSQLType="cf_sql_decimal" />
		</cfif>
		<cfif structKeyExists(arguments,"Close") and len(arguments.Close)>
			AND	Close = <cfqueryparam value="#arguments.Close#" CFSQLType="cf_sql_decimal" />
		</cfif>
		<cfif structKeyExists(arguments,"Volume") and len(arguments.Volume)>
			AND	Volume = <cfqueryparam value="#arguments.Volume#" CFSQLType="cf_sql_integer" />
		</cfif>
		<cfif structKeyExists(arguments, "orderby") and len(arguments.orderBy)>
			ORDER BY #arguments.orderby#
		</cfif>
		</cfquery>
		
		<cfreturn qList />
	</cffunction>

</cfcomponent>
