<cfcomponent output="true">
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

<!--- 
int outBegIdx;
int outNbElement;
double[] inputClose = new double [] { 75.2, 76.5, 75.8, 75.3, 75.0, 74.5 }; //this is just for example. inputClose array will be generated by you in you app.
double[] output = new double[inputClose.Length];
TA.Lib.Core.SMA(0, inputClose.Length - 1, inputClose, count, out outBegIdx, out outNbElement, output);
//output will be SMA values 

 public RetCode sma( int startIdx,
      int endIdx,
      double inReal[],
      int optInTimePeriod,
      MInteger outBegIdx,
      MInteger outNBElement,
      double outReal[] )
   {
      if( startIdx < 0 )
         return RetCode.OutOfRangeStartIndex ;
      if( (endIdx < 0) || (endIdx < startIdx))
         return RetCode.OutOfRangeEndIndex ;
      if( (int)optInTimePeriod == ( Integer.MIN_VALUE ) )
         optInTimePeriod = 30;
      else if( ((int)optInTimePeriod < 2) || ((int)optInTimePeriod > 100000) )
         return RetCode.BadParam ;
      return TA_INT_SMA ( startIdx, endIdx,
         inReal, optInTimePeriod,
         outBegIdx, outNBElement, outReal );
   }
   RetCode TA_INT_SMA( int startIdx,
      int endIdx,
      double inReal[],
      int optInTimePeriod,
      MInteger outBegIdx,
      MInteger outNBElement,
      double outReal[] )
   {
      double periodTotal, tempReal;
      int i, outIdx, trailingIdx, lookbackTotal;
      lookbackTotal = (optInTimePeriod-1);
      if( startIdx < lookbackTotal )
         startIdx = lookbackTotal;
      if( startIdx > endIdx )
      {
         outBegIdx.value = 0 ;
         outNBElement.value = 0 ;
         return RetCode.Success ;
      }
      periodTotal = 0;
      trailingIdx = startIdx-lookbackTotal;
      i=trailingIdx;
      if( optInTimePeriod > 1 )
      {
         while( i < startIdx )
            periodTotal += inReal[i++];
      }
      outIdx = 0;
      do
      {
         periodTotal += inReal[i++];
         tempReal = periodTotal;
         periodTotal -= inReal[trailingIdx++];
         outReal[outIdx++] = tempReal / optInTimePeriod;
      } while( i <= endIdx );
      outNBElement.value = outIdx;
      outBegIdx.value = startIdx;
      return RetCode.Success ;
   }
--->

