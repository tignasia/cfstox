<!--- unload everything - do a reload if requested --->
<cfset init() />
<!--- load the controller object if not already loaded and set the controller flag  --->
<cfset session.objects.controller = createObject("component","controller").init() />
<cfset session.controllerLoaded = True />
<cfinvoke component="#session.objects.controller#" method="#form.action#"  argumentcollection="#form#"  returnvariable="resultData" />
<cfinclude template="../views/#resultdata.view#.cfm" >

<cffunction name="init" description="init" returntype="void">
		<!--- <cfif NOT StructKeyExists("session.controllerLoaded") OR session.controllerLoaded IS FALSE >
		</cfif>
		<cfif NOT StructKeyExists("session.objects") >
			<cfset session.objects = StructNew() />
		</cfif>
		<cfset structKeyDelete(session.controller) />
		<cfset session.controllerLoaded = False />
		<cfset session.objects = StructNew() />
		<cfloop collection="session.objects" item="objectname">
			<cfset structkeydelete(session.objects[#objectname#])>
		</cfloop>
		</cfif> --->
	<cfreturn />
</cffunction>

<cffunction name="reload" description="reload objects" returntype="void">
	<cfif isDefined("url.reload") OR development IS TRUE>
		<cfset structKeyDelete(session.objects.controller) />
		<cfset session.controllerLoaded = False />
		<cfif isDefined("session.objects")>
			<cfset StructKeyDelete("session.objects")>
		</cfif>
		<cfset session.objects = StructNew() />
		<cfloop collection="session.objects" item="objectname">
			<cfset structkeydelete(session.objects[#objectname#])>
		</cfloop>
	</cfif>
	<cfreturn />
</cffunction>