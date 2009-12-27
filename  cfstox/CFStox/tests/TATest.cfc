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
		 this.TA = createObject("component","cfstox.model.TA").init();
		 this.http = createObject("component","cfstox.model.http").init();
		
		</cfscript>
	</cffunction>

	<cffunction name="testMisc" access="public" returntype="void">
		<cfscript>
		var local = structNew();
		local.array = arrayNew(1);
		local.data = local.array.getClass(); 
		local.something = local.array.size();
		debug(local.something);
		debug(local.array);
		debug(local.data);
		local.sdata = local.getClass(); 
		debug(local.sdata);
		writeOutput("<strong>Class:</strong> " & local.data & "	");
		methods = local.data.getMethods();  
		fields = local.data.getFields();  
		writeOutput("<strong>Fields</strong>" & " ");
		for(x = 1; x LTE arrayLen(fields); ++x) 
	            writeOutput(fields[x] & " ");
		writeOutput("<strong>Methods</strong>" & " ");
		for(x = 1; x LTE arrayLen(methods); ++x) 
	            writeOutput(methods[x] & "	");
	        
		/* local.data = this.http.gethttp("ABX");
		local.num = this.TA.SMA(aryPrices:local.data); */
		</cfscript>
	</cffunction>


	<cffunction name="testSMA" access="public" returntype="void">
		<cfscript>
		var local = structNew();
		local.data = this.http.gethttp("ABX");
		local.array = arrayNew(1);
		/* debug(local.data); */
		</cfscript>
		<cfloop query="local.data">
   			<cfset local.array[local.data.CurrentRow]= local.data.close />
		</cfloop>
		<cfscript>
		debug(local.array);	
		local.num = this.TA.SMA(aryPrices:local.array); 
		debug(local.num); 
		</cfscript>
	</cffunction>

	<cffunction name="testDX" access="public" returntype="void">
		<cfscript>
		var local = structNew();
		local.data = this.http.gethttp("ABX");
		local.num = this.TA.DX(qryPrices:local.data);
		debug(local.num); 
		</cfscript>
	</cffunction>

	<cffunction name="testADX" access="public" returntype="void">
		<cfscript>
		var local = structNew();
		local.data = this.http.gethttp("ABX");
		local.num = this.TA.DX(qryPrices:local.data);
		debug(local.num); 
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
