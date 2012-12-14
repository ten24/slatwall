<!---

    Slatwall - An Open Source eCommerce Platform
    Copyright (C) 2011 ten24, LLC

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
    
    Linking this library statically or dynamically with other modules is
    making a combined work based on this library.  Thus, the terms and
    conditions of the GNU General Public License cover the whole
    combination.
 
    As a special exception, the copyright holders of this library give you
    permission to link this library with independent modules to produce an
    executable, regardless of the license terms of these independent
    modules, and to copy and distribute the resulting executable under
    terms of your choice, provided that you also meet, for each linked
    independent module, the terms and conditions of the license of that
    module.  An independent module is a module which is not derived from
    or based on this library.  If you modify this library, you may extend
    this exception to your version of the library, but you are not
    obligated to do so.  If you do not wish to do so, delete this
    exception statement from your version.

Notes:

--->
<cfcomponent extends="BaseDAO">
	
	<cffunction name="getAttributeValuesForEntity" returntype="array" access="public">
		<cfargument name="primaryIDPropertyIdentifier">
		<cfargument name="primaryIDValue" />
		
		<cfreturn ormExecuteQuery("SELECT av FROM SlatwallAttributeValue av INNER JOIN FETCH av.attribute att INNER JOIN FETCH att.attributeSet ats WHERE av.#primaryIDPropertyIdentifier# = ?", [arguments.primaryIDValue], false, {ignoreCase="true"}) />
	</cffunction>
	
	<cffunction name="getAttributeCodesQueryByAttributeSetType" returntype="query" access="public">
		<cfargument name="attributeSetType" required="true" type="string" />
		
		<cfset var rs = "" />
		<cfquery name="rs">
			SELECT
				SlatwallAttribute.attributeCode
			FROM
				SlatwallAttribute
			  INNER JOIN
			  	SlatwallAttributeSet on SlatwallAttribute.attributeSetID = SlatwallAttributeSet.attributeSetID
			  INNER JOIN
			  	SlatwallType on SlatwallAttributeSet.attributeSetTypeID = SlatwallType.typeID
			WHERE
				SlatwallType.systemCode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.attributeSetType#"/>
		</cfquery>
		<cfreturn rs />
	</cffunction> 
	
</cfcomponent>