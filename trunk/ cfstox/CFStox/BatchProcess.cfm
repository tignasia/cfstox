<cfscript>
controller 	= createObject("component","cfstox.controllers.controller").init();
fdata 		= Controller.AnalyseData(symbol:"f",startdate:"10/01/2012",enddate:"12/04/2012");
fdata 		= Controller.AnalyseData(symbol:"x",startdate:"10/01/2012",enddate:"12/04/2012");
fdata 		= Controller.AnalyseData(symbol:"c",startdate:"10/01/2012",enddate:"12/04/2012");
debug(fdata);
</cfscript>

<cffunction name="debug" description="" >
	<cfargument name="object" required="false"  />
	<cfargument name="label" required="false" default="Label" />
	<cfdump var="#arguments.object#" label="arguments.label">
	<cfreturn />
</cffunction>