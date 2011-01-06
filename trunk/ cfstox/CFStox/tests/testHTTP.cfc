<cfcomponent name="testHTTP" extends="mxunit.framework.TestCase">
	<!--- Begin specific tests --->
	
	<!--- setup and teardown --->
	<cffunction name="setUp" returntype="void" access="public">
		<cfset this.httpService = createObject("component","cfstox.model.http")>
		<cfset this.TAService = createObject("component","cfstox.model.ta").init()>		
	</cffunction>

	<cffunction name="testGetGoogleURL" returntype="void" access="public">
		<cfargument name="Symbol" 		required="false" default="ABX"  />
		<cfargument name="startdate" 	required="false" default=#CreateDate(2010,11,1)# />
		<cfargument name="enddate" 		required="false" default=#now()# />
		<cfscript>
		// http://www.google.com/finance/historical?cid=5232&startdate=Nov+1%2C+2010&enddate=Jan+6%2C+2011&num=30&output=csv
		var results = this.httpService.getGoogleURL(symbol:"CSX",startdate:#arguments.startdate#,enddate:Now());
		debug(results);
		</cfscript>	
	</cffunction>
	
	<cffunction name="testGetYahooURL" returntype="void" access="public">
		<cfargument name="Symbol" 		required="false" default="ABX"  />
		<cfargument name="startdate" 	required="false" default=#CreateDate(2010,11,1)# />
		<cfargument name="enddate" 		required="false" default=#now()# />
		<cfscript>
		// http://www.google.com/finance/historical?cid=5232&startdate=Nov+1%2C+2010&enddate=Jan+6%2C+2011&num=30&output=csv
		var results = this.httpService.getGoogleURL(symbol:"CSX",startdate:#arguments.startdate#,enddate:Now());
		debug(results);
		</cfscript>	
	</cffunction>
	
	<cffunction name="testGetGoogleData" returntype="void" access="public">
		<cfargument name="Symbol" 		required="false" default="ABX"  />
		<cfargument name="startdate" 	required="false" default=#CreateDate(2010,11,1)# />
		<cfargument name="enddate" 		required="false" default=#now()# />
		<cfscript>
			var local = structNew();
		// http://www.google.com/finance/historical?cid=5232&startdate=Nov+1%2C+2010&enddate=Jan+6%2C+2011&num=30&output=csv
		local.results = this.httpService.getHTTPGoogle(symbol:"CSX",startdate:#arguments.startdate#,enddate:Now());
		debug(local.results);
		local.data = local.results.resultdata.filecontent.toString();
		debug(local.data);
		</cfscript>	
	</cffunction>
	
	<cffunction name="testGetYahooData" returntype="void" access="public">
		<cfargument name="Symbol" 		required="false" default="ABX"  />
		<cfargument name="startdate" 	required="false" default=#CreateDate(2010,11,1)# />
		<cfargument name="enddate" 		required="false" default=#now()# />
		<cfscript>
		// http://www.google.com/finance/historical?cid=5232&startdate=Nov+1%2C+2010&enddate=Jan+6%2C+2011&num=30&output=csv
		var results = this.httpService.gethttp(symbol:"CSX",startdate:#arguments.startdate#,enddate:Now());
		debug(results);
		</cfscript>	
	</cffunction>
	<cffunction name="tearDown" returntype="void" access="public">
		<!--- Any code needed to return your environment to normal goes here --->
	</cffunction>

</cfcomponent>

