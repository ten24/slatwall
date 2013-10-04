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
component entityname="SlatwallEventRegistration" table="SwEventRegistration" persistent="true" accessors="true" extends="HibachiEntity" cacheuse="transactional" hb_serviceName="eventRegistrationService" hb_permission="this" {
	
	// Persistent Properties
	property name="eventRegistrationID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="firstName";
	property name="lastName";
	property name="emailAddress";
	property name="phoneNumber";
	
	// Related Object Properties (many-to-one)
	property name="orderItem" cfc="OrderItem" fieldtype="many-to-one" fkcolumn="orderItemID";
	property name="account" cfc="Account" fieldtype="many-to-one" fkcolumn="accountID";
	property name="eventRegistrationStatusType" cfc="Type" fieldtype="many-to-one" fkcolumn="eventRegistrationStatusTypeID" hb_optionsSmartListData="f:parentType.systemCode=eventRegistrationStatusType";
	
	// Related Object Properties (one-to-many)
	
	// Related Object Properties (many-to-many)
	
	// Remote Properties
	property name="remoteID" ormtype="string";
	
	// Audit Properties
	property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="createdByAccount" hb_populateEnabled="false" cfc="Account" fieldtype="many-to-one" fkcolumn="createdByAccountID";
	property name="modifiedDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="modifiedByAccount" hb_populateEnabled="false" cfc="Account" fieldtype="many-to-one" fkcolumn="modifiedByAccountID";
	
	// Non-Persistent Properties
	property name="productName"  persistent="false";
	
	// ==================== START: Logical Methods =========================
	
	// ====================  END: Logical Methods ==========================
	
	// ============ START: Non-Persistent Property Methods =================
	
	public string function getProductName() {
		return orderItem.getsku().getproduct().getproductName();
	}
	
	// ============  END:  Non-Persistent Property Methods =================
		
	// ============= START: Bidirectional Helper Methods ===================
	
	// =============  END:  Bidirectional Helper Methods ===================

	// =============== START: Custom Validation Methods ====================
	
	// ===============  END: Custom Validation Methods =====================
	
	// =============== START: Custom Formatting Methods ====================
	
	// ===============  END: Custom Formatting Methods =====================
	
	// ============== START: Overridden Implicit Getters ===================
	
	public any function getEventRegistrationStatusType() {
		if(isNull(variables.eventRegistrationStatusType)) {
			// Needs to change to something like 'erstRegistrationNotPlaced'
			variables.eventRegistrationStatusType = getService("settingService").getTypeBySystemCode('erstRegistrationClosed');
		}
		return variables.eventRegistrationStatusType;
	}
	
	public any function getFirstName() {
		if(!isNull(getAccount())) {
			variables.firstName = javaCast("null", "");
			return getAccount().getFirstName();
		}
		if(structKeyExists(variables, "firstName")) {
			return variables.firstName;
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
		var simpleRep = "#getOrderItem().getSku().getProduct().getProductName()# - #getOrderItem().getSku().getSkuDefinition()# - (#getOrderItem().getSku().getFormattedValue('eventStartDateTime')# - #getOrderItem().getSku().getFormattedValue('eventEndDateTime')#)";
		
		return simpleRep;
	}
	
	// ==================  END:  Overridden Methods ========================
	
	// =================== START: ORM Event Hooks  =========================
	
	// ===================  END:  ORM Event Hooks  =========================
	
	// ================== START: Deprecated Methods ========================
	
	// ==================  END:  Deprecated Methods ========================
}
