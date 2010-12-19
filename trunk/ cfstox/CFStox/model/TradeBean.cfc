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
		// trade info
		Set("HKGoShort","false");
		Set("HKGoLong","false");
		Set("EntryDate","00/00/0000");
		Set("EntryPrice",0);
		Set("ExitDate","00/00/0000");
		Set("ExitPrice",0);
		Set("StopLossPrice",0);
		Set("StopLossTriggered",false);
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