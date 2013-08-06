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
component displayname="Content" entityname="SlatwallContent" table="SlatwallContent" persistent="true" accessors="true" extends="HibachiEntity" cacheuse="transactional" hb_serviceName="contentService" hb_permission="this" hb_parentPropertyName="parentContent" hb_processContexts="createSku" {
	
	// Persistent Properties
	property name="contentID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="contentIDPath" ormtype="string" length="500";
	property name="activeFlag" ormtype="boolean";
	property name="title" ormtype="string";
	property name="allowPurchaseFlag" ormtype="boolean";
	property name="productListingPageFlag" ormtype="boolean";
	
	// CMS Properties
	property name="cmsContentID" ormtype="string";
	
	// Related Object Properties (many-to-one)
	property name="site" cfc="Site" fieldtype="many-to-one" fkcolumn="siteID";
	property name="parentContent" cfc="Content" fieldtype="many-to-one" fkcolumn="parentContentID";
	property name="contentTemplateType" cfc="Type" fieldtype="many-to-one" fkcolumn="contentTemplateTypeID" hb_optionsNullRBKey="define.none" hb_optionsSmartListData="f:parentType.systemCode=contentTemplateType" fetch="join";
	
	// Related Object Properties (one-to-many)
	property name="childContents" singularname="childContent" cfc="Content" type="array" fieldtype="one-to-many" fkcolumn="parentContentID" cascade="all-delete-orphan" inverse="true";
	
	// Related Object Properties (many-to-many - owner)
	property name="categories" singularname="category" cfc="Category" type="array" fieldtype="many-to-many" linktable="SlatwallContentCategory" fkcolumn="contentID" inversejoincolumn="categoryID";
	
	// Related Object Properties (many-to-many - inverse)
	property name="skus" singularname="sku" cfc="Sku" type="array" fieldtype="many-to-many" linktable="SlatwallSkuAccessContent" fkcolumn="contentID" inversejoincolumn="skuID" inverse="true";
	property name="listingProducts" singularname="listingProduct" cfc="Product" type="array" fieldtype="many-to-many" linktable="SlatwallProductListingPage" fkcolumn="contentID" inversejoincolumn="productID" inverse="true";
	
	// Remote properties
	property name="remoteID" ormtype="string" hint="Only used when integrated with a remote system";
	
	// Audit Properties
	property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="createdByAccount" hb_populateEnabled="false" cfc="Account" fieldtype="many-to-one" fkcolumn="createdByAccountID";
	property name="modifiedDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="modifiedByAccount" hb_populateEnabled="false" cfc="Account" fieldtype="many-to-one" fkcolumn="modifiedByAccountID";
	
	// Non Persistent
	property name="categoryIDList" persistent="false";
	
	// Deprecated Properties
	property name="disableProductAssignmentFlag" ormtype="boolean";			// no longer needed because the listingPageFlag is defined for all objects
	property name="templateFlag" ormtype="boolean";							// use contentTemplateType instead
	property name="cmsSiteID" ormtype="string";
	property name="cmsContentIDPath" ormtype="string" length="500";
    
	
	// ============ START: Non-Persistent Property Methods =================
	
	public string function getCategoryIDList() {
		if(!structKeyExists(variables, "categoryIDList")) {
			variables.categoryIDList = "";
			for(var category in getCategories()) {
				for(var l=1; l<=listLen(category.getCategoryIDPath()); l++) {
					var thisCatID = listGetAt(category.getCategoryIDPath(), l);
					if(!listFindNoCase(variables.categoryIDList, thisCatID)) {
						variables.categoryIDList = listAppend(variables.categoryIDList, thisCatID);
					}
				}
			}	
		}
		
		return variables.categoryIDList;
	}
	
	// ============  END:  Non-Persistent Property Methods =================
		
	// ============= START: Bidirectional Helper Methods ===================
	
	// Parent Content (many-to-one)
	public void function setParentContent(required any parentContent) {
		variables.parentContent = arguments.parentContent;
		if(isNew() or !arguments.parentContent.hasChildContent( this )) {
			arrayAppend(arguments.parentContent.getChildContents(), this);
		}
	}
	public void function removeParentContent(any parentContent) {
		if(!structKeyExists(arguments, "parentContent")) {
			arguments.parentContent = variables.parentContent;
		}
		var index = arrayFind(arguments.parentContent.getChildContents(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.parentContent.getChildContents(), index);
		}
		structDelete(variables, "parentContent");
	}
	
	// Site (many-to-one)    
	public void function setSite(required any site) {    
		variables.site = arguments.site;    
		if(isNew() or !arguments.site.hasContent( this )) {    
			arrayAppend(arguments.site.getContents(), this);    
		}    
	}    
	public void function removeSite(any site) {    
		if(!structKeyExists(arguments, "site")) {    
			arguments.site = variables.site;    
		}    
		var index = arrayFind(arguments.site.getContents(), this);    
		if(index > 0) {    
			arrayDeleteAt(arguments.site.getContents(), index);    
		}    
		structDelete(variables, "site");    
	}
	
	// Child Contents (one-to-many)    
	public void function addChildContent(required any childContent) {    
		arguments.childContent.setParentContent( this );    
	}    
	public void function removeChildContent(required any childContent) {    
		arguments.childContent.removeParentContent( this );    
	}
	
	// Categories (many-to-many - owner)    
	public void function addCategory(required any category) {    
		if(arguments.category.isNew() or !hasCategory(arguments.category)) {    
			arrayAppend(variables.categories, arguments.category);    
		}    
		if(isNew() or !arguments.category.hasContent( this )) {    
			arrayAppend(arguments.category.getContents(), this);    
		}    
	}    
	public void function removeCategory(required any category) {    
		var thisIndex = arrayFind(variables.categories, arguments.category);    
		if(thisIndex > 0) {    
			arrayDeleteAt(variables.categories, thisIndex);    
		}    
		var thatIndex = arrayFind(arguments.category.getContents(), this);    
		if(thatIndex > 0) {    
			arrayDeleteAt(arguments.category.getContents(), thatIndex);    
		}    
	}
	
	// Skus (many-to-many - inverse)
	public void function addSku(required any sku) {
		arguments.sku.addAccessContent( this );
	}
	public void function removeSku(required any sku) {
		arguments.sku.removeAccessContent( this );
	}
	
	// Listing Products (many-to-many - inverse)    
	public void function addListingProduct(required any listingProduct) {    
		arguments.listingProduct.addListingPage( this );    
	}    
	public void function removeListingProduct(required any listingProduct) {    
		arguments.listingProduct.removeListingPage( this );    
	}
	
	// =============  END:  Bidirectional Helper Methods ===================

	// ================== START: Overridden Methods ========================
	
	public boolean function getAllowPurchaseFlag() {
		if(isNull(variables.allowPurchaseFlag)) {
			variables.allowPurchaseFlag = 0;
		}
		return variables.allowPurchaseFlag;
	}
	
	public boolean function getProductListingPageFlag() {
		if(isNull(variables.productListingPageFlag)) {
			variables.productListingPageFlag = 0;
		}
		return variables.productListingPageFlag;
	}
	
	public string function getSimpleRepresentationPropertyName() {
		return "title";
	}
	
	// ==================  END:  Overridden Methods ========================
	
	// =================== START: ORM Event Hooks  =========================
	
	public void function preInsert(){
		super.preInsert();
		setContentIDPath( buildIDPathList( "parentContent" ) );
	}
	
	public void function preUpdate(struct oldData){
		super.preUpdate(argumentcollection=arguments);
		setContentIDPath( buildIDPathList( "parentContent" ) );
	}
	
	// ===================  END:  ORM Event Hooks  =========================
	
	// ================== START: Deprecated Methods ========================
	
	// The setting method is not deprecated, but 
	public any function setting(required string settingName, array filterEntities=[], formatValue=false) {
		if(arguments.settingName == 'contentProductListingFlag') {
			return getProductListingPageFlag();
		}
		return super.setting(argumentcollection=arguments);
	}
	
	// ==================  END:  Deprecated Methods ========================
	
}
