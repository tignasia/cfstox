<cfcomponent name="testHTTP" extends="mxunit.framework.TestCase">
	<!--- Begin specific tests --->
	
	<!--- setup and teardown --->
	<cffunction name="setUp" returntype="void" access="public">
		<cfset this.MailService = createObject("component","cfstox.model.mail").init() />
	</cffunction>

	<cffunction name="testSendMail" returntype="void" access="public">
		<cfset var subject = "test email" />
		<cfset this.MailService.sendMail(subject:subject) />
	</cffunction>

	<cffunction name="getGoogleJSON" returntype="void" access="public">
		<cfhttp 
		url="http://www.google.com/finance/info?infotype=infoquoteall&q=BIDU,SINA" 
		useragent="Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1; .NET CLR 2.0.50727; FDM)"
		method="get" result="stockdata" />
		>
		<cfscript>
		debug(stockdata.filecontent);
		debug(stockdata.filecontent.getClass().toString() );
		debug(stockdata.filecontent.length() );
		strlen = stockdata.filecontent.length();
		debug(stockdata.filecontent.substring(4,strlen ) );
		debug(DeSerializeJSON(stockdata.filecontent.substring(4,strlen )));
		// c change cp change percent l_cur current price 
		// http://www.google.com/finance/info?infotype=infoquoteall&q=BIDU,SINA
		// http://www.google.com/ig/api?stock=GOOG&stock=SINA
		
		//debug(stockdata.filecontent.getClass().getMethods() );
		//jsonoutput = DeserializeJSON(stockdata.filecontent.substring(4) );
		//debug(jsonoutput);
		</cfscript>
		
	</cffunction>
	
	<cffunction name="tearDown" returntype="void" access="public">
		<!--- Any code needed to return your environment to normal goes here --->
	</cffunction>

</cfcomponent>

