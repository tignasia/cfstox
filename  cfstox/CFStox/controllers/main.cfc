<cfcomponent output="false">
<cffunction  name="default"  access="public" output="false">
	<cfargument name="rc" required="false" >
	<cfdump label="in cfc" var="#arguments.rc#"> 
	<cfabort>
</cffunction>
</cfcomponent>