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
component displayname="Brand" entityname="SlatwallBrand" table="SwBrand" persistent=true output=false accessors=true extends="HibachiEntity" cacheuse="transactional" hb_serviceName="brandService" hb_permission="this" {
	
	// Persistent Properties
	property name="brandID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="activeFlag" ormtype="boolean" hint="As Brands Get Old, They would be marked as Not Active";
	property name="publishedFlag" ormtype="boolean";
	property name="urlTitle" ormtype="string" unique="true" hint="This is the name that is used in the URL string";
	property name="brandName" ormtype="string" hint="This is the common name that the brand goes by.";
	property name="brandWebsite" ormtype="string" hint="This is the Website of the brand";
	
	// Related Object Properties (one-to-many)
	property name="attributeValues" singularname="attributeValue" cfc="AttributeValue" type="array" fieldtype="one-to-many" fkcolumn="brandID" cascade="all-delete-orphan" inverse="true";
	property name="products" singularname="product" cfc="Product" type="array" fieldtype="one-to-many" fkcolumn="brandID" inverse="true";
	
	// Related Object Properties (many-to-many - owner)
	
	// Related Object Properties (many-to-many - inverse)
	property name="promotionRewards" hb_populateEnabled="false" singularname="promotionReward" cfc="PromotionReward" fieldtype="many-to-many" linktable="SwPromoRewardBrand" fkcolumn="brandID" inversejoincolumn="promotionRewardID" inverse="true";
	property name="promotionRewardExclusions" hb_populateEnabled="false" singularname="promotionRewardExclusion" cfc="PromotionReward" type="array" fieldtype="many-to-many" linktable="SwPromoRewardExclBrand" fkcolumn="brandID" inversejoincolumn="promotionRewardID" inverse="true";
	property name="loyaltyAccruements" hb_populateEnabled="false" singularname="loyaltyAccruement" cfc="LoyaltyAccruement" fieldtype="many-to-many" linktable="SwLoyaltyAccruBrand" fkcolumn="brandID" inversejoincolumn="loyaltyAccruementID" inverse="true";
	property name="loyaltyAccruementExclusions" hb_populateEnabled="false" singularname="loyaltyAccruementExclusion" cfc="LoyaltyAccruement" type="array" fieldtype="many-to-many" linktable="SwLoyaltyAccruExclBrand" fkcolumn="brandID" inversejoincolumn="loyaltyAccruementID" inverse="true";
	property name="loyaltyRedemptions" singularname="loyaltyredemption" cfc="LoyaltyRedemption" type="array" fieldtype="many-to-many" linktable="SwLoyaltyRedemptionBrand" fkcolumn="brandID" inversejoincolumn="loyaltyRedemptionID" inverse="true";
	property name="loyaltyRedemptionExclusions" singularname="loyaltyRedemptionExclusion" cfc="LoyaltyRedemption" type="array" fieldtype="many-to-many" linktable="SwLoyaltyRedemptionExclBrand" fkcolumn="brandID" inversejoincolumn="loyaltyRedemptionID" inverse="true";
	property name="promotionQualifiers" hb_populateEnabled="false" singularname="promotionQualifier" cfc="PromotionQualifier" fieldtype="many-to-many" linktable="SwPromoQualBrand" fkcolumn="brandID" inversejoincolumn="promotionQualifierID" inverse="true";
	property name="promotionQualifierExclusions" hb_populateEnabled="false" singularname="promotionQualifierExclusion" cfc="PromotionQualifier" type="array" fieldtype="many-to-many" linktable="SwPromoQualExclBrand" fkcolumn="brandID" inversejoincolumn="promotionQualifierID" inverse="true";
	property name="vendors" singularname="vendor" cfc="Vendor" fieldtype="many-to-many" linktable="SwVendorBrand" fkcolumn="brandID" inversejoincolumn="vendorID" inverse="true";
	property name="physicals" hb_populateEnabled="false" singularname="physical" cfc="Physical" type="array" fieldtype="many-to-many" linktable="SwPhysicalBrand" fkcolumn="brandID" inversejoincolumn="physicalID" inverse="true";
	
	// Remote properties
	property name="remoteID" ormtype="string";
	
	// Audit Properties
	property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="createdByAccountID" hb_populateEnabled="false" ormtype="string";
	property name="modifiedDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="modifiedByAccountID" hb_populateEnabled="false" ormtype="string";
	
	
	// ============ START: Non-Persistent Property Methods =================
	
	// ============  END:  Non-Persistent Property Methods =================
	
	// ============= START: Bidirectional Helper Methods ===================
	
	// Attribute Values (one-to-many)    
	public void function addAttributeValue(required any attributeValue) {    
		arguments.attributeValue.setBrand( this );    
	}    
	public void function removeAttributeValue(required any attributeValue) {    
		arguments.attributeValue.removeBrand( this );    
	}
	
	// Products (one-to-many)
	public void function addProduct(required any product) {
	   arguments.product.setBrand(this);
	}
	public void function removeProduct(required any product) {
	   arguments.Product.removeBrand(this);
	}
	
	// Promotion Rewards (many-to-many - inverse)
	public void function addPromotionReward(required any promotionReward) {
	   arguments.promotionReward.addBrand(this);
	}
	
	public void function removePromotionReward(required any promotionReward) {
	   arguments.promotionReward.removeBrand(this);
	}
	
	// Promotion Reward Exclusions (many-to-many - inverse)    
	public void function addPromotionRewardExclusion(required any promotionReward) {    
		arguments.promotionReward.addExcludedBrand( this );    
	}
	public void function removePromotionRewardExclusion(required any promotionReward) {    
		arguments.promotionReward.removeExcludedBrand( this );    
	}
	
	// Promotion Qualifiers (many-to-many - inverse)
	public void function addPromotionQualifier(required any promotionQualifier) {
		arguments.promotionQualifier.addBrand( this );
	}
	
	public void function removePromotionQualifier(required any promotionQualifier) {
		arguments.promotionQualifier.removeBrand( this );
	}
	
	// Promotion Qualifier Exclusions (many-to-many - inverse)    
	public void function addPromotionQualifierExclusion(required any promotionQualifier) {    
		arguments.promotionQualifier.addExcludedBrand( this );    
	}    
	public void function removePromotionQualifierExclusion(required any promotionQualifier) {    
		arguments.promotionQualifier.removeExcludedBrand( this );    
	}
	
	// Vendors (many-to-many - inverse)    
	public void function addVendor(required any vendor) {    
		arguments.vendor.addBrand( this );    
	}    
	public void function removeVendor(required any vendor) {    
		arguments.vendor.removeBrand( this );    
	}
	
	// Physicals (many-to-many - inverse)
	public void function addPhysical(required any physical) {
		arguments.physical.addBrand( this );
	}
	public void function removePhysical(required any physical) {
		arguments.physical.removeBrand( this );
	}
	
	// Loyalty Accruements (many-to-many - inverse)
	public void function addLoyaltyAccruement(required any loyaltyAccruement) {
		arguments.loyaltyAccruement.addBrand( this );
	}
	public void function removeloyaltyAccruement(required any loyaltyAccruement) {
		arguments.loyaltyAccruement.removeBrand( this );
	}
	
	// Loyalty Accruement Exclusions (many-to-many - inverse)
	public void function addLoyaltyAccruementExclusion(required any loyaltyAccruementExclusion) {
		arguments.loyaltyAccruementExclusion.addBrand( this );
	}
	public void function removeloyaltyAccruementExclusion(required any loyaltyAccruementExclusion) {
		arguments.loyaltyAccruementExclusion.removeBrand( this );
	}
	
	// Loyalty Redemptions (many-to-many - inverse)    
	public void function addLoyaltyRedemption(required any loyaltyRedemption) {    
		arguments.loyaltyRedemption.addBrand( this );    
	}    
	public void function removeLoyaltyRedemption(required any loyaltyRedemption) {    
		arguments.loyaltyRedemption.removeBrand( this );    
	}
	
	// Loyalty Redemption Exclusions (many-to-many - inverse)
	public void function addLoyaltyRedemptionExclusion(required any loyaltyRedemptionExclusion) {
		arguments.loyaltyRedemptionExclusion.addbrand( this );
	}
	public void function removeLoyaltyRedemptionExclusion(required any loyaltyRedemptionExclusion) {
		arguments.loyaltyRedemptionExclusion.removebrand( this );
	}
	
	// =============  END:  Bidirectional Helper Methods ===================
	
	// ================== START: Overridden Methods ========================
	
	// ==================  END:  Overridden Methods ========================
		
	// =================== START: ORM Event Hooks  =========================
	
	// ===================  END:  ORM Event Hooks  =========================
}

