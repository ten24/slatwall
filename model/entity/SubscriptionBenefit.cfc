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
component entityname="SlatwallSubscriptionBenefit" table="SwSubsBenefit" persistent="true" accessors="true" extends="HibachiEntity" cacheuse="transactional" hb_serviceName="subscriptionService" hb_permission="this" {
	
	// Persistent Properties
	property name="subscriptionBenefitID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="subscriptionBenefitName" ormtype="string";
	property name="maxUseCount" ormtype="integer";
	
	// Related Object Properties (many-to-one)
	property name="accessType" cfc="Type" fieldtype="many-to-one" fkcolumn="accessTypeID" hb_optionsSmartListData="f:parentType.systemCode=accessType";
	
	// Related Object Properties (one-to-many)
	property name="attributeValues" singularname="attributeValue" cfc="AttributeValue" fieldtype="one-to-many" fkcolumn="subscriptionBenefitID" inverse="true" cascade="all-delete-orphan";
	
	// Related Object Properties (many-to-many - owner)
	property name="priceGroups" singularname="priceGroup" cfc="PriceGroup" type="array" fieldtype="many-to-many" linktable="SwSubsBenefitPriceGroup" fkcolumn="subscriptionBenefitID" inversejoincolumn="priceGroupID" cascade="all";
	property name="promotions" singularname="promotion" cfc="Promotion" type="array" fieldtype="many-to-many" linktable="SwSubsBenefitPromotion" fkcolumn="subscriptionBenefitID" inversejoincolumn="promotionID" cascade="all";
	property name="categories" singularname="category" cfc="Category" type="array" fieldtype="many-to-many" linktable="SwSubsBenefitCategory" fkcolumn="subscriptionBenefitID" inversejoincolumn="categoryID" cascade="all";
	property name="contents" singularname="content" cfc="Content" type="array" fieldtype="many-to-many" linktable="SwSubsBenefitContent" fkcolumn="subscriptionBenefitID" inversejoincolumn="contentID" cascade="all";
	property name="excludedCategories" singularname="excludedCategory" cfc="Category" type="array" fieldtype="many-to-many" linktable="SwSubsBenefitExclCategory" fkcolumn="subscriptionBenefitID" inversejoincolumn="categoryID" cascade="all";
	property name="excludedContents" singularname="excludedContent" cfc="Content" type="array" fieldtype="many-to-many" linktable="SwSubsBenefitExclContent" fkcolumn="subscriptionBenefitID" inversejoincolumn="contentID" cascade="all";
	
	// Related Object Properties (many-to-many - inverse)
	property name="skus" singularname="sku" cfc="Sku" type="array" fieldtype="many-to-many" linktable="SwSkuSubsBenefit" fkcolumn="subscriptionBenefitID" inversejoincolumn="skuID" inverse="true";
	
	// Remote properties
	property name="remoteID" ormtype="string";
	
	// Audit Properties
	property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="createdByAccountID" hb_populateEnabled="false" ormtype="string";
	property name="modifiedDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="modifiedByAccountID" hb_populateEnabled="false" ormtype="string";
	
	// Non-Persistent Properties
	
    public array function getAccessTypeOptions() {
		if(!structKeyExists(variables, "accessTypeOptions")) {
			var smartList = getService("typeService").getTypeSmartList();
			smartList.addSelect(propertyIdentifier="typeName", alias="name");
			smartList.addSelect(propertyIdentifier="typeID", alias="value");
			smartList.addFilter(propertyIdentifier="parentType.systemCode", value="subscriptionAccessType");
			smartList.addOrder("typeName|ASC");
			variables.accessTypeOptions = smartList.getRecords();
			arrayPrepend(variables.accessTypeOptions,{name=rbKey("define.select"),value=""});
		}
		return variables.accessTypeOptions;
    }
    
    public any function getContentsOptionsSmartList() {
		if(!structKeyExists(variables, "contentsOptionsSmartList")) {
			var smartList = getService("contentService").getContentSmartList();
			//smartList.addWhereCondition("exists (FROM SlatwallSetting ss WHERE ss.settingName='contentRestrictAccessFlag' AND ss.settingValue=1 AND ss.cmsContentID = aslatwallcontent.cmsContentID)");
			smartList.addOrder("title|ASC");
			variables.contentsOptionsSmartList = smartList;
		}
		return variables.contentsOptionsSmartList;
    }
    
    public any function getCategoriesOptionsSmartList() {
		if(!structKeyExists(variables, "categoriesOptionsSmartList")) {
			var smartList = getService("contentService").getCategorySmartList();
			//smartList.addFilter(propertyIdentifier="restrictAccessFlag", value="1");
			smartList.addOrder("categoryName|ASC");
			variables.categoriesOptionsSmartList = smartList;
		}
		return variables.categoriesOptionsSmartList;
    }
    

	// ============ START: Non-Persistent Property Methods =================
	
	// ============  END:  Non-Persistent Property Methods =================
		
	// ============= START: Bidirectional Helper Methods ===================
	
	// Price Groups (many-to-many - owner)
	public void function addPriceGroup(required any priceGroup) {
		if(arguments.priceGroup.isNew() or !hasPriceGroup(arguments.priceGroup)) {
			arrayAppend(variables.priceGroups, arguments.priceGroup);
		}
		if(isNew() or !arguments.priceGroup.hasSubscriptionBenefit( this )) {
			arrayAppend(arguments.priceGroup.getSubscriptionBenefits(), this);
		}
	}
	public void function removePriceGroup(required any priceGroup) {
		var thisIndex = arrayFind(variables.priceGroups, arguments.priceGroup);
		if(thisIndex > 0) {
			arrayDeleteAt(variables.priceGroups, thisIndex);
		}
		var thatIndex = arrayFind(arguments.priceGroup.getSubscriptionBenefits(), this);
		if(thatIndex > 0) {
			arrayDeleteAt(arguments.priceGroup.getSubscriptionBenefits(), thatIndex);
		}
	}
	
	// Skus (many-to-many - inverse)
	public void function addSku(required any sku) {
		arguments.sku.addSubscriptionBenefit( this );
	}
	public void function removeSku(required any sku) {
		arguments.sku.removeSubscriptionBenefit( this );
	}
	
	// Attribute Values (one-to-many)
	public void function addAttributeValue(required any attributeValue) {
		arguments.attributeValue.setSubscriptionBenefit( this );
	}
	public void function removeAttributeValue(required any attributeValue) {
		arguments.attributeValue.removeSubscriptionBenefit( this );
	}
	
	// =============  END:  Bidirectional Helper Methods ===================

	// ================== START: Overridden Methods ========================
	
	// ==================  END:  Overridden Methods ========================
	
	// =================== START: ORM Event Hooks  =========================
	
	// ===================  END:  ORM Event Hooks  =========================
}
