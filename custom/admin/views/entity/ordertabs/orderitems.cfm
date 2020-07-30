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
<cfimport prefix="swa" taglib="../../../../../tags" />
<cfimport prefix="hb" taglib="../../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.order" type="any" />
<cfparam name="rc.edit" type="boolean" />

<cfoutput>
	<!--- Order item collection list --->
	<cfset orderItemCollectionList = getHibachiScope().getService('orderService').getOrderItemCollectionList()>
	<cfset orderItemCollectionList.addFilter("order.orderID", "#rc.order.getOrderID()#","=")>
	<cfset orderItemCollectionList.setDisplayProperties("sku.product.calculatedTitle,sku.skuCode", {
		isVisible=true,
		isSearchable=true,
		isDeletable=true
	})/>
	<cfset orderItemCollectionList.addDisplayProperty('sku.product.productType.productTypeName','Product Type',{'isVisible': true, 'isEditable': false, 'isSearchable': true, 'isExportable': true})>
	
	<!--- Adds a type name fields if this is an exchange order --->
	<cfif !isNull(rc.order.getOrderType()) && (rc.order.getOrderType().getSystemCode() eq "otExchangeOrder" || rc.order.getOrderType().getSystemCode() eq "otReplacementOrder")>
		<cfset orderItemCollectionList.addDisplayProperty('orderItemType.typeName','Item Type',{'isVisible': true, 'isEditable': false, 'isSearchable': true, 'isExportable': true})>
	</cfif>
	
	<cfset orderItemCollectionList.addDisplayProperty(displayProperty='price',columnConfig={ isVisible :true, isSearchable: true, isDeletable: true}) />
	<cfset orderItemCollectionList.addDisplayProperty(displayProperty='quantity',columnConfig={ isVisible :true, isSearchable: true, isDeletable: true}) />
	<cfset orderItemCollectionList.addDisplayProperty(displayProperty='discountAmount',columnConfig={ isVisible :true, isSearchable: true, isDeletable: true}) />
	<cfset orderItemCollectionList.addDisplayProperty(displayProperty='extendedPrice',columnConfig={ isVisible :true, isSearchable: true, isDeletable: true}) />
	<cfset orderItemCollectionList.addDisplayProperty(displayProperty='extendedPersonalVolume',columnConfig={ isVisible :true, isSearchable: true, isDeletable: true}) />
	<cfset orderItemCollectionList.addDisplayProperty(displayProperty='extendedCommissionableVolume',columnConfig={ isVisible :true, isSearchable: true, isDeletable: true}) />
	<cfif rc.order.getVATTotal() NEQ 0>
		<cfset orderItemCollectionList.addDisplayProperty(displayProperty='VATAmount',columnConfig={ isVisible :true, isSearchable: true, isDeletable: true}) />
	<cfelse>
		<cfset orderItemCollectionList.addDisplayProperty(displayProperty='taxAmount',columnConfig={ isVisible :true, isSearchable: true, isDeletable: true}) />
	</cfif>
	<cfset orderItemCollectionList.addDisplayProperty(displayProperty='extendedPriceAfterDiscount',columnConfig={ isVisible :true, isSearchable: true, isDeletable: true}) />
	
	
	<cfif NOT isNull(rc.order.getOrderType()) && rc.order.getOrderType().getSystemCode() NEQ "otSalesOrder" >
		<cfset orderItemCollectionList.addDisplayProperty('stockLoss','Stock Loss',{'isVisible':true}) />
		<cfset orderItemCollectionList.addDisplayProperty('stockLossReason','Stock Loss Reason',{'isVisible':true}) />
	</cfif>
	
	<cfset orderItemCollectionList.addDisplayProperty(displayProperty='orderItemID', columnConfig={
		isVisible=false,
		isSearchable=false,
		isDeletable=false
	})/>
	
	<!--- The order item listing has a refreshOrderItemListing event that it will listen for to refresh
	      this listing, notify that event  using the observer service --->
	<hb:HibachiListingDisplay 
		collectionList="#orderItemCollectionList#"
		usingPersonalCollection="true"
		recordEditAction="admin:entity.edit#lcase(orderItemCollectionList.getCollectionObject())#"
		recordDeleteAction="admin:entity.adminDeleteOrderItem&sRedirectAction=admin:entity.detailOrder&orderID=#rc.order.getOrderID()#"
		recordDeleteActionProperty="orderItemID"
		recordDetailAction="admin:entity.detail#lcase(orderItemCollectionList.getCollectionObject())#"
		refreshEvent="refreshOrderItemListing"
		currencyCode="#rc.order.getCurrencyCode()#">
	</hb:HibachiListingDisplay>
	
	<!--- If in edit and order is of correct status then we can add sale order items --->
	<cfif rc.edit and listFindNoCase("ostNotPlaced,ostNew,ostProcessing,ostOnHold", rc.order.getOrderStatusType().getSystemCode())>
	    <cfset local.activeTab = "soiaddsku" />
	    <cfif listFindNoCase('otReturnOrder,otExchangeOrder,otRefundOrder', rc.order.getTypeCode())>
	        <cfset local.activeTab = "soiaddreturnsku" />
	    </cfif>
		<hb:HibachiTabGroup tabLocation="top" activeTab="#local.activeTab#">
		    <!--- Tabs for Adding Sale Order Items Sku and Stock --->
    		<hb:HibachiTab tabid="soiaddsku" lazyLoad="true" view="admin:entity/ordertabs/addsku" text="#$.slatwall.rbKey('define.add')# #$.slatwall.rbKey('entity.sku')#" />
    		<hb:HibachiTab tabid="soiaddpromotionsku" lazyLoad="true" view="admin:entity/ordertabs/addpromotionsku" text="#$.slatwall.rbKey('define.add')# #$.slatwall.rbKey('entity.promotionsku')#" />
    		<hb:HibachiTab tabid="soiaddstock" lazyLoad="true" view="admin:entity/ordertabs/addstock" text="#$.slatwall.rbKey('define.add')# #$.slatwall.rbKey('entity.stock')#" />
    		<!--- Tabs for Adding Return Order Items Sku and Stock --->
    		<!---<hb:HibachiTab tabid="soiaddreturnsku" lazyLoad="true" view="admin:entity/ordertabs/addreturnsku" text="#$.slatwall.rbKey('define.add')# Return #$.slatwall.rbKey('entity.sku')#" />
    		<hb:HibachiTab tabid="soiaddreturnstock" lazyLoad="true" view="admin:entity/ordertabs/addreturnstock" text="#$.slatwall.rbKey('define.add')# Return #$.slatwall.rbKey('entity.stock')#" />--->
		</hb:HibachiTabGroup>
    </cfif>
</cfoutput>
