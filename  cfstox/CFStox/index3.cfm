<!--- get the data  --->
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>CFStox</title>
<link rel="stylesheet" href="FusionChartsFree/Contents/Style.css" type="text/css" /> 
<script language="JavaScript" src="FusionChartsFree/JSClass/FusionCharts.js"></script>
</head>

<cfset httpService = createObject("component","cfstox.model.http")>
<!--- <cfset XMLGenerator = createobject("component","model.XMLGenerator").init() />
<cfset TA 			= createobject("component","model.TA").init() />
<cfset Utility 		= createobject("component","model.Utility").init() /> --->
<cfset ProfitTester	= createobject("component","model.ProfitTester").init() />

<cfset results = httpService.gethttp(sym:"RIG") />
<cfquery   dbtype="query"  name="yahoo" >
select * from results order by DateOne
</cfquery>

<cfset results2 = ProfitTester.backtester2(qryStockHist:yahoo) />
<!--- <cfdump var="#results2#"> --->

<cfset aryPrices = arrayNew(2) />
<cfset aryPrices.addall(results2.lowarray) />
<cfset aryPrices.addall(results2.higharray) />

<cfloop index="outer" from="1" to="#arrayLen(aryPrices)#">
      <cfloop index="inner" from="1" to="#arrayLen(aryPrices)-1#">
          <cfif aryPrices[inner][1] gt aryPrices[outer][1]>
              <cfset arraySwap(aryPrices,outer,inner)>
          </cfif>
      </cfloop>
</cfloop>

<cfloop from="1" to="#ArrayLen(aryPrices)#" index="x">
	<cftry>
	<cfif x GTE 2 AND aryPrices[x][3] EQ aryPrices[x-1][3]>
		<cfset aryPrices[x-1][1] = "" > 
		
	</cfif>
	<cfcatch>
	</cfcatch>
	</cftry>
</cfloop>

<cfdump label="array prices deduped" var="#aryPrices#" />
<cfset profit = 0 />
<cfloop from="1" to=#arrayLen(aryPrices)# index="x">
	<cfif x GTE 4 AND len(aryPrices[x-1][1])>
		<cfoutput>aryPrices #aryPrices[x][1]# : #aryPrices[x][2]# #aryPrices[x][3]#</br></cfoutput>
		<cfset profit = profit + abs(aryPrices[x-1][2] - aryPrices[x][2])>
	</cfif>
</cfloop>
<cfoutput>profit : #profit# </br></cfoutput>
<!--- <cfloop from="1" to="#ArrayLen(results2.lowarray)#" index="x">
	<cfoutput>results2.lowarray: #results2.lowarray[x][1]# : #results2.lowarray[x][2]# </br></cfoutput>
	<cfoutput>results2.higharray: #results2.higharray[x][1]# : #results2.higharray[x][2]# </br></cfoutput>
</cfloop> --->

<cfabort>
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




