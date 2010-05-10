<cfcomponent hint="I test to see if a stock can be profitably traded" output="false">

	<cffunction name="Init" description="" access="public" displayname="" output="false" returntype="Any">
			<cfreturn this/>
	</cffunction>

	<cffunction name="trend_analyser" description="finds movement lengths and amounts" access="public" displayname="" output="false" returntype="Any">
	 	<cfargument name="qryStockHist" required="true" />
		<cfscript>
		var local = structNew(); 
		local.checkHigh = 1;
		local.CheckLow = 1;
		local.HighArray = ArrayNew(2);
		local.LowArray = ArrayNew(2);
		local.HighArray[1][1] = arguments.qryStockHist.dateone[1];
		local.HighArray[1][2] = arguments.qryStockHist.high[1];
		local.HighArray[1][3] = "High";
		local.LowArray[1][1] = arguments.qryStockHist.dateone[1];
		local.LowArray[1][2] = arguments.qryStockHist.low[1];
		local.LowArray[1][3] = "Low";
		local.idxArray = 1;
		/* enter the starting high as the high and the starting low as the low */
		/* loop over the query 	*/
		/* if high is > prev record */
		/* replace record */
		/* dont check low */
		/* if low < prev low */
		/* enter date and amount in appropriate array */
		/* set flag and zero other flag */ 
		
		for (i = 2; i lte arguments.qryStockHist.recordcount; i = i + 1) 
			{ 
			/*  if new low check for high  */
				if(arguments.qryStockHist.high[i] GT arguments.qryStockHist.high[i-1])
					{
					if (local.checkHigh EQ 1)	local.idxArray = ArrayLen(local.HighArray); 
					if (local.checkHigh EQ 0)	local.idxArray = ArrayLen(local.HighArray) + 1; 
					local.HighArray[local.idxArray][1] = arguments.qryStockHist.dateone[i];
				 	local.HighArray[local.idxArray][2] = arguments.qryStockHist.high[i];
				 	local.HighArray[local.idxArray][3] = arguments.qryStockHist.high[i];
					local.checkHigh = 1; }
				else { local.checkHigh = 0;		 }
		} //end loop
	 	return local;
		</cfscript>
	</cffunction>
	
	<cffunction name="backtester2" description="finds movement lengths and amounts" access="public" displayname="" output="false" returntype="Any">
	 	<cfargument name="qryStockHist" required="true" />
		<cfscript>
		var local = structNew(); 
		local.checkHigh = 1;
		local.CheckLow = 1;
		local.HighArray = ArrayNew(2);
		local.LowArray = ArrayNew(2);
		local.MAHighArray = ArrayNew(1);
		local.MALowArray = ArrayNew(1);
		local.HighArray[1][1] = arguments.qryStockHist.dateone[1];
		local.HighArray[1][2] = arguments.qryStockHist.high[1];
		local.HighArray[1][3] = "High";
		local.LowArray[1][1] = arguments.qryStockHist.dateone[1];
		local.LowArray[1][2] = arguments.qryStockHist.low[1];
		local.LowArray[1][3] = "Low";
		local.idxArray = 1;
		local.idxArrayLow = 1;
		local.maHigh = arguments.qryStockHist.high[1];
		local.maHigh = local.maHigh + arguments.qryStockHist.high[2];
		local.maHigh = local.maHigh + arguments.qryStockHist.high[3];
		local.maHigh = local.maHigh / 3; 	
		local.maHighArray[1] = local.maHigh;
		
		local.maLow = arguments.qryStockHist.LOw[1];
		local.maLow = local.maLow + arguments.qryStockHist.Low[2];
		local.maLow = local.maLow + arguments.qryStockHist.Low[3];
		local.maLow = local.maLow / 3; 	
		local.maLowArray[1] = local.maLow;
		for (i = 4; i lte arguments.qryStockHist.recordcount; i = i + 1) 
			{ 
			/*  if new low check for high  */
				local.maHigh = arguments.qryStockHist.high[i-2];
				local.maHigh = local.maHigh + arguments.qryStockHist.high[i-1];
				local.maHigh = local.maHigh + arguments.qryStockHist.high[i];
				local.maHigh = local.maHigh / 3; 
				local.maHighArray[i-2] = local.maHigh;
				if(local.maHigh GT local.maHighArray[i-3])
					{
					local.HighArray[local.idxArray][1] = arguments.qryStockHist.dateone[i];
				 	local.HighArray[local.idxArray][2] = arguments.qryStockHist.high[i];
				 	local.HighArray[local.idxArray][3] = "High";
					 }
				else { local.idxArray = ArrayLen(local.HighArray)+1; }
				
			/*  if new low check for high  */
				local.maLow = arguments.qryStockHist.Low[i-2];
				local.maLow = local.maLow + arguments.qryStockHist.Low[i-1];
				local.maLow = local.maLow + arguments.qryStockHist.Low[i];
				local.maLow = local.maLow / 3; 
				local.maLowArray[i-2] = local.maLow;
				if(local.maLow LT local.maLowArray[i-3])
					{
					local.LowArray[local.idxArrayLow][1] = arguments.qryStockHist.dateone[i];
				 	local.LowArray[local.idxArrayLow][2] = arguments.qryStockHist.Low[i];
				 	local.LowArray[local.idxArrayLow][3] = "Low";
					 }
				else { local.idxArrayLow = ArrayLen(local.LowArray)+1; }
		} //end loop
	 	return local;
		</cfscript>
	</cffunction>
	<cffunction name="trace" description="" access="private" displayname="" output="false" returntype="void">
		<cfargument  name="thingToTrace">
		<cfargument  name="desc">
		<cftrace  category="information" inline="false" text="#arguments.desc#" var="arguments.thingToTrace">
		<cfreturn />
	</cffunction>
