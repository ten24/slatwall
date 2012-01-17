/*

    Slatwall - An e-commerce plugin for Mura CMS
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
component displayname="Order Delivery Item" entityname="SlatwallOrderDeliveryItem" table="SlatwallOrderDeliveryItem" persistent="true" accessors="true" output="false" extends="BaseEntity" {
	
	// Persistent Properties
	property name="orderDeliveryItemID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="quantity" ormtype="integer";
	
	// Related Object Properties (many-to-one)
	property name="orderDelivery" cfc="OrderDelivery" fieldtype="many-to-one" fkcolumn="orderDeliveryID";
	property name="orderItem" cfc="OrderItem" fieldtype="many-to-one" fkcolumn="orderItemID";
	property name="stock" cfc="Stock" fieldtype="many-to-one" fkcolumn="stockID";
	
	// Related Object Properties (one-to-many)
	property name="referencingOrderItems" singularname="referencingOrderItem" cfc="OrderItem" fieldtype="one-to-many" fkcolumn="referencedOrderDeliveryItemID" inverse="true" cascade="all"; // Used For Returns
	
	// Non-Persistent Properties
	property name="quantityReturned" persistent="false";
	
	public numeric function getQuantityReturned() {
		if(!structKeyExists(variables, "quantityReturned")) {
			variables.quantityReturned = 0;
			for(var i=1; i<=arrayLen(getReferencingOrderItems()); i++) {
				variables.quantityReturned += getReferencingOrderItems()[i].getQuantity();
			}
		}
		return variables.quantityReturned;
	}
	
	// ============ START: Non-Persistent Property Methods =================
	
	// ============  END:  Non-Persistent Property Methods =================
	
	// ============= START: Bidirectional Helper Methods ===================
	
	// Order Delivery (many-to-one)
	public void function setOrderDelivery(required any orderDelivery) {
		variables.orderDelivery = arguments.orderDelivery;
		if(isNew() or !arguments.orderDelivery.hasOrderDeliveryItem( this )) {
			arrayAppend(arguments.orderDelivery.getOrderDeliveryItems(), this);
		}
	}
	public void function removeOrderDelivery(any orderDelivery) {
		if(!structKeyExists(arguments, "orderDelivery")) {
			arguments.orderDelivery = variables.orderDelivery;
		}
		var index = arrayFind(arguments.orderDelivery.getOrderDeliveryItems(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.account.getOrderDeliveryItems(), index);
		}
		structDelete(variables, "orderDelivery");
	}

	// Order Item (many-to-one)
	public void function setOrderItem(required any orderItem) {
		variables.orderItem = arguments.orderItem;
		if(isNew() or !arguments.orderItem.hasOrderDeliveryItem( this )) {
			arrayAppend(arguments.orderItem.getOrderDeliveryItems(), this);
		}
	}
	public void function removeOrderItem(any orderItem) {
		if(!structKeyExists(arguments, "orderItem")) {
			arguments.orderItem = variables.orderItem;
		}
		var index = arrayFind(arguments.orderItem.getOrderDeliveryItems(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.account.getOrderDeliveryItems(), index);
		}
		structDelete(variables, "orderItem");
	}
	
	// Referencing Order Items (one-to-many)
	public void function addReferencingOrderItem(required any referencingOrderItem) {
		arguments.referencingOrderItem.setReferencedOrderDeliveryItem( this );
	}
	public void function removeReferencingOrderItem(required any referencingOrderItem) {
		arguments.referencingOrderItem.removeReferencedOrderDeliveryItem( this );
	}
	
	// =============  END:  Bidirectional Helper Methods ===================
	
	// ================== START: Overridden Methods ========================
	
	// ==================  END:  Overridden Methods ========================
		
	// =================== START: ORM Event Hooks  =========================
	
	public void function preInsert(){
		super.preInsert();
		getService("inventoryService").createInventory( this );
	}
	
	public void function preUpdate(struct oldData){
		throw("Updates to Order Delivery Items are not allowed because this illustrates a fundamental flaw in inventory tracking.");
	}
	
	// ===================  END:  ORM Event Hooks  =========================
}
