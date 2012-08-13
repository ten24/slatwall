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

*/
component displayname="Price Group" entityname="SlatwallPriceGroup" table="SlatwallPriceGroup" persistent=true output=false accessors=true extends="BaseEntity" {
	
	// Persistent Properties
	property name="priceGroupID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="priceGroupIDPath" ormtype="string";
	property name="activeFlag" ormtype="boolean";
	property name="priceGroupName" ormtype="string";
	property name="priceGroupCode" ormtype="string";
	
	// Related Object Properties (Many-To-One)
	property name="parentPriceGroup" cfc="PriceGroup" fieldtype="many-to-one" fkcolumn="parentPriceGroupID" nullRBKey="define.none";
	
	// Related Object Properties (One-To-Many)
	property name="childPriceGroups" singularname="ChildPriceGroup" cfc="PriceGroup" fieldtype="one-to-many" fkcolumn="parentPriceGroupID" inverse="true";
	property name="priceGroupRates" singularname="priceGroupRate" cfc="PriceGroupRate" fieldtype="one-to-many" fkcolumn="priceGroupID" cascade="all-delete-orphan" inverse="true";    
	
	// Related Object Properties (many-to-many - invers)
	property name="accounts" singularname="account" cfc="Account" fieldtype="many-to-many" linktable="SlatwallAccountPriceGroup" fkcolumn="priceGroupID" inversejoincolumn="accountID" inverse="true";
	property name="subscriptionBenefits" singularname="subscriptionBenefit" cfc="SubscriptionBenefit" type="array" fieldtype="many-to-many" linktable="SlatwallSubscriptionBenefitPriceGroup" fkcolumn="priceGroupID" inversejoincolumn="subscriptionBenefitID" inverse="true";
	property name="subscriptionUsageBenefits" singularname="subscriptionUsageBenefit" cfc="SubscriptionUsageBenefit" type="array" fieldtype="many-to-many" linktable="SlatwallSubscriptionUsageBenefitPriceGroup" fkcolumn="priceGroupID" inversejoincolumn="subscriptionUsageBenefitID" inverse="true";
	property name="promotionRewards" singularname="promotionReward" cfc="PromotionReward" type="array" fieldtype="many-to-many" linktable="SlatwallPromotionRewardEligiblePriceGroup" fkcolumn="priceGroupID" inversejoincolumn="promotionRewardID" inverse="true";

	// Audit properties
	property name="createdDateTime" ormtype="timestamp";
	property name="createdByAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="createdByAccountID";
	property name="modifiedDateTime" ormtype="timestamp";
	property name="modifiedByAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="modifiedByAccountID";
	
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
			if(options[i]['value'] == getPriceGroupID()) {
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
		setPriceGroupIDPath( buildIDPathList( "parentPriceGroup" ) );;
		super.preUpdate(argumentcollection=arguments);
	}
	
	// ==================  END:  Overridden Methods ========================
	
	// =================== START: ORM Event Hooks  =========================
	
	// ===================  END:  ORM Event Hooks  =========================
	
	// ================== START: Deprecated Methods ========================
	
	// ==================  END:  Deprecated Methods ========================
}
