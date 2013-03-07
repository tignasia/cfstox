<cfcomponent output="false">

	<cffunction  name="init">
		<cfreturn this />
	</cffunction>

	<cffunction name="getHTTPData" output="false"  access="public" returntype="Any">
		<cfargument name="symbol" required="true" type="String" displayname="sym" hint="the symbol to be returned">
		<cfargument name="startDate" required="false"  default=#CreateDate(2013,1,1)# />
		<cfargument name="endDate" required="true" />  <!--- default="#now()#" --->
		<cfargument name="Source" required="true" />  <!--- Yahoo, Google --->
		<cfset var local = structNew() />	
		<cfset local.startmonth = month(arguments.startdate) -1 />
		<cfset local.startday 	= day(arguments.startdate) />
		<cfset local.startyear 	= year(arguments.startdate) />
		<cfset local.endmonth 	= month(arguments.enddate) -1 />
		<cfset local.endday 	= day(arguments.enddate) />
		<cfset local.endyear 	= year(arguments.enddate) />
		<cfset local.url 		= GetURL(source:arguments.source,symbol:arguments.symbol,startdate:arguments.startdate,enddate:arguments.enddate) />
		<cfset local.HistoricalData = "" />
		<cfswitch expression="#arguments.Source#">
			<cfcase  value="Yahoo">
				<cftry> 
				<cfhttp
				columns="DateOne,Open,High,Low,Close,Volume,Adj_Close"		   
				url="#local.url#" 
				useragent="Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1; .NET CLR 2.0.50727; FDM)"
				method="get" firstrowasheaders="Yes" result="stockdata" name="HistoricalDataYahoo" />
				<cfset local.HistoricalData = HistoricalDataYahoo />
				<cfcatch>
				<cfoutput> HTTP request failed</cfoutput>
				<cfdump var="#arguments.symbol#">
				<cfdump var="#variables#">
				<cfdump var="#arguments#">
				</cfcatch>
				</cftry>
			</cfcase>
			<cfcase  value="Google">
				<cftry> 
				<cfhttp
				columns="DateOne,Open,High,Low,Close,Volume"		   
				url="#local.url#" 
				useragent="Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1; .NET CLR 2.0.50727; FDM)"
				method="get" firstrowasheaders="Yes" result="stockdata" name="HistoricalDataGoogle" />
				<cfset local.HistoricalData = HistoricalDataGoogle />
				<cfcatch>
				<cfoutput> HTTP request failed</cfoutput>
				<cfdump var="#arguments.symbol#">
				<cfdump var="#variables#">
				<cfdump var="#arguments#">
				</cfcatch>
				</cftry>
			</cfcase>
			</cfswitch>	
		<cfreturn local.HistoricalData />
	</cffunction>

	<cffunction name="getURL" output="false"  returntype="Any" access="public">
		<!--- http://www.google.com/finance/historical?q=RIMM&startdate=Feb+5%2C+2010&enddate=Nov+23%2C+2010&num=30&output=csv
		<!--- http://www.google.com/finance/historical?cid=5232&startdate=Nov+1%2C+2010&enddate=Jan+6%2C+2011&num=30&output=csv --->
		a = start month starting at 0
		b = start day starting at 1
		c = start year 
		d = end month starting at 0
		e = end day starting at 1
		f = end year 
		--->
		<!--- http://ichart.finance.yahoo.com/table.csv?s=CSX&a=00&b=1&c=2010&d=04&e=17&f=2010&g=d&ignore=.csv 
		a = start month starting at 0
		b = start day starting at 1
		c = start year 
		d = end month starting at 0
		e = end day starting at 1
		f = end year 
		--->
		<cfargument name="symbol" required="true" type="String" displayname="sym" hint="the symbol to be returned">
		<cfargument name="startDate" required="false"  default=#CreateDate(2010,10,1)# />
		<cfargument name="endDate" required="true">  <!--- default="#now()#" --->
		<cfargument name="Source" required="true" />  <!--- Yahoo, Google --->
		<cfset var local = structNew() />
		<!--- Yahoo sets the month back by 1 --->	
		<cfset local.TxtStartmonth = LSDateFormat(arguments.startdate,"mmm")  />
		<cfset local.startmonth = month(arguments.startdate) - 1   />
		<cfset local.startday 	= day(arguments.startdate) />
		<cfset local.startyear 	= year(arguments.startdate) />
		<cfset local.txtEndmonth 	= LSDateFormat(arguments.enddate,"mmm")  />
		<cfset local.endmonth 	= month(arguments.enddate) - 1 />
		<cfset local.endday 	= day(arguments.enddate) />
		<cfset local.endyear 	= year(arguments.enddate) />
		
		<!--- Yahoo: 
		correct: 	http://ichart.finance.yahoo.com/table.csv?s=JOYG&a=10&b=1&c=2011&d=10&e=28&f=2011&g=d&ignore=.csv
		wrong: 		http://ichart.finance.yahoo.com/table.csv?s=CSX&a=Nov&b=1&c=2011&d=Nov&e=27&f=2011&ignore=.csv
		--->
		<cfswitch expression="#arguments.Source#">
			<cfcase  value="Yahoo">
				<cfset local.url="http://ichart.finance.yahoo.com/table.csv?s=#arguments.symbol#&a=#local.startmonth#&b=#local.startday#&c=#local.startyear#&d=#local.endmonth#&e=#local.endday#&f=#local.endyear#&ignore=.csv" />
			</cfcase>
			<cfcase value="Google">
				<cfset local.url = 	"http://www.google.com/finance/historical?q=#arguments.symbol#&startdate=#local.TxtStartmonth#+#local.startday#+#local.startyear#&enddate=#local.TxtEndmonth#+#local.endday#+#local.endyear#&output=csv" >
			</cfcase>
		</cfswitch>
		<cfreturn local.url />
	</cffunction>
	
	<cffunction name="getJSONData" output="false"  access="public" returntype="Any">
		<cfargument name="symbolList" required="true" type="String" displayname="sym" hint="the symbol to be returned">
		<cfset var local = StructNew() />
		<!---  
		I found this list of data items:

  avvo    = Average volume (float with multiplier, like '3.54M')
  beta    = Beta (float)
  c       = Amount of change while open (float)
  ccol    = (unknown) (chars)
  cl      = Last perc. change
  cp      = Change perc. while open (float)
  e       = Exchange (text, like 'NASDAQ')
  ec      = After hours last change from close (float)
  eccol   = (unknown) (chars)
  ecp     = After hours last chage perc. from close (float)
  el      = After. hours last quote (float)
  el_cur  = (unknown) (float)
  elt     = After hours last quote time (unknown)
  eo      = Exchange Open (0 or 1)
  eps     = Earnings per share (float)
  fwpe    = Forward PE ratio (float)
  hi      = Price high (float)
  hi52    = 52 weeks high (float)
  id      = Company id (identifying number)
  l       = Last value while open (float)
  l_cur   = Last value at close (like 'l')
  lo      = Price low (float)
  lo52    = 52 weeks low (float)
  lt      = Last value date/time
  ltt     = Last trade time (Same as "lt" without the data)
  mc      = Market cap. (float with multiplier, like '123.45B')
  name    = Company name (text)
  op      = Open price (float)
  pe      = PE ratio (float)
  t       = Ticker (text)
  type    = Type (i.e. 'Company')
  vo      = Volume (float with multiplier, like '3.54M')
		
		--->
		
		<cftry>
		<cfhttp
		url="http://www.google.com/finance/info?infotype=infoquoteall&q=#arguments.symbolList#" 
		useragent="Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1; .NET CLR 2.0.50727; FDM)"
		method="get" >
		<cfcatch>
		<cfoutput> HTTP request failed</cfoutput>
		<cfdump var="#arguments.symbolList#">
		<cfdump var="#variables#">
		<cfdump var="#arguments#">
		</cfcatch>
		</cftry>
		<cfreturn replace(cfhttp.filecontent,"\x26","&") />
	</cffunction>

	http://www.google.com/finance/info?infotype=infoquoteall&q=BIDU,SINA
</cfcomponent>
