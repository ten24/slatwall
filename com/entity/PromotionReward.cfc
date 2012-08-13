/*

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

	Valid Reward Types
	
	merchandise
	subscription
	contentAccess
	fulfillment
	order

*/
component displayname="Promotion Reward" entityname="SlatwallPromotionReward" table="SlatwallPromotionReward" persistent="true" extends="BaseEntity" {
	
	// Persistent Properties
	property name="promotionRewardID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="amount" ormType="big_decimal" formatType="custom";
	property name="amountType" ormType="string" formFieldType="select" formatType="custom";
	property name="rewardType" ormType="string" formFieldType="select" formatType="custom";
	property name="applicableTerm" ormType="string" formFieldType="select" formatType="custom";
	property name="maximumUsePerOrder" ormType="integer" formatType="custom";
	property name="maximumUsePerItem" ormtype="integer" formatType="custom";
	property name="maximumUsePerQualification" ormtype="integer" formatType="custom";

	// Related Object Properties (many-to-one)
	property name="promotionPeriod" cfc="PromotionPeriod" fieldtype="many-to-one" fkcolumn="promotionPeriodID";
	property name="roundingRule" cfc="RoundingRule" fieldtype="many-to-one" fkcolumn="roundingRuleID" nullRBKey="define.none";
	
	// Related Object Properties (many-to-many - owner)
	property name="eligiblePriceGroups" singularname="eligiblePriceGroup" cfc="PriceGroup" type="array" fieldtype="many-to-many" linktable="SlatwallPromotionRewardEligiblePriceGroup" fkcolumn="promotionRewardID" inversejoincolumn="priceGroupID";
	
	property name="fulfillmentMethods" singularname="fulfillmentMethod" cfc="FulfillmentMethod" fieldtype="many-to-many" linktable="SlatwallPromotionRewardFulfillmentMethod" fkcolumn="promotionRewardID" inversejoincolumn="fulfillmentMethodID";
	property name="shippingAddressZones" singularname="shippingAddressZone" cfc="AddressZone" fieldtype="many-to-many" linktable="SlatwallPromotionRewardShippingAddressZone" fkcolumn="promotionRewardID" inversejoincolumn="addressZoneID";
	property name="shippingMethods" singularname="shippingMethod" cfc="ShippingMethod" fieldtype="many-to-many" linktable="SlatwallPromotionRewardShippingMethod" fkcolumn="promotionRewardID" inversejoincolumn="shippingMethodID";
	
	property name="brands" singularname="brand" cfc="Brand" fieldtype="many-to-many" linktable="SlatwallPromotionRewardBrand" fkcolumn="promotionRewardID" inversejoincolumn="brandID";
	property name="options" singularname="option" cfc="Option" fieldtype="many-to-many" linktable="SlatwallPromotionRewardOption" fkcolumn="promotionRewardID" inversejoincolumn="optionID";
	property name="skus" singularname="sku" cfc="Sku" fieldtype="many-to-many" linktable="SlatwallPromotionRewardSku" fkcolumn="promotionRewardID" inversejoincolumn="skuID";
	property name="products" singularname="product" cfc="Product" fieldtype="many-to-many" linktable="SlatwallPromotionRewardProduct" fkcolumn="promotionRewardID" inversejoincolumn="productID";
	property name="productTypes" singularname="productType" cfc="ProductType" fieldtype="many-to-many" linktable="SlatwallPromotionRewardProductType" fkcolumn="promotionRewardID" inversejoincolumn="productTypeID";
	
	property name="excludedBrands" singularname="excludedBrand" cfc="Brand" type="array" fieldtype="many-to-many" linktable="SlatwallPromotionRewardExcludedBrand" fkcolumn="promotionRewardID" inversejoincolumn="brandID";
	property name="excludedOptions" singularname="excludedOption" cfc="Option" type="array" fieldtype="many-to-many" linktable="SlatwallPromotionRewardExcludedOption" fkcolumn="promotionRewardID" inversejoincolumn="optionID";
	property name="excludedSkus" singularname="excludedSku" cfc="Sku" fieldtype="many-to-many" linktable="SlatwallPromotionRewardExcludedSku" fkcolumn="promotionRewardID" inversejoincolumn="skuID";
	property name="excludedProducts" singularname="excludedProduct" cfc="Product" fieldtype="many-to-many" linktable="SlatwallPromotionRewardExcludedProduct" fkcolumn="promotionRewardID" inversejoincolumn="productID";
	property name="excludedProductTypes" singularname="excludedProductType" cfc="ProductType" fieldtype="many-to-many" linktable="SlatwallPromotionRewardExcludedProductType" fkcolumn="promotionRewardID" inversejoincolumn="productTypeID";
	
	// Remote Properties
	property name="remoteID" ormtype="string";
	
	// Audit properties
	property name="createdDateTime" ormtype="timestamp";
	property name="createdByAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="createdByAccountID";
	property name="modifiedDateTime" ormtype="timestamp";
	property name="modifiedByAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="modifiedByAccountID";

	// Non-persistent entities
	property name="amountTypeOptions" persistent="false";
	property name="applicableTermOptions" persistent="false";
	property name="rewards" type="string" persistent="false";


	// ============ START: Non-Persistent Property Methods =================
	
	public array function getApplicableTermOptions() {
		return [
			{name=rbKey("define.both"), value="both"},
			{name=rbKey("define.initial"), value="initial"},
			{name=rbKey("define.renewal"), value="renewal"}
		];
	}
	
	public array function getAmountTypeOptions() {
		if(getRewardType() == "order") {
			return [
				{name=rbKey("define.percentageOff"), value="percentageOff"},
				{name=rbKey("define.amountOff"), value="amountOff"}
			];
		} else {
			return [
				{name=rbKey("define.percentageOff"), value="percentageOff"},
				{name=rbKey("define.amountOff"), value="amountOff"},
				{name=rbKey("define.fixedAmount"), value="amount"}
			];
		}
	}
	
	// ============  END:  Non-Persistent Property Methods =================

	// ============= START: Bidirectional Helper Methods ===================
	
	// Promotion Period (many-to-one)
	public void function setPromotionPeriod(required any promotionPeriod) {
		variables.promotionPeriod = arguments.promotionPeriod;
		if(!arguments.promotionPeriod.hasPromotionReward(this)) {
			arrayAppend(arguments.promotionPeriod.getPromotionRewards(),this);
		}
	}
	public void function removePromotionPeriod(any promotionPeriod) {
	   if(!structKeyExists(arguments, "promotionPeriod")) {
	   		arguments.promotionPeriod = variables.promotionPeriod;
	   }
       var index = arrayFind(arguments.promotionPeriod.getPromotionRewards(),this);
       if(index > 0) {
           arrayDeleteAt(arguments.promotionPeriod.getPromotionRewards(), index);
       }
       structDelete(variables,"promotionPeriod");
    }

	// Eligible Price Groups (many-to-many - owner)
	public void function addEligiblePriceGroup(required any eligiblePriceGroup) {
		if(arguments.eligiblePriceGroup.isNew() or !hasEligiblePriceGroup(arguments.eligiblePriceGroup)) {
			arrayAppend(variables.eligiblePriceGroups, arguments.eligiblePriceGroup);
		}
		if(isNew() or !arguments.eligiblePriceGroup.hasPromotionReward( this )) {
			arrayAppend(arguments.eligiblePriceGroup.getPromotionRewards(), this);
		}
	}
	public void function removeEligiblePriceGroup(required any eligiblePriceGroup) {
		var thisIndex = arrayFind(variables.eligiblePriceGroups, arguments.eligiblePriceGroup);
		if(thisIndex > 0) {
			arrayDeleteAt(variables.eligiblePriceGroups, thisIndex);
		}
		var thatIndex = arrayFind(arguments.eligiblePriceGroup.getPromotionRewards(), this);
		if(thatIndex > 0) {
			arrayDeleteAt(arguments.eligiblePriceGroup.getPromotionRewards(), thatIndex);
		}
	}

	// Brands (many-to-many - owner)
	public void function addBrand(required any brand) {
		if(arguments.brand.isNew() or !hasBrand(arguments.brand)) {
			arrayAppend(variables.brands, arguments.brand);
		}
		if(isNew() or !arguments.brand.hasPromotionReward( this )) {
			arrayAppend(arguments.brand.getPromotionRewards(), this);
		}
	}
	public void function removeBrand(required any brand) {
		var thisIndex = arrayFind(variables.brands, arguments.brand);
		if(thisIndex > 0) {
			arrayDeleteAt(variables.brands, thisIndex);
		}
		var thatIndex = arrayFind(arguments.brand.getPromotionRewards(), this);
		if(thatIndex > 0) {
			arrayDeleteAt(arguments.brand.getPromotionRewards(), thatIndex);
		}
	}

	// Options (many-to-many - owner)
	public void function addOption(required any option) {
		if(arguments.option.isNew() or !hasOption(arguments.option)) {
			arrayAppend(variables.options, arguments.option);
		}
		if(isNew() or !arguments.option.hasPromotionReward( this )) {
			arrayAppend(arguments.option.getPromotionRewards(), this);
		}
	}
	public void function removeOption(required any option) {
		var thisIndex = arrayFind(variables.options, arguments.option);
		if(thisIndex > 0) {
			arrayDeleteAt(variables.options, thisIndex);
		}
		var thatIndex = arrayFind(arguments.option.getPromotionRewards(), this);
		if(thatIndex > 0) {
			arrayDeleteAt(arguments.option.getPromotionRewards(), thatIndex);
		}
	}
	
	// Skus (many-to-many - owner)    
	public void function addSku(required any sku) {    
		if(arguments.sku.isNew() or !hasSku(arguments.sku)) {    
			arrayAppend(variables.skus, arguments.sku);    
		}    
		if(isNew() or !arguments.sku.hasPromotionReward( this )) {    
			arrayAppend(arguments.sku.getPromotionRewards(), this);    
		}    
	}    
	public void function removeSku(required any sku) {    
		var thisIndex = arrayFind(variables.skus, arguments.sku);    
		if(thisIndex > 0) {    
			arrayDeleteAt(variables.skus, thisIndex);    
		}    
		var thatIndex = arrayFind(arguments.sku.getPromotionRewards(), this);    
		if(thatIndex > 0) {    
			arrayDeleteAt(arguments.sku.getPromotionRewards(), thatIndex);    
		}    
	}

	// Products (many-to-many - owner)
	public void function addProduct(required any product) {
		if(arguments.product.isNew() or !hasProduct(arguments.product)) {
			arrayAppend(variables.products, arguments.product);
		}
		if(isNew() or !arguments.product.hasPromotionReward( this )) {
			arrayAppend(arguments.product.getPromotionRewards(), this);
		}
	}
	public void function removeProduct(required any product) {
		var thisIndex = arrayFind(variables.products, arguments.product);
		if(thisIndex > 0) {
			arrayDeleteAt(variables.products, thisIndex);
		}
		var thatIndex = arrayFind(arguments.product.getPromotionRewards(), this);
		if(thatIndex > 0) {
			arrayDeleteAt(arguments.product.getPromotionRewards(), thatIndex);
		}
	}
	
	// Product Types (many-to-many - owner)
	public void function addProductType(required any productType) {
		if(arguments.productType.isNew() or !hasProductType(arguments.productType)) {
			arrayAppend(variables.productTypes, arguments.productType);
		}
		if(isNew() or !arguments.productType.hasPromotionReward( this )) {
			arrayAppend(arguments.productType.getPromotionRewards(), this);
		}
	}
	public void function removeProductType(required any productType) {
		var thisIndex = arrayFind(variables.productTypes, arguments.productType);
		if(thisIndex > 0) {
			arrayDeleteAt(variables.productTypes, thisIndex);
		}
		var thatIndex = arrayFind(arguments.productType.getPromotionRewards(), this);
		if(thatIndex > 0) {
			arrayDeleteAt(arguments.productType.getPromotionRewards(), thatIndex);
		}
	}
	
	// Shipping Methods (many-to-many - owner)    
	public void function addShippingMethod(required any shippingMethod) {    
		if(arguments.shippingMethod.isNew() or !hasShippingMethod(arguments.shippingMethod)) {    
			arrayAppend(variables.shippingMethods, arguments.shippingMethod);    
		}    
		if(isNew() or !arguments.shippingMethod.hasPromotionReward( this )) {    
			arrayAppend(arguments.shippingMethod.getPromotionRewards(), this);    
		}    
	}    
	public void function removeShippingMethod(required any shippingMethod) {    
		var thisIndex = arrayFind(variables.shippingMethods, arguments.shippingMethod);    
		if(thisIndex > 0) {    
			arrayDeleteAt(variables.shippingMethods, thisIndex);    
		}    
		var thatIndex = arrayFind(arguments.shippingMethod.getPromotionRewards(), this);    
		if(thatIndex > 0) {    
			arrayDeleteAt(arguments.shippingMethod.getPromotionRewards(), thatIndex);    
		}    
	}
	
	// Excluded Product Types (many-to-many - owner)
	public void function addExcludedProductType(required any excludedProductType) {
		if(arguments.excludedProductType.isNew() or !hasExcludedProductType(arguments.excludedProductType)) {
			arrayAppend(variables.excludedProductTypes, arguments.excludedProductType);
		}
		if(isNew() or !arguments.excludedProductType.hasPromotionReward( this )) {
			arrayAppend(arguments.excludedProductType.getPromotionRewards(), this);
		}
	}
	public void function removeExcludedProductType(required any excludedProductType) {
		var thisIndex = arrayFind(variables.excludedProductTypes, arguments.excludedProductType);
		if(thisIndex > 0) {
			arrayDeleteAt(variables.excludedProductTypes, thisIndex);
		}
		var thatIndex = arrayFind(arguments.excludedProductType.getPromotionRewards(), this);
		if(thatIndex > 0) {
			arrayDeleteAt(arguments.excludedProductType.getPromotionRewards(), thatIndex);
		}
	}
	
	// Excluded Products (many-to-many - owner)
	public void function addExcludedProduct(required any excludedProduct) {
		if(arguments.excludedProduct.isNew() or !hasExcludedProduct(arguments.excludedProduct)) {
			arrayAppend(variables.excludedProducts, arguments.excludedProduct);
		}
		if(isNew() or !arguments.excludedProduct.hasPromotionReward( this )) {
			arrayAppend(arguments.excludedProduct.getPromotionRewards(), this);
		}
	}
	public void function removeExcludedProduct(required any excludedProduct) {
		var thisIndex = arrayFind(variables.excludedProducts, arguments.excludedProduct);
		if(thisIndex > 0) {
			arrayDeleteAt(variables.excludedProducts, thisIndex);
		}
		var thatIndex = arrayFind(arguments.excludedProduct.getPromotionRewards(), this);
		if(thatIndex > 0) {
			arrayDeleteAt(arguments.excludedProduct.getPromotionRewards(), thatIndex);
		}
	}
	
	// Excluded Skus (many-to-many - owner)
	public void function addExcludedSku(required any excludedSku) {
		if(arguments.excludedSku.isNew() or !hasExcludedSku(arguments.excludedSku)) {
			arrayAppend(variables.excludedSkus, arguments.excludedSku);
		}
		if(isNew() or !arguments.excludedSku.hasPromotionReward( this )) {
			arrayAppend(arguments.excludedSku.getPromotionRewards(), this);
		}
	}
	public void function removeExcludedSku(required any excludedSku) {
		var thisIndex = arrayFind(variables.excludedSkus, arguments.excludedSku);
		if(thisIndex > 0) {
			arrayDeleteAt(variables.excludedSkus, thisIndex);
		}
		var thatIndex = arrayFind(arguments.excludedSku.getPromotionRewards(), this);
		if(thatIndex > 0) {
			arrayDeleteAt(arguments.excludedSku.getPromotionRewards(), thatIndex);
		}
	}
	
	// =============  END:  Bidirectional Helper Methods ===================
	
	// =============== START: Custom Formatting Methods ====================
	
	public string function getAmountFormatted() {
		if(getAmountType() == "percentageOff") {
			return formatValue(getAmount(), "percentage");
		}
		
		return formatValue(getAmount(), "currency");
	}
	
	public string function getAmountTypeFormatted() {
		return rbKey('define.#getAmountType()#');
	}
	
	public string function getRewardTypeFormatted() {
		return rbKey('define.#getRewardType()#');
	}
	
	public string function getApplicableTermFormatted() {
		return rbKey('define.#getApplicableTerm()#');
	}
	
	public any function getMaximumUsePerOrderFormatted() {
		if(isNull(getMaximumUsePerOrder()) || !isNumeric(getMaximumUsePerOrder()) || getMaximumUsePerOrder() == 0) {
			return rbKey('define.unlimited');
		}
		return getMaximumUsePerOrder();
	}
	
	public any function getMaximumUsePerItemFormatted() {
		if(isNull(getMaximumUsePerItem()) || !isNumeric(getMaximumUsePerItem()) || getMaximumUsePerItem() == 0) {
			return rbKey('define.unlimited');
		}
		return getMaximumUsePerItem();
	}
	
	public any function getMaximumUsePerQualificationFormatted() {
		if(isNull(getMaximumUsePerQualification()) || !isNumeric(getMaximumUsePerQualification()) || getMaximumUsePerQualification() == 0) {
			return rbKey('define.unlimited');
		}
		return getMaximumUsePerQualification();
	}
	
	// ===============  END: Custom Formatting Methods =====================

	// ================== START: Overridden Methods ========================
	
	public string function getSimpleRepresentationPropertyName() {
		return "rewardType";
	}

	public boolean function isDeletable() {
		return !getPromotionPeriod().isExpired() && getPromotionPeriod().getPromotion().isDeletable();
	}
	
	// ==================  END:  Overridden Methods ========================

	// =================== START: ORM Event Hooks  =========================
	
	// ===================  END:  ORM Event Hooks  =========================
}