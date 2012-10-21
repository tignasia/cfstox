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
	local.arguments.dayStruct 		= StructNew();
	local.arguments.dayStruct.Date	= local.qryDataOriginal['DateOne'][local.i];;
	local.arguments.Counter 		= local.i;
	OHLC(argumentcollection:local.arguments);
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
	local.candles = ArrayNew(2); 
	//local.LowCandleBullList 		= "BeltHold,Hammer,InvertedHammer,Harami" ;
	//local.MediumCandleBullList 	= "DragonflyDoji,LongLeggedDoji,Engulfing,GravestoneDoji,DojiStar,HaramiCross,HomingPigeon,MatchingLow,StickSandwich,ThreeStarsInSouth,TriStar,Unique3River,Breakaway,LadderBottom" ;
	//local.HighCandleBullList 		= "Piercing,Kicking,AbandonedBaby,MorningDojiStar,MorningStar,ThreeInside,ThreeOutside,ThreeWhiteSoldiers,ConcealBabySwallow" ;
	
	local.candles[1][1]	= "RisingThreeMethods,UpsideGap3Methods,TasukiGap,ThreeLineStrike,LongLine,Marubozu,ClosingMarubozu" ;
	local.candles[1][2] = "Unknown Reliablity";
	local.candles[2][1]	= "DarkCloudCover,EveningStar,EveningDojiStar,ThreeBlackCrows,UpsideGap2Crows,HaramiCross,AdvanceBlock,TwoCrows,HangingMan,ShootingStar,InNeck,OnNeck,Thrusting" ;
	local.candles[2][2] = "Unknown Reliablity";
	local.candles[3][1]	= "CounterAttack,Doji,GapSideSideWhite,HighWave,Hikkake,Identical3Crows,RickshawMan,ShortLine,SpinningTop,StalledPattern,Takuri" ;
	local.candles[3][2] = "Unknown Reliablity";
	local.candles[4][1]	= "BeltHold,Hammer,InvertedHammer,Harami,ThreeLineStrike,LongLine,SeperatingLines" ;
	local.candles[4][2] = "Low Reliablity";
	local.candles[5][1]	= "DragonflyDoji,LongLeggedDoji,Engulfing,GravestoneDoji,DojiStar,HaramiCross,HomingPigeon,MatchingLow,StickSandwich,ThreeStarsInSouth,TriStar,Unique3River,Breakaway,LadderBottom" ;
	local.candles[5][2] = "Medium Reliablity";
	local.candles[6][1]	= "MatHold,Piercing,Kicking,AbandonedBaby,MorningDojiStar,MorningStar,ThreeInside,ThreeOutside,ThreeWhiteSoldiers,ConcealBabySwallow" ;
	local.candles[6][2] = "High Reliablity";
	
	arguments.dayStruct["CandlePattern"] = StructNew();
	arguments.dayStruct["CandlePattern"].value = "";
	arguments.dayStruct["CandlePattern"].comment = "";
	for(h=1;h<=6;h++){
		local.candlelen = listlen(local.Candles[h][1]);
		for(i=1;i<=local.candlelen;i++){
			local.CandleName = listGetAt(local.Candles[h][1],i);
			if(arguments.qryDataOriginal[#local.CandleName#][arguments.Counter] EQ 100) {
			arguments.dayStruct["CandlePattern"].value = arguments.dayStruct["CandlePattern"].value & " | " & "Bullish #local.candleName# ";
			arguments.dayStruct["CandlePattern"].comment = arguments.dayStruct["CandlePattern"].comment & " " & "#local.Candles[h][2]#";		
			}	
			if(arguments.qryDataOriginal[#local.CandleName#][arguments.Counter] EQ -100) {
			arguments.dayStruct["CandlePattern"].value = arguments.dayStruct["CandlePattern"].value & " | " & "Bearish #local.CandleName# ";
			arguments.dayStruct["CandlePattern"].comment = arguments.dayStruct["CandlePattern"].comment & " " &  "#local.Candles[h][2]#";	
			}
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

<cffunction name="OHLC" description="" access="private" displayname="" output="false" returntype="void">
<cfargument name="counter" required="true" />
<!--- 
<cfset local.dspHeaders = "Engulfing,Hammer,HangingMan,ThreeInside,ThreeOutside,ThreeBlackCrows,Harami,HaramiCross,LongLine">
<cfset local.headers = "Engulfing,Hammer,HangingMan,ThreeInside,ThreeOutside,ThreeBlackCrows,Harami,HaramiCross,LongLine">
 --->
<cfscript>
	arguments.dayStruct.Open 	= arguments.qryDataOriginal.Open[arguments.Counter];
	arguments.dayStruct.High 	= arguments.qryDataOriginal.High[arguments.Counter];
	arguments.dayStruct.Low 	= arguments.qryDataOriginal.Low[arguments.Counter];
	arguments.dayStruct.Close 	= arguments.qryDataOriginal.Close[arguments.Counter];
	arguments.dayStruct.Volume	= arguments.qryDataOriginal.Volume[arguments.Counter];
	arguments.dayStruct.Change	= "";
	arguments.dayStruct.VolumeChange	= "";
	if(arguments.counter > 1 ) {
	arguments.dayStruct.Change			= arguments.qryDataOriginal.Close[arguments.Counter] - arguments.qryDataOriginal.Close[arguments.Counter-1];
	arguments.dayStruct.VolumeChange	= arguments.qryDataOriginal.Volume[arguments.Counter] - arguments.qryDataOriginal.Volume[arguments.Counter-1];
	}
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