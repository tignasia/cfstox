<cfif IsDefined("form.name")>
<cfdump var="#form#"  label="form">
<cfset requestMap 	= Duplicate(getPageContext().getRequest().getParameterMap()) />		
<cfdump var="#requestMap#" label="requestmap">
<!--- if this is a multipart request ...--->
<cfset loc = StructNew() />
<cfset loc.data = ArrayNew(1) />   
   <cfif StructKeyExists(server, "railo")>
                <cfloop array="#form.getRaw()#" index="loc.i">
                        <cfset loc.t = {key = loc.i.getName(), value = loc.i.getValue()}>
                        <cfset arrayappend(loc.data, loc.t)>
                </cfloop>
		<cfdump var="#loc#" />	
        <cfdump var="#railo.runtime.functions.other.GetPageContext()#">
		<cfelse>
                <cfloop array="#form.getPartsArray()#" index="loc.i">
                	<cfif loc.i.isParam()>
                    	<cfset loc.t.key = loc.i.getName() />
						<cfset loc.t.value = loc.i.getStringValue() />
                    	<cfset arrayappend(loc.data, loc.t) />
                    </cfif>
                </cfloop>
		<cfdump var="#loc#" />	
        </cfif>
        
</cfif>
<form name="test" method="post" id="Test" enctype="multipart/form-data" >
<input type="text" name="Name" id="Name" value="Jim">
<input type="submit" name="submit" id="submit" value="Submit" />
</form>

