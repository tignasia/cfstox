<cfcomponent  displayname="TradeBean" output="false"  hint="I represent the values and indicators for a given day" >

	<cffunction name="init" description="init method" access="public" displayname="init" output="false" returntype="TradeBean">
		<cfargument name="strData" required="true"  />
		<cfscript>
		set("Symbol",strData.Symbol);	
		set("Date",strData.DateOne);	
		set("HKOpen",strData.Open);
		set("HKHigh",strData.High);
		set("HKLow",strData.Low);
		set("HKClose",strData.Close);
		set("HKVolume",strData.Volume);
		set("ADX",strData.ADX);
		set("CCI",strData.CCI);
		set("LinearReg",strData.LinearReg);
		set("LinearRegAngle",strData.LinearRegAngle);
		set("LinearRegIntercept",strData.LinearRegIntercept);
		set("LinearRegSlope",strData.LinearRegSlope);
		set("LRSDelta",strData.LRSDelta);
		set("Momentum",strData.Momentum);
		set("RSI",strData.RSI); 
		set("S1",strData.S1);
		set("S2",strData.S2);
		set("R1",strData.R1);
		set("R2",strData.R2); 
		// trade info
		Set("NewHighBreakout","false"); //high greater than prev local high
		Set("NewHighReversal","false"); // bounce off new local high 
		Set("NewLowBreakDown","false"); //new low greater than previous local low
		Set("NewLowReversal","false"); // bounce off new local low
		Set("NewLocalLow",false);
		Set("NewLocalHigh",false);
		Set("HKGoShort","false");
		Set("HKCloseShort","false");
		Set("HKGoLong","false");
		Set("HKCloseLong","false");
		Set("EntryDate","00/00/0000");
		Set("EntryPrice",0);
		Set("ExitDate","00/00/0000");
		Set("ExitPrice",0);
		Set("ProfitLoss",0);
		Set("NetProfitLoss",0);
		Set("StopLossPrice",0);
		Set("StopLossTriggered",false);
		Set("RSIstatus","");
		Set("CCIstatus","");
		Set("MomentumStatus","");
		Set("BolBandStatus","");
		Set("MACDStatus","");
		Set("R1Breakout1Day",false);
		Set("R1BreakOut2Days",false);
		Set("R2Breakout1Day",false);
		Set("R2BreakOut2Days",false);
		Set("R1Status","");
		Set("R2Status","");
		Set("S1Status","");
		Set("S2Status","");
		return this;
		</cfscript>
	</cffunction>
	
	<cffunction name="getMemento" description="" access="public" displayname="" output="false" returntype="Any">
		<cfreturn variables />
	</cffunction>
	
	<cffunction name="Set" description="" access="public" displayname="" output="false" returntype="void">
		<cfargument name="fieldname" required="true"  />
		<cfargument name="data" required="true"  />
		<cfset variables[#fieldname#] = arguments.data />
		<cfreturn />
	</cffunction>	
	
	<cffunction name="Get" description="" access="public" displayname="" output="false" returntype="Any">
		<cfargument name="fieldname" required="true"  />
		<cfreturn variables[#fieldname#] />
	</cffunction>	
	
	
</cfcomponent>