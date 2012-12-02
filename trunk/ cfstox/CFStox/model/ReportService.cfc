<cfcomponent  displayname="ReportService" output="false" >

	<cffunction name="Init" description="" access="public" displayname="" output="false" returntype="ReportService">
		<cfreturn this />
	</cffunction>

	<cffunction name="ReportRunner" description="I generate reports" access="public" displayname="" output="false" returntype="void">
		<cfargument name="ReportName" required="true" />
		<cfargument name="data" required="true" />
		<cfargument name="symbol" required="true" />
		<cfargument name="format" required="false"  default="Excel"/>
		<!--- <cfdump var="#arguments.data#">
		<cfabort> --->
		<cfscript>
		var local = StructNew() ;
		local.ReportResults = ReportSetup(reportName:arguments.reportName,Data:arguments.Data);
		if(arguments.format EQ "excel")
		OutputReport(content:local.reportResults,symbol:arguments.symbol,filetype:"excel",ReportName:"#arguments.ReportName#");
		else
		OutputReport(content:local.reportResults,symbol:arguments.symbol,filetype:"PDF",ReportName:"#arguments.ReportName#");  
		</cfscript> 
		<cfreturn />
	</cffunction>
	
	<cffunction name="AnalyseDataReport" description="I generate the analysedata report" access="public" displayname="" output="false" returntype="void">
		<cfargument name="data" required="true" />
		<cfargument name="symbol" required="true" />
		<cfset var local = StructNew() />
		<cfset local.crlf = chr(1) & chr(13) />
		<cfoutput>
		<cfsavecontent variable="local.reportResults">
		<!DOCTYPE html>
		<html>
		<head>
		<style type="text/css">
		##txts {width:250px;float:left;}
		##clearer {clear:both;height:0;}
		##pgbr {page-break-before:always}}
		</style>
		</head>
		Analysis for #arguments.symbol# </br> 
		<cfloop from="2" to="#arguments.data.size()#" index="i">
			<cfif i GT 1 AND i MOD 2 >
			<div id="pgbr"></div>
			</cfif>
			<cfset local.dayStruct = arguments.data[i] />
			<table>
			<tr><td>Symbol: #arguments.symbol#		Date: #local.dayStruct.Date#	</td></tr>
			<tr><td>
				Open:   #local.dayStruct.Open# 
				High:   #local.dayStruct.High# 
				Low:    #local.dayStruct.Low#
				Close:  #local.dayStruct.Close# 
				Change: #local.dayStruct.Change#
				Volume: #local.dayStruct.Volume#
				Volume Change: 	#local.dayStruct.VolumeChange#
			</td></tr>
			</table>
			
			<div id="container" style="width:500px">
			<div id="txts">Resistance: R1Break: #local.dayStruct.Pivots.R1Break#</div>
			<div id="txts">Resistance: R2Break: #local.dayStruct.Pivots.R2Break#</div>
			</div>
			<div id="container" style="width:500px">
			<div id="txts">Resistance: HAR1Break: #local.dayStruct.Pivots.HAR1Break#</div>
			<div id="txts">Resistance: HAR2Break: #local.dayStruct.Pivots.HAR2Break#</div>
			</div>
			<div id="container" style="width:500px">		
			<div id="txts">Support: S1Break: #local.dayStruct.Pivots.S1Break#</div>
			<div id="txts">Support: S2Break: #local.dayStruct.Pivots.S2Break#</div>
			<div id="txts">Support: HAS1Break: #local.dayStruct.Pivots.HAS1Break#</div>
			<div id="txts">Support: HAS2Break: #local.dayStruct.Pivots.HAS2Break#</div>
			</div>
			<div id="clearer" style="width:500px">
			</div>
			<table> 
			<tr><td style="width:100%">Candle Pattern:  #local.dayStruct.CandlePattern.value# </td></tr>
			<tr><td>#local.dayStruct.CandlePattern.comment# </td></tr>
			<tr><td>HA Candle Pattern:  #local.dayStruct.HACandlePattern.value# </td></tr>
			<tr><td>#local.dayStruct.HACandlePattern.comment# </td></tr>
			<tr><td>CCI : #Round(local.dayStruct.CCI.value*100)/100# #local.dayStruct.CCI.comment#</td></tr>
			<tr><td>AroonOsc : #local.dayStruct.AroonOsc.value# #local.dayStruct.AroonOsc.comment#</td></tr>
			</table>
			<table>  
			<tr>
			<td style="width:25%;">Candle Buy Flag : #local.dayStruct.CandleBuyflag#</td>
			<td style="width:25%;">Candle Sell Flag : #local.dayStruct.CandleSellflag#</td></tr>
			<tr><td style="width:25%;">HA Candle Buy Flag : #local.dayStruct.HACandleBuyflag#</td><td style="width:25%;">HA Candle Sell Flag : #local.dayStruct.HACandleSellflag#</td></tr>
			<tr><td style="width:25%;">ZigZag: #local.dayStruct.ZigZag.value#</td><td style="width:25%;"></td></tr>
			<tr>
			<td style="width:20%;">ZigZag Buy Flag : #local.dayStruct.ZigZagBuyflag#</td>
			<td style="width:20%;">ZigZag Sell Flag : #local.dayStruct.ZigZagSellflag#</td>
			<td style="width:20%;">ZigZag Length: #local.dayStruct.ZigZagLen.Duration#</td>
			<td style="width:20%;">ZigZag Percent: #local.dayStruct.ZigZagLen.Percent#</td>
			<td style="width:20%;">ZigZag Value: #local.dayStruct.ZigZagLen.Value#</td>
			</tr>
			<tr><td>----------------------------- </td></tr>
			</table>
		</cfloop>
		
		</cfsavecontent>
		</cfoutput>
		<cfset OutputReport(content:local.reportResults,symbol:arguments.symbol,filetype:"PDF",ReportName:"testAnalysis") />
		<cfset OutputReport(content:local.reportResults,symbol:arguments.symbol,filetype:"HTML",ReportName:"testAnalysis") />
		<cfreturn />
	</cffunction>
	
	<cffunction name="ReportSetUp" description="I define a report" access="private" displayname="" output="false" returntype="Any">
		<!---- regardless of the report, the final output should be a list of headers and an array --->
		<cfargument name="reportName" required="true" />
		<cfargument name="data" required="true" />
		<cfset var local = structNew() />
		<cfset local.dataArray = ArrayNew(2) />
		<cfswitch  expression="#arguments.ReportName#">
			<cfcase value="HistoryReport">
				<!--- <cfset local.headers = "SYMBOL,DATEONE,OPEN,HIGH,LOW,CLOSE,VOLUME,MOMENTUM,ADX,CCI,RSI,LOCALHIGH,LOCALLOW,LINEARREG,LINEARREG10,LINEARREGANGLE,LINEARREGINTERCEPT,LINEARREGSLOPE,LINEARREGSLOPE10,LRSDELTA,PP,R1,R2,S1,S2,R1Break,R2Break,S1Break,S2Break">
				 --->
				 <cfset local.dspHeaders = "SYM,DATE,OPEN,HIGH,LOW,CLOSE,VOL,MO,ADX,CCI,CCI5,RSI,LR,LR10,LRANG,LRINTR,LRSLP,LRSLP10,LRSDEL,FSLOPE,SSLOPE">
				 <cfset local.headers = "SYMBOL,DATEONE,OPEN,HIGH,LOW,CLOSE,VOLUME,MOMENTUM,ADX,CCI,CCI5,RSI,LINEARREG,LINEARREG10,LINEARREGANGLE,LINEARREGINTERCEPT,LINEARREGSLOPE,LINEARREGSLOPE10,LRSDELTA,FASTSLOPE,SLOWSLOPE">
				<!---  <cfset local.headers = arguments.data.columnlist> --->
				<cfset local.dataArray = session.Objects.Utility.QryToArray(query:arguments.data,columnlist:local.headers) />
			</cfcase>
			<cfcase value="PivotReport">
				<!--- <cfset local.headers = "SYMBOL,DATEONE,OPEN,HIGH,LOW,CLOSE,VOLUME,MOMENTUM,ADX,CCI,RSI,LOCALHIGH,LOCALLOW,LINEARREG,LINEARREG10,LINEARREGANGLE,LINEARREGINTERCEPT,LINEARREGSLOPE,LINEARREGSLOPE10,LRSDELTA,PP,R1,R2,S1,S2,R1Break,R2Break,S1Break,S2Break">
				 --->
				 <cfset local.dspHeaders = "SYM,DATE,OPEN,HIGH,LOW,CLOSE,VOL,LOHIGH,LHVAL,LOLOW,LLVAL,PP,R1,R2,S1,S2,R1Break,R2Break,S1Break,S2Break">
				 <cfset local.headers = "SYMBOL,DATEONE,OPEN,HIGH,LOW,CLOSE,VOLUME,LOCALHIGH,LOCALHIGHVALUE,LOCALLOW,LOCALLOWVALUE,PP,R1,R2,S1,S2,R1Break,R2Break,S1Break,S2Break">
				<!---  <cfset local.headers = arguments.data.columnlist> --->
				<cfset local.dataArray = session.Objects.Utility.QryToArray(query:arguments.data,columnlist:local.headers) />
			</cfcase>
			<cfcase value="CandleReport">
				<!--- <cfset local.headers = "SYMBOL,DATEONE,OPEN,HIGH,LOW,CLOSE,VOLUME,MOMENTUM,ADX,CCI,RSI,LOCALHIGH,LOCALLOW,LINEARREG,LINEARREG10,LINEARREGANGLE,LINEARREGINTERCEPT,LINEARREGSLOPE,LINEARREGSLOPE10,LRSDELTA,PP,R1,R2,S1,S2,R1Break,R2Break,S1Break,S2Break">
				 --->
				 <cfset local.dspHeaders = "SYM,DATE,OPEN,HIGH,LOW,CLOSE,VOL,Engulfing,Hammer,HangingMan,ThreeInside,ThreeOutside,ThreeBlackCrows,Harami,HaramiCross,LongLine,DarkCloudCover">
				 <cfset local.headers = "SYMBOL,DATEONE,OPEN,HIGH,LOW,CLOSE,VOLUME,Engulfing,Hammer,HangingMan,ThreeInside,ThreeOutside,ThreeBlackCrows,Harami,HaramiCross,LongLine,DarkCloudCover">
				<!---  <cfset local.headers = arguments.data.columnlist> --->
				<cfset local.dataArray = session.Objects.Utility.QryToArray(query:arguments.data,columnlist:local.headers) />
			</cfcase>
			<cfcase value="BreakoutReport">
				<cfset local.dspHeaders = "DATEONE,OPEN,HIGH,LOW,CLOSE,LOCALHIGH,LOCALHIGHVALUE,LOCALLOW,LOCALLOWVALUE,PP,R1,R1BREAK,R2,R2BREAK,S1,S1BREAK,S2,S2BREAK" />
				<cfset local.headers = "DATEONE,OPEN,HIGH,LOW,CLOSE,LOCALHIGH,LOCALHIGHVALUE,LOCALLOW,LOCALLOWVALUE,PP,R1,R1BREAK,R2,R2BREAK,S1,S1BREAK,S2,S2BREAK" />
				<cfset local.dataArray = session.Objects.Utility.QryToArray(query:arguments.data,columnlist:local.headers) />
			</cfcase>
			<cfcase value="AnalyseData">
				<cfset local.dspHeaders = "DATEONE,OPEN,HIGH,LOW,CLOSE,LOCALHIGH,LOCALHIGHVALUE,LOCALLOW,LOCALLOWVALUE,PP,R1,R1BREAK,R2,R2BREAK,S1,S1BREAK,S2,S2BREAK" />
				<cfset local.headers = "DATEONE,OPEN,HIGH,LOW,CLOSE,LOCALHIGH,LOCALHIGHVALUE,LOCALLOW,LOCALLOWVALUE,PP,R1,R1BREAK,R2,R2BREAK,S1,S1BREAK,S2,S2BREAK" />
				<cfset local.dataArray = session.Objects.Utility.QryToArray(query:arguments.data,columnlist:local.headers) />
			</cfcase>
			<cfcase value="BacktestReport">
				<cfset local.dspHeaders = "Date,Description,Entry_Exit,Price,Profit,NetProfit">
				<cfset local.headers = "Date,Description,Entry_Exit,Price,Profit,NetProfit">
				<cfset local.alen = arguments.data.size() />
				<cfset local.dataArray = ArrayNew(2) />
				<cfset local.Profit = 0 />
				<cfset local.NetProfit = 0 />
				
				<cfloop from="1" to="#local.alen#" index="local.j">
					<cfif arguments.data[local.j].TradeDescription EQ "OpenShort">
						<cfset local.Profit = 0 />
						<cfset local.TradeTracker = arguments.data[local.j].TradePrice />
					</cfif>
					<cfif arguments.data[local.j].TradeDescription EQ "CloseShort">
						<cfset local.Profit = local.TradeTracker - arguments.data[local.j].TradePrice />
						<cfset local.NetProfit = local.NetProfit + local.Profit >
						<cfset local.TradeTracker = 0 />
					</cfif>
					<cfset local.DataArray[local.j][1] = arguments.data[local.j].date />
					<cfset local.DataArray[local.j][2] = arguments.data[local.j].TradeDescription />
					<cfset local.DataArray[local.j][3] = arguments.data[local.j].TradeEntryExitPoint />
					<cfset local.DataArray[local.j][4] = arguments.data[local.j].Price />
					<cfset local.DataArray[local.j][5] = local.Profit />
					<cfset local.DataArray[local.j][6] = local.NetProfit />
				</cfloop>
			</cfcase>
			<cfcase value="ProfitReport">
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
				</cfoutput>
			</cfcase>
			<cfcase value="HiLoReport">
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
			</cfcase>
			<cfcase value="BeanReport">
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
			</cfcase>
			<cfcase value="WatchListReport">
				<cfset local.watchlist = local.watchlist3>
			</cfcase>
		</cfswitch>	
		
		<cfset local.i = 1 />
		<cfset local.j = 1 />
		<cfset local.alen = local.dataArray.size() />
		<cfset local.rowlen = local.dataArray[1].size() />
		<cfsavecontent variable="local.Reportdata">
		<cfoutput>
		<table>
		<cfloop list="#local.dspHeaders#" index="local.i">
			<th>#local.i#</th>
		</cfloop>
		<cfloop from="1" to="#local.alen#" index="local.j">
			<tr>
			<cfloop from="1" to="#local.rowlen#" index="local.k">
				<td>#local.dataArray[local.j][local.k]#</td>
			</cfloop>
			</tr>
		</cfloop>
		</table>
		</cfoutput>
		</cfsavecontent>
		<cfreturn local.Reportdata />
	</cffunction>
	
	<cffunction name="OutputReport" description="I write the report files" access="public" displayname="" output="false" returntype="void">
		<!---- regardless of the report, the final output should be a list of headers and an array --->
		<cfargument name="content" required="true">
		<cfargument name="symbol" required="true">
		<cfargument name="filetype" required="true">
		<cfargument name="reportName" required="true">
		<!--- fix for google requiring "NYSE" for IOC and others.  --->
		<cfif left(arguments.symbol,4) EQ "NYSE" >
			<cfset arguments.symbol = right(arguments.symbol,3) >
		</cfif>
		<cfset local.rootpath = session.objects.utility.getdirectorypath() />
		<cfset local.PDFfilename = "#local.rootpath#..\Data\" & "#arguments.symbol#" & "#arguments.reportName#" & ".pdf"/>
		<cfset local.Excelfilename = "#local.rootpath#..\Data\" & "#arguments.symbol#" & "#arguments.reportName#" & ".xls"/>
		<cfset local.HTMLfilename = "#local.rootpath#..\Data\" & "#arguments.symbol#" & "#arguments.reportName#" & ".html"/>
		<cfif arguments.filetype EQ "PDF">
			<cfdocument  format="PDF" filename="#local.PDFfilename#" overwrite="true" orientation = "portrait">
			<cfoutput>#arguments.content#</cfoutput>
			</cfdocument>
		<cfelseif arguments.filetype EQ "excel">
			<cffile action="write" file="#local.Excelfilename#" output="#arguments.content#"   />
		<cfelseif arguments.filetype EQ "html">
			<cffile action="write" file="#local.HTMLfilename#" output="#arguments.content#"   />
		</cfif>
		
		<!--- for excel --->
		<!--- <cffile action="write" file="#local.Excelfilename#" output="#local.stockdata#"   /> --->
		<cfreturn />
	</cffunction>
	<!---- these reports loop over i --->
	<!--- Fields 
	ADX	CCI	CLOSE	DATEONE	HIGH	LINEARREG	LINEARREG10	LINEARREGANGLE	LINEARREGINTERCEPT	
	LINEARREGSLOPE	LINEARREGSLOPE10	LOCALHIGH	LOCALLOW	LOW	LRSDELTA	
	MOMENTUM	OPEN	PP	
	R1	R1BREAK	R2	R2BREAK	
	RSI	
	S1	S1BREAK	S2	S2BREAK	
	SYMBOL	VOLUME --->
	
	<cffunction name="getBreakoutReportHeaders" description="I set the columns for the breakout report" access="public" displayname="" output="false" returntype="void">
		<cfset var local = structNew() />
		<cfset local.headers = "DATEONE,OPEN,HIGH,LOW,CLOSE,LOCALHIGH,LOCALLOW,PP,R1,R1BREAK,R2,R2BREAK,S1,S1BREAK,S2,S2BREAK" />
		<cfreturn local.headers />
	</cffunction>
	
	<cffunction name="BeanReport" description="I output a PDF of the bean status" access="public" displayname="" output="false" returntype="void">
		<cfargument name="data" required="true">
		<cfset var local = structNew() />
		<cfsavecontent variable="local.Stockdata">
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
		
	<cffunction name="TradeReportBuilder" description="I build a structure of trades" access="public" displayname="" output="false" returntype="array">
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

