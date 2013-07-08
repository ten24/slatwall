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
<cfparam name="rc.stockAdjustment" type="any" />

<cf_HibachiListingDisplay smartList="#rc.stockAdjustment.getstockAdjustmentItemsSmartList()#"
						  recordDeleteAction="admin:entity.deleteStockAdjustmentItem"
						  recordDeleteQueryString="redirectAction=admin:entity.editstockadjustment&stockAdjustmentID=#rc.stockadjustment.getStockAdjustmentID()#"
						  recordEditAction="admin:entity.editStockAdjustmentItem"
						  recordEditQueryString="redirectAction=admin:entity.editstockadjustment"
						  recordEditModal="true">
						   	   
	<cfif listFindNoCase("satLocationTransfer,satManualOut,satPhysicalCount", rc.stockAdjustment.getStockAdjustmentType().getSystemCode())>
		<cf_HibachiListingColumn tdclass="primary" propertyIdentifier="fromstock.sku.skucode" />
		<cf_HibachiListingColumn propertyIdentifier="fromstock.sku.product.brand.brandName" />
		<cf_HibachiListingColumn propertyIdentifier="fromstock.sku.product.productName" />
		<cf_HibachiListingColumn propertyIdentifier="fromstock.sku.skuDefinition" sort="false" />
		
		<cf_HibachiListingColumn propertyIdentifier="fromstock.location.locationName" title="#$.slatwall.rbKey('admin.warehouse.detailstockadjustment.fromlocationname')#" />
		<cfif rc.stockAdjustment.getStockAdjustmentType().getSystemCode() eq "satLocationTransfer">
			<cf_HibachiListingColumn propertyIdentifier="tostock.location.locationName" title="#$.slatwall.rbKey('admin.warehouse.detailstockadjustment.tolocationname')#" />
		</cfif>
	<cfelse>
		<cf_HibachiListingColumn tdclass="primary" propertyIdentifier="tostock.sku.skucode" />
		<cf_HibachiListingColumn propertyIdentifier="tostock.sku.product.brand.brandName" />
		<cf_HibachiListingColumn propertyIdentifier="tostock.sku.product.productName" />
		<cf_HibachiListingColumn propertyIdentifier="tostock.sku.skuDefinition" sort="false" />
		<cf_HibachiListingColumn propertyIdentifier="tostock.location.locationName" title="#$.slatwall.rbKey('admin.warehouse.detailstockadjustment.tolocationname')#" />
	</cfif>
	
	<cf_HibachiListingColumn propertyIdentifier="quantity" />
</cf_HibachiListingDisplay>

<cfif rc.edit>
	<cf_HibachiListingDisplay smartList="#rc.stockAdjustment.getAddStockAdjustmentItemSkuOptionsSmartList()#"
							  recordProcessAction="admin:entity.processStockAdjustment"
							  recordProcessContext="addStockAdjustmentItem"
							  recordProcessEntity="#rc.stockAdjustment#"
							  recordProcessUpdateTableID="LD#replace(rc.stockAdjustment.getstockAdjustmentItemsSmartList().getSavedStateID(),'-','','all')#">
							    
		<cf_HibachiListingColumn propertyIdentifier="skuCode" />
		<cf_HibachiListingColumn propertyIdentifier="product.productCode" />
		<cf_HibachiListingColumn propertyIdentifier="product.brand.brandName" />
		<cf_HibachiListingColumn tdclass="primary" propertyIdentifier="product.productName" />
		<cf_HibachiListingColumn propertyIdentifier="product.productType.productTypeName" />
		<cf_HibachiListingColumn processObjectProperty="quantity" title="#$.slatwall.rbKey('define.quantity')#" fieldClass="span1" />
	</cf_HibachiListingDisplay>
</cfif>