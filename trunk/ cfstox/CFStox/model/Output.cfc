<cfcomponent  displayname="Output" output="false" >

<cffunction name="Init" description="" access="public" displayname="" output="false" returntype="Output">
	<cfreturn this />
</cffunction>

<cffunction name="PDF" description="I output a PDF file" access="public" displayname="" output="false" returntype="void">
	<cfargument name="content" required="true">
	<cfargument name="filename" required="true">
	<cfdocument  format="PDF" filename="#arguments.filename#">
	<cfoutput>#arguments.content#</cfoutput>
	</cfdocument>
	<cfreturn />
</cffunction>

</cfcomponent>