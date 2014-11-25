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
component entityname="SlatwallSubscriptionUsageBenefit" table="SwSubsUsageBenefit" persistent="true" accessors="true" extends="HibachiEntity" cacheuse="transactional" hb_serviceName="subscriptionService" hb_permission="subscriptionUsage.subscriptionUsageBenefits" {
	
	// Persistent Properties
	property name="subscriptionUsageBenefitID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="maxUseCount" ormtype="integer";
	
	// Related Object Properties (many-to-one)
	property name="subscriptionBenefit" cfc="SubscriptionBenefit" fieldtype="many-to-one" fkcolumn="subscriptionBenefitID";
	property name="subscriptionUsage" cfc="SubscriptionUsage" fieldtype="many-to-one" fkcolumn="subscriptionUsageID" inverse="true";
	property name="renewalSubscriptionUsage" cfc="SubscriptionUsage" fieldtype="many-to-one" fkcolumn="renewalSubscriptionUsageID" inverse="true";
	property name="accessType" cfc="Type" fieldtype="many-to-one" fkcolumn="accessTypeID" hb_optionsSmartListData="f:parentType.systemCode=accessType";
	
	// Related Object Properties (one-to-many)
	property name="subscriptionUsageBenefitAccounts" singularname="subscriptionUsageBenefitAccount" cfc="SubscriptionUsageBenefitAccount" type="array" fieldtype="one-to-many" fkcolumn="subscriptionUsageBenefitID" cascade="all-delete-orphan" inverse="true";
	
	// Related Object Properties (many-to-many)
	property name="priceGroups" singularname="priceGroup" cfc="PriceGroup" type="array" fieldtype="many-to-many" linktable="SwSubsUsageBenefitPriceGroup" fkcolumn="subscriptionUsageBenefitID" inversejoincolumn="priceGroupID";
	property name="promotions" singularname="promotion" cfc="Promotion" type="array" fieldtype="many-to-many" linktable="SwSubsUsageBenefitPromotion" fkcolumn="subscriptionUsageBenefitID" inversejoincolumn="promotionID";
	property name="categories" singularname="category" cfc="Category" type="array" fieldtype="many-to-many" linktable="SwSubsUsageBenefitCategory" fkcolumn="subscriptionUsageBenefitID" inversejoincolumn="categoryID";
	property name="contents" singularname="content" cfc="Content" type="array" fieldtype="many-to-many" linktable="SwSubsUsageBenefitContent" fkcolumn="subscriptionUsageBenefitID" inversejoincolumn="contentID";
	
	property name="excludedCategories" singularname="excludedCategory" cfc="Category" type="array" fieldtype="many-to-many" linktable="SwSubsUsageBenefitExclCategory" fkcolumn="subscriptionUsageBenefitID" inversejoincolumn="categoryID";
	property name="excludedContents" singularname="excludedContent" cfc="Content" type="array" fieldtype="many-to-many" linktable="SwSubsUsageBenefitExclContent" fkcolumn="subscriptionUsageBenefitID" inversejoincolumn="contentID";
	
	// Remote Properties
	property name="remoteID" ormtype="string";
	
	// Audit Properties
	property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="createdByAccountID" hb_populateEnabled="false" ormtype="string";
	property name="modifiedDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="modifiedByAccountID" hb_populateEnabled="false" ormtype="string";
	
	// Non-Persistent Properties

	
	public numeric function getCurrentUseCount() {
		var subscriptionUsageBenefitAccountSmartList = getService("SubscriptionService").getSubscriptionUsageBenefitAccountSmartList();
		subscriptionUsageBenefitAccountSmartList.addFilter(propertyIdentifier="subscriptionUsageBenefit.subscriptionUsageBenefitID", value=variables.subscriptionUsageBenefitID);
		return subscriptionUsageBenefitAccountSmartList.getRecordsCount();
	}
	
	public numeric function getAvailableUseCount() {
		return getMaxUseCount() - getCurrentUseCount();
	}
	
	public void function copyFromSubscriptionBenefit(required any subscriptionBenefit) {
		setSubscriptionBenefit(arguments.subscriptionBenefit);
		setMaxUseCount(arguments.subscriptionBenefit.getMaxUseCount());
		setAccessType(arguments.subscriptionBenefit.getAccessType());
		for(var priceGroup in arguments.subscriptionBenefit.getPriceGroups()) {
			addPriceGroup(priceGroup);
		}
		for(var promotion in arguments.subscriptionBenefit.getPromotions()) {
			addPromotion(promotion);
		}
		for(var category in arguments.subscriptionBenefit.getCategories()) {
			addCategory(category);
		}
		for(var content in arguments.subscriptionBenefit.getContents()) {
			addContent(content);
		}
		for(var excludedCategory in arguments.subscriptionBenefit.getExcludedCategories()) {
			addExcludedCategory(excludedCategory);
		}
		for(var excludedContent in arguments.subscriptionBenefit.getExcludedContents()) {
			addExcludedContent(excludedContent);
		}
	}
	
	public void function copyFromSubscriptionUsageBenefit(required any subscriptionUsageBenefit) {
		setSubscriptionBenefit(arguments.subscriptionUsageBenefit.getSubscriptionBenefit());
		setMaxUseCount(arguments.subscriptionUsageBenefit.getMaxUseCount());
		setAccessType(arguments.subscriptionUsageBenefit.getAccessType());
		for(var priceGroup in arguments.subscriptionUsageBenefit.getPriceGroups()) {
			addPriceGroup(priceGroup);
		}
		for(var promotion in arguments.subscriptionUsageBenefit.getPromotions()) {
			addPromotion(promotion);
		}
		for(var category in arguments.subscriptionUsageBenefit.getCategories()) {
			addCategory(category);
		}
		for(var content in arguments.subscriptionUsageBenefit.getContents()) {
			addContent(content);
		}
		for(var excludedCategory in arguments.subscriptionUsageBenefit.getExcludedCategories()) {
			addExcludedCategory(excludedCategory);
		}
		for(var excludedContent in arguments.subscriptionUsageBenefit.getExcludedContents()) {
			addExcludedContent(excludedContent);
		}
	}
	
	// ============ START: Non-Persistent Property Methods =================
	
	// ============  END:  Non-Persistent Property Methods =================
		
	// ============= START: Bidirectional Helper Methods ===================
	
	// subscriptionUsage (many-to-one)    
	public void function setSubscriptionUsage(required any subscriptionUsage) {    
		variables.subscriptionUsage = arguments.subscriptionUsage;    
		if(isNew() or !arguments.subscriptionUsage.hasSubscriptionUsageBenefit( this )) {    
			arrayAppend(arguments.subscriptionUsage.getSubscriptionUsageBenefits(), this);    
		}    
	}    
	public void function removeSubscriptionUsage(any subscriptionUsage) {    
		if(!structKeyExists(arguments, "subscriptionUsage")) {    
			arguments.subscriptionUsage = variables.subscriptionUsage;    
		}    
		var index = arrayFind(arguments.subscriptionUsage.getSubscriptionUsageBenefits(), this);    
		if(index > 0) {    
			arrayDeleteAt(arguments.subscriptionUsage.getSubscriptionUsageBenefits(), index);    
		}    
		structDelete(variables, "subscriptionUsage");    
	}
	
	// renewalSubscriptionUsage (many-to-one)    
	public void function setRenewalSubscriptionUsage(required any renewalSubscriptionUsage) {    
		variables.renewalSubscriptionUsage = arguments.renewalSubscriptionUsage;    
		if(isNew() or !arguments.renewalSubscriptionUsage.hasRenewalSubscriptionUsageBenefit( this )) {    
			arrayAppend(arguments.renewalSubscriptionUsage.getRenewalSubscriptionUsageBenefits(), this);    
		}    
	}    
	public void function removeRenewalSubscriptionUsage(any renewalSubscriptionUsage) {    
		if(!structKeyExists(arguments, "renewalSubscriptionUsage")) {    
			arguments.renewalSubscriptionUsage = variables.renewalSubscriptionUsage;    
		}    
		var index = arrayFind(arguments.renewalSubscriptionUsage.getRenewalSubscriptionUsageBenefits(), this);    
		if(index > 0) {    
			arrayDeleteAt(arguments.renewalSubscriptionUsage.getRenewalSubscriptionUsageBenefits(), index);    
		}    
		structDelete(variables, "renewalSubscriptionUsage");    
	}
	
	// Price Groups (many-to-many - owner)    
	public void function addPriceGroup(required any priceGroup) {    
		if(arguments.priceGroup.isNew() or !hasPriceGroup(arguments.priceGroup)) {    
			arrayAppend(variables.priceGroups, arguments.priceGroup);    
		}    
		if(isNew() or !arguments.priceGroup.hasSubscriptionUsageBenefit( this )) {    
			arrayAppend(arguments.priceGroup.getSubscriptionUsageBenefits(), this);    
		}    
	}    
	public void function removePriceGroup(required any priceGroup) {    
		var thisIndex = arrayFind(variables.priceGroups, arguments.priceGroup);    
		if(thisIndex > 0) {    
			arrayDeleteAt(variables.priceGroups, thisIndex);    
		}    
		var thatIndex = arrayFind(arguments.priceGroup.getSubscriptionUsageBenefits(), this);    
		if(thatIndex > 0) {    
			arrayDeleteAt(arguments.priceGroup.getSubscriptionUsageBenefits(), thatIndex);    
		}    
	}
	
	// =============  END:  Bidirectional Helper Methods ===================

	// ================== START: Overridden Methods ========================
	
	public string function getSimpleRepresentation() {
		return getSubscriptionBenefit().getSubscriptionBenefitName();
	}
	
	// ==================  END:  Overridden Methods ========================
	
	// =================== START: ORM Event Hooks  =========================
	
	// ===================  END:  ORM Event Hooks  =========================
}
