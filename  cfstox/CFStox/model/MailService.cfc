<cfcomponent displayname="Amazon SES emailer" hint="I send mail via Amazon SES" output="false">

<cffunction name="init" access="public" output="false" >
	<cfreturn this>
</cffunction>

<cffunction name="sendmail" access="public" debug="true">
	<cfargument name="subject" required="false" default="test mail message">
	<cfargument name="emailbody" required="false" default="this is a test email">
	<cfmail  
	subject	= "#arguments.subject#" 
	from	= "jimcollins+aws@gmail.com" 
	to		= "jimcollins+aws@gmail.com" 
	>
	#arguments.emailbody#
	</cfmail>
	<cfreturn>
</cffunction>

</cfcomponent>