<cfcomponent displayname="mxunit.framework.MyComponentTest"  extends="mxunit.framework.TestCase">

	<cffunction name="setUp" access="public" returntype="void">
	 <!---  <cfset super.TestCase(this) /> --->
	  <!--- Place additional setUp and initialization code here --->
		<cfscript>
		this.controller = createObject("component","cfstox.controllers.controller").init();
		</cfscript>
	</cffunction>

	<cffunction name="testGetData" access="public" returntype="void">
		<cfscript>
		var local = structNew();
		local.data = this.Controller.getData(symbol:"f",startdate:"06/01/2012",enddate:"10/01/2012");
		debug(session.objects.DataStorage.GetMemento() );
		</cfscript>
	</cffunction>
	
	<cffunction name="testAnalyseData" access="public" returntype="void">
		<cfscript>
		var local = structNew();
		local.data = this.Controller.AnalyseData(symbol:"f",startdate:"10/01/2012",enddate:"12/01/2012");
		//debug(local.data );
		//local.data = this.Controller.AnalyseData(symbol:"x",startdate:"10/01/2012",enddate:"12/01/2012");
		//debug(local.data );
		//local.data = this.Controller.AnalyseData(symbol:"c",startdate:"10/01/2012",enddate:"12/01/2012");
		//debug(local.data );
		</cfscript>
	</cffunction>


	<!--- End Specific Test Cases --->
	<cffunction name="tearDown" access="public" returntype="void">
	 <!--- Place tearDown/clean up code here --->
	</cffunction>

</cfcomponent>
