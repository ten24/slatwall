/*

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

*/
component displayname="Promotion Qualifier" entityname="SlatwallPromotionQualifier" table="SwPromoQual" persistent="true" extends="HibachiEntity" cacheuse="transactional" hb_serviceName="promotionService" hb_permission="promotionPeriod.promotionQualifiers" {
	
	// Persistent Properties
	property name="promotionQualifierID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="qualifierType" ormtype="string" hb_formatType="rbKey";
	
	property name="minimumOrderQuantity" ormtype="integer" hb_nullRBKey="define.0";
	property name="maximumOrderQuantity" ormtype="integer" hb_nullRBKey="define.unlimited";
	property name="minimumOrderSubtotal" ormtype="big_decimal" hb_formatType="currency" hb_nullRBKey="define.0";
	property name="maximumOrderSubtotal" ormtype="big_decimal" hb_formatType="currency" hb_nullRBKey="define.unlimited";
	property name="minimumItemQuantity" ormtype="integer" hb_nullRBKey="define.0";
	property name="maximumItemQuantity" ormtype="integer" hb_nullRBKey="define.unlimited";
	property name="minimumItemPrice" ormtype="big_decimal" hb_formatType="currency" hb_nullRBKey="define.0";
	property name="maximumItemPrice" ormtype="big_decimal" hb_formatType="currency" hb_nullRBKey="define.unlimited";
	property name="minimumFulfillmentWeight" ormtype="big_decimal" hb_formatType="weight" hb_nullRBKey="define.0";
	property name="maximumFulfillmentWeight" ormtype="big_decimal" hb_formatType="weight" hb_nullRBKey="define.unlimited";
	property name="rewardMatchingType" ormtype="string" hb_formatType="rbKey" hb_formFieldType="select";
	
	// Related Entities (many-to-one)
	property name="promotionPeriod" cfc="PromotionPeriod" fieldtype="many-to-one" fkcolumn="promotionPeriodID";
	
	// Related Entities (one-to-many)
	
	// Related Entities (many-to-many - owner)
	property name="fulfillmentMethods" singularname="fulfillmentMethod" cfc="FulfillmentMethod" fieldtype="many-to-many" linktable="SwPromoQualFulfillmentMethod" fkcolumn="promotionQualifierID" inversejoincolumn="fulfillmentMethodID";
	property name="shippingMethods" singularname="shippingMethod" cfc="ShippingMethod" fieldtype="many-to-many" linktable="SwPromoQualShippingMethod" fkcolumn="promotionQualifierID" inversejoincolumn="shippingMethodID";
	property name="shippingAddressZones" singularname="shippingAddressZone" cfc="AddressZone" fieldtype="many-to-many" linktable="SwPromoQualShipAddressZone" fkcolumn="promotionQualifierID" inversejoincolumn="addressZoneID";
	
	property name="brands" singularname="brand" cfc="Brand" fieldtype="many-to-many" linktable="SwPromoQualBrand" fkcolumn="promotionQualifierID" inversejoincolumn="brandID";
	property name="options" singularname="option" cfc="Option" fieldtype="many-to-many" linktable="SwPromoQualOption" fkcolumn="promotionQualifierID" inversejoincolumn="optionID";
	property name="skus" singularname="sku" cfc="Sku" fieldtype="many-to-many" linktable="SwPromoQualSku" fkcolumn="promotionQualifierID" inversejoincolumn="skuID";
	property name="products" singularname="product" cfc="Product" fieldtype="many-to-many" linktable="SwPromoQualProduct" fkcolumn="promotionQualifierID" inversejoincolumn="productID";
	property name="productTypes" singularname="productType" cfc="ProductType" fieldtype="many-to-many" linktable="SwPromoQualProductType" fkcolumn="promotionQualifierID" inversejoincolumn="productTypeID";
	
	property name="excludedBrands" singularname="excludedBrand" cfc="Brand" type="array" fieldtype="many-to-many" linktable="SwPromoQualExclBrand" fkcolumn="promotionQualifierID" inversejoincolumn="brandID";
	property name="excludedOptions" singularname="excludedOption" cfc="Option" type="array" fieldtype="many-to-many" linktable="SwPromoQualExclOption" fkcolumn="promotionQualifierID" inversejoincolumn="optionID";
	property name="excludedSkus" singularname="excludedSku" cfc="Sku" fieldtype="many-to-many" linktable="SwPromoQualExclSku" fkcolumn="promotionQualifierID" inversejoincolumn="skuID";
	property name="excludedProducts" singularname="excludedProduct" cfc="Product" fieldtype="many-to-many" linktable="SwPromoQualExclProduct" fkcolumn="promotionQualifierID" inversejoincolumn="productID";
	property name="excludedProductTypes" singularname="excludedProductType" cfc="ProductType" fieldtype="many-to-many" linktable="SwPromoQualExclProductType" fkcolumn="promotionQualifierID" inversejoincolumn="productTypeID";
	
	// Remote Properties
	property name="remoteID" ormtype="string";
	
	// Audit Properties
	property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="createdByAccountID" hb_populateEnabled="false" ormtype="string";
	property name="modifiedDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="modifiedByAccountID" hb_populateEnabled="false" ormtype="string";

	// Non-persistent entities
	property name="qualifierApplicationTypeOptions" type="array" persistent="false";
	
	public string function getSimpleRepresentation() {
		return "#rbKey('entity.promotionQualifier')# - #getFormattedValue('qualifierType')#";
	}
	
	// ============ START: Non-Persistent Property Methods =================
	
	public array function getRewardMatchingTypeOptions() {
		return [
			{name=rbKey('entity.promotionQualifier.rewardMatchingType.any'), value="any"},
			{name=rbKey('entity.promotionQualifier.rewardMatchingType.sku'), value="sku"},
			{name=rbKey('entity.promotionQualifier.rewardMatchingType.product'), value="product"},
			{name=rbKey('entity.promotionQualifier.rewardMatchingType.productType'), value="productType"},
			{name=rbKey('entity.promotionQualifier.rewardMatchingType.brand'), value="brand"}
		];
	}
	
	// ============  END:  Non-Persistent Property Methods =================
		
	// ============= START: Bidirectional Helper Methods ===================
	
	// Promotion Period (many-to-one)
	public void function setPromotionPeriod(required any promotionPeriod) {
		variables.promotionPeriod = arguments.promotionPeriod;
		if(isNew() or !arguments.promotionPeriod.hasPromotionQualifier( this )) {
			arrayAppend(arguments.promotionPeriod.getPromotionQualifiers(), this);
		}
	}
	public void function removePromotionPeriod(any promotionPeriod) {
		if(!structKeyExists(arguments, "promotionPeriod")) {
			arguments.promotionPeriod = variables.promotionPeriod;
		}
		var index = arrayFind(arguments.promotionPeriod.getPromotionQualifiers(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.promotionPeriod.getPromotionQualifiers(), index);
		}
		structDelete(variables, "promotionPeriod");
	}
	
	// Brands (many-to-many - owner)
	public void function addBrand(required any brand) {
		if(arguments.brand.isNew() or !hasBrand(arguments.brand)) {
			arrayAppend(variables.brands, arguments.brand);
		}
		if(isNew() or !arguments.brand.hasPromotionQualifier( this )) {
			arrayAppend(arguments.brand.getPromotionQualifiers(), this);
		}
	}
	public void function removeBrand(required any brand) {
		var thisIndex = arrayFind(variables.brands, arguments.brand);
		if(thisIndex > 0) {
			arrayDeleteAt(variables.brands, thisIndex);
		}
		var thatIndex = arrayFind(arguments.brand.getPromotionQualifiers(), this);
		if(thatIndex > 0) {
			arrayDeleteAt(arguments.brand.getPromotionQualifiers(), thatIndex);
		}
	}

	// Options (many-to-many - owner)
	public void function addOption(required any option) {
		if(arguments.option.isNew() or !hasOption(arguments.option)) {
			arrayAppend(variables.options, arguments.option);
		}
		if(isNew() or !arguments.option.hasPromotionQualifier( this )) {
			arrayAppend(arguments.option.getPromotionQualifiers(), this);
		}
	}
	public void function removeOption(required any option) {
		var thisIndex = arrayFind(variables.options, arguments.option);
		if(thisIndex > 0) {
			arrayDeleteAt(variables.options, thisIndex);
		}
		var thatIndex = arrayFind(arguments.option.getPromotionQualifiers(), this);
		if(thatIndex > 0) {
			arrayDeleteAt(arguments.option.getPromotionQualifiers(), thatIndex);
		}
	}
	
	// Skus (many-to-many - owner)    
	public void function addSku(required any sku) {    
		if(arguments.sku.isNew() or !hasSku(arguments.sku)) {    
			arrayAppend(variables.skus, arguments.sku);    
		}    
		if(isNew() or !arguments.sku.hasPromotionQualifier( this )) {    
			arrayAppend(arguments.sku.getPromotionQualifiers(), this);    
		}    
	}    
	public void function removeSku(required any sku) {    
		var thisIndex = arrayFind(variables.skus, arguments.sku);    
		if(thisIndex > 0) {    
			arrayDeleteAt(variables.skus, thisIndex);    
		}    
		var thatIndex = arrayFind(arguments.sku.getPromotionQualifiers(), this);    
		if(thatIndex > 0) {    
			arrayDeleteAt(arguments.sku.getPromotionQualifiers(), thatIndex);    
		}    
	}

	// Products (many-to-many - owner)
	public void function addProduct(required any product) {
		if(arguments.product.isNew() or !hasProduct(arguments.product)) {
			arrayAppend(variables.products, arguments.product);
		}
		if(isNew() or !arguments.product.hasPromotionQualifier( this )) {
			arrayAppend(arguments.product.getPromotionQualifiers(), this);
		}
	}
	public void function removeProduct(required any product) {
		var thisIndex = arrayFind(variables.products, arguments.product);
		if(thisIndex > 0) {
			arrayDeleteAt(variables.products, thisIndex);
		}
		var thatIndex = arrayFind(arguments.product.getPromotionQualifiers(), this);
		if(thatIndex > 0) {
			arrayDeleteAt(arguments.product.getPromotionQualifiers(), thatIndex);
		}
	}
	
	// Product Types (many-to-many - owner)
	public void function addProductType(required any productType) {
		if(arguments.productType.isNew() or !hasProductType(arguments.productType)) {
			arrayAppend(variables.productTypes, arguments.productType);
		}
		if(isNew() or !arguments.productType.hasPromotionQualifier( this )) {
			arrayAppend(arguments.productType.getPromotionQualifiers(), this);
		}
	}
	public void function removeProductType(required any productType) {
		var thisIndex = arrayFind(variables.productTypes, arguments.productType);
		if(thisIndex > 0) {
			arrayDeleteAt(variables.productTypes, thisIndex);
		}
		var thatIndex = arrayFind(arguments.productType.getPromotionQualifiers(), this);
		if(thatIndex > 0) {
			arrayDeleteAt(arguments.productType.getPromotionQualifiers(), thatIndex);
		}
	}
	
	// Excluded Brands (many-to-many - owner)    
	public void function addExcludedBrand(required any brand) {    
		if(arguments.brand.isNew() or !hasExcludedBrand(arguments.brand)) {    
			arrayAppend(variables.excludedBrands, arguments.brand);    
		}    
		if(isNew() or !arguments.brand.hasPromotionQualifierExclusion( this )) {    
			arrayAppend(arguments.brand.getPromotionQualifierExclusions(), this);    
		}    
	}    
	public void function removeExcludedBrand(required any brand) {    
		var thisIndex = arrayFind(variables.excludedBrands, arguments.brand);    
		if(thisIndex > 0) {    
			arrayDeleteAt(variables.excludedBrands, thisIndex);    
		}    
		var thatIndex = arrayFind(arguments.brand.getPromotionQualifierExclusions(), this);    
		if(thatIndex > 0) {    
			arrayDeleteAt(arguments.brand.getPromotionQualifierExclusions(), thatIndex);    
		}    
	}
	
	// Excluded Options (many-to-many - owner)    
	public void function addExcludedOption(required any option) {    
		if(arguments.option.isNew() or !hasExcludedOption(arguments.option)) {    
			arrayAppend(variables.excludedOptions, arguments.option);    
		}    
		if(isNew() or !arguments.option.hasPromotionQualifierExclusion( this )) {    
			arrayAppend(arguments.option.getPromotionQualifierExclusions(), this);    
		}    
	}    
	public void function removeExcludedOption(required any option) {    
		var thisIndex = arrayFind(variables.excludedOptions, arguments.option);    
		if(thisIndex > 0) {    
			arrayDeleteAt(variables.excludedOptions, thisIndex);    
		}    
		var thatIndex = arrayFind(arguments.option.getPromotionQualifierExclusions(), this);    
		if(thatIndex > 0) {    
			arrayDeleteAt(arguments.option.getPromotionQualifierExclusions(), thatIndex);    
		}    
	}
	
	// Excluded Skus (many-to-many - owner)
	public void function addExcludedSku(required any sku) {
		if(arguments.sku.isNew() or !hasExcludedSku(arguments.sku)) {
			arrayAppend(variables.excludedSkus, arguments.sku);
		}
		if(isNew() or !arguments.sku.hasPromotionQualifierExclusion( this )) {
			arrayAppend(arguments.sku.getPromotionQualifierExclusions(), this);
		}
	}
	public void function removeExcludedSku(required any sku) {
		var thisIndex = arrayFind(variables.excludedSkus, arguments.sku);
		if(thisIndex > 0) {
			arrayDeleteAt(variables.excludedSkus, thisIndex);
		}
		var thatIndex = arrayFind(arguments.sku.getPromotionQualifierExclusions(), this);
		if(thatIndex > 0) {
			arrayDeleteAt(arguments.sku.getPromotionQualifierExclusions(), thatIndex);
		}
	}
	
	// Excluded Products (many-to-many - owner)
	public void function addExcludedProduct(required any product) {
		if(arguments.product.isNew() or !hasExcludedProduct(arguments.product)) {
			arrayAppend(variables.excludedProducts, arguments.product);
		}
		if(isNew() or !arguments.product.hasPromotionQualifierExclusion( this )) {
			arrayAppend(arguments.product.getPromotionQualifierExclusions(), this);
		}
	}
	public void function removeExcludedProduct(required any product) {
		var thisIndex = arrayFind(variables.excludedProducts, arguments.product);
		if(thisIndex > 0) {
			arrayDeleteAt(variables.excludedProducts, thisIndex);
		}
		var thatIndex = arrayFind(arguments.product.getPromotionQualifierExclusions(), this);
		if(thatIndex > 0) {
			arrayDeleteAt(arguments.product.getPromotionQualifierExclusions(), thatIndex);
		}
	}

	// Excluded Product Types (many-to-many - owner)
	public void function addExcludedProductType(required any productType) {
		if(arguments.productType.isNew() or !hasExcludedProductType(arguments.productType)) {
			arrayAppend(variables.excludedProductTypes, arguments.productType);
		}
		if(isNew() or !arguments.productType.hasPromotionQualifierExclusion( this )) {
			arrayAppend(arguments.productType.getPromotionQualifierExclusions(), this);
		}
	}
	public void function removeExcludedProductType(required any productType) {
		var thisIndex = arrayFind(variables.excludedProductTypes, arguments.productType);
		if(thisIndex > 0) {
			arrayDeleteAt(variables.excludedProductTypes, thisIndex);
		}
		var thatIndex = arrayFind(arguments.productType.getPromotionQualifierExclusions(), this);
		if(thatIndex > 0) {
			arrayDeleteAt(arguments.productType.getPromotionQualifierExclusions(), thatIndex);
		}
	}
	
	// =============  END:  Bidirectional Helper Methods ===================

	// =============== START: Custom Validation Methods ====================
	
	// ===============  END: Custom Validation Methods =====================
	
	// =============== START: Custom Formatting Methods ====================
	
	// ===============  END: Custom Formatting Methods =====================
	
	// ============== START: Overridden Implicet Getters ===================
	
	// ==============  END: Overridden Implicet Getters ====================

	// ================== START: Overridden Methods ========================
	
	public string function getSimpleRepresentationPropertyName() {
		return "qualifierType";
	}
	
	public boolean function isDeletable() {
		return !getPromotionPeriod().isExpired() && getPromotionPeriod().getPromotion().isDeletable();
	}
	
	// ==================  END:  Overridden Methods ========================
	
	// =================== START: ORM Event Hooks  =========================
	
	// ===================  END:  ORM Event Hooks  =========================
	
	// ================== START: Deprecated Methods ========================
	
	// ==================  END:  Deprecated Methods ========================
	
}
