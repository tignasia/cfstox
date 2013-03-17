
<cfcomponent displayname="Alert" output="false">
<cfproperty name="Symbol" type="string" default="" />
<cfproperty name="Value" type="string" default="" />
<cfproperty name="Action" type="string" default="" />
<cfproperty name="ALERTED" type="string" default="" />
<cfproperty name="MESSAGE" type="string" default="" />
<cfproperty name="Strategy" type="string" default="" />
		
	<!---
	PROPERTIES
	--->
	<cfset variables.instance = StructNew() />

	<!---
	INITIALIZATION / CONFIGURATION
	--->
	<cffunction name="init" access="public" returntype="AlertBean" output="false">
		<cfargument name="Symbol" type="string" required="false" default="" />
		<cfargument name="Value" type="string" required="false" default="" />
		<cfargument name="Action" type="string" required="false" default="" />
		<cfargument name="ALERTED" type="string" required="false" default="" />
		<cfargument name="MESSAGE" type="string" required="false" default="" />
		<cfargument name="STRATEGY" type="string" required="false" default="" />
		<!--- run setters --->
		<cfset setSymbol(arguments.Symbol) />
		<cfset setValue(arguments.Value) />
		<cfset setAction(arguments.Action) />
		<cfset setALERTED(arguments.ALERTED) />
		<cfset setMESSAGE(arguments.MESSAGE) />
		<cfset setSTRATEGY(arguments.STRATEGY) />
		<cfreturn this />
 	</cffunction>

	<!---
	PUBLIC FUNCTIONS
	--->
	<cffunction name="setMemento" access="public" returntype="any" output="false">
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
		
		<!--- Symbol --->
		<cfif (NOT len(trim(getSymbol())))>
			<cfset thisError.field = "Symbol" />
			<cfset thisError.type = "required" />
			<cfset thisError.message = "Symbol is required" />
			<cfset arrayAppend(errors,duplicate(thisError)) />
		</cfif>
		<cfif (len(trim(getSymbol())) AND NOT IsSimpleValue(trim(getSymbol())))>
			<cfset thisError.field = "Symbol" />
			<cfset thisError.type = "invalidType" />
			<cfset thisError.message = "Symbol is not a string" />
			<cfset arrayAppend(errors,duplicate(thisError)) />
		</cfif>
		<cfif (len(trim(getSymbol())) GT 4)>
			<cfset thisError.field = "Symbol" />
			<cfset thisError.type = "tooLong" />
			<cfset thisError.message = "Symbol is too long" />
			<cfset arrayAppend(errors,duplicate(thisError)) />
		</cfif>
		
		<!--- Value --->
		<cfif (NOT len(trim(getValue())))>
			<cfset thisError.field = "Value" />
			<cfset thisError.type = "required" />
			<cfset thisError.message = "Value is required" />
			<cfset arrayAppend(errors,duplicate(thisError)) />
		</cfif>
		<cfif (len(trim(getValue())) AND NOT IsSimpleValue(trim(getValue())))>
			<cfset thisError.field = "Value" />
			<cfset thisError.type = "invalidType" />
			<cfset thisError.message = "Value is not a string" />
			<cfset arrayAppend(errors,duplicate(thisError)) />
		</cfif>
		<cfif (len(trim(getValue())) GT 8)>
			<cfset thisError.field = "Value" />
			<cfset thisError.type = "tooLong" />
			<cfset thisError.message = "Value is too long" />
			<cfset arrayAppend(errors,duplicate(thisError)) />
		</cfif>
		
		<!--- Action --->
		<cfif (NOT len(trim(getAction())))>
			<cfset thisError.field = "Action" />
			<cfset thisError.type = "required" />
			<cfset thisError.message = "Action is required" />
			<cfset arrayAppend(errors,duplicate(thisError)) />
		</cfif>
		<cfif (len(trim(getAction())) AND NOT IsSimpleValue(trim(getAction())))>
			<cfset thisError.field = "Action" />
			<cfset thisError.type = "invalidType" />
			<cfset thisError.message = "Action is not a string" />
			<cfset arrayAppend(errors,duplicate(thisError)) />
		</cfif>
		<cfif (len(trim(getAction())) GT 200)>
			<cfset thisError.field = "Action" />
			<cfset thisError.type = "tooLong" />
			<cfset thisError.message = "Action is too long" />
			<cfset arrayAppend(errors,duplicate(thisError)) />
		</cfif>
		
		<!--- ALERTED --->
		<cfif (len(trim(getALERTED())) AND NOT IsSimpleValue(trim(getALERTED())))>
			<cfset thisError.field = "ALERTED" />
			<cfset thisError.type = "invalidType" />
			<cfset thisError.message = "ALERTED is not a string" />
			<cfset arrayAppend(errors,duplicate(thisError)) />
		</cfif>
		<cfif (len(trim(getALERTED())) GT 5)>
			<cfset thisError.field = "ALERTED" />
			<cfset thisError.type = "tooLong" />
			<cfset thisError.message = "ALERTED is too long" />
			<cfset arrayAppend(errors,duplicate(thisError)) />
		</cfif>
		
		<!--- MESSAGE --->
		<cfif (len(trim(getMESSAGE())) AND NOT IsSimpleValue(trim(getMESSAGE())))>
			<cfset thisError.field = "MESSAGE" />
			<cfset thisError.type = "invalidType" />
			<cfset thisError.message = "MESSAGE is not a string" />
			<cfset arrayAppend(errors,duplicate(thisError)) />
		</cfif>
		<cfif (len(trim(getMESSAGE())) GT 500)>
			<cfset thisError.field = "MESSAGE" />
			<cfset thisError.type = "tooLong" />
			<cfset thisError.message = "MESSAGE is too long" />
			<cfset arrayAppend(errors,duplicate(thisError)) />
		</cfif>
		
		<cfreturn errors />
	</cffunction>

	<!---
	ACCESSORS
	--->
	<cffunction name="setSymbol" access="public" returntype="void" output="false">
		<cfargument name="Symbol" type="string" required="true" />
		<cfset variables.instance.Symbol = arguments.Symbol />
	</cffunction>
	<cffunction name="getSymbol" access="public" returntype="string" output="false">
		<cfreturn variables.instance.Symbol />
	</cffunction>

	<cffunction name="setValue" access="public" returntype="void" output="false">
		<cfargument name="Value" type="string" required="true" />
		<cfset variables.instance.Value = arguments.Value />
	</cffunction>
	<cffunction name="getValue" access="public" returntype="string" output="false">
		<cfreturn variables.instance.Value />
	</cffunction>

	<cffunction name="setAction" access="public" returntype="void" output="false">
		<cfargument name="Action" type="string" required="true" />
		<cfset variables.instance.Action = arguments.Action />
	</cffunction>
	<cffunction name="getAction" access="public" returntype="string" output="false">
		<cfreturn variables.instance.Action />
	</cffunction>

	<cffunction name="setALERTED" access="public" returntype="void" output="false">
		<cfargument name="ALERTED" type="string" required="true" />
		<cfset variables.instance.ALERTED = arguments.ALERTED />
	</cffunction>
	<cffunction name="getALERTED" access="public" returntype="string" output="false">
		<cfreturn variables.instance.ALERTED />
	</cffunction>

	<cffunction name="setMESSAGE" access="public" returntype="void" output="false">
		<cfargument name="MESSAGE" type="string" required="true" />
		<cfset variables.instance.MESSAGE = arguments.MESSAGE />
	</cffunction>
	<cffunction name="getMESSAGE" access="public" returntype="string" output="false">
		<cfreturn variables.instance.MESSAGE />
	</cffunction>

	<cffunction name="setStrategy" access="public" returntype="void" output="false">
		<cfargument name="Strategy" type="string" required="true" />
		<cfset variables.instance.Strategy = arguments.Strategy />
	</cffunction>
	<cffunction name="getStrategy" access="public" returntype="string" output="false">
		<cfreturn variables.instance.Strategy />
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
