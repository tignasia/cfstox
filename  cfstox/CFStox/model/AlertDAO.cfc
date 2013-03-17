<cfcomponent displayname="AlertDAO" hint="table ID column = ">

	<cffunction name="init" access="public" output="false" returntype="AlertDAO">
		<cfargument name="dsn" type="string" required="false" default="CFStox">
		<cfset variables.dsn = arguments.dsn>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="GetAlerts" access="public" output="false" returntype="any">
		<cfargument name="symbol" required="false" default="">
		<cfset var local = StructNew() />
		<cfset local.qryGetAlerts = "" />
		<cfset local.strReturn = structNew() />
		<cftry>
			<cfquery name="local.qryGetAlerts" datasource="#application.dsn#">
			SELECT
			SYMBOL
			,VALUE
			,ACTION
			,ALERTED
			,MESSAGE
			,STRATEGY
			FROM	ALERTS
			WHERE	1=1
			<cfif arguments.symbol NEQ "">
			AND SYMBOL = '#arguments.symbol#'
			</cfif>
			</cfquery>
			<cfset local.return_value = local.qryGetAlerts />
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
			<cfset local.return_value = cfcatch />
			</cfcatch>
		</cftry>
		<cfreturn local.return_value />
	</cffunction>

	<cffunction name="GetAlertSymbols" access="public" output="false" returntype="any">
		<cfset var local = StructNew() />
		<cfset local.qryGetSymbols = "" />
			<cftry>
			<cfquery name="local.qryGetSymbols" datasource="#application.dsn#">
			SELECT DISTINCT 
			SYMBOL
			FROM	ALERTS
			WHERE	1=1
			</cfquery>
			<cfset local.return_value = local.qryGetSymbols />
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
			<cfset local.return_value = cfcatch />
			</cfcatch>
		</cftry>
		<cfreturn local.return_value />
	</cffunction>

	<cffunction name="GetWatchList" access="public" output="false" returntype="any">
		<cfset var local = StructNew() />
		<cfset local.qryGetWatchList = "" />
		<cfset local.strReturn = structNew() />
		<cftry>
			<cfquery name="local.qryGetWatchList" datasource="#application.dsn#">
			SELECT
			SYMBOL
			FROM	WATCHLIST
			WHERE	1=1
			</cfquery>
			<cfset local.return_value = local.qryGetWatchList />
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
			<cfset local.return_value = cfcatch />
			</cfcatch>
		</cftry>
		<cfreturn local.return_value />
	</cffunction>

	<cffunction name="AddAlert" access="public" output="false" returntype="any">
		<cfargument name="alertBean" required="true" />
		<cfset var local = StructNew() />
		<cfset local.return_value = "" />
		<cfset local.qryAddAlerts = "" />
		<cfset local.strReturn = structNew() />
		<cftry>
			<cfquery name="local.qryAddAlerts" datasource="#application.dsn#">
			INSERT INTO ALERTS 
			(SYMBOL
			,VALUE
			,ACTION
			,ALERTED
			,MESSAGE
			,STRATEGY) 
			VALUES(
			 <cfqueryparam value="#arguments.alertBean.GetSymbol()#" CFSQLType="cf_sql_varchar"  />
			,<cfqueryparam value="#arguments.alertBean.GetValue()#" CFSQLType="cf_sql_varchar"  />
			,<cfqueryparam value="#arguments.alertBean.GetAction()#" CFSQLType="cf_sql_varchar"  />
			,<cfqueryparam value="#arguments.alertBean.GetAlerted()#" CFSQLType="cf_sql_varchar"  />
			,<cfqueryparam value="#arguments.alertBean.GetMessage()#" CFSQLType="cf_sql_varchar"  />
			,<cfqueryparam value="#arguments.alertBean.GetStrategy()#" CFSQLType="cf_sql_varchar"  />
			);
			</cfquery>
			<cfset local.return_value = true />
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
			<cfset local.return_value = cfcatch  />	
			</cfcatch>
		</cftry>
		<cfreturn local.return_value />
	</cffunction>
		
	<cffunction name="AddWatchlist" access="public" output="false" returntype="any">
		<cfargument name="alertBean" required="true" />
		<cfset var local = StructNew() />
		<cfset local.qAddAlerts = "" />
		<cfset local.strReturn = structNew() />
		<cftry>
			<cfquery name="local.qryAddAlerts" datasource="#application.dsn#">
			INSERT INTO ALERTS 
			(SYMBOL
			,VALUE
			,ACTION
			,ALERTED
			,MESSAGE) 
			VALUES(
			 <cfqueryparam value="#arguments.alertBean.GetSymbol()#" CFSQLType="cf_sql_varchar"  />
			,<cfqueryparam value="#arguments.alertBean.GetValue()#" CFSQLType="cf_sql_varchar"  />
			,<cfqueryparam value="#arguments.alertBean.GetAction()#" CFSQLType="cf_sql_varchar"  />
			,<cfqueryparam value="#arguments.alertBean.GetAlerted()#" CFSQLType="cf_sql_varchar"  />
			,<cfqueryparam value="#arguments.alertBean.GetMessage()#" CFSQLType="cf_sql_varchar"  />
			);
			</cfquery>
			<cfset local.return_value = local.qryAddAlerts />
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
			<cfset local.return_value = cfcatch />
			</cfcatch>
		</cftry>
		<cfreturn local.return_value />
	</cffunction>
	
	<cffunction name="deleteAlert" access="public" output="false" returntype="any">
		<cfargument name="AlertBean" type="AlertBean" required="true" />
		<cfset var qryDeleteAlert = "">
		<cftry>
			<cfquery name="qryDeleteAlert" datasource="#application.dsn#">
				DELETE FROM	ALERTS 
				WHERE	1=1
				AND Symbol = <cfqueryparam value="#arguments.alertBean.GetSymbol()#" CFSQLType="cf_sql_varchar"  />
			</cfquery>
			<cfset local.return_value = true />
			<cfcatch type="database">
				<cfset local.return_value = cfcatch />
			</cfcatch>
		</cftry>
		<cfreturn local.return_value />
	</cffunction>

	<cffunction name="deleteWatchlist" access="public" output="false" returntype="any" >
		<cfargument name="Symbol" type="string" required="true" />
		<cfset var qryDeleteWatchlist = "">
		<cftry>
			<cfquery name="qryDeleteWatchlist" datasource="#application.dsn#">
				DELETE FROM	WATCHLIST 
				WHERE	1=1
				AND Symbol = '#arguments.symbol#'
			</cfquery>
			<cfset local.return_value = qryDeleteWatchlist />
			<cfcatch type="database">
				<cfset local.return_value = cfcatch />
			</cfcatch>
		</cftry>
		<cfreturn local.return_value />
	</cffunction>
	
	<cffunction name="updateAlert" access="public" output="false" returntype="any">
		<cfargument name="AlertBean" required="true" />
		<cfset var local = StructNew() />
		<cfset local.qryUpdateAlerts = "" />
		<cftry>
			<cfquery name="local.qryUpdateAlerts" datasource="#application.dsn#">
			UPDATE ALERTS
			SET
			VALUE 	= <cfqueryparam value="#arguments.alertBean.GetValue()#" CFSQLType="cf_sql_varchar"  />
			,ALERTED = <cfqueryparam value="#arguments.alertBean.GetAlerted()#" CFSQLType="cf_sql_varchar"  />
			,MESSAGE = <cfqueryparam value="#arguments.alertBean.GetMessage()#" CFSQLType="cf_sql_varchar"  />
			,STRATEGY = <cfqueryparam value="#arguments.alertBean.GetStrategy()#" CFSQLType="cf_sql_varchar"  />
			WHERE	1=1
			AND SYMBOL = <cfqueryparam value="#arguments.alertBean.GetSymbol()#" CFSQLType="cf_sql_varchar"  />
			</cfquery>
			<cfset local.return_value = true />
			<cfcatch type="database">
			<cfthrow type="dbError"
			message="Error occurred while connecting to the database:" detail="<br/>
			<strong>REASON:</strong><br/>
			#cfcatch.message#<br />
			<br /><strong>DETAIL:</strong>
			<br/>#cfcatch.detail#<br />
			<br /><strong>T-SQL EXECUTED:</strong>
			<br/>#cfcatch.sql# 
			<br/>Values: #arguments.AlertBean.GetMemento().toString()#
			<br/>:
			"
			/>
			<cfset local.return_value = StructNew()  />	
			<cfset local.return_value.error = cfcatch  />	
			<cfset local.return_value.Values = arguments.AlertBean.GetMemento()  />	
			</cfcatch>
		</cftry>
		<cfreturn local.return_value />
	</cffunction>
	
	<cffunction name="Create">
	<cfquery name="qrycreate" datasource="variables.dsn">
	CREATE TABLE [Alerts] (
    [Symbol] VARCHAR(4),
    [Value] VARCHAR(8),
    [Action] VARCHAR(200),
    [ALERTED] VARCHAR(5),
    [MESSAGE] VARCHAR(500)
	);
	</cfquery>
	</cffunction>
	
	<cffunction name="exists" access="public" output="false" returntype="boolean">
		<cfargument name="qryData" type="qryData" required="true" />
		<cfset var qExists = "">
		<cfquery name="qExists" datasource="#application.dsn#" maxrows="1">
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
