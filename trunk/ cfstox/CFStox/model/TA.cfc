<cfcomponent output="false">
<!--- 
Supported indicators:
SMA - Smple moving average 
DX - Directional Movement Index
ADX - Average Directional Movement Index
CCI - Commodity Channel Index
Plus DI - Plus Directional Indicator
Plus DM - Plus Directional Movement


Coming Soon:
MACD                Moving Average Convergence/Divergence
MAX                 Highest value over a specified period
MIN                 Lowest value over a specified period
ROC                 Rate of change : ((price/prevPrice)-1)*100
RSI                 Relative Strength Index
STOCH               Stochastic
BBANDS              Bollinger Bands
Bar Counter - coldfusion
Pivot Points - coldfusion
 --->
	<cffunction  name="init">
		<cfset paths[1] =  "C:\JRun4\servers\cfusion\cfusion-ear\cfusion-war\CFStox\model\ta-lib.jar">
		<cfset server.loader = createObject("component", "cfstox.model.JavaLoader").init(paths) />
		<cfset talib  		= server.loader.create("com.tictactec.ta.lib.Core") />
		<cfset Minteger1  	= server.loader.create("com.tictactec.ta.lib.MInteger") />
		<cfset Minteger2  	= server.loader.create("com.tictactec.ta.lib.MInteger") />
		<cfset RetCode 		= server.loader.create("com.tictactec.ta.lib.RetCode") />
		<cfreturn this />
	</cffunction>
	
	<cffunction  name="PivotPoints" hint="Pivot Points">
		<cfargument name="qryData" required="true" />
		<!--- 
		R2 = P + (H - L) = P + (R1 - S1)
		R1 = (P x 2) - L
		P = (H + L + C) / 3
		S1 = (P x 2) - H
		S2 = P - (H - L) = P - (R1 - S1) 
		 --->
		<cfscript>
		var local = structNew();
		local.qryrows = arguments.qrydata.recordcount;
		local.PP = arrayNew(1);
		local.S1 = arraynew(1);
		local.S2 = arraynew(1);
		local.R1 = arrayNew(1);
		local.R2 = arrayNew(1);
		for(i=1;i<=local.qryrows;i++){ 
		    local.PP[i] = ((arguments.qryData.high[i] + arguments.qryData.low[i] + arguments.qrydata.close[i] ) / 3);
			local.S1[i] = (local.pp[i] * 2) - arguments.qryData.high[i];
			local.S2[i] = local.pp[i] - (arguments.qryData.high[i] - arguments.qryData.low[i]) ;
			local.R1[i] = (local.pp[i] * 2) - arguments.qryData.low[i];
			local.R2[i] = local.pp[i] + (arguments.qryData.high[i] - arguments.qryData.low[i]);
	    }
		</cfscript>
		<cfreturn local />
	</cffunction>
	
	<cffunction  name="Slope" hint="Slope">
		<cfargument name="qryPrices" required="true" />
		<cfargument name="value" required="true" />
		<cfargument name="length" required="true" />
		<cfscript>
		var local = structNew();
		local.qryrows = arguments.qryPrices.recordcount;
		local.aryOpen 	= ArrayNew(1);
		local.aryHigh 	= ArrayNew(1);
		local.aryLow 	= ArrayNew(1);
		local.aryClose 	= ArrayNew(1);
		local.arySlope 	= ArrayNew(1);		
		for(i=1;i<=local.qryrows;i++)
		{ 
			local.aryOpen[i]	= arguments.qryPrices.open[i]; 
			local.aryHigh[i]	= arguments.qryPrices.high[i]; 
			local.aryLow[i]		= arguments.qryPrices.low[i]; 
			local.aryClose[i]	= arguments.qryPrices.close[i]; 
			local.arySlope[i]	= 0;
		    if(i GT length)
		    {
		    	switch(arguments.value)
		    	{ 
		    	case "Open": 
        		local.value = (local.aryOpen[i] - local.aryOpen[i-length])/ length;  
        		break;
        		case "High": 
        		local.value = (local.aryHigh[i] - local.aryHigh[i-length])/ length;  
        		break;
        		case "Low": 
        		local.value = (local.aryLow[i] - local.aryLow[i-length])/ length;  
        		break;
        		case "Close": 
        		local.value = (local.aryClose[i] - local.aryClose[i-length])/ length;  
        		break;
        		}
		  	 local.arySlope[i] = local.value ;
		    }
	    }
		</cfscript>
		<cfreturn local.arySlope />
	</cffunction>
	
	<cffunction  name="LocalHighLow" hint="Support/resistance">
		<cfargument name="qryData" required="true" />
		<cfscript>
		var local = structNew();
		local.qryrows = arguments.qrydata.recordcount;
		local.LocalHighs = arrayNew(1);
		local.LocalLows = arraynew(1);
		local.LocalHighValue = arrayNew(1);
		local.LocalLowValue = arraynew(1);
		local.LocalHigh = 0;
		local.LocalLow = 0;
		for(i=1;i<=local.qryrows;i++){
		local.LocalHighs[i] = FALSE;
		local.LocalLows[i] = FALSE;
		} 
		for(i=3;i<=local.qryrows;i++){ 
		    if(arguments.qryData.high[i-2] LT arguments.qryData.high[i-1] AND arguments.qryData.high[i] LT arguments.qryData.high[i-1] ) {
		    local.LocalHighs[i-1] = TRUE;
		    local.LocalHigh = arguments.qryData.high[i-1];
		    }
		    local.LocalHighValue[i-1] = local.LocalHigh;
		    
		    if(arguments.qryData.low[i-2] GT arguments.qryData.low[i-1] AND arguments.qryData.low[i] GT arguments.qryData.low[i-1]) {
		    local.LocalLows[i-1] = TRUE;
		    local.LocalLow = arguments.qryData.low[i-1]; 
		    }
		    local.LocalLowValue[i-1] = local.LocalLow;
	    }
		</cfscript>
		<cfreturn local />
	</cffunction>

 	<cffunction  name="PivotBreak" hint="Support/resistance">
		<cfargument name="qryData" required="true" />
		<cfscript>
		var local = structNew();
		local.qryrows = arguments.qrydata.recordcount;
		local.S1Break = arrayNew(1);
		local.S2Break = arraynew(1);
		local.R1Break = arrayNew(1);
		local.R2Break = arraynew(1);
		for(i=1;i<=local.qryrows;i++){
		local.S1Break[i] = FALSE;
		local.S2Break[i] = FALSE;
		local.R1Break[i] = FALSE;
		local.R2Break[i] = FALSE;
		} 
		for(i=3;i<=local.qryrows;i++){ 
		    if(arguments.qryData.high[i] GT arguments.qryData.R1[i-1] ) {
		    local.R1Break[i] = TRUE;
		    }
		     if(arguments.qryData.high[i] GT arguments.qryData.R2[i-1] ) {
		    local.R2break[i] = TRUE;
		    }
		     if(arguments.qryData.low[i] LT arguments.qryData.S1[i-1] ) {
		    local.S1Break[i] = TRUE;
		    }
		    if(arguments.qryData.low[i] LT arguments.qryData.S2[i-1] ) {
		    local.S2Break[i] = TRUE;
		    }
	    }
		</cfscript>
		<cfreturn local />
	</cffunction>

	<cffunction  name="GetIndicator">
		<!--- data should be passed into the function oldest first --->
		<cfargument name="Indicator" 	type="String"  required="true" />
		<cfargument name="startIdx" 	type="Numeric"  default="0" required="false"  hint="where to start calculating"/> 
		<cfargument name="qryPrices" 	type="query" required="true"  hint="the array of prices to base on"/>
		<cfargument name="endIdx" 		type="Numeric"  default="#arguments.qryprices.recordcount-1#" required="false" />
		<cfargument name="optInTimePeriod" type="Numeric"  default="14" required="false" hint="length of MA" />
		<cfargument name="outBegIdx" 	type="Numeric"  default="1" required="false"  hint="where the data starts"/>
		<cfargument name="outNBElement" type="Numeric"  default="1" required="false"  hint="last element with data"/>
		<cfargument name="optInPenetration" type="Numeric"  default="1" required="false" />
		<cfargument name="lookback" type="Numeric"  default="1" required="false"  hint="normally called indicator length"/>
		<cfscript>
		var local = structNew();
		local.returndata = Structnew();
		// ta-lib returned data is not padded with zeros in front like you would expect
		// so if you want it aligned with your data you have to pad it in front
		local.fixArrays = true;
		local.srtArrays = ProcessArrays(qryPrices: arguments.qryPrices);
		/* arguments is a struct so it's passed by reference */
		DoJavaCast(arguments);
	    Minteger1  	= server.loader.create("com.tictactec.ta.lib.MInteger"); 
		Minteger2  	= server.loader.create("com.tictactec.ta.lib.MInteger"); 
		MaType  	= server.loader.create("com.tictactec.ta.lib.MAType");  
		Minteger1.value = 0;
		Minteger2.value = 0;
		</cfscript>
		<cftry>
		<cfswitch expression="#arguments.Indicator#">
			<cfcase value="SMA">
				<!--- sma(int startIdx, int endIdx, double[] inReal, int optInTimePeriod, MInteger outBegIdx, MInteger outNBElement, double[] outReal)   --->
				<cfset variables.talib.sma(arguments.startIdx,arguments.endIdx, local.srtArrays.aryClose, arguments.optInTimePeriod,Minteger1,Minteger2,local.srtArrays.aryOut) />
				<cfset local.returndata.lookback 		= variables.talib.smaLookback(arguments.optInTimePeriod) />
				<cfset local.returndata.outBegIdx		= Minteger1.value />
				<cfset local.returndata.outNBElement 	= Minteger2.value />
				<cfset local.returndata.results 		= local.srtArrays />
				<cfreturn local.returndata />
			</cfcase>
			
			<cfcase value="DX">
				<!--- 	dx(int startIdx, int endIdx, double[] inHigh, double[] inLow, double[] inClose, int optInTimePeriod, MInteger outBegIdx, MInteger outNBElement, double[] outReal)   --->
				<cfset variables.talib.DX(arguments.startIdx,arguments.endIdx,local.srtArrays.aryHigh, local.srtArrays.aryLow, local.srtArrays.aryClose,arguments.optInTimePeriod,Minteger1,Minteger2,local.srtArrays.aryOut) />
				<cfset local.lookback = variables.talib.dxLookback(arguments.optInTimePeriod) />
				<cfset local.returndata.results = local.srtArrays.aryOut />
			</cfcase>
			
			<cfcase value="ADX">
				<!--- adx(int startIdx, int endIdx, double[] inHigh, double[] inLow, double[] inClose, int optInTimePeriod, MInteger outBegIdx, MInteger outNBElement, double[] outReal)   --->
				<cfset variables.talib.ADX(arguments.startIdx,arguments.endIdx,local.srtArrays.aryHigh, local.srtArrays.aryLow, local.srtArrays.aryClose,arguments.optInTimePeriod,Minteger1,Minteger2,local.srtArrays.aryOut) />
				<cfset local.lookback = variables.talib.adxLookback(arguments.optInTimePeriod) />
				<cfset local.returndata.results = local.srtArrays.aryOut />
			</cfcase>
			
			<cfcase value="ADXR">
				<!--- adxr(int startIdx, int endIdx, double[] inHigh, double[] inLow, double[] inClose, int optInTimePeriod, MInteger outBegIdx, MInteger outNBElement, double[] outReal)    --->
				<cfset variables.talib.ADXR(arguments.startIdx,arguments.endIdx,local.srtArrays.aryHigh, local.srtArrays.aryLow, local.srtArrays.aryClose,arguments.optInTimePeriod,Minteger1,Minteger2,local.srtArrays.aryOut) />
				<cfset local.lookback = variables.talib.adxrLookback(arguments.optInTimePeriod) />
				<cfset local.returndata.results = local.srtArrays.aryOut />
			</cfcase>
			
			<cfcase value="AroonOsc">
				<!--- aroonOsc(int startIdx, int endIdx, double[] inHigh, double[] inLow, int optInTimePeriod, MInteger outBegIdx, MInteger outNBElement, double[] outReal) --->
				<cfset variables.talib.aroonOsc(arguments.startIdx,arguments.endIdx,local.srtArrays.aryHigh,local.srtArrays.aryLow, arguments.optInTimePeriod,Minteger1,Minteger2,local.srtArrays.aryOut) />
				<cfset local.lookback = variables.talib.AroonLookback(arguments.optInTimePeriod) />
				<cfset local.returndata.results = local.srtArrays.aryOut />
			</cfcase>
						
			
			
			<cfcase value="CCI">
				<!--- cci(int startIdx, int endIdx, double[] inHigh, double[] inLow, double[] inClose, int optInTimePeriod, MInteger outBegIdx, MInteger outNBElement, double[] outReal)   --->
				<cfset variables.talib.CCI(arguments.startIdx, arguments.endIdx, local.srtArrays.aryHigh, local.srtArrays.aryLow, local.srtArrays.aryClose,arguments.optInTimePeriod,Minteger1,Minteger2,local.srtArrays.aryOut) />
				<cfset local.lookback = variables.talib.cciLookback(arguments.optInTimePeriod) />
				<cfset local.returndata.results = local.srtArrays.aryOut />
			</cfcase>
			
			<cfcase value="PLUS_DI">
				<!--- plusDI(int startIdx, int endIdx, double[] inHigh, double[] inLow, double[] inClose, int optInTimePeriod, MInteger outBegIdx, MInteger outNBElement, double[] outReal)   --->
				<cfset variables.talib.plusDI(arguments.startIdx,arguments.endIdx,local.srtArrays.aryHigh, local.srtArrays.aryLow, local.srtArrays.aryClose,arguments.optInTimePeriod,Minteger1,Minteger2,local.srtArrays.aryOut) />
				<cfset local.returndata.results = local.srtArrays.aryOut />
			</cfcase>
			
			<cfcase value="PLUS_DM">
				<!--- plusDM(int startIdx, int endIdx, double[] inHigh, double[] inLow, int optInTimePeriod, MInteger outBegIdx, MInteger outNBElement, double[] outReal)   --->
				<cfset variables.talib.plusDM(arguments.startIdx,arguments.endIdx,local.srtArrays.aryHigh, local.srtArrays.aryLow, arguments.optInTimePeriod,Minteger1,Minteger2,local.srtArrays.aryOut) />
				<cfset local.returndata.results = local.srtArrays.aryOut />
			</cfcase>
			
			<cfcase value="linearReg">
				<cfset variables.talib.linearReg(arguments.startIdx,arguments.endIdx, local.srtArrays.aryClose, arguments.optInTimePeriod,Minteger1,Minteger2,local.srtArrays.aryOut) />
				<cfset local.returndata.results = local.srtArrays.aryOut />
			</cfcase>
			
			<cfcase value="linearRegAngle">
				<cfset variables.talib.linearRegAngle(arguments.startIdx,arguments.endIdx, local.srtArrays.aryClose, arguments.optInTimePeriod,Minteger1,Minteger2,local.srtArrays.aryOut) />
				<cfset local.returndata.results = local.srtArrays.aryOut />
			</cfcase>
			
			<cfcase value="linearRegSlope">
				<cfset variables.talib.linearRegSlope(arguments.startIdx,arguments.endIdx, local.srtArrays.aryClose, arguments.optInTimePeriod,Minteger1,Minteger2,local.srtArrays.aryOut) />
				<cfset local.returndata.results = local.srtArrays.aryOut />
			</cfcase>
			
			<cfcase value="linearRegIntercept">
				<cfset variables.talib.linearRegIntercept(arguments.startIdx,arguments.endIdx, local.srtArrays.aryClose, arguments.optInTimePeriod,Minteger1,Minteger2,local.srtArrays.aryOut) />
				<cfset local.returndata.results = local.srtArrays.aryOut />
			</cfcase>
			
			<cfcase value="Momentum">
				<!--- mom(int startIdx, int endIdx, double[] inReal, int optInTimePeriod, MInteger outBegIdx, MInteger outNBElement, double[] outReal)  --->
				<cfset variables.talib.mom(arguments.startIdx,arguments.endIdx, local.srtArrays.aryClose, arguments.optInTimePeriod,Minteger1,Minteger2,local.srtArrays.aryOut) />
				<cfset local.returndata.results = local.srtArrays.aryOut />
			</cfcase>

			<cfcase value="PPO">
				<!--- ppo(int startIdx, int endIdx, double[] inReal, int optInFastPeriod, int optInSlowPeriod, MAType optInMAType, MInteger outBegIdx, MInteger outNBElement, double[] outReal)			 --->
				<cfset variables.talib.ppo(arguments.startIdx,arguments.endIdx,local.srtArrays.aryClose, arguments.optInTimePeriod,Minteger1,Minteger2,local.srtArrays.aryOut) />
				<cfset local.returndata.results = local.srtArrays.aryOut />
			</cfcase>
						
			<cfcase value="RSI">
				<!--- rsi(int startIdx, int endIdx, double[] inReal, int optInTimePeriod, MInteger outBegIdx, MInteger outNBElement, double[] outReal) --->
				<cfset variables.talib.rsi(arguments.startIdx,arguments.endIdx, local.srtArrays.aryClose, arguments.optInTimePeriod,Minteger1,Minteger2,local.srtArrays.aryOut) />
				<cfset local.lookback = variables.talib.rsiLookback(arguments.optInTimePeriod) />
				<cfset local.returndata.results = local.srtArrays.aryOut />
			</cfcase>
			
			<cfcase value="SAR">
				<cfset local.acceleration = jDouble(0.02) />
				<cfset local.optInMaximum = jDouble(0.2) />
				<!--- (int startIdx, int endIdx, double[] inHigh, double[] inLow, double optInAcceleration, double optInMaximum, MInteger outBegIdx, 
				MInteger outNBElement, double[] outReal)  --->
				<cfset variables.talib.sar(arguments.startIdx,arguments.endIdx,local.srtArrays.aryHigh,local.srtArrays.aryLow,local.acceration,local.optInMaximum,Minteger1,
				Minteger2,local.srtArrays.aryOut) />
				<cfset local.returndata.results = local.srtArrays.aryOut />
			</cfcase>
			
			<cfcase value="Bollinger">
				<cfset local.fixArrays = false />
				<cfset local.cfAryObj = structNew() />
				<cfset local.optInNbDevUp 	= jDouble(3) />
				<cfset local.optInNbDevDn 	= jDouble(3) />
				<cfset local.optInMAType 	=  MAType /> <!---- MAType.valueOf("Sma") = 0 ---->
				<cfset local.aryUpper 		=  local.srtArrays.aryHigh /> 
				<cfset local.aryMiddle 		=  local.srtArrays.aryLow />
				<cfset local.aryLower 		=  local.srtArrays.aryOpen />  
				<!--- bbands(int startIdx, int endIdx, double[] inReal, int optInTimePeriod, double optInNbDevUp, double optInNbDevDn, MAType optInMAType, MInteger outBegIdx, MInteger outNBElement, double[] outRealUpperBand, double[] outRealMiddleBand, double[] outRealLowerBand) ---> 
				<cfset variables.talib.bbands(arguments.startIdx,arguments.endIdx,local.srtArrays.aryClose,arguments.optInTimePeriod,local.optInNbDevUp,local.optInNbDevDn,local.optInMAType.Sma,Minteger1,Minteger2,local.aryUpper,local.aryMiddle,local.aryLower) />
				<cfset local.cfAryObj.aryUpper 	= FixTAArray(javaArray:local.aryUpper,outBegIdx:MInteger1.value) />
				<cfset local.cfAryObj.aryMiddle	= FixTAArray(javaArray:local.aryMiddle,outBegIdx:MInteger1.value) />
				<cfset local.cfAryObj.aryLower 	= FixTAArray(javaArray:local.aryLower,outBegIdx:MInteger1.value) />
			</cfcase>			
			<cfcase value="Stoch">
			<cfset local.fixArrays = false />
			<cfset local.cfAryObj = structNew() />
			<cfset local.aryOutSlowK = duplicate(local.srtArrays.aryOut)  />
			<cfset local.aryOutSlowD = duplicate(local.srtArrays.aryOut)  />
			<cfset local.optInFastK_Period = 2  />
			<cfset local.optInSlowK_Period = 5 />	
			<cfset local.optInSlowK_MAType = MAType.Sma />
			<cfset local.optInSlowD_Period = 5 />
			<cfset local.optInSlowD_MAType = MAType.Sma />	
			<!--- stoch(int startIdx, int endIdx, double[] inHigh, double[] inLow, double[] inClose, int optInFastK_Period, int optInSlowK_Period, 
			MAType optInSlowK_MAType, int optInSlowD_Period, MAType optInSlowD_MAType, MInteger outBegIdx, MInteger outNBElement, double[] outSlowK, 
			double[] outSlowD) 
			 --->
			<cfset variables.talib.stoch(arguments.startIdx,arguments.endIdx,local.srtArrays.aryHigh,
			local.srtArrays.aryLow,local.srtArrays.aryClose,local.optInFastK_Period,local.optInSlowK_Period, 
			local.optInSlowK_MAType, local.optInSlowD_Period, local.optInSlowD_MAType, Minteger1, Minteger2,
			local.aryOutSlowK, local.aryOutSlowD ) />
			<cfset local.cfAryObj.SlowK 	= FixTAArray(javaArray:local.aryOutSlowK,outBegIdx:MInteger1.value) />
			<cfset local.cfAryObj.SlowD		= FixTAArray(javaArray:local.aryOutSlowD,outBegIdx:MInteger1.value) />
			</cfcase>
			
			<cfdefaultcase>
				<cfthrow type="Application" message="Invalid indicator type">
			</cfdefaultcase>
		</cfswitch>
		<cfcatch type="application">
		   <cfoutput>
		   <h3>Invalid indicator type passed to GetIndicator, or something else went wrong</h3>
		   <strong>REASON:</strong><br/>
			#cfcatch.message#<br/>
			<br /><strong>DETAIL:</strong>
			<br/>#cfcatch.detail#<br/>
			</cfoutput>
		</cfcatch>
		</cftry>
		<cfif local.fixArrays >
			<cfset local.cfAryObj = FixTAArray(javaArray:local.srtArrays.aryOut,outBegIdx:MInteger1.value) />
		</cfif>
		<cfreturn  local.cfAryObj />
	</cffunction>
	
	<cffunction name="FixTAArray" description="" access="private" displayname="" output="false" returntype="Array">
		<cfargument name="javaArray" required="true" />
		<cfargument name="outBegIdx" required="true" />
		<!---- convert the java object back to a CF object so we can use it --->
			<cfset local.aryCopy = duplicate(arguments.javaArray) />
			<cfset local.cfListObj = ArraytoList(local.aryCopy) >
			<cfset local.cfAryObj  = ListToArray(local.cfListObj, ",", true) >
			<!--- 'for loop' should stop prior to outNbElement, not dataLen --->
			<!--- outNBElement is the number of the last cell containing data --->
			<!--- outBegIndex is the number of starting rows to pad with zeros --->
			<cfloop from="1" to="#arguments.outBegIdx#" index="i">
				<cfset ArrayPrepend(local.cfAryObj,"0")>
			</cfloop>  
		 	<cfloop from="1" to="#arguments.outBegIdx#" index="i">
				<cfset ArrayDeleteAt(local.cfAryObj,local.cfAryObj.size() )>
			</cfloop> 
		<cfreturn local.cfAryObj />
	</cffunction>

	<cffunction name="jDouble" description="" access="private" displayname="" output="false" returntype="Any">
		<cfargument name="intValue" required="true" />
		<cfset var newValue = arguments.intValue />
		<cfset var dValue  = javacast("double",newValue) />
		<cfreturn dValue />
	</cffunction>
	
	<cffunction  name="GetCandle">
		<!--- data should be passed into the function oldest first 
		http://www.tadoc.org/forum/index.php?topic=342.0
		The inputs are assumed to be provided in ascending chronological order (oldest element at position zero of the input array).
		The outputs are in ascending chronological order (oldest *calculable* element at position zero of the output array).
		TA-Lib writes the first caculable output at the index zero of the output. You then use outbegIdx to figure out the offset from the input.
		So you have to pad the start/top of the output array with OUTBEGIDX zeros then loop over and copy the output values to
		get the output to match with the dates. 
		--->
		<cfargument name="Candle" 				type="String"  required="true" />
		<cfargument name="startIdx" 			type="Numeric"  default="0" required="false"  hint="where to start calculating"/> 
		<cfargument name="qryPrices" 			type="query" 	required="true"  hint="the array of prices to base on"/>
		<cfargument name="endIdx" 				type="Numeric"  default="#arguments.qryprices.recordcount-1#" required="false" />
		<cfargument name="optInTimePeriod" 		type="Numeric"  default="1" required="false" hint="length of MA" />
		<cfargument name="outBegIdx" 			type="Numeric"  default="1" required="false" />
		<cfargument name="outNBElement" 		type="Numeric"  default="1" required="false" />
		<cfargument name="optInPenetration" 	type="Numeric"  default="0.5" required="false" />
		
		<cfscript>
		var local = structNew();
		local.returndata = Structnew();
		local.srtArrays = ProcessArrays(qryPrices: arguments.qryPrices);
		/* arguments is a struct so it's passed by reference */
		DoJavaCast(arguments);
	    Minteger1  = server.loader.create("com.tictactec.ta.lib.MInteger"); 
		Minteger2  = server.loader.create("com.tictactec.ta.lib.MInteger"); 
		Minteger1.value = 0;
		Minteger2.value = 0;
		</cfscript>
		<cftry>
		<!---- 
		High Reliablity Bullish
		Piercing Line 	Kicking 	Abandoned Baby 	Morning Doji Star 	Morning Star
		Three Inside Up 	Three Outside Up 	Three White Soldiers 	 Concealing Baby Swallow
		
		Medium Reliablity Bullish
		Dragonfly Doji 	Long Legged Doji 	Engulfing 	Gravestone Doji 	Doji Star
		Harami Cross 	Homing Pigeon 	Matching Low 	Meeting Lines 	Stick Sandwich
		Three Stars in the South 	Tri Star 	Three River 	Breakaway 	Ladder Bottom 	
		
		Low Reliablity Bullish
		Belt Hold 	Hammer 	Inverted Hammer 	Harami 	
		
		BULLISH CONTINUATION PATTERNS
      	HIGH RELIABILITY
		Side-by-side-White Lines 	Mat Hold 	Rising Three Methods
		
		MEDIUM RELIABILITY
		Upside Gap Three Methods 	Upside Tasuki Gap
		
		LOW RELIABILITY
		Separating Lines 	Three Line Strike
		
		BULLISH REVERSAL/CONTINUATION PATTERNS 
		LOW RELIABILITY
		Long White Candlestick 	White Marubozu 	White Closing Marubozu 	White Opening Marubozu
		---->
		
		<!---- 
		BEARISH REVERSAL PATTERNS
      	
		HIGH RELIABILITY
		Dark Cloud Cover 	Kicking 	Abandoned Baby 	Evening Star 	Evening Doji Star
		Three Black Crows 	Three Inside Down 	Three Outside Down 	 Upside Gap Two Crows 	
		
		MEDIUM RELIABILITY
		Dragonfly Doji 	Long Legged Doji 	Engulfing 	Gravestone Doji 	Doji Star
		Harami Cross 	Meeting Lines 	Advance Block 	Deliberation 	Tri Star
		Two Crows 	Breakaway
		
		LOW RELIABILITY
		Belt Hold 	Hanging Man 	Shooting Star 	Harami
		
		BEARISH CONTINUATION PATTERNS 
      	HIGH RELIABILITY
		Falling Three Methods 	

		MEDIUM RELIABILITY
		In Neck 	On Neck 	Downside Gap Three Methods 	Downside Tasuki Gap 	Side By Side White Lines 	 

		LOW RELIABILITY
		Separating Lines 	Thrusting 	Three Line Strike 	  	  	 
 
    	BEARISH REVERSAL/CONTINUATION PATTERNS 
      	LOW RELIABILITY
		Long Black Candlestick 	Black Marubozu 	Black Closing Marubozu 	Black Opening Marubozu 	

		---->
		
		<!----- UNKNOWN 
		MatHold
		3LineStrike
		CounterAttack
		Doji
		GapInsideWhite
		HighWave
		Hikkake
		Identical3Crows
		LongLine
		MatchingLow
		RickshawMan
		SeperatingLines
		ShortLine
		SpinningTop
		StalledPattern
		Takuri
		TasukiGap
		----->
		<cfswitch expression="#arguments.Candle#">
			<!--- take optInPenetration argument  --->
			<cfcase value="AbandonedBaby"> <!--- HIGH RELIABILITY --->
				<!---- optInPenetration:(From 0 to TA_REAL_MAX) *    Percentage of penetration of a candle within another candle ----> 
				<!---- cdlAbandonedBaby(int startIdx, int endIdx, double[] inOpen, double[] inHigh, double[] inLow, double[] inClose, double optInPenetration, MInteger outBegIdx, MInteger outNBElement, int[] outInteger) --->
				<cfset variables.talib.cdlAbandonedBaby(arguments.startIdx,arguments.endIdx,local.srtArrays.aryOpen,local.srtArrays.aryHigh, local.srtArrays.aryLow, local.srtArrays.aryClose,arguments.optInPenetration,Minteger1,Minteger2,local.srtArrays.aryOutCandle) />
				<!--- <cfset local.lookback = variables.talib.cdlAbandonedBabyLookback(arguments.optInTimePeriod) /> --->
			</cfcase>
			<cfcase value="DarkCloudCover"> <!--- HIGH RELIABILITY --->
				<!---- optInPenetration:(From 0 to TA_REAL_MAX) *    Percentage of penetration of a candle within another candle ----> 
				<!---- cdlAbandonedBaby(int startIdx, int endIdx, double[] inOpen, double[] inHigh, double[] inLow, double[] inClose, double optInPenetration, MInteger outBegIdx, MInteger outNBElement, int[] outInteger) --->
				<cfset variables.talib.cdlDarkCloudCover(arguments.startIdx,arguments.endIdx,local.srtArrays.aryOpen,local.srtArrays.aryHigh, local.srtArrays.aryLow, local.srtArrays.aryClose,arguments.optInPenetration,Minteger1,Minteger2,local.srtArrays.aryOutCandle) />
				<!--- <cfset local.lookback = variables.talib.cdlAbandonedBabyLookback(arguments.optInTimePeriod) /> --->
			</cfcase>
			<cfcase value="EveningDojiStar"> <!--- HIGH RELIABILITY --->
				<!---- optInPenetration:(From 0 to TA_REAL_MAX) *    Percentage of penetration of a candle within another candle ----> 
				<!---- cdlAbandonedBaby(int startIdx, int endIdx, double[] inOpen, double[] inHigh, double[] inLow, double[] inClose, double optInPenetration, MInteger outBegIdx, MInteger outNBElement, int[] outInteger) --->
				<cfset variables.talib.cdlEveningDojiStar(arguments.startIdx,arguments.endIdx,local.srtArrays.aryOpen,local.srtArrays.aryHigh, local.srtArrays.aryLow, local.srtArrays.aryClose,arguments.optInPenetration,Minteger1,Minteger2,local.srtArrays.aryOutCandle) />
				<!--- <cfset local.lookback = variables.talib.cdlAbandonedBabyLookback(arguments.optInTimePeriod) /> --->
			</cfcase>
			<cfcase value="EveningStar"> <!--- HIGH RELIABILITY --->
				<!---- optInPenetration:(From 0 to TA_REAL_MAX) *    Percentage of penetration of a candle within another candle ----> 
				<!---- cdlAbandonedBaby(int startIdx, int endIdx, double[] inOpen, double[] inHigh, double[] inLow, double[] inClose, double optInPenetration, MInteger outBegIdx, MInteger outNBElement, int[] outInteger) --->
				<cfset variables.talib.cdlEveningStar(arguments.startIdx,arguments.endIdx,local.srtArrays.aryOpen,local.srtArrays.aryHigh, local.srtArrays.aryLow, local.srtArrays.aryClose,arguments.optInPenetration,Minteger1,Minteger2,local.srtArrays.aryOutCandle) />
				<!--- <cfset local.lookback = variables.talib.cdlAbandonedBabyLookback(arguments.optInTimePeriod) /> --->
			</cfcase>
			<cfcase value="MatHold"> <!--- HIGH RELIABILITY --->
				<!---- optInPenetration:(From 0 to TA_REAL_MAX) *    Percentage of penetration of a candle within another candle ----> 
				<!---- cdlAbandonedBaby(int startIdx, int endIdx, double[] inOpen, double[] inHigh, double[] inLow, double[] inClose, double optInPenetration, MInteger outBegIdx, MInteger outNBElement, int[] outInteger) --->
				<cfset variables.talib.cdlMatHold(arguments.startIdx,arguments.endIdx,local.srtArrays.aryOpen,local.srtArrays.aryHigh, local.srtArrays.aryLow, local.srtArrays.aryClose,arguments.optInPenetration,Minteger1,Minteger2,local.srtArrays.aryOutCandle) />
				<!--- <cfset local.lookback = variables.talib.cdlAbandonedBabyLookback(arguments.optInTimePeriod) /> --->
			</cfcase>
			<cfcase value="MorningDojiStar"> <!--- HIGH RELIABILITY --->
				<!---- optInPenetration:(From 0 to TA_REAL_MAX) *    Percentage of penetration of a candle within another candle ----> 
				<!---- cdlAbandonedBaby(int startIdx, int endIdx, double[] inOpen, double[] inHigh, double[] inLow, double[] inClose, double optInPenetration, MInteger outBegIdx, MInteger outNBElement, int[] outInteger) --->
				<cfset variables.talib.cdlMorningDojiStar(arguments.startIdx,arguments.endIdx,local.srtArrays.aryOpen,local.srtArrays.aryHigh, local.srtArrays.aryLow, local.srtArrays.aryClose,arguments.optInPenetration,Minteger1,Minteger2,local.srtArrays.aryOutCandle) />
				<!--- <cfset local.lookback = variables.talib.cdlAbandonedBabyLookback(arguments.optInTimePeriod) /> --->
			</cfcase>
			<cfcase value="MorningStar"> <!--- HIGH RELIABILITY --->
				<!---- optInPenetration:(From 0 to TA_REAL_MAX) *    Percentage of penetration of a candle within another candle ----> 
				<!---- cdlAbandonedBaby(int startIdx, int endIdx, double[] inOpen, double[] inHigh, double[] inLow, double[] inClose, double optInPenetration, MInteger outBegIdx, MInteger outNBElement, int[] outInteger) --->
				<cfset variables.talib.cdlMorningStar(arguments.startIdx,arguments.endIdx,local.srtArrays.aryOpen,local.srtArrays.aryHigh, local.srtArrays.aryLow, local.srtArrays.aryClose,arguments.optInPenetration,Minteger1,Minteger2,local.srtArrays.aryOutCandle) />
				<!--- <cfset local.lookback = variables.talib.cdlAbandonedBabyLookback(arguments.optInTimePeriod) /> --->
			</cfcase>
						
			<!--- no optInPenetration ---->
			<cfcase value="2Crows"> <!--- MEDIUM RELIABILITY --->
				<cfset variables.talib.cdl2Crows(arguments.startIdx,arguments.endIdx,local.srtArrays.aryOpen,local.srtArrays.aryHigh, local.srtArrays.aryLow, local.srtArrays.aryClose,Minteger1,Minteger2,local.srtArrays.aryOutCandle) />
				<!--- <cfset local.lookback = variables.talib.cdlAbandonedBabyLookback(arguments.optInTimePeriod) /> --->
			</cfcase>	
			
			<cfcase value="3BlackCrows"> <!--- HIGH RELIABILITY --->
				<cfset variables.talib.cdl3BlackCrows(arguments.startIdx,arguments.endIdx,local.srtArrays.aryOpen,local.srtArrays.aryHigh, local.srtArrays.aryLow, local.srtArrays.aryClose,Minteger1,Minteger2,local.srtArrays.aryOutCandle) />
				<!--- <cfset local.lookback = variables.talib.cdlAbandonedBabyLookback(arguments.optInTimePeriod) /> --->
			</cfcase>	
			
			<cfcase value="3Inside"> <!--- HIGH RELIABILITY --->
				<cfset variables.talib.cdl3Inside(arguments.startIdx,arguments.endIdx,local.srtArrays.aryOpen,local.srtArrays.aryHigh, local.srtArrays.aryLow, local.srtArrays.aryClose,Minteger1,Minteger2,local.srtArrays.aryOutCandle) />
				<!--- <cfset local.lookback = variables.talib.cdlAbandonedBabyLookback(arguments.optInTimePeriod) /> --->
			</cfcase>	
			
			<cfcase value="3LineStrike"> <!--- LOW RELIABILITY --->
				<cfset variables.talib.cdl3LineStrike(arguments.startIdx,arguments.endIdx,local.srtArrays.aryOpen,local.srtArrays.aryHigh, local.srtArrays.aryLow, local.srtArrays.aryClose,Minteger1,Minteger2,local.srtArrays.aryOutCandle) />
				<!--- <cfset local.lookback = variables.talib.cdlAbandonedBabyLookback(arguments.optInTimePeriod) /> --->
			</cfcase>	
			
			<cfcase value="3Outside"> <!--- HIGH RELIABILITY --->
				<cfset variables.talib.cdl3Outside(arguments.startIdx,arguments.endIdx,local.srtArrays.aryOpen,local.srtArrays.aryHigh, local.srtArrays.aryLow, local.srtArrays.aryClose,Minteger1,Minteger2,local.srtArrays.aryOutCandle) />
				<!--- <cfset local.lookback = variables.talib.cdlAbandonedBabyLookback(arguments.optInTimePeriod) /> --->
			</cfcase>
			
			<cfcase value="3StarsInSouth"> <!--- MEDIUM RELIABILITY --->
				<cfset variables.talib.cdl3StarsInSouth(arguments.startIdx,arguments.endIdx,local.srtArrays.aryOpen,local.srtArrays.aryHigh, local.srtArrays.aryLow, local.srtArrays.aryClose,Minteger1,Minteger2,local.srtArrays.aryOutCandle) />
				<!--- <cfset local.lookback = variables.talib.cdlAbandonedBabyLookback(arguments.optInTimePeriod) /> --->
			</cfcase>	
			
			<cfcase value="3WhiteSoldiers"> <!--- HIGH RELIABILITY --->
				<cfset variables.talib.cdl3WhiteSoldiers(arguments.startIdx,arguments.endIdx,local.srtArrays.aryOpen,local.srtArrays.aryHigh, local.srtArrays.aryLow, local.srtArrays.aryClose,Minteger1,Minteger2,local.srtArrays.aryOutCandle) />
				<!--- <cfset local.lookback = variables.talib.cdlAbandonedBabyLookback(arguments.optInTimePeriod) /> --->
			</cfcase>	
			
			<cfcase value="AdvanceBlock"> <!--- MEDIUM RELIABILITY --->
				<cfset variables.talib.cdlAdvanceBlock(arguments.startIdx,arguments.endIdx,local.srtArrays.aryOpen,local.srtArrays.aryHigh, local.srtArrays.aryLow, local.srtArrays.aryClose,Minteger1,Minteger2,local.srtArrays.aryOutCandle) />
				<!--- <cfset local.lookback = variables.talib.cdlAbandonedBabyLookback(arguments.optInTimePeriod) /> --->
			</cfcase>	
			
			<cfcase value="BeltHold"> <!--- LOW RELIABILITY --->
				<cfset variables.talib.cdlBeltHold(arguments.startIdx,arguments.endIdx,local.srtArrays.aryOpen,local.srtArrays.aryHigh, local.srtArrays.aryLow, local.srtArrays.aryClose,Minteger1,Minteger2,local.srtArrays.aryOutCandle) />
				<!--- <cfset local.lookback = variables.talib.cdlAbandonedBabyLookback(arguments.optInTimePeriod) /> --->
			</cfcase>	
			
			<cfcase value="Breakaway"> <!--- MEDIUM RELIABILITY --->
				<cfset variables.talib.cdlBreakaway(arguments.startIdx,arguments.endIdx,local.srtArrays.aryOpen,local.srtArrays.aryHigh, local.srtArrays.aryLow, local.srtArrays.aryClose,Minteger1,Minteger2,local.srtArrays.aryOutCandle) />
				<!--- <cfset local.lookback = variables.talib.cdlAbandonedBabyLookback(arguments.optInTimePeriod) /> --->
			</cfcase>	
			
			<cfcase value="ClosingMarubozu"> <!--- LOW RELIABILITY --->
				<cfset variables.talib.cdlClosingMarubozu(arguments.startIdx,arguments.endIdx,local.srtArrays.aryOpen,local.srtArrays.aryHigh, local.srtArrays.aryLow, local.srtArrays.aryClose,Minteger1,Minteger2,local.srtArrays.aryOutCandle) />
				<!--- <cfset local.lookback = variables.talib.cdlAbandonedBabyLookback(arguments.optInTimePeriod) /> --->
			</cfcase>	
			
			<cfcase value="ConcealBabySwallow"> <!--- HIGH RELIABILITY --->
				<cfset variables.talib.cdlConcealBabysWall(arguments.startIdx,arguments.endIdx,local.srtArrays.aryOpen,local.srtArrays.aryHigh, local.srtArrays.aryLow, local.srtArrays.aryClose,Minteger1,Minteger2,local.srtArrays.aryOutCandle) />
				<!--- <cfset local.lookback = variables.talib.cdlAbandonedBabyLookback(arguments.optInTimePeriod) /> --->
			</cfcase>	
			
			<cfcase value="CounterAttack"> <!--- UNKNOWN --->
				<cfset variables.talib.cdlCounterAttack(arguments.startIdx,arguments.endIdx,local.srtArrays.aryOpen,local.srtArrays.aryHigh, local.srtArrays.aryLow, local.srtArrays.aryClose,Minteger1,Minteger2,local.srtArrays.aryOutCandle) />
				<!--- <cfset local.lookback = variables.talib.cdlAbandonedBabyLookback(arguments.optInTimePeriod) /> --->
			</cfcase>	
			
			<cfcase value="Doji"> <!--- UNKNOWN --->
				<cfset variables.talib.cdlDoji(arguments.startIdx,arguments.endIdx,local.srtArrays.aryOpen,local.srtArrays.aryHigh, local.srtArrays.aryLow, local.srtArrays.aryClose,Minteger1,Minteger2,local.srtArrays.aryOutCandle) />
				<!--- <cfset local.lookback = variables.talib.cdlAbandonedBabyLookback(arguments.optInTimePeriod) /> --->
			</cfcase>		
			
			<cfcase value="DojiStar"> <!--- MEDIUM RELIABILITY --->
				<cfset variables.talib.cdlDojiStar(arguments.startIdx,arguments.endIdx,local.srtArrays.aryOpen,local.srtArrays.aryHigh, local.srtArrays.aryLow, local.srtArrays.aryClose,Minteger1,Minteger2,local.srtArrays.aryOutCandle) />
				<!--- <cfset local.lookback = variables.talib.cdlAbandonedBabyLookback(arguments.optInTimePeriod) /> --->
			</cfcase>		
						
			<cfcase value="DragonflyDoji"> <!--- MEDIUM RELIABILITY --->
				<cfset variables.talib.cdlDragonflyDoji(arguments.startIdx,arguments.endIdx,local.srtArrays.aryOpen,local.srtArrays.aryHigh, local.srtArrays.aryLow, local.srtArrays.aryClose,Minteger1,Minteger2,local.srtArrays.aryOutCandle) />
				<!--- <cfset local.lookback = variables.talib.cdlAbandonedBabyLookback(arguments.optInTimePeriod) /> --->
			</cfcase>		
			
			<cfcase value="Engulfing"> <!--- MEDIUM RELIABILITY --->
				<cfset variables.talib.cdlEngulfing(arguments.startIdx,arguments.endIdx,local.srtArrays.aryOpen,local.srtArrays.aryHigh, local.srtArrays.aryLow, local.srtArrays.aryClose,Minteger1,Minteger2,local.srtArrays.aryOutCandle) />
				<!--- <cfset local.lookback = variables.talib.cdlAbandonedBabyLookback(arguments.optInTimePeriod) /> --->
			</cfcase>		
			
			<cfcase value="GapSideSideWhite"> <!--- UNKNOWN --->
				<cfset variables.talib.cdlGapSideSideWhite(arguments.startIdx,arguments.endIdx,local.srtArrays.aryOpen,local.srtArrays.aryHigh, local.srtArrays.aryLow, local.srtArrays.aryClose,Minteger1,Minteger2,local.srtArrays.aryOutCandle) />
				<!--- <cfset local.lookback = variables.talib.cdlAbandonedBabyLookback(arguments.optInTimePeriod) /> --->
			</cfcase>		
			
			<cfcase value="GravestoneDoji"> <!--- MEDIUM RELIABILITY --->
				<cfset variables.talib.cdlGravestoneDoji(arguments.startIdx,arguments.endIdx,local.srtArrays.aryOpen,local.srtArrays.aryHigh, local.srtArrays.aryLow, local.srtArrays.aryClose,Minteger1,Minteger2,local.srtArrays.aryOutCandle) />
				<!--- <cfset local.lookback = variables.talib.cdlAbandonedBabyLookback(arguments.optInTimePeriod) /> --->
			</cfcase>		
			
			<cfcase value="Hammer"> <!--- LOW RELIABILITY --->
				<cfset variables.talib.cdlHammer(arguments.startIdx,arguments.endIdx,local.srtArrays.aryOpen,local.srtArrays.aryHigh, local.srtArrays.aryLow, local.srtArrays.aryClose,Minteger1,Minteger2,local.srtArrays.aryOutCandle) />
				<!--- <cfset local.lookback = variables.talib.cdlAbandonedBabyLookback(arguments.optInTimePeriod) /> --->
			</cfcase>		
			
			<cfcase value="HangingMan"> <!--- LOW RELIABILITY --->
				<cfset variables.talib.cdlHangingMan(arguments.startIdx,arguments.endIdx,local.srtArrays.aryOpen,local.srtArrays.aryHigh, local.srtArrays.aryLow, local.srtArrays.aryClose,Minteger1,Minteger2,local.srtArrays.aryOutCandle) />
				<!--- <cfset local.lookback = variables.talib.cdlAbandonedBabyLookback(arguments.optInTimePeriod) /> --->
			</cfcase>		
			
			<cfcase value="Harami"> <!--- LOW RELIABILITY --->
				<cfset variables.talib.cdlHarami(arguments.startIdx,arguments.endIdx,local.srtArrays.aryOpen,local.srtArrays.aryHigh, local.srtArrays.aryLow, local.srtArrays.aryClose,Minteger1,Minteger2,local.srtArrays.aryOutCandle) />
				<!--- <cfset local.lookback = variables.talib.cdlAbandonedBabyLookback(arguments.optInTimePeriod) /> --->
			</cfcase>		
			
			<cfcase value="HaramiCross"> <!--- MEDIUM RELIABILITY --->
				<cfset variables.talib.cdlHaramiCross(arguments.startIdx,arguments.endIdx,local.srtArrays.aryOpen,local.srtArrays.aryHigh, local.srtArrays.aryLow, local.srtArrays.aryClose,Minteger1,Minteger2,local.srtArrays.aryOutCandle) />
				<!--- <cfset local.lookback = variables.talib.cdlAbandonedBabyLookback(arguments.optInTimePeriod) /> --->
			</cfcase>	
			
			<cfcase value="HighWave"> <!--- UNKNOWN --->
				<cfset variables.talib.cdlHignWave(arguments.startIdx,arguments.endIdx,local.srtArrays.aryOpen,local.srtArrays.aryHigh, local.srtArrays.aryLow, local.srtArrays.aryClose,Minteger1,Minteger2,local.srtArrays.aryOutCandle) />
				<!--- <cfset local.lookback = variables.talib.cdlHignWaveLookback(arguments.optInTimePeriod) /> --->
			</cfcase>		
			
			<cfcase value="Hikkake"> <!--- UNKNOWN --->
				<cfset variables.talib.cdlHikkake(arguments.startIdx,arguments.endIdx,local.srtArrays.aryOpen,local.srtArrays.aryHigh, local.srtArrays.aryLow, local.srtArrays.aryClose,Minteger1,Minteger2,local.srtArrays.aryOutCandle) />
				<!--- <cfset local.lookback = variables.talib.cdlHikkakeLookback(arguments.optInTimePeriod) /> --->
			</cfcase>		
			
			<cfcase value="HikkakeMod">
				<cfset variables.talib.cdlHikkakeMod(arguments.startIdx,arguments.endIdx,local.srtArrays.aryOpen,local.srtArrays.aryHigh, local.srtArrays.aryLow, local.srtArrays.aryClose,Minteger1,Minteger2,local.srtArrays.aryOutCandle) />
				<!--- <cfset local.lookback = variables.talib.cdlHikkakeModLookback(arguments.optInTimePeriod) /> --->
			</cfcase>		
			<cfcase value="HomingPigeon"> <!--- MEDIUM RELIABILITY --->
				<cfset variables.talib.cdlHomingPigeon(arguments.startIdx,arguments.endIdx,local.srtArrays.aryOpen,local.srtArrays.aryHigh, local.srtArrays.aryLow, local.srtArrays.aryClose,Minteger1,Minteger2,local.srtArrays.aryOutCandle) />
				<!--- <cfset local.lookback = variables.talib.cdlHomingPigeonLookback(arguments.optInTimePeriod) /> --->
			</cfcase>	
			
			<cfcase value="Identical3Crows"> <!--- UNKNOWN --->
				<cfset variables.talib.cdlIdentical3Crows(arguments.startIdx,arguments.endIdx,local.srtArrays.aryOpen,local.srtArrays.aryHigh, local.srtArrays.aryLow, local.srtArrays.aryClose,Minteger1,Minteger2,local.srtArrays.aryOutCandle) />
				<!--- <cfset local.lookback = variables.talib.cdlIdentical3CrowsLookback(arguments.optInTimePeriod) /> --->
			</cfcase>	
						
			<cfcase value="InNeck"> <!--- MEDIUM RELIABILITY --->
				<cfset variables.talib.cdlInNeck(arguments.startIdx,arguments.endIdx,local.srtArrays.aryOpen,local.srtArrays.aryHigh, local.srtArrays.aryLow, local.srtArrays.aryClose,Minteger1,Minteger2,local.srtArrays.aryOutCandle) />
				<!--- <cfset local.lookback = variables.talib.cdlInNeckLookback(arguments.optInTimePeriod) /> --->
			</cfcase>	
			
			<cfcase value="InvertedHammer"> <!--- LOW RELIABILITY --->
				<cfset variables.talib.cdlInvertedHammer(arguments.startIdx,arguments.endIdx,local.srtArrays.aryOpen,local.srtArrays.aryHigh, local.srtArrays.aryLow, local.srtArrays.aryClose,Minteger1,Minteger2,local.srtArrays.aryOutCandle) />
				<!--- <cfset local.lookback = variables.talib.cdlInvertedHammerLookback(arguments.optInTimePeriod) /> --->
			</cfcase>	
			
			<cfcase value="Kicking"> <!--- HIGH RELIABILITY --->
				<cfset variables.talib.cdlKicking(arguments.startIdx,arguments.endIdx,local.srtArrays.aryOpen,local.srtArrays.aryHigh, local.srtArrays.aryLow, local.srtArrays.aryClose,Minteger1,Minteger2,local.srtArrays.aryOutCandle) />
				<!--- <cfset local.lookback = variables.talib.cdlKickingLookback(arguments.optInTimePeriod) /> --->
			</cfcase>	
			
			<cfcase value="KickingByLength">
				<cfset variables.talib.cdlKickingByLength(arguments.startIdx,arguments.endIdx,local.srtArrays.aryOpen,local.srtArrays.aryHigh, local.srtArrays.aryLow, local.srtArrays.aryClose,Minteger1,Minteger2,local.srtArrays.aryOutCandle) />
				<!--- <cfset local.lookback = variables.talib.cdlKickingByLengthLookback(arguments.optInTimePeriod) /> --->
			</cfcase>	
			
			
			<cfcase value="LadderBottom"> <!--- MEDIUM RELIABILITY --->
				<cfset variables.talib.cdlLadderBottom(arguments.startIdx,arguments.endIdx,local.srtArrays.aryOpen,local.srtArrays.aryHigh, local.srtArrays.aryLow, local.srtArrays.aryClose,Minteger1,Minteger2,local.srtArrays.aryOutCandle) />
				<!--- <cfset local.lookback = variables.talib.cdlLadderBottomLookback(arguments.optInTimePeriod) /> --->
			</cfcase>	
			
			<cfcase value="LongLeggedDoji"> <!--- MEDIUM RELIABILITY --->
				<cfset variables.talib.cdlLongLeggedDoji(arguments.startIdx,arguments.endIdx,local.srtArrays.aryOpen,local.srtArrays.aryHigh, local.srtArrays.aryLow, local.srtArrays.aryClose,Minteger1,Minteger2,local.srtArrays.aryOutCandle) />
				<!--- <cfset local.lookback = variables.talib.cdlLongLeggedDojiLookback(arguments.optInTimePeriod) /> --->
			</cfcase>	
			
			<cfcase value="LongLine"> <!--- UNKNOWN --->
				<cfset variables.talib.cdlIdentical3Crows(arguments.startIdx,arguments.endIdx,local.srtArrays.aryOpen,local.srtArrays.aryHigh, local.srtArrays.aryLow, local.srtArrays.aryClose,Minteger1,Minteger2,local.srtArrays.aryOutCandle) />
				<!--- <cfset local.lookback = variables.talib.cdlIdentical3CrowsLookback(arguments.optInTimePeriod) /> --->
			</cfcase>	
			
			<cfcase value="Marubozu"> <!--- LOW RELIABILITY --->
				<cfset variables.talib.cdlMarubozu(arguments.startIdx,arguments.endIdx,local.srtArrays.aryOpen,local.srtArrays.aryHigh, local.srtArrays.aryLow, local.srtArrays.aryClose,Minteger1,Minteger2,local.srtArrays.aryOutCandle) />
				<!--- <cfset local.lookback = variables.talib.cdlMarubozuLookback(arguments.optInTimePeriod) /> --->
			</cfcase>	
			
			<cfcase value="MatchingLow"> <!--- MEDIUM RELIABILITY --->
				<cfset variables.talib.cdlMatchingLow(arguments.startIdx,arguments.endIdx,local.srtArrays.aryOpen,local.srtArrays.aryHigh, local.srtArrays.aryLow, local.srtArrays.aryClose,Minteger1,Minteger2,local.srtArrays.aryOutCandle) />
				<!--- <cfset local.lookback = variables.talib.cdlMatchingLowLookback(arguments.optInTimePeriod) /> --->
			</cfcase>	
			
			<cfcase value="OnNeck"> <!--- MEDIUM RELIABILITY --->
				<cfset variables.talib.cdlOnNeck(arguments.startIdx,arguments.endIdx,local.srtArrays.aryOpen,local.srtArrays.aryHigh, local.srtArrays.aryLow, local.srtArrays.aryClose,Minteger1,Minteger2,local.srtArrays.aryOutCandle) />
				<!--- <cfset local.lookback = variables.talib.cdlOnNeckLookback(arguments.optInTimePeriod) /> --->
			</cfcase>	
			
			<cfcase value="Piercing"> <!--- HIGH RELIABILITY --->
				<cfset variables.talib.cdlPiercing(arguments.startIdx,arguments.endIdx,local.srtArrays.aryOpen,local.srtArrays.aryHigh, local.srtArrays.aryLow, local.srtArrays.aryClose,Minteger1,Minteger2,local.srtArrays.aryOutCandle) />
				<!--- <cfset local.lookback = variables.talib.cdlPiercingLookback(arguments.optInTimePeriod) /> --->
			</cfcase>	
			
			<cfcase value="RickshawMan"> <!--- UNKNOWN --->
				<cfset variables.talib.cdlRickshawMan(arguments.startIdx,arguments.endIdx,local.srtArrays.aryOpen,local.srtArrays.aryHigh, local.srtArrays.aryLow, local.srtArrays.aryClose,Minteger1,Minteger2,local.srtArrays.aryOutCandle) />
				<!--- <cfset local.lookback = variables.talib.cdlIdentical3CrowsLookback(arguments.optInTimePeriod) /> --->
			</cfcase>	
			
			<cfcase value="RiseFall3Methods"> <!--- HIGH RELIABILITY --->
				<cfset variables.talib.cdlRiseFall3Methods(arguments.startIdx,arguments.endIdx,local.srtArrays.aryOpen,local.srtArrays.aryHigh, local.srtArrays.aryLow, local.srtArrays.aryClose,Minteger1,Minteger2,local.srtArrays.aryOutCandle) />
				<!--- <cfset local.lookback = variables.talib.cdlRiseFall3MethodsLookback(arguments.optInTimePeriod) /> --->
			</cfcase>	
			
			<cfcase value="SeperatingLines"> <!--- LOW RELIABILITY --->
				<cfset variables.talib.cdlSeperatingLines(arguments.startIdx,arguments.endIdx,local.srtArrays.aryOpen,local.srtArrays.aryHigh, local.srtArrays.aryLow, local.srtArrays.aryClose,Minteger1,Minteger2,local.srtArrays.aryOutCandle) />
				<!--- <cfset local.lookback = variables.talib.cdlSeperatingLinesLookback(arguments.optInTimePeriod) /> --->
			</cfcase>	
			
			<cfcase value="ShootingStar"> <!--- LOW RELIABILITY --->
				<cfset  variables.talib.cdlShootingStar(arguments.startIdx,arguments.endIdx,local.srtArrays.aryOpen,local.srtArrays.aryHigh, local.srtArrays.aryLow, local.srtArrays.aryClose,Minteger1,Minteger2,local.srtArrays.aryOutCandle) />
				<!--- <cfset local.lookback = variables.talib.cdlShootingStarLookback(arguments.optInTimePeriod) /> --->
			</cfcase>	
			
			<cfcase value="ShortLine"> <!--- UNKNOWN --->
				<cfset  variables.talib.cdlShortLine(arguments.startIdx,arguments.endIdx,local.srtArrays.aryOpen,local.srtArrays.aryHigh, local.srtArrays.aryLow, local.srtArrays.aryClose,Minteger1,Minteger2,local.srtArrays.aryOutCandle) />
				<!--- <cfset local.lookback = variables.talib.cdlShortLineLookback(arguments.optInTimePeriod) /> --->
			</cfcase>	
			
			<cfcase value="SpinningTop"> <!--- UNKNOWN --->
				<cfset  variables.talib.cdlSpinningTop(arguments.startIdx,arguments.endIdx,local.srtArrays.aryOpen,local.srtArrays.aryHigh, local.srtArrays.aryLow, local.srtArrays.aryClose,Minteger1,Minteger2,local.srtArrays.aryOutCandle) />
				<!--- <cfset local.lookback = variables.talib.cdlSpinningTopLookback(arguments.optInTimePeriod) /> --->
			</cfcase>	
			
			<cfcase value="StalledPattern"> <!--- UNKNOWN --->
				<cfset  variables.talib.cdlStalledPattern(arguments.startIdx,arguments.endIdx,local.srtArrays.aryOpen,local.srtArrays.aryHigh, local.srtArrays.aryLow, local.srtArrays.aryClose,Minteger1,Minteger2,local.srtArrays.aryOutCandle) />
				<!--- <cfset local.lookback = variables.talib.cdlStalledPatternLookback(arguments.optInTimePeriod) /> --->
			</cfcase>	
			
			<cfcase value="StickSandwich"> <!--- MEDIUM RELIABILITY --->
				<cfset  variables.talib.cdlStickSandwhich(arguments.startIdx,arguments.endIdx,local.srtArrays.aryOpen,local.srtArrays.aryHigh, local.srtArrays.aryLow, local.srtArrays.aryClose,Minteger1,Minteger2,local.srtArrays.aryOutCandle) />
				<!--- <cfset local.lookback = variables.talib.cdlStickSandwhichLookback(arguments.optInTimePeriod) /> --->
			</cfcase>	
			
			<cfcase value="Takuri"> <!--- UNKNOWN --->
				<cfset  variables.talib.cdlTakuri(arguments.startIdx,arguments.endIdx,local.srtArrays.aryOpen,local.srtArrays.aryHigh, local.srtArrays.aryLow, local.srtArrays.aryClose,Minteger1,Minteger2,local.srtArrays.aryOutCandle) />
				<!--- <cfset local.lookback = variables.talib.cdlTakuriLookback(arguments.optInTimePeriod) /> --->
			</cfcase>	
			
			<cfcase value="TasukiGap"> <!--- MEDIUM RELIABILITY --->
				<cfset  variables.talib.cdlTasukiGap(arguments.startIdx,arguments.endIdx,local.srtArrays.aryOpen,local.srtArrays.aryHigh, local.srtArrays.aryLow, local.srtArrays.aryClose,Minteger1,Minteger2,local.srtArrays.aryOutCandle) />
				<!--- <cfset local.lookback = variables.talib.cdlTasukiGapLookback(arguments.optInTimePeriod) /> --->
			</cfcase>	
			
			<cfcase value="Thrusting"> <!--- LOW RELIABILITY --->
				<cfset  variables.talib.cdlThrusting(arguments.startIdx,arguments.endIdx,local.srtArrays.aryOpen,local.srtArrays.aryHigh, local.srtArrays.aryLow, local.srtArrays.aryClose,Minteger1,Minteger2,local.srtArrays.aryOutCandle) />
				<!--- <cfset local.lookback = variables.talib.cdlThrustingLookback(arguments.optInTimePeriod) /> --->
			</cfcase>	
			
			<cfcase value="Tristar"> <!--- MEDIUM RELIABILITY --->
				<cfset  variables.talib.cdlTristar(arguments.startIdx,arguments.endIdx,local.srtArrays.aryOpen,local.srtArrays.aryHigh, local.srtArrays.aryLow, local.srtArrays.aryClose,Minteger1,Minteger2,local.srtArrays.aryOutCandle) />
				<!--- <cfset local.lookback = variables.talib.cdlTristar(arguments.optInTimePeriod) /> --->
			</cfcase>	
			
			<cfcase value="Unique3River"> <!--- MEDIUM RELIABILITY --->
				<cfset  variables.talib.cdlUnique3River(arguments.startIdx,arguments.endIdx,local.srtArrays.aryOpen,local.srtArrays.aryHigh, local.srtArrays.aryLow, local.srtArrays.aryClose,Minteger1,Minteger2,local.srtArrays.aryOutCandle) />
				<!--- <cfset local.lookback = variables.talib.cdlUnique3RiverLookback(arguments.optInTimePeriod) /> --->
			</cfcase>	
			
			<cfcase value="UpsideGap2Crows"> <!--- HIGH RELIABILITY --->
				<cfset  variables.talib.cdlUpsideGap2Crows(arguments.startIdx,arguments.endIdx,local.srtArrays.aryOpen,local.srtArrays.aryHigh, local.srtArrays.aryLow, local.srtArrays.aryClose,Minteger1,Minteger2,local.srtArrays.aryOutCandle) />
				<!--- <cfset local.lookback = variables.talib.cdlUpsideGap2CrowsLookback(arguments.optInTimePeriod) /> --->
			</cfcase>	
			
			<cfcase value="XSideGap3Methods">
				<cfset  variables.talib.cdlXSideGap3Methods(arguments.startIdx,arguments.endIdx,local.srtArrays.aryOpen,local.srtArrays.aryHigh, local.srtArrays.aryLow, local.srtArrays.aryClose,Minteger1,Minteger2,local.srtArrays.aryOutCandle) />
				<!--- <cfset local.lookback = variables.talib.cdlXSideGap3Methods(arguments.optInTimePeriod) /> --->
			</cfcase>	
					
			<cfdefaultcase>
				<cfthrow type="Application" message="Invalid Candle Type">
			</cfdefaultcase>
		</cfswitch>
		<cfcatch type="application">
		   <h3>Invalid indicator type passed to GetIndicator</h3>
		</cfcatch>
		</cftry>
		<!--- 
		process candle data  
		--->
		<cfset local.returndata.outData = AdjustArray(outputArray:local.srtArrays.aryOutCandle,outBegIdx:MInteger1.value) />
		<cfset local.returndata.dataType = arguments.Candle />
		<cfreturn  local.returndata />
	</cffunction>
	
	<cffunction name="AdjustArray" description="" access="private" displayname="" output="false" returntype="Array">
		<cfargument name="outputArray" required="true" />
		<cfargument name="outBegIdx" required="true"  />
		<!--- data type conversion  --->
		<cfset cfList 	= ArraytoList(arguments.outputArray) >
		<cfset cfArray 	= ListToArray(cfList, ",", true) >
		<!--- pad the top of the returned array so it matches the dates  --->
		<cfloop from="1" to="#arguments.outBegIdx#" index="i">
			<cfset ArrayPrepend(cfArray,"0")>
		</cfloop>
		<!--- trim off the extra cells from the bottom of the array  --->
	 	<cfloop from="1" to="#arguments.outBegIdx#" index="i">
			<cfset ArrayDeleteAt(cfArray,cfArray.size() )>
		</cfloop>   
		<cfreturn cfArray />
	</cffunction>

	<cffunction name="LRSDelta" description="get change in LRSlope" access="public" displayname="" output="false" returntype="Array">
		<cfargument name="qryData" required="true" />
		<cfset var local = structNew() />
		<cfset local.qryLen = arguments.qryData.recordcount />
		<cfset local.dataArray = ArrayNew(1) />
		<cfset local.dataArray[1] = 0 />
		<cfloop from="2" to="#local.qryLen#" index="i">
			<cfset local.dataArray[i] = arguments.qrydata.linearRegSlope[i-1]- arguments.qrydata.linearRegSlope[i]> 
		</cfloop>
		<cfreturn local.dataArray />
	</cffunction>

	<cffunction name="RVI" description="Relative Volatility Index" access="public" displayname="" output="false" returntype="Array">
		<!--- 
		The calculation is identical  to the Relative Strength Index (RSI) except that the RVI measures the 
		standard deviation of daily price changes rather than absolute price changes.
					   100
	    RSI = 100 - --------
	                 1 + RS
	    RS = Average Gain / Average Loss
	
						100
		RVI = 100 - ----------
						1 + SD
		Formula Parameters:      Default:
	    Period                              10
	    UpperBand                           80
	    LowerBand                           20
	
		set d,u = 0
		if close > close[1]
			u = stddev(x1-9 prev (close) )
			d = 0 
		else
			d = stddev(x1-9prev (close) )
			u = 0
			
		upavg = upavg x (n-1) +up 
				---------
					n
					 
		dnavg = dnavg x (n-1) +dn
					------
					n
					
		RVIorg = 100 x (upavg / upavg - dnagv)
		
		RVI = (RVIorg(high) + RVIorg(lo) ) / 2  
		Only act on buy signals when RVI > 50.
	    Only act on sell signals when RVI < 50.
	    If a buy signal is ignored, enter long if RVI > 60.
	    If a sell signal is ignored, enter short if RVI < 40.
	    Close a long position if RVI falls below 40.
	    Close a short position if RVI rises above 60.
	 --->	
		<cfreturn />
	</cffunction>

	<cffunction name="convertHK" description="" access="public" displayname="" output="false" returntype="Query">
		<cfargument name="qrydata"  required="true">
		<cfset var local = structNew() />
		
		<cfset local.hkquery = duplicate(arguments.qrydata) >
		<cfscript> 
			local.qryrows = arguments.qrydata.recordcount;
			local.open 	= arguments.qrydata['open'][1];
			local.high 	= arguments.qrydata['high'][1];
			local.low 	= arguments.qrydata['low'][1];
			local.close = arguments.qrydata['close'][1];
			local.openp	= arguments.qrydata['open'][1]; 
			local.closep = arguments.qrydata['close'][1];
			//HAO = (HAO-1 + HAC-1) / 2
		    //HAC = (O + H + L + C) / 4
	    	//HAH = Highest(H, HAO, HAC)
	    	//HAL = Lowest(L, HAO, HAC)
			//Convert data to XML and append
	       	for(i=2;i<=local.qryrows;i++){ 
	       		local.HAopen 	= (local.closep + local.openp) / 2;
	       		local.HAclose 	= (local.open + local.high + local.low + local.close) / 4;
	       		local.HAhigh 	= max(local.high, local.HAopen);
	       		local.high 	= max(local.HAhigh, local.HAclose);
	       		local.HAlow	= min(local.low, local.HAopen);
	       		local.HAlow	= min(local.HAlow, local.HAclose);
				local.hkquery["open"][i-1] 	= decimalformat(local.HAopen);
				local.hkquery["high"][i-1]	= decimalformat(local.HAhigh);
				local.hkquery["low"][i-1] 	= decimalformat(local.HAlow);
				local.hkquery["close"][i-1]	= decimalformat(local.HAclose);
	
	       		local.openp		= local.HAopen;
	       		local.closep	= local.HAclose;
	       		local.open		= qrydata['open'][i];
	       		local.close		= qrydata['close'][i];
	       		local.high		= qrydata['high'][i];
	       		local.low		= qrydata['low'][i];
	       	}
				</cfscript>
		<cfreturn local.hkquery />
	</cffunction>

	<cffunction  name="ProcessArrays">
		<cfargument name="qryPrices" 	type="query" required="true"  hint="the array of prices to base on"/>
		<cfscript>
		var local = structNew();
		local.aryDate 	= ArrayNew(1);
		local.aryOut 	= ArrayNew(1);
		local.aryOpen 	= ArrayNew(1);
		local.aryHigh 	= ArrayNew(1);
		local.aryLow 	= ArrayNew(1);
		local.aryClose 	= ArrayNew(1);
		local.aryOutCandle 	= ArrayNew(1);
		for (
		 local.intRow = 1 ;
		 local.intRow LTE qryPrices.RecordCount ;
		 local.intRow = (local.intRow + 1) )
		 {
			local.aryOut[local.introw]			= 0;
			local.aryOutCandle[local.introw]	= 0;
			local.aryDate[local.introw]			= arguments.qryPrices['DateOne'][local.introw]; 
			local.aryOpen[local.introw]			= arguments.qryPrices['open'][local.introw]; 
			local.aryHigh[local.introw]			= arguments.qryPrices['high'][local.introw]; 
			local.aryLow[local.introw]			= arguments.qryPrices['low'][local.introw];
			local.aryClose[local.introw]		= arguments.qryPrices['close'][local.introw];
		}
		local.aryHigh 	= javacast("double[]",local.aryHigh);
		local.aryLow 	= javacast("double[]",local.aryLow);
		local.aryClose 	= javacast("double[]",local.aryClose);
		local.aryOut	= javacast("double[]",local.aryOut);
		local.aryOpen 	= javacast("double[]",local.aryOpen);
		local.aryOutCandle = javacast("int[]",local.aryOutCandle);
		</cfscript>
		<cfreturn local />
	</cffunction>

	<cffunction name="GetMAType" description="" access="public" displayname="" output="false" returntype="Any">
	<cfscript>
	var TypeString = "Sma";	
	var instance = server.loader.create("com.tictactec.ta.lib.MAType");  
	//var MAinstance = createObject("java","com.tictactec.ta.lib.MAType");
	return instance;
	</cfscript>
	<cfreturn />
	</cffunction>
	<cffunction  name="DoJavaCast">
		<cfargument name="argStruct" 	type="Struct" required="true"  hint="the array of prices to base on"/>
		<cfscript>
		arguments.argStruct.startIdx 		= javacast("int",arguments.argStruct.startIdx);
	    arguments.argStruct.endIdx 			= javacast("int",arguments.argStruct.endIdx);
	    arguments.argStruct.outBegIdx 		= javacast("int",arguments.argStruct.outBegIdx);
	    arguments.argStruct.outNBElement 	= javacast("int",arguments.argStruct.outNBElement);
	    arguments.argStruct.optInTimePeriod = javacast("int",arguments.argStruct.optInTimePeriod);
		arguments.argStruct.optInPenetration = javacast("double",arguments.argStruct.optInPenetration);
	    </cfscript>
	</cffunction>

	<cffunction  name="Dump">
		<cfargument name="target" type="Any" required="true"  hint="the object to be dumped"/>
		<cfargument name="abort"  type="Boolean" required="false" default="false" hint="if true, performs cfabort" />
		<cfargument name="theLabel"  type="String" required="false" default="cfdump label" />
		<cfdump label="#arguments.theLabel#" var="#arguments.target#" />
		<cfif arguments.abort>
			<cfabort>
		</cfif>
		<cfreturn />
	</cffunction>
<!--- 

AD                  Chaikin A/D Line
ADOSC               Chaikin A/D Oscillator
ADX                 Average Directional Movement Index
ADXR                Average Directional Movement Index Rating
APO                 Absolute Price Oscillator
AROON               Aroon
AROONOSC            Aroon Oscillator
ATR                 Average True Range
AVGPRICE            Average Price
BBANDS              Bollinger Bands
BETA                Beta
CCI                 Commodity Channel Index
CMO                 Chande Momentum Oscillator
DX                  Directional Movement Index
EMA                 Exponential Moving Average
KAMA                Kaufman Adaptive Moving Average
LINEARREG           Linear Regression
LINEARREG_ANGLE     Linear Regression Angle
LINEARREG_INTERCEPT Linear Regression Intercept
LINEARREG_SLOPE     Linear Regression Slope
MA                  Moving average
MACD                Moving Average Convergence/Divergence
MACDEXT             MACD with controllable MA type
MACDFIX             Moving Average Convergence/Divergence Fix 12/26
MAMA                MESA Adaptive Moving Average
MAVP                Moving average with variable period
MFI                 Money Flow Index
MINUS_DI            Minus Directional Indicator
MINUS_DM            Minus Directional Movement
MOM                 Momentum
OBV                 On Balance Volume
PLUS_DI             Plus Directional Indicator
PLUS_DM             Plus Directional Movement
PPO                 Percentage Price Oscillator
ROC                 Rate of change : ((price/prevPrice)-1)*100
ROCP                Rate of change Percentage: (price-prevPrice)/prevPrice
ROCR                Rate of change ratio: (price/prevPrice)
ROCR100             Rate of change ratio 100 scale: (price/prevPrice)*100
RSI                 Relative Strength Index
SAR                 Parabolic SAR
SAREXT              Parabolic SAR - Extended
SMA                 Simple Moving Average
STOCH               Stochastic
STOCHF              Stochastic Fast
STOCHRSI            Stochastic Relative Strength Index
TRANGE              True Range
TRIMA               Triangular Moving Average
TRIX                1-day Rate-Of-Change (ROC) of a Triple Smooth EMA
TSF                 Time Series Forecast
TYPPRICE            Typical Price
ULTOSC              Ultimate Oscillator
VAR                 Variance
WCLPRICE            Weighted Close Price
WILLR               Williams' %R
WMA                 Weighted Moving Average 
--->
</cfcomponent>