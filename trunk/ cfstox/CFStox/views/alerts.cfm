<cfoutput>
<form action="controller.cfm" method="post" id="AddAlert">

<fieldset title="Add Alerts"><legend>Add Alert</legend>
<input type="hidden" id="actionitem" name="actionitem" value="AddAlert">

<label for="Symbol" >Symbol:</label>
<input type="text" style="width:10%" name="Symbol" id="Symbol" value="">

<label for="Action" >Action:</label>
<input type="text" style="width:5%"name="Action" id="Action" value="">

<label for="Message" >Message:</label>
<input type="text" style="width:20%" name="Message" id="Message" value="">

<label for="Value" >Price:</label>
<input type="text" style="width:5%" name="Value" id="Value" value="">

<label for="Strategy" >Strategy:</label>
<input type="text" style="width:5%" name="Strategy" id="Strategy" value="None">

<label for="Alerted" >Alerted:</label>
<input type="text" style="width=5%" name="Alerted" id="Alerted" value="false" >

<label for="Delete" >Delete</label>
<input type="text" style="width=5%" name="Delete" id="Delete" value="false">
</br>
</fieldset>
<input type="submit" name="submit" id="submit" value="Submit" />
</form>

<form action="controller.cfm" method="post" id="UpdateAlerts">
<fieldset title="Edit Alerts"><legend>Edit Alerts</legend>
<input type="hidden" id="actionitem" name="actionitem" value="UpdateAlerts">
<cfloop query="request.context.queryAlerts">
<cfset ischecked = "">

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

<label for="Alerted" >Alerted:</label>
<input type="text" style="width=5%" name="Alerted" id="Alerted" value="#request.context.queryAlerts.alerted#" >

<label for="Delete" >Delete</label>
<input type="text" style="width=5%" name="Delete" id="Delete" value="false">
</br>
</cfloop>
</fieldset>
<input type="submit" name="submit" id="submit" value="Submit" />
</form>
</cfoutput>