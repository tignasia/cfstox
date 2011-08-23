<cfcomponent output="false">
	
	<cffunction name="init"  >
		<cfset variables.SnapShot = ArrayNew(1) />
		<cfreturn this />
	</cffunction>

	<cffunction name="QryToArray" access="public" output="false" returntype="Array">
		<cfargument name="query" required="true">
		<cfset var local = structNew() />
		<cfset local.returnArray = ArrayNew(2) />
		<cfscript>
		local.qryrows = arguments.query.recordcount;
		//Convert data and append
		local.cols = listToArray(arguments.query.columnList);
       	for(i=1;i<=local.qryrows;i++){   
			for (j=1;j <= local.cols.size(); j++) { 
				local.returnArray[i][j] = query["#local.cols[j]#"][i];
    		}
       	}
       	</cfscript>
		<cfreturn local.returnArray />
	</cffunction>
	
	<cffunction name="QrytoStruct" description="" access="public" displayname="" output="false" returntype="Struct">
		<cfargument name="query" required="true" />
		<cfargument name="rownumber" required="false"  default=1 />
    	<cfscript>
		var local = StructNew();
    	//a var for looping
    	local.ii = 1;
    	//the cols to loop over
    	local.cols = listToArray(arguments.query.columnList);
    	//the struct to return
    	local.stReturn = structnew();
    	//if there is a second argument, use that for the row number
    	local.row = arguments.rownumber;
    	//loop over the cols and build the struct from the query row    
    	for(local.ii = 1; local.ii <= local.cols.size(); local.ii++){
        	local.stReturn[local.cols[local.ii]] = arguments.query[local.cols[local.ii]][local.row];
    	}        
    	//return the struct
    	return local.stReturn;
    	</cfscript>
	</cffunction>

	<cffunction name="testPath" access="public" returntype="String">
	<cfscript>
	var local = structnew();
	local.filepath = GetBaseTemplatePath();
	debug(local.filepath);
	local.basepath = GetDirectoryFromPath(GetBaseTemplatePath());
	debug(local.basepath);
	return local.filepath;
	</cfscript>
	</cffunction>
	
	<cffunction name="getbasepath" access="public" returntype="String">
	<cfscript>
	var local = structnew();
	local.filepath = GetBaseTemplatePath();
	return local.filepath;
	</cfscript>
	</cffunction>
	
	<cffunction name="getdirectorypath" access="public" returntype="String">
	<cfscript>
	var local = structnew();
	local.basepath = GetDirectoryFromPath(GetBaseTemplatePath());
	return local.basepath;
	</cfscript>
	</cffunction>
	
	<cffunction name="debug" access="public">
		<cfargument name="obj" required="true" type="any">
		<cfargument name="label" required="false" default="MXUNIT Dump" />
		<cfdump var="#arguments.obj#" label="#arguments.label#">
	</cffunction>
	
	<cffunction name="genExcel" description="" access="public" displayname="" output="false" returntype="Any">
		<cfargument name="exceldata" required="true"  />
		<cfset var local = StructNew()  />
		<cfset local.columnList = arguments.exceldata.columnlist	/>
		<cfset local.columnArray = listToArray(arguments.exceldata.columnList) />
		<cfsavecontent variable="local.exceldata">
		<cfoutput>
		<!--- <cfcontent type="application/vnd.ms-excel"> --->
		<!--- <cfheader name="Content-Disposition" value="inline; filename=Stockdata.xls"> --->
		<table border="2">
		<tr>
		<cfloop index="symbol" list="#local.columnList#">
			<td>#symbol#</td>
		</cfloop>
		</tr>
		<cfset local.qryrows = arguments.exceldata.recordcount />
		<cfset local.colArray = listToArray(arguments.exceldata.columnList) />
      	<cfloop from="1" to="#local.qryrows#" index="i">
			<tr>
			<cfloop from="1" to="#local.colArray.size()#" index="j">
			 <td><cfoutput>#exceldata["#local.colArray[j]#"][i]#</cfoutput></td>
			</cfloop>
			</tr>	
		</cfloop>	
		
		</table>
		</cfoutput>
		</cfsavecontent>
		
		<cfreturn local.exceldata />
	</cffunction>
	
	<cffunction  name="WriteData"  access="public" output="false" returntype="String">
		<cfargument name="filepath" required="true">
		<cfargument name="filename" required="true">
		<cfargument name="filedata" required="true">
		<cfset var rootpath= GetDirectoryFromPath(GetBaseTemplatePath()) />
		<cfif FileExists("#rootpath##arguments.filePath#\#arguments.filename#") > 
			<cffile action="append" file="#rootpath##arguments.filePath#\#arguments.filename#" output="#arguments.filedata#"  />
		<cfelse>
			<cffile action="write" file="#rootpath##arguments.filePath#\#arguments.filename#" output="#arguments.filedata#"  />
		</cfif>
		<cfreturn arguments.filename />
	</cffunction>
	
	<cffunction name="trace" description="" access="public" displayname="" output="false" returntype="void">
		<cfargument  name="thingToTrace">
		<cfargument  name="desc">
		<cftrace  category="information" inline="false" text="#arguments.desc#" var="arguments.thingToTrace">
		<cfreturn />
	</cffunction>
</cfcomponent>