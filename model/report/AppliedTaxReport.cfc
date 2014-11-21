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
			{alias='taxAmount', function='sum', formatType="currency", title=rbKey('entity.taxApplied.taxAmount')},
			{alias='taxRate', function='avg', formatType="currency", title=rbKey('entity.taxApplied.taxRate')}
		] />
	</cffunction>
	
	<cffunction name="getDimensionDefinitions">
		<cfreturn [
			{alias='taxCategoryName', title=rbKey('entity.taxCategory.taxCategoryName')},
			{alias='taxCategoryCode', title=rbKey('entity.taxCategory.taxCategoryCode')},
			{alias='taxCategoryRateCode', title=rbKey('entity.taxCategoryRate.taxCategoryRateCode')},
			{alias='taxRate', title=rbKey('entity.taxApplied.taxRate')},
			{alias='taxAmount', title=rbKey('entity.taxApplied.taxAmount')},
			{alias='taxLiabilityAmount', title=rbKey('entity.taxApplied.taxLiabilityAmount')},
			{alias='currencyCode', title=rbKey('entity.taxApplied.currencyCode')},
			{alias='taxImpositionName', title=rbKey('entity.taxApplied.taxImpositionName')},
			{alias='taxImpositionType', title=rbKey('entity.taxApplied.taxImpositionType')},
			{alias='taxJurisdictionName', title=rbKey('entity.taxApplied.taxJurisdictionName')},
			{alias='taxJurisdictionType', title=rbKey('entity.taxApplied.taxJurisdictionType')},
			{alias='taxStreetAddress', title=rbKey('entity.taxApplied.taxStreetAddress')},
			{alias='taxStreet2Address', title=rbKey('entity.taxApplied.taxStreet2Address')},
			{alias='taxLocality', title=rbKey('entity.taxApplied.taxLocality')},
			{alias='taxCity', title=rbKey('entity.taxApplied.taxCity')},
			{alias='taxStateCode', title=rbKey('entity.taxApplied.taxStateCode')},
			{alias='taxPostalCode', title=rbKey('entity.taxApplied.taxPostalCode')},
			{alias='taxCountryCode', title=rbKey('entity.taxApplied.taxCountryCode')},
			{alias='orderID', title=rbKey('entity.order.orderID')},
			{alias='orderNumber', title=rbKey('entity.order.orderNumber')},
			{alias='referencedOrderID', title=rbKey('entity.order.referencedOrderID')},
			{alias='referencedOrderNumber', title=rbKey('entity.order.referencedOrderNumber')},
			{alias='fulfillmentMethodName', title=rbKey('entity.fulfillmentMethod.fulfillmentMethodName')}
		] />
	</cffunction>
	
	<cffunction name="getData" returnType="Query">
		<cfif not structKeyExists(variables, "data")>
			<cfquery name="variables.data">
				SELECT
					SwTaxCategory.taxCategoryName,
					SwTaxCategory.taxCategoryCode,
					SwTaxCategoryRate.taxCategoryRateCode,
					SwTaxApplied.taxRate,
					SwTaxApplied.taxAmount,
					SwTaxApplied.taxLiabilityAmount,
					SwTaxApplied.currencyCode,
					SwTaxApplied.taxImpositionName,
					SwTaxApplied.taxImpositionType,
					SwTaxApplied.taxJurisdictionName,
					SwTaxApplied.taxJurisdictionType,
					SwTaxApplied.taxStreetAddress,
					SwTaxApplied.taxStreet2Address,
					SwTaxApplied.taxLocality,
					SwTaxApplied.taxCity,
					SwTaxApplied.taxStateCode,
					SwTaxApplied.taxPostalCode,
					SwTaxApplied.taxCountryCode,
					SwSku.skuID,
					SwSku.skuCode,
					SwProduct.productID,
					SwProduct.productName,
					SwProductType.productTypeID,
					SwProductType.productTypeName,
					SwOrder.orderID,
					SwOrder.orderNumber,
					ro.orderID as referencedOrderID,
					ro.orderNumber as referencedOrderNumber,
					SwFulfillmentMethod.fulfillmentMethodName,
					SwAddress.countryCode,
					SwAddress.stateCode,
					SwAddress.city,
					SwOrderItem.quantity,
					SwOrderItem.price,
					CASE
    					WHEN SwOrderItem.orderItemTypeID = '444df2e9a6622ad1614ea75cd5b982ce' THEN
    						(SwOrderItem.price * SwOrderItem.quantity)
						ELSE
							0
					END as salePreDiscount,
					CASE
    					WHEN SwOrderItem.orderItemTypeID = '444df2eac18fa589af0f054442e12733' THEN
    						(SwOrderItem.price * SwOrderItem.quantity)
    					ELSE
    						0
					END as returnPreDiscount,
					( SELECT COALESCE(SUM(swpa.discountAmount), 0) FROM SwPromotionApplied swpa WHERE swpa.orderItemID = SwOrderItem.orderItemID ) as itemDiscount,
					#getReportDateTimeSelect()#
				FROM
					SwTaxApplied
				  INNER JOIN
				  	SwTaxCategoryRate on SwTaxApplied.taxCategoryRateID = SwTaxCategoryRate.taxCategoryRateID
				  INNER JOIN
				  	SwTaxCategory on SwTaxCategoryRate.taxCategoryID = SwTaxCategory.taxCategoryID 
				  INNER JOIN
					SwOrderItem on SwTaxApplied.orderItemID = SwOrderItem.orderItemID
				  INNER JOIN
				  	SwOrderFulfillment on SwOrderItem.orderFulfillmentID = SwOrderFulfillment.orderFulfillmentID
				  INNER JOIN
				  	SwFulfillmentMethod on SwOrderFulfillment.fulfillmentMethodID = SwFulfillmentMethod.fulfillmentMethodID
				  INNER JOIN
				  	SwOrder on SwOrderFulfillment.orderID = SwOrder.orderID
				  INNER JOIN
				  	SwAccount on SwOrder.accountID = SwAccount.accountID
				  INNER JOIN
				  	SwSku on SwOrderItem.skuID = SwSku.skuID
				  INNER JOIN
				  	SwProduct on SwSku.productID = SwProduct.productID
				  INNER JOIN
				  	SwProductType on SwProduct.productTypeID = SwProductType.productTypeID
				  LEFT JOIN
				  	SwAddress on SwOrderFulfillment.shippingAddressID = SwAddress.addressID
				  LEFT JOIN
				  	SwOrder ro on SwOrder.orderID = ro.referencedOrderID 
				WHERE
					SwOrder.orderOpenDateTime is not null
				  AND
					#getReportDateTimeWhere()#
			</cfquery>
		</cfif>
		
		<cfreturn variables.data />
	</cffunction>
	
</cfcomponent>
