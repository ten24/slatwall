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
component displayname="ProductListingPage" entityname="SlatwallProductListingPage" table="SwProductListingPage" persistent="true" accessors="true" extends="HibachiEntity" hb_serviceName="productService" hb_permission="this" {

	// Persistent Properties
	property name="productListingPageID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="sortOrder" ormtype="integer";

	// Calculated Properties

	// Related Object Properties (many-to-one)
	property name="product" cfc="Product" fieldtype="many-to-one" fkcolumn="productID";
	property name="content" cfc="Content" fieldtype="many-to-one" fkcolumn="contentID";

	// Related Object Properties (one-to-many)

	// Related Object Properties (many-to-many - owner)

	// Related Object Properties (many-to-many - inverse)

	// Remote Properties

	// Audit Properties
	property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="createdByAccountID" hb_populateEnabled="false" ormtype="string";
	property name="modifiedDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="modifiedByAccountID" hb_populateEnabled="false" ormtype="string";

	// Helper Accessors
	public string function getContentIDPath(){
		return this.getContent().getContentIDPath();
	}

	// Non-Persistent Properties
	// Deprecated Properties
	
	
	// ==================== START: Logical Methods =========================

	// ====================  END: Logical Methods ==========================

	// ============ START: Non-Persistent Property Methods =================

	// ============  END:  Non-Persistent Property Methods =================

	// ============= START: Bidirectional Helper Methods ===================
	
	// Product (many-to-one)
	public void function setProduct(required any product) {
		variables.product = arguments.product;
		if(isNew() or !arguments.product.hasListingPage( this )) {
			arrayAppend(arguments.product.getListingPages(), this);
		}
	}
	public void function removeProduct(any product) {
		if(!structKeyExists(arguments, "product") && structKeyExists(variables,"product")) {
			arguments.product = variables.product;
		}
		if(structKeyExists(arguments,"product")){
			var index = arrayFind(arguments.product.getListingPages(), this);
			if(index > 0) {
				arrayDeleteAt(arguments.product.getListingPages(), index);
			}	
		}
		structDelete(variables, "product");
	}	

	// Content (many-to-one)
	public void function setContent(required any content) {
		variables.content = arguments.content;
		if(isNew() or !arguments.content.hasListingPage( this )) {
			arrayAppend(arguments.content.getListingPages(), this);
		}
	}
	public void function removeContent(any content) {
		if(!structKeyExists(arguments, "content") && structKeyExists(variables,"content")) {
			arguments.content = variables.content;
		}
		if(structKeyExists(arguments,"content")){
			var index = arrayFind(arguments.content.getListingPages(), this);
			if(index > 0) {
				arrayDeleteAt(arguments.content.getListingPages(), index);
			}
		}
		if(!isNull(variables.content)){
			structDelete(variables, "content");
		}
	}
	
	// =============  END:  Bidirectional Helper Methods ===================

	// =============== START: Custom Validation Methods ====================

	// ===============  END: Custom Validation Methods =====================

	// =============== START: Custom Formatting Methods ====================

	// ===============  END: Custom Formatting Methods =====================

	// ============== START: Overridden Implicit Getters ===================

	// ==============  END: Overridden Implicit Getters ====================

	// ============= START: Overridden Smart List Getters ==================

	// =============  END: Overridden Smart List Getters ===================

	// ================== START: Overridden Methods ========================

	// ==================  END:  Overridden Methods ========================

	// =================== START: ORM Event Hooks  =========================

	// ===================  END:  ORM Event Hooks  =========================

	// ================== START: Deprecated Methods ========================

	// ==================  END:  Deprecated Methods ========================

}
