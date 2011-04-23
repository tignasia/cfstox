<cfcomponent  displayname="Output" output="false" >

	<cffunction name="Init" description="" access="public" displayname="" output="false" returntype="ReportService">
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
	
	<cffunction name="BeanReportPDF" description="I output a PDF of the bean status" access="public" displayname="" output="false" returntype="void">
		<cfargument name="data" required="true">
		<cfset var local = structNew() />
		<cfset local.filename = "C:\JRun4\servers\cfusion\cfusion-ear\cfusion-war\CFStox\Data\" & "#arguments.data.results.symbol#" & ".pdf"/>
		<cfdocument  format="PDF" filename="#local.filename#" overwrite="true" orientation = "landscape">
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
	
	<cffunction name="BeanReportExcel" description="I output a Excel of the bean status" access="public" displayname="" output="false" returntype="void">
		<cfargument name="data" required="true">
		<cfset var local = structNew() />
		<cfset local.filename = "C:\JRun4\servers\cfusion\cfusion-ear\cfusion-war\CFStox\Data\" & "#arguments.data.results.symbol#" & ".xls"/>
		<cfsavecontent variable="exceldata">
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
		</cfsavecontent>
		<cffile action="write" file="#local.filename#" output="#exceldata#"   />
		<cfreturn />
	</cffunction>
	
	<cffunction name="TradeReport" description="I output a PDF of the trades" access="public" displayname="" output="false" returntype="void">
		<cfargument name="data" required="true">
		<cfset var local = structNew() />
		<cfset local.filename = "C:\JRun4\servers\cfusion\cfusion-ear\cfusion-war\CFStox\Data\" & "#arguments.data.results.symbol#" & "trades" & ".pdf"/>
		<cfset local.longpostion = false />
		<cfset local.longEntryPrice = 0 />
		<cfdocument  format="PDF" filename="#local.filename#" overwrite="true" >
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
			<cfif local.tradeBean.Get("HKGoShort") OR local.tradeBean.Get("HKCloseShort") >
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
	
	<cffunction name="TradeReportPDF" description="I output a PDF of the trades" access="public" displayname="" output="false" returntype="void">
		<cfargument name="BeanArray" required="true">
		<cfset var local = structNew() />
		<cfset local.filename = "C:\JRun4\servers\cfusion\cfusion-ear\cfusion-war\CFStox\Data\" & "#arguments.symbol#" & "trades" & ".pdf"/>
		<cfset local.ReportHeaders1 	= "Trade,Entry,Entry,Profit,Net Profit">
		<cfset local.ReportHeaders2 	= "Type,/Exit Price,/Exit Date,/Loss,/Loss">
		<cfdocument  format="PDF" filename="#local.filename#" overwrite="true" >
		<cfoutput>
		<table cellspacing="10" width="80%">
		<tr>
		<cfloop list="#local.ReportHeaders1#" index="i">
		<th>#i#</th>
		</cfloop>
		</tr>
		<tr>
		<cfloop list="#local.ReportHeaders2#" index="i">
		<th>#i#</th>
		</cfloop>
		</tr>
		<cfset local.longentry 		= 0  />
		<cfset local.shortentry 	= 0 />
		<cfset local.profitloss 	= 0 />
		<cfset local.netprofitloss 	= 0 />
		<cfset local.Price		 	= 0 />
		<cfset local.Date 		= 0 />
		<cfloop from="1" to="#arguments.beanarray.size()#" index="i">
			<cfset local.EntryDate 	= "" />
			<cfset local.ExitPrice 	= 0 />
			<cfset local.ExitDate 	= "" />
			<cfset local.TradeBean = arguments.BeanArray[i] />	
			<cfif local.tradeBean.LongOpen >
				<cfset local.TradeType = "Long Open" />
				<cfset local.entryprice = local.tradeBean.LongOpenPrice  />
				<cfset local.entrydate = local.tradeBean.LongOpenDate  />
				<cfset local.longentry = local.tradeBean.LongOpenPrice  />
				<cfset local.price = local.tradeBean.LongOpenPrice  />
				<cfset local.date = local.tradeBean.LongOpenDate  />
				
			</cfif> 
			<cfif local.tradeBean.LongClose >
				<cfset local.TradeType = "Long Close" />
				<cfset local.exitprice 	= local.tradeBean.LongClosePrice  />
				<cfset local.exitdate 	= local.tradeBean.LongCloseDate  />
				<cfset local.profitloss =  local.tradeBean.LongClosePrice - local.longentry  />
				<cfset local.netprofitloss = local.netprofitloss + local.profitloss />
				<cfset local.price 	= local.tradeBean.LongClosePrice  />
				<cfset local.date 	= local.tradeBean.LongCloseDate  />
			</cfif> 
			<cfif local.tradeBean.ShortOpen>
				<cfset local.TradeType = "Short Open" />
				<cfset local.EntryPrice = local.tradeBean.ShortOpenPrice />
				<cfset local.EntryDate  = local.tradeBean.ShortOpenDate />
				<cfset local.ShortEntry 	= local.tradeBean.ShortOpenPrice />
				<cfset local.price 	= local.tradeBean.ShortOpenPrice  />
				<cfset local.date 	= local.tradeBean.ShortOpenDate  />
			</cfif> 
			<cfif local.tradeBean.ShortClose>
				<cfset local.TradeType = "Short Close" />
				<cfset local.ExitPrice = local.tradeBean.ShortClosePrice />
				<cfset local.ExitDate  = local.tradeBean.ShortCloseDate />
				<cfset local.profitloss =  local.shortentry - local.tradeBean.ShortClosePrice />
				<cfset local.netprofitloss = local.netprofitloss + local.profitloss />
				<cfset local.Price = local.tradeBean.ShortClosePrice />
				<cfset local.Date  = local.tradeBean.ShortCloseDate />
			</cfif> 
			<tr>
			<td>#local.TradeType#</td>
			<td>#local.Price#</td>
			<td>#local.Date#</td>
			<td>#local.profitloss#</td>
			<td>#local.netprofitloss#</td>
			</tr>
			<cfset local.profitloss =  "" />
		</cfloop>
		</table>
		</cfoutput>
		</cfdocument>
		<cfreturn />
	</cffunction>
	
	<cffunction name="WatchListReportPDF" description="I output a PDF of the trades" access="public" displayname="" output="false" returntype="void">
		<cfargument name="BeanArray" required="true">
		<cfargument name="watchlist" required="false" default="1" />
		<cfset var local = structNew() />
		<cfset local.filename = "C:\JRun4\servers\cfusion\cfusion-ear\cfusion-war\CFStox\Data\" & "Watchlist" & "#arguments.watchlist#" & ".pdf"/>
		<cfset local.ReportHeaders1 	= "Symbol,Trade,Entry Price,Date">
		<cfdocument  format="PDF" filename="#local.filename#" overwrite="true" >
		<cfoutput>
		<table cellspacing="10" width="80%">
		<tr>
		<cfloop list="#local.ReportHeaders1#" index="i">
		<th>#i#</th>
		</cfloop>
		</tr>
		
		<cfset local.longentry 		= 0  />
		<cfset local.shortentry 	= 0 />
		<cfset local.profitloss 	= 0 />
		<cfset local.netprofitloss 	= 0 />
		<cfset local.Price		 	= 0 />
		<cfset local.Date 		= 0 />
		<cfloop from="1" to="#arguments.beanarray.size()#" index="i">
			<cfset local.EntryDate 	= "" />
			<cfset local.ExitPrice 	= 0 />
			<cfset local.ExitDate 	= "" />
			<cfset local.TradeBean = arguments.BeanArray[i] />
			<cfset local.symbol = local.tradebean.get("Symbol") />	
			<cfif local.tradeBean.LongOpen >
				<cfset local.TradeType = "Long Open" />
				<cfset local.entryprice = local.tradeBean.LongOpenPrice  />
				<cfset local.entrydate = local.tradeBean.LongOpenDate  />
				<cfset local.longentry = local.tradeBean.LongOpenPrice  />
				<cfset local.price = local.tradeBean.LongOpenPrice  />
				<cfset local.date = local.tradeBean.LongOpenDate  />
				
			</cfif> 
			<cfif local.tradeBean.LongClose >
				<cfset local.TradeType = "Long Close" />
				<cfset local.exitprice 	= local.tradeBean.LongClosePrice  />
				<cfset local.exitdate 	= local.tradeBean.LongCloseDate  />
				<cfset local.profitloss =  local.tradeBean.LongClosePrice - local.longentry  />
				<cfset local.netprofitloss = local.netprofitloss + local.profitloss />
				<cfset local.price 	= local.tradeBean.LongClosePrice  />
				<cfset local.date 	= local.tradeBean.LongCloseDate  />
			</cfif> 
			<cfif local.tradeBean.ShortOpen>
				<cfset local.TradeType = "Short Open" />
				<cfset local.EntryPrice = local.tradeBean.ShortOpenPrice />
				<cfset local.EntryDate  = local.tradeBean.ShortOpenDate />
				<cfset local.ShortEntry 	= local.tradeBean.ShortOpenPrice />
				<cfset local.price 	= local.tradeBean.ShortOpenPrice  />
				<cfset local.date 	= local.tradeBean.ShortOpenDate  />
			</cfif> 
			<cfif local.tradeBean.ShortClose>
				<cfset local.TradeType = "Short Close" />
				<cfset local.ExitPrice = local.tradeBean.ShortClosePrice />
				<cfset local.ExitDate  = local.tradeBean.ShortCloseDate />
				<cfset local.profitloss =  local.shortentry - local.tradeBean.ShortClosePrice />
				<cfset local.netprofitloss = local.netprofitloss + local.profitloss />
				<cfset local.Price = local.tradeBean.ShortClosePrice />
				<cfset local.Date  = local.tradeBean.ShortCloseDate />
			</cfif> 
			<tr>
			<td>#local.symbol#</td>
			<td>#local.TradeType#</td>
			<td>#local.Price#</td>
			<td>#local.Date#</td>
			</tr>
			<cfset local.profitloss =  "" />
		</cfloop>
		</table>
		</cfoutput>
		</cfdocument>
		<cfreturn />
	</cffunction>
	
	<cffunction name="getTradeStruct" access="private" output="false" returntype="Any">
		<cfscript>
		 local.tradeStruct = structNew();
		 local.tradestruct.Symbol 			= "";
		 local.tradestruct.LongOpen 		= false;
		 local.tradestruct.LongOpenDate 	= "";
		 local.tradestruct.LongOpenPrice 	= "";
		 local.tradestruct.LongClose 		= false;
		 local.tradestruct.LongCloseDate 	= "";
		 local.tradestruct.LongClosePrice	= "";
		 local.tradestruct.ShortOpen 		= false;
		 local.tradestruct.ShortOpenDate 	= "";
		 local.tradestruct.ShortOpenPrice	= "";
		 local.tradestruct.ShortClose 		= false;
		 local.tradestruct.ShortCloseDate 	= "";
		 local.tradestruct.ShortClosePrice	= "";
		 return local.tradestruct;
		</cfscript>
	</cffunction>
	
	<cffunction name="TradeReportBuilder" description="I build a structure of trades" access="public" displayname="" output="false" returntype="array">
		<!--- todo:test I stopped here --->
		<cfargument name="data" required="true">
		<cfset var local = structNew() />
		<cfset local.tradeArray = ArrayNew(1) />
		<cfset local.arrayindex = 1 />
		<cfloop from="1" to="#arguments.data.size()#" index="i">
			<cfset local.tradeflag = false />
			<cfset local.tradeStruct = GetTradeStruct() />
			<cfset local.TradeBean = arguments.data[i] />
			
			<cfif local.tradeBean.Get("HKCloseShort") >
				<cfset local.tradeStruct = GetTradeStruct() />
				<cfset local.tradeStruct.symbol = local.tradeBean.Get("symbol") />
				<cfset local.tradestruct.ShortClose 		= true />
				<cfset local.tradestruct.ShortCloseDate 	= local.tradeBean.Get("Date") />
				<cfset local.tradestruct.ShortClosePrice 	= local.tradeBean.Get("HKClose") />
				<cfset local.tradeArray[local.arrayindex] 	= local.tradestruct />
				<cfset local.arrayindex = local.arrayindex + 1 >			
			</cfif>
			<cfif local.tradeBean.Get("HKGoLong")  >
				<cfset local.tradeStruct = GetTradeStruct() />
				<cfset local.tradeStruct.symbol = local.tradeBean.Get("symbol") />
				<cfset local.tradestruct.LongOpen 		= true />
				<cfset local.tradestruct.LongOpenDate 	= local.tradeBean.Get("Date") />
				<cfset local.tradestruct.LongOpenPrice 	= local.tradeBean.Get("HKClose") />
				<cfset local.tradeArray[local.arrayindex] = local.tradestruct />
				<cfset local.arrayindex = local.arrayindex + 1 >			
			</cfif>
			<cfif local.tradeBean.Get("HKCloseLong")>
				<cfset local.tradeStruct = GetTradeStruct() />
				<cfset local.tradeStruct.symbol = local.tradeBean.Get("symbol") />
				<cfset local.tradestruct.LongClose 		= true />
				<cfset local.tradestruct.LongCloseDate 	= local.tradeBean.Get("Date") />
				<cfset local.tradestruct.LongClosePrice = local.tradeBean.Get("HKClose") />
				<cfset local.tradeArray[local.arrayindex] = local.tradestruct />
				<cfset local.arrayindex = local.arrayindex + 1 >			
			</cfif>
			<cfif local.tradeBean.Get("HKGoShort") >
				<cfset local.tradeStruct = GetTradeStruct() />
				<cfset local.tradeStruct.symbol = local.tradeBean.Get("symbol") />
				<cfset local.tradestruct.ShortOpen 		= true />
				<cfset local.tradestruct.ShortOpenDate 	= local.tradeBean.Get("Date") />
				<cfset local.tradestruct.ShortOpenPrice	= local.tradeBean.Get("HKClose") />
				<cfset local.tradeArray[local.arrayindex] = local.tradestruct />
				<cfset local.arrayindex = local.arrayindex + 1 >			
			</cfif>
		</cfloop>
		<cfreturn local.tradearray />
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
		<cfoutput>
		New Short Positions <br/>
		<table>
		<th>Symbol</th>
		<th>ClosingPrice</th> 
		<th>Date</th>
		<th>R1</th> 
		<th>Previous Low</th>
		<th>Previous Low Date</th>
		
		<cfloop array="#arguments.data#" index="k">
		<cfset local.TradeBean =  k />	
		<cfif local.TradeBean["goshort"].Get("HKGoShort") > 
		<tr>
			<td>#local.tradebean["goshort"].Get("Symbol")#</td>
			<td>#local.tradebean["goshort"].Get("HKClose")#</td>
			<td>#local.tradebean["goshort"].Get("Date")#</td>
			<td>#DecimalFormat(local.tradebean["goshort"].Get("R1"))#</td>
			<td>#local.tradebean["goshort"].Get("PreviousLocalHigh")#</td>
			<td>#local.tradebean["goshort"].Get("PreviousLocalHighDate")#</td>
		</tr>
		</cfif> 
		</cfloop>
		</table>
		</cfoutput>
		</cfdocument>
		<cfreturn />
	</cffunction>
	
	<cffunction name="RunReport" description="I output a PDF of the bean status" access="public" displayname="" output="false" returntype="void">
		<cfargument name="data" required="true">
		<cfset var local = structNew() />
		
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