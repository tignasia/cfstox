<cfoutput>
<form action="controller.cfm" method="post" id="AddAlert">

<fieldset title="Add Alerts"><legend>Add Alert</legend>
<input type="hidden" id="actionitem" name="actionitem" value="AddAlert">

<label for="Symbol" >Symbol:</label>
<input type="text" style="width:10%" name="Symbol" id="Symbol" value="">

<label for="Action" >Action:</label>
<input type="select" style="width:5%"name="Action" id="Action" value="">

<label for="Message" >Message:</label>
<input type="text" style="width:20%" name="Message" id="Message" value="">

<label for="Value" >Price:</label>
<input type="text" style="width:5%" name="Value" id="Value" value="">

<label for="Strategy" >Strategy:</label>
<input type="text" style="width:5%" name="Strategy" id="Strategy" value="None">

<label for="Alerted" >Alerted:</label>
<input type="radio" style="width=5%" name="Alerted" id="Alerted" value="false" checked>
<input type="radio" style="width=5%" name="Alerted" id="Alerted" value="true" >

<label for="Delete" >Delete</label>
<input type="radio" style="width=5%" name="Delete" id="Delete" value="false" checked>
<input type="radio" style="width=5%" name="Delete" id="Delete" value="true">
</br>
</fieldset>
<input type="submit" name="submit" id="submit" value="Submit" />
</form>

<form action="controller.cfm" method="post" id="UpdateAlerts">
<fieldset title="Edit Alerts"><legend>Edit Alerts</legend>
<input type="hidden" id="actionitem" name="actionitem" value="UpdateAlerts">
<cfloop query="request.context.queryAlerts">
<cfset ischecked = "">
<cfset curritem = request.context.queryAlerts.currentrow />

<label for="Symbol" >Symbol:</label>
<input type="text" style="width:10%" name="Symbol" id="Symbol" value="#request.context.queryAlerts.symbol#">

<label for="Action" >Action:</label>
<input type="text" style="width:5%" name="Action" id="Action" value="#request.context.queryAlerts.action#">

<label for="Message"> Message:</label>
<input type="text" style="width:20%" name="Message" id="Message" value="#request.context.queryAlerts.message#">

<label for="Value" >Price:</label>
<input type="text" style="width:5%" name="Value" id="Value" value="#request.context.queryAlerts.value#">

<label for="Strategy" >Strategy:</label>
<input type="text" style="width:5%" name="Strategy" id="Strategy" value="#request.context.queryAlerts.strategy#">

<label for="Alerted" >Alerted false/true:</label>
<input type="radio" style="width=5%" name="Alerted#curritem#" id="Alerted" value="false" 
<cfif NOT request.context.queryAlerts.alerted >checked</cfif>
>
<input type="radio" style="width=5%" name="Alerted#curritem#" id="Alerted" value="true" 
<cfif request.context.queryAlerts.alerted >checked</cfif>
>
<label for="Delete" >Delete false/true:</label>
<input type="radio" style="width=5%" name="Delete#curritem#" id="Delete" value="false" checked>
<input type="radio" style="width=5%" name="Delete#curritem#" id="Delete" value="true">
</br>
</cfloop>
<input type="hidden" id="itemcount" name="itemcount" value="#curritem#">
</fieldset>
<input type="submit" name="submit" id="submit" value="Submit" />
</form>
</cfoutput>