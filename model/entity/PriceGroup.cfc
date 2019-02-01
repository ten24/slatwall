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
component displayname="Price Group" entityname="SlatwallPriceGroup" table="SwPriceGroup" persistent=true output=false accessors=true extends="HibachiEntity" cacheuse="transactional" hb_serviceName="priceGroupService" hb_permission="this" {
	
	// Persistent Properties
	property name="priceGroupID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="priceGroupIDPath" ormtype="string" length="4000";
	property name="activeFlag" ormtype="boolean";
	property name="priceGroupName" ormtype="string";
	property name="priceGroupCode" ormtype="string" index="PI_PRICEGROUPCODE";
	
	// Remote properties
	property name="remoteID" ormtype="string";
	
	// Related Object Properties (Many-To-One)
	property name="parentPriceGroup" cfc="PriceGroup" fieldtype="many-to-one" fkcolumn="parentPriceGroupID" hb_optionsNullRBKey="define.none";
	
	// Related Object Properties (One-To-Many)
	property name="appliedOrderItems" singularname="appliedOrderItem" cfc="OrderItem" type="array" fieldtype="one-to-many" fkcolumn="appliedPriceGroupID" inverse="true";
	property name="childPriceGroups" singularname="ChildPriceGroup" cfc="PriceGroup" fieldtype="one-to-many" fkcolumn="parentPriceGroupID" inverse="true";
	property name="priceGroupRates" singularname="priceGroupRate" cfc="PriceGroupRate" fieldtype="one-to-many" fkcolumn="priceGroupID" cascade="all-delete-orphan" inverse="true";
	property name="loyaltyRedemptions" singularname="loyaltyRedemption" cfc="LoyaltyRedemption" type="array" fieldtype="one-to-many" fkcolumn="priceGroupID" cascade="all-delete-orphan" inverse="true";    
	
	// Related Object Properties (many-to-many - invers)
	property name="accounts" singularname="account" cfc="Account" fieldtype="many-to-many" linktable="SwAccountPriceGroup" fkcolumn="priceGroupID" inversejoincolumn="accountID" inverse="true";
	property name="subscriptionBenefits" singularname="subscriptionBenefit" cfc="SubscriptionBenefit" type="array" fieldtype="many-to-many" linktable="SwSubsBenefitPriceGroup" fkcolumn="priceGroupID" inversejoincolumn="subscriptionBenefitID" inverse="true";
	property name="subscriptionUsageBenefits" singularname="subscriptionUsageBenefit" cfc="SubscriptionUsageBenefit" type="array" fieldtype="many-to-many" linktable="SwSubsUsageBenefitPriceGroup" fkcolumn="priceGroupID" inversejoincolumn="subscriptionUsageBenefitID" inverse="true";
	property name="shippingMethodRates" singularname="shippingMethodRate" cfc="ShippingMethodRate" type="array" fieldtype="many-to-many" linktable="SwShippingMethodRatePriceGroup" fkcolumn="priceGroupID" inversejoincolumn="shippingMethodRateID" inverse="true";
	property name="promotionRewards" singularname="promotionReward" cfc="PromotionReward" type="array" fieldtype="many-to-many" linktable="SwPromoRewardEligiblePriceGrp" fkcolumn="priceGroupID" inversejoincolumn="promotionRewardID" inverse="true";

	// Audit Properties
	property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="createdByAccountID" hb_populateEnabled="false" ormtype="string";
	property name="modifiedDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="modifiedByAccountID" hb_populateEnabled="false" ormtype="string";
	
	// Non-Persistent Properties
	property name="parentPriceGroupOptions" persistent="false";
	
	
	// Loop over all Price Group Rates and pull the one that is global
    public any function getGlobalPriceGroupRate() {
    	var rates = getPriceGroupRates();
    	for(var i=1; i <= ArrayLen(rates); i++) {
    		if(rates[i].getGlobalFlag()) {
    			return rates[i];
    		}
    	}	
    }
    
	// ============ START: Non-Persistent Property Methods =================
	
	public any function getParentPriceGroupOptions() {
		var options = getPropertyOptions("parentPriceGroup");
		for(var i=1; i<=arrayLen(options); i++) {
			if(len(options[i]['value']) && options[i]['value'] == getPriceGroupID()) {
				arrayDeleteAt(options, i);
				break;
			}
		}
		return options;
	}
	
	// ============  END:  Non-Persistent Property Methods =================
		
	// ============= START: Bidirectional Helper Methods ===================
	
	// Parent Price Group (many-to-one)
	public void function setParentPriceGroup(required any parentPriceGroup) {
		variables.parentPriceGroup = arguments.parentPriceGroup;
		if(isNew() or !arguments.parentPriceGroup.hasChildPriceGroup( this )) {
			arrayAppend(arguments.parentPriceGroup.getChildPriceGroups(), this);
		}
	}
	public void function removeParentPriceGroup(any parentPriceGroup) {
		if(!structKeyExists(arguments, "parentPriceGroup")) {
			arguments.parentPriceGroup = variables.parentPriceGroup;
		}
		var index = arrayFind(arguments.parentPriceGroup.getChildPriceGroups(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.parentPriceGroup.getChildPriceGroups(), index);
		}
		structDelete(variables, "parentPriceGroup");
	}
	
	// Applied Order Items (one-to-many)    
	public void function addAppliedOrderItem(required any appliedOrderItem) {    
		arguments.appliedOrderItem.setAppliedPriceGroup( this );    
	}    
	public void function removeAppliedOrderItem(required any appliedOrderItem) {    
		arguments.appliedOrderItem.removeAppliedPriceGroup( this );    
	}
	
	// Child Price Groups (one-to-many)    
	public void function addChildPriceGroup(required any childPriceGroup) {    
		arguments.childPriceGroup.setParentPriceGroup( this );    
	}    
	public void function removeChildPriceGroup(required any childPriceGroup) {    
		arguments.childPriceGroup.removeParentPriceGroup( this );    
	}
	
	// Price Group Rates (one-to-many)
	public void function addPriceGroupRate(required any priceGroupRate) {
		arguments.priceGroupRate.setPriceGroup( this );
	}
	public void function removePriceGroupRate(required any priceGroupRate) {
		arguments.priceGroupRate.removePriceGroup( this );
	}
	
	// Loyalty Redemptions (one-to-many)
	public void function addLoyaltyRedemption(required any loyaltyRedemption) {
		arguments.loyaltyRedemption.setPriceGroup( this );
	}
	public void function removeLoyaltyRedemption(required any loyaltyRedemption) {
		arguments.loyaltyRedemption.removePriceGroup( this );
	}	
	
	// Accounts (many-to-many - inverse)
	public void function addAccount(required any account) {
		arguments.account.addPriceGroup( this );
	}
	public void function removeAccount(required any account) {
		arguments.account.removePriceGroup( this );
	}
	
	// Subscription Benefits (many-to-many - inverse)
	public void function addSubscriptionBenefit(required any subscriptionBenefit) {
		arguments.subscriptionBenefit.addPriceGroup( this );
	}
	public void function removeSubscriptionBenefit(required any subscriptionBenefit) {
		arguments.subscriptionBenefit.removePriceGroup( this );
	}
	
	// Subscription Usage Benefits (many-to-many - inverse)
	public void function addSubscriptionUsageBenefit(required any subsciptionUsageBenefit) {
		arguments.subsciptionUsageBenefit.addPriceGroup( this );
	}
	public void function removeSubscriptionUsageBenefit(required any subsciptionUsageBenefit) {
		arguments.subsciptionUsageBenefit.removePriceGroup( this );
	}
	
	// Promotion Reward (many-to-many - inverse)
	public void function addPromotionReward(required any promotionReward) {
		arguments.promotionReward.addEligiblePriceGroup( this );
	}
	public void function removePromotionReward(required any promotionReward) {
		arguments.promotionReward.removeEligiblePriceGroup( this );
	}
	
	// Subscription Usage Benefits (many-to-many - inverse)
    public void function addShippingMethodRate(required any shippingMethodRate) {
        arguments.shippingMethodRate.addPriceGroup( this );
    }
    public void function removeShippingMethodRate(required any shippingMethodRate) {
        arguments.shippingMethodRate.removePriceGroup( this );
    }
	// =============  END:  Bidirectional Helper Methods ===================

	// =============== START: Custom Validation Methods ====================
	
	// ===============  END: Custom Validation Methods =====================
	
	// =============== START: Custom Formatting Methods ====================
	
	// ===============  END: Custom Formatting Methods =====================
	
	// ============== START: Overridden Implicet Getters ===================
	
	public string function getPriceGroupIDPath() {
		if(isNull(variables.priceGroupIDPath)) {
			variables.priceGroupIDPath = buildIDPathList( "parentPriceGroup" );
		}
		return variables.priceGroupIDPath;
	}
	
	// ==============  END: Overridden Implicet Getters ====================

	// ================== START: Overridden Methods ========================
	
	public void function preInsert(){
		setPriceGroupIDPath( buildIDPathList( "parentPriceGroup" ) );
		super.preInsert();
	}
	
	public void function preUpdate(struct oldData){
		setPriceGroupIDPath( buildIDPathList( "parentPriceGroup" ) );
		super.preUpdate(argumentcollection=arguments);
	}
	
	// ==================  END:  Overridden Methods ========================
	
	// =================== START: ORM Event Hooks  =========================
	
	// ===================  END:  ORM Event Hooks  =========================
	
	// ================== START: Deprecated Methods ========================
	
	// ==================  END:  Deprecated Methods ========================
}

