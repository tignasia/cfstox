
<cfcomponent displayname="somethingTO" output="false">

	<cffunction name="init" access="public" returntype="somethingTO" output="false">
		<cfargument name="Date" type="date" required="false"  />
		<cfargument name="Symbol" type="string" required="false"  />
		<cfargument name="Open" type="numeric" required="false"  />
		<cfargument name="High" type="numeric" required="false"  />
		<cfargument name="Low" type="numeric" required="false"  />
		<cfargument name="Close" type="numeric" required="false"  />
		<cfargument name="Volume" type="numeric" required="false"  />
		
		<cfset this.Date = arguments.Date />
		<cfset this.Symbol = arguments.Symbol />
		<cfset this.Open = arguments.Open />
		<cfset this.High = arguments.High />
		<cfset this.Low = arguments.Low />
		<cfset this.Close = arguments.Close />
		<cfset this.Volume = arguments.Volume />
		
		<cfreturn this />
	</cffunction>
</cfcomponent>
