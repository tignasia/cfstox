<cfcomponent name="testHTTP" extends="mxunit.framework.TestCase">
	<!--- Begin specific tests --->
	<cffunction name="testadd" access="public" returnType="void">
			<cfset fail("Test testadd not implemented")>
	</cffunction>		
	
	<cffunction name="testappend" access="public" returnType="void">
		<cfset fail("Test testappend not implemented")>
	</cffunction>		

	<!--- setup and teardown --->
	<cffunction name="setUp" returntype="void" access="public">
		<cfset this.httpService = createObject("component","cfstox.model.http")>
		<cfset this.TAService = createObject("component","cfstox.model.ta").init()>		
	</cffunction>

	<cffunction name="testHTTP" returntype="void" access="public">
		<cfscript>
		var results = this.httpService.gethttp(sym:"CSX");
		debug(results);
		</cfscript>	
	</cffunction>
	
	<cffunction name="testMAindicator" returntype="void" access="public">
		<cfscript>
		var results = this.httpService.gethttp(sym:"SQNM");
		debug(results);
		taoutput = this.TAService.getMA(type:"s", period:"10");
		debug(taoutput);
		</cfscript>	
	</cffunction>
	
	<cffunction name="testMAindicator" returntype="void" access="private">
		<cfscript>
		paths = arrayNew(1);
paths[1] = expandPath("ta-lib-0.4.0.jar");
loader = createObject("component", "JavaLoader").init(Paths);
talib = loader.create("com.tictactec.ta.lib.Core"); 
</cfscript>
<cfdump label="loader" var="#loader#">
<cfdump label="talib" var="#talib#">

	</cffunction>
	

	<cffunction name="tearDown" returntype="void" access="public">
		<!--- Any code needed to return your environment to normal goes here --->
	</cffunction>

</cfcomponent>

