<cfcomponent output="false">
	
	<cffunction name="init"  >
		<cfreturn this />
	</cffunction>
	
	<cffunction name="GenerateXML"  hint="I generate XML data for FusionCharts" access="public" output="false" returntype="xml">
		<cfargument name="name" required="true" />
		<cfargument name="symbol" required="true" />
		<cfargument name="qrydata" required="true" />
		<cfset var local = structNew() />
		<cfscript> 
		local.strXML = "<graph caption='#arguments.name# #arguments.symbol#' yAxisMinValue='24' yAxisMaxValue='29' canvasBorderColor='DAE1E8' canvasBgColor='FFFFFF' bgColor='EEF2FB' numDivLines='9' divLineColor='DAE1E8' decimalPrecision='2' numberPrefix='$' showNames='1' bearBorderColor='E33C3C' bearFillColor='E33C3C' bullBorderColor='1F3165' baseFontColor='444C60' outCnvBaseFontColor='444C60' hoverCapBorderColor='DAE1E8' hoverCapBgColor='FFFFFF' rotateNames='0'>";
		local.strxml = local.strXML & "<data>";
		local.qryrows = arguments.qrydata.recordcount;
		//Convert data to XML and append
       	for(i=1;i<=local.qryrows;i++){   
			local.strXML = local.strXML & "<set open='#qrydata['open'][i]#' high='#qrydata['high'][i]#' low='#qrydata['low'][i]#' close='#qrydata['close'][i]#' />";
       	}
           	//Close <graph> element
       	local.strXML = local.strXML & "</data></graph>";
			</cfscript>
		<cfreturn local.strxml />
	</cffunction>

</cfcomponent>