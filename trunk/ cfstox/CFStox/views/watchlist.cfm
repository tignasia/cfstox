<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Trading Info</title>
<link rel="stylesheet" href="../FusionChartsFree/Contents/Style.css" type="text/css" /> 
<script language="JavaScript" src="../FusionChartsFree/JSClass/FusionCharts.js"></script>
</head>
<body>
<cfset local = structNew() />
		<cfset local.filename = "C:\JRun4\servers\cfusion\cfusion-ear\cfusion-war\CFStox\Data\" & "Watchlist"  & ".pdf"/>
		<cfset local.ReportHeaders1 	= "Symbol,Trade,Entry Price,Date">
		
		<cfoutput>
		<table cellspacing="10" width="80%">
		<tr>
		<cfloop list="#local.ReportHeaders1#" index="i">
		<th>#i#</th>
		</cfloop>
		</tr>
		
		<cfset local.longentry 		= 0  />
		<cfset local.shortentry 	= 0 />
		<cfset local.profitloss 	= 0 />
		<cfset local.netprofitloss 	= 0 />
		<cfset local.Price		 	= 0 />
		<cfset local.Date 		= 0 />
		<cfloop from="1" to="#request.beanarray.size()#" index="i">
			<cfset local.EntryDate 	= "" />
			<cfset local.ExitPrice 	= 0 />
			<cfset local.ExitDate 	= "" />
			<cfset local.TradeBean = request.BeanArray[i] />
			<cfset local.symbol = local.tradebean.get("Symbol") />	
			<cfif local.tradeBean.LongOpen >
				<cfset local.TradeType = "Long Open" />
				<cfset local.entryprice = local.tradeBean.LongOpenPrice  />
				<cfset local.entrydate = local.tradeBean.LongOpenDate  />
				<cfset local.longentry = local.tradeBean.LongOpenPrice  />
				<cfset local.price = local.tradeBean.LongOpenPrice  />
				<cfset local.date = local.tradeBean.LongOpenDate  />
				
			</cfif> 
			<cfif local.tradeBean.LongClose >
				<cfset local.TradeType = "Long Close" />
				<cfset local.exitprice 	= local.tradeBean.LongClosePrice  />
				<cfset local.exitdate 	= local.tradeBean.LongCloseDate  />
				<cfset local.profitloss =  local.tradeBean.LongClosePrice - local.longentry  />
				<cfset local.netprofitloss = local.netprofitloss + local.profitloss />
				<cfset local.price 	= local.tradeBean.LongClosePrice  />
				<cfset local.date 	= local.tradeBean.LongCloseDate  />
			</cfif> 
			<cfif local.tradeBean.ShortOpen>
				<cfset local.TradeType = "Short Open" />
				<cfset local.EntryPrice = local.tradeBean.ShortOpenPrice />
				<cfset local.EntryDate  = local.tradeBean.ShortOpenDate />
				<cfset local.ShortEntry 	= local.tradeBean.ShortOpenPrice />
				<cfset local.price 	= local.tradeBean.ShortOpenPrice  />
				<cfset local.date 	= local.tradeBean.ShortOpenDate  />
			</cfif> 
			<cfif local.tradeBean.ShortClose>
				<cfset local.TradeType = "Short Close" />
				<cfset local.ExitPrice = local.tradeBean.ShortClosePrice />
				<cfset local.ExitDate  = local.tradeBean.ShortCloseDate />
				<cfset local.profitloss =  local.shortentry - local.tradeBean.ShortClosePrice />
				<cfset local.netprofitloss = local.netprofitloss + local.profitloss />
				<cfset local.Price = local.tradeBean.ShortClosePrice />
				<cfset local.Date  = local.tradeBean.ShortCloseDate />
			</cfif> 
			<tr>
			<td>#local.symbol#</td>
			<td>#local.TradeType#</td>
			<td>#local.Price#</td>
			<td>#local.Date#</td>
			</tr>
			<cfset local.profitloss =  "" />
		</cfloop>
		</table>
		</cfoutput>
	



<!--- <cfdump var="#request#">
<cfdump var="#variables#">
<cfdump var="#session#"> --->
</body>
