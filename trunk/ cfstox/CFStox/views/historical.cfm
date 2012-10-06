<cfoutput>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Historical Data</title>
<script type="text/javascript" src="../fusionChartsFree/JSClass/FusionCharts.js">
</script>
</head>
<body>
<!--- <cfdump label="request" var="#request#"> --->
<!--- <cfset stockdata = request.stockdata /> --->


Heiken-Ashi Data
<cfif request.method EQ "historical">
<a href="../Data/#request.symbol#.pdf" target="_blank">View PDF</a>
<a href="../Data/#request.symbol#.xls" target="_blank">View Excel</a>
</cfif>
<cfif request.method EQ "backtest">
<cfset tradesurl = "../Data/#request.symbol#"&"trades"&".pdf">	
<a href="#tradesurl#" target="_blank">View Trades (PDF)</a>
<!--- <a href="../Data/#symbol#.xls" target="_blank">View Excel</a> --->
</cfif>


<cfform >
<cfgrid  format="flash" name="myHAGrid" query="request.qryDataHA" rowheaders="false" height="250" autowidth="true">
</cfgrid>
</cfform> 

Original Data
<cfif request.method EQ "historical">
<a href="../Data/#request.symbol#.pdf" target="_blank">View PDF</a>
<a href="../Data/#request.symbol#.xls" target="_blank">View Excel</a>
</cfif>
<cfif request.method EQ "backtest">
<cfset tradesurl = "../Data/#request.symbol#"&"trades"&".pdf">	
<a href="#tradesurl#" target="_blank">View Trades (PDF)</a>
<!--- <a href="../Data/#symbol#.xls" target="_blank">View Excel</a> --->
</cfif>

<cfform >
<cfgrid  format="flash" name="myOriginalGrid" query="request.qryDataOriginal" rowheaders="false" height="250" autowidth="true">
</cfgrid>
</cfform> 

<div id="chartdiv" align="center" width="50%"> Historical Data : #request.symbol# </div>
<script type="text/javascript">
  var chart = new FusionCharts("../Charts/Candlestick.swf", "ChartId", "1200", "600");
  chart.setDataXML("#request.xmldata#");	   
   chart.render("chartdiv");
</script>
<!--- draw heiken ashi  --->


<div id="chartdiv2" align="center" width="50%"> Heiken-Ashi Chart: #request.symbol#</div>
<script type="text/javascript">
  var chart = new FusionCharts("../Charts/Candlestick.swf", "ChartId", "1200", "600");
  chart.setDataXML("#request.xmldataHA#");
   chart.render("chartdiv2");
</script>


 <a href="Data/Col3DLineDY.xml" target="_blank"><img src="../FusionChartsFree/Contents/Images/BtnViewXML.gif" alt="View XML for the above chart" width="75" height="25" border="0" /></a>
</body>
</cfoutput>