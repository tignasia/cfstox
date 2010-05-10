<cfcomponent displayname="controller" output="false">
	<cffunction name="init" description="init method" access="public" displayname="" output="false" returntype="controller">
		<cfreturn this/>
	</cffunction>
	
	<cffunction name="historical" description="return historical data" access="public" displayname="" output="false" returntype="Struct">
		<cfargument name="argumentData">
		<cfset var local = structnew() />
		<!--- get historical data ---->
		<!---- get indicator data  --->
		
		<cfreturn local/>
	</cffunction>
	
	<cffunction name="summary" description="provide trading actions and analysis" access="public" displayname="" output="false" returntype="controller">
		<cfargument name="argumentData">
		<cfset var local = structnew() />
		<cfreturn this/>
	</cffunction>

	<cffunction name="backtest" description="provide results using given system" access="public" displayname="" output="false" returntype="controller">
		<cfargument name="argumentData">
		<cfset var local = structnew() />
		<cfreturn this/>
	</cffunction>
	
	<cffunction name="watchlist" description="run systems agains watchlist" access="public" displayname="" output="false" returntype="controller">
		<cfargument name="argumentData">
		<cfset var local = structnew() />
		<cfreturn this/>
	</cffunction>
	
</cfcomponent>