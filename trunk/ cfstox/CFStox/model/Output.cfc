<cfcomponent  displayname="Output" output="false" >

	<cffunction name="Init" description="" access="public" displayname="" output="false" returntype="Output">
		<cfreturn this />
	</cffunction>

	<cffunction name="PDF" description="I output a PDF file" access="public" displayname="" output="false" returntype="void">
		<cfargument name="content" required="true">
		<cfargument name="filename" required="true">
		<cfdocument  format="PDF" filename="#arguments.filename#">
		<cfoutput>#arguments.content#</cfoutput>
		</cfdocument>
		<cfreturn />
	</cffunction>
	
	<cffunction name="TradeReport" description="I output a PDF of the trades" access="public" displayname="" output="false" returntype="void">
		<cfargument name="data" required="true">
		<cfset var local = structNew() />
		<cfset local.filename = "C:\JRun4\servers\cfusion\cfusion-ear\cfusion-war\CFStox\Data\" & "#arguments.data.results.symbol#" & ".pdf"/>
		<cfdocument  format="PDF" filename="#local.filename#" overwrite="true">
		<cfoutput>
		<table>
		<cfloop list="#arguments.data.ReportHeaders#" index="i">
		<th>#i#</th>
		</cfloop>
		<cfloop from="1" to="#arguments.data.results.beancollection.size()#" index="i">
		<cfset local.TradeBean = arguments.data.results.beancollection[i] />	
		<tr>
			<cfloop list="#arguments.data.reportMethods#" index="j">
			<td>#local.tradebean.Get(j)#</td>
			</cfloop>
		</tr>
		</cfloop>
		</table>
		</cfoutput>
		</cfdocument>
		<cfreturn />
	</cffunction>
	
	<cffunction name="GetPDFPath" description="I get the absolute path for the PDF" access="public" displayname="" output="false" returntype="String">
		<cfargument name="data" required="true">
		<cfset var filepath = "C:\JRun4\servers\cfusion\cfusion-ear\cfusion-war\CFStox\Data\">
		<cfset var filename = filepath & "#arguments.data.symbol#" />
		<cfreturn filename/>
	</cffunction>
<!--- save comments  --->

<!--- get file storage path --->

<!--- flush comment array --->

<!--- loop thru table header array and write th headers --->
<!--- loop over methods array and call methods on the tradebean to get info --->


</cfcomponent>