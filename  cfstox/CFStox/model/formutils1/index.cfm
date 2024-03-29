<cfif StructKeyExists(form, 'submit')>
	
	<cfset util = CreateObject('component', 'FormUtilities').init() />
	
	<cftimer type="debug" label="build form collections">
	<cfset util.buildFormCollections(form) />
	</cftimer>
<cfoutput>
	
	<cfloop list="#form.formCollectionsList#" index="thisColl" delimiters=",">
		<cfdump var="#form[thisColl]#" label="#thisColl#"><br/>
	</cfloop>
	<br />
	<cfdump var="#util.compareLists(form.existingValues, form.newValues)#" label="Results of list compare.">
	
</cfoutput>
<cfelse>

<form name="testform" action="index.cfm" method="post">
	permission<br />
	<input name="permission.id" type="text" value="permID"><br />
	<input name="permission.permission[2]" type="text" value="perm name 2"><br />
	<input name="permission.permission[1]" type="text" value="perm name 1"><br />
	
	user<br />
	<input name="user.id" type="text" value="user"><br />
	<input name="user.name" type="text" value="user"><br />
	<input name="user.password" type="text" value="user"><br />
	
	misc<br />
	<input name="something" type="text" value="misc"><br />
	<input name="more{" type="text" value="misc"><br />
	<input name="{still_more}" type="text" value="misc"><br />
	<input name="{still_more2}" type="text" value="misc"><br />
	<input name="{more" type="text" value="misc"><br /> 
	
	user2<br />
	<input name="user2.id" type="text" value="user2"><br />
	<input name="user2.name" type="text" value="user2"><br />
	<input name="user2.password" type="text" value="user2"><br />
	
	<input name="user2.permission[2]" type="text" value="user2.permission[2]"><br />
	<input name="user2.permission[1]" type="text" value="user2.permission[1]"><br />
	
	<input name="user2.category.11" type="text" value="user2"><br />
	<input name="user2.category.8" type="text" value="user2"><br />
	
	<input name="user2.userType" type="text" value="user2type1"><br />
	<input name="user2.userType" type="text" value="user2type2"><br />
	
	employee[1]<br />
	<input name="employee[1].name" type="text" value="employee [1]"><br />
	<input name="employee[1].phone" type="text" value="employee [1]"><br />
	<input name="employee[1].permission.2" type="text" value="employee [1].permission.2"><br />
	<input name="employee[1].permission.1" type="text" value="employee [1].permission.1"><br />
	<input name="employee[1].mode[2]" type="text" value="employee [1].mode [2]"><br />
	<input name="employee[1].mode[1]" type="text" value="employee [1].mode [1]"><br />
	
	employee[2]<br />
	<input name="employee[2].name" type="text" value="employee[2]"><br />
	<input name="employee[2].phone" type="text" value="employee[2]"><br />
	<input name="employee[2].permission.2" type="text" value="employee[2].permission.2"><br />
	<input name="employee[2].permission.1" type="text" value="employee[2].permission.1"><br />
	<input name="employee[2].mode[1]" type="text" value="employee[2]mode[1]"><br />
	<input name="employee[2].mode[2]" type="text" value="employee[2]mode[2]"><br />
	
	employee[3]<br />
	<input id="company[1].name.firstName.prefix" name="company[1].name.firstName.prefix" type="text" value="company[1]"><br />
	<input name="company[1].phone[2].something[5]" type="text" value="company[1]"><br /><br />
	
	This demonstrates the list compare utility function, by comparing an old list (in a hidden form field) to a new one.<br />
	For comparison, the old values in the hidden field are: 2,5,9,488
	<input name="existingValues" type="hidden" value="2,5,9,488"><br />
	<input name="newValues" type="text" value="1,5,22,488,19"><br />
	
	<br />
	<input type="submit" name="submit" value="submit">
</form>

</cfif>
