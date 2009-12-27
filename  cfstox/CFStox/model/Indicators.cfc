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

	
</cfcomponent>