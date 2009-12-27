<!--- get the data  --->
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>FusionCharts Free Documentation</title>
<link rel="stylesheet" href="FusionChartsFree/Contents/Style.css" type="text/css" /> 
<script language="JavaScript" src="FusionChartsFree/JSClass/FusionCharts.js"></script>
</head>
<cfsilent>
<cfset httpService = createObject("component","cfstox.model.http")>
<cfset results = httpService.gethttp(sym:"CSX") />
<cfset application.XMLGenerator = createobject("component","model.XMLGenerator").init() />
<cfset application.TA 			= createobject("component","model.TA").init() />
<cfset application.Utility 		= createobject("component","model.Utility").init() />
<!--- <cfloop query="results">
	<cfset results[ "date" ][ results.currentRow ] = (results.date * 1) />
</cfloop> 
<cfdump var="#results#"> --->

<cfquery   dbtype="query"  name="yahoo" >
select * from results order by DateOne
</cfquery>

<!--- 
<cfdump var="#yahoo#"> --->
<cfset aMomentum = arrayNew(1) />
<cfset period = 14 />
<cfset i = 1 />
<cfloop query="yahoo">
	<!--- <cfoutput>#yahoo.close# #yahoo.dateone#</cfoutput> --->
	<cfif i GT period>
		<cfset momentum = (yahoo.close - yahoo.close[(yahoo.currentrow - period)] ) />
		<cfset aMomentum[i] = round(momentum*100)/100>
		<!--- <cfoutput>#momentum# <br></cfoutput> --->
	</cfif>
	<cfset i = i + 1 />
</cfloop>
<cfset queryAddColumn(yahoo,"momentum",'Decimal',aMomentum) >
</cfsilent>
<body>
<cfform format="flash">
<cfgrid  format="flash" name="myGrid" query="yahoo" rowheaders="false" height="125" autowidth="true">
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

<cfset xmldata = application.XMLGenerator.GenerateXML(name:"CSX",symbol:"CSX",qrydata:yahoo)>
		<div id="chartdiv" align="center"> 
        FusionCharts. 
    <script type="text/javascript">
		   var chart = new FusionCharts("Charts/CandleStick.swf", "ChartId", "600", "400", "0", "0");
		   chart.setDataURL("Data/test1.xml");		   
		   chart.render("chartdiv");
		</script>  
	</div>
  
</body>
</html>
<!--- QueryAddColumn(query, column-name[, datatype], array-name)
 --->

<!--- display in datagrid --->


<!--- get a specific row ---->

<!--- loop and calculate momentum and ROC --->




