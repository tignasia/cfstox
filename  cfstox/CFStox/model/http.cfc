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
	<cfhttp
	columns="DateOne,Open,High,Low,Close,Volume,Adj_Close"		   
	url="http://ichart.finance.yahoo.com/table.csv?s=#arguments.sym#&a=0&b=1&c=2010&ignore=.csv" 
	method="get" result="stockdata" name="yahoo" firstrowasheaders="Yes" />
	<cfreturn yahoo />
</cffunction>

</cfcomponent>
<!--- &d=9&e=17&f=2009&g=d --->