<cffunction  name="sma" hint="simple moving average - array of prices you want to average ie high, low, close">
	<!--- 
		int outBegIdx;
		int outNbElement;
		double[] inputClose = new double [] { 75.2, 76.5, 75.8, 75.3, 75.0, 74.5 }; //this is just for example. inputClose array will be generated by you in you app.
		double[] output = new double[inputClose.Length];
		TA.Lib.Core.SMA(0, inputClose.Length - 1, inputClose, count, out outBegIdx, out outNbElement, output);
       //output will be SMA values --->
	<!--- works <cfargument name="startIdx" type="Numeric"  default="1" required="false"  hint="where to start calculating"/> 
	<cfargument name="aryPrices" type="Array" required="true"  hint="the array of prices to base on"/>
	<cfargument name="endIdx" type="Numeric"  default="10" required="false" />
	<cfargument name="maLen" type="Numeric"  default="2" required="false" />
	<cfargument name="optInTimePeriod" type="Numeric"  default="2" required="false" hint="length of MA" />
	<cfargument name="outBegIdx" type="Numeric"  default="1" required="false" />
	<cfargument name="outNBElement" type="Numeric"  default="1" required="false" /> --->
	<cfargument name="startIdx" 	type="Numeric"  required="false" default="1" hint="where to start calculating"/> 
	<cfargument name="aryPrices" 	type="Array" 	required="true"  hint="the array of prices to base on"/>
	<cfargument name="endIdx" 		type="Numeric"  required="false" default="10" />
	<cfargument name="maLen" 		type="Numeric"  required="false" default="3" hint="must be greater than 1"/>
	<cfargument name="optInTimePeriod" type="Numeric"  default="1" required="false" hint="length of MA" />
	<cfargument name="outBegIdx" 	type="Numeric"  default="1" required="false" />
	<cfargument name="outNBElement" type="Numeric"  default="1" required="false" />
	<cfscript>
	var local = structNew();
	local.aryOut = ArrayNew(1);
	For (i=1;i LTE arguments.aryPrices.size(); i=i+1)
          local.aryOut[i] = 0;
    /* return local.aryout; */
    arguments.startIdx 		= javacast("int",arguments.startIdx);
    arguments.endIdx 		= javacast("int",arguments.endIdx);
    arguments.outBegIdx 	= javacast("int",arguments.outBegIdx);
    arguments.outNBElement 	= javacast("int",arguments.outNBElement);
    arguments.maLen 		= javacast("int",arguments.maLen);
	local.aryOut 			= javacast("double[]",local.aryout);
	local.aryPrices 		= javacast("double[]",arguments.aryPrices);
	Minteger1  = server.loader.create("com.tictactec.ta.lib.MInteger"); 
	Minteger2  = server.loader.create("com.tictactec.ta.lib.MInteger"); 
	Minteger1.value = 1;
	Minteger2.value = 2;
	/* sma(int, int, double[], int, com.tictactec.ta.lib.MInteger, com.tictactec.ta.lib.MInteger, double[]) */
	</cfscript>
	<!--- JavaCast("int", "1")) --->
	<cfset variables.talib.SMA(arguments.startIdx,arguments.endIdx,local.aryPrices,arguments.maLen,Minteger1,Minteger2,local.aryOut) />
	<cfreturn local.aryOut />
</cffunction>

<cffunction  name="DX" hint="Directional ">
	<cfargument name="startIdx" 	type="Numeric"  default="1" required="false"  hint="where to start calculating"/> 
	<cfargument name="qryPrices" 	type="query" required="true"  hint="the array of prices to base on"/>
	<cfargument name="endIdx" 		type="Numeric"  default="#arguments.qryprices.recordcount - 1#" required="false" />
	<cfargument name="optInTimePeriod" type="Numeric"  default="14" required="false" hint="length of MA" />
	<cfargument name="outBegIdx" 	type="Numeric"  default="1" required="false" />
	<cfargument name="outNBElement" type="Numeric"  default="1" required="false" />
	
	<cfscript>
	var local = structNew();
	local.aryOut 	= ArrayNew(1);
	local.aryHigh 	= ArrayNew(1);
	local.aryLow 	= ArrayNew(1);
	local.aryClose 	= ArrayNew(1);
	</cfscript>
	<cfloop query="arguments.qryPrices">
		<cfset local.aryOut[arguments.qryPrices.currentrow]		= 0 />
		<cfset local.aryHigh[arguments.qryPrices.currentrow]	= arguments.qryPrices.high />
		<cfset local.aryLow[arguments.qryPrices.currentrow]		= arguments.qryPrices.low />
		<cfset local.aryClose[arguments.qryPrices.currentrow]	= arguments.qryPrices.close />
	</cfloop>
	<cfscript>
    arguments.startIdx 	= javacast("int",arguments.startIdx);
    arguments.endIdx 	= javacast("int",arguments.endIdx);
    arguments.outBegIdx = javacast("int",arguments.outBegIdx);
    arguments.outNBElement = javacast("int",arguments.outNBElement);
    arguments.optInTimePeriod = javacast("int",arguments.optInTimePeriod);
	local.aryOut	= javacast("double[]",local.aryout);
	local.aryHigh 	= javacast("double[]",local.aryHigh);
	local.aryLow 	= javacast("double[]",local.aryLow);
	local.aryClose 	= javacast("double[]",local.aryClose);
	Minteger1  = server.loader.create("com.tictactec.ta.lib.MInteger"); 
	Minteger2  = server.loader.create("com.tictactec.ta.lib.MInteger"); 
 	Minteger1.value = 1;
	Minteger2.value = 2;
	/* dx(int startIdx, int endIdx, double[] inHigh, double[] inLow, double[] inClose, int optInTimePeriod, MInteger outBegIdx, MInteger outNBElement, double[] outReal)  */
	</cfscript>
	<!--- JavaCast("int", "1")) --->
	<cfset variables.talib.DX(arguments.startIdx,arguments.endIdx,local.aryHigh, local.aryLow, local.aryClose,arguments.optInTimePeriod,Minteger1,Minteger2,local.aryOut) />
	<cfreturn local.aryOut />
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

