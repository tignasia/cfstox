
<cfcomponent displayname="DataDAO" hint="table ID column = ">

	<cffunction name="init" access="public" output="false" returntype="DataDAO">
		<cfargument name="dsn" type="string" required="true">
		<cfset variables.dsn = arguments.dsn>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="create" access="public" output="false" returntype="boolean">
		<cfargument name="qryData" type="Query" required="true" />
		<cfset var local = StructNew() />
		<cfset local.qCreate = "" />
		<cftry>
			<cfquery name="local.qCreate" datasource="#variables.dsn#">
				INSERT INTO Stocks
					(Date
					,Symbol
					,Open
					,High
					,Low
					,Close
					,Volume
					)
				VALUES
					(
					<cfqueryparam value="#arguments.qryData.Date#" CFSQLType="cf_sql_timestamp" null="#not len(arguments.qryData.Date)#" />,
					<cfqueryparam value="#arguments.qryData.Symbol#" CFSQLType="cf_sql_char" null="#not len(arguments.qryData.Symbol)#" />,
					<cfqueryparam value="#arguments.qryData.Open#" CFSQLType="cf_sql_decimal" null="#not len(arguments.qryData.Open)#" />,
					<cfqueryparam value="#arguments.qryData.High#" CFSQLType="cf_sql_decimal" null="#not len(arguments.qryData.High)#" />,
					<cfqueryparam value="#arguments.qryData.Low#" CFSQLType="cf_sql_decimal" null="#not len(arguments.qryData.Low)#" />,
					<cfqueryparam value="#arguments.qryData.Close#" CFSQLType="cf_sql_decimal" null="#not len(arguments.qryData.Close)#" />,
					<cfqueryparam value="#arguments.qryData.Volume#" CFSQLType="cf_sql_integer" null="#not len(arguments.qryData.Volume)#" />
					)
			</cfquery>
			<cfcatch type="database">
				<cfreturn false />
			</cfcatch>
		</cftry>
		<cfreturn true />
	</cffunction>

	<cffunction name="read" access="public" output="false" returntype="void">
		<cfargument name="qryData" type="qryData" required="true" />
		<cfset var local = StructNew() />
		<cfset local.qRead = "" />
		<cfset local.strReturn = structNew() />
		<cftry>
			<cfquery name="local.qRead" datasource="#variables.dsn#">
				SELECT
					Date
					,Symbol
					,Open
					,High
					,Low
					,Close
					,Volume
				FROM	Stocks
				WHERE	
			</cfquery>
			<cfcatch type="database">
				<!--- leave the bean as is and set an empty query for the conditional logic below --->
				<cfset qRead = queryNew("id") />
			</cfcatch>
		</cftry>
		<cfif qRead.recordCount>
			<cfset strReturn = queryRowToStruct(qRead)>
			<cfset arguments.qryData.init(argumentCollection=strReturn)>
		</cfif>
	</cffunction>

	<cffunction name="update" access="public" output="false" returntype="boolean">
		<cfargument name="qryData" type="qryData" required="true" />
		<cfset var local = StructNew() />
		<cfset local.qUpdate = "" />
		<cftry>
			<cfquery name="local.qUpdate" datasource="#variables.dsn#">
				UPDATE	Stocks
				SET
					Date = <cfqueryparam value="#arguments.qryData.Date#" CFSQLType="cf_sql_timestamp" null="#not len(arguments.qryData.Date)#" />
					,Symbol = <cfqueryparam value="#arguments.qryData.Symbol#" CFSQLType="cf_sql_char" null="#not len(arguments.qryData.Symbol)#" />
					,Open = <cfqueryparam value="#arguments.qryData.Open#" CFSQLType="cf_sql_decimal" null="#not len(arguments.qryData.Open)#" />
					,High = <cfqueryparam value="#arguments.qryData.High#" CFSQLType="cf_sql_decimal" null="#not len(arguments.qryData.High)#" />
					,Low = <cfqueryparam value="#arguments.qryData.Low#" CFSQLType="cf_sql_decimal" null="#not len(arguments.qryData.Low)#" />
					,Close = <cfqueryparam value="#arguments.qryData.Close#" CFSQLType="cf_sql_decimal" null="#not len(arguments.qryData.Close)#" />
					,Volume = <cfqueryparam value="#arguments.qryData.Volume#" CFSQLType="cf_sql_integer" null="#not len(arguments.qryData.Volume)#" />
				WHERE	
			</cfquery>
			<cfcatch type="database">
				<cfreturn false />
			</cfcatch>
		</cftry>
		<cfreturn true />
	</cffunction>

	<cffunction name="delete" access="public" output="false" returntype="boolean">
		<cfargument name="qryData" type="qryData" required="true" />
		<cfset var qDelete = "">
		<cftry>
			<cfquery name="qDelete" datasource="#variables.dsn#">
				DELETE FROM	Stocks 
				WHERE	
			</cfquery>
			<cfcatch type="database">
				<cfreturn false />
			</cfcatch>
		</cftry>
		<cfreturn true />
	</cffunction>

	<cffunction name="exists" access="public" output="false" returntype="boolean">
		<cfargument name="qryData" type="qryData" required="true" />
		<cfset var qExists = "">
		<cfquery name="qExists" datasource="#variables.dsn#" maxrows="1">
			SELECT count(1) as idexists
			FROM	Stocks
			WHERE	
		</cfquery>
		<cfif qExists.idexists>
			<cfreturn true />
		<cfelse>
			<cfreturn false />
		</cfif>
	</cffunction>

	<cffunction name="save" access="public" output="false" returntype="boolean">
		<cfargument name="qryData" type="qryData" required="true" />
		<cfset var success = false />
		<cfif exists(arguments.qryData)>
			<cfset success = update(arguments.qryData) />
		<cfelse>
			<cfset success = create(arguments.qryData) />
		</cfif>
		<cfreturn success />
	</cffunction>

	<cffunction name="queryRowToStruct" access="private" output="false" returntype="struct">
		<cfargument name="qry" type="query" required="true">
		<cfscript>
			/**
			 * Makes a row of a query into a structure.
			 * 
			 * @param query 	 The query to work with. 
			 * @param row 	 Row number to check. Defaults to row 1. 
			 * @return Returns a structure. 
			 * @author Nathan Dintenfass (nathan@changemedia.com) 
			 * @version 1, December 11, 2001 
			 */
			//by default, do this to the first row of the query
			var row = 1;
			//a var for looping
			var ii = 1;
			//the cols to loop over
			var cols = listToArray(qry.columnList);
			//the struct to return
			var stReturn = structnew();
			//if there is a second argument, use that for the row number
			if(arrayLen(arguments) GT 1)
				row = arguments[2];
			//loop over the cols and build the struct from the query row
			for(ii = 1; ii lte arraylen(cols); ii = ii + 1){
				stReturn[cols[ii]] = qry[cols[ii]][row];
			}		
			//return the struct
			return stReturn;
		</cfscript>
	</cffunction>
</cfcomponent>
