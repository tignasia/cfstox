<cfsilent>
<cfapplication 
	name="cfstox" 
	sessionmanagement="Yes" 					
	sessiontimeout="#CreateTimeSpan(0,0,30,0)#" 	
	clientmanagement="Yes">
<cfsetting
 requesttimeout="12000"
 showdebugoutput="true"
 />
<!--- <cfparam name="url.appReload" type="string" default="false" />
<cfif not structKeyExists( application, 'appInitialized' ) or url.appReload>
<cfif FindNoCase(".xml.cfm", GetFileFromPath(GetBaseTemplatePath()))>
	<cflocation url="index.cfm">
</cfif>
	<cflock name="appInitBlock" type="exclusive" timeout="10">
		<cfif not structKeyExists( application, 'appInitialized' ) or url.appReload>
		<cfset StructClear(application) />
			<cfset StructClear(session) />
			<cfset loadresult = createObject('component','config').init().SetVariables() />
			<cfif loadResult EQ FALSE >
				<cfabort showerror="XML Load Error" />
			</cfif>

		</cfif>
	</cflock>
</cfif>

<cfset tickBegin = GetTickCount()>
<!--- <cfset cfcPath = "development.functions"> --->

<cfparam name="session.organizationid" 			default="1">
<cfparam name="session.ReturnOrganizationId" 	default="1">
<cfparam name="organizationID" 					default="1">
<cfparam name="session.FCKFolder" 				default="#session.organizationid#">
<cfparam name="session.Role" 			default="GUEST">
<cfparam name="session.email" 			default="">
<!--- <cfparam name="session.dsn" 			default="touchbase"> --->
<cfparam name="session.MemberId" 		default="0">
<cfparam name="session.SelectedMemberId" default="0">
<cfparam name="session.UserGroupId" 	default="4">
<cfparam name="session.UserGroupName"	default="GUEST">
<cfparam name="session.UserId" 			default="GUEST">

<cfset request.FCKeditor = StructNew()>
<cfset request.FCKeditor.userFilesPath = "/development/userfiles/" & session.FCKFolder & "/">
<cfset  session.memberphotopath = "/development/memberphotos/" & session.organizationid & "/">

<cfinclude template="functions/UDF_StringEncryption.cfm">
<cfinclude template="functions/UDF_StringFunctions.cfm"> --->

</cfsilent>

