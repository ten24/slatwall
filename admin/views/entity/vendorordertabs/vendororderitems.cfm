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

<cfparam name="rc.vendorOrder" type="any"/>

<cfoutput>
	<!--- Return Items --->
	<cfif listFindNoCase("votReturnOrder", rc.vendorOrder.getVendorOrderType().getSystemCode())>
		<cfset local.vendorReturnOrderSmartList = rc.vendorOrder.getVendorOrderItemsSmartList() />
		<cfset local.vendorReturnOrderSmartList.addKeywordProperty(propertyIdentifier="stock.sku.product.brand.brandName", weight=1 ) />
		<cfset local.vendorReturnOrderSmartList.addKeywordProperty(propertyIdentifier="stock.sku.product.productName", weight=1 ) />
		<cfset local.vendorReturnOrderSmartList.addKeywordProperty(propertyIdentifier="stock.sku.skucode", weight=1 ) />
		<cfset local.vendorReturnOrderSmartList.addKeywordProperty(propertyIdentifier="stock.sku.calculatedSkuDefinition", weight=1 ) />
		<cfset local.vendorReturnOrderSmartList.addKeywordProperty(propertyIdentifier="stock.location.locationName", weight=1 ) />
		
		<hb:HibachiListingDisplay smartlist="#local.vendorReturnOrderSmartList#" 
		                           recordeditaction="admin:entity.editVendorOrderItem" 
								   recordEditQueryString="redirectAction=admin:entity.detailVendorOrder&vendorOrderID=#rc.vendorOrder.getVendorOrderID()#"
		                           recordeditmodal="true"
								   recorddetailaction="admin:entity.detailvendororderitem"
								   recorddetailmodal="true"
		                           recorddeleteaction="admin:entity.deleteVendorOrderItem" 
		                           recorddeletequerystring="redirectAction=admin:entity.detailVendorOrder&vendorOrderID=#rc.vendorOrder.getVendorOrderID()#">
								      
			<hb:HibachiListingColumn propertyidentifier="stock.sku.product.brand.brandName" />
			<hb:HibachiListingColumn tdclass="primary" propertyidentifier="stock.sku.product.productName"  />
			<hb:HibachiListingColumn propertyidentifier="stock.sku.skucode" />
			<hb:HibachiListingColumn propertyidentifier="stock.sku.calculatedSkuDefinition" />
			<hb:HibachiListingColumn propertyidentifier="stock.location.locationName" />
			<hb:HibachiListingColumn propertyidentifier="quantity" />
			<hb:HibachiListingColumn propertyIdentifier="stock.sku.inventoryMeasurementUnit.unitCode" sort="false" search="false" />
			<hb:HibachiListingColumn propertyidentifier="quantityDelivered" />
			<hb:HibachiListingColumn propertyidentifier="quantityUnDelivered" />
			<hb:HibachiListingColumn propertyidentifier="cost" />
			<hb:HibachiListingColumn propertyidentifier="extendedCost" />
			<hb:HibachiListingColumn propertyidentifier="extendedWeight" />
			
			
			
			<!---<hb:HibachiListingColumn propertyidentifier="estimatedReceivalDateTime" />--->
			
		</hb:HibachiListingDisplay>
		
		<cfif rc.edit and listFindNoCase("vostNew", rc.vendorOrder.getVendorOrderStatusType().getSystemCode())>
			<h5>#$.slatwall.rbKey('define.add')#</h5>
			<cfset local.vendorReturnOrderSkuOptionsSmartList = rc.vendorOrder.getAddVendorOrderItemSkuOptionsSmartList() />
			<cfset local.vendorReturnOrderSkuOptionsSmartList.addKeywordProperty(propertyIdentifier="product.productCode", weight=1 ) />
			<cfset local.vendorReturnOrderSkuOptionsSmartList.addKeywordProperty(propertyIdentifier="product.brand.brandName", weight=1 ) />
			<cfset local.vendorReturnOrderSkuOptionsSmartList.addKeywordProperty(propertyIdentifier="product.productName", weight=1 ) />
			<cfset local.vendorReturnOrderSkuOptionsSmartList.addKeywordProperty(propertyIdentifier="product.productType.productTypeName", weight=1 ) />
			
			<hb:HibachiListingDisplay smartList="#local.vendorReturnOrderSkuOptionsSmartList#"
									  recordProcessAction="admin:entity.processVendorOrder"
									  recordProcessContext="addVendorOrderItem"
									  recordProcessEntity="#rc.vendorOrder#"
									  recordProcessUpdateTableID="LD#replace(rc.vendorOrder.getVendorOrderItemsSmartList().getSavedStateID(),'-','','all')#">
									    
				<hb:HibachiListingColumn propertyIdentifier="skuCode" />
				<hb:HibachiListingColumn propertyIdentifier="product.productCode" />
				<hb:HibachiListingColumn propertyIdentifier="product.brand.brandName" />
				<hb:HibachiListingColumn tdclass="primary" propertyIdentifier="product.productName" />
				<hb:HibachiListingColumn propertyIdentifier="calculatedSkuDefinition" />
				<hb:HibachiListingColumn propertyIdentifier="product.productType.productTypeName" />
				<hb:HibachiListingColumn processObjectProperty="deliverFromLocationID" title="#$.slatwall.rbKey('process.vendorOrder_AddVendorOrderItem.deliverFromLocationID')#" fieldClass="span2" value="#rc.vendorOrder.getBillToLocation().getLocationID()#" />
				<hb:HibachiListingColumn processObjectProperty="quantity" title="#$.slatwall.rbKey('define.quantity')#" fieldClass="span1" />
				<hb:HibachiListingColumn propertyIdentifier="inventoryMeasurementUnit.unitCode" sort="false" search="false" />
			</hb:HibachiListingDisplay>
		</cfif>
		
	</cfif>
	
	<!--- Purchase Items --->
	<cfif listFindNoCase("votPurchaseOrder", rc.vendorOrder.getVendorOrderType().getSystemCode())>
		<cfset local.vendorPruchaseOrderSmartList = rc.vendorOrder.getVendorOrderItemsSmartList() />
		<cfset local.vendorPruchaseOrderSmartList.addKeywordProperty(propertyIdentifier="stock.sku.product.brand.brandName", weight=1 ) />
		<cfset local.vendorPruchaseOrderSmartList.addKeywordProperty(propertyIdentifier="stock.sku.product.productName", weight=1 ) />
		<cfset local.vendorPruchaseOrderSmartList.addKeywordProperty(propertyIdentifier="stock.sku.skucode", weight=1 ) />
		<cfset local.vendorPruchaseOrderSmartList.addKeywordProperty(propertyIdentifier="stock.sku.calculatedSkuDefinition", weight=1 ) />
		<cfset local.vendorPruchaseOrderSmartList.addKeywordProperty(propertyIdentifier="stock.location.locationName", weight=1 ) />
		<cfset local.vendorPruchaseOrderSmartList.addKeywordProperty(propertyIdentifier="stock.sku.price", weight=1 ) />
		
		<hb:HibachiListingDisplay smartlist="#local.vendorPruchaseOrderSmartList#" 
		                           recordeditaction="admin:entity.editVendorOrderItem"
								   recordEditQueryString="redirectAction=admin:entity.detailVendorOrder&vendorOrderID=#rc.vendorOrder.getVendorOrderID()#"
		                           recordeditmodal="true"
								   recorddetailaction="admin:entity.detailvendororderitem"
								   recorddetailmodal="true"
		                           recorddeleteaction="admin:entity.deleteVendorOrderItem" 
		                           recorddeletequerystring="redirectAction=admin:entity.detailVendorOrder&vendorOrderID=#rc.vendorOrder.getVendorOrderID()#">
								      
			<hb:HibachiListingColumn propertyidentifier="stock.sku.product.brand.brandName" />
			<hb:HibachiListingColumn tdclass="primary" propertyidentifier="stock.sku.product.productName" />
			<hb:HibachiListingColumn propertyidentifier="stock.sku.skucode" />
			<hb:HibachiListingColumn propertyidentifier="stock.sku.calculatedSkuDefinition" />
			<hb:HibachiListingColumn propertyidentifier="stock.location.locationName" />
			<hb:HibachiListingColumn propertyidentifier="quantity" />
			<hb:HibachiListingColumn propertyIdentifier="stock.sku.inventoryMeasurementUnit.unitCode" sort="false" search="false" />
			<hb:HibachiListingColumn propertyidentifier="quantityReceived" />
			<hb:HibachiListingColumn propertyidentifier="quantityUnreceived" />
			<hb:HibachiListingColumn propertyidentifier="sku.price" />
			<hb:HibachiListingColumn propertyidentifier="cost" />
			<hb:HibachiListingColumn propertyidentifier="price" />
			<hb:HibachiListingColumn propertyidentifier="extendedCost" />
			<hb:HibachiListingColumn propertyidentifier="extendedWeight" />

			<hb:HibachiListingColumn propertyidentifier="grossProfitMargin" />
			<hb:HibachiListingColumn propertyidentifier="estimatedReceivalDateTime" />
			<hb:HibachiListingColumn propertyidentifier="vendorAlternateSkuCode.alternateSkuCode" />
			<hb:HibachiListingColumn propertyidentifier="currencyCode" />
		</hb:HibachiListingDisplay>
		
		<cfif rc.edit and listFindNoCase("vostNew", rc.vendorOrder.getVendorOrderStatusType().getSystemCode())>
			<h5>#$.slatwall.rbKey('define.add')#</h5>
			
			<sw-tab-group id="#request.slatwallScope.createHibachiUUID()#">
				<sw-tab-content id="#request.slatwallScope.createHibachiUUID()#" name="#$.slatwall.rbKey('admin.vendororder.addItems.assigned')#">
					<cfset local.vendorOrderSkuOptionsSmartList = rc.vendorOrder.getAddVendorOrderItemSkuOptionsSmartList() />
					<cfset local.vendorOrderSkuOptionsSmartList.addKeywordProperty(propertyIdentifier="product.productCode", weight=1 ) />
					<cfset local.vendorOrderSkuOptionsSmartList.addKeywordProperty(propertyIdentifier="product.brand.brandName", weight=1 ) />
					<cfset local.vendorOrderSkuOptionsSmartList.addKeywordProperty(propertyIdentifier="product.productName", weight=1 ) />
					<cfset local.vendorOrderSkuOptionsSmartList.addKeywordProperty(propertyIdentifier="product.productType.productTypeName", weight=1 ) />
					
					<hb:HibachiListingDisplay smartList="#local.vendorOrderSkuOptionsSmartList#"
											recordProcessAction="admin:entity.processVendorOrder"
											recordProcessQueryString="vendorOrderItemTypeSystemCode=voitPurchase"
											recordProcessContext="addVendorOrderItem"
											recordProcessEntity="#rc.vendorOrder#"
											recordProcessUpdateTableID="LD#replace(rc.vendorOrder.getVendorOrderItemsSmartList().getSavedStateID(),'-','','all')#">
												
						<hb:HibachiListingColumn propertyIdentifier="skuCode" />
						<hb:HibachiListingColumn propertyIdentifier="skuName" />
						<hb:HibachiListingColumn processObjectProperty="price" title="#$.slatwall.rbKey('define.price')#" />
						<hb:HibachiListingColumn propertyIdentifier="product.productCode" />
						<hb:HibachiListingColumn propertyIdentifier="product.brand.brandName" />
						<hb:HibachiListingColumn tdclass="primary" propertyIdentifier="product.productName" />
						<hb:HibachiListingColumn propertyIdentifier="calculatedSkuDefinition" />
						<hb:HibachiListingColumn propertyIdentifier="product.productType.productTypeName" />
						<hb:HibachiListingColumn propertyIdentifier="calculatedQATS" />
						
						<hb:HibachiListingColumn processObjectProperty="deliverToLocationID" title="#$.slatwall.rbKey('process.vendorOrder_AddVendorOrderItem.deliverToLocationID')#" fieldClass="span2" />
						<hb:HibachiListingColumn processObjectProperty="quantity" title="#$.slatwall.rbKey('define.quantity')#" fieldClass="span1" />
						<hb:HibachiListingColumn propertyIdentifier="inventoryMeasurementUnit.unitCode" sort="false" search="false" />
						<hb:HibachiListingColumn processObjectProperty="cost" title="#$.slatwall.rbKey('define.cost')#" fieldClass="span1" />
						<hb:HibachiListingColumn processObjectProperty="vendorSkuCode" title="#$.slatwall.rbKey('process.vendorOrder_AddVendorOrderItem.vendorSkuCode')#" fieldClass="span1"/>
						
					</hb:HibachiListingDisplay>
				</sw-tab-content>

				<sw-tab-content id="#request.slatwallScope.createHibachiUUID()#" name="#$.slatwall.rbKey('admin.vendororder.addItems.all')#">
					<cfset local.vendorOrderAllSkuOptionsSmartList = rc.vendorOrder.getAddVendorOrderItemAllSkuOptionsSmartList() />
					<cfset local.vendorOrderAllSkuOptionsSmartList.addKeywordProperty(propertyIdentifier="product.productCode", weight=1 ) />
					<cfset local.vendorOrderAllSkuOptionsSmartList.addKeywordProperty(propertyIdentifier="product.brand.brandName", weight=1 ) />
					<cfset local.vendorOrderAllSkuOptionsSmartList.addKeywordProperty(propertyIdentifier="product.productName", weight=1 ) />
					<cfset local.vendorOrderAllSkuOptionsSmartList.addKeywordProperty(propertyIdentifier="product.productType.productTypeName", weight=1 ) />
					
					<hb:HibachiListingDisplay smartList="#local.vendorOrderAllSkuOptionsSmartList#"
											recordProcessAction="admin:entity.processVendorOrder"
											recordProcessQueryString="vendorOrderItemTypeSystemCode=voitPurchase"
											recordProcessContext="addVendorOrderItem"
											recordProcessEntity="#rc.vendorOrder#"
											recordProcessUpdateTableID="LD#replace(rc.vendorOrder.getVendorOrderItemsSmartList().getSavedStateID(),'-','','all')#">
												
						<hb:HibachiListingColumn propertyIdentifier="skuCode" />
						<hb:HibachiListingColumn propertyIdentifier="skuName" />
						<hb:HibachiListingColumn processObjectProperty="price" title="#$.slatwall.rbKey('define.price')#" />
						<hb:HibachiListingColumn propertyIdentifier="product.productCode" />
						<hb:HibachiListingColumn propertyIdentifier="product.brand.brandName" />
						<hb:HibachiListingColumn tdclass="primary" propertyIdentifier="product.productName" />
						<hb:HibachiListingColumn propertyIdentifier="calculatedSkuDefinition" />
						<hb:HibachiListingColumn propertyIdentifier="product.productType.productTypeName" />
						<hb:HibachiListingColumn propertyIdentifier="calculatedQATS" />
						
						<hb:HibachiListingColumn processObjectProperty="deliverToLocationID" title="#$.slatwall.rbKey('process.vendorOrder_AddVendorOrderItem.deliverToLocationID')#" fieldClass="span2" />
						<hb:HibachiListingColumn processObjectProperty="quantity" title="#$.slatwall.rbKey('define.quantity')#" fieldClass="span1" />
						<hb:HibachiListingColumn propertyIdentifier="inventoryMeasurementUnit.unitCode" sort="false" search="false" />
						<hb:HibachiListingColumn processObjectProperty="cost" title="#$.slatwall.rbKey('define.cost')#" fieldClass="span1" />
						<hb:HibachiListingColumn processObjectProperty="vendorSkuCode" title="#$.slatwall.rbKey('process.vendorOrder_AddVendorOrderItem.vendorSkuCode')#" fieldClass="span1"/>
						
					</hb:HibachiListingDisplay>
				</sw-tab-content>
		</sw-tab-group>
		</cfif>
	</cfif>
</cfoutput>
