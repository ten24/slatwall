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
<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfoutput>
	<cfset local.bundleSkusSmartList = rc.product.getBundleSkusSmartList() />

	<cfset local.defaultSkuID = "" />
	<cfif not isNull(rc.product.getDefaultSku())>
		<cfset local.defaultSkuID = rc.product.getDefaultSku().getSkuID() />
	</cfif>

	<!--- If there are sku bundles then we can display them seperately here
	<cfif local.bundleSkusSmartList.getRecordsCount()>
		<hb:HibachiListingDisplay smartList="#local.bundleSkusSmartList#" title="#$.slatwall.rbKey('entity.SkuBundle_plural')#"
							   recordDetailAction="admin:entity.detailsku"
							   recordDetailQueryString="productID=#rc.product.getProductID()#"
							   recordEditAction="admin:entity.editsku"
							   recordEditQueryString="productID=#rc.product.getProductID()#">
			<cfif rc.product.getBaseProductType() eq "event">
				<hb:HibachiListingColumn propertyIdentifier="skuName" />
			</cfif>
			<hb:HibachiListingColumn propertyIdentifier="skuCode" />
			<hb:HibachiListingColumn propertyIdentifier="calculatedSkuDefinition" />
			<hb:HibachiListingColumn propertyIdentifier="imageFile" />
			<hb:HibachiListingColumn propertyIdentifier="listPrice" />
			<hb:HibachiListingColumn propertyIdentifier="price" />
			<cfif  rc.product.getProductType().getBaseProductType() eq "subscription">
				<hb:HibachiListingColumn propertyIdentifier="renewalPrice" />
			</cfif>
			<hb:HibachiListingColumn propertyIdentifier="salePrice" />
		</hb:HibachiListingDisplay>
		<br />
		<hr />
		<h4>Skus</h4>
	</cfif>

	<cfset local.skusSmartList = rc.product.getSkusSmartList() />
	<cfset local.skusSmartList.addWhereCondition("bundleFlag != true")>
	<cfif local.skusSmartList.getRecordsCount() gt 0>
		<hb:HibachiListingDisplay smartList="#local.skusSmartList#"
								   edit="#rc.edit#"
								   recordDetailAction="admin:entity.detailsku"
								   recordDetailQueryString="productID=#rc.product.getProductID()#"
								   recordEditAction="admin:entity.editsku"
								   recordEditQueryString="productID=#rc.product.getProductID()#"
								   selectFieldName="defaultSku.skuID"
								   selectValue="#local.defaultSkuID#"
								   selectTitle="#$.slatwall.rbKey('define.default')#">

			<cfif rc.product.getBaseProductType() eq "event">
				<hb:HibachiListingColumn propertyIdentifier="skuName" />
			</cfif>
			<hb:HibachiListingColumn tdclass="primary" propertyIdentifier="skuCode" />
			<hb:HibachiListingColumn propertyIdentifier="calculatedSkuDefinition" title="#getHibachiScope().rbKey('entity.sku.skuDefinition')#" />
			<cfif rc.product.getBaseProductType() eq "event">
				<hb:HibachiListingColumn propertyIdentifier="eventStartDateTime" />
				<hb:HibachiListingColumn propertyIdentifier="eventEndDateTime" />
				<hb:HibachiListingColumn propertyIdentifier="eventAttendanceCode" />
				<hb:HibachiListingColumn propertyIdentifier="eventConflictExistsFlag" />
				<hb:HibachiListingColumn propertyIdentifier="availableSeatCount" />
			</cfif>
			<hb:HibachiListingColumn propertyIdentifier="imageFile" />
			<cfif not isNull(rc.product.getDefaultSku()) and (isNull(rc.product.getDefaultSku().getUserDefinedPriceFlag()) || !rc.product.getDefaultSku().getUserDefinedPriceFlag())>
				<hb:HibachiListingColumn propertyIdentifier="listPrice" />
				<hb:HibachiListingColumn propertyIdentifier="price" />
				<cfif  rc.product.getProductType().getBaseProductType() eq "subscription">
					<hb:HibachiListingColumn propertyIdentifier="renewalPrice" />
				</cfif>
				<hb:HibachiListingColumn propertyIdentifier="salePrice" />
			</cfif>
		</hb:HibachiListingDisplay>
	</cfif>
	--->

	<sw-pricing-manager data-product-id="#rc.product.getProductID()#" 
						data-track-inventory="#getHibachiScope().getService('settingService').getSettingValue('skuTrackInventoryFlag', rc.product)#">

	</sw-pricing-manager>

	<hb:HibachiProcessCaller entity="#rc.product#" action="admin:entity.preprocessproduct" processContext="addEventSchedule" class="btn btn-primary" modal="false" />
	<hb:HibachiProcessCaller entity="#rc.product#" action="admin:entity.preprocessproduct" processContext="addSku" class="btn btn-primary" modal="true" />
	<hb:HibachiProcessCaller entity="#rc.product#" action="admin:entity.preprocessproduct" processContext="addOptionGroup" class="btn btn-primary" modal="true" />
	<hb:HibachiProcessCaller entity="#rc.product#" action="admin:entity.preprocessproduct" processContext="addOption" class="btn btn-primary" modal="true" />
	<hb:HibachiProcessCaller entity="#rc.product#" action="admin:entity.preprocessproduct" processContext="addSubscriptionSku" class="btn btn-primary" modal="true" />
	<hb:HibachiProcessCaller entity="#rc.product#" action="admin:entity.preprocessproduct" processContext="addSkuBundle" class="btn btn-primary" modal="false" />

</cfoutput>

