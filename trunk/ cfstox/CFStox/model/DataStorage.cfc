<cfcomponent output="false">

	<cffunction name="Init" description="" access="public" displayname="init" output="false" returntype="any">
		<cfreturn this/>
	</cffunction>
	
	<cffunction name="SetData" description="sets data values" access="public" displayname="SetData" output="false" returntype="void">
		<cfargument name="DataSet" required="true" /> 
		<cfargument name="theData" required="true" />
		<cfset variables[#arguments.dataSet#] = arguments.theData />
		<cfreturn />
	</cffunction>
	
	<cffunction name="GetData" description="" access="public" displayname="" output="false" returntype="Any">
		<cfargument name="DataSet" required="true"  />
		<cfreturn variables[#arguments.dataset#] />
	</cffunction>	
	
	<cffunction name="getMemento" description="" access="public" displayname="" output="false" returntype="Any">
		<cfreturn variables />
	</cffunction>
</cfcomponent>