<cffunction name="CandleSticksFunction" description="" access="public" displayname="" output="false" returntype="Numeric">
	<!--- 
	> 0 the bullish version of the pattern detected (price trend interpreted going up)
	= 0 No pattern detected
	< 0 the bearish version of the pattern detected (price trend interpreted going down)
	 --->
	<cfreturn />
</cffunction>

<cffunction  name="ADX">
	<cfargument name="startIdx" 	type="Numeric"  default="1" required="false"  hint="where to start calculating"/> 
	<cfargument name="qryPrices" 	type="query" required="true"  hint="the array of prices to base on"/>
	<cfargument name="endIdx" 		type="Numeric"  default="#arguments.qryprices.recordcount - 1#" required="false" />
	<cfargument name="optInTimePeriod" type="Numeric"  default="14" required="false" hint="length of MA" />
	<cfargument name="outBegIdx" 	type="Numeric"  default="1" required="false" />
	<cfargument name="outNBElement" type="Numeric"  default="1" required="false" />
	<cfscript>
	var local = structNew();
	srtArrays = ProcessArrays(qryPrices: arguments.qryPrices);
	DoJavaCast(arguments);
    Minteger1  = server.loader.create("com.tictactec.ta.lib.MInteger"); 
	Minteger2  = server.loader.create("com.tictactec.ta.lib.MInteger"); 
 	Minteger1.value = 1;
	Minteger2.value = 2;
	/* dx(int startIdx, int endIdx, double[] inHigh, double[] inLow, double[] inClose, int optInTimePeriod, MInteger outBegIdx, MInteger outNBElement, double[] outReal)  */
	</cfscript>
	<!--- JavaCast("int", "1")) --->
	<cfset variables.talib.ADX(arguments.startIdx,arguments.endIdx,srtArrays.aryHigh, srtArrays.aryLow, srtArrays.aryClose,arguments.optInTimePeriod,Minteger1,Minteger2,srtArrays.aryOut) />
	<cfreturn local.aryOut />
</cffunction>

<cffunction  name="CCI">
	<cfargument name="startIdx" 	type="Numeric"  default="1" required="false"  hint="where to start calculating"/> 
	<cfargument name="qryPrices" 	type="query" required="true"  hint="the array of prices to base on"/>
	<cfargument name="endIdx" 		type="Numeric"  default="#arguments.qryprices.recordcount - 1#" required="false" />
	<cfargument name="optInTimePeriod" type="Numeric"  default="14" required="false" hint="length of MA" />
	<cfargument name="outBegIdx" 	type="Numeric"  default="1" required="false" />
	<cfargument name="outNBElement" type="Numeric"  default="1" required="false" />
	<cfscript>
	var local = structNew();
	srtArrays = ProcessArrays(qryPrices: arguments.qryPrices);
	DoJavaCast(arguments);
    Minteger1  = server.loader.create("com.tictactec.ta.lib.MInteger"); 
	Minteger2  = server.loader.create("com.tictactec.ta.lib.MInteger"); 
 	Minteger1.value = 1;
	Minteger2.value = 2;
	/* cci(int startIdx, int endIdx, double[] inHigh, double[] inLow, double[] inClose, int optInTimePeriod, MInteger outBegIdx, MInteger outNBElement, double[] outReal)   */
	</cfscript>
	<!--- JavaCast("int", "1")) --->
	<cfset variables.talib.CCI(arguments.startIdx, arguments.endIdx, srtArrays.aryHigh, srtArrays.aryLow, srtArrays.aryClose,arguments.optInTimePeriod,Minteger1,Minteger2,srtArrays.aryOut) />
	<cfreturn srtArrays.aryOut />
