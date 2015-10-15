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
component displayname="Option" entityname="SlatwallOption" table="SwOption" persistent=true output=false accessors=true extends="HibachiEntity" cacheuse="transactional" hb_serviceName="optionService" hb_permission="optionGroup.options" {
	
	// Persistent Properties
	property name="optionID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="optionCode" ormtype="string" index="PI_OPTIONCODE";
	property name="optionName" ormtype="string";
	property name="optionDescription" ormtype="string" length="4000" hb_formFieldType="wysiwyg";
	property name="sortOrder" ormtype="integer" sortContext="optionGroup";
	
	// Related Object Properties (many-to-one)
	property name="optionGroup" cfc="OptionGroup" fieldtype="many-to-one" fkcolumn="optionGroupID";
	property name="defaultImage" cfc="Image" fieldtype="many-to-one" fkcolumn="defaultImageID";
	
	// Related Object Properties (one-to-many)
	property name="images" singularname="image" cfc="Image" type="array" fieldtype="one-to-many" fkcolumn="optionID" cascade="all-delete-orphan" inverse="true";
	
	// Related Object Properties (many-to-many - inverse)
	property name="skus" singularname="sku" cfc="Sku" fieldtype="many-to-many" linktable="SwSkuOption" fkcolumn="optionID" inversejoincolumn="skuID" inverse="true"; 
	property name="promotionRewards" singularname="promotionReward" cfc="PromotionReward" fieldtype="many-to-many" linktable="SwPromoRewardOption" fkcolumn="optionID" inversejoincolumn="promotionRewardID" inverse="true";
	property name="promotionRewardExclusions" singularname="promotionRewardExclusion" cfc="PromotionReward" type="array" fieldtype="many-to-many" linktable="SwPromoRewardExclOption" fkcolumn="optionID" inversejoincolumn="promotionRewardID" inverse="true";
	property name="promotionQualifiers" singularname="promotionQualifier" cfc="PromotionQualifier" fieldtype="many-to-many" linktable="SwPromoQualOption" fkcolumn="optionID" inversejoincolumn="promotionQualifierID" inverse="true";
	property name="promotionQualifierExclusions" singularname="promotionQualifierExclusion" cfc="PromotionQualifier" type="array" fieldtype="many-to-many" linktable="SwPromoQualExclOption" fkcolumn="optionID" inversejoincolumn="promotionQualifierID" inverse="true";
	property name="productImages" singularname="productImage" cfc="Image" fieldtype="many-to-many" linktable="SwImageOption" fkcolumn="optionID" inversejoincolumn="imageID" inverse="true" lazy="extra"; 
	
	// Remote properties
	property name="remoteID" ormtype="string";
	
	// Audit Properties
	property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="createdByAccountID" hb_populateEnabled="false" ormtype="string";
	property name="modifiedDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="modifiedByAccountID" hb_populateEnabled="false" ormtype="string";
	   
    public string function getImageDirectory() {
    	return getURLFromPath(setting('globalAssetsImageFolderPath')) & '/option/';
    }
    
    // ============ START: Non-Persistent Property Methods =================
	
	// ============  END:  Non-Persistent Property Methods =================
	
	// ============= START: Bidirectional Helper Methods ===================
	
	// Option Group (many-to-one)
	public void function setOptionGroup(required any optionGroup) {
		variables.optionGroup = arguments.optionGroup;
		if(isNew() or !arguments.optionGroup.hasOption( this )) {
			arrayAppend(arguments.optionGroup.getOptions(), this);
		}
	}
	public void function removeOptionGroup(any optionGroup) {
		if(!structKeyExists(arguments, "optionGroup")) {
			arguments.optionGroup = variables.optionGroup;
		}
		var index = arrayFind(arguments.optionGroup.getOptions(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.optionGroup.getOptions(), index);
		}
		structDelete(variables, "optionGroup");
	}
	
	// Skus (many-to-many - inverse)
	public void function addSku(required any sku) {
		arguments.sku.addOption( this );
	}
	public void function removeSku(required any sku) {
		arguments.sku.removeOption( this );
	}
	
	// Promotion Rewards (many-to-many - inverse)
	public void function addPromotionReward(required any promotionReward) {
		arguments.promotionReward.addOption( this );
	}
	public void function removePromotionReward(required any promotionReward) {
		arguments.promotionReward.removeOption( this );
	}
	
	// Promotion Reward Exclusions (many-to-many - inverse)    
	public void function addPromotionRewardExclusion(required any promotionReward) {    
		arguments.promotionReward.addExcludedOption( this );    
	}
	public void function removePromotionRewardExclusion(required any promotionReward) {    
		arguments.promotionReward.addExcludedOption( this );    
	}
	
	// Promotion Qualifiers (many-to-many - inverse)
	public void function addPromotionQualifier(required any promotionQualifier) {
		arguments.promotionQualifier.addOption( this );
	}
	public void function removePromotionQualifier(required any promotionQualifier) {
		arguments.promotionQualifier.removeOption( this );
	}	
	
	// Promotion Qualifier Exclusions (many-to-many - inverse)    
	public void function addPromotionQualifierExclusion(required any promotionQualifier) {    
		arguments.promotionQualifier.addExcludedOption( this );    
	}
	public void function removePromotionQualifierExclusion(required any promotionQualifier) {    
		arguments.promotionQualifier.addExcludedOption( this );    
	}
	
	// =============  END:  Bidirectional Helper Methods ===================
	
	// ================== START: Overridden Methods ========================
	
	// ==================  END:  Overridden Methods ========================
		
	// =================== START: ORM Event Hooks  =========================
	
	// ===================  END:  ORM Event Hooks  =========================

}

