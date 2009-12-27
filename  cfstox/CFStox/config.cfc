<!--- 
This application is licensed under the Apache License, Version 2.0 . 
For a copy of the Apache License, Version 2.0, go to 
http://www.apache.org/licenses/
--->
<cfcomponent displayname="Config" output="false" hint="I am a configuration component." >

<cffunction name="init" access="Public" returnType="Config" output="false" hint="I return a new config object">
	<cfreturn this />
</cffunction>

<cffunction name="SetVariables" access="Public" returnType="boolean" output="false" hint="I set the variables defined in config.xml.cfm">
	<cfset var xConfig = ""/>
	<cfset var inFile = "" />
	<cfset var appPath = GetDirectoryFromPath(GetBaseTemplatePath()) /> 
	<cfset var i = 0 />
	<cfset var j = 0 />
	<cfset var len_xConfig = 0 />
	<cfset var isValid = FALSE />
	<cfset var len_xmlChildren = 0 />
	<cfset var scope = "" />
	<cffile action="read" file="#appPath#config.xml.cfm" variable="inFile">
	<!--- make sure the config file is valid xml  --->
	<!--- the next version will use XMLSchema to validate if anyone wants it --->
	<cfif IsXML(inFile)>
		<cfset isValid = TRUE />
		<cfset xConfig = xmlParse(infile).xmlRoot />
		<cfset len_xConfig = arrayLen(xConfig.xmlChildren) />
		<!--- Loop over the modules --->
		<cfloop from="1" to="#len_xConfig#" index="i">
			<cfset len_xmlChildren = arrayLen(xConfig.xmlChildren[i].xmlChildren) /> 
			<!--- Loop over this module's parameters --->
			<cfset scope = xConfig.xmlChildren[i].xmlAttributes.name />
			<!--- loop over the various scopes  and populate them --->
			<cfloop from="1"  to="#len_xmlChildren#" index="j">
				<cfset property = xConfig.xmlChildren[i].xmlChildren[j].name.xmlText />
				<cfset "#scope#.#property#" = xConfig.xmlChildren[i].xmlChildren[j].value.xmlText /> 
			</cfloop>
		</cfloop>
		<cfset application.appInitialized = TRUE />
	</cfif>
	<cfreturn isValid />
	</cffunction>
</cfcomponent>