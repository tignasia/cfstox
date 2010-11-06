<cfcomponent output="false">
	
	<cffunction name="init"  >
		<cfreturn this />
	</cffunction>
	
	<cffunction name="GenerateXML"  hint="I generate XML data for FusionCharts" access="public" output="false" returntype="xml">
		<cfargument name="name" required="true" />
		<cfargument name="symbol" required="true" />
		<cfargument name="qrydata" required="true" />
		<cfargument name="high" required="false" />
		<cfargument name="low" required="false" />
		<cfset var local = structNew() />
		
		<cfscript> 
		local.strXML = "<graph caption='#arguments.name# #arguments.symbol#' yAxisMinValue='#arguments.low#' yAxisMaxValue='#arguments.high#' canvasBorderColor='DAE1E8' canvasBgColor='FFFFFF' bgColor='EEF2FB' numDivLines='9' divLineColor='DAE1E8' decimalPrecision='2' numberPrefix='$' showNames='1' bearBorderColor='E33C3C' bearFillColor='B00F1F' bullBorderColor='1F3165' baseFontColor='444C60' outCnvBaseFontColor='444C60' hoverCapBorderColor='DAE1E8' hoverCapBgColor='FFFFFF' rotateNames='0' showExportDataMenuItem='1'>";
		local.strxml = local.strXML & "<data>";
		local.qryrows = arguments.qrydata.recordcount;
		//Convert data to XML and append
       	for(i=1;i<=local.qryrows;i++){   
			local.strXML = local.strXML & "<set open='#qrydata['open'][i]#' high='#qrydata['high'][i]#' low='#qrydata['low'][i]#' close='#qrydata['close'][i]#' date='#qrydata['DateOne'][i]#' />";
       	}
           	//Close <graph> element
       	local.strXML = local.strXML & "</data></graph>";
			</cfscript>
		<cfreturn local.strxml />
	</cffunction>
<!--- todo: write seperate function that returns array  --->
	<cffunction name="GenerateXMLHA"  hint="I generate XML data for FusionCharts" access="public" output="false" returntype="xml">
		<cfargument name="name" required="true" />
		<cfargument name="symbol" required="true" />
		<cfargument name="qrydata" required="true" />
		<cfset var local = structNew() />
		<cfscript> 
		local.strXML = "<graph caption='#arguments.name# #arguments.symbol#' yAxisMinValue='100' yAxisMaxValue='125' canvasBorderColor='DAE1E8' canvasBgColor='FFFFFF' bgColor='EEF2FB' numDivLines='9' divLineColor='DAE1E8' decimalPrecision='2' numberPrefix='$' showNames='1' bearBorderColor='E33C3C' bearFillColor='B00F1F' bullBorderColor='1F3165' baseFontColor='444C60' outCnvBaseFontColor='444C60' hoverCapBorderColor='DAE1E8' hoverCapBgColor='FFFFFF' rotateNames='0' showExportDataMenuItem='1'>";
		local.strxml = local.strXML & "<data>";
		local.qryrows = arguments.qrydata.recordcount;
		local.open 	= arguments.qrydata['open'][1];
		local.high 	= arguments.qrydata['high'][1];
		local.low 	= arguments.qrydata['low'][1];
		local.close = arguments.qrydata['close'][1];
		local.openp	= arguments.qrydata['open'][1]; 
		local.closep = arguments.qrydata['close'][1];
		//Convert data to XML and append
       	for(i=2;i<=local.qryrows;i++){ 
       		local.close = (local.open + local.high + local.low + local.close) / 4;
       		local.open 	= (local.closep + local.openp) / 2;
       		local.high 	= max(local.high, local.openp);
       		local.high 	= max(local.high, local.closep);
       		local.low	= min(local.low, local.openp);
       		local.low	= min(local.low, local.closep);
			local.strXML = local.strXML & "<set open='#local.open#' high='#local.high#' low='#local.low#' close='#local.close#' />";
       		local.openp		= local.open;
       		local.closep	= local.close;
       		local.highp		= local.high;
       		local.lowp		= local.low;
       		local.open		= qrydata['open'][i];
       		local.close		= qrydata['close'][i];
       		local.high		= qrydata['high'][i];
       		local.low		= qrydata['low'][i];
       	}
           	//Close <graph> element
       	local.strXML = local.strXML & "</data></graph>";
			</cfscript>
		<cfreturn local.strxml />
	</cffunction>
</cfcomponent>