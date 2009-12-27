<!--- based on FusionCharts API : http://www.fusioncharts.com/free/docs/?gMenuItemId=19 --->
<!--- get user input for symbol --->
<cfset application.XMLGenerator = createobject("component","XMLGenerator").init() />
<cfset s_symbol = "MS">
<!--- validate symbol --->
<!--- get date range for data --->
<!--- *fetch data --->
<cfhttp  url="http://ichart.finance.yahoo.com/table.csv?s=#s_symbol#&a=01&b=23&c=2009&d=02&e=22&f=2009&g=d&ignore=.csv"  
		name="querydata1" columns="CalDate,Open,High,Low,Close,Volume,Adj_Close" firstrowasheaders="yes" />

<cfset sitedata = #CFHTTP.FileContent#>
<!--- <cfdump var="#sitedata#"> --->
<!--- <cfdump var="#cfhttp.errorDetail#"> --->

<cfquery name="querydata" dbtype="query">
select * from querydata1 order by Caldate
</cfquery>

<!--- convert into array  --->
<!--- process into xml for FusionCharts --->
<cfset xmldata = application.XMLGenerator.GenerateXML(name:"Morgan Stanley",symbol:"MS",qrydata:querydata)>
<cfdump var="#xmldata#">
<!--- display chart --->
<!--- write html --->
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>FusionCharts Free Documentation</title>
<link rel="stylesheet" href="../Contents/Style.css" type="text/css" />
<script language="JavaScript" src="../JSClass/FusionCharts.js"></script>
</head>

<body>
<table width="98%" border="0" cellspacing="0" cellpadding="3" align="center">
  <tr> 
    <td valign="top" class="text" align="center"> <div id="chartdiv" align="center"> 
        FusionCharts. </div>

      <script type="text/javascript">
		   var chart = new FusionCharts("../Charts/FCF_Candlestick.swf", "ChartId", "600", "350");
		  <cfoutput>chart.setDataXML("#xmldata#");</cfoutput>		   
		   chart.render("chartdiv");
		</script> </td>
  </tr>
  <tr>
    <td valign="top" class="text" align="center">&nbsp;</td>
  </tr>
  <tr> 
    <td valign="top" class="text" align="center"><a href="Data/Col3DLineDY.xml" target="_blank"><img src="../Contents/Images/BtnViewXML.gif" alt="View XML for the above chart" width="75" height="25" border="0" /></a></td>
  </tr>

</table>
</body>
</html>