</cfcomponent>

<!---- 
if(arguments.qryStockHist.high[i] GT local.HighArray[ArrayLen(local.HighArray)][2] ){
				trace(thingtotrace:arguments.qryStockHist.high[i],desc:"query:high value");
				trace(thingtotrace:local.HighArray[ArrayLen(local.HighArray)][2],desc:"existing high value");
				trace(thingtotrace:local.HighArray[ArrayLen(local.HighArray)][1],desc:"existing high date");
				local.idxArray = ArrayLen(local.HighArray) + 1;
			 	local.HighArray[local.idxArray][1] = arguments.qryStockHist.dateone[i];
			 	local.HighArray[local.idxArray][2] = arguments.qryStockHist.high[i];
			 	<!--- local.newHighFlag = 1; --->
			} */
			/* else {	local.newHighFlag = 0; } */ -->
			  	
<!--
			if(arguments.qryStockHist.low[i] LT local.LowArray[ArrayLen(local.LowArray)][2] )
				{
				trace(thingtotrace:arguments.qryStockHist.low[i],desc:"query:low value");
				trace(thingtotrace:local.LowArray[ArrayLen(local.LowArray)][2],desc:"existing Low value");
				trace(thingtotrace:local.LowArray[ArrayLen(local.LowArray)][1],desc:"existing Low date");
				if(local.newLowFlag EQ 1) /* replace low value */ 
					local.idxArray = ArrayLen(local.LowArray);
			 	else
			 		local.idxArray = ArrayLen(local.LowArray) + 1;
			 	local.LowArray[local.idxArray][1] = arguments.qryStockHist.dateone[i];
			 	local.LowArray[local.idxArray][2] = arguments.qryStockHist.low[i];
			 	/* local.newHighFlag = 0;
			 	local.newLowFlag = 1; */
			 } 
			/*  else {	local.newLowFlag = 0; } */
			--> 				 			 

/* if new high check for low */
			if ( local.checkLow) {
				if(arguments.qryStockHist.low[i] LT arguments.qryStockHist.low[i-1])
				{
				local.idxArray = ArrayLen(local.LowArray);
			 	local.LowArray[local.idxArray][1] = arguments.qryStockHist.dateone[i];
			 	local.LowArray[local.idxArray][2] = arguments.qryStockHist.low[i];
				local.checkHigh = 0;
				}
				else {
				}
		 	}	 
			else {local.checkHigh =1}	
		
---->