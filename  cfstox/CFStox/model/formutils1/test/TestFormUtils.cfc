<cfcomponent extends="mxunit.framework.TestCase">
	
	<cffunction name="setUp" output="false" access="public" returntype="void" hint="">
		
		<cfset util = CreateObject('component', 'formutils.FormUtilities').init() />
		
		<cfset formData = {} />
		<cfset formData['COMPANY[1].NAME.FIRSTNAME.PREFIX'] = 'company[1]' />
		<cfset formData['COMPANY[1].PHONE[2].SOMETHING[5]'] = 	'company[1]' />
		<cfset formData['EMPLOYEE[1].MODE[1]'] = 'employee[1].mode[1]' />
		<cfset formData['EMPLOYEE[1].MODE[2]'] = 'employee[1].mode[2]' />
		<cfset formData['EMPLOYEE[1].NAME'] = 	'employee[1]' />
		<cfset formData['EMPLOYEE[1].PERMISSION.1'] = 'employee[1].permission.1' />
		<cfset formData['EMPLOYEE[1].PERMISSION.2'] = 'employee[1].permission.2' />
		<cfset formData['EMPLOYEE[1].PHONE'] = 'employee[1]' />
		<cfset formData['EMPLOYEE[2].MODE[1]'] = 'employee[2]mode[1]' />
		<cfset formData['EMPLOYEE[2].MODE[2]'] = 'employee[2]mode[2]' />
		<cfset formData['EMPLOYEE[2].NAME'] = 'employee[2]' />
		<cfset formData['EMPLOYEE[2].PERMISSION.1'] = 'employee[2].permission.1' />
		<cfset formData['EMPLOYEE[2].PERMISSION.2'] = 'employee[2].permission.2' />
		<cfset formData['EMPLOYEE[2].PHONE'] = 'employee[2]' />
		<cfset formData['EXISTINGVALUES'] = '2,5,9,488' />
		<cfset formData['FIELDNAMES'] = 'PERMISSION.ID,PERMISSION.PERMISSION[2],PERMISSION.PERMISSION[1],USER.ID,USER.NAME,USER.PASSWORD,SOMETHING,MORE{,{STILL_MORE},{STILL_MORE2},{MORE,USER2.ID,USER2.NAME,USER2.PASSWORD,USER2.PERMISSION[2],USER2.PERMISSION[1],USER2.CATEGORY.11,USER2.CATEGORY.8,USER2.USERTYPE,EMPLOYEE[1].NAME,EMPLOYEE[1].PHONE,EMPLOYEE[1].PERMISSION.2,EMPLOYEE[1].PERMISSION.1,EMPLOYEE[1].MODE[2],EMPLOYEE[1].MODE[1],EMPLOYEE[2].NAME,EMPLOYEE[2].PHONE,EMPLOYEE[2].PERMISSION.2,EMPLOYEE[2].PERMISSION.1,EMPLOYEE[2].MODE[1],EMPLOYEE[2].MODE[2],COMPANY[1].NAME.FIRSTNAME.PREFIX,COMPANY[1].PHONE[2].SOMETHING[5],EXISTINGVALUES,NEWVALUES,SUBMIT' />
		<cfset formData['MORE{'] = 'misc' />
		<cfset formData['NEWVALUES'] = '1,5,22,488,19' />
		<cfset formData['PERMISSION.ID'] = 'permID' />
		<cfset formData['PERMISSION.PERMISSION[1]'] = 'perm name 1' />
		<cfset formData['PERMISSION.PERMISSION[2]'] = 'perm name 2' />
		<cfset formData['SOMETHING'] = 'misc' />
		<cfset formData['SUBMIT'] = 'submit' />
		<cfset formData['USER.ID'] = 'user' />
		<cfset formData['USER.NAME'] = 'user' />
		<cfset formData['USER.PASSWORD'] = 'user' />
		<cfset formData['USER2.CATEGORY.11'] = 'user2' />
		<cfset formData['USER2.CATEGORY.8'] = 'user2' />
		<cfset formData['USER2.ID'] = 'user2' />
		<cfset formData['USER2.NAME'] = 'user2' />
		<cfset formData['USER2.PASSWORD'] = 'user2' />
		<cfset formData['USER2.PERMISSION[1]'] = 'user2.permission[1]' />
		<cfset formData['USER2.PERMISSION[2]'] = 'user2.permission[2]' />
		<cfset formData['USER2.USERTYPE'] = 'user2type1,user2type2' />
		<cfset formData['{MORE'] = 'misc' />
		<cfset formData['{STILL_MORE2}'] = 'misc' />
		<cfset formData['{STILL_MORE}'] = 'misc' />
		
		<cffile action="read" file="#ExpandPath('result.xml')#" variable="resultWDDX" />
		<cfwddx action="wddx2cfml" input="#resultWDDX#" output="result">
		
	</cffunction>

	<cffunction name="tearDown" output="false" access="public" returntype="void" hint="">
	</cffunction>
	
	<cffunction name="testCollectionCreation" access="public" returntype="void">
		<cfset var local = {} />
		<cfset util.buildFormCollections(formData) />
		<!--- <cfdump var="#formData.employee#">
		<cfdump var="#result.employee#"><cfabort> --->
		<cfloop list="#formData.formCollectionsList#" index="local.thisColl" delimiters=",">
			<cfif isArray(formData[local.thisColl])>
				<cfset assertTrue(arrayCompare(formData[local.thisColl], result[local.thisColl]), 'Collection #local.thisColl# does not match expected results.') />			
			<cfelseif isStruct(formData[local.thisColl])>
				<cfset assertTrue(structCompare(formData[local.thisColl], result[local.thisColl]), 'Collection #local.thisColl# does not match expected results.') />
			</cfif>
		</cfloop>
	</cffunction>
	
	<cffunction name="arrayCompare" access="private" returntype="any" output="false" hint="">
		<cfargument name="LeftArray" type="array" required="true" />
		<cfargument name="RightArray" type="array" required="true" />
		<cfscript>
		    var result = true;
		    var i = "";
		    
		    //Make sure both params are arrays
		    if (NOT (isArray(LeftArray) AND isArray(RightArray))) return false;
		    
		    //Make sure both arrays have the same length
		    if (NOT arrayLen(LeftArray) EQ arrayLen(RightArray)) return false;
		    
		    // Loop through the elements and compare them one at a time
		    for (i=1;i lte arrayLen(LeftArray); i = i+1) {
		    	if(ArrayIsDefined(LeftArray, i)) {
			        //elements is a structure, call structCompare()
			        if (isStruct(LeftArray[i])){
			            result = structCompare(LeftArray[i],RightArray[i]);
			            if (NOT result) return false;
			        //elements is an array, call arrayCompare()
			        } else if (isArray(LeftArray[i])){
			            result = arrayCompare(LeftArray[i],RightArray[i]);
			            if (NOT result) return false;
			        //A simple type comparison here
			        } else {
			            if(LeftArray[i] IS NOT RightArray[i]) return false;
			        }
		    	}
		    }
		    
		    return true;
		</cfscript>
	</cffunction>
	
	<cffunction name="structCompare" access="private" returntype="any" output="false" hint="">
		<cfargument name="LeftStruct" type="struct" required="true" />
		<cfargument name="RightStruct" type="struct" required="true" />
		<cfscript>
		    var result = true;
		    var LeftStructKeys = "";
		    var RightStructKeys = "";
		    var key = "";
		    
		    //Make sure both params are structures
		    if (NOT (isStruct(LeftStruct) AND isStruct(RightStruct))) return false;
		
		    //Make sure both structures have the same keys
		    LeftStructKeys = ListSort(StructKeyList(LeftStruct),"TextNoCase","ASC");
		    RightStructKeys = ListSort(StructKeyList(RightStruct),"TextNoCase","ASC");
		    if(LeftStructKeys neq RightStructKeys) return false;    
		    
		    // Loop through the keys and compare them one at a time
		    for (key in LeftStruct) {
		        //Key is a structure, call structCompare()
		        if (isStruct(LeftStruct[key])){
		            result = structCompare(LeftStruct[key],RightStruct[key]);
		            if (NOT result) return false;
		        //Key is an array, call arrayCompare()
		        } else if (isArray(LeftStruct[key])){
		            result = arrayCompare(LeftStruct[key],RightStruct[key]);
		            if (NOT result) return false;
		        // A simple type comparison here
		        } else {
		            if(LeftStruct[key] IS NOT RightStruct[key]) return false;
		        }
		    }
		    return true;
		</cfscript>
	</cffunction>
	
	
	
</cfcomponent>