<!--- unload everything - do a reload if requested --->
<cfset init() />
<!--- load the controller object if not already loaded and set the controller flag  --->
<cfset session.controller = createObject("component","controller").init() />
<cfset session.controllerLoaded = True />

<!--- load the objects that we might need if not already loaded and set the loaded flag in session --->
<cfset session.ta 		= createObject("component","cfstox.model.ta").init() />
<cfset session.objects.ta = "ta">
<cfset session.http 	= createObject("component","cfstox.model.http").init() />
<cfset session.objects.http = "http">
<cfset session.utility 	= createObject("component","cfstox.model.utility").init() />
<cfset session.objects.utility = "utility">
<!--- test the objects, if fail, report error and unload them--->
<!--- figure out what we want to do --->

<cfinvoke  component="controller" method="#form.action#"  argumentcollection="form"  returnvariable="resultData" />
<cflocation url="views/#resultdata.view#.cfm">

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
		<cfset structKeyDelete(session.controller) />
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