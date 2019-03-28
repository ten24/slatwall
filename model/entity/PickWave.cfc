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
component displayname="Pickwave" entityname="SlatwallPickWave" table="SwPickWave" persistent="true" output="false" accessors="true" extends="HibachiEntity"cacheuse="transactional" hb_serviceName="fulfillmentService" hb_permission="this" {

	// Persistent Properties
	property name="pickWaveID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";

	// Related Object Properties (many-to-one)
	property name="fulfillmentBatch" cfc="FulfillmentBatch" fieldtype="many-to-one" fkcolumn="fulfillmentBatchID";
	property name="assignedAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="accountID";
	
	// Related Object Properties (one-to-many)
	property name="fulfillmentBatchItems" singularname="fulfillmentBatchItem" cfc="FulfillmentBatchItem" fieldtype="one-to-many" fkcolumn="pickWaveID" cascade="all-delete-orphan" inverse="true";
	
	// Related Object Properties (many-to-many - owner)
	property name="locations" singularname="location" cfc="Location" fieldtype="many-to-many" linktable="SwPickWaveLocation" fkcolumn="pickWaveID" inversejoincolumn="locationID";
	
	// Related Object Properties (many-to-many - inverse)
	
	// Audit Properties
	property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="createdByAccountID" hb_populateEnabled="false" ormtype="string";
	property name="modifiedDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="modifiedByAccountID" hb_populateEnabled="false" ormtype="string";

	// ============ START: Non-Persistent Property Methods =================

	// ============  END:  Non-Persistent Property Methods =================

	// ============= START: Bidirectional Helper Methods ===================
	// Fulfillment Batch (many-to-one)
	public void function setFulfillmentBatch(required any fulfillmentBatch) {
		variables.fulfillmentBatch = arguments.fulfillmentBatch;
		if(isNew() or !arguments.fulfillmentBatch.hasPickWave( this )) {
			arrayAppend(arguments.fulfillmentBatch.getPickWaves(), this);
		}
	}
	
	public void function removeFulfillmentBatch(any fulfillmentBatch) {
		if(!structKeyExists(arguments, "fulfillmentBatch")) {
			arguments.fulfillmentBatch = variables.fulfillmentBatch;
		}
		var index = arrayFind(arguments.fulfillmentBatch.getPickWaves(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.fulfillmentBatch.getPickWaves(), index);
		}
		structDelete(variables, "fulfillmentBatch");
	}
	
	// Assigned Account (many-to-one)
	public void function setAssignedAccount(required any account) {
		variables.assignedAccount = arguments.account;
		if(isNew() or !arguments.account.hasPickWave( this )) {
			arrayAppend(arguments.account.getPickWaves(), this);
		}
	}
	
	public void function removeAssignedAccount(any account) {
		if(!structKeyExists(arguments, "account")) {
			arguments.account = variables.assignedAccount;
		}
		var index = arrayFind(arguments.account.getPickWaves(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.account.getPickWaves(), index);
		}
		structDelete(variables, "assignedAccount");
	}
	
	// Fulfillment Batch Items (one-to-many)
	public void function addFulfillmentBatchItem(required any fulfillmentBatchItem) {
		arguments.fulfillmentBatchItem.setPickWave( this );
	}
	public void function removeFulfillmentBatchItem(required any fulfillmentBatchItem) {
		arguments.fulfillmentBatchItem.removePickWave( this );
	}
	
	// Location (many-to-many - inverse)
	public void function addLocation(required any location) {
		arguments.location.addPickWave( this );
	}
	public void function removelocation(required any location) {
		arguments.location.removePickWave( this );
	}

	// =============  END:  Bidirectional Helper Methods ===================

	// ================== START: Overridden Methods ========================

	// ==================  END:  Overridden Methods ========================

	// =================== START: ORM Event Hooks  =========================

	// ===================  END:  ORM Event Hooks  =========================
}

