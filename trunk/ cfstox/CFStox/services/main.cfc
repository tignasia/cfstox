<cfcomponent output="false">

<cffunction  name="default"  access="public" output="false">
	<cfargument name="rc" required="false" >
	<cfdump label="in service" var="#arguments#"> 
	<cfabort>
</cffunction>

</cfcomponent>