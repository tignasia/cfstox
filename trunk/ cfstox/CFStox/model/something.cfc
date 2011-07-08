
<cfcomponent displayname="something" output="false">
		<cfproperty name="Date" type="date" default="" />
		<cfproperty name="Symbol" type="string" default="" />
		<cfproperty name="Open" type="numeric" default="" />
		<cfproperty name="High" type="numeric" default="" />
		<cfproperty name="Low" type="numeric" default="" />
		<cfproperty name="Close" type="numeric" default="" />
		<cfproperty name="Volume" type="numeric" default="" />
		
	<!---
	PROPERTIES
	--->
	<cfset variables.instance = StructNew() />

	<!---
	INITIALIZATION / CONFIGURATION
	--->
	<cffunction name="init" access="public" returntype="something" output="false">
		<cfargument name="Date" type="string" required="false" default="" />
		<cfargument name="Symbol" type="string" required="false" default="" />
		<cfargument name="Open" type="string" required="false" default="" />
		<cfargument name="High" type="string" required="false" default="" />
		<cfargument name="Low" type="string" required="false" default="" />
		<cfargument name="Close" type="string" required="false" default="" />
		<cfargument name="Volume" type="string" required="false" default="" />
		
		<!--- run setters --->
		<cfset setDate(arguments.Date) />
		<cfset setSymbol(arguments.Symbol) />
		<cfset setOpen(arguments.Open) />
		<cfset setHigh(arguments.High) />
		<cfset setLow(arguments.Low) />
		<cfset setClose(arguments.Close) />
		<cfset setVolume(arguments.Volume) />
		
		<cfreturn this />
 	</cffunction>

	<!---
	PUBLIC FUNCTIONS
	--->
	<cffunction name="setMemento" access="public" returntype="something" output="false">
		<cfargument name="memento" type="struct" required="yes"/>
		<cfset variables.instance = arguments.memento />
		<cfreturn this />
	</cffunction>
	<cffunction name="getMemento" access="public" returntype="struct" output="false" >
		<cfreturn variables.instance />
	</cffunction>

	<cffunction name="validate" access="public" returntype="array" output="false">
		<cfset var errors = arrayNew(1) />
		<cfset var thisError = structNew() />
		
		<!--- Date --->
		<cfif (len(trim(getDate())) AND NOT isDate(trim(getDate())))>
			<cfset thisError.field = "Date" />
			<cfset thisError.type = "invalidType" />
			<cfset thisError.message = "Date is not a date" />
			<cfset arrayAppend(errors,duplicate(thisError)) />
		</cfif>
		
		<!--- Symbol --->
		<cfif (len(trim(getSymbol())) AND NOT IsSimpleValue(trim(getSymbol())))>
			<cfset thisError.field = "Symbol" />
			<cfset thisError.type = "invalidType" />
			<cfset thisError.message = "Symbol is not a string" />
			<cfset arrayAppend(errors,duplicate(thisError)) />
		</cfif>
		<cfif (len(trim(getSymbol())) GT 10)>
			<cfset thisError.field = "Symbol" />
			<cfset thisError.type = "tooLong" />
			<cfset thisError.message = "Symbol is too long" />
			<cfset arrayAppend(errors,duplicate(thisError)) />
		</cfif>
		
		<!--- Open --->
		<cfif (len(trim(getOpen())) AND NOT isNumeric(trim(getOpen())))>
			<cfset thisError.field = "Open" />
			<cfset thisError.type = "invalidType" />
			<cfset thisError.message = "Open is not numeric" />
			<cfset arrayAppend(errors,duplicate(thisError)) />
		</cfif>
		
		<!--- High --->
		<cfif (len(trim(getHigh())) AND NOT isNumeric(trim(getHigh())))>
			<cfset thisError.field = "High" />
			<cfset thisError.type = "invalidType" />
			<cfset thisError.message = "High is not numeric" />
			<cfset arrayAppend(errors,duplicate(thisError)) />
		</cfif>
		
		<!--- Low --->
		<cfif (len(trim(getLow())) AND NOT isNumeric(trim(getLow())))>
			<cfset thisError.field = "Low" />
			<cfset thisError.type = "invalidType" />
			<cfset thisError.message = "Low is not numeric" />
			<cfset arrayAppend(errors,duplicate(thisError)) />
		</cfif>
		
		<!--- Close --->
		<cfif (len(trim(getClose())) AND NOT isNumeric(trim(getClose())))>
			<cfset thisError.field = "Close" />
			<cfset thisError.type = "invalidType" />
			<cfset thisError.message = "Close is not numeric" />
			<cfset arrayAppend(errors,duplicate(thisError)) />
		</cfif>
		
		<!--- Volume --->
		<cfif (len(trim(getVolume())) AND NOT isNumeric(trim(getVolume())))>
			<cfset thisError.field = "Volume" />
			<cfset thisError.type = "invalidType" />
			<cfset thisError.message = "Volume is not numeric" />
			<cfset arrayAppend(errors,duplicate(thisError)) />
		</cfif>
		
		<cfreturn errors />
	</cffunction>

	<!---
	ACCESSORS
	--->
	<cffunction name="setDate" access="public" returntype="void" output="false">
		<cfargument name="Date" type="string" required="true" />
		<cfset variables.instance.Date = arguments.Date />
	</cffunction>
	<cffunction name="getDate" access="public" returntype="string" output="false">
		<cfreturn variables.instance.Date />
	</cffunction>

	<cffunction name="setSymbol" access="public" returntype="void" output="false">
		<cfargument name="Symbol" type="string" required="true" />
		<cfset variables.instance.Symbol = arguments.Symbol />
	</cffunction>
	<cffunction name="getSymbol" access="public" returntype="string" output="false">
		<cfreturn variables.instance.Symbol />
	</cffunction>

	<cffunction name="setOpen" access="public" returntype="void" output="false">
		<cfargument name="Open" type="string" required="true" />
		<cfset variables.instance.Open = arguments.Open />
	</cffunction>
	<cffunction name="getOpen" access="public" returntype="string" output="false">
		<cfreturn variables.instance.Open />
	</cffunction>

	<cffunction name="setHigh" access="public" returntype="void" output="false">
		<cfargument name="High" type="string" required="true" />
		<cfset variables.instance.High = arguments.High />
	</cffunction>
	<cffunction name="getHigh" access="public" returntype="string" output="false">
		<cfreturn variables.instance.High />
	</cffunction>

	<cffunction name="setLow" access="public" returntype="void" output="false">
		<cfargument name="Low" type="string" required="true" />
		<cfset variables.instance.Low = arguments.Low />
	</cffunction>
	<cffunction name="getLow" access="public" returntype="string" output="false">
		<cfreturn variables.instance.Low />
	</cffunction>

	<cffunction name="setClose" access="public" returntype="void" output="false">
		<cfargument name="Close" type="string" required="true" />
		<cfset variables.instance.Close = arguments.Close />
	</cffunction>
	<cffunction name="getClose" access="public" returntype="string" output="false">
		<cfreturn variables.instance.Close />
	</cffunction>

	<cffunction name="setVolume" access="public" returntype="void" output="false">
		<cfargument name="Volume" type="string" required="true" />
		<cfset variables.instance.Volume = arguments.Volume />
	</cffunction>
	<cffunction name="getVolume" access="public" returntype="string" output="false">
		<cfreturn variables.instance.Volume />
	</cffunction>


	<!---
	DUMP
	--->
	<cffunction name="dump" access="public" output="true" return="void">
		<cfargument name="abort" type="boolean" default="false" />
		<cfdump var="#variables.instance#" />
		<cfif arguments.abort>
			<cfabort />
		</cfif>
	</cffunction>

</cfcomponent>
