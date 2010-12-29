<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Trading Info</title>
<link rel="stylesheet" href="../FusionChartsFree/Contents/Style.css" type="text/css" /> 
<script language="JavaScript" src="../FusionChartsFree/JSClass/FusionCharts.js"></script>
</head>
<body>
<cfoutput>
<cfset local = structNew() />


Watchlist Report <br/>
Breakout Highs <br/>
<table>
<th>Symbol</th>
<th>ClosingPrice</th>
<th>High</th>
<th>Previous High</th>
<th>Previous High Date</th>
<th>Previous High Date</th>
<th>GoLong</th>		


<cfloop array="#request.data#" index="i"  >
<cfset local.TradeBean = i />
<cfif local.TradeBean["highbreakout"].Get("NewHighBreakOut") > 
<tr>
	<td>#local.tradebean["highbreakout"].Get("Symbol")#</td>
	<td>#local.tradebean["highbreakout"].Get("HKClose")#</td>
	<td>#local.tradebean["highbreakout"].Get("HKHigh")#</td>
	<td>#local.tradebean["highbreakout"].Get("PreviousLocalHigh")#</td>
	<td>#local.tradebean["highbreakout"].Get("PreviousLocalHighDate")#</td>
	<td>#local.tradebean["highbreakout"].Get("HKGoLong")#</td>
</tr>
</cfif> 
</cfloop>
</table>
</cfoutput>
<cfoutput>
New Long Positions <br/>
<table>
<th>Symbol</th><th>ClosingPrice</th> <th>R1</th> <th>Previous High</th><th>Previous High Date</th>


<cfloop array="#request.data#" index="j">
<cfset local.TradeBean =  j />	
<cfif local.TradeBean["golong"].Get("HKGoLong") > 
<tr>
	<td>#local.tradebean["golong"].Get("Symbol")#</td>
	<td>#local.tradebean["golong"].Get("HKClose")#</td>
	<td>#DecimalFormat(local.tradebean["golong"].Get("R1"))#</td>
	<td>#local.tradebean["golong"].Get("PreviousLocalHigh")#</td>
	<td>#local.tradebean["golong"].Get("PreviousLocalHighDate")#</td>
</tr>
</cfif> 
</cfloop>
</table>
</cfoutput>
	

</body>
