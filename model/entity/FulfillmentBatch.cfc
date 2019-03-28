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
component displayname="Fulfillment Batch" entityname="SlatwallFulfillmentBatch" table="SwFulfillmentBatch" persistent="true" output="false" accessors="true" extends="HibachiEntity"cacheuse="transactional" hb_serviceName="fulfillmentService" hb_permission="this" {

	// Persistent Properties
	property name="fulfillmentBatchID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="description" ormtype="string" length="500";
	property name="fulfillmentBatchName" ormtype="string";
	property name="fulfillmentBatchNumber" ormtype="integer";

	// Related Object Properties (many-to-one)
	property name="assignedAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="accountID";
	
	// Related Object Properties (one-to-many)
	property name="fulfillmentBatchItems" singularname="fulfillmentBatchItem" cfc="FulfillmentBatchItem" fieldtype="one-to-many" fkcolumn="fulfillmentBatchID" cascade="all-delete-orphan" inverse="true";
	property name="pickWaves" singularname="pickWave" cfc="PickWave" fieldtype="one-to-many" fkcolumn="fulfillmentBatchID" cascade="all-delete-orphan" inverse="true";
	property name="stockAdjustments" singularname="stockAdjustment" cfc="StockAdjustment" fieldtype="one-to-many" fkcolumn="fulfillmentBatchID" inverse="true";
	
	// Related Object Properties (many-to-many - owner)
	property name="locations" singularname="location" cfc="Location" fieldtype="many-to-many" linktable="SwFulfillmentBatchLocation" fkcolumn="fulfillmentBatchID" inversejoincolumn="locationID";
	
	// Related Object Properties (many-to-many - inverse)
	
	// Audit Properties
	property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="createdByAccountID" hb_populateEnabled="false" ormtype="string";
	property name="modifiedDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="modifiedByAccountID" hb_populateEnabled="false" ormtype="string";
	
	//Non-persistent
	property name="totalQuantityOnBatch" persistent="false";
	property name="fulfillmentsCompletedTotal" persistent="false";
	
	// ============ START: Non-Persistent Property Methods =================

	// ============  END:  Non-Persistent Property Methods =================

	// ============= START: Bidirectional Helper Methods ===================
	// Assigned Account (many-to-one)
	public void function setAssignedAccount(required any account) {
		variables.assignedAccount = arguments.account;
		if(isNew() or !arguments.account.hasFulfillmentBatch( this )) {
			arrayAppend(arguments.account.getFulfillmentBatches(), this);
		}
	}
	
	public void function removeAssignedAccount(any account) {
		if(!structKeyExists(arguments, "account")) {
			arguments.account = variables.assignedAccount;
		}
		var index = arrayFind(arguments.account.getFulfillmentBatches(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.account.getFulfillmentBatches(), index);
		}
		structDelete(variables, "OrderDeliveryItem");
	}
	
	// Fulfillment Batch Items (one-to-many)
	public void function addFulfillmentBatchItem(required any fulfillmentBatchItem) {
		arguments.fulfillmentBatchItem.setFulfillmentBatch( this );
	}
	public void function removeFulfillmentBatchItem(required any fulfillmentBatchItem) {
		arguments.fulfillmentBatchItem.removeFulfillmentBatch( this );
	}
	
	// Pick Wave (one-to-many)
	public void function addPickWave(required any pickWave) {
	   arguments.pickWave.setFulfillmentBatch(this);
	}
	public void function removePickWave(required any pickWave) {
	   arguments.pickWave.removeFulfillmentBatch(this);
	}
	
	//The total number of fulfillments in this batch.
	public any function getTotalQuantityOnBatch() {
		var totalQuantityOnBatch = 0;
		for (fulfillmentItem in getFulfillmentBatchItems() ){
			totalQuantityOnBatch += (fulfillmentItem.getOrderFulfillment().getQuantityUnDelivered()+fulfillmentItem.getOrderFulfillment().getQuantityDelivered());
		}
		return totalQuantityOnBatch;
	}
	
	//The total number of fulfillments in this batch.
	public any function getFulfillmentsCompletedTotal() {
		var totalQuantityOnBatchCompleted = 0;
		for (fulfillmentItem in getFulfillmentBatchItems() ){
			totalQuantityOnBatchCompleted += fulfillmentItem.getOrderFulfillment().getQuantityDelivered();
		}
		return totalQuantityOnBatchCompleted;
	}
	
	// Locations (many-to-many - owner)
	public void function addLocation(required any location) {
		if(arguments.location.isNew() or !hasLocation(arguments.location)) {
			arrayAppend(variables.locations, arguments.location);
		}
		if(isNew() or !arguments.location.hasFulfillmentBatch( this )) {
			arrayAppend(arguments.location.getFulfillmentBatches(), this);
		}
	}
	
	public void function removeLocation(required any location) {
		var thisIndex = arrayFind(variables.locations, arguments.location);
		if(thisIndex > 0) {
			arrayDeleteAt(variables.locations, thisIndex);
		}
		var thatIndex = arrayFind(arguments.location.getFulfillmentBatches(), this);
		if(thatIndex > 0) {
			arrayDeleteAt(arguments.location.getFulfillmentBatches(), thatIndex);
		}
	}
	// =============  END:  Bidirectional Helper Methods ===================

	// ================== START: Overridden Methods ========================

	// ==================  END:  Overridden Methods ========================

	// =================== START: ORM Event Hooks  =========================

	// ===================  END:  ORM Event Hooks  =========================
}

