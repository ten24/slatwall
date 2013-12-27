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
<cfoutput>
	
	<cfset local.bundleSkusSmartList = rc.product.getBundleSkusSmartList() />
	
	<!--- If there are sku bundles then we can display them seperately here ---> 
	<cfif local.bundleSkusSmartList.getRecordsCount()>
		<h4>Sku Bundles</h4>
		<cf_HibachiListingDisplay smartList="#local.bundleSkusSmartList#"
							   recordDetailAction="admin:entity.detailsku"
							   recordDetailQueryString="productID=#rc.product.getProductID()#"
							   recordEditAction="admin:entity.editsku"
							   recordEditQueryString="productID=#rc.product.getProductID()#">
							      
			<cf_HibachiListingColumn propertyIdentifier="skuCode" />
			<cf_HibachiListingColumn propertyIdentifier="skuDefinition" />
			<cf_HibachiListingColumn propertyIdentifier="imageFile" />
			<cf_HibachiListingColumn propertyIdentifier="listPrice" />
			<cf_HibachiListingColumn propertyIdentifier="price" />
			<cfif  rc.product.getProductType().getBaseProductType() eq "subscription">
				<cf_HibachiListingColumn propertyIdentifier="renewalPrice" />
			</cfif>
			<cf_HibachiListingColumn propertyIdentifier="salePrice" />
		</cf_HibachiListingDisplay>
		<br />
		<hr />
		<h4>Skus</h4>
	</cfif>
	
	<cfset local.skusSmartList = rc.product.getSkusSmartList() />
	<cfif local.skusSmartList.getRecordsCount() gt 0>
		<cfset local.skusSmartList.joinRelatedProperty("SlatwallSku", "options", "left", true) />
		<cfset local.skusSmartList.addKeywordProperty(propertyIdentifier="hasEventConflict", weight=1)>
		
	
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
			<cfif rc.product.getBaseProductType() eq "event">
				<cf_HibachiListingColumn propertyIdentifier="eventStartDateTime" />
				<cf_HibachiListingColumn propertyIdentifier="eventEndDateTime" />
				<cf_HibachiListingColumn propertyIdentifier="eventAttendanceCode" />
				<cf_HibachiListingColumn propertyIdentifier="eventConflictExistsFlag" />
			</cfif>
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
	</cfif>
	<cf_HibachiProcessCaller entity="#rc.product#" action="admin:entity.preprocessproduct" processContext="addEventSchedule" class="btn" icon="plus icon" modal="false" />
	<cf_HibachiProcessCaller entity="#rc.product#" action="admin:entity.preprocessproduct" processContext="addOptionGroup" class="btn" icon="plus icon" modal="true" />
	<cf_HibachiProcessCaller entity="#rc.product#" action="admin:entity.preprocessproduct" processContext="addOption" class="btn" icon="plus icon" modal="true" />
	<cf_HibachiProcessCaller entity="#rc.product#" action="admin:entity.preprocessproduct" processContext="addSubscriptionSku" class="btn" icon="plus icon" modal="true" />
	<cf_HibachiProcessCaller entity="#rc.product#" action="admin:entity.preprocessproduct" processContext="addSkuBundle" class="btn" icon="plus icon" modal="false" />
	
</cfoutput>

