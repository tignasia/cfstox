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
	local.arguments.dayStruct 			= StructNew();
	local.arguments.dayStruct.Date		= local.qryDataOriginal['DateOne'][local.i];;
	local.arguments.dayStruct.BuyFlag 	= false;
	local.arguments.dayStruct.SellFlag 	= false;
	local.arguments.Counter 			= local.i;
	OHLC(argumentcollection:local.arguments);
	local.arguments.CandleType = "CandlePattern";
	CandlePattern(argumentcollection:local.arguments);
	local.arguments.CandleType = "HACandlePattern";
	CandlePattern(argumentcollection:local.arguments);
	CCI(argumentcollection:local.arguments);
	AroonOsc(argumentcollection:local.arguments);
	CheckPivots(argumentcollection:local.arguments);	 	 
	ZigZag(argumentcollection:local.arguments);
	CalcZigZag(argumentcollection:local.arguments);
	HAChange(argumentcollection:local.arguments);	 	 
	local.reportArray[local.i] 	= local.arguments.DayStruct;
		if (local.i GT 1){
		CheckIndicators(daystructs:local.reportArray,counter:local.i);
		}
	}
	return local.ReportArray;
	</cfscript>
</cffunction>

<cffunction name="CandlePattern" description="" access="private" displayname="" output="false" returntype="void">
<cfargument name="CandleType" required="true" />
<!--- 
<cfset local.dspHeaders = "Engulfing,Hammer,HangingMan,ThreeInside,ThreeOutside,ThreeBlackCrows,Harami,HaramiCross,LongLine">
<cfset local.headers = "Engulfing,Hammer,HangingMan,ThreeInside,ThreeOutside,ThreeBlackCrows,Harami,HaramiCross,LongLine">
 --->
