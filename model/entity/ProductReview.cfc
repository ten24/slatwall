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
component displayname="Product Review" entityname="SlatwallProductReview" table="SwProductReview" persistent="true" output="false" accessors="true" extends="HibachiEntity" cacheuse="transactional" hb_serviceName="productService" hb_permission="product.productReviews" {

	// Persistent Properties
	property name="productReviewID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="activeFlag" ormtype="boolean";
	property name="reviewerName" hb_populateEnabled="public" ormtype="string";
	property name="review" hb_populateEnabled="public" ormtype="string" length="4000" hint="HTML Formated review of the Product";
	property name="reviewTitle" hb_populateEnabled="public" ormtype="string";
	property name="rating" hb_populateEnabled="public" ormtype="int";

	// Related Object Properties (many-to-one)
	property name="product" hb_populateEnabled="public" cfc="Product" fieldtype="many-to-one" fkcolumn="productID";
	property name="account" cfc="Account" fieldtype="many-to-one" fkcolumn="accountID";
	property name="sku" hb_populateEnabled="public" cfc="Sku" fieldtype="many-to-one" fkcolumn="skuID";
	
	// Related Object Properties (one-to-many)
 	property name="attributeValues" singularname="attributeValue" cfc="AttributeValue" fieldtype="one-to-many" fkcolumn="productReviewID" inverse="true" cascade="all-delete-orphan";

	// Remote Properties
	property name="remoteID" ormtype="string";

	// Audit Properties
	property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="createdByAccountID" hb_populateEnabled="false" ormtype="string";
	property name="modifiedDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="modifiedByAccountID" hb_populateEnabled="false" ormtype="string";
	
	// Non-Persistent Properties
	property name="ratingOptions" type="array" persistent="false";

	public any function init() {
		setActiveFlag(0);

		if(isNull(variables.reviewTitle)) {
			variables.reviewTitle = "";
		}
		if(isNull(variables.rating)) {
			variables.rating = 0;
		}

		return super.init();
	}
	
	

	public string function getReviewerGravatarURL(numeric size=80) {
		var server = "http://www.gravatar.com";

		if(cgi.server_port eq 443) {
			server = "https://secure.gravatar.com";
		}

		if(!isNull(getAccount())) {
			return "#server#/avatar/#lcase(hash(lcase(getAccount().getEmailAddress()), "MD5" ))#?s=#arguments.size#";
		}
		return "#server#/avatar/00000000000000000000000000000000?s=#arguments.size#";
	}

	// ============ START: Non-Persistent Property Methods =================
	
	public array function getRatingOptions() {
		return [5,4,3,2,1];
	}

	// ============  END:  Non-Persistent Property Methods =================

	// ============= START: Bidirectional Helper Methods ===================

	// Product (many-to-one)
	public void function setProduct(required any product) {
		variables.product = arguments.product;
		if(isNew() or !arguments.product.hasProductReview( this )) {
			arrayAppend(arguments.product.getProductReviews(), this);
		}
	}
	public void function removeProduct(any product) {
		if(!structKeyExists(arguments, "product")) {
			arguments.product = variables.product;
		}
		var index = arrayFind(arguments.product.getProductReviews(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.product.getProductReviews(), index);
		}
		structDelete(variables, "product");
	}

	// Account (many-to-one)
	public void function setAccount(required any account) {
		variables.account = arguments.account;
		if(isNew() or !arguments.account.hasProductReview( this )) {
			arrayAppend(arguments.account.getProductReviews(), this);
		}
	}
	public void function removeAccount(any account) {
		if(!structKeyExists(arguments, "account")) {
			arguments.account = variables.account;
		}
		var index = arrayFind(arguments.account.getProductReviews(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.account.getProductReviews(), index);
		}
		structDelete(variables, "account");
	}
	
	// Sku (many-to-one)
	public void function setSku(required any sku) {
		variables.sku = arguments.sku;
		if(isNew() or !arguments.sku.hasProductReview( this )) {
			arrayAppend(arguments.sku.getProductReviews(), this);
		}
	}
	public void function removeSku(any sku) {
		if(!structKeyExists(arguments, "sku")) {
			arguments.sku = variables.sku;
		}
		var index = arrayFind(arguments.sku.getProductReviews(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.sku.getProductReviews(), index);
		}
		structDelete(variables, "sku");
	}
	
	// Attribute Values (one-to-many)
 	public void function addAttributeValue(required any attributeValue) {
 		arguments.attributeValue.setProductReview( this );
 	}
 	public void function removeAttributeValue(required any attributeValue) {
 		arguments.attributeValue.removeProductReview( this );
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
		return "reviewTitle";
	}
	
	public any function getDefaultCollectionProperties(string includesList = "", string excludesList="modifiedByAccountID,createdByAccountID,modifiedDateTime,remoteID,remoteEmployeeID,remoteCustomerID,remoteContactID,cmsAccountID,cmsContentID,cmsSiteID"){
		
		return super.getDefaultCollectionProperties(argumentCollection=arguments);
	}

	// ==================  END:  Overridden Methods ========================

	// =================== START: ORM Event Hooks  =========================

	public void function preInsert(){
		super.preInsert();

		// This bit of logic sets a product review as whatever the current account is (We might want to move this to the service)
		if( isNull(getAccount()) && !isNull(getHibachiScope().getAccount()) && !getHibachiScope().getAccount().isNew() ) {
			setAccount(getAccount().getAccount());
		}
	}

	// ===================  END:  ORM Event Hooks  =========================

	// ================== START: Deprecated Methods ========================

	// ==================  END:  Deprecated Methods ========================
}

