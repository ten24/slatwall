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
<cfparam name="rc.order" type="any" />
<cfparam name="rc.edit" type="boolean" />

<cfoutput>
	<cf_HibachiListingDisplay smartList="#rc.order.getSaleItemSmartList()#"
							  recordDetailAction="admin:entity.detailorderitem"
							  recordEditAction="admin:entity.editorderitem">
							    
		<cf_HibachiListingColumn propertyIdentifier="sku.skuCode" />
		<cf_HibachiListingColumn tdclass="primary" propertyIdentifier="sku.product.calculatedTitle" />
		<cf_HibachiListingColumn propertyIdentifier="sku.optionsDisplay" sort="false" />
		<cf_HibachiListingColumn propertyIdentifier="orderItemStatusType.type" filter="true" />
		<cf_HibachiListingColumn propertyIdentifier="quantity" />
		<cf_HibachiListingColumn propertyIdentifier="price" />
		<cf_HibachiListingColumn propertyIdentifier="discountAmount" />
		<cf_HibachiListingColumn propertyIdentifier="extendedPriceAfterDiscount" />
		<cf_HibachiListingColumn propertyIdentifier="quantityDelivered" />
	</cf_HibachiListingDisplay>
	
	<!--- If in edit and order is of correct status then we can add sale order items --->
		
	<cfif rc.edit and listFindNoCase("ostNotPlaced,ostNew,ostProcessing,ostOnHold", rc.order.getOrderStatusType().getSystemCode())>
		<!---
		<ul>
			<li class="active"><a href="##tabsaddsku" data-toggle="tab">#$.slatwall.rbKey('define.add')# #$.slatwall.rbKey('entity.sku')#</a></li>
			<li><a href="##tabsaddstock" data-toggle="tab">#$.slatwall.rbKey('define.add')# #$.slatwall.rbKey('entity.stock')#</a></li> 
		</ul>
		<div class="tab-content">
			<div class="tab-pane active" id="tabsaddsku">
				<div class="row-fluid">
					--->
					<div class="well well-small">
						<input type="text" name="search" class="general-listing-search" placeholder="Search Sku Listing" tableid="LD#replace(rc.order.getAddOrderItemSkuOptionsSmartList().getSavedStateID(),'-','','all')#">
					</div>
					<cf_HibachiListingDisplay smartList="#rc.order.getAddOrderItemSkuOptionsSmartList()#"
											  recordProcessAction="admin:entity.processOrder"
											  recordProcessQueryString="orderItemTypeSystemCode=oitSale"
											  recordProcessContext="addOrderItem"
											  recordProcessEntity="#rc.order#"
											  recordProcessUpdateTableID="LD#replace(rc.order.getSaleItemSmartList().getSavedStateID(),'-','','all')#">
											    
						<cf_HibachiListingColumn propertyIdentifier="skuCode" />
						<cf_HibachiListingColumn propertyIdentifier="product.productCode" />
						<cf_HibachiListingColumn propertyIdentifier="product.brand.brandName" />
						<cf_HibachiListingColumn tdclass="primary" propertyIdentifier="product.productName" />
						<cf_HibachiListingColumn propertyIdentifier="product.productType.productTypeName" />
						<cf_HibachiListingColumn propertyIdentifier="calculatedQATS" />
						<cf_HibachiListingColumn processObjectProperty="orderFulfillmentID" title="#$.slatwall.rbKey('entity.orderFulfillment')#" fieldClass="span2" />
						<cf_HibachiListingColumn processObjectProperty="price" fieldClass="span1" />
						<cf_HibachiListingColumn processObjectProperty="quantity" title="#$.slatwall.rbKey('define.quantity')#" fieldClass="span1" />
					</cf_HibachiListingDisplay>
					<!---
				</div>
			</div>
			<div class="tab-pane" id="tabsaddstock">
				<div class="row-fluid">
					<cf_HibachiListingDisplay smartList="#rc.order.getAddOrderItemStockOptionsSmartList()#"
											  recordProcessAction="admin:entity.processOrder"
											  recordProcessQueryString="orderItemTypeSystemCode=oitSale"
											  recordProcessContext="addOrderItem"
											  recordProcessEntity="#rc.order#"
											  recordProcessUpdateTableID="LD#replace(rc.order.getSaleItemSmartList().getSavedStateID(),'-','','all')#">
						
						<cf_HibachiListingColumn propertyIdentifier="location.locationName" />					    
						<cf_HibachiListingColumn propertyIdentifier="sku.skuCode" />
						<cf_HibachiListingColumn propertyIdentifier="sku.product.productCode" />
						<cf_HibachiListingColumn propertyIdentifier="sku.product.brand.brandName" />
						<cf_HibachiListingColumn tdclass="primary" propertyIdentifier="sku.product.productName" />
						<cf_HibachiListingColumn propertyIdentifier="sku.product.productType.productTypeName" />
						<cf_HibachiListingColumn propertyIdentifier="sku.calculatedQATS" />
						<cf_HibachiListingColumn processObjectProperty="orderFulfillmentID" title="#$.slatwall.rbKey('entity.orderFulfillment')#" fieldClass="span2" />
						<cf_HibachiListingColumn processObjectProperty="price" fieldClass="span1" />
						<cf_HibachiListingColumn processObjectProperty="quantity" title="#$.slatwall.rbKey('define.quantity')#" fieldClass="span1" />
					</cf_HibachiListingDisplay>
				</div>
			</div>
		</div>
		--->
	</cfif>
	
</cfoutput>
