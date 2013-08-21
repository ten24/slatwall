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
<cfparam name="rc.vendorOrder" type="any"/>

<cfoutput>
	<!--- Return Items --->
	<cfif listFindNoCase("votReturnOrder", rc.vendorOrder.getVendorOrderType().getSystemCode())>
		
		<cf_HibachiListingDisplay smartlist="#rc.vendorOrder.getVendorOrderItemsSmartList()#" 
		                           recordeditaction="admin:entity.editVendorOrderItem" 
								   recordEditQueryString="redirectAction=admin:entity.detailVendorOrder&vendorOrderID=#rc.vendorOrder.getVendorOrderID()#"
		                           recordeditmodal="true"
								   recorddetailaction="admin:entity.detailvendororderitem"
								   recorddetailmodal="true"
		                           recorddeleteaction="admin:entity.deleteVendorOrderItem" 
		                           recorddeletequerystring="redirectAction=admin:entity.detailVendorOrder&vendorOrderID=#rc.vendorOrder.getVendorOrderID()#">
								      
			<cf_HibachiListingColumn propertyidentifier="stock.sku.product.brand.brandName" />
			<cf_HibachiListingColumn tdclass="primary" propertyidentifier="stock.sku.product.productName"  />
			<cf_HibachiListingColumn propertyidentifier="stock.sku.skucode" />
			<cf_HibachiListingColumn propertyidentifier="stock.location.locationName" />
			<cf_HibachiListingColumn propertyidentifier="quantity" />
			<cf_HibachiListingColumn propertyidentifier="quantityReceived" />
			<cf_HibachiListingColumn propertyidentifier="quantityUnreceived" />
			<cf_HibachiListingColumn propertyidentifier="cost" />
			<cf_HibachiListingColumn propertyidentifier="extendedCost" />
			<cf_HibachiListingColumn propertyidentifier="estimatedReceivalDateTime" />
			
		</cf_HibachiListingDisplay>
		
		<cfif rc.edit and listFindNoCase("vostNew", rc.vendorOrder.getVendorOrderStatusType().getSystemCode())>
			<h5>#$.slatwall.rbKey('define.add')#</h5>
			<cf_HibachiListingDisplay smartList="#rc.vendorOrder.getAddVendorOrderItemSkuOptionsSmartList()#"
									  recordProcessAction="admin:entity.processVendorOrder"
									  recordProcessContext="addVendorOrderItem"
									  recordProcessEntity="#rc.vendorOrder#"
									  recordProcessUpdateTableID="LD#replace(rc.vendorOrder.getVendorOrderItemsSmartList().getSavedStateID(),'-','','all')#">
									    
				<cf_HibachiListingColumn propertyIdentifier="skuCode" />
				<cf_HibachiListingColumn propertyIdentifier="product.productCode" />
				<cf_HibachiListingColumn propertyIdentifier="product.brand.brandName" />
				<cf_HibachiListingColumn tdclass="primary" propertyIdentifier="product.productName" />
				<cf_HibachiListingColumn propertyIdentifier="product.productType.productTypeName" />
				<cf_HibachiListingColumn processObjectProperty="quantity" title="#$.slatwall.rbKey('define.quantity')#" fieldClass="span1" />
			</cf_HibachiListingDisplay>
		</cfif>
		
	</cfif>
	
	<!--- Purchase Items --->
	<cfif listFindNoCase("votPurchaseOrder", rc.vendorOrder.getVendorOrderType().getSystemCode())>
		<cf_HibachiListingDisplay smartlist="#rc.vendorOrder.getVendorOrderItemsSmartList()#" 
		                           recordeditaction="admin:entity.editVendorOrderItem"
								   recordEditQueryString="redirectAction=admin:entity.detailVendorOrder&vendorOrderID=#rc.vendorOrder.getVendorOrderID()#"
		                           recordeditmodal="true"
								   recorddetailaction="admin:entity.detailvendororderitem"
								   recorddetailmodal="true"
		                           recorddeleteaction="admin:entity.deleteVendorOrderItem" 
		                           recorddeletequerystring="redirectAction=admin:entity.detailVendorOrder&vendorOrderID=#rc.vendorOrder.getVendorOrderID()#">
								      
			<cf_HibachiListingColumn propertyidentifier="stock.sku.product.brand.brandName" />
			<cf_HibachiListingColumn tdclass="primary" propertyidentifier="stock.sku.product.productName" />
			<cf_HibachiListingColumn propertyidentifier="stock.sku.skucode" />
			<cf_HibachiListingColumn propertyidentifier="stock.location.locationName" />
			<cf_HibachiListingColumn propertyidentifier="quantity" />
			<cf_HibachiListingColumn propertyidentifier="quantityReceived" />
			<cf_HibachiListingColumn propertyidentifier="quantityUnreceived" />
			<cf_HibachiListingColumn propertyidentifier="cost" />
			<cf_HibachiListingColumn propertyidentifier="extendedCost" />
			<cf_HibachiListingColumn propertyidentifier="estimatedReceivalDateTime" />
			
		</cf_HibachiListingDisplay>
		
		<cfif rc.edit and listFindNoCase("vostNew", rc.vendorOrder.getVendorOrderStatusType().getSystemCode())>
			<h5>#$.slatwall.rbKey('define.add')#</h5>
			
			<cf_HibachiListingDisplay smartList="#rc.vendorOrder.getAddVendorOrderItemSkuOptionsSmartList()#"
									  recordProcessAction="admin:entity.processVendorOrder"
									  recordProcessQueryString="vendorOrderItemTypeSystemCode=voitPurchase"
									  recordProcessContext="addVendorOrderItem"
									  recordProcessEntity="#rc.vendorOrder#"
									  recordProcessUpdateTableID="LD#replace(rc.vendorOrder.getVendorOrderItemsSmartList().getSavedStateID(),'-','','all')#">
									    
				<cf_HibachiListingColumn propertyIdentifier="skuCode" />
				<cf_HibachiListingColumn propertyIdentifier="product.productCode" />
				<cf_HibachiListingColumn propertyIdentifier="product.brand.brandName" />
				<cf_HibachiListingColumn tdclass="primary" propertyIdentifier="product.productName" />
				<cf_HibachiListingColumn propertyIdentifier="product.productType.productTypeName" />
				<cf_HibachiListingColumn propertyIdentifier="calculatedQATS" />
				<cf_HibachiListingColumn processObjectProperty="deliverToLocationID" title="#$.slatwall.rbKey('process.vendorOrder_AddVendorOrderItem.deliverToLocationID')#" fieldClass="span2" />
				<cf_HibachiListingColumn processObjectProperty="quantity" title="#$.slatwall.rbKey('define.quantity')#" fieldClass="span1" />
				<cf_HibachiListingColumn processObjectProperty="cost" title="#$.slatwall.rbKey('define.cost')#" fieldClass="span1" />
				
			</cf_HibachiListingDisplay>
		</cfif>
	</cfif>
</cfoutput>
