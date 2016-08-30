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
component entityname="SlatwallEventRegistration" table="SwEventRegistration" persistent="true" accessors="true" extends="HibachiEntity" cacheuse="transactional" hb_serviceName="eventRegistrationService" hb_permission="this" hb_processContexts="approve,attend,cancel,confrm,exire,pending,register,waitlist" {

	// Persistent Properties
	property name="eventRegistrationID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="firstName" ormtype="string" hb_populateEnabled="public" ;
	property name="lastName" ormtype="string" hb_populateEnabled="public" ;
	property name="emailAddress" ormtype="string" hb_populateEnabled="public" ;
	property name="phoneNumber" ormtype="string" ;
	property name="waitlistQueueDateTime" ormtype="timestamp" hb_formatType="dateTime" hint="Datetime registrant was added to waitlist.";
	property name="pendingClaimDateTime" ormtype="timestamp" hb_formatType="dateTime" hint="Datetime registrant was changed to pending claim.";
	property name="registrantAttendanceCode" ormtype="string" unique="true" length="8" hint="Unique code to track registrant attendance";


	// Related Object Properties (many-to-one)
	property name="orderItem" cfc="OrderItem" fieldtype="many-to-one" fkcolumn="orderItemID";
	property name="sku" cfc="Sku" fieldtype="many-to-one" fkcolumn="skuID";
	property name="account" cfc="Account" fieldtype="many-to-one" fkcolumn="accountID";
	property name="eventRegistrationStatusType" cfc="Type" fieldtype="many-to-one" fkcolumn="eventRegistrationStatusTypeID" hb_optionsSmartListData="f:parentType.systemCode=eventRegistrationStatusType";

	// Related Object Properties (one-to-many)
	property name="attributeValues" singularname="attributeValue" cfc="AttributeValue" fieldtype="one-to-many" fkcolumn="eventRegistrationID" inverse="true" cascade="all-delete-orphan";
	
	// Related Object Properties (many-to-many)

	// Remote Properties
	property name="remoteID" ormtype="string";

	// Audit Properties
	property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="createdByAccountID" hb_populateEnabled="false" ormtype="string";
	property name="modifiedDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="modifiedByAccountID" hb_populateEnabled="false" ormtype="string";

	// Non-Persistent Properties
	property name="productName"  persistent="false";
	property name="attendedFlag"  persistent="false";
	property name="registrationStatusTitle"  persistent="false";
	property name="waitlistQueuePositionStruct" persistent="false";


	// ==================== START: Logical Methods =========================

	public boolean function getAttendedFlag() {
		if(eventRegistrationStatusType.getSystemCode() == "erstAttended") {
			return true;
		}
		return false;
	}

	public any function getWaitlistQueuePositionStruct(){
		//get the waitlist
		try {
			var waitlistedRegistrants = getService('eventRegistrationService').getWaitlistedRegistrants(this.getOrderItem().getSku());
			var position = 1;
			//loop over all waitlistedRegistrants registrants
			for(var waitlistedRegistrant in waitlistedRegistrants){
			//base case: if we find this id in the list, return the position.
				if(waitlistedRegistrant.getEventRegistrationID() == this.getEventRegistrationID()){
					return position;
				}
				position++;
			}
			return -1; //not found in the list
		} catch (any error){
			return -1; //error occured.
		}
	}

	public string function getRegistrationStatusTitle() {
		if(!structKeyExists(variables,"registrationStatusTitle")) {
			variables.registrationStatusTitle = this.getEventRegistrationStatusType().getTypeName();
		}
		return variables.registrationStatusTitle;
	}

	//@hint Generates a unique attendance code and sets it as this registrant's code
	public string function generateAndSetAttendanceCode() {
		var uniq = false;
		var code = "";
		do {
			code = getService("EventRegistrationService").generateAttendanceCode(8);
			if(codeIsUnique(code)) {
				uniq = true;
			}
		} while (uniq == false);
		this.setRegistrantAttendanceCode(code);
		return code;
	}

	// @hint Used to determine uniqueness of generated attendance code
	private boolean function codeIsUnique(required string code) {
		var result = false;
		var smartList =  getService("EventRegistrationService").getEventRegistrationSmartList();
		smartList.addFilter("registrantAttendanceCode",arguments.code);
		if(smartList.getRecordsCount > 0) {
			result = true;
		}
		return result;
	}

	// ====================  END: Logical Methods ==========================

	// ============ START: Non-Persistent Property Methods =================

	public string function getProductName() {
		return orderItem.getsku().getproduct().getproductName();
	}

	// ============  END:  Non-Persistent Property Methods =================

	// ============= START: Bidirectional Helper Methods ===================
	
 	// Order Item (many-to-one)    
  	public void function setOrderItem(required any orderItem) {    
  		variables.orderItem = arguments.orderItem;    
  		if(isNew() or !arguments.orderItem.hasEventRegistration( this )) {    
  			arrayAppend(arguments.orderItem.getEventRegistrations(), this);    
  		}    
  	}    
  	public void function removeOrderItem(any orderItem) {    
  		if(!structKeyExists(arguments, "orderItem")) {    
  			arguments.orderItem = variables.orderItem;    
  		}    
  		var index = arrayFind(arguments.orderItem.getEventRegistrations(), this);    
  		if(index > 0) {    
  			arrayDeleteAt(arguments.orderItem.getEventRegistrations(), index);    
  		}    
  		structDelete(variables, "orderItem");    
  	}
  	
  	// Sku (many-to-one)    
  	public void function setSku(required any sku) {    
  		variables.sku = arguments.sku;    
  		if(isNew() or !arguments.sku.hasEventRegistration( this )) {    
  			arrayAppend(arguments.sku.getEventRegistrations(), this);    
  		}    
  	}    
  	public void function removeSku(any sku) {    
  		if(!structKeyExists(arguments, "sku")) {    
  			arguments.sku = variables.sku;    
  		}    
  		var index = arrayFind(arguments.sku.getEventRegistrations(), this);    
  		if(index > 0) {    
  			arrayDeleteAt(arguments.sku.getEventRegistrations(), index);    
  		}    
  		structDelete(variables, "sku");    
  	}
  	
  	// Account (many-to-one)    
  	public void function setAccount(required any account) {    
  		variables.account = arguments.account;    
  		if(isNew() or !arguments.account.hasEventRegistration( this )) {    
  			arrayAppend(arguments.account.getEventRegistrations(), this);    
  		}    
  	}    
  	public void function removeAccount(any account) {    
  		if(!structKeyExists(arguments, "account")) {    
  			arguments.account = variables.account;    
  		}    
  		var index = arrayFind(arguments.account.getEventRegistrations(), this);    
  		if(index > 0) {    
  			arrayDeleteAt(arguments.account.getEventRegistrations(), index);    
  		}    
  		structDelete(variables, "account");    
  	}
  	
  	// Attribute Values (one-to-many)
 	public void function addAttributeValue(required any attributeValue) {
 		arguments.attributeValue.setEventRegistration( this );
 	}
 	public void function removeAttributeValue(required any attributeValue) {
 		arguments.attributeValue.removeEventRegistration( this );
 	}


	// =============  END:  Bidirectional Helper Methods ===================

	// =============== START: Custom Validation Methods ====================

	// ===============  END: Custom Validation Methods =====================

	// =============== START: Custom Formatting Methods ====================

	// ===============  END: Custom Formatting Methods =====================

	// ============== START: Overridden Implicit Getters ===================


	public any function getFirstName() {
		if(!isNull(getAccount())) {
			variables.firstName = javaCast("null", "");
			return getAccount().getFirstName();
		}
		if(structKeyExists(variables, "firstName")) {
			return variables.firstName;
		}
	}

	public any function getLastName() {
		if(!isNull(getAccount())) {
			variables.lastName = javaCast("null", "");
			return getAccount().getLastName();
		}
		if(structKeyExists(variables, "lastName")) {
			return variables.lastName;
		}
	}

	public any function getEmailAddress() {
		if(!isNull(getAccount())) {
			variables.emailAddress = javaCast("null","" );
			return getAccount().getPrimaryEmailAddress().getEmailAddress();
		}
		if(structKeyExists(variables,"emailAddress")) {
			return variables.emailAddress;
		}
	}

	public any function getPhoneNumber() {
		if(!isNull(getAccount())) {
			variables.phoneNumber = javaCast("null", "");
			return getAccount().getPrimaryPhoneNumber();
		}
		if(structKeyExists(variables, "phoneNumber")) {
			return variables.phoneNumber;
		}
	}


	// ==============  END: Overridden Implicit Getters ====================

	// ============= START: Overridden Smart List Getters ==================

	// =============  END: Overridden Smart List Getters ===================

	// ================== START: Overridden Methods ========================

	public string function getSimpleRepresentation() {
		var simpleRep = "";
		if(!isNull(getFirstName())) {
			simpleRep = listAppend(simpleRep, getFirstName(), " ");
		}
		if(!isNull(getLastName())) {
			simpleRep = listAppend(simpleRep, getLastName(), " ");
		}
		if(len(simpleRep)) {
			simpleRep &= ": ";
		}
		var simpleRep = "#getSku().getProduct().getProductName()# - #getSku().getSkuDefinition()# - (#getSku().getFormattedValue('eventStartDateTime')# - #getSku().getFormattedValue('eventEndDateTime')#)";

		return simpleRep;
	}

	public string function getSimpleRepresentationName() {
		return "eventRegistrationID";
	}

	// ==================  END:  Overridden Methods ========================

	// =================== START: ORM Event Hooks  =========================

	// ===================  END:  ORM Event Hooks  =========================

	// ================== START: Deprecated Methods ========================

}