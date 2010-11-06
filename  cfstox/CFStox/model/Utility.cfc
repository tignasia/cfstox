<cfcomponent output="false">
	
	<cffunction name="init"  >
		<cfreturn this />
	</cffunction>

	<cffunction name="QryToArray" access="public" output="false" returntype="Array">
		<cfargument name="qryData" required="true">
		<cfset var local = structNew() />
		<cfset local.returnArray = ArrayNew(2) />
		<cfscript>
		local.qryrows = arguments.qrydata.recordcount;
		//Convert data to XML and append
       	for(i=1;i<=local.qryrows;i++){   
			local.returnArray[i][1] = qrydata['open'][i];
			local.returnArray[i][2] = qrydata['high'][i];
			local.returnArray[i][3] = qrydata['low'][i];
			local.returnArray[i][4] = qrydata['close'][i];
       	}
       	</cfscript>
		<cfreturn local.returnArray />
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
		<cfsavecontent variable="local.exceldata">
		<cfoutput>
		<!--- <cfcontent type="application/vnd.ms-excel"> --->
		<!--- <cfheader name="Content-Disposition" value="inline; filename=Stockdata.xls"> --->
		<table border="2">
		<tr>
		<td>Date</td> <td>Open</td> <td>high</td> <td>low</td> <td>close</td> <td>LinReg</td> <td>LinRegAngle</td>
		<td>LinRegSlope</td> <td>LinRegIntercept</td> <td>LRSDelta</td>
		<td>Momentum</td> <td>RSI</td> <td>ADX</td> <td>CCI</td>
		<td>TestResult</td> <td>HKLong</td> <td>HKShort</td> <td>longp</td> <td>shortp</td> <td>longe</td>
		<td>shorte</td> <td>tlongp</td> <td>tshortp</td> 
		<!--- <td>Position</td><td>Profit</td> --->
		</tr>
 		<cfloop query="arguments.exceldata">
		<tr>
		<td>#DateOne#</td><td>#Open#</td><td>#high#</td><td>#low#</td><td>#close#</td><td>#LinearReg#</td><td>#LinearRegAngle#</td>
		<td>#LinearRegSlope#</td><td>#LinearRegIntercept#</td><td>#LRSDelta#</td>
		<td>#Momentum#</td><td>#RSI#</td><td>#ADX#</td><td>#CCI#</td>
		<td>#TestResult#</td> <td>#HKLong#</td> <td>#HKShort#</td> <td>#longp#</td> <td>#shortp#</td> <td>#longe#</td>
		<td>#shorte#</td> <td>#tlongp#</td> <td>#tshortp#</td> 
		<!--- <td>#Position#</td><td>#Profit#</td> --->
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
		<cfset var rootpath= GetDirectoryFromPath(GetBaseTemplatePath()) /> >
		<cffile action="write" file="#rootpath##arguments.filePath#\#arguments.filename#" output="#arguments.filedata#"  />
		<cfreturn arguments.filename />
	</cffunction>
</cfcomponent>