</cffunction>

<cffunction  name="GetIndicator">
	<!--- data should be passed into the function oldest first --->
	<cfargument name="Indicator" 	type="String"  required="true" />
	<cfargument name="startIdx" 	type="Numeric"  default="0" required="false"  hint="where to start calculating"/> 
	<cfargument name="qryPrices" 	type="query" required="true"  hint="the array of prices to base on"/>
	<cfargument name="endIdx" 		type="Numeric"  default="#arguments.qryprices.recordcount-1#" required="false" />
	<cfargument name="optInTimePeriod" type="Numeric"  default="14" required="false" hint="length of MA" />
	<cfargument name="outBegIdx" 	type="Numeric"  default="1" required="false" />
	<cfargument name="outNBElement" type="Numeric"  default="1" required="false" />
	
	<cfscript>
	var local = structNew();
	var returndata = Structnew();
	local.srtArrays = ProcessArrays(qryPrices: arguments.qryPrices);
	/* arguments is a struct so it's passed by reference */
	DoJavaCast(arguments);
    Minteger1  = server.loader.create("com.tictactec.ta.lib.MInteger"); 
	Minteger2  = server.loader.create("com.tictactec.ta.lib.MInteger"); 
	Minteger1.value = 0;
	Minteger2.value = 0;
	
	/* 	linearReg(int startIdx, int endIdx, float[] inReal, int optInTimePeriod, MInteger outBegIdx, MInteger outNBElement, double[] outReal)    */
	</cfscript>
	<cftry>
	<cfswitch expression="#arguments.Indicator#">
		<cfcase value="SMA">
			<!--- sma(int startIdx, int endIdx, double[] inReal, int optInTimePeriod, MInteger outBegIdx, MInteger outNBElement, double[] outReal)   --->
			<cfset local.result = variables.talib.sma(arguments.startIdx,arguments.endIdx, local.srtArrays.aryClose, arguments.optInTimePeriod,Minteger1,Minteger2,local.srtArrays.aryOut) />
			<cfset local.lookback = variables.talib.smaLookback(arguments.optInTimePeriod) />
		</cfcase>
		<cfcase value="DX">
			<!--- 	dx(int startIdx, int endIdx, double[] inHigh, double[] inLow, double[] inClose, int optInTimePeriod, MInteger outBegIdx, MInteger outNBElement, double[] outReal)   --->
			<cfset local.result = variables.talib.DX(arguments.startIdx,arguments.endIdx,local.srtArrays.aryHigh, local.srtArrays.aryLow, local.srtArrays.aryClose,arguments.optInTimePeriod,Minteger1,Minteger2,local.srtArrays.aryOut) />
			<cfset local.lookback = variables.talib.dxLookback(arguments.optInTimePeriod) />
		</cfcase>
		<cfcase value="ADX">
			<!--- adx(int startIdx, int endIdx, double[] inHigh, double[] inLow, double[] inClose, int optInTimePeriod, MInteger outBegIdx, MInteger outNBElement, double[] outReal)   --->
			<cfset local.result = variables.talib.ADX(arguments.startIdx,arguments.endIdx,local.srtArrays.aryHigh, local.srtArrays.aryLow, local.srtArrays.aryClose,arguments.optInTimePeriod,Minteger1,Minteger2,local.srtArrays.aryOut) />
			<cfset local.lookback = variables.talib.adxLookback(arguments.optInTimePeriod) />
		</cfcase>
		<cfcase value="ADXR">
			<!--- adxr(int startIdx, int endIdx, double[] inHigh, double[] inLow, double[] inClose, int optInTimePeriod, MInteger outBegIdx, MInteger outNBElement, double[] outReal)    --->
			<cfset local.result = variables.talib.ADXR(arguments.startIdx,arguments.endIdx,local.srtArrays.aryHigh, local.srtArrays.aryLow, local.srtArrays.aryClose,arguments.optInTimePeriod,Minteger1,Minteger2,local.srtArrays.aryOut) />
			<cfset local.lookback = variables.talib.adxrLookback(arguments.optInTimePeriod) />
		</cfcase>
		<cfcase value="CCI">
			<!--- cci(int startIdx, int endIdx, double[] inHigh, double[] inLow, double[] inClose, int optInTimePeriod, MInteger outBegIdx, MInteger outNBElement, double[] outReal)   --->
			<cfset local.result =  variables.talib.CCI(arguments.startIdx, arguments.endIdx, local.srtArrays.aryHigh, local.srtArrays.aryLow, local.srtArrays.aryClose,arguments.optInTimePeriod,Minteger1,Minteger2,local.srtArrays.aryOut) />
			<cfset local.lookback = variables.talib.cciLookback(arguments.optInTimePeriod) />
		</cfcase>
		<cfcase value="PLUS_DI">
			<!--- plusDI(int startIdx, int endIdx, double[] inHigh, double[] inLow, double[] inClose, int optInTimePeriod, MInteger outBegIdx, MInteger outNBElement, double[] outReal)   --->
			<cfset variables.talib.plusDI(arguments.startIdx,arguments.endIdx,local.srtArrays.aryHigh, local.srtArrays.aryLow, local.srtArrays.aryClose,arguments.optInTimePeriod,Minteger1,Minteger2,local.srtArrays.aryOut) />
		</cfcase>
		<cfcase value="PLUS_DM">
			<!--- plusDM(int startIdx, int endIdx, double[] inHigh, double[] inLow, int optInTimePeriod, MInteger outBegIdx, MInteger outNBElement, double[] outReal)   --->
			<cfset variables.talib.plusDM(arguments.startIdx,arguments.endIdx,local.srtArrays.aryHigh, local.srtArrays.aryLow, arguments.optInTimePeriod,Minteger1,Minteger2,local.srtArrays.aryOut) />
		</cfcase>
		<cfcase value="linearReg">
			<cfset variables.talib.linearReg(arguments.startIdx,arguments.endIdx, local.srtArrays.aryClose, arguments.optInTimePeriod,Minteger1,Minteger2,local.srtArrays.aryOut) />
		</cfcase>
		<cfcase value="linearRegAngle">
			<cfset variables.talib.linearRegAngle(arguments.startIdx,arguments.endIdx, local.srtArrays.aryClose, arguments.optInTimePeriod,Minteger1,Minteger2,local.srtArrays.aryOut) />
		</cfcase>
		<cfcase value="linearRegSlope">
			<cfset variables.talib.linearRegSlope(arguments.startIdx,arguments.endIdx, local.srtArrays.aryClose, arguments.optInTimePeriod,Minteger1,Minteger2,local.srtArrays.aryOut) />
		</cfcase>
		<cfcase value="linearRegIntercept">
			<cfset variables.talib.linearRegIntercept(arguments.startIdx,arguments.endIdx, local.srtArrays.aryClose, arguments.optInTimePeriod,Minteger1,Minteger2,local.srtArrays.aryOut) />
		</cfcase>
		<cfcase value="Momentum">
			<!--- mom(int startIdx, int endIdx, double[] inReal, int optInTimePeriod, MInteger outBegIdx, MInteger outNBElement, double[] outReal)  --->
			<cfset variables.talib.mom(arguments.startIdx,arguments.endIdx, local.srtArrays.aryClose, arguments.optInTimePeriod,Minteger1,Minteger2,local.srtArrays.aryOut) />
		</cfcase>
		<cfcase value="RSI">
			<!--- rsi(int startIdx, int endIdx, double[] inReal, int optInTimePeriod, MInteger outBegIdx, MInteger outNBElement, double[] outReal) --->
			<cfset local.result = variables.talib.rsi(arguments.startIdx,arguments.endIdx, local.srtArrays.aryClose, arguments.optInTimePeriod,Minteger1,Minteger2,local.srtArrays.aryOut) />
			<cfset local.lookback = variables.talib.rsiLookback(arguments.optInTimePeriod) />
		</cfcase>
		<cfcase value="SAR">
			<cfset local.acceleration = 0.02 />
			<cfset local.optInMaximum = 0.2 />
			<!--- (int startIdx, int endIdx, double[] inHigh, double[] inLow, double optInAcceleration, double optInMaximum, MInteger outBegIdx, MInteger outNBElement, double[] outReal)  --->
			<cfset local.result = variables.talib.sar(arguments.startIdx,arguments.endIdx,local.srtArrays.aryHigh,local.srtArrays.aryLow,local.acceration,local.optInMaximum,Minteger1,Minteger2,local.srtArrays.aryOut) />
		</cfcase>
		<cfcase value="Stoch">
		<cfset	local.aryOutSlowK	= javacast("double[]",arrayNew(1) ) />
		<cfset	local.aryOutSlowD 	= javacast("double[]",arrayNew(1) ) />
		<cfset local.optInFastK_Period = 2 />
		<cfset local.optInSlowK_Period = 15 />	
		<cfset local.optInSlowK_MAType = 1 />
		<cfset local.optInSlowD_Period = 5 />
		<cfset local.optInSlowD_MAType = 1 />	
		<!--- stoch(int startIdx, int endIdx, double[] inHigh, 
		double[] inLow, double[] inClose, int optInFastK_Period, int optInSlowK_Period, 
		MAType optInSlowK_MAType, int optInSlowD_Period, MAType optInSlowD_MAType, 
		MInteger outBegIdx, MInteger outNBElement, double[] outSlowK, 
		double[] outSlowD) 
		 --->
		<cfset local.result = variables.talib.sar(arguments.startIdx,arguments.endIdx,local.srtArrays.aryHigh,
		local.srtArrays.aryLow,local.srtArrays.aryClose,local.optInFastK_Period,local.optInSlowK_Period, 
		local.optInSlowK_MAType, local.optInSlowD_Period, local.optInSlowD_MAType, Minteger1, Minteger2,
		local.aryOutSlowK, local.aryOutSlowD ) />
		<cfset returndata.SlowK = local.aryOutSlowK />
		<cfset returndata.SlowD = local.aryOutSlowD />
		</cfcase>
		<cfdefaultcase>
			<cfthrow type="Application" message="Invalid indicator type">
		</cfdefaultcase>
	</cfswitch>
	<cfcatch type="application">
	   <h3>Invalid indicator type passed to GetIndicator</h3>
	</cfcatch>
	</cftry>
	<cfset returndata.outBegIdx = MInteger1.value />
	<cfset returndata.outNBElement = MInteger2.value />
	<cfset foobar = duplicate(local.srtArrays.aryOut) />
	<cfset bar = ArraytoList(foobar) >
	<cfset foo = ListToArray(bar, ",", true) >
	<!--- 'for loop' should stop prior to outNbElement, not dataLen --->
	<!--- outNBElement is the numer of the last cell containing data --->
	<!--- outBegIndex is the number of starting rows to pad with zeros --->
	
	<cfloop from="1" to="#returndata.outBegIdx#" index="i">
		<cfset ArrayPrepend(foo,"0")>
	</cfloop>  
 	<cfloop from="1" to="#returndata.outBegIdx#" index="i">
		<cfset ArrayDeleteAt(foo,foo.size() )>
	</cfloop> 
	
	<cfset returndata.outData = foo />
	<cfset returndata.dataType = arguments.Indicator />
	<cfreturn  foo />