<cfscript>
	local.candles = ArrayNew(2); 
	//local.LowCandleBullList 		= "BeltHold,Hammer,InvertedHammer,Harami" ;
	//local.MediumCandleBullList 	= "DragonflyDoji,LongLeggedDoji,Engulfing,GravestoneDoji,DojiStar,HaramiCross,HomingPigeon,MatchingLow,StickSandwich,ThreeStarsInSouth,TriStar,Unique3River,Breakaway,LadderBottom" ;
	//local.HighCandleBullList 		= "Piercing,Kicking,AbandonedBaby,MorningDojiStar,MorningStar,ThreeInside,ThreeOutside,ThreeWhiteSoldiers,ConcealBabySwallow" ;
	// CandlePattern, HACandlePattern
	local.candles[1][1]	= "RisingThreeMethods,UpsideGap3Methods,TasukiGap,ThreeLineStrike,LongLine,Marubozu,ClosingMarubozu" ;
	local.candles[1][2] = "Unknown Reliablity";
	local.candles[2][1]	= "EveningStar,EveningDojiStar,ThreeBlackCrows,UpsideGap2Crows,AdvanceBlock,TwoCrows,HangingMan,ShootingStar,InNeck,OnNeck,Thrusting" ;
	local.candles[2][2] = "Unknown Reliablity";
	local.candles[3][1]	= "CounterAttack,Doji,GapSideSideWhite,HighWave,Hikkake,Identical3Crows,RickshawMan,ShortLine,SpinningTop,StalledPattern,Takuri" ;
	local.candles[3][2] = "Unknown Reliablity";
	local.candles[4][1]	= "BeltHold,Hammer,InvertedHammer,Harami,ThreeLineStrike,LongLine,SeperatingLines" ;
	local.candles[4][2] = "Low Reliablity";
	local.candles[5][1]	= "DragonflyDoji,LongLeggedDoji,Engulfing,GravestoneDoji,DojiStar,HaramiCross,HomingPigeon,MatchingLow,StickSandwich,ThreeStarsInSouth,TriStar,Unique3River,Breakaway,LadderBottom" ;
	local.candles[5][2] = "Medium Reliablity";
	local.candles[6][1]	= "DarkCloudCover,MatHold,Piercing,Kicking,AbandonedBaby,MorningDojiStar,MorningStar,ThreeInside,ThreeOutside,ThreeWhiteSoldiers,ConcealBabySwallow" ;
	local.candles[6][2] = "High Reliablity";
	
	if(arguments.CandleType EQ "CandlePattern")
	{ local.CandleData = arguments.qryDataOriginal; }
	
	if(arguments.CandleType EQ "HACandlePattern")
	{ local.CandleData = arguments.qryDataHA; }
	
	local.Ctype = arguments.CandleType;
	
	arguments.dayStruct["#local.Ctype#"] = StructNew();
	arguments.dayStruct["#local.Ctype#"].value 		= "";
	arguments.dayStruct["#local.Ctype#"].comment 	= "";
	arguments.dayStruct["#local.Ctype#"].BearFlag  	= false;
	arguments.dayStruct["#local.Ctype#"].BullFlag  	= false;
	for(h=1;h<=6;h++){
		local.candlelen = listlen(local.Candles[h][1]);
		for(i=1;i<=local.candlelen;i++){
			local.CandleName = listGetAt(local.Candles[h][1],i);
			
			if(local.CandleData[#local.CandleName#][arguments.Counter] EQ 100) {
			arguments.dayStruct["#local.Ctype#"].value = arguments.dayStruct["#local.Ctype#"].value & " | " & "Bullish #local.candleName# ";
			arguments.dayStruct["#local.Ctype#"].comment = arguments.dayStruct["#local.Ctype#"].comment & " " & "#local.Candles[h][2]#";		
			if(h EQ 5 OR h EQ 6)
			{arguments.dayStruct["#local.Ctype#"].BullFlag = true;}
			}
			
			if(local.CandleData[#local.CandleName#][arguments.Counter] EQ -100) {
			arguments.dayStruct["#local.Ctype#"].value = arguments.dayStruct["#local.Ctype#"].value & " | " & "Bearish #local.CandleName# ";
			arguments.dayStruct["#local.Ctype#"].comment = arguments.dayStruct["#local.Ctype#"].comment & " " &  "#local.Candles[h][2]#";	
				if(h EQ 5 OR h EQ 6)
				{arguments.dayStruct["#local.Ctype#"].BearFlag = true;}
			}
		}
	}
	return;
	</cfscript>
</cffunction>

<cffunction name="CCI" description="" access="private" displayname="" output="false" returntype="void">
	<cfscript>
	arguments.dayStruct["CCI"] = StructNew();
	arguments.dayStruct["CCI"].value = "0.0";
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
	
	if(arguments.qryDataOriginal.CCI[arguments.Counter] GTE 100) {
	arguments.dayStruct["CCI"].comment = arguments.dayStruct["CCI"].comment & " - CCI is overbought";		
	}
	if(arguments.qryDataOriginal.CCI[arguments.Counter] LTE -100) {
	arguments.dayStruct["CCI"].comment = arguments.dayStruct["CCI"].comment & " - CCI is oversold";
	} 
	return;
	</cfscript>
</cffunction>

<cffunction name="ZigZag" description="" access="private" displayname="" output="false" returntype="void">
	<cfscript>
	arguments.dayStruct["ZigZag"] = StructNew();
	arguments.dayStruct["ZigZag"].value = "";
	arguments.dayStruct["ZigZag"].comment = "";
	arguments.dayStruct["ZigZag"].BearFlag  	= false;
	arguments.dayStruct["ZigZag"].BullFlag  	= false;
	 
	if(arguments.counter > 3 ) {
		if(arguments.qryDataOriginal.LocalHigh[arguments.Counter-1] ) {
		arguments.dayStruct["ZigZag"].value = "Prev Local Low = " &  arguments.qryDataOriginal.LocalLowValue[arguments.Counter];
		arguments.dayStruct["ZigZag"].comment = "Yesterday was local high" ;
		arguments.dayStruct["ZigZag"].BearFlag  	= true;
		}
		if(arguments.qryDataOriginal.LocalLow[arguments.Counter-1])  {
		arguments.dayStruct["ZigZag"].value = "Prev Local High = " &  arguments.qryDataOriginal.LocalHighValue[arguments.Counter];
		arguments.dayStruct["ZigZag"].comment = "Yesterday was local high" ;
		arguments.dayStruct["ZigZag"].BullFlag  	= true;	
		}
	}
	return;
	</cfscript>
</cffunction>

<cffunction name="CalcZigZag" description="" access="private" displayname="" output="false" returntype="void">
	<!--- 
	Count back to see how many day ago was the previous high/low (true/false)
	get the % of stock price of the change 
	 --->
	<cfscript>
	var local = structNew();
	arguments.dayStruct["ZigZagLen"] = StructNew();
	arguments.dayStruct["ZigZagLen"].Duration 	= 0;
	arguments.dayStruct["ZigZagLen"].Value 		= 0;
	arguments.dayStruct["ZigZagLen"].Percent 	= 0;
	
	local.prevFlag 	= true; 
	local.PrevHighRN 	= arguments.qryDataOriginal.PrevHighRecNo[arguments.Counter-1];
	local.PrevLowRN 	= arguments.qryDataOriginal.PrevLowRecNo[arguments.Counter-1];
	if(arguments.counter > 20 ) {
		if(arguments.qryDataOriginal.LocalHigh[arguments.Counter-1] ) 
		{
		arguments.dayStruct["ZigZagLen"].Duration 	= arguments.counter - local.PrevLowRN;		
		arguments.dayStruct["ZigZagLen"].Value 		= arguments.qryDataOriginal.High[arguments.Counter-1] - arguments.qryDataOriginal.Low[local.PrevLowRN];
		arguments.dayStruct["ZigZagLen"].Percent 	= (arguments.qryDataOriginal.High[arguments.Counter-1] - arguments.qryDataOriginal.Low[local.PrevLowRN] )/arguments.qryDataOriginal.close[local.PrevLowRN];
		}
				
		if(arguments.qryDataOriginal.LocalLow[arguments.Counter-1])  
		{arguments.dayStruct["ZigZagLen"].Duration 	= arguments.counter - local.PrevHighRN;		
		arguments.dayStruct["ZigZagLen"].Value 		= arguments.qryDataOriginal.High[local.PrevHighRN] - arguments.qryDataOriginal.Low[arguments.Counter-1];
		arguments.dayStruct["ZigZagLen"].Percent 	= (arguments.qryDataOriginal.High[local.PrevHighRN] - arguments.qryDataOriginal.Low[arguments.Counter-1] )/arguments.qryDataOriginal.close[local.PrevHighRN];
		}
	}
	return;
	</cfscript>
</cffunction>

<cffunction name="HAChange" description="" access="private" displayname="" output="false" returntype="void">
	<cfscript>
	arguments.dayStruct["HAChange"] = StructNew();
	arguments.dayStruct["HAChange"].comment = "";
	arguments.dayStruct["HAChange"].BearFlag  	= false;
	arguments.dayStruct["HAChange"].BullFlag  	= false;
	 //todo: check for hollow red / solid green
	if(arguments.counter > 3 ) {
		if(arguments.qryDataHA.close[arguments.Counter-1] > arguments.qryDataHA.Open[arguments.Counter-1] 
		AND arguments.qryDataHA.close[arguments.Counter] < arguments.qryDataHA.open[arguments.Counter]) {
		arguments.dayStruct["HAChange"].comment = "HA Candle Bearish change - turned black - down" ;
		arguments.dayStruct["HAChange"].BearFlag  	= true;
		}
		if(arguments.qryDataHA.close[arguments.Counter-1] < arguments.qryDataHA.Open[arguments.Counter-1] 
		AND arguments.qryDataHA.close[arguments.Counter] > arguments.qryDataHA.open[arguments.Counter]) {
		arguments.dayStruct["HAChange"].comment = "HA Candle Bullish change - turned white - up"  ;
		arguments.dayStruct["HAChange"].BullFlag  	= true;	
		}
	}
	return;
	</cfscript>
</cffunction>

<cffunction name="AroonOsc" description="" access="private" displayname="" output="false" returntype="void">
	<cfscript>
	arguments.dayStruct["AroonOsc"] = StructNew();
	arguments.dayStruct["AroonOsc"].value = "";
	arguments.dayStruct["AroonOsc"].comment = "";
	 
	if(arguments.counter > 5 ) {
		arguments.dayStruct["AroonOsc"].value = "#arguments.qryDataOriginal.AroonOsc5[arguments.Counter]#" ;
		if(arguments.qryDataOriginal.AroonOsc5[arguments.Counter] GT arguments.qryDataOriginal.AroonOsc5[arguments.Counter-1]) {
		arguments.dayStruct["AroonOsc"].comment = "AroonOsc value is rising" ;
		}
		if(arguments.qryDataOriginal.AroonOsc5[arguments.Counter] LT arguments.qryDataOriginal.AroonOsc5[arguments.Counter-1]) {
		arguments.dayStruct["AroonOsc"].comment = "AroonOsc value is falling" ;	
		}
	}
	return;
	</cfscript>
</cffunction>

<cffunction name="CheckPivots" description="" access="private" displayname="" output="false" returntype="void">
	<cfscript>
	arguments.dayStruct["Pivots"] = StructNew();
	arguments.dayStruct["Pivots"].S1Break = false;
	arguments.dayStruct["Pivots"].S2Break = false;
	arguments.dayStruct["Pivots"].R1Break = false;
	arguments.dayStruct["Pivots"].R2Break = false;
	arguments.dayStruct["Pivots"].HAS1Break = false;
	arguments.dayStruct["Pivots"].HAS2Break = false;
	arguments.dayStruct["Pivots"].HAR1Break = false;
	arguments.dayStruct["Pivots"].HAR2Break = false;  
	if(arguments.counter > 1 ) {
		if(arguments.qryDataOriginal.S1Break[arguments.Counter])  {
		arguments.dayStruct["Pivots"].S1Break = true ;
		}
		if(arguments.qryDataOriginal.S2Break[arguments.Counter])  {
		arguments.dayStruct["Pivots"].S2Break = true ;
		}
		if(arguments.qryDataOriginal.R1Break[arguments.Counter])  {
		arguments.dayStruct["Pivots"].R1Break = true ;
		}
		if(arguments.qryDataOriginal.R2Break[arguments.Counter])  {
		arguments.dayStruct["Pivots"].R2Break = true ;
		}
		// HK 
		if(arguments.qryDataHA.S1Break[arguments.Counter])  {
		arguments.dayStruct["Pivots"].HAS1Break = true ;
		}
		if(arguments.qryDataHA.S2Break[arguments.Counter])  {
		arguments.dayStruct["Pivots"].HAS2Break = true ;
		}
		if(arguments.qryDataHA.R1Break[arguments.Counter])  {
		arguments.dayStruct["Pivots"].HAR1Break = true ;
		}
		if(arguments.qryDataHA.R2Break[arguments.Counter])  {
		arguments.dayStruct["Pivots"].HAR2Break = true ;
		}
	}
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

<cffunction name="CheckIndicators" description="buy/sell" access="public" displayname="test" output="false" returntype="Any">
	<cfargument name="daystructs" required="true" />
	<cfargument name="counter" required="true"  />
	<cfscript>
	var local = structNew(); 
	local.prevDayStruct 	= arguments.daystructs[arguments.counter -1];
	local.CurrentDayStruct 	= arguments.daystructs[arguments.counter];
	arguments.daystructs[arguments.counter]["CandleBuyFlag"] 	= "";
	arguments.daystructs[arguments.counter]["CandleSellFlag"] 	= "";
	arguments.daystructs[arguments.counter]["HACandleBuyFlag"] 	= "";
	arguments.daystructs[arguments.counter]["HACandleSellFlag"] = "";
	arguments.daystructs[arguments.counter]["AroonBuyFlag"] 	= "";
	arguments.daystructs[arguments.counter]["AroonSellFlag"] 	= ""; 
	arguments.daystructs[arguments.counter]["ZigZagBuyFlag"] 	= "";
	arguments.daystructs[arguments.counter]["ZigZagSellFlag"] 	= "";
	arguments.daystructs[arguments.counter]["HABullChange"] 	= "";
	arguments.daystructs[arguments.counter]["HABearChange"] 	= "";  
	 
	if (local.prevDayStruct["Candlepattern"].Bullflag AND local.CurrentDayStruct["Pivots"].R1Break  )
	{arguments.daystructs[arguments.counter]["CandleBuyFlag"] = "Buy initiated"; }
	if (local.CurrentDayStruct["Candlepattern"].Bearflag AND local.CurrentDayStruct["Pivots"].S1Break  )  
	{arguments.daystructs[arguments.counter]["CandleSellFlag"] = "Sell initiated";} 
	
	if (local.prevDayStruct["HACandlepattern"].Bullflag AND local.CurrentDayStruct["Pivots"].HAR1Break)
	{arguments.daystructs[arguments.counter]["HACandleBuyFlag"] = "Buy initiated"; }
	if (local.CurrentDayStruct["HACandlepattern"].Bearflag AND local.CurrentDayStruct["Pivots"].HAS1Break )  
	{arguments.daystructs[arguments.counter]["HACandleSellFlag"] = "Sell initiated";} 
	
	if (local.CurrentDayStruct["ZigZag"].Bullflag)
	{arguments.daystructs[arguments.counter]["ZigZagBuyFlag"] = "Buy initiated"; }
	if (local.CurrentDayStruct["ZigZag"].Bearflag)  
	{arguments.daystructs[arguments.counter]["ZigZagSellFlag"] = "Sell initiated";} 
	
	if (local.CurrentDayStruct["HAChange"].Bullflag)
	{arguments.daystructs[arguments.counter]["HAChangeBuyFlag"] = "Buy initiated"; }
	if (local.CurrentDayStruct["HAChange"].Bearflag)  
	{arguments.daystructs[arguments.counter]["HAChangeSellFlag"] = "Sell initiated";} 
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