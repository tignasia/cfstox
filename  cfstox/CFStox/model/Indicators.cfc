<cfcomponent output="false">
	<cffunction name="init"  >
		<cfreturn this />
	</cffunction>

	<cffunction name="SMA" access="public" output="false" returntype="Array">
		<cfargument name="values" required="true">
		<cfargument name="period" required="true">
		<cfset var local = StructNew() />
		<cfset local.arrlen = arraylen(arguments.values) />
		<cfset local.lookback = arguments.period - 1 />
		<cfset local.avgArray  = ArrayNew(1) />
		<!--- preload the period total ; while( i < startIdx )
            periodTotal += inReal[i++]; --->
		<cfscript>
		local.i = 1;
		while (local.i LE local.lookback) {
		local.periodTotal = local.periodTotal + arguments.values[local.i];
		local.i = local.i + 1;
		}
		local.outIndex = 1;
		while (local.i LE local.arrlen) {
		local.avgArray[local.outIndex] = local.periodTotal / local.lookback;
		local.periodTotal = local.periodTotal + arguments.values[local.i];
		local.periodTotal = local.periodTotal - arguments.values[local.outIndex];
		local.i = local.i + 1;
		local.outIndex = local.outindex + 1;
		}
		</cfscript>
		<cfreturn local.avgArray />
	</cffunction>
	
	<cffunction name="PercentChange" access="public" output="false" returntype="Array">
		<cfargument name="values" required="true">
		<cfargument name="period" required="true">
		<cfscript>
		var local = StructNew();
		local.arrlen = arraylen(arguments.values);
		local.lookback = arguments.period - 1; 
		// store the values to return
		local.DataArray  = ArrayNew(1); 
		local.ReturnArray = ArrayNew(1);
		local.outIndex = 1;
		local.lastclose = arguments.values[1][5];
		// values should be array of date open high low close 
		// create initial value 
		local.j = 1;
		local.i = 2;
		while (local.i LE arguments.period) {
			local.DataArray[local.j] = ((arguments.values[local.i][5] - local.lastclose)/ local.lastclose)*100;
			local.i = local.i + 1;
			local.j = local.j + 1;
		}
		
		// use arrayavg to avg the array values
		while (local.i LE local.arrlen) 
		{	// push the new value on the bottom	
			local.DataArray[arguments.period] = ((arguments.values[local.i][5] - local.lastclose)/ local.lastclose)*100;
			local.lastclose 					= arguments.values[local.i][5];
			try {
			local.indicatorSum = ArrayAvg(local.DataArray);
			}
			catch(Any e) {
			dump(local.DataArray,true);
			}
			local.ReturnArray[local.i] = local.indicatorSum;
			// pop the oldest val from array
			ArrayDeleteAt(local.DataArray,1);
			local.i 			= local.i + 1;
			local.outIndex 		= local.outindex + 1;
		}
		</cfscript>
		<cfreturn local.ReturnArray />
	</cffunction>
	
	<cffunction name="Dump" description="" access="private" displayname="" output="false" returntype="void">
		<cfargument name="target">
		<cfargument name="abort" default=false required="false">
		<cfdump label="target" var="#arguments.target#">
		<cfif arguments.abort>
			<cfabort>
		</cfif>
		<cfreturn />
	</cffunction>
</cfcomponent>