</cffunction>

<cffunction  name="PLUS_DI">
	<cfargument name="startIdx" 	type="Numeric"  default="1" required="false"  hint="where to start calculating"/> 
	<cfargument name="qryPrices" 	type="query" required="true"  hint="the array of prices to base on"/>
	<cfargument name="endIdx" 		type="Numeric"  default="#arguments.qryprices.recordcount - 1#" required="false" />
	<cfargument name="optInTimePeriod" type="Numeric"  default="14" required="false" hint="length of MA" />
	<cfargument name="outBegIdx" 	type="Numeric"  default="1" required="false" />
	<cfargument name="outNBElement" type="Numeric"  default="1" required="false" />
	<cfscript>
	var local = structNew();
	srtArrays = ProcessArrays(qryPrices: arguments.qryPrices);
	dump(local.srtArrays);
	DoJavaCast(arguments);
    Minteger1  = server.loader.create("com.tictactec.ta.lib.MInteger"); 
	Minteger2  = server.loader.create("com.tictactec.ta.lib.MInteger"); 
 	Minteger1.value = 1;
	Minteger2.value = 2;
	/* dx(int startIdx, int endIdx, double[] inHigh, double[] inLow, double[] inClose, int optInTimePeriod, MInteger outBegIdx, MInteger outNBElement, double[] outReal)  */
	</cfscript>
	<!--- JavaCast("int", "1")) --->
	<cfset variables.talib.PLUS_DI(arguments.startIdx,arguments.endIdx,local.srtArrays.aryHigh, local.srtArrays.aryLow, local.srtArrays.aryClose,arguments.optInTimePeriod,Minteger1,Minteger2,local.srtArrays.aryOut) />
	<cfreturn local.aryOut />
