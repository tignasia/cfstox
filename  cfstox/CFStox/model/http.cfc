<cfcomponent output="false">

<cffunction  name="init">
	<cfreturn this />
</cffunction>

<cffunction name="gethttp" output="false"  returntype="Query">
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
	<cftrace text="symbol: #arguments.sym#" var="arguments.sym">
	
	<cfhttp
	columns="DateOne,Open,High,Low,Close,Volume,Adj_Close"		   
	url="http://ichart.finance.yahoo.com/table.csv?s=#arguments.sym#&a=#local.startmonth#&b=#local.startday#&c=#local.startyear#&d=#local.endmonth#&e=#local.endday#&f=#local.endyear#&ignore=.csv" 
	method="get" result="stockdata" name="yahoo" firstrowasheaders="Yes" />
	<cfreturn yahoo />
</cffunction>

</cfcomponent>
<!--- &d=9&e=17&f=2009&g=d --->