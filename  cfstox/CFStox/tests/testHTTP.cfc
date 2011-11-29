<cfcomponent name="testHTTP" extends="mxunit.framework.TestCase">
	<!--- Begin specific tests --->
	
	<!--- setup and teardown --->
	<cffunction name="setUp" returntype="void" access="public">
		<cfset this.httpService = createObject("component","cfstox.model.http")>
		<cfset this.TAService = createObject("component","cfstox.model.ta").init()>		
	</cffunction>

	<cffunction name="testGetHTTPDataGoogle" returntype="void" access="public">
		<cfargument name="Symbol" 		required="false" default="ABX"  />
		<cfargument name="startdate" 	required="false" default=#CreateDate(2011,11,1)# />
		<cfargument name="enddate" 		required="false" default=#now()# />
		<cfscript>
		// http://www.google.com/finance/historical?cid=5232&startdate=Nov+1%2C+2010&enddate=Jan+6%2C+2011&num=30&output=csv
		GoogleResults = this.httpService.getHTTPData(source:"Google",symbol:"CSX",startdate:#arguments.startdate#,enddate:Now());
		debug(GoogleResults);
		</cfscript>	
	</cffunction>
	
	<cffunction name="testGetHTTPDataYahoo" returntype="void" access="public">
		<cfargument name="Symbol" 		required="false" default="CSX"  />
		<cfargument name="startdate" 	required="false" default=#CreateDate(2011,11,1)# />
		<cfargument name="enddate" 		required="false" default=#now()# />
		<cfscript>
		// http://www.google.com/finance/historical?cid=5232&startdate=Nov+1%2C+2010&enddate=Jan+6%2C+2011&num=30&output=csv
		// http://www.google.com/finance/historical?q=CSX&startdate=Nov+1+2011&enddate=Nov+27+2011&output=csv 
		YahooResults = this.httpService.getHTTPData(source:"Yahoo",symbol:"CSX",startdate:#arguments.startdate#,enddate:Now());
		debug(YahooResults);
		</cfscript>	
	</cffunction>
	
	<cffunction name="testGetURLGoogle" returntype="void" access="public">
		<cfargument name="Symbol" 		required="false" default="ABX"  />
		<cfargument name="startdate" 	required="false" default=#CreateDate(2011,11,1)# />
		<cfargument name="enddate" 		required="false" default=#now()# />
		<cfscript>
		// http://www.google.com/finance/historical?cid=5232&startdate=Nov+1%2C+2010&enddate=Jan+6%2C+2011&num=30&output=csv
		YahooResults = this.httpService.getURL(source:"Google",symbol:"CSX",startdate:#arguments.startdate#,enddate:Now());
		debug(YahooResults);
		</cfscript>	
	</cffunction>
	
	
	<cffunction name="testGetURLYahoo" returntype="void" access="public">
		<!--- ichart.finance.yahoo.com/table.csv?s=CSX&a=Nov&b=1&c=2011&d=Nov&e=27&f=2011&ignore=.csv  --->
		<cfargument name="Symbol" 		required="false" default="CSX"  />
		<cfargument name="startdate" 	required="false" default=#CreateDate(2011,11,1)# />
		<cfargument name="enddate" 		required="false" default=#now()# />
		<cfscript>
		// http://www.google.com/finance/historical?cid=5232&startdate=Nov+1%2C+2010&enddate=Jan+6%2C+2011&num=30&output=csv
		YahooResults = this.httpService.getURL(source:"Yahoo",symbol:"CSX",startdate:#arguments.startdate#,enddate:Now());
		debug(YahooResults);
		</cfscript>	
	</cffunction>
	
		
	<cffunction name="tearDown" returntype="void" access="public">
		<!--- Any code needed to return your environment to normal goes here --->
	</cffunction>

</cfcomponent>

