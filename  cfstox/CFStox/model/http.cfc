<cfcomponent output="false">

<cffunction  name="init">
	<cfreturn this />
</cffunction>

<cffunction name="gethttp" output="false"  returntype="Query">
	<cfargument name="sym" required="true" type="String" displayname="sym" hint="the symbol to be returned">
	<cfhttp
	columns="DateOne,Open,High,Low,Close,Volume,Adj_Close"		   
	url="http://ichart.finance.yahoo.com/table.csv?s=#arguments.sym#&a=0&b=4&c=2009&ignore=.csv" 
	method="get" result="stockdata" name="yahoo" firstrowasheaders="Yes" />
	<cfreturn yahoo />
</cffunction>

</cfcomponent>
<!--- &d=9&e=17&f=2009&g=d --->