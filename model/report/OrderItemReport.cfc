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
<cfcomponent accessors="true" persistent="false" output="false" extends="HibachiReport">
	
	<cffunction name="getReportDateTimeDefinitions">
		<cfreturn [
			{alias='orderOpenDateTime', dataColumn='SwOrder.orderOpenDateTime', title=rbKey('entity.order.orderOpenDateTime')},
			{alias='orderCloseDateTime', dataColumn='SwOrder.orderCloseDateTime', title=rbKey('entity.order.orderCloseDateTime')}
		] />
	</cffunction>
	
	<cffunction name="getMetricDefinitions">
		<cfreturn [
			{alias='revenue', calculation='SUM(salePreDiscount) + SUM(returnPreDiscount) - SUM(itemDiscount)', formatType="currency"},
			{alias='salePreDiscount', function='sum', formatType="currency"},
			{alias='returnPreDiscount', function='sum', formatType="currency"},
			{alias='quantity', calculation='SUM(quantitySold) + SUM(quantityReturned)', title=rbKey('entity.orderItem.quantity')},
			{alias='quantitySold', function='sum'},
			{alias='quantityReturned', function='sum'},
			{alias='itemDiscount', function='sum', formatType="currency"},
			{alias='itemTax', function='sum', formatType="currency"},
			{alias='saleAfterDiscount', calculation='SUM(salePreDiscount) - SUM(itemDiscount)', formatType="currency"},
			{alias='returnAfterDiscount', calculation='SUM(returnPreDiscount) - SUM(itemDiscount)', formatType="currency"}
		] />
	</cffunction>
	
	<cffunction name="getDimensionDefinitions">
		<cfreturn [
			{alias='productName', filterAlias='productID', filterDimension='skuCode', title=rbKey('entity.product.productName')},
			{alias='skuCode', title=rbKey('entity.sku.skuCode')},
			{alias='productTypeName', filterAlias='productTypeID', filterDimension='productName', title=rbKey('entity.productType.productTypeName')},
			{alias='brandName', title=rbKey('entity.brand.brandName')},
			{alias='currencyCode', title=rbKey('entity.currency.currencyCode')},
			{alias='price', formatType="currency", title=rbKey('entity.orderItem.price')},
			{alias='typeName', title=rbKey('entity.orderItem.orderItemType')},
			{alias='orderNumber', title=rbKey('entity.order.orderNumber')},
			{alias='orderOpenDateTime', title=rbKey('entity.order.orderOpenDateTime')},
			{alias='orderCloseDateTime', title=rbKey('entity.order.orderCloseDateTime')},
			{alias='stateCode', title=rbKey('entity.address.stateCode')},
			{alias='city', title=rbKey('entity.address.city')},
			{alias='postalCode', title=rbKey('entity.address.postalCode')},
			{alias='countryCode', title=rbKey('entity.address.countryCode')}
		] />
	</cffunction>
	
	<cffunction name="getData" returnType="Query">
		<cfif not structKeyExists(variables, "data")>
			<cfquery name="variables.data">
				SELECT
					SwSku.skuID,
					SwSku.skuCode,
					SwProduct.productID,
					SwProduct.productName,
					SwProductType.productTypeID,
					SwProductType.productTypeName,
					SwBrand.brandID,
					SwBrand.brandName,
					SwOrder.orderID,
					SwOrder.orderNumber,
					SwOrder.orderOpenDateTime,
					SwOrder.orderCloseDateTime,
					SwOrder.currencyCode,
					<cfif getApplicationValue('databaseType') eq "Oracle10g">
						oit."typeName" as type,
					<cfelse>
						oit.typeName,
					</cfif>
					SwAddress.city,
					SwAddress.stateCode,
					SwAddress.postalCode,
					SwOrderItem.price,
					SwAddress.countryCode,
					CASE
    					WHEN SwOrderItem.orderItemTypeID = '444df2e9a6622ad1614ea75cd5b982ce' THEN
    						SwOrderItem.quantity
						ELSE
							0
					END as quantitySold,
					CASE
    					WHEN SwOrderItem.orderItemTypeID = '444df2eac18fa589af0f054442e12733' THEN
    						SwOrderItem.quantity * -1
						ELSE
							0
					END as quantityReturned,
					CASE
    					WHEN SwOrderItem.orderItemTypeID = '444df2e9a6622ad1614ea75cd5b982ce' THEN
    						(SwOrderItem.price * SwOrderItem.quantity)
						ELSE
							0
					END as salePreDiscount,
					CASE
    					WHEN SwOrderItem.orderItemTypeID = '444df2eac18fa589af0f054442e12733' THEN
    						(SwOrderItem.price * SwOrderItem.quantity) * -1
    					ELSE
    						0
					END as returnPreDiscount,
					( SELECT COALESCE(SUM(swpa.discountAmount), 0) FROM SwPromotionApplied swpa WHERE swpa.orderItemID = SwOrderItem.orderItemID AND SwOrderItem.orderItemTypeID = '444df2e9a6622ad1614ea75cd5b982ce' ) - ( SELECT COALESCE(SUM(swpa.discountAmount), 0) FROM SwPromotionApplied swpa WHERE swpa.orderItemID = SwOrderItem.orderItemID AND SwOrderItem.orderItemTypeID = '444df2eac18fa589af0f054442e12733' ) as itemDiscount,
					( SELECT COALESCE(SUM(swta.taxAmount), 0) FROM SwTaxApplied swta WHERE swta.orderItemID = SwOrderItem.orderItemID AND SwOrderItem.orderItemTypeID = '444df2e9a6622ad1614ea75cd5b982ce' ) - ( SELECT COALESCE(SUM(swta.taxAmount), 0) FROM SwTaxApplied swta WHERE swta.orderItemID = SwOrderItem.orderItemID AND SwOrderItem.orderItemTypeID = '444df2eac18fa589af0f054442e12733' ) as itemTax,
					#getReportDateTimeSelect()#
				FROM
					SwOrderItem
				  INNER JOIN
				  	SwType oit on SwOrderItem.orderItemTypeID = oit.typeID
				  LEFT JOIN
				  	SwOrderFulfillment on SwOrderItem.orderFulfillmentID = SwOrderFulfillment.orderFulfillmentID
				  INNER JOIN
				  	SwOrder on SwOrderItem.orderID = SwOrder.orderID
				  INNER JOIN
				  	SwAccount on SwOrder.accountID = SwAccount.accountID
				  INNER JOIN
				  	SwSku on SwOrderItem.skuID = SwSku.skuID
				  INNER JOIN
				  	SwProduct on SwSku.productID = SwProduct.productID
				  INNER JOIN
				  	SwProductType on SwProduct.productTypeID = SwProductType.productTypeID
				  LEFT JOIN
				  	SwBrand on SwProduct.brandID = SwBrand.brandID
				  LEFT JOIN
				  	SwAddress on SwOrderFulfillment.shippingAddressID = SwAddress.addressID
				WHERE
					SwOrder.orderOpenDateTime is not null
				  AND
					#getReportDateTimeWhere()#
			</cfquery>
		</cfif>
		
		<cfreturn variables.data />
	</cffunction>
	
</cfcomponent>