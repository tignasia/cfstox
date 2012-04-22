<!---
 MXUnit TestCase Template
 @author
 @description
 @history
 --->

<cfcomponent displayname="mxunit.framework.MyComponentTest"  extends="mxunit.framework.TestCase">

	<cffunction name="setUp" access="public" returntype="void">
	 <!---  <cfset super.TestCase(this) /> --->
	  <!--- Place additional setUp and initialization code here --->
		<cfscript>
		createObject("component","cfstox.controllers.Controller").init();
		this.DataService 	= createObject("component","cfstox.model.DataService").init();
		this.Utility 		= createObject("component","cfstox.model.Utility").init();
		this.SystemService 	= createObject("component","cfstox.model.SystemService").init();
		this.data = this.DataService.GetStockData(symbol:"CSX",startdate:"04/01/2012",enddate:"04/20/2012");
		this.stockdata = this.data.OrgData;
		this.TA = createObject("component","cfstox.model.TA").init();
		</cfscript>
		<!--- <cfdump var="#this.TA#">
		<cfabort> --->
	</cffunction>

	<cffunction name="testGetIndicator" access="public" returntype="void">
		
		<cfscript>
		var local = structNew();
		local.num = this.TA.GetIndicator(Indicator:"SMA",qryPrices:this.stockdata); 
		debug(local.num);
		local.num = this.TA.GetIndicator(Indicator:"DX",qryPrices:this.stockdata); 
		debug(local.num);
		local.num = this.TA.GetIndicator(Indicator:"ADX",qryPrices:this.stockdata); 
		debug(local.num);
		local.num = this.TA.GetIndicator(Indicator:"CCI",qryPrices:this.stockdata); 
		debug(local.num);
		local.num = this.TA.GetIndicator(Indicator:"RSI",qryPrices:this.stockdata); 
		debug(local.num);
		</cfscript>
	</cffunction>
	
	<cffunction name="testGetData" access="public" returntype="void">
		<cfscript>
		debug(this.StockData);
		</cfscript>
	</cffunction>
	
	<cffunction name="testGetCandle" access="public" returntype="void">
		<cfscript>
		var local = structNew();
		local.num = this.TA.GetCandle(Candle:"AbandonedBaby",qryPrices:this.stockdata); 
		debug(local.num);
		local.num = this.TA.GetCandle(Candle:"HaramiCross",qryPrices:this.stockdata); 
		debug(local.num);
		</cfscript>
	</cffunction>
	
	<!--- End Specific Test Cases --->

	<cffunction name="tearDown" access="public" returntype="void">
	 <!--- Place tearDown/clean up code here --->
	</cffunction>

</cfcomponent>
