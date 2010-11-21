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
		this.controller = createObject("component","cfstox.controllers.controller").init();
		this.System 	= createObject("component","cfstox.model.System").init();
		this.http 		= createObject("component","cfstox.model.http").init();
		this.Utility	= createObject("component","cfstox.model.Utility").init();
		this.DataService	= createObject("component","cfstox.model.DataService").init();
		</cfscript>
	</cffunction>

	<cffunction name="testQryToArray" access="public" returntype="void">
		<cfscript>
		var local = structNew();
		local.data = this.DataService.GetStockData(symbol:"ABX",startdate:"2/1/2010",enddate:"6/10/2010");
		local.data = this.Utility.QryToArray(query:local.data.HKData);
		debug(local.data);
		</cfscript>
	</cffunction>
	
	<cffunction name="testQrytoStruct" access="public" returntype="void">
		<cfscript>
		var local = structNew();
		local.data = this.DataService.GetStockData(symbol:"ABX",startdate:"2/1/2010",enddate:"6/10/2010");
		local.data1 = this.Utility.QryToStruct(query:local.data.HKData, rownumber:11);
		local.data2 = this.Utility.QryToStruct(query:local.data.HKData, rownumber:12);
		local.data3 = this.Utility.QryToStruct(query:local.data.HKData, rownumber:13);
		debug(local.data1);
		debug(local.data2);
		debug(local.data3);
		</cfscript>
	</cffunction>
	
	<cffunction name="testGenExcel" access="public" returntype="void">
		<cfscript>
		var local = structNew();
		local.data = this.DataService.GetStockData(symbol:"ABX",startdate:"2/1/2010",enddate:"6/10/2010");
		local.exceldata = this.DataService.GetTechnicalIndicators(query:local.data.HKData);
		debug(local.data);
		debug(local.exceldata);
		local.data1 = this.Utility.genExcel(exceldata:local.excelData);
		debug(local.data1);
		</cfscript>
	</cffunction>


	<cffunction name="testAdd2" access="public" returntype="void">
		<cfscript>
		var num = this.mycomp.add(1,1);
		addTrace("num == " & num );
		assertEquals(num,3,"Intentionally failing so you can see what a failure looks like.");
	</cfscript>
	</cffunction>

	<cffunction name="testSomethingElse2" access="public" returntype="void">
	<cfset var myExpression = evaluate("1+1 eq 2") />
    <cfset addTrace(" myExpression == " & myExpression) />
    <cfset assertTrue(myExpression) />
	</cffunction>
	
	<cffunction name="testwritefile" access="public" returntype="void">
	<cfscript>
	var local = structnew();
	local.filepath = "Data";
	local.filename = "test.xml";
	local.filedata = "This is test data";
	local.result = this.mycomp.writeData(filepath:local.filepath, filename:local.filename, filedata:local.filedata);
	</cfscript>
	</cffunction>
	
	<cffunction name="testPath" access="public" returntype="void">
	<cfscript>
	var local = structnew();
	local.filepath = GetBaseTemplatePath();
	debug(local.filepath);
	local.basepath = GetDirectoryFromPath(GetBaseTemplatePath());
	debug(local.basepath);
	local.comppath = this.mycomp.getbasepath();
	debug(local.comppath);
	local.dirpath = this.mycomp.getdirectorypath();
	debug(local.dirpath);
	local.metadata = getmetadata(this.mycomp);
	debug(this.mycomp);
	debug(local.metadata);
	</cfscript>
	</cffunction>
	
	<!--- End Specific Test Cases --->

	<cffunction name="tearDown" access="public" returntype="void">
	 <!--- Place tearDown/clean up code here --->
	</cffunction>

</cfcomponent>
