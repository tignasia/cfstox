<cfcomponent output="false">
	
	<cffunction name="init"  >
		<cfreturn this />
	</cffunction>
	
	<cffunction name="GenerateXML"  hint="I generate XML data for FusionCharts" access="public" output="false" returntype="xml">
		<cfargument name="dataType" required="false" default="Original" />
		<cfset var 	local = structNew() />
		<cfset name 	=	"chart"  />
		<cfset symbol 	=	session.objects.DataStorage.GetData("symbol") />
		<cfif arguments.dataType EQ "Original">
			<cfset qrydata 	=	session.objects.DataStorage.GetData("qryDataOriginal") />
		<cfelse>
			<cfset qrydata 	=	session.objects.DataStorage.GetData("qryDataHA") />
		</cfif>	
		<cfset high =	session.objects.DataStorage.GetData("High") />
		<cfset low 	=	session.objects.DataStorage.GetData("low") />
		
		<cfscript>
		local.strXML = ""; 
		//local.strXML = "<chart showToolTip='1'>";
		local.strXML = local.strXML & "<chart showToolTip='1' caption='#name# #symbol#' yAxisMinValue='#low#' yAxisMaxValue='#high#' xAxisMinValue='#low#' xAxisMaxValue='#high#' setAdaptiveYMin='1' canvasBorderColor='DAE1E8' canvasBgColor='FFFFFF' bgColor='EEF2FB' numDivLines='9' divLineColor='DAE1E8' decimalPrecision='2' numberPrefix='$' showNames='1' bearBorderColor='E33C3C' bearFillColor='B00F1F' bullBorderColor='1F3165' baseFontColor='444C60' outCnvBaseFontColor='444C60' hoverCapBorderColor='DAE1E8' hoverCapBgColor='FFFFFF' rotateNames='0' showExportDataMenuItem='1'>";
		local.strxml = local.strXML & "<dataset>";
		local.qryrows = qrydata.recordcount;
		//Convert data to XML and append
       	for(i=1;i<=local.qryrows;i++){
       		local.date = qrydata['DateOne'][i];
       		local.newDate =  listGetAt(local.date, 2, '-') & '/' & listGetAt(local.date, 3, '-') & '/' & listGetAt(local.date, 1, '-');   //hoverText='date:#local.newdate# open:#qrydata['open'][i]#'
			local.strXML = local.strXML & "<set open='#qrydata['open'][i]#' high='#qrydata['high'][i]#' low='#qrydata['low'][i]#' close='#qrydata['close'][i]#' x='#i#' date='#local.newdate#' toolText='date:#local.newdate# {br} open:#qrydata['open'][i]# {br} high:#qrydata['high'][i]# {br} low:#qrydata['low'][i]# {br} close:#qrydata['close'][i]#'  />";
       	}
           	//Close <graph> element
       	local.strXML = local.strXML & "</dataset>";
       	//local.strXML = local.strXML & "</graph>";
       	local.strXML = local.strXML & "</chart>";
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
		//local.strXML = "<graph caption='#arguments.name# #arguments.symbol#' yAxisMinValue='100' yAxisMaxValue='125' canvasBorderColor='DAE1E8' canvasBgColor='FFFFFF' bgColor='EEF2FB' numDivLines='9' divLineColor='DAE1E8' decimalPrecision='2' numberPrefix='$' showNames='1' bearBorderColor='E33C3C' bearFillColor='B00F1F' bullBorderColor='1F3165' baseFontColor='444C60' outCnvBaseFontColor='444C60' hoverCapBorderColor='DAE1E8' hoverCapBgColor='FFFFFF' rotateNames='0' showExportDataMenuItem='1'>";
		//local.strxml = local.strXML & "<data>";
		local.strXML = local.strXML & "<chart showToolTip='1' caption='#arguments.name# #arguments.symbol#' yAxisMinValue='#arguments.low#' yAxisMaxValue='#arguments.high#' canvasBorderColor='DAE1E8' canvasBgColor='FFFFFF' bgColor='EEF2FB' numDivLines='9' divLineColor='DAE1E8' decimalPrecision='2' numberPrefix='$' showNames='1' bearBorderColor='E33C3C' bearFillColor='B00F1F' bullBorderColor='1F3165' baseFontColor='444C60' outCnvBaseFontColor='444C60' hoverCapBorderColor='DAE1E8' hoverCapBgColor='FFFFFF' rotateNames='0' showExportDataMenuItem='1'>";
		local.strxml = local.strXML & "<dataset>";
		
		local.qryrows = arguments.qrydata.recordcount;
		local.open 	= arguments.qrydata['open'][1];
		local.high 	= arguments.qrydata['high'][1];
		local.low 	= arguments.qrydata['low'][1];
		local.close = arguments.qrydata['close'][1];
		local.openp	= arguments.qrydata['open'][1]; 
		local.closep = arguments.qrydata['close'][1];
		local.date = qrydata['DateOne'][1];
		//Convert data to XML and append
       	for(i=2;i<=local.qryrows;i++){ 
       		local.close = (local.open + local.high + local.low + local.close) / 4;
       		local.open 	= (local.closep + local.openp) / 2;
       		local.high 	= max(local.high, local.openp);
       		local.high 	= max(local.high, local.closep);
       		local.low	= min(local.low, local.openp);
       		local.low	= min(local.low, local.closep);
       		local.date = qrydata['DateOne'][i];
       		local.newDate =  listGetAt(local.date, 2, '-') & '/' & listGetAt(local.date, 3, '-') & '/' & listGetAt(local.date, 1, '-');   //hoverText='date:#local.newdate# open:#qrydata['open'][i]#'
			
			//local.strXML = local.strXML & "<set open='#local.open#' high='#local.high#' low='#local.low#' close='#local.close#' />";
       		local.strXML = local.strXML & "<set open='#local.open#' high='#local.high#' low='#local.low#' close='#local.close#' x='#i#' date='#local.newdate#' toolText='date:#local.newdate# {br} open:#local.open# {br} high:#local.high# {br} low:#local.low# {br} close:#local.close#'  />";
       
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
        	local.strXML = local.strXML & "</dataset>";
       	//local.strXML = local.strXML & "</graph>";
       	local.strXML = local.strXML & "</chart>";
       //	local.strXML = local.strXML & "</data></graph>";
			</cfscript>
		<cfreturn local.strxml />
	</cffunction>
</cfcomponent>