</cffunction>

<cffunction  name="PLUS_DM">
	<cfargument name="startIdx" 	type="Numeric"  default="1" required="false"  hint="where to start calculating"/> 
	<cfargument name="qryPrices" 	type="query" required="true"  hint="the array of prices to base on"/>
	<cfargument name="endIdx" 		type="Numeric"  default="#arguments.qryprices.recordcount - 1#" required="false" />
	<cfargument name="optInTimePeriod" type="Numeric"  default="14" required="false" hint="length of MA" />
	<cfargument name="outBegIdx" 	type="Numeric"  default="1" required="false" />
	<cfargument name="outNBElement" type="Numeric"  default="1" required="false" />
	<cfscript>
	var local = structNew();
	srtArrays = ProcessArrays(qryPrices: arguments.qryPrices);
	DoJavaCast(arguments);
    Minteger1  = server.loader.create("com.tictactec.ta.lib.MInteger"); 
	Minteger2  = server.loader.create("com.tictactec.ta.lib.MInteger"); 
 	Minteger1.value = 1;
	Minteger2.value = 2;
	/* dx(int startIdx, int endIdx, double[] inHigh, double[] inLow, double[] inClose, int optInTimePeriod, MInteger outBegIdx, MInteger outNBElement, double[] outReal)  */
	</cfscript>
	<!--- JavaCast("int", "1")) --->
	<cfset variables.talib.PLUS_DM(arguments.startIdx,arguments.endIdx,local.srtArrays.aryHigh, local.srtArrays.aryLow, local.srtArrays.aryClose,arguments.optInTimePeriod,Minteger1,Minteger2,local.srtArrays.aryOut) />
	<cfreturn local.aryOut />
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

