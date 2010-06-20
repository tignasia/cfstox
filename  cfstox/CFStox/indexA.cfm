<!--- get the data  --->
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>FusionCharts Free Documentation</title>
<link rel="stylesheet" href="FusionChartsFree/Contents/Style.css" type="text/css" /> 
<script language="JavaScript" src="FusionChartsFree/JSClass/FusionCharts.js"></script>
</head>
<cfsilent>
<cfset httpService = createObject("component","cfstox.model.http")>
<cfset application.XMLGenerator = createobject("component","model.XMLGenerator").init() />
<cfset application.Indicators 	= createobject("component","model.Indicators").init() />
<cfset application.Utility 		= createobject("component","model.Utility").init() />
<cfset application.TA 		= createobject("component","model.TA").init() />
<!--- ToDo:add start and end dates --->
<cfset results = httpService.gethttp(sym:"SPY") />

<!--- <cfloop query="results">
	<cfset results[ "date" ][ results.currentRow ] = (results.date * 1) />
</cfloop> 
<cfdump var="#results#"> --->

<cfquery   dbtype="query"  name="yahoo" >
select * from results order by DateOne asc
</cfquery>

<cfset falseArray = ArrayNew(1) >

<cfloop from="1" to="#yahoo.recordcount#" index="i">
	<cfset falseArray[i] = "false">
</cfloop>
<cfset stockdata = duplicate(yahoo) />
<cfset num = application.TA.GetIndicator(Indicator:"linearReg",qryPrices:yahoo) />
<cfset queryAddColumn(stockdata,"linearReg",'Decimal',num) > 
<cfset num = application.TA.GetIndicator(Indicator:"linearRegAngle",qryPrices:yahoo) />
<cfset queryAddColumn(stockdata,"linearRegAngle",'Decimal',num) >
<cfset num = application.TA.GetIndicator(Indicator:"linearRegSlope",qryPrices:yahoo) />
<cfset queryAddColumn(stockdata,"linearRegSlope",'Decimal',num) >
<cfset num = application.TA.GetIndicator(Indicator:"linearRegIntercept",qryPrices:yahoo) />
<cfset queryAddColumn(stockdata,"linearRegIntercept",'Decimal',num) >
<cfset num = application.TA.GetIndicator(Indicator:"Momentum",qryPrices:yahoo) />
<cfset queryAddColumn(stockdata,"Momentum",'Decimal',num) >
<cfset num = application.TA.GetIndicator(Indicator:"RSI",qryPrices:yahoo) />
<cfset queryAddColumn(stockdata,"RSI",'Decimal',num) >
<cfset num = application.TA.GetIndicator(Indicator:"ADX",qryPrices:yahoo) />
<cfset queryAddColumn(stockdata,"ADX",'Decimal',num) >
<cfset num = application.TA.GetIndicator(Indicator:"CCI",qryPrices:yahoo) />
<cfset queryAddColumn(stockdata,"CCI",'Decimal',num) >
<cfset queryAddColumn(stockdata,"TestResult","VarChar",falsearray) >
<cfset LRSArray = application.TA.LRSDelta(qryData:stockdata) />
<cfset queryAddColumn(stockdata,"LRSdelta","Decimal", LRSarray) >

<!--- 
<cfdump var="#yahoo#"> --->
<!--- <cfset aMomentum = arrayNew(1) />
<cfset period = 14 />
<cfset i = 1 />
<cfloop query="yahoo">
	<!--- <cfoutput>#yahoo.close# #yahoo.dateone#</cfoutput> --->
	<cfif i GT period>
		<cfset momentum = (yahoo.close - yahoo.close[(yahoo.currentrow - period) ] ) />
		<cfset aMomentum[i] = round(momentum*100)/100>
		<!--- <cfoutput>#momentum# <br></cfoutput> --->
	</cfif>
	<cfset i = i + 1 />
</cfloop>
<cfset queryAddColumn(yahoo,"momentum",'Decimal',aMomentum) > --->

<cfquery   dbtype="query"  name="stockdata" >
select * from stockdata order by DateOne desc
</cfquery>
</cfsilent>
<cfform format="flash">
<cfgrid  format="flash" name="myGrid" query="stockdata" rowheaders="false" height="250" autowidth="true">
	<!--- loop over the columns and populate the columns! --->
	<!--- <cfloop from="1" to="#ArrayLen(thisTag.columns)#" index="x">
	<cfif NOT thisTag.columns[x].visible>
		<cfgridcolumn name="#thisTag.columns[x].columnName#" header="#thisTag.columns[x].Header#" display="no">
	<cfelseif IsNumeric(thisTag.columns[x].width)>
		<cfgridcolumn name="#thisTag.columns[x].columnName#" header="#thisTag.columns[x].Header#" width="#thisTag.columns[x].width#">
	<cfelse>
		<cfgridcolumn name="#thisTag.columns[x].columnName#" header="#thisTag.columns[x].Header#">
	</cfif>
	</cfloop> --->
</cfgrid>
</cfform> 

<!--- todo: have data read from file --->
<cfsilent>
<cfset xmldata = application.XMLGenerator.GenerateXML(name:"SPY",symbol:"SPY",qrydata:yahoo)>
</cfsilent>
<div id="chartdiv" align="center"> FusionCharts </div>
<script type="text/javascript">
  var chart = new FusionCharts("FusionChartsFree/Charts/FCF_Candlestick.swf", "ChartId", "600", "400");
  <cfoutput>chart.setDataXML("#xmldata#");</cfoutput>		   
   chart.render("chartdiv");
</script> 
<!--- draw heiken ashi  --->

<cfset xmldata = application.XMLGenerator.GenerateXMLha(name:"SPY",symbol:"SPY",qrydata:yahoo)>
<div id="chartdiv2" align="center"> FusionCharts </div>
<script type="text/javascript">
  var chart = new FusionCharts("FusionChartsFree/Charts/FCF_Candlestick.swf", "ChartId2", "600", "400");
  <cfoutput>chart.setDataXML("#xmldata#");</cfoutput>		   
   chart.render("chartdiv2");
</script> 


 <a href="Data/Col3DLineDY.xml" target="_blank"><img src="FusionChartsFree/Contents/Images/BtnViewXML.gif" alt="View XML for the above chart" width="75" height="25" border="0" /></a>

<!--- QueryAddColumn(query, column-name[, datatype], array-name)
 --->

<!--- display in datagrid --->


<!--- get a specific row ---->

<!--- loop and calculate momentum and ROC --->




