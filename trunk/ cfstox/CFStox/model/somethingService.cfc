
<cfcomponent name="somethingService" output="false">

	<cffunction name="init" access="public" output="false" returntype="somethingService">
		<cfargument name="somethingDAO" type="somethingDAO" required="true" />
		<cfargument name="somethingGateway" type="somethingGateway" required="true" />

		<cfset variables.somethingDAO = arguments.somethingDAO />
		<cfset variables.somethingGateway = arguments.somethingGateway />

		<cfreturn this/>
	</cffunction>

	<cffunction name="getsomething" access="public" output="false" returntype="something">
		
		<cfset var something = createObject("component","something").init(argumentCollection=arguments) />
		<cfset variables.somethingDAO.read(something) />
		<cfreturn something />
	</cffunction>

	<cffunction name="getsomethings" access="public" output="false" returntype="query">
		<cfargument name="Date" type="date" required="false" />
		<cfargument name="Symbol" type="string" required="false" />
		<cfargument name="Open" type="numeric" required="false" />
		<cfargument name="High" type="numeric" required="false" />
		<cfargument name="Low" type="numeric" required="false" />
		<cfargument name="Close" type="numeric" required="false" />
		<cfargument name="Volume" type="numeric" required="false" />
		
		<cfreturn variables.somethingGateway.getByAttributes(argumentCollection=arguments) />
	</cffunction>

	<cffunction name="savesomething" access="public" output="false" returntype="boolean">
		<cfargument name="Date" type="date" required="false" />
		<cfargument name="Symbol" type="string" required="false" />
		<cfargument name="Open" type="numeric" required="false" />
		<cfargument name="High" type="numeric" required="false" />
		<cfargument name="Low" type="numeric" required="false" />
		<cfargument name="Close" type="numeric" required="false" />
		<cfargument name="Volume" type="numeric" required="false" />
		
		
		<cfset var something = getsomething() />
		<cfset something.setDate(arguments.Date) />
		<cfset something.setSymbol(arguments.Symbol) />
		<cfset something.setOpen(arguments.Open) />
		<cfset something.setHigh(arguments.High) />
		<cfset something.setLow(arguments.Low) />
		<cfset something.setClose(arguments.Close) />
		<cfset something.setVolume(arguments.Volume) />
		<cfreturn variables.somethingDAO.save(something) />
	</cffunction>

	<cffunction name="deletesomething" access="public" output="false" returntype="boolean">
		
		<cfset var something = createObject("component","something").init(argumentCollection=arguments) />
		<cfreturn variables.somethingDAO.delete(something) />
	</cffunction>
</cfcomponent>