<!--- <cffunction  name="PLUS_DM">
	<cfargument name="startIdx" 	type="Numeric"  default="1" required="false"  hint="where to start calculating"/> 
	<cfargument name="qryPrices" 	type="query" required="true"  hint="the array of prices to base on"/>
	<cfargument name="endIdx" 		type="Numeric"  default="#arguments.qryprices.recordcount - 1#" required="false" />
	<cfargument name="optInTimePeriod" type="Numeric"  default="14" required="false" hint="length of MA" />
	<cfargument name="outBegIdx" 	type="Numeric"  default="1" required="false" />
	<cfargument name="outNBElement" type="Numeric"  default="1" required="false" />
	<cfscript>
	var local = structNew();
	srtArrays = ProcessArrays(qryPrices: arguments.qryPrices);
	DoJavaCast(arguments);
    Minteger1  = server.loader.create("com.tictactec.ta.lib.MInteger"); 
	Minteger2  = server.loader.create("com.tictactec.ta.lib.MInteger"); 
 	Minteger1.value = 1;
	Minteger2.value = 2;
	/* dx(int startIdx, int endIdx, double[] inHigh, double[] inLow, double[] inClose, int optInTimePeriod, MInteger outBegIdx, MInteger outNBElement, double[] outReal)  */
	</cfscript>
	<!--- JavaCast("int", "1")) --->
	<cfset variables.talib.PLUS_DI(arguments.startIdx,arguments.endIdx,strArrays.aryHigh, strArrays.aryLow, strArrays.aryClose,arguments.optInTimePeriod,Minteger1,Minteger2,strArrays.aryOut) />
	<cfreturn local.aryOut />
