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
		 this.mycomp = createObject("component","cfstox.model.Utility");
		 debug(this.mycomp);
		</cfscript>
	</cffunction>

	<cffunction name="testAdd" access="public" returntype="void">
		<cfscript>
		var num = this.mycomp.add(1,1);
		addTrace("num == " & num );
		assertEquals(num,2);
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
