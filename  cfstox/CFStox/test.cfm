<cfscript>
this.indicators = createObject("component","cfstox.model.indicators").init(); 
this.http = createObject("component","cfstox.model.http").init();
local = structNew();
local.array = arrayNew(2);
local.data = this.http.gethttp("ABX");
</cfscript>
<cfloop query="local.data">
<cfset local.array[local.data.CurrentRow][1] = local.data.dateone />
<cfset local.array[local.data.CurrentRow][2] = local.data.open />
<cfset local.array[local.data.CurrentRow][3] = local.data.high />
<cfset local.array[local.data.CurrentRow][4] = local.data.low />
<cfset local.array[local.data.CurrentRow][5] = local.data.close />
</cfloop>
<cfscript>	
local.num = this.Indicators.PercentChange(values:local.array, period:5); 
</cfscript>