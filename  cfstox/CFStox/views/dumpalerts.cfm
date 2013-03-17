<cfoutput>
<cfdump var=#form#>
<cfset formsize = form.Size() />
<cfset a_symbol = ListtoArray(form.Symbol)	>
<cfset a_action = ListtoArray(form.action)	>
<cfset a_message = ListtoArray(form.message) >
<cfset a_value = ListtoArray(form.value) >
<cfdump var="#formsize#">
<cfdump var="#a_message#">
<cfloop from="1" to="4" index="i">
<cfset AlertBean = session.objects.AlertService.GetAlertBean() />
<cfset AlertBean.SetSymbol(a_symbol[i]) />
<cfset AlertBean.SetAction(a_action[i]) />
<cfset AlertBean.SetMessage(a_message[i]) />
<cfset AlertBean.SetValue(a_value[i]) />
<cfset AlertBean = session.objects.AlertService.SetAlert(AlertBean) />
</cfloop> 
</cfoutput>