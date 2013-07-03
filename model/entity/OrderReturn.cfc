/*

    Slatwall - An Open Source eCommerce Platform
    Copyright (C) 2011 ten24, LLC

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
    
    Linking this library statically or dynamically with other modules is
    making a combined work based on this library.  Thus, the terms and
    conditions of the GNU General Public License cover the whole
    combination.
 
    As a special exception, the copyright holders of this library give you
    permission to link this library with independent modules to produce an
    executable, regardless of the license terms of these independent
    modules, and to copy and distribute the resulting executable under
    terms of your choice, provided that you also meet, for each linked
    independent module, the terms and conditions of the license of that
    module.  An independent module is a module which is not derived from
    or based on this library.  If you modify this library, you may extend
    this exception to your version of the library, but you are not
    obligated to do so.  If you do not wish to do so, delete this
    exception statement from your version.

Notes:

*/
component displayname="Order Return" entityname="SlatwallOrderReturn" table="SlatwallOrderReturn" persistent=true accessors=true output=false extends="HibachiEntity" cacheuse="transactional" hb_serviceName="orderService" hb_permission="order.orderReturns" hb_processContexts="receiveReturn" {
	
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
	
	// Audit properties
	property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="createdByAccount" hb_populateEnabled="false" cfc="Account" fieldtype="many-to-one" fkcolumn="createdByAccountID";
	property name="modifiedDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="modifiedByAccount" hb_populateEnabled="false" cfc="Account" fieldtype="many-to-one" fkcolumn="modifiedByAccountID";
	
	
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
