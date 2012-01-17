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
component displayname="Vendor Order Item" entityname="SlatwallVendorOrderItem" table="SlatwallVendorOrderItem" persistent="true" accessors="true" output="false" extends="BaseEntity" {
	
	// Persistent Properties
	property name="vendorOrderItemID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="quantity" ormtype="integer" default=0;
	property name="cost" ormtype="big_decimal" formatType="currency";
	
	// Related Object Properties (Many-to-One)
	property name="vendorOrder" cfc="VendorOrder" fieldtype="many-to-one" fkcolumn="vendorOrderID";
	property name="stock" cfc="Stock" fieldtype="many-to-one" fkcolumn="stockID";
	
	// Related Object Properties (One-to-Many)
	property name="stockReceiverItems" singularname="stockReceiverItem" cfc="StockReceiverItem" type="array" fieldtype="one-to-many" fkcolumn="vendorOrderItemID" cascade="all-delete-orphan" inverse="true";
	
	// Audit properties
	property name="createdDateTime" ormtype="timestamp";
	property name="createdByAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="createdByAccountID";
	property name="modifiedDateTime" ormtype="timestamp";
	property name="modifiedByAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="modifiedByAccountID";
	
	// Non-persistant properties
	property name="extendedCost" persistent="false" formatType="currency";
	
	public any function init() {
		if(isNull(variables.stockReceiverItems)) {
			variables.stockReceiverItems = [];	
		}
	
		return super.init();
	}
	
	
	// Maintain bidirectional relationships (many-to-one). Notice that the child (VendorOrderItem) is the handler of the relationship, while the parent (VendorOrder), has inverse="true".
	public void function setVendorOrder(required any vendorOrder) {
	   variables.vendorOrder = arguments.vendorOrder;
	   if(isNew() or !arguments.vendorOrder.hasVendorOrderItem(this)) {
	       arrayAppend(arguments.vendorOrder.getVendorOrderItems(), this);
	   }
	}
	
	public void function removeVendorOrder() {
       var index = arrayFind(variables.vendorOrder.getVendorOrderItems(), this);
       if(index > 0) {
           arrayDeleteAt(variables.vendorOrder.getVendorOrderItems(), index);
       }
       structDelete(variables,"vendorOrder");
    }
    
    public numeric function getExtendedCost() {
		return getCost() * getQuantity();
	}
	
	// ============ START: Non-Persistent Property Methods =================
	
	// ============  END:  Non-Persistent Property Methods =================
		
	// ============= START: Bidirectional Helper Methods ===================
	
	// Stock Receiver Items (one-to-many)    
	public void function addStockReceiverItem(required any stockReceiverItem) {    
		arguments.stockReceiverItem.setVendorOrderItem( this );    
	}
	public void function removeStockReceiverItem(required any stockReceiverItem) {    
		arguments.stockReceiverItem.removeVendorOrderItem( this );    
	}
	
	// =============  END:  Bidirectional Helper Methods ===================
	
	// =================== START: ORM Event Hooks  =========================
	
	public void function preInsert(){
		super.preInsert();
		getService("skuCacheService").updateFromVendorOrderItem( this );
	}
	
	public void function preUpdate(struct oldData){
		super.preUpdate(argumentcollection=arguments);
		getService("skuCacheService").updateFromVendorOrderItem( this );
	}
	
	// ===================  END:  ORM Event Hooks  =========================
}
