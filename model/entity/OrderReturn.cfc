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
component displayname="Order Return" entityname="SlatwallOrderReturn" table="SwOrderReturn" persistent=true accessors=true output=false extends="HibachiEntity" cacheuse="transactional" hb_serviceName="orderService" hb_permission="order.orderReturns" hb_processContexts="receiveReturn,receive" {
	
	// Persistent Properties
	property name="orderReturnID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="fulfillmentRefundAmount" ormtype="big_decimal";
	property name="currencyCode" ormtype="string" length="3";
	
	// Related Object Properties (many-to-one)
	property name="order" cfc="Order" fieldtype="many-to-one" fkcolumn="orderID";
	property name="returnLocation" hb_populateEnabled="public" cfc="Location" fieldtype="many-to-one" fkcolumn="returnLocationID";
	
	// Related Object Properties (one-to-many)
	property name="orderReturnItems" hb_populateEnabled="public" singularname="orderReturnItem" cfc="OrderItem" fieldtype="one-to-many" fkcolumn="orderReturnID" cascade="all" inverse="true";
	
	// Remote properties
	property name="remoteID" ormtype="string";
	
	// Audit Properties
	property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="createdByAccountID" hb_populateEnabled="false" ormtype="string";
	property name="modifiedDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="modifiedByAccountID" hb_populateEnabled="false" ormtype="string";
	
	
	// ============ START: Non-Persistent Property Methods =================
	
	// ============  END:  Non-Persistent Property Methods =================
		
	// ============= START: Bidirectional Helper Methods ===================
	
	// Order (many-to-one)
	public void function setOrder(required any order) {
		variables.order = arguments.order;
		if(isNew() or !arguments.order.hasOrderReturn( this )) {
			arrayAppend(arguments.order.getOrderReturns(), this);
		}
	}
	public void function removeOrder(any order) {
		if(!structKeyExists(arguments, "order")) {
			arguments.order = variables.order;
		}
		var index = arrayFind(arguments.order.getOrderReturns(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.order.getOrderReturns(), index);
		}
		structDelete(variables, "order");
	}
	
	// Order Return Items (one-to-many)
	public void function addOrderReturnItem(required any orderReturnItem) {
		arguments.orderReturnItem.setOrderReturn( this );
	}
	public void function removeOrderReturnItem(required any orderReturnItem) {
		arguments.orderReturnItem.removeOrderReturn( this );
	}
	
	// =============  END:  Bidirectional Helper Methods ===================
	
	// ================== START: Overridden Methods ========================
	
	public numeric function getFulfillmentRefundAmount() {
		if(!structKeyExists(variables, "fulfillmentRefundAmount")) {
			variables.fulfillmentRefundAmount = 0;
		}
		return variables.fulfillmentRefundAmount;
	}
	
	public string function getSimpleRepresentation() {
		return getOrder().getOrderNumber() & " - " & getReturnLocation().getLocationName();
	}
	
	// ==================  END:  Overridden Methods ========================
	
	// =================== START: ORM Event Hooks  =========================
	
	// ===================  END:  ORM Event Hooks  =========================
}

