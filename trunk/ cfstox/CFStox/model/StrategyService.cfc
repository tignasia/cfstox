<cfcomponent output="false">

<cffunction name="Init" description="" access="public" displayname="" output="false" returntype="StrategyService">
	<cfreturn this />
</cffunction>

<cffunction name="Analyse" description="" access="public" displayname="" output="false" returntype="array">
	<cfscript>
	var local = StructNew();
	// array to hold the report structures, one structure per day
	local.ReportArray 		= ArrayNew(1);
	local.qryDataOriginal 	= session.objects.DataStorage.GetData(DataSet:"qryDataOriginal") ;
	local.qryDataHA 		= session.objects.DataStorage.GetData(DataSet:"qryDataHA") ;
	local.RecordCount 		= local.qryDataOriginal.recordCount ;
	local.arguments.qryDataOriginal = local.qryDataOriginal;
	local.arguments.qryDataHA 		= local.qryDataHA;
	for (local.i = 1; local.i lte local.recordcount; local.i = local.i + 1) 
	{
	local.arguments.dayStruct 	= StructNew();
	local.arguments.dayStruct.Date	= local.qryDataOriginal['DateOne'][local.i];;
	local.arguments.Counter 	= local.i;
	local.arguments.Indicator 	= "CandlePattern";
	CandlePattern(argumentcollection:local.arguments);
	CCI(argumentcollection:local.arguments);	 	 
	local.reportArray[local.i] 	= local.arguments.DayStruct;
	}
	return local.ReportArray;
	</cfscript>
</cffunction>

<cffunction name="CandlePattern" description="" access="private" displayname="" output="false" returntype="void">
<!--- 
<cfset local.dspHeaders = "Engulfing,Hammer,HangingMan,ThreeInside,ThreeOutside,ThreeBlackCrows,Harami,HaramiCross,LongLine">
<cfset local.headers = "Engulfing,Hammer,HangingMan,ThreeInside,ThreeOutside,ThreeBlackCrows,Harami,HaramiCross,LongLine">
 --->
<cfscript>
	local.LowCandleList = "Engulfing,Hammer,HangingMan,ThreeInside,ThreeOutside,ThreeBlackCrows,Harami,HaramiCross,LongLine" ;
	local.MediumCandleList = "Engulfing,Hammer,HangingMan,ThreeInside,ThreeOutside,ThreeBlackCrows,Harami,HaramiCross,LongLine" ;
	local.HighCandleList = "Engulfing,Hammer,HangingMan,ThreeInside,ThreeOutside,ThreeBlackCrows,Harami,HaramiCross,LongLine" ;
	
	arguments.dayStruct["#arguments.indicator#"] = StructNew();
	arguments.dayStruct["#arguments.indicator#"].value = "";
	arguments.dayStruct["#arguments.indicator#"].comment = "";
	local.candlelen = listlen(local.candleList);
	for(i=1;i<=local.candlelen;i++){
		local.CandleName = listGetAt(local.CandleList,i);
		if(arguments.qryDataOriginal[#local.CandleName#][arguments.Counter] EQ 100) {
		arguments.dayStruct["#arguments.indicator#"].value = "Bullish #local.candleName# ";
		arguments.dayStruct["#arguments.indicator#"].comment = "Strong Bullish Candle";		
		}	
		if(arguments.qryDataOriginal[#local.CandleName#][arguments.Counter] EQ -100) {
			arguments.dayStruct["#arguments.indicator#"].value = "Bearish #local.CandleName# ";
			arguments.dayStruct["#arguments.indicator#"].comment = "Strong Bearish Candle";		
		}
	}
	return;
	</cfscript>
</cffunction>

<cffunction name="CCI" description="" access="private" displayname="" output="false" returntype="void">
	<cfscript>
	arguments.dayStruct["CCI"] = StructNew();
	arguments.dayStruct["CCI"].value = "";
	arguments.dayStruct["CCI"].comment = "";
	 
	if(arguments.counter > 20 ) {
		arguments.dayStruct["CCI"].value = "#arguments.qryDataOriginal.CCI[arguments.Counter]#" ;
		if(arguments.qryDataOriginal.CCI[arguments.Counter] GT arguments.qryDataOriginal.CCI[arguments.Counter-1]) {
		arguments.dayStruct["CCI"].comment = "CCI value is rising" ;
		}
		if(arguments.qryDataOriginal.CCI[arguments.Counter] LT arguments.qryDataOriginal.CCI[arguments.Counter-1]) {
		arguments.dayStruct["CCI"].comment = "CCI value is falling" ;	
		}
	}
	/* if(arguments.qryDataOriginal.CCI[arguments.Counter] LTE 30) {
	arguments.dayStruct["CCI"].value = "CCI below 30" ;
	arguments.dayStruct["CCI"].comment = "CCI is bearish" ;		
	}
	if(arguments.qryDataOriginal.CCI[arguments.Counter] GTE 70) {
		arguments.dayStruct["CCI"].value = "CCI above 70";
		arguments.dayStruct["CCI"].comment = "CCI is Bullish";
	} */
	return;
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

</cfcomponent>