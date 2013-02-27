<cfcomponent output="false">

<cffunction name="AddWatchList" access="public" output="false" returntype="any">
		<cfargument name="symbol" required="true" />
		<cfset var local = StructNew() />
		<cfset local.qAddWatchlist = "" />
		<cfset local.strReturn = structNew() />
		<cftry>
			<cfquery name="local.qryAddWatchList" datasource="#application.dsn#">
			INSERT INTO Wathclist 
			(SYMBOL) 
			VALUES(
			 <cfqueryparam value="#arguments.Symbol#" CFSQLType="cf_sql_varchar"  />
			);
			</cfquery>
			<cfcatch type="database">
			<cfthrow type="dbError"
			message="Error occurred while connecting to the database:" detail="<br/>
			<strong>REASON:</strong><br/>
			#cfcatch.message#<br />
			<br /><strong>DETAIL:</strong>
			<br/>#cfcatch.detail#<br />
			<br /><strong>T-SQL EXECUTED:</strong>
			<br/>#cfcatch.sql# 
			<br/>: 
			<br/>:
			"
			/>
			<cfset return_value = false  />	
			</cfcatch>
		</cftry>
		<cfreturn local.qryGetAlerts />
	</cffunction>
INSERT INTO WATCHLIST ([SYMBOL])
VALUES (symbol);

</cfcomponent>