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
component entityname="SlatwallVendor" table="SwVendor" persistent="true" accessors="true" output="false" extends="HibachiEntity" cacheuse="transactional" hb_serviceName="vendorService" hb_permission="this" {
	
	// Persistent Properties
	property name="vendorID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="vendorName" ormtype="string";
	property name="vendorWebsite" ormtype="string";
	property name="accountNumber" ormtype="string";
	
	// Related Object Properties (many-to-one)
	property name="primaryEmailAddress" cfc="VendorEmailAddress" fieldtype="many-to-one" fkcolumn="primaryEmailAddressID";
	property name="primaryPhoneNumber" cfc="VendorPhoneNumber" fieldtype="many-to-one" fkcolumn="primaryPhoneNumberID";
	property name="primaryAddress" cfc="VendorAddress" fieldtype="many-to-one" fkcolumn="primaryAddressID";
	
	// Related Object Properties (one-to-many)
	property name="attributeValues" singularname="attributeValue" cfc="AttributeValue" type="array" fieldtype="one-to-many" fkcolumn="vendorID" cascade="all-delete-orphan" inverse="true";
	property name="vendorOrders" singularname="vendorOrder" type="array" cfc="VendorOrder" fieldtype="one-to-many" fkcolumn="vendorID" cascade="save-update" inverse="true";
	property name="vendorAddresses" singularname="vendorAddress" type="array" cfc="VendorAddress" fieldtype="one-to-many" fkcolumn="vendorID" cascade="all-delete-orphan" inverse="true";
	property name="vendorPhoneNumbers" singularname="vendorPhoneNumber" type="array" cfc="VendorPhoneNumber" fieldtype="one-to-many" fkcolumn="vendorID" cascade="all-delete-orphan" inverse="true";
	property name="vendorEmailAddresses" singularname="vendorEmailAddress" type="array" cfc="VendorEmailAddress" fieldtype="one-to-many" fkcolumn="vendorID" cascade="all-delete-orphan" inverse="true";
	
	// Related Object Properties (many-to-many - owner)
	property name="brands" singularname="brand" cfc="Brand" fieldtype="many-to-many" linktable="SwVendorBrand" fkcolumn="vendorID" inversejoincolumn="brandID";
	property name="products" singularname="product" cfc="Product" fieldtype="many-to-many" linktable="SwVendorProduct" fkcolumn="vendorID" inversejoincolumn="productID";
	
	// Remote properties
	property name="remoteID" ormtype="string";
	
	// Audit Properties
	property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="createdByAccountID" hb_populateEnabled="false" ormtype="string";
	property name="modifiedDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="modifiedByAccountID" hb_populateEnabled="false" ormtype="string";
	
	// Non-Persistent Properties
	property name="vendorSkusSmartList" persistent="false";
	
	
	public string function getEmailAddress() {
		return getPrimaryEmailAddress().getEmailAddress();
	}
	
	public string function getPhoneNumber() {
		return getPrimaryPhoneNumber().getPhoneNumber();
	}
	
	public string function getAddress() {
		return getPrimaryAddress().getAddress();
	}
	
	// ============ START: Non-Persistent Property Methods =================
	
	public any function getVendorSkusSmartList() {
		if(!structKeyExists(variables, "vendorSkusSmartList")) {
			variables.vendorSkusSmartList = getService("vendorService").getVendorSkusSmartList(vendorID=getVendorID());
		}
		return variables.vendorSkusSmartList;
	}
	
	// ============  END:  Non-Persistent Property Methods =================
		
	// ============= START: Bidirectional Helper Methods ===================
	
	
	// Attribute Values (one-to-many)
	public void function addAttributeValue(required any attributeValue) {
		arguments.attributeValue.setVendor( this );
	}
	public void function removeAttributeValue(required any attributeValue) {
		arguments.attributeValue.removeVendor( this );
	}
	
	// Vendor Email Addresses (one-to-many)
	public void function addVendorEmailAddress(required any vendorEmailAddress) {
	   arguments.vendorEmailAddress.setVendor(this);
	}
	public void function removeVendorEmailAddress(required any vendorEmailAddress) {
	   arguments.vendorEmailAddress.removeVendor(this);
	}
	
	// Vendor Phone Numbers (one-to-many)
	public void function addVendorPhoneNumber(required any vendorPhoneNumber) {
	   arguments.vendorPhoneNumber.setVendor(this);
	}
	public void function removeVendorPhoneNumber(required any vendorPhoneNumber) {
	   arguments.vendorPhoneNumber.removeVendor(this);
	}
	
	// Vendor Addresses (one-to-many)
	public void function addVendorAddress(required any vendorAddress) {
	   arguments.vendorAddress.setVendor(this);
	}
	public void function removeVendorAddress(required any vendorAddress) {
	   arguments.vendorAddress.removeVendor(this);
	}
	
	// Vendor Orders (one-to-many)
	public void function addVendorOrder(required any vendorOrder) {
		arguments.vendorOrder.setVendor( this );
	}
	public void function removeVendorOrder(required any vendorOrder) {
		arguments.vendorOrder.removeVendor( this );
	}
	
	// Products (many-to-many - owner)
	public void function addProduct(required any product) {
		if(arguments.product.isNew() or !hasProduct(arguments.product)) {
			arrayAppend(variables.products, arguments.product);
		}
		if(isNew() or !arguments.product.hasVendor( this )) {
			arrayAppend(arguments.product.getVendors(), this);
		}
	}
	public void function removeProduct(required any product) {
		var thisIndex = arrayFind(variables.products, arguments.product);
		if(thisIndex > 0) {
			arrayDeleteAt(variables.products, thisIndex);
		}
		var thatIndex = arrayFind(arguments.product.getVendors(), this);
		if(thatIndex > 0) {
			arrayDeleteAt(arguments.product.getVendors(), thatIndex);
		}
	}
	
	// Brands (many-to-many - owner)
	public void function addBrand(required any brand) {
		if(arguments.brand.isNew() or !hasBrand(arguments.brand)) {
			arrayAppend(variables.brands, arguments.brand);
		}
		if(isNew() or !arguments.brand.hasVendor( this )) {
			arrayAppend(arguments.brand.getVendors(), this);
		}
	}
	public void function removeBrand(required any brand) {
		var thisIndex = arrayFind(variables.brands, arguments.brand);
		if(thisIndex > 0) {
			arrayDeleteAt(variables.brands, thisIndex);
		}
		var thatIndex = arrayFind(arguments.brand.getVendors(), this);
		if(thatIndex > 0) {
			arrayDeleteAt(arguments.brand.getVendors(), thatIndex);
		}
	}
	
	// =============  END:  Bidirectional Helper Methods ===================
	
	// ================== START: Overridden Methods ========================
	
	public any function getPrimaryEmailAddress() {
		if(!isNull(variables.primaryEmailAddress)) {
			return variables.primaryEmailAddress;
		} else if (arrayLen(getVendorEmailAddresses())) {
			setPrimaryEmailAddress(getVendorEmailAddresses()[1]);
			return getVendorEmailAddresses()[1];
		} else {
			return getService("vendorService").newVendorEmailAddress();
		}
	}
	
	public any function getPrimaryPhoneNumber() {
		if(!isNull(variables.primaryPhoneNumber)) {
			return variables.primaryPhoneNumber;
		} else if (arrayLen(getVendorPhoneNumbers())) {
			setPrimaryPhoneNumber(getVendorPhoneNumbers()[1]);
			return getVendorPhoneNumbers()[1];
		} else {
			return getService("vendorService").newVendorPhoneNumber();
		}
	}
	
	public any function getPrimaryAddress() {
		if(!isNull(variables.primaryAddress)) {
			return variables.primaryAddress;
		} else if (arrayLen(getVendorAddresses())) {
			setPrimaryAddress(getVendorAddresses()[1]);
			return getVendorAddresses()[1];
		} else {
			return getService("vendorService").newVendorAddress();
		}
	}
	
	// ==================  END:  Overridden Methods ========================
	
	// =================== START: ORM Event Hooks  =========================
	
	// ===================  END:  ORM Event Hooks  =========================
}
