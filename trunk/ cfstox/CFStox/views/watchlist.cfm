<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>TRading Info</title>
<link rel="stylesheet" href="../FusionChartsFree/Contents/Style.css" type="text/css" /> 
<script language="JavaScript" src="../FusionChartsFree/JSClass/FusionCharts.js"></script>
</head>
<body>

<table title="Current Trades">
<th>Stock</th>
<th>Open/Close</th>
<th>Trade Type</th>
<th>Trade Date</th>
<th>Price</th>
<cfset tradeLength = request.tradedata.Size() />
<cfloop from="1" to="#tradelength#" index="i">
	
	<cfif (i mod 2) >
		<cfset sym = #request.tradedata[i]# />
	<cfelse>
		<cfloop from="#arraylen(request.tradedata[i])#" to="#arraylen(request.tradedata[i])#" index="j">
			<cfif #request.tradedata[i][j][1]# EQ "open">
			<tr>
			<cfoutput><td>#sym#</td></cfoutput>
			<cfoutput><td>#request.tradedata[i][j][1]#</td></cfoutput>
			<cfoutput><td>#request.tradedata[i][j][2]#</td></cfoutput>
			<cfoutput><td>#request.tradedata[i][j][3]#</td></cfoutput>
			<cfoutput><td>#request.tradedata[i][j][4]#</td></cfoutput>
			</tr>
			</cfif>
		</cfloop>
		
	</cfif>
	
</cfloop>
</body>
