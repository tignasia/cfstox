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
	
	<cffunction name="BeanReport" description="I output a PDF of the bean status" access="public" displayname="" output="false" returntype="void">
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
	
	<cffunction name="TradeReport" description="I output a PDF of the trades" access="public" displayname="" output="false" returntype="void">
		<cfargument name="data" required="true">
		<cfset var local = structNew() />
		<cfset local.filename = "C:\JRun4\servers\cfusion\cfusion-ear\cfusion-war\CFStox\Data\" & "#arguments.data.results.symbol#" & "trades" & ".pdf"/>
		<cfset local.longpostion = false />
		<cfset local.longEntryPrice = 0 />
		<cfdocument  format="PDF" filename="#local.filename#" overwrite="true">
		<cfoutput>
		<table>
		<cfloop list="#arguments.data.ReportHeaders#" index="i">
		<th>#i#</th>
		</cfloop>
		<cfloop from="1" to="#arguments.data.results.beancollection.size()#" index="i">
			<cfset local.TradeBean = arguments.data.results.beancollection[i] />	
			<cfif local.tradeBean.Get("HKGoLong") OR local.tradeBean.Get("HKCloseLong") >
				<tr>
					<cfloop list="#arguments.data.reportMethods#" index="j">
					<td>#local.tradebean.Get(j)#</td>
					</cfloop>
				</tr>
			</cfif>
		</cfloop>
		</table>
		</cfoutput>
		</cfdocument>
		<cfreturn />
	</cffunction>
	
	<cffunction name="ProfitReport" description="I output a PDF of the best trades" access="public" displayname="" output="false" returntype="void">
		<cfargument name="data" required="true">
		<cfset var local = structNew() />
		<cfset local.filename = "C:\JRun4\servers\cfusion\cfusion-ear\cfusion-war\CFStox\Data\" & "#arguments.data.results.symbol#" & "trades" & ".pdf"/>
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
	
	<cffunction name="HiLoReport" description="I output a PDF of the highs and lows" access="public" displayname="" output="false" returntype="void">
		<cfargument name="data" required="true">
		<cfset var local = structNew() />
		<cfset local.filename = "C:\JRun4\servers\cfusion\cfusion-ear\cfusion-war\CFStox\Data\" & "#arguments.data.results.symbol#" & "HiLo" & ".pdf"/>
		<cfdocument  format="PDF" filename="#local.filename#" overwrite="true">
		<cfoutput>
		<table width="90%">
		<cfloop list="#arguments.data.ReportHeaders#" index="i">
		<th>#i#</th>
		</cfloop>
		<cfloop from="1" to="#arguments.data.results.HiLoBeanArray.size()#" index="i">
		<cfset local.TradeBean = arguments.data.results.HiLoBeanArray[i] />	
		<cfif local.tradeBean.Get("NewLocalLow") OR local.tradeBean.Get("NewLocalHigh") >
			<tr>
				<cfloop list="#arguments.data.reportMethods#" index="j">
				<td>#local.tradebean.Get(j)#</td>
				</cfloop>
			</tr>
		</cfif>
		</cfloop>
		</table>
		</cfoutput>
		</cfdocument>
		<cfreturn />
	</cffunction>
	
	<cffunction name="WatchListReport" description="I output a PDF of the bean status" access="public" displayname="" output="false" returntype="void">
		<cfargument name="data" required="true">
		<cfset var local = structNew() />
		<cfset local.filename = "C:\JRun4\servers\cfusion\cfusion-ear\cfusion-war\CFStox\Data\" & "WatchList" & ".pdf"/>
		<cfdocument  format="PDF" filename="#local.filename#" overwrite="true">
		<cfoutput>
		Watchlist Report <br/>
		Breakout Highs <br/>
		<table>
		<th>Symbol</th>
		<th>ClosingPrice</th>
		<th>High</th>
		<th>Date</th>
		<th>Previous High</th>
		<th>Previous High Date</th>
		<cfloop array="#arguments.data#" index="i"  >
		<cfset local.TradeBean = i />
			<cfif local.TradeBean["highbreakout"].Get("NewHighBreakOut") > 
		<tr>
			<td>#local.tradebean["highbreakout"].Get("Symbol")#</td>
			<td>#local.tradebean["highbreakout"].Get("HKClose")#</td>
			<td>#local.tradebean["highbreakout"].Get("HKHigh")#</td>
			<td>#local.tradebean["highbreakout"].Get("Date")#</td>
			<td>#local.tradebean["highbreakout"].Get("PreviousLocalHigh")#</td>
			<td>#local.tradebean["highbreakout"].Get("PreviousLocalHighDate")#</td>
		</tr>
		</cfif> 
		</cfloop>
		</table>
		</cfoutput>
		<cfoutput>
		New Long Positions <br/>
		<table>
		<th>Symbol</th>
		<th>ClosingPrice</th> 
		<th>Date</th>
		<th>R1</th> 
		<th>Previous High</th>
		<th>Previous High Date</th>
		
		<cfloop array="#arguments.data#" index="j">
		<cfset local.TradeBean =  j />	
		<cfif local.TradeBean["golong"].Get("HKGoLong") > 
		<tr>
			<td>#local.tradebean["golong"].Get("Symbol")#</td>
			<td>#local.tradebean["golong"].Get("HKClose")#</td>
			<td>#local.tradebean["golong"].Get("Date")#</td>
			<td>#DecimalFormat(local.tradebean["golong"].Get("R1"))#</td>
			<td>#local.tradebean["golong"].Get("PreviousLocalHigh")#</td>
			<td>#local.tradebean["golong"].Get("PreviousLocalHighDate")#</td>
		</tr>
		</cfif> 
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