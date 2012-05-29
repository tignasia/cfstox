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
		// abandoned baby from stockfetcher
		//this.data = this.DataService.GetStockData(symbol:"CELL",startdate:"04/01/2011",enddate:"05/04/2012");
		//this.stockdata = this.data.OrgData;
		//this.abandoned_baby = this.data.OrgData;
		// Harami Cross from stockfetcher
		//this.data = this.DataService.GetStockData(symbol:"PBY",startdate:"04/01/2011",enddate:"05/04/2012");
		//this.HaramiCross = this.data.OrgData;
		// Engulfing - Bullish from stockfetcher
		this.data = this.DataService.GetStockData(symbol:"AMZN",startdate:"12/01/2011",enddate:"05/04/2012");
		this.stockData = this.data.OrgData;
		this.TA = createObject("component","cfstox.model.TA").init();
		</cfscript>
		<!--- <cfdump var="#this.TA#">
		<cfabort> --->
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
	
	<cffunction name="testGetData" access="public" returntype="void">
		<cfscript>
		//debug(this.StockData);
		</cfscript>
	</cffunction>
	
	<!--- 
	Dark Cloud Cover 		DarkCloudCover	none
	Kicking 				Kicking			none	
	Abandoned Baby			AbandonedBaby	none
	Evening Star			EveningStar		none
	Evening Doji Star 		EveningDojiStar none
	Three Black Crows 		3BlackCrows		none
	Three Inside Down 		3Inside			3
	Three Outside Down		3Outside		2
	Upside Gap Two Crows 	UpsideGap2Crows none
		
	MEDIUM RELIABILITY
	Dragonfly Doji 		DragonflyDoji
	Long Legged Doji 	LongLeggedDoji
	Engulfing 			Engulfing
	Gravestone Doji 	GravestoneDoji
	Doji Star			DojiStar
	Harami Cross 		HaramiCross			3
	Meeting Lines 	
	Advance Block 		AdvanceBlock
	Deliberation 	
	Tri Star			Tristar
	Two Crows 			
	Breakaway 			cdlBreakaway
	
	OTHER 
	Doji
	HighWave
	Hikkake
	Marubozu
	Thrusting
	Hammer				one
	HangingMan			Three
		--->
	
	<cffunction name="testGetCandle" access="public" returntype="void">
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
	</cffunction>
	
	<!--- End Specific Test Cases --->

	<cffunction name="tearDown" access="public" returntype="void">
	 <!--- Place tearDown/clean up code here --->
	</cffunction>

</cfcomponent>
