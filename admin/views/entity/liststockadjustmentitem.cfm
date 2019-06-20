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



<cfparam name="rc.stockadjustmentItemSmartList" type="any" />

<cfset rc.stockadjustmentItemSmartList.addOrder("stockadjustment.createdDateTime|DESC") />
<!---
<cfif not len(rc.orderItemSmartList.getFilters("stockadjustment.stockadjustmentType.typeName")) >
	<cfset local.defaultStatusFilter = $.slatwall.getService('typeService').getTypeBySystemCode("ostNew").getTypeName() />
	<cfset local.defaultStatusFilter = listAppend(local.defaultStatusFilter, $.slatwall.getService('typeService').getTypeBySystemCode("ostNew").getTypeName()) />
	<cfset local.defaultStatusFilter = listAppend(local.defaultStatusFilter, $.slatwall.getService('typeService').getTypeBySystemCode("ostProcessing").getTypeName()) />
	<cfset local.defaultStatusFilter = listAppend(local.defaultStatusFilter, $.slatwall.getService('typeService').getTypeBySystemCode("ostOnHold").getTypeName()) />
	<cfset local.defaultStatusFilter = listAppend(local.defaultStatusFilter, $.slatwall.getService('typeService').getTypeBySystemCode("ostClosed").getTypeName()) />
	<cfset local.defaultStatusFilter = listAppend(local.defaultStatusFilter, $.slatwall.getService('typeService').getTypeBySystemCode("ostCanceled").getTypeName()) />
	<cfset rc.orderItemSmartList.addFilter('order.orderStatusType.typeName', local.defaultStatusFilter) />
</cfif>--->

<cfoutput>
	<hb:HibachiEntityActionBar type="listing" object="#rc.stockadjustmentItemSmartList#" showCreate="false" />

	<!--- <hb:HibachiListingDisplay smartList="#rc.stockadjustmentItemSmartList#"
							   recorddetailaction="admin:entity.detailstockadjustment"
							   recordeditaction="admin:entity.editstockadjustment"
							   recorddetailactionproperty="stockAdjustment.stockAdjustmentID"
							   recordeditactionproperty="stockAdjustment.stockAdjustmentID">
		<hb:HibachiListingColumn tdclass="primary" propertyIdentifier="sku.skucode" />
		<hb:HibachiListingColumn propertyIdentifier="sku.product.brand.brandName" />
		<hb:HibachiListingColumn propertyIdentifier="sku.product.productName" />
		<hb:HibachiListingColumn propertyIdentifier="sku.skuDefinition" sort="false" />
		<hb:HibachiListingColumn propertyIdentifier="stockAdjustment.stockAdjustmentType.typeName" filter="true" title="#$.slatwall.rbKey('entity.StockAdjustment.stockAdjustmentType')#" />
		<hb:HibachiListingColumn propertyIdentifier="stockAdjustment.stockAdjustmentStatusType.typeName" title="#$.slatwall.rbKey('define.status')#" filter="true" />
		<hb:HibachiListingColumn propertyIdentifier="stockAdjustment.createdDateTime" />
		<hb:HibachiListingColumn propertyIdentifier="fromstock.location.locationName" title="#$.slatwall.rbKey('admin.warehouse.detailstockadjustment.fromlocationname')#" />
		<hb:HibachiListingColumn propertyIdentifier="tostock.location.locationName" title="#$.slatwall.rbKey('admin.warehouse.detailstockadjustment.tolocationname')#" />
	<hb:HibachiListingColumn propertyIdentifier="quantity" />
	</hb:HibachiListingDisplay> --->

	<sw-listing-display data-using-personal-collection="true"
	    data-collection="'StockAdjustmentItem'"
	    data-edit="false"
	    data-has-search="true"
	    record-edit-action="admin:entity.editstockadjustmentitem"
	    record-detail-action="admin:entity.detailstockadjustmentitem"
	    record-detail-action-property="stockAdjustmentitem.stockAdjustmentItemID"
	    record-edit-action-property="stockAdjustmentitem.stockAdjustmentItemID"
	    data-is-angular-route="false"
	    data-angular-links="false"
	    data-has-action-bar="false"
	    
	>
		<sw-listing-column data-property-identifier="stockAdjustmentItemID" data-is-visible="false" data-is-deletable="false" ></sw-listing-column>
    	<sw-listing-column data-property-identifier="sku.skuCode" tdclass="primary" ></sw-listing-column>
    	<sw-listing-column data-property-identifier="sku.product.brand.brandName" ></sw-listing-column>
    	<sw-listing-column data-property-identifier="sku.product.productName" ></sw-listing-column>
    	<sw-listing-column data-property-identifier="sku.calculatedSkuDefinition" sort="false" ></sw-listing-column>
    	<sw-listing-column data-property-identifier="stockAdjustment.stockAdjustmentType.typeName" filter="true" title="#$.slatwall.rbKey('entity.StockAdjustment.stockAdjustmentType')#" ></sw-listing-column>
    	<sw-listing-column data-property-identifier="stockAdjustment.stockAdjustmentStatusType.typeName" title="#$.slatwall.rbKey('define.status')#" filter="true" ></sw-listing-column>
    	<sw-listing-column data-property-identifier="stockAdjustment.createdDateTime" ></sw-listing-column>
    	<sw-listing-column data-property-identifier="fromStock.location.locationName" title="#$.slatwall.rbKey('admin.warehouse.detailstockadjustment.fromlocationname')#" ></sw-listing-column>
    	<sw-listing-column data-property-identifier="toStock.location.locationName" title="#$.slatwall.rbKey('admin.warehouse.detailstockadjustment.tolocationname')#" ></sw-listing-column>
    	<sw-listing-column data-property-identifier="quantity" ></sw-listing-column>
	</sw-listing-display>

</cfoutput>

