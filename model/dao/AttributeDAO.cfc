<!---

    Slatwall - An Open Source eCommerce Platform
    Copyright (C) ten24, LLC
	
    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.
	
    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.
	
    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
    
    Linking this program statically or dynamically with other modules is
    making a combined work based on this program.  Thus, the terms and
    conditions of the GNU General Public License cover the whole
    combination.
	
    As a special exception, the copyright holders of this program give you
    permission to combine this program with independent modules and your 
    custom code, regardless of the license terms of these independent
    modules, and to copy and distribute the resulting program under terms 
    of your choice, provided that you follow these specific guidelines: 

	- You also meet the terms and conditions of the license of each 
	  independent module 
	- You must not alter the default display of the Slatwall name or logo from  
	  any part of the application 
	- Your custom code must not alter or create any files inside Slatwall, 
	  except in the following directories:
		/integrationServices/

	You may copy and distribute the modified version of this program that meets 
	the above guidelines as a combined work under the terms of GPL for this program, 
	provided that you include the source code of that other code when and as the 
	GNU GPL requires distribution of source code.
    
    If you modify this program, you may extend this exception to your version 
    of the program, but you are not obligated to do so.

Notes:

--->
<cfcomponent extends="HibachiDAO">
	
	<cffunction name="getAttributeValuesForEntity" returntype="array" access="public">
		<cfargument name="primaryIDPropertyIdentifier">
		<cfargument name="primaryIDValue" />
		
		<cfreturn ormExecuteQuery("SELECT av FROM SlatwallAttributeValue av INNER JOIN FETCH av.attribute att INNER JOIN FETCH att.attributeSet ats WHERE av.#primaryIDPropertyIdentifier# = ?", [arguments.primaryIDValue], false, {ignoreCase="true"}) />
	</cffunction>
	
	<cffunction name="getAttributeCodesQueryByAttributeSetObject" returntype="query" access="public">
		<cfargument name="attributeSetObject" required="true" type="string" />
		
		<cfset var rs = "" />
		<cfquery name="rs">
			SELECT
				SwAttribute.attributeCode
			FROM
				SwAttribute
			  INNER JOIN
			  	SwAttributeSet on SwAttribute.attributeSetID = SwAttributeSet.attributeSetID
			WHERE
				SwAttributeSet.attributeSetObject = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.attributeSetObject#"/>
		</cfquery>
		<cfreturn rs />
	</cffunction>
	
	<cffunction name="removeAttributeOptionFromAllAttributeValues">
		<cfargument name="attributeOptionID" type="string" required="true" >
		
		<cfset var rs = "" />
		
		<cfquery name="rs">
			UPDATE
				SwAttributeValue
			SET
				attributeValueOptionID = null
			WHERE
				attributeValueOptionID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.attributeOptionID#" /> 
		</cfquery>
	</cffunction>
	
</cfcomponent>
