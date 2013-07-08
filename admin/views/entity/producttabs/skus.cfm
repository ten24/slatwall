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
<cfoutput>
	<cfset local.skusSmartList = rc.product.getSkusSmartList() />
	<cfset local.skusSmartList.joinRelatedProperty("SlatwallSku", "options", "left", true) />
	
	<cf_HibachiListingDisplay smartList="#local.skusSmartList#"
							   edit="#rc.edit#"
							   recordDetailAction="admin:entity.detailsku"
							   recordDetailQueryString="productID=#rc.product.getProductID()#"
							   recordEditAction="admin:entity.editsku"
							   recordEditQueryString="productID=#rc.product.getProductID()#"
							   selectFieldName="defaultSku.skuID"
							   selectValue="#rc.product.getDefaultSku().getSkuID()#"
							   selectTitle="#$.slatwall.rbKey('define.default')#">
							      
		<cf_HibachiListingColumn tdclass="primary" propertyIdentifier="skuCode" />
		<cf_HibachiListingColumn propertyIdentifier="skuDefinition" />
		<!---
		<cfif rc.product.getBaseProductType() eq "merchandise">
			<cf_HibachiListingColumn propertyIdentifier="optionsDisplay" />
		<cfelseif  rc.product.getProductType().getBaseProductType() eq "subscription">
			<cf_HibachiListingColumn propertyIdentifier="subscriptionTerm.subscriptionTermName" />
		<cfelseif rc.product.getProductType().getBaseProductType() eq "contentAccess">
			<!--- Sumit says nothing is ok --->
		</cfif>
		--->
		<cf_HibachiListingColumn propertyIdentifier="imageFile" />
		<cfif isNull(rc.product.getDefaultSku().getUserDefinedPriceFlag()) || !rc.product.getDefaultSku().getUserDefinedPriceFlag()>
			<cf_HibachiListingColumn propertyIdentifier="listPrice" />
			<cf_HibachiListingColumn propertyIdentifier="price" />
			<cfif  rc.product.getProductType().getBaseProductType() eq "subscription">
				<cf_HibachiListingColumn propertyIdentifier="renewalPrice" />
			</cfif>
			<cf_HibachiListingColumn propertyIdentifier="salePrice" />
		</cfif>
	</cf_HibachiListingDisplay>
	
	<cf_HibachiProcessCaller entity="#rc.product#" action="admin:entity.preprocessproduct" processContext="addOptionGroup" class="btn" icon="plus icon" modal="true" />
	<cf_HibachiProcessCaller entity="#rc.product#" action="admin:entity.preprocessproduct" processContext="addOption" class="btn" icon="plus icon" modal="true" />
	<cf_HibachiProcessCaller entity="#rc.product#" action="admin:entity.preprocessproduct" processContext="addSubscriptionTerm" class="btn" icon="plus icon" modal="true" />
</cfoutput>