<!--- 
	<cfset local.ReportHeaders 	= "Date,Open,High,Low,Close,New High Reversal,New High Breakout,R1 Breakout, R2 Breakout,New Low Reversal,New Low Breakdown,S1 Breakdown, S2 Breakdown,RSIStatus,CCIStatus">
		<cfset local.ReportMethods 	= "Date,HKOpen,HKHigh,HKLow,HKClose,NewHighReversal,NewHighBreakout,R1Breakout1Day,R2Breakout1Day,NewLowReversal,NewLowBreakdown,S1Breakdown1Day,S2Breakdown1Day,RSIStatus,CCIStatus">
		<!--- historical technical data  --->
		<cfset session.objects.ReportService.BeanReportPDF(local) />
		<cfset session.objects.ReportService.BeanReportExcel(local) />
		<cfset local.ReportHeaders 	= "Date,Long Entry Trade,Long Exit Trade,Short Entry Trade,Short Exit Trade,Entry Price,Entry Date,Exit Price,Exit Date,Profit/loss,Net Profit/Loss">
		<cfset local.ReportMethods 	= "Date,HKGoLong,HKCloseLong,HKGoShort,HKCloseShort,EntryPrice,EntryDate,ExitPrice,ExitDate,ProfitLoss,NetProfitLoss">
		<cfset session.objects.ReportService.TradeReport(local) />
		<cfset local.ReportHeaders 	= "Date,High,Low,Price,High,Difference">
		<cfset local.ReportMethods 	= "Date,NewLocalHigh,NewLocalLow,HKHigh">
 --->
	
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
	
	<cffunction name="Dump" description="utility" access="public" displayname="test" output="false" returntype="Any">
		<cfargument name="object" required="true" />
		<cfargument name="abort" required="false"  default="true"/>
		<cfdump label="bean:" var="#arguments.object#">
		<cfif arguments.abort>
			<cfabort>
		</cfif>
	</cffunction>

	<cffunction name="TrimNum" description="utility" access="public" displayname="test" output="false" returntype="Any">
		<cfargument name="TheNumber" required="true" />
		<cfset RoundedNumber = arguments.TheNumber * 100>
		<cfset RoundedNumber = Round(RoundedNumber )>
		<cfset RoundedNumber = RoundedNumber / 100>
		<cfreturn RoundedNumber />
	</cffunction>
</cfcomponent>