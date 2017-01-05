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
component displayname="AttributeSet" entityname="SlatwallAttributeSet" table="SwAttributeSet" persistent="true" output="false" accessors="true" extends="HibachiEntity" cacheuse="transactional" hb_serviceName="attributeService" hb_permission="this" {
	
	// Persistent Properties
	property name="attributeSetID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="activeFlag" ormtype="boolean";
	property name="attributeSetName" ormtype="string";
	property name="attributeSetCode" ormtype="string" index="PI_ATTRIBUTESETCODE";
	property name="attributeSetDescription" ormtype="string" length="2000";
	property name="attributeSetObject" ormtype="string" hb_formFieldType="select";
	property name="globalFlag" ormtype="boolean" default="1";
	property name="accountSaveFlag" ormtype="boolean";
	property name="sortOrder" ormtype="integer";
	
	// Related Object Properties (many-to-one)
	
	// Related Object Properties (one-to-many)
	property name="attributes" singularname="attribute" cfc="Attribute" fieldtype="one-to-many" fkcolumn="attributeSetID" inverse="true" cascade="all-delete-orphan" orderby="sortOrder";
	
	// Related Object Properties (many-to-many - owner)
	property name="contents" singularname="content" cfc="Content" type="array" fieldtype="many-to-many" linktable="SwAttributeSetContent" fkcolumn="attributeSetID" inversejoincolumn="contentID";
	property name="productTypes" singularname="productType" cfc="ProductType" type="array" fieldtype="many-to-many" linktable="SwAttributeSetProductType" fkcolumn="attributeSetID" inversejoincolumn="productTypeID";
	property name="products" singularname="product" cfc="Product" type="array" fieldtype="many-to-many" linktable="SwAttributeSetProduct" fkcolumn="attributeSetID" inversejoincolumn="productID";
	property name="brands" singularname="brand" cfc="Brand" type="array" fieldtype="many-to-many" linktable="SwAttributeSetBrand" fkcolumn="attributeSetID" inversejoincolumn="brandID";
	property name="skus" singularname="sku" cfc="Sku" type="array" fieldtype="many-to-many" linktable="SwAttributeSetSku" fkcolumn="attributeSetID" inversejoincolumn="skuID";
	property name="types" singularname="type" cfc="Type" type="array" fieldtype="many-to-many" linktable="SwAttributeSetType" fkcolumn="attributeSetID" inversejoincolumn="typeID";

	// Related Object Properties (many-to-many - inverse)
	
	// Audit Properties
	property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="createdByAccountID" hb_populateEnabled="false" ormtype="string";
	property name="modifiedDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="modifiedByAccountID" hb_populateEnabled="false" ormtype="string";
	
	//Non-Persistent
	
	public string function getAttributeSetObjectPrimaryIDPropertyName(){
		return getService('hibachiService').getPrimaryIDPropertyNameByEntityName(getAttributeSetObject());
	}
	
	public array function getAttributes(orderby, sortType="text", direction="asc") {
		if(!structKeyExists(arguments, "orderby")) {
			return variables.Attributes;
		} else {
			return getService("hibachiUtilityService").sortObjectArray(variables.Attributes,arguments.orderby,arguments.sortType,arguments.direction);
		}
	}
    
   	public numeric function getAttributeCount() {
		return arrayLen(this.getAttributes());
	}

	// ============ START: Non-Persistent Property Methods =================
	
	public array function getAttributeSetObjectOptions() {
		return [
			{value="Account", name=rbKey("entity.Account")},
			{value="AccountAddress", name=rbKey("entity.AccountAddress")},
			{value="AccountPayment", name=rbKey("entity.AccountPayment")},
			{value="Address", name=rbKey("entity.Address")},
			{value="AttributeOption", name=rbKey("entity.AttributeOption")},
			{value="Brand", name=rbKey("entity.Brand")},
			{value="Content", name=rbKey("entity.Content")},
			{value="EventRegistration", name=rbKey("entity.EventRegistration")},
			{value="File", name=rbKey("entity.File")},
			{value="Image", name=rbKey("entity.Image")},
			{value="Location", name=rbKey("entity.Location")},
			{value="LocationConfiguration", name=rbKey("entity.LocationConfiguration")},
			{value="Order", name=rbKey("entity.Order")},
			{value="OrderItem", name=rbKey("entity.OrderItem")},
			{value="OrderPayment", name=rbKey("entity.OrderPayment")},
			{value="OrderFulfillment", name=rbKey("entity.OrderFulfillment")},
			{value="OrderDelivery", name=rbKey("entity.OrderDelivery")},
			{value="OptionGroup", name=rbKey("entity.OptionGroup")},
			{value="Product", name=rbKey("entity.Product")},
			{value="ProductBundleGroup", name=rbKey("entity.ProductBundleGroup")},
			{value="ProductType", name=rbKey("entity.ProductType")},
			{value="ProductReview", name=rbKey("entity.ProductReview")},
			{value="Promotion", name=rbKey("entity.Promotion")},
			{value="Sku", name=rbKey("entity.Sku")},
			{value="Site", name=rbKey("entity.Site")},
			{value="SubscriptionBenefit", name=rbKey("entity.SubscriptionBenefit")},
			{value="Type", name=rbKey("entity.Type")},
			{value="Vendor", name=rbKey("entity.Vendor")},
			{value="VendorOrder", name=rbKey("entity.VendorOrder")}
		];
    }
    
	// ============  END:  Non-Persistent Property Methods =================
	
	// ============= START: Bidirectional Helper Methods ===================
	
	// Attributes (one-to-many)
	public void function addAttribute(required any attribute) {
		arguments.attribute.setAttributeSet( this );
	}
	public void function removeAttribute(required any attribute) {
		arguments.attribute.removeAttributeSet( this );
	}
	
	// Product Types (many-to-many - owner)
	public void function addProductType(required any productType) {    
		if(arguments.productType.isNew() or !hasProductType(arguments.productType)) {    
			arrayAppend(variables.productTypes, arguments.productType);    
		}
		if(isNew() or !arguments.productType.hasAttributeSet( this )) {    
			arrayAppend(arguments.productType.getAttributeSets(), this);    
		}    
	}
	public void function removeProductType(required any productType) {    
		var thisIndex = arrayFind(variables.productTypes, arguments.productType);    
		if(thisIndex > 0) {    
			arrayDeleteAt(variables.productTypes, thisIndex);    
		}    
		var thatIndex = arrayFind(arguments.productType.getAttributeSets(), this);    
		if(thatIndex > 0) {    
			arrayDeleteAt(arguments.productType.getAttributeSets(), thatIndex);    
		}
	}
	
	// Contents (many-to-many - owner)
	public void function addContent(required any content) {    
		if(arguments.content.isNew() or !hasContent(arguments.content)) {    
			arrayAppend(variables.contents, arguments.content);    
		}
		if(isNew() or !arguments.content.hasAttributeSet( this )) {    
			arrayAppend(arguments.content.getAttributeSets(), this);    
		}    
	}
	public void function removeContent(required any content) {    
		var thisIndex = arrayFind(variables.contents, arguments.content);    
		if(thisIndex > 0) {    
			arrayDeleteAt(variables.contents, thisIndex);    
		}    
		var thatIndex = arrayFind(arguments.content.getAttributeSets(), this);    
		if(thatIndex > 0) {    
			arrayDeleteAt(arguments.content.getAttributeSets(), thatIndex);    
		}
	}
	
	// =============  END:  Bidirectional Helper Methods ===================
	
	// ================== START: Overridden Methods ========================
	
	public boolean function getGlobalFlag() {
		if(!structKeyExists(variables, "globalFlag")) {
			variables.globalFlag = 1;
		}
		if(!isNull(getAttributeSetObject()) && !listFindNoCase("Content,OrderItem,ProductType,Product,Sku,Type", getAttributeSetObject())) {
			variables.globalFlag = 1;
		}
		return variables.globalFlag;
	}
	
	// ==================  END:  Overridden Methods ========================
		
	// =================== START: ORM Event Hooks  =========================
	
	// ===================  END:  ORM Event Hooks  =========================
}

