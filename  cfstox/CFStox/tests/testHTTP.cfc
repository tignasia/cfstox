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
		var results = this.httpService.gethttp(sym:"CSX",enddate:Now());
		debug(results);
		</cfscript>	
	</cffunction>
	
	<cffunction name="testHTTPGoogle" returntype="void" access="public">
		<cfargument name="Symbol" 		required="false" default="ABX"  />
		<cfargument name="startdate" 	required="false" default=#CreateDate(2010,11,1)# />
		<cfargument name="enddate" 		required="false" default=#now()# />
		<cfscript>
		// http://www.google.com/finance/historical?cid=5232&startdate=Nov+1%2C+2010&enddate=Jan+6%2C+2011&num=30&output=csv
		var results = this.httpService.getGoogleURL(symbol:"CSX",startdate:#arguments.startdate#,enddate:Now());
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
	
	<!--- <cffunction name="testMAindicator" returntype="void" access="private">
		<cfscript>
		paths = arrayNew(1);
paths[1] = expandPath("ta-lib-0.4.0.jar");
loader = createObject("component", "JavaLoader").init(Paths);
talib = loader.create("com.tictactec.ta.lib.Core"); 
</cfscript>
<cfdump label="loader" var="#loader#">
<cfdump label="talib" var="#talib#">

	</cffunction> --->

	<cffunction name="tearDown" returntype="void" access="public">
		<!--- Any code needed to return your environment to normal goes here --->
	</cffunction>

</cfcomponent>

