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
		// need to load objects
		//this.DataService 	= createObject("component","cfstox.model.DataService").init();
				
		this.controller = createObject("component","cfstox.controllers.controller").init();
		//this.TA 		= createObject("component","cfstox.model.ta").init();
		this.symbol 	= "HD";
		this.startDate	= "10/01/2012";
		this.enddate	= "11/16/2012";
		</cfscript>
		</cffunction>
<!---  
todo: construct a fake query for indicator testing purposes
note: candles are offset by two days  
--->
	
	<cffunction name="testGetMAType" access="public" returntype="void">
		<cfscript>
		var local = structNew();
		local.MAObject 	= session.Objects.TA.GetMAType(); 
		debug(local.MAObject);
		//local.results = local.MAObject.Ema;
		//debug(local.results);
		local.results = local.MAObject.values();
		debug(ArraytoList(local.results));
		</cfscript>
	</cffunction>
	
	<cffunction name="testGetSMA" access="public" returntype="void">
		<cfscript>
		var local = structNew();
		local.data 		= session.Objects.DataService.GetStockData(symbol:#this.symbol#,startdate:#this.startdate#,enddate:#this.enddate#);
		local.MAObject 	= session.Objects.TA.GetIndicator(Indicator:"SMA",qryPrices:local.data.orgdata,optInTimePeriod:2); 
		debug(local.MAObject);
		</cfscript>
	</cffunction>
	
	<cffunction name="testGetBollinger" access="public" returntype="void">
		<cfscript>
		var local = structNew();
		local.data 		= session.Objects.DataService.GetStockData(symbol:#this.symbol#,startdate:#this.startdate#,enddate:#this.enddate#);
		local.results 	= session.Objects.TA.GetIndicator(Indicator:"Bollinger",qryPrices:local.data.orgdata,optInTimePeriod:2); 
		debug(local.results);
		</cfscript>
	</cffunction>
	
	
	<cffunction name="testGetStoch" access="public" returntype="void">
		<cfscript>
		var local = structNew();
		local.data 		= session.Objects.DataService.GetStockData(symbol:#this.symbol#,startdate:#this.startdate#,enddate:#this.enddate#);
		local.results 	= session.Objects.TA.GetIndicator(Indicator:"Stoch",qryPrices:local.data.orgdata,optInTimePeriod:2); 
		debug(local.results);
		</cfscript>
	</cffunction>
	
	<cffunction name="testGetCandle" access="public" returntype="void">
		<cfscript>
		var local = structNew();
		local.data 		= session.Objects.DataService.GetStockData(symbol:#this.symbol#,startdate:#this.startdate#,enddate:#this.enddate#);
		local.results 	= session.Objects.TA.GetCandle(Candle:"Engulfing",qryPrices:local.data.orgdata); 
		debug(local.results);
		</cfscript>
	</cffunction>
	<!--- <cffunction name="testGetIndicator" access="public" returntype="void">
		<cfscript>
		var local = structNew();
		local.num = this.TA.GetIndicator(Indicator:"SMA",qryPrices:this.stockdata); 
		//debug(local.num);
		local.num = this.TA.GetIndicator(Indicator:"DX",qryPrices:this.stockdata); 
		//debug(local.num);
		local.num = this.TA.GetIndicator(Indicator:"ADX",qryPrices:this.stockdata); 
		//debug(local.num);
		local.num = this.TA.GetIndicator(Indicator:"CCI",qryPrices:this.stockdata); 
		//debug(local.num);
		local.num = this.TA.GetIndicator(Indicator:"RSI",qryPrices:this.stockdata); 
		//debug(local.num);
		</cfscript>
	</cffunction> --->
		
	<!--- <cffunction name="testGetCandle" access="public" returntype="void">
		<cfscript>
		var local = structNew();
		/* local.num = this.TA.GetCandle(Candle:"DarkCloudCover",qryPrices:this.stockdata); 
		debug(local.num);
		local.num = this.TA.GetCandle(Candle:"Kicking",qryPrices:this.stockdata); 
		debug(local.num);
		local.num = this.TA.GetCandle(Candle:"AbandonedBaby",qryPrices:this.stockdata); 
		debug(local.num);
		local.num = this.TA.GetCandle(Candle:"EveningStar",qryPrices:this.stockdata);
		debug(local.num);
		local.num = this.TA.GetCandle(Candle:"EveningDojiStar",qryPrices:this.stockdata); 
		debug(local.num); */
		local.num = this.TA.GetCandle(Candle:"3BlackCrows",qryPrices:this.stockdata); 
		debug(local.num);
		local.num = this.TA.GetCandle(Candle:"3Inside",qryPrices:this.stockdata); 
		debug(local.num);
		local.num = this.TA.GetCandle(Candle:"3Outside",qryPrices:this.stockdata);
		debug(local.num);
		local.num = this.TA.GetCandle(Candle:"UpsideGap2Crows",qryPrices:this.stockdata);
		debug(local.num);
		local.num = this.TA.GetCandle(Candle:"Hammer",qryPrices:this.stockdata); 
		debug(local.num);
		local.num = this.TA.GetCandle(Candle:"HangingMan",qryPrices:this.stockdata);
		debug(local.num);
		local.num = this.TA.GetCandle(Candle:"HaramiCross",qryPrices:this.stockdata); 
		debug(local.num); 
		</cfscript>
	</cffunction> --->
	
	<!--- End Specific Test Cases --->
	<cffunction name="tearDown" access="public" returntype="void">
	 <!--- Place tearDown/clean up code here --->
	</cffunction>

</cfcomponent>
