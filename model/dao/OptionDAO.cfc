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

	<cffunction name="getNumberOFUsedProductOptions">
		<cfargument name="productID">

		<cfset var rs = "" />

		<cfquery name="rs" maxrows=1>
			SELECT
			count(SwOption.optionID) AS total
			FROM SwOption
			    LEFT JOIN SwSkuOption ON SwSkuOption.optionID = SwOption.optionID
			    LEFT JOIN SwSku ON SwSkuOption.skuID = SwSku.skuID
			    LEFT JOIN SwProduct ON SwSku.productID = SwProduct.productID
			WHERE
			SwProduct.productID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#productID#" />
		</cfquery>
		<cfreturn rs.total[1] />
	</cffunction>

	<cffunction name="getNumberOfOptionsForOptionGroup">
		<cfargument name="optionGroupID">

		<cfset var rs = "" />

		<cfquery name="rs" maxrows=1>
			SELECT
				count(o.optionID) AS total
			FROM SwOption AS o
			WHERE
				o.optionGroupID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#optionGroupID#" />
		</cfquery>


		<cfreturn rs.total[1] />

	</cffunction>

	<cffunction name="getAllUsedProductOptionGroupIDs">

		<cfargument name="productID">

		<cfset var rs = "" />

		<cfquery name="rs">
		SELECT DISTINCT
            SwOptionGroup.optionGroupID
		FROM SwOptionGroup
		    Left Join SwOption on SwOptionGroup.optionGroupID = SwOption.optionGroupID
		    Left Join SwSkuOption on SwSkuOption.optionID = SwOption.optionID
		    Left Join SwSku  on SwSkuOption.skuID = SwSku.skuID
		    Left Join SwProduct on SwSku.productID = SwProduct.productID
		WHERE
		SwProduct.productID=<cfqueryparam cfsqltype="cf_sql_varchar" value="#productID#" />
		</cfquery>

		<cfset var optionGroupIDs = ArrayNew(1) />

		<cfloop query="rs">
			<cfset arrayAppend(optionGroupIDs, ogID) />
		</cfloop>

		<cfreturn optionGroupIDs />

	</cffunction>

	<cffunction name="getUnusedProductOptionGroups">
		<cfargument name="productTypeID" type="string" required="true" />
		<cfargument name="existingOptionGroupIDList" type="string" required="true" />
		
		<cfset var result = [] />
		<cfset var rs = "" />
		
		<cfquery name="rs">
			SELECT
				SwOptionGroup.optionGroupID,
				SwOptionGroup.optionGroupName
			FROM
				SwOptionGroup
			LEFT OUTER JOIN
				SwOptionGroupProductType
   			 ON
       			SwOptionGroup.optionGroupID = SwOptionGroupProductType.optionGroupID
			WHERE
				SwOptionGroup.optionGroupID NOT IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.existingOptionGroupIDList#" list="true">)
			AND
				( SwOptionGroup.globalFLag = <cfqueryparam cfsqltype="cf_sql_bit" value="true"> OR SwOptionGroupProductType.productTypeID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.productTypeID#"> )
			ORDER BY 
				SwOptionGroup.optionGroupName
		</cfquery>
		
		<cfloop query="rs">
			<cfset arrayAppend(result, {name=rs.optionGroupName, value=rs.optionGroupID}) />
		</cfloop>
		
		<cfreturn result />
	</cffunction>

</cfcomponent>