</cffunction> --->

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
		//Convert data to XML and append
       	for(i=2;i<=local.qryrows;i++){ 
       		local.close = (local.open + local.high + local.low + local.close) / 4;
       		local.open 	= (local.closep + local.openp) / 2;
       		local.high 	= max(local.high, local.openp);
       		local.high 	= max(local.high, local.closep);
       		local.low	= min(local.low, local.openp);
       		local.low	= min(local.low, local.closep);
			local.hkquery["open"][i-1] 	= local.open;
			local.hkquery["high"][i-1]	= local.high;
			local.hkquery["low"][i-1] 	= local.low;
			local.hkquery["close"][i-1]	= local.close;

       		local.openp		= local.open;
       		local.closep	= local.close;
       		local.highp		= local.high;
       		local.lowp		= local.low;
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
	<!--- <cfargument name="offset" 		type="query" required="true"  hint="the array of prices to base on"/> --->
	<cfscript>
	var local = structNew();
	local.aryOut 	= ArrayNew(1);
	local.aryOpen 	= ArrayNew(1);
	local.aryHigh 	= ArrayNew(1);
	local.aryLow 	= ArrayNew(1);
	local.aryClose 	= ArrayNew(1);
	
	for (
	 local.intRow = 1 ;
	 local.intRow LTE qryPrices.RecordCount ;
	 local.intRow = (local.intRow + 1) )
	 {
		local.aryOut[local.introw]	= 0;
		local.aryOpen[local.introw]	= arguments.qryPrices['open'][local.introw]; 
		local.aryHigh[local.introw]	= arguments.qryPrices['high'][local.introw]; 
		local.aryLow[local.introw]	= arguments.qryPrices['low'][local.introw];
		local.aryClose[local.introw]	= arguments.qryPrices['close'][local.introw];
	}
	local.aryHigh 	= javacast("double[]",local.aryHigh);
	local.aryLow 	= javacast("double[]",local.aryLow);
	local.aryClose 	= javacast("double[]",local.aryClose);
	local.aryOut	= javacast("double[]",local.aryout);
	local.aryOpen 	= javacast("double[]",local.aryOpen);
	</cfscript>
	<cfreturn local />
</cffunction>

<cffunction  name="DoJavaCast">
	<cfargument name="argStruct" 	type="Struct" required="true"  hint="the array of prices to base on"/>
	<cfscript>
	arguments.argStruct.startIdx 		= javacast("int",arguments.argStruct.startIdx);
    arguments.argStruct.endIdx 			= javacast("int",arguments.argStruct.endIdx);
    arguments.argStruct.outBegIdx 		= javacast("int",arguments.argStruct.outBegIdx);
    arguments.argStruct.outNBElement 	= javacast("int",arguments.argStruct.outNBElement);
    arguments.argStruct.optInTimePeriod = javacast("int",arguments.argStruct.optInTimePeriod);
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