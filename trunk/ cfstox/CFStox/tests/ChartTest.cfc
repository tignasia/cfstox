<!---
 MXUnit TestCase Template
 @author
 @description
 @history
 --->

<cfcomponent displayname="mxunit.framework.MyComponentTest"  extends="mxunit.framework.TestCase">

	<cffunction name="setUp" access="public" returntype="void">
	 <!---  <cfset super.TestCase(this) /> --->
	  <!--- Place additional setUp and initialization code here --->
		<cfscript>
		 this.chart 	= createObject("component","cfstox.model.Chart");
		 this.utility 	= createObject("component","cfstox.model.Utility");
		 debug(this.chart);
		 debug(this.utility);
		</cfscript>
	</cffunction>
	
	<cffunction name="testwritefile" access="public" returntype="void">
	<cfscript>
	var local = structnew();
	local.filepath = "Data";
	local.filename = "test1.xml";
	local.output = this.chart.writeXML();
	debug(local.output);
	local.result = this.utility.writeData(filepath:local.filepath, filename:local.filename, filedata:local.output);
	</cfscript>
	</cffunction>
	
	<!--- End Specific Test Cases --->

	<cffunction name="tearDown" access="public" returntype="void">
	 <!--- Place tearDown/clean up code here --->
	</cffunction>

</cfcomponent>
