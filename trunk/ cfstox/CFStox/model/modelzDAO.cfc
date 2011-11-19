
<cfcomponent displayname="HistoryDAO" hint="table ID column = ">

	<cffunction name="init" access="public" output="false" returntype="modelzDAO">
		<cfargument name="dsn" type="string" required="true">
		<cfset variables.dsn = arguments.dsn>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="create" access="public" output="false" returntype="boolean">
		<cfargument name="qryData" type="Query" required="true" />
		<cfset var return_value = true  />
		<cfset var qCreate = "" />
		<cftry>
			<cfquery name="qCreate" datasource="#application.dsn#">
				INSERT INTO History
					(
					DATEONE
					,SYMBOL
					,Open
					,High
					,Low
					,Close
					,Volume
					)
				VALUES
					(
					<cfqueryparam value="#arguments.qryData.DATEONE#" CFSQLType="cf_sql_date" null="#not len(arguments.qryData.getDATEONE())#" />
					,<cfqueryparam value="#arguments.qryData.SYMBOL#" CFSQLType="cf_sql_varchar" null="#not len(arguments.qryData.SYMBOL)#" />
					,<cfqueryparam value="#arguments.qryData.Open#" CFSQLType="cf_sql_varchar" null="#not len(arguments.qryData.Open)#" />
					,<cfqueryparam value="#arguments.qryData.High#" CFSQLType="cf_sql_varchar" null="#not len(arguments.qryData.High)#" />
					,<cfqueryparam value="#arguments.qryData.Low#" CFSQLType="cf_sql_varchar" null="#not len(arguments.qryData.Low)#" />
					,<cfqueryparam value="#arguments.qryData.Close#" CFSQLType="cf_sql_varchar" null="#not len(arguments.qryData.Close)#" />
					,<cfqueryparam value="#arguments.qryData.Volume#" CFSQLType="cf_sql_varchar" null="#not len(arguments.qryData.Volume)#" />
					)
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
		<cfreturn return_value />
	</cffunction>

	<cffunction name="getqryData" access="public" output="false" returntype="query">
		<cfargument name="date" required="false" default="" />
		<cfargument name="symbol" required="true" default="" />
		<cfset var qryGetqryData = "" />
			<cftry>
			<cfquery name="qryGetqryData" datasource="#variables.dsn#">
				SELECT					
					, History.DATEONE
					, History.SYMBOL
					, History.Open
					, History.High
					, History.Low
					, History.Close
					, History.Volume
				FROM	History
				WHERE	1=1 
				<cfif len(arguments.SYMBOL)>
					AND History.SYMBOL = <cfqueryparam value="#arguments.SYMBOL)#"  />
				</cfif>
				<cfif len(arguments.date)>
					AND History.DATEONE = <cfqueryparam value="#arguments.date)#"  />
				</cfif>
				
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
			</cfcatch>
		</cftry>
		<cfreturn qryGetqryData />
	</cffunction>
	
	<cffunction name="update" access="public" output="false" returntype="boolean">
		<cfargument name="qryData" type="qryData" required="true" />

		<cfset var qUpdate = "" />
		<cftry>
			<cfquery name="qUpdate" datasource="#variables.dsn#">
				UPDATE	History
				SET
					DATEONE = <cfqueryparam value="#arguments.qryData.getDATEONE()#" CFSQLType="" null="#not len(arguments.qryData.getDATEONE())#" />,
					SYMBOL = <cfqueryparam value="#arguments.qryData.getSYMBOL()#" CFSQLType="cf_sql_varchar" null="#not len(arguments.qryData.getSYMBOL())#" />,
					Open = <cfqueryparam value="#arguments.qryData.getOpen()#" CFSQLType="cf_sql_varchar" null="#not len(arguments.qryData.getOpen())#" />,
					High = <cfqueryparam value="#arguments.qryData.getHigh()#" CFSQLType="cf_sql_varchar" null="#not len(arguments.qryData.getHigh())#" />,
					Low = <cfqueryparam value="#arguments.qryData.getLow()#" CFSQLType="cf_sql_varchar" null="#not len(arguments.qryData.getLow())#" />,
					Close = <cfqueryparam value="#arguments.qryData.getClose()#" CFSQLType="cf_sql_varchar" null="#not len(arguments.qryData.getClose())#" />,
					Volume = <cfqueryparam value="#arguments.qryData.getVolume()#" CFSQLType="cf_sql_varchar" null="#not len(arguments.qryData.getVolume())#" />
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
				DELETE FROM	History 
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
			FROM	History
			WHERE	History.DATEONE = qryData.DATEONE
			AND History.SYMBOL = qryData.SYMBOL
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
