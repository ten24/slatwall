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
<cfimport prefix="swa" taglib="../../../tags" />
<cfimport prefix="hb" taglib="../../../org/Hibachi/HibachiTags" />


<cfparam name="rc.taxCategoryRate" type="any" />
<cfparam name="rc.taxCategory" type="any" default="#rc.taxCategoryRate.getTaxCategory()#" />
<cfparam name="rc.integration" type="any" default="" />
<cfparam name="rc.edit" type="boolean" />

<cfif not isNull(rc.taxCategoryRate.getTaxIntegration())>
	<cfset rc.integration = rc.taxCategoryRate.getTaxIntegration() />
</cfif>

<cfoutput>
	<hb:HibachiEntityDetailForm object="#rc.taxCategoryRate#" srenderItem="detailtaxCategory" edit="#rc.edit#">
		<hb:HibachiEntityActionBar type="detail" object="#rc.taxCategoryRate#" edit="#rc.edit#" 
						backAction="admin:entity.detailtaxCategory" 
						backQueryString="taxCategoryID=#rc.taxCategory.getTaxCategoryID()#"
						cancelAction="admin:entity.detailtaxCategory"
						cancelQueryString="taxCategoryID=#rc.taxCategory.getTaxCategoryID()#" />
						
		<cfif rc.edit>
			<input type="hidden" name="taxCategoryID" value="#rc.taxCategory.getTaxCategoryID()#" />
			<input type="hidden" name="taxCategory.TaxCategoryID" value="#rc.taxCategory.getTaxCategoryID()#" />
			<cfif isObject(rc.integration)>
				<input type="hidden" name="taxIntegration.integrationID" value="#rc.integration.getIntegrationID()#" />
			</cfif>
		</cfif>
		
		<hb:HibachiPropertyRow>
			<hb:HibachiPropertyList>
				<hb:HibachiPropertyDisplay object="#rc.taxCategoryRate#" property="taxAddressLookup" edit="#rc.edit#">
				<cfif not isObject(rc.integration)>
					<hb:HibachiPropertyDisplay object="#rc.taxCategoryRate#"  property="taxRate" edit="#rc.edit#" />
				</cfif>
				<cfset rc.taxCategoryRate.getAddressZoneOptions()[1]["name"] = request.slatwallScope.rbKey('define.all') />
				<hb:HibachiPropertyDisplay object="#rc.taxCategoryRate#"  property="addressZone" edit="#rc.edit#">
				<hb:HibachiPropertyDisplay object="#rc.taxCategoryRate#" property="taxCategoryRateCode" edit="#rc.edit#">
				<hb:HibachiPropertyDisplay object="#rc.taxCategoryRate#" property="taxLiabilityAppliedToItemFlag" edit="#rc.edit#">
			</hb:HibachiPropertyList>
		</hb:HibachiPropertyRow>

	</hb:HibachiEntityDetailForm>
</cfoutput>
