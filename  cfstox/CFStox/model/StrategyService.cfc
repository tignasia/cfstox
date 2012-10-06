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
	local.reportArray[local.i] 	= local.arguments.DayStruct;
	}
	return local.ReportArray;
	</cfscript>
</cffunction>

<cffunction name="CandlePattern" description="" access="private" displayname="" output="false" returntype="void">
<!--- 
<cfset local.dspHeaders = "SYM,DATE,OPEN,HIGH,LOW,CLOSE,VOL,Engulfing,Hammer,HangingMan,ThreeInside,ThreeOutside,ThreeBlackCrows,Harami,HaramiCross,LongLine">
<cfset local.headers = "SYMBOL,DATEONE,OPEN,HIGH,LOW,CLOSE,VOLUME,Engulfing,Hammer,HangingMan,ThreeInside,ThreeOutside,ThreeBlackCrows,Harami,HaramiCross,LongLine">
 --->
	<cfset arguments.dayStruct["#arguments.indicator#"] = StructNew() />
	<cfif arguments.qryDataOriginal.Engulfing[arguments.Counter] EQ 100>
		<cfset arguments.dayStruct["#arguments.indicator#"].value = "Bullish Engulfing ">
		<cfset arguments.dayStruct["#arguments.indicator#"].comment = "Strong Bullish Candle">		
	</cfif>
	<cfif arguments.qryDataOriginal.Engulfing[arguments.Counter] EQ -100>
		<cfset arguments.dayStruct["#arguments.indicator#"].value = "Bearish Engulfing ">
		<cfset arguments.dayStruct["#arguments.indicator#"].comment = "Strong Bearish Candle">		
	</cfif>
	<cfreturn />
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