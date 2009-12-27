<cfcomponent output="false">
<!--- 
<chart palette="1" numPDivLines="5" caption="XYZ - 3 Months" numberPrefix="$" 
		bearBorderColor="E33C3C" bearFillColor="E33C3C" bullBorderColor="1F3165" PYAxisName="Price" 
			VYAxisName="Volume (In Millions)">

<categories>
<category label="2006" x="1"/>
<category label="Feb" x="31"/>
<category label="March" x="59"/>
</categories>

<dataset>
<set open="24.6" high="25.24" low="24.58" close="25.19" x="1" volume="17856350"/>
<set open="24.36" high="24.58" low="24.18" close="24.41" x="2" volume="3599252"/>
<set open="24.63" high="24.66" low="24.11" close="24.15" x="3" volume="74685351"/>
........
<set open="27.05" high="27.25" low="27" close="27.21" x="62" volume="45226989"/>
</dataset>
</chart>

 --->
	<cffunction name="writeXML" access="public" output="false">
	<cfscript>
	var local = structNew();
	local.crlf = chr(10) & chr(13); 
	local.data = "";
	local.header = '<chart palette="1" numPDivLines="5" caption="XYZ - 3 Months" numberPrefix="$" 
		bearBorderColor="E33C3C" bearFillColor="E33C3C" bullBorderColor="1F3165" PYAxisName="Price" 
			VYAxisName="Volume (In Millions)">';
	local.categories = '<categories>';
	local.categories = local.categories & #local.crlf# & '<category label="2006" x="1"/>' 
	& #local.crlf# & '<category label="Feb" x="31"/>' ;
	local.categories = local.categories & & #local.crlf# & '</categories>';
	local.data = local.data & "<dataset>" & #local.crlf#;
	local.data = local.data & '<set open="24.6" high="25.24" low="24.58" close="25.19" x="1" />' & #local.crlf#;
	local.data = local.data & "</dataset>" & #local.crlf#;
	local.footer = "</chart>";
	</cfscript>
	<cfsavecontent  variable="chartoutput" >
		<cfoutput>
		#local.header#
		#local.categories#
		#local.data#
		#local.footer#
		</cfoutput>
	</cfsavecontent>
	<cfreturn chartoutput />
	</cffunction>

</cfcomponent>