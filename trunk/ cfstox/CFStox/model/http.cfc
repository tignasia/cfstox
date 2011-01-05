<cfcomponent output="false">

<cffunction  name="init">
	<cfreturn this />
</cffunction>

<cffunction name="gethttp" output="false"  returntype="Any">
	<!--- http://ichart.finance.yahoo.com/table.csv?s=CSX&a=00&b=1&c=2010&d=04&e=17&f=2010&g=d&ignore=.csv 
	a = start month starting at 0
	b = start day starting at 1
	c = start year 
	d = end month starting at 0
	e = end day starting at 1
	f = end year 
	--->
	<cfargument name="sym" required="true" type="String" displayname="sym" hint="the symbol to be returned">
	<cfargument name="startDate" required="false"  default=#CreateDate(2009,1,1)# />
	<cfargument name="endDate" required="true"  <!--- default="#now()#" --->>
	<cfset var local = structNew() />	
	<cfset local.startmonth = month(arguments.startdate) -1 />
	<cfset local.startday 	= day(arguments.startdate) />
	<cfset local.startyear 	= year(arguments.startdate) />
	<cfset local.endmonth 	= month(arguments.enddate) -1 />
	<cfset local.endday 	= day(arguments.enddate) />
	<cfset local.endyear 	= year(arguments.enddate) />
	<!--- 
	d  - This parameter is to get the input for end month, and again '00' is for January, '02' is for February and so on.
	e - This parameter is to get the input for the end day
	f - This parameter is to get the input for the end year --->
	<!--- <cftrace text="symbol: #arguments.sym#" var="arguments.sym"> --->
	
	<cfhttp
	columns="DateOne,Open,High,Low,Close,Volume,Adj_Close"		   
	url="http://ichart.finance.yahoo.com/table.csv?s=#arguments.sym#&a=#local.startmonth#&b=#local.startday#&c=#local.startyear#&d=#local.endmonth#&e=#local.endday#&f=#local.endyear#&ignore=.csv" 
	method="get" result="stockdata" name="yahoo" firstrowasheaders="Yes" />
	<cfset local.yahoo = yahoo />
	<cfreturn local.yahoo />
</cffunction>

<cffunction name="getHTTPGoogle" output="false"  returntype="Any">
	<!--- http://www.google.com/finance/historical?q=RIMM&startdate=Feb+5%2C+2010&enddate=Nov+23%2C+2010&num=30&output=csv
	a = start month starting at 0
	b = start day starting at 1
	c = start year 
	d = end month starting at 0
	e = end day starting at 1
	f = end year 
	--->
	<cfargument name="sym" required="true" type="String" displayname="sym" hint="the symbol to be returned">
	<cfargument name="startDate" required="false"  default=#CreateDate(2009,1,1)# />
	<cfargument name="endDate" required="true"  <!--- default="#now()#" --->>
	<cfset var local = structNew() />	
	<cfset local.startmonth = LSDateFormat(arguments.startdate,"mmm")  />
	<cfset local.startday 	= day(arguments.startdate) />
	<cfset local.startyear 	= year(arguments.startdate) />
	<cfset local.endmonth 	= LSDateFormat(arguments.enddate,"mmm")  />
	<cfset local.endday 	= day(arguments.enddate) />
	<cfset local.endyear 	= year(arguments.enddate) />
	<cfset local.url = 	"http://www.google.com/finance/historical?q=#arguments.sym#&startdate=#local.startmonth#+#local.startday#" & "," & "#local.startyear#&enddate=#local.endmonth#+#local.endday#" & "," & "#local.endyear#&output=csv" >
	<!--- 
	d  - This parameter is to get the input for end month, and again '00' is for January, '02' is for February and so on.
	e - This parameter is to get the input for the end day
	f - This parameter is to get the input for the end year --->
	<!--- <cftrace text="symbol: #arguments.sym#" var="arguments.sym"> --->
	<!--- http://www.google.com/finance/historical?s=RIMM&startdate=Nov+11%2C+2009&enddate=Nov+9%2C+2010&num=30&output=csv --->
	<!--- <cfhttp 
	columns="DateOne,Open,High,Low,Close,Volume"
	useragent="Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1; .NET CLR 2.0.50727; FDM)"		   
	url="#local.url#" 
	method="get" result="stockdata" name="yahoo1" firstrowasheaders="Yes" />  --->
	<cfset local.basepath = GetDirectoryFromPath(GetBaseTemplatePath()) />
	<cfhttp 
	useragent="Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1; .NET CLR 2.0.50727; FDM)"		   
	url="#local.url#" 
	method="get" columns="DateOne,Open,High,Low,Close,Volume"	firstrowasheaders="Yes"   result="resultdata" name="google"/>
	<cfset local.resultdata = resultdata>
	<cfreturn local />
</cffunction>

</cfcomponent>
<!--- &d=9&e=17&f=2009&g=d --->