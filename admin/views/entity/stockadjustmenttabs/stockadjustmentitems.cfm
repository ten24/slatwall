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

<cfparam name="rc.stockAdjustment" type="any" />

<hb:HibachiListingDisplay smartList="#rc.stockAdjustment.getstockAdjustmentItemsSmartList()#"
						  recordDeleteAction="admin:entity.deleteStockAdjustmentItem"
						  recordDeleteQueryString="redirectAction=admin:entity.editstockadjustment&stockAdjustmentID=#rc.stockadjustment.getStockAdjustmentID()#"
						  recordEditAction="admin:entity.editStockAdjustmentItem"
						  recordEditQueryString="redirectAction=admin:entity.editstockadjustment"
						  recordEditModal="true">
						   	   
	<cfif listFindNoCase("satLocationTransfer,satManualOut,satPhysicalCount", rc.stockAdjustment.getStockAdjustmentType().getSystemCode())>
		<hb:HibachiListingColumn tdclass="primary" propertyIdentifier="fromstock.sku.skucode" />
		<hb:HibachiListingColumn propertyIdentifier="fromstock.sku.product.brand.brandName" />
		<hb:HibachiListingColumn propertyIdentifier="fromstock.sku.product.productName" />
		<hb:HibachiListingColumn propertyIdentifier="fromstock.sku.skuDefinition" sort="false" />
		<hb:HibachiListingColumn propertyIdentifier="fromstock.location.locationName" title="#$.slatwall.rbKey('admin.warehouse.detailstockadjustment.fromlocationname')#" />
		<cfif rc.stockAdjustment.getStockAdjustmentType().getSystemCode() eq "satLocationTransfer">
			<hb:HibachiListingColumn propertyIdentifier="tostock.location.locationName" title="#$.slatwall.rbKey('admin.warehouse.detailstockadjustment.tolocationname')#" />
		</cfif>
	<cfelse>
		<hb:HibachiListingColumn tdclass="primary" propertyIdentifier="tostock.sku.skucode" />
		<hb:HibachiListingColumn propertyIdentifier="tostock.sku.product.brand.brandName" />
		<hb:HibachiListingColumn propertyIdentifier="tostock.sku.product.productName" />
		<hb:HibachiListingColumn propertyIdentifier="tostock.sku.skuDefinition" sort="false" />
		<hb:HibachiListingColumn propertyIdentifier="tostock.location.locationName" title="#$.slatwall.rbKey('admin.warehouse.detailstockadjustment.tolocationname')#" />
	</cfif>
	
	<hb:HibachiListingColumn propertyIdentifier="quantity" />
</hb:HibachiListingDisplay>

<cfif rc.edit>
	<cfscript>
			if( rc.stockAdjustment.getStockAdjustmentType().getSystemCode() eq "satLocationTransfer"){
					SL=rc.stockAdjustment.getAddStockAdjustmentItemStockOptionsSmartList();
				}else{
					SL=rc.stockAdjustment.getAddStockAdjustmentItemSkuOptionsSmartList();
				}
	</cfscript>
	<hb:HibachiListingDisplay smartList="#SL#"
							  recordProcessAction="admin:entity.processStockAdjustment"
							  recordProcessContext="addStockAdjustmentItem"
							  recordProcessEntity="#rc.stockAdjustment#"
							  recordProcessUpdateTableID="LD#replace(rc.stockAdjustment.getstockAdjustmentItemsSmartList().getSavedStateID(),'-','','all')#">
		<cfif rc.stockAdjustment.getStockAdjustmentType().getSystemCode() eq "satLocationTransfer">
			<hb:HibachiListingColumn propertyIdentifier="sku.skuCode" />
			<hb:HibachiListingColumn propertyIdentifier="sku.product.productCode" />
			<hb:HibachiListingColumn propertyIdentifier="sku.product.brand.brandName" />
			<hb:HibachiListingColumn tdclass="primary" propertyIdentifier="sku.product.productName" />
			<hb:HibachiListingColumn propertyIdentifier="sku.product.productType.productTypeName" />
			<hb:HibachiListingColumn propertyIdentifier="calculatedQNC" />
		<cfelse>
			<hb:HibachiListingColumn propertyIdentifier="skuCode" />
			<hb:HibachiListingColumn propertyIdentifier="product.productCode" />
			<hb:HibachiListingColumn propertyIdentifier="product.brand.brandName" />
			<hb:HibachiListingColumn tdclass="primary" propertyIdentifier="product.productName" />
			<hb:HibachiListingColumn propertyIdentifier="product.productType.productTypeName" />
		</cfif>					    
		
		<hb:HibachiListingColumn processObjectProperty="quantity" title="#$.slatwall.rbKey('define.quantity')#" fieldClass="span1" />
	</hb:HibachiListingDisplay>
</cfif>
