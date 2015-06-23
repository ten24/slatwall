/*

    Slatwall - An e-commerce plugin for Mura CMS
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

*/
component displayname="LoyaltyAccruement" entityname="SlatwallLoyaltyAccruement" table="SwLoyaltyAccru" persistent="true"  extends="HibachiEntity" cacheuse="transactional" hb_serviceName="loyaltyService" hb_permission="this" {
	
	// Persistent Properties
	property name="loyaltyAccruementID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="startDateTime" ormtype="timestamp" hb_nullRBKey="define.forever";
	property name="endDateTime" ormtype="timestamp" hb_nullRBKey="define.forever";
	property name="accruementType" ormType="string" hb_formatType="rbKey" hb_formFieldType="select";
	property name="pointType" ormType="string" hb_formatType="rbKey" hb_formFieldType="select";
	property name="pointQuantity" ormType="integer";
	property name="activeFlag" ormtype="boolean" default="1";
	property name="currencyCode" ormtype="string" length="3";
	
	// Related Object Properties (many-to-one)
	property name="loyalty" cfc="Loyalty" fieldtype="many-to-one" fkcolumn="loyaltyID";
	property name="expirationTerm" cfc="Term" fieldtype="many-to-one" fkcolumn="expirationTermID" hb_optionsNullRBKey="define.never";
	
	// Related Object Properties (one-to-many)
	property name="accountLoyaltyTransactions" singularname="accountLoyaltyTransaction" cfc="AccountLoyaltyTransaction" type="array" fieldtype="one-to-many" fkcolumn="loyaltyAccruementID" cascade="all-delete-orphan" inverse="true";
	
	// Related Object Properties (many-to-many - owner)
	property name="brands" singularname="brand" cfc="Brand" fieldtype="many-to-many" linktable="SwLoyaltyAccruBrand" fkcolumn="loyaltyAccruementID" inversejoincolumn="brandID";
	property name="skus" singularname="sku" cfc="Sku" fieldtype="many-to-many" linktable="SwLoyaltyAccruSku" fkcolumn="loyaltyAccruementID" inversejoincolumn="skuID";
	property name="products" singularname="product" cfc="Product" fieldtype="many-to-many" linktable="SwLoyaltyAccruProduct" fkcolumn="loyaltyAccruementID" inversejoincolumn="productID";
	property name="productTypes" singularname="productType" cfc="ProductType" fieldtype="many-to-many" linktable="SwLoyaltyAccruProductType" fkcolumn="loyaltyAccruementID" inversejoincolumn="productTypeID";
	
	property name="excludedBrands" singularname="excludedBrand" cfc="Brand" type="array" fieldtype="many-to-many" linktable="SwLoyaltyAccruExclBrand" fkcolumn="loyaltyAccruementID" inversejoincolumn="brandID";
	property name="excludedSkus" singularname="excludedSku" cfc="Sku" fieldtype="many-to-many" linktable="SwLoyaltyAccruExclSku" fkcolumn="loyaltyAccruementID" inversejoincolumn="skuID";
	property name="excludedProducts" singularname="excludedProduct" cfc="Product" fieldtype="many-to-many" linktable="SwLoyaltyAccruExclProduct" fkcolumn="loyaltyAccruementID" inversejoincolumn="productID";
	property name="excludedProductTypes" singularname="excludedProductType" cfc="ProductType" fieldtype="many-to-many" linktable="SwLoyaltyAccruExclProductType" fkcolumn="loyaltyAccruementID" inversejoincolumn="productTypeID";
	
	// Remote Properties
	property name="remoteID" ormtype="string";
	
	// Audit Properties
	property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="createdByAccountID" hb_populateEnabled="false" ormtype="string";
	property name="modifiedDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="modifiedByAccountID" hb_populateEnabled="false" ormtype="string";
	
	// Non-Persistent Properties


	public string function getSimpleRepresentation() {
		return getLoyalty().getLoyaltyName() & " - " & getAccruementType();
	}
	
	// ============ START: Non-Persistent Property Methods =================
	
	public array function getAccruementTypeOptions() {
		return [
			{name=rbKey('entity.loyaltyAccruement.accruementType.itemFulfilled'), value="itemFulfilled"},
			{name=rbKey('entity.loyaltyAccruement.accruementType.orderClosed'), value="orderClosed"},
			{name=rbKey('entity.loyaltyAccruement.accruementType.fulfillmentMethodUsed'), value="fulfillmentMethodUsed"},
			{name=rbKey('entity.loyaltyAccruement.accruementType.enrollment'), value="enrollment"}
		];
	}
	
	public array function getPointTypeOptions() {
		return [
			{name=rbKey('entity.loyaltyAccruement.pointType.fixed'), value="fixed"},
			{name=rbKey('entity.loyaltyAccruement.pointType.pointPerDollar'), value="pointPerDollar"}
		];
	}
	
	// ============  END:  Non-Persistent Property Methods =================
		
	// ============= START: Bidirectional Helper Methods ===================
	
	// Account Loyalty Program Transaction (one-to-many)
	public void function addAccountLoyaltyTransaction(required any accountLoyaltyTransaction) {
		arguments.accountLoyaltyTransaction.setLoyaltyAccruement( this );
	}
	public void function removeAccountLoyaltyTransaction(required any accountLoyaltyTransaction) {
		arguments.accountLoyaltyTransaction.removeLoyaltyAccruement( this );
	}
	
	
	// loyalty Program (many-to-one)
	public void function setLoyalty(required any loyalty) {
		variables.loyalty = arguments.loyalty;
		if(isNew() or !arguments.loyalty.hasLoyaltyAccruement( this )) {
			arrayAppend(arguments.loyalty.getLoyaltyAccruements(), this);
		}
	}
	public void function removeLoyalty(any loyalty) {
		if(!structKeyExists(arguments, "loyalty")) {
			arguments.loyalty = variables.loyalty;
		}
		var index = arrayFind(arguments.loyalty.getLoyaltyAccruements(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.loyalty.getLoyaltyAccruements(), index);
		}
		structDelete(variables, "loyalty");
	}
	
	// Brands (many-to-many - owner)
	public void function addBrand(required any brand) {
		if(arguments.brand.isNew() or !hasBrand(arguments.brand)) {
			arrayAppend(variables.brands, arguments.brand);
		}
		if(isNew() or !arguments.brand.hasLoyaltyAccruement( this )) {
			arrayAppend(arguments.brand.getLoyaltyAccruements(), this);
		}
	}
	public void function removeBrand(required any brand) {
		var thisIndex = arrayFind(variables.brands, arguments.brand);
		if(thisIndex > 0) {
			arrayDeleteAt(variables.brands, thisIndex);
		}
		var thatIndex = arrayFind(arguments.brand.getLoyaltyAccruements(), this);
		if(thatIndex > 0) {
			arrayDeleteAt(arguments.brand.getLoyaltyAccruements(), thatIndex);
		}
	}
	
	// Skus (many-to-many - owner)    
	public void function addSku(required any sku) {    
		if(arguments.sku.isNew() or !hasSku(arguments.sku)) {    
			arrayAppend(variables.skus, arguments.sku);    
		}
		if(isNew() or !arguments.sku.hasLoyaltyAccruement( this )) {
			arrayAppend(arguments.sku.getLoyaltyAccruements(), this);
		}   
	}    
	public void function removeSku(required any sku) {    
		var thisIndex = arrayFind(variables.skus, arguments.sku);    
		if(thisIndex > 0) {    
			arrayDeleteAt(variables.skus, thisIndex);    
		}
		var thatIndex = arrayFind(arguments.sku.getLoyaltyAccruements(), this);
		if(thatIndex > 0) {
			arrayDeleteAt(arguments.sku.getLoyaltyAccruements(), thatIndex);
		}   
	}

	// Products (many-to-many - owner)
	public void function addProduct(required any product) {
		if(arguments.product.isNew() or !hasProduct(arguments.product)) {
			arrayAppend(variables.products, arguments.product);
		}
		if(isNew() or !arguments.product.hasLoyaltyAccruement( this )) {
			arrayAppend(arguments.product.getLoyaltyAccruements(), this);
		} 
	}
	public void function removeProduct(required any product) {
		var thisIndex = arrayFind(variables.products, arguments.product);
		if(thisIndex > 0) {
			arrayDeleteAt(variables.products, thisIndex);
		}
		var thatIndex = arrayFind(arguments.product.getLoyaltyAccruements(), this);
		if(thatIndex > 0) {
			arrayDeleteAt(arguments.product.getLoyaltyAccruements(), thatIndex);
		} 
	}
	
	// Product Types (many-to-many - owner)
	public void function addProductType(required any productType) {
		if(arguments.productType.isNew() or !hasProductType(arguments.productType)) {
			arrayAppend(variables.productTypes, arguments.productType);
		}
		if(isNew() or !arguments.productType.hasLoyaltyAccruement( this )) {
			arrayAppend(arguments.productType.getLoyaltyAccruements(), this);
		} 
	}
	public void function removeProductType(required any productType) {
		var thisIndex = arrayFind(variables.productTypes, arguments.productType);
		if(thisIndex > 0) {
			arrayDeleteAt(variables.productTypes, thisIndex);
		}
		var thatIndex = arrayFind(arguments.productType.getLoyaltyAccruements(), this);
		if(thatIndex > 0) {
			arrayDeleteAt(arguments.productType.getLoyaltyAccruements(), thatIndex);
		}
	}
	
	// Excluded Brands (many-to-many - owner)    
	public void function addExcludedBrand(required any brand) {    
		if(arguments.brand.isNew() or !hasExcludedBrand(arguments.brand)) {    
			arrayAppend(variables.excludedBrands, arguments.brand);    
		}
		if(isNew() or !arguments.brand.hasLoyaltyAccruementExclusion( this )) {    
			arrayAppend(arguments.brand.getLoyaltyAccruementExclusions(), this);    
		}  
	}    
	public void function removeExcludedBrand(required any brand) {    
		var thisIndex = arrayFind(variables.excludedBrands, arguments.brand);    
		if(thisIndex > 0) {    
			arrayDeleteAt(variables.excludedBrands, thisIndex);    
		}
		var thatIndex = arrayFind(arguments.brand.getLoyaltyAccruementExclusions(), this);    
		if(thatIndex > 0) {    
			arrayDeleteAt(arguments.brand.getLoyaltyAccruementExclusions(), thatIndex);    
		}    
	}
	
	// Excluded Skus (many-to-many - owner)
	public void function addExcludedSku(required any sku) {
		if(arguments.sku.isNew() or !hasExcludedSku(arguments.sku)) {
			arrayAppend(variables.excludedSkus, arguments.sku);
		}
		if(isNew() or !arguments.sku.hasLoyaltyAccruementExclusion( this )) {    
			arrayAppend(arguments.sku.getLoyaltyAccruementExclusions(), this);    
		}
	}
	public void function removeExcludedSku(required any sku) {
		var thisIndex = arrayFind(variables.excludedSkus, arguments.sku);
		if(thisIndex > 0) {
			arrayDeleteAt(variables.excludedSkus, thisIndex);
		}
		var thatIndex = arrayFind(arguments.sku.getLoyaltyAccruementExclusions(), this);    
		if(thatIndex > 0) {    
			arrayDeleteAt(arguments.sku.getLoyaltyAccruementExclusions(), thatIndex);    
		}  
	}
	
	// Excluded Products (many-to-many - owner)
	public void function addExcludedProduct(required any product) {
		if(arguments.product.isNew() or !hasExcludedProduct(arguments.product)) {
			arrayAppend(variables.excludedProducts, arguments.product);
		}
		if(isNew() or !arguments.product.hasLoyaltyAccruementExclusion( this )) {    
			arrayAppend(arguments.product.getLoyaltyAccruementExclusions(), this);    
		}
	}
	public void function removeExcludedProduct(required any product) {
		var thisIndex = arrayFind(variables.excludedProducts, arguments.product);
		if(thisIndex > 0) {
			arrayDeleteAt(variables.excludedProducts, thisIndex);
		}
		var thatIndex = arrayFind(arguments.product.getLoyaltyAccruementExclusions(), this);    
		if(thatIndex > 0) {    
			arrayDeleteAt(arguments.product.getLoyaltyAccruementExclusions(), thatIndex);    
		}
	}

	// Excluded Product Types (many-to-many - owner)
	public void function addExcludedProductType(required any productType) {
		if(arguments.productType.isNew() or !hasExcludedProductType(arguments.productType)) {
			arrayAppend(variables.excludedProductTypes, arguments.productType);
		}
		if(isNew() or !arguments.productType.hasLoyaltyAccruementExclusion( this )) {    
			arrayAppend(arguments.productType.getLoyaltyAccruementExclusions(), this);    
		}
	}
	public void function removeExcludedProductType(required any productType) {
		var thisIndex = arrayFind(variables.excludedProductTypes, arguments.productType);
		if(thisIndex > 0) {
			arrayDeleteAt(variables.excludedProductTypes, thisIndex);
		}
		var thatIndex = arrayFind(arguments.productType.getLoyaltyAccruementExclusions(), this);    
		if(thatIndex > 0) {    
			arrayDeleteAt(arguments.productType.getLoyaltyAccruementExclusions(), thatIndex);    
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
	
	// ==================  END:  Overridden Methods ========================
	
	// =================== START: ORM Event Hooks  =========================
	
	// ===================  END:  ORM Event Hooks  =========================
	
	// ================== START: Deprecated Methods ========================
	
	// ==================  END:  Deprecated Methods ========================
}
