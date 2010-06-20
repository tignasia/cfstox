<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Historical Data</title>
<link rel="stylesheet" href="../FusionChartsFree/Contents/Style.css" type="text/css" /> 
<script language="JavaScript" src="../FusionChartsFree/JSClass/FusionCharts.js"></script>
</head>
<!--- <cfdump label="request" var="#request#"> --->
<cfset stockdata = request.stockdata />
<cfform format="flash">
<cfgrid  format="flash" name="myGrid" query="request.stockdata" rowheaders="false" height="250" autowidth="true">
</cfgrid>
</cfform> 
<cfoutput>
<div id="chartdiv" align="center"> Historical Data : #request.symbol# </div>
<script type="text/javascript">
  var chart = new FusionCharts("../FusionChartsFree/Charts/FCF_Candlestick.swf", "ChartId", "600", "400");
  <cfoutput>chart.setDataXML("#request.xmldata#");</cfoutput>		   
   chart.render("chartdiv");
</script> 
<!--- draw heiken ashi  --->


<div id="chartdiv2" align="center"> Heiken-Ashi Chart </div>
<script type="text/javascript">
  var chart = new FusionCharts("../FusionChartsFree/Charts/FCF_Candlestick.swf", "ChartId2", "600", "400");
  <cfoutput>chart.setDataXML("#request.xmldataHA#");</cfoutput>		   
   chart.render("chartdiv2");
</script> 


 <a href="Data/Col3DLineDY.xml" target="_blank"><img src="../FusionChartsFree/Contents/Images/BtnViewXML.gif" alt="View XML for the above chart" width="75" height="25" border="0" /></a>
</cfoutput>