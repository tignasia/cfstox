<cfcomponent  displayname="DataService" output="false" hint="I process and store the data ">

	<cffunction name="Init" description="" access="public" displayname="" output="false" returntype="DataService">
		<cfset variables.qryDataOriginal = "" />
		<cfset variables.qryDataHA = "" />
		<cfset variables.high = "" />
		<cfset variables.low = "" />
		<cfreturn this />
	</cffunction>	

	<cffunction name="reset" description="" access="public" displayname="" output="false" returntype="void">
	<cfset variables.qryDataOriginal = "" />
	<cfset variables.qryDataHA = "" />
	<cfset variables.high = "" />
	<cfset variables.low = "" />
	<cfreturn />
	</cffunction>	
	
	<cffunction name="SetDates" description="" access="public" displayname="" output="false" returntype="Any">
		<cfargument name="startdate" required="false" default="01/01/2012" />
		<cfargument name="enddate" required="false" default=now() />
		<cfset var local = StructNew() />
		<!--- 
		SPY will be used as the canonical list of dates the market was open 
		see if we already have the data for the symbol and dates requested
		check for a start day record and if not found keep going back until we get a record
		end day is a little trickier because it could be today
		if the last day is not today 
		try to get data for the last day we have it until today. We'll work with what we have.
		--->
		<!--- handle the start date --->
		<cfset local.MarketFlag = false>
		<cfset arguments.startDate = DateFormat(arguments.startdate, "mm-dd-yyyy")>
		<cfset arguments.endDate = DateFormat(arguments.enddate, "mm-dd-yyyy")>
		<cfset local.DayofWeek = DayofWeek("#arguments.startdate#") />
		<!--- see if we have data for the startdate --->
		<cfset local.qryStock = session.objects.DataDAO.Read(symbol:"SPY",date:arguments.startdate) />
		<cfif local.qryStock.recordcount EQ 1> <!--- market was open --->
			<cfset local.MarketFlag = true />		
		</cfif>
		<cfif local.MarketFlag EQ FALSE >
			<cfloop from="-1" to="-14" index="i" step="-1">
	  			<cfset arguments.StartDate = DateAdd('d',i,arguments.startdate) /> 
	  			<cfset local.qryStock = session.objects.DataDAO.Read(symbol:"SPY",date:arguments.startdate) />
	  			<cfif local.qryStock.recordcount EQ 1> <!--- market was open --->
					<cfset local.MarketFlag = true />		
					<cfbreak>
				</cfif>
			</cfloop>
		</cfif>
		<cfset local.MarketFlag = false>
		<!--- handle the end date --->
		<cfset local.qryStock = session.objects.DataDAO.Read(symbol:"SPY",date:arguments.enddate) />
		<cfif local.qryStock.recordcount EQ 1> <!--- market was open --->
			<cfset local.MarketFlag = true />		
		</cfif>
		<cfif local.MarketFlag EQ FALSE >
			<cfloop from="-1" to="-14" index="i" step="-1">
	  			<cfset arguments.EndDate = DateAdd('d',i,arguments.Enddate) /> 
	  			<cfset local.qryStock = session.objects.DataDAO.Read(symbol:"SPY",date:arguments.enddate) />
	  			<cfif local.qryStock.recordcount EQ 1> <!--- market was open --->
					<cfset local.MarketFlag = true />		
					<cfbreak>
				</cfif>
			</cfloop>
		</cfif>
		<cfset local.startdate = arguments.startdate />
		<cfset local.enddate = arguments.enddate />
		<cfreturn local />
	</cffunction>
	
	<cffunction name="GetRawData" description="I return a stock data query" access="public" displayname="GetRawStockData" output="false" returntype="Any">
		<cfargument name="Symbol" 		required="true"  />
		<cfargument name="startdate" 	required="false" default=#CreateDate(2012,1,1)# />
		<cfargument name="enddate" 		required="false" default=#now()# />
		<cfargument name="Source" required="false" default="Yahoo" />
		<cfset var local = structnew() />
		<cfset reset() />
		<!-- todo: seperate out returning the raw data as a query; open,high low close volume -->
		<cftry> 
		<cfset results = session.objects.http.getHTTPData(source:arguments.source, symbol:"#arguments.Symbol#",startdate:"#arguments.startdate#",enddate:"#arguments.enddate#") />
		<cfcatch>
			<cfoutput> HTTP request failed</cfoutput>
			<cfdump var="#arguments.symbol#">
			<cfdump var="#variables#">
			<cfdump var="#arguments#">
			<cfabort>
		</cfcatch>
		</cftry>
		
		<cfset local.results = results />
		<!--- <cfset local.txtdata = results.Filecontent.toString() />
		<cfset local.debugging.txtdata = local.txtdata />	
		<cfset local.qrydata = session.objects.Utility.CSVtoQuery(local.txtdata) /> --->
		<!---
		for Google: 
		strip headers from first row of query  
		rename query columns
		--->
		<!--- <cfset local.debugging.qryData = local.qryData />
		<cfset local.dateArray = ArrayNew(1) /> --->
		<!--- <cfset local.openArray = ArrayNew(1) />
		<cfset local.highArray = ArrayNew(1) />
		<cfset local.lowArray = ArrayNew(1) />
		<cfset local.closeArray = ArrayNew(1) />
		<cfset local.volumeArray = ArrayNew(1) />
		<cfset local.dummyArray = ArrayNew(1) /> --->
		
		<!--- <cfset local.GoogleData = QueryNew( "" ) /> --->
		<!--- <cfloop from="2" to="#local.qryData.recordcount#" index="i">
			<!--- <cfif local.qryData.column_6[i] NEQ 0> --->
			<cfset local.dateArray[i-1] = DateFormat(local.qryData.column_1[i], "yyyy-mm-dd") />
			<!--- <cfset local.openArray[i-1] = local.qryData.column_2[i] />
			<cfset local.highArray[i-1] = local.qryData.column_3[i] />
			<cfset local.lowArray[i-1] = local.qryData.column_4[i] />
			<cfset local.closeArray[i-1] = local.qryData.column_5[i] />
			<cfset local.volumeArray[i-1] = local.qryData.column_6[i] />
			</cfif> --->
		</cfloop>
		
		<cfset queryAddColumn(local.qryData,"DateOne",'VarChar',local.dateArray) >  --->
			 
		<!--- <cfset local.dummyArray[3] = "placeholder" />
		<cfset ArrayDeleteAt(local.dummyArray,3) />
		<cfset local.dateArray.removeAll(local.dummyArray) />
		<cfset local.openArray.removeAll(local.dummyArray) />
		<cfset local.highArray.removeAll(local.dummyArray) />
		<cfset local.lowArray.removeAll(local.dummyArray) />
		<cfset local.closeArray.removeAll(local.dummyArray) />
		<cfset local.volumeArray.removeAll(local.dummyArray) />
		
		<cfloop from="1" to="#local.dateArray.size()#" index="i">
			<cfif local.dateArray[i] EQ "">
				<cfset ArrayDeleteAt(local.dateArray,i) />
				<cfset ArrayDeleteAt(local.openArray,i) />
				<cfset ArrayDeleteAt(local.highArray,i) />
				<cfset ArrayDeleteAt(local.lowArray,i) />
				<cfset ArrayDeleteAt(local.closeArray,i) />
				<cfset ArrayDeleteAt(local.volumeArray,i) />
			</cfif>
		</cfloop> 
	
		<cfset queryAddColumn(local.GoogleData,"DateOne",'VarChar',local.dateArray) > 
		<cfset queryAddColumn(local.GoogleData,"Open",'VarChar',local.openArray) > 
		<cfset queryAddColumn(local.GoogleData,"High",'VarChar',local.highArray) > 
		<cfset queryAddColumn(local.GoogleData,"Low",'VarChar',local.lowArray) > 
		<cfset queryAddColumn(local.GoogleData,"Close",'VarChar',local.closeArray) > 
		<cfset queryAddColumn(local.GoogleData,"Volume",'VarChar',local.volumeArray) >  --->
		<cfreturn local.results />
		</cffunction>
		
	<cffunction name="GetStockData" description="I return a stock data bean" access="public" displayname="GetStockData" output="false" returntype="Any">
		<cfargument name="Symbol" 		required="true"  />
		<cfargument name="startdate" 	required="false" default=#CreateDate(2012,1,1)# />
		<cfargument name="enddate" 		required="false" default=#now()# />
		<cfset var local = structnew() />
		<cfset reset() />
		<cfset results = GetRawData(symbol:"#arguments.Symbol#",startdate:"#arguments.startdate#",enddate:"#arguments.enddate#") />
		
		<cfquery   dbtype="query"  name="resorted" >
			select * from results order by DateOne asc
		</cfquery>
		<!--- used to display chart  --->
		<cfquery   dbtype="query"  name="high1" >
			select max(high) AS high from results 
		</cfquery>
		<cfquery   dbtype="query"  name="low1" >
			select min(low) As low from results 
		</cfquery>
		<cfset variables.high = high1.high />
		<cfset variables.low = low1.low />	
		<!--- raw data  --->
		<cfset local.OrgData = resorted />
		<!--- HAData --->
		<cfset local.HKData = session.objects.TA.convertHK(qrydata:resorted) />
		<cfset local.symbolArray = ArrayNew(1) >
		<cfloop from="1" to="#local.HKData.recordcount#" index="i">
			<cfset local.symbolArray[i] = arguments.symbol>
		</cfloop>
		<cfset queryAddColumn(local.HKData,"Symbol",'VarChar',local.symbolArray) > 
		<cfset queryAddColumn(local.OrgData,"Symbol",'VarChar',local.symbolArray) > 
		<cfset variables.qryDataOriginal = GetTechnicalIndicators(query:local.OrgData)  />
		<cfset variables.qryDataHA = GetTechnicalIndicators(query:local.HKData)  />
		<cfset variables.OrgData = local.OrgData />
		<cfset variables.HKData  = local.HKData />
		<cfreturn variables />
	</cffunction>
		
	<cffunction name="GetTechnicalIndicators" description="I populate a query with technical data" access="public" displayname="GetTechnicalData" output="false" returntype="Any">
		<cfargument name="query" required="true" />
		<cfset local.num = session.objects.TA.GetIndicator(Indicator:"linearReg",qryPrices:arguments.query) />
		<cfset queryAddColumn(arguments.query,"linearReg",'Decimal',local.num) > 
		<cfset local.num = session.objects.TA.GetIndicator(Indicator:"linearReg",qryPrices:arguments.query,optInTimePeriod:10) />
		<cfset queryAddColumn(arguments.query,"linearReg10",'Decimal',local.num) > 
		<cfset local.num = session.objects.TA.GetIndicator(Indicator:"linearRegAngle",qryPrices:arguments.query) />
		<cfset queryAddColumn(arguments.query,"linearRegAngle",'Decimal',local.num) >
		<cfset local.num = session.objects.TA.GetIndicator(Indicator:"linearRegSlope",qryPrices:arguments.query) />
		<cfset queryAddColumn(arguments.query,"linearRegSlope",'Decimal',local.num) >
		<cfset local.num = session.objects.TA.GetIndicator(Indicator:"linearRegSlope",qryPrices:arguments.query,optInTimePeriod:10) />
		<cfset queryAddColumn(arguments.query,"linearRegSlope10",'Decimal',local.num) >
		<cfset local.num = session.objects.TA.GetIndicator(Indicator:"linearRegIntercept",qryPrices:arguments.query) />
		<cfset queryAddColumn(arguments.query,"linearRegIntercept",'Decimal',local.num) >
		<cfset local.LRSArray = session.objects.TA.LRSDelta(qryData:arguments.query) />
		<cfset queryAddColumn(arguments.query,"LRSdelta","Decimal", local.LRSarray) >
		<cfset local.num = session.objects.TA.GetIndicator(Indicator:"Momentum",qryPrices:arguments.query) />
		<cfset queryAddColumn(arguments.query,"Momentum",'Decimal',local.num) >
		
		<cfset local.FastSlope = session.objects.TA.Slope(qryPrices:arguments.query,length:5,value:"High") />
		<cfset queryAddColumn(arguments.query,"FastSlope",'Decimal',local.FastSlope) >
		
		<cfset local.SlowSlope = session.objects.TA.Slope(qryPrices:arguments.query,length:14,value:"High") />
		<cfset queryAddColumn(arguments.query,"SlowSlope",'Decimal',local.SlowSlope) >
		
		<cfset local.num = session.objects.TA.GetIndicator(Indicator:"RSI",qryPrices:arguments.query) />
		<cfset queryAddColumn(arguments.query,"RSI",'Decimal',local.num) >
		<cfset local.num = session.objects.TA.GetIndicator(Indicator:"ADX",qryPrices:arguments.query) />
		<cfset queryAddColumn(arguments.query,"ADX",'Decimal',local.num) >
		<cfset local.num = session.objects.TA.GetIndicator(Indicator:"CCI",qryPrices:arguments.query) />
		<cfset queryAddColumn(arguments.query,"CCI",'Decimal',local.num) >
		
		<cfset local.num = session.objects.TA.GetIndicator(Indicator:"CCI",qryPrices:arguments.query,optInTimePeriod:5) />
		<cfset queryAddColumn(arguments.query,"CCI5",'Decimal',local.num) >
		
		<cfset local.Pivots = session.objects.TA.PivotPoints(qryData:arguments.query) />
		<cfset queryAddColumn(arguments.query,"PP",'Decimal',local.pivots.pp) >
		<cfset queryAddColumn(arguments.query,"R1",'Decimal',local.pivots.r1) >
		<cfset queryAddColumn(arguments.query,"R2",'Decimal',local.pivots.r2) >
		<cfset queryAddColumn(arguments.query,"S1",'Decimal',local.pivots.s1) >
		<cfset queryAddColumn(arguments.query,"S2",'Decimal',local.pivots.s2) >
		<cfset local.PivotBreak = session.objects.TA.PivotBreak(qryData:arguments.query) />
		<cfset queryAddColumn(arguments.query,"R1Break",'Decimal',local.PivotBreak.r1break) >
		<cfset queryAddColumn(arguments.query,"R2Break",'Decimal',local.PivotBreak.r2break) >
		<cfset queryAddColumn(arguments.query,"S1Break",'Decimal',local.PivotBreak.s1break) >
		<cfset queryAddColumn(arguments.query,"S2Break",'Decimal',local.PivotBreak.s2break) >
		<cfset local.LocalHighLows = session.objects.TA.LocalHighLow(qryData:arguments.query) />
		<cfset queryAddColumn(arguments.query,"LocalHigh","VarChar",local.LocalHighLows.LocalHighs) />
		<cfset queryAddColumn(arguments.query,"LocalLow","VarChar",local.LocalHighLows.LocalLows) />
		<cfset queryAddColumn(arguments.query,"LocalHighValue","VarChar",local.LocalHighLows.LocalHighValue) />
		<cfset queryAddColumn(arguments.query,"LocalLowValue","VarChar",local.LocalHighLows.LocalLowValue) />
		<!--- Candles  --->
		<cfset local.num = session.objects.TA.GetCandle(Candle:"Hammer",qryPrices:arguments.query) />
		<cfset queryAddColumn(arguments.query,"Hammer",'Decimal',local.num.outdata) > 
		<cfset local.num = session.objects.TA.GetCandle(Candle:"HangingMan",qryPrices:arguments.query) />
		<cfset queryAddColumn(arguments.query,"HangingMan",'Decimal',local.num.outdata) > 
		<cfset local.num = session.objects.TA.GetCandle(Candle:"3Inside",qryPrices:arguments.query) />
		<cfset queryAddColumn(arguments.query,"ThreeInside",'Decimal',local.num.outdata) > 
		<cfset local.num = session.objects.TA.GetCandle(Candle:"3Outside",qryPrices:arguments.query) />
		<cfset queryAddColumn(arguments.query,"ThreeOutside",'Decimal',local.num.outdata) > 
		<cfset local.num = session.objects.TA.GetCandle(Candle:"3BlackCrows",qryPrices:arguments.query) />
		<cfset queryAddColumn(arguments.query,"ThreeBlackCrows",'Decimal',local.num.outdata) >
		<cfset local.num = session.objects.TA.GetCandle(Candle:"Harami",qryPrices:arguments.query) />
		<cfset queryAddColumn(arguments.query,"Harami",'Decimal',local.num.outdata) />
		<cfset local.num = session.objects.TA.GetCandle(Candle:"HaramiCross",qryPrices:arguments.query) />
		<cfset queryAddColumn(arguments.query,"HaramiCross",'Decimal',local.num.outdata) > 
		<cfset local.num = session.objects.TA.GetCandle(Candle:"LongLine",qryPrices:arguments.query) />
		<cfset queryAddColumn(arguments.query,"LongLine",'Decimal',local.num.outdata) > 
		<cfreturn arguments.query />	
	</cffunction>

	<cffunction name="GetOriginalStockData" description="" access="public" displayname="" output="false" returntype="Any">
	<cfreturn variables.qryDataOriginal />
	</cffunction>
	
	<cffunction name="GetHAStockData" description="" access="public" displayname="" output="false" returntype="Any">
	<cfreturn variables.qryDataHA />
	</cffunction>
	
	<cffunction name="GetHigh" description="" access="public" displayname="" output="false" returntype="Any">
	<cfreturn variables.high />
	</cffunction>
	
	<cffunction name="GetLow" description="" access="public" displayname="" output="false" returntype="Any">
	<cfreturn variables.low />
	</cffunction>
		
	<cffunction name="GetHAStockDataGoogle" description="I return a HA data" access="public" displayname="" output="false" returntype="Any" >
		<cfargument name="symbol" required="true" />
		<cfargument name="startdate" required="false"  default="1/1/2012" />
		<cfargument name="enddate" required="false" default="#dateformat(now(),"mm/dd/yyyy")#" />
		<cfscript>
		// todo: I stopped here
		local.data = session.objects.DataService.GetStockDataGoogle(symbol:"#arguments.symbol#",startdate:"#arguments.startdate#",enddate:"#arguments.enddate#"); 
		local.HAData = session.objects.DataService.GetHAStockData();
		return local.HAData;
		</cfscript>
	</cffunction>

	<cffunction name="CheckRecordsExist" description="I see if records for the stock exist in the Amazon data store" access="public" displayname="" output="false" returntype="Any" >
		<cfargument name="symbol" required="true" />
		<cfset var local = StructNew() />
		<cfset local.records = false />
		<!--- See if records exist  --->
		<cfquery name="qryCheckRecords"  datasource="#application.amazon#" >
		SELECT DATEONE FROM StockData where SYMBOL = '#arguments.symbol#'
		</cfquery>
		<cfif qryCheckRecords.recordcount>
		<cfset local.records = true />
		</cfif>
		<cfreturn local.records />
	</cffunction>

	<cffunction name="GetCurrentRecord" description="I see if records are updated in the Amazon data store" access="public" displayname="" output="false" returntype="Any" >
		<cfargument name="symbol" required="true" />
		<cfset var local = StructNew() />
		<cfset local.LatestDate = CreateDate(2000,1,1) />
		<cfquery name="qryCheckRecordDates"  datasource="#application.amazon#" >
		SELECT MAX(DateOne) LatestDate FROM StockData where SYMBOL = '#arguments.symbol#'
		</cfquery>
		<cfif qryCheckRecordDates.LatestDate NEQ "">
			<cfset local.LatestDate = qryCheckRecordDates.LatestDate />
		</cfif> 
		<cfreturn local.LatestDate />
	</cffunction>	
	
	<cffunction name="CheckRecordDates" description="I see if records are updated in the Amazon data store" access="public" displayname="" output="false" returntype="Any" >
		<cfargument name="symbol" required="true" />
		<cfset var local = StructNew() />
		<cfset local.recordsUpdated = false />
		<!--- See if records are up to date --->
		<cfset local.currentRecordDate = GetCurrentRecord(symbol: arguments.symbol) />
		<cfset local.SPYRecordDate = GetCurrentRecord(symbol: 'SPY') />
		<cfif local.currentRecordDate EQ  local.SPYRecordDate >
			<cfset local.recordsUpdated = true />
		</cfif>
		<cfreturn local.recordsUpdated />
	</cffunction>	

	<cffunction name="Records" description="I see if records for the stock exist in the Amazon data store" access="public" displayname="" output="false" returntype="Any" >
		<cfargument name="symbol" required="true" />
		<cfargument name="startdate" required="false"  default="1/1/2012" />
		<cfargument name="enddate" required="false" default="#dateformat(now(),"mm/dd/yyyy")#" />
		<cfset var local = StructNew() />
		<cfset local.records 		= false />
		<cfset local.CurrentRecords = false />
		<!--- See if records exist  --->
		<cfset local.Records = CheckRecordsExist(symbol:arguments.symbol) >
		<cfif local.Records >
			<cfset local.CurrentRecords = CheckRecordDates(symbol:arguments.symbol) />
		</cfif>
		<cfif NOT local.records>
			<cfset UpdateRecords(action:"Create",symbol:arguments.symbol) />
		</cfif>
		<cfif NOT local.records OR NOT local.CurrentRecords>
			<cfset UpdateRecords(action:"Update",symbol:arguments.symbol,startdate:arguments.startdate,enddate:arguments.enddate) />
		</cfif>
		<cfreturn />
	</cffunction>
	
	<cffunction name="UpdateRecords" description="I see if records for the stock exist in the Amazon data store" access="public" displayname="" output="false" returntype="Any" >
		<cfargument name="symbol" required="true" />
		<cfargument name="startdate" required="false"  default="1/1/2012" />
		<cfargument name="enddate" required="false" default="#dateformat(now(),"mm/dd/yyyy")#" />
		<cfargument name="action" required="true" />
		<cfset var local = StructNew() />
		<cfset local.records 		= false />
		<cfset local.CurrentRecords = false />
		<!--- See if records exist  --->
		<cfswitch expression="#arguments.action#">
		<cfcase  value="Create">
			<cfset local.Data = GetStockData(symbol:arguments.symbol,startdate:arguments.startdate,enddate:arguments.enddate) >
			<cfset InsertRecords(query:local.data.qryDataOriginal) >		
		</cfcase>
		<cfcase  value="Update">
			<!--- get most recent record in table --->
			<cfset local.LastDate = GetCurrentRecord(symbol: arguments.symbol) />
			<cfset local.Data = GetStockData(symbol:arguments.symbol,startdate:local.LastDate,enddate:arguments.enddate) >
			<cfset InsertRecords(query:local.data.qryDataOriginal) >		
		</cfcase>		
		</cfswitch>
		<cfset local.Records = CheckRecordsExist(symbol:arguments.symbol) >
		<cfif local.Records >
			<cfset local.CurrentRecords = CheckRecordDates(symbol:arguments.symbol) />
		</cfif>
		<cfif NOT local.records>
			<cfset UpdateRecords(action:"Create",symbol:arguments.symbol) />
		</cfif>
		<cfif NOT local.records OR NOT local.CurrentRecords>
			<cfset UpdateRecords(action:"Update",symbol:arguments.symbol,startdate:arguments.startdate,enddate:arguments.enddate) />
		</cfif>
		<cfreturn />
	</cffunction>
</cfcomponent>