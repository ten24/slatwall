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
component displayname="Fulfillment Batch Item" entityname="SlatwallFulfillmentBatchItem" table="SwFulfillmentBatchItem" persistent="true" output="false" accessors="true" extends="HibachiEntity"cacheuse="transactional" hb_serviceName="fulfillmentService" hb_permission="this" {

	// Persistent Properties
	property name="fulfillmentBatchItemID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";

	property name="quantityOnBatch" ormtype="integer";
	property name="quantityPicked" ormtype="integer";
	property name="quantityFulfilled" ormtype="integer";

	// Related Object Properties (many-to-one)
	property name="stock" cfc="Stock" fieldtype="many-to-one" fkcolumn="stockID";
	property name="fulfillmentBatch" cfc="FulfillmentBatch" fieldtype="many-to-one" fkcolumn="fulfillmentBatchID";
	property name="orderItem" cfc="OrderItem" fieldtype="many-to-one" fkcolumn="orderItemID";
	property name="pickWave" cfc="PickWave" fieldtype="many-to-one" fkcolumn="pickWaveID";
	property name="orderFulfillment" cfc="OrderFulfillment" fieldtype="many-to-one" fkcolumn="orderFulfillmentID";
	property name="orderDeliveryItem" cfc="OrderDeliveryItem" fieldtype="many-to-one" fkcolumn="orderDeliveryItemID";
	
	// Related Object Properties (one-to-many)
	property name="comments" singularname="comment" cfc="Comment" type="array" fieldtype="one-to-many" fkcolumn="fulfillmentBatchItemID" cascade="all-delete-orphan" inverse="true";
	
	// Related Object Properties (many-to-many - owner)
	
	// Related Object Properties (many-to-many - inverse)
	
	// Audit Properties
	property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="createdByAccountID" hb_populateEnabled="false" ormtype="string";
	property name="modifiedDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="modifiedByAccountID" hb_populateEnabled="false" ormtype="string";

	// ============ START: Non-Persistent Property Methods =================

	// ============  END:  Non-Persistent Property Methods =================

	// ============= START: Bidirectional Helper Methods ===================
	// OrderDeliveryItem (many-to-one)
	public void function setOrderDeliveryItem(required any orderDeliveryItem) {
		variables.orderDeliveryItem = arguments.orderDeliveryItem;
		if(isNew() or !arguments.orderDeliveryItem.hasFulfillmentBatchItem( this )) {
			arrayAppend(arguments.orderDeliveryItem.getFulfillmentBatchItems(), this);
		}
	}
	
	public void function removeOrderDeliveryItem(any orderDeliveryItem) {
		if(!structKeyExists(arguments, "orderDeliveryItem")) {
			arguments.orderDeliveryItem = variables.orderDeliveryItem;
		}
		var index = arrayFind(arguments.orderDeliveryItem.getFulfillmentBatchItems(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.orderDeliveryItem.getFulfillmentBatchItems(), index);
		}
		structDelete(variables, "orderDeliveryItem");
	}
	
	// OrderFulfillment (many-to-one)
	public void function setOrderFulfillment(required any orderFulfillment) {
		variables.orderFulfillment = arguments.orderFulfillment;
		if(isNew() or !arguments.orderFulfillment.hasFulfillmentBatchItem( this )) {
			arrayAppend(arguments.orderFulfillment.getFulfillmentBatchItems(), this);
		}
	}
	
	public void function removeOrderFulfillment(any orderFulfillment) {
		if(!structKeyExists(arguments, "orderFulfillment")) {
			arguments.orderFulfillment = variables.orderFulfillment;
		}
		var index = arrayFind(arguments.orderFulfillment.getFulfillmentBatchItems(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.orderFulfillment.getFulfillmentBatchItems(), index);
		}
		structDelete(variables, "orderFulfillment");
	}
	
	// PickWave (many-to-one)
	public void function setPickWave(required any pickWave) {
		variables.pickWave = arguments.pickWave;
		if(isNew() or !arguments.pickWave.hasFulfillmentBatchItem( this )) {
			arrayAppend(arguments.pickWave.getFulfillmentBatchItems(), this);
		}
	}
	
	public void function removePickWave(any pickWave) {
		if(!structKeyExists(arguments, "pickWave")) {
			arguments.pickWave = variables.pickWave;
		}
		var index = arrayFind(arguments.pickWave.getFulfillmentBatchItems(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.pickWave.getFulfillmentBatchItems(), index);
		}
		structDelete(variables, "pickWave");
	}
	
	// OrderItem (many-to-one)
	public void function setOrderItem(required any orderItem) {
		variables.orderItem = arguments.orderItem;
		if(isNew() or !arguments.orderItem.hasFulfillmentBatchItem( this )) {
			arrayAppend(arguments.orderItem.getFulfillmentBatchItems(), this);
		}
	}
	
	public void function removeOrderItem(any orderItem) {
		if(!structKeyExists(arguments, "orderItem")) {
			arguments.orderItem = variables.orderItem;
		}
		var index = arrayFind(arguments.orderItem.getFulfillmentBatchItems(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.orderItem.getFulfillmentBatchItems(), index);
		}
		structDelete(variables, "orderItem");
	}
	
	// FulfillmentBatch (many-to-one)
	public void function setFulfillmentBatch(required any fulfillmentBatch) {
		variables.fulfillmentBatch = arguments.fulfillmentBatch;
		if(isNew() or !arguments.fulfillmentBatch.hasFulfillmentBatchItem( this )) {
			arrayAppend(arguments.fulfillmentBatch.getFulfillmentBatchItems(), this);
		}
	}
	
	public void function removeFulfillmentBatch(any fulfillmentBatch) {
		if(!structKeyExists(arguments, "FulfillmentBatch")) {
			arguments.fulfillmentBatch = variables.fulfillmentBatch;
		}
		var index = arrayFind(arguments.fulfillmentBatch.getFulfillmentBatchItems(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.fulfillmentBatch.getFulfillmentBatchItems(), index);
		}
		structDelete(variables, "fulfillmentBatch");
	}
	
	// Stock (many-to-one)
	public void function setStock(required any stock) {
		variables.stock = arguments.stock;
		if(isNew() or !arguments.stock.hasFulfillmentBatchItem( this )) {
			arrayAppend(arguments.stock.getFulfillmentBatchItems(), this);
		}
	}
	
	public void function removeStock(any stock) {
		if(!structKeyExists(arguments, "stock")) {
			arguments.account = variables.account;
		}
		var index = arrayFind(arguments.account.getAccountPaymentMethods(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.account.getFulfillmentBatchItems(), index);
		}
		structDelete(variables, "stock");
	}
	
	// Comments (one-to-many)
	public void function addComment(required any comment) {
		arguments.comment.setFulfillmentBatchItem( this );
	}
	public void function removeComment(required any comment) {
		arguments.comment.removeFulfillmentBatchItem( this );
	}
	
	// =============  END:  Bidirectional Helper Methods ===================

	// ================== START: Overridden Methods ========================

	// ==================  END:  Overridden Methods ========================

	// =================== START: ORM Event Hooks  =========================

	// ===================  END:  ORM Event Hooks  =========================
}

