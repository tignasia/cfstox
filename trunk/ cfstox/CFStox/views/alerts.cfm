<cfoutput>
<form action="controller.cfm" method="post" id="alerts">

<fieldset title="Alerts"><legend>Edit Alerts</legend>
<input type="hidden" id="actionitem" name="actionitem" value="updatealertsTEST">

<label for="Symbol" style="width=30%" >Symbol:</label>
<input type="text" name="Symbol" id="Symbol" value="">

<label for="Action" style="width=30%">Action:</label>
<input type="text" name="Action" id="Action" value="">

<label for="Message" style="width=30%">Message:</label>
<input type="text" name="Message" id="Message" value="">

<label for="Value" style="width=30%">Price:</label>
<input type="text" name="Value" id="Value" value="">

<label for="Strategy" style="width=30%">Strategy:</label>
<input type="text" name="Strategy" id="Strategy" value="None">
</br>
<cfdump var="#request.context.queryAlerts#">
<cfloop query="request.context.queryAlerts">
<cfset ischecked = "">
<cfif request.context.queryAlerts.alerted EQ "true">
	<cfset ischecked = "checked">
</cfif>
<label for="Symbol" style="width=30%" >Symbol:</label>
<input type="text" name="Symbol" id="Symbol" value="#request.context.queryAlerts.symbol#">

<label for="Action" style="width=30%">Action:</label>
<input type="text" name="Action" id="Action" value="#request.context.queryAlerts.action#">

<label for="Message" style="width=60%">Message:</label>
<input type="text" name="Message" id="Message" value="#request.context.queryAlerts.message#">

<label for="Value" style="width=30%">Price:</label>
<input type="text" name="Value" id="Value" value="#request.context.queryAlerts.value#">

<label for="Strategy" style="width=30%">Strategy:</label>
<input type="text" name="Strategy" id="Strategy" value="#request.context.queryAlerts.strategy#">

<label for="Alerted" style="width=30%">Alerted:</label>
<input type="checkbox" name="Alerted" id="Alerted" value="#request.context.queryAlerts.alerted#" #ischecked#>

<label for="Delete" style="width=30%">Delete</label>
<input type="checkbox" name="Delete" id="Delete">
</br>
</cfloop>
</fieldset>
<input type="submit" name="submit" id="submit" value="Submit" />
</form>
</cfoutput>