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
component displayname="AccountLoyaltyTransaction" entityname="SlatwallAccountLoyaltyTransaction" table="SwAccountLoyaltyTransaction" persistent="true"  extends="HibachiEntity" cacheuse="transactional" hb_serviceName="accountService" hb_permission="account.accountLoyaltyTransaction" hb_processContext="create" {
	
	// Persistent Properties
	property name="accountLoyaltyTransactionID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="accruementType" ormType="string";
	property name="redemptionType" ormType="string";
	property name="pointsIn" ormType="integer";
	property name="pointsOut" ormType="integer";		
	property name="expirationDateTime" ormtype="timestamp";
	
	// Related Object Properties (many-to-one)
	property name="accountLoyalty" cfc="AccountLoyalty" fieldtype="many-to-one" fkcolumn="accountLoyaltyID";
	property name="loyaltyAccruement" cfc="LoyaltyAccruement" fieldtype="many-to-one" fkcolumn="loyaltyAccruementID";
	property name="loyaltyRedemption" cfc="LoyaltyRedemption" fieldtype="many-to-one" fkcolumn="loyaltyRedemptionID";
	property name="order" cfc="Order" fieldtype="many-to-one" fkcolumn="orderID";
	property name="orderItem" cfc="OrderItem" fieldtype="many-to-one" fkcolumn="orderItemID";
	property name="orderFulfillment" cfc="OrderFulfillment" fieldtype="many-to-one" fkcolumn="orderFulfillmentID";
	
	
	// Remote Properties
	property name="remoteID" ormtype="string";
	
	// Audit Properties
	property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="createdByAccountID" hb_populateEnabled="false" ormtype="string";
	property name="modifiedDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="modifiedByAccountID" hb_populateEnabled="false" ormtype="string";
	
	// Non-Persistent Properties
	
	// ============ START: Non-Persistent Property Methods =================
	
	public array function getAccruementTypeOptions() {
		return [
			{name=rbKey('entity.accountLoyaltyAccruement.accruementType.itemFulfilled'), value="itemFulfilled"},
			{name=rbKey('entity.accountLoyaltyAccruement.accruementType.orderClosed'), value="orderClosed"},
			{name=rbKey('entity.accountLoyaltyAccruement.accruementType.fulfillmentMethodUsed'), value="fulfillmentMethodUsed"},
			{name=rbKey('entity.accountLoyaltyAccruement.accruementType.enrollment'), value="enrollment"}
		];
	}
	
	public array function getRedemptionTypeOptions() {
		return [
			{name=rbKey('entity.accountLoyaltyAccruement.redemptionType.productPurchase'), value="productPurchase"},
			{name=rbKey('entity.accountLoyaltyAccruement.redemptionType.cashCouponCreation'), value="cashCouponCreation"},
			{name=rbKey('entity.accountLoyaltyAccruement.redemptionType.priceGroupAssignment'), value="priceGroupAssignment"}
		];
	}
	
	// ============  END:  Non-Persistent Property Methods =================
		
	// ============= START: Bidirectional Helper Methods ===================
	
	// Account Loyalty Program (many-to-one)
	public void function setAccountLoyalty(required any accountLoyalty) {
		variables.accountLoyalty = arguments.accountLoyalty;
		if(isNew() or !arguments.accountLoyalty.hasAccountLoyaltyTransaction( this )) {
			arrayAppend(arguments.accountLoyalty.getAccountLoyaltyTransactions(), this);
		}
	}
	public void function removeAccountLoyalty(any accountLoyalty) {
	   if(!structKeyExists(arguments, "accountLoyalty")) {
	   		arguments.accountLoyalty = variables.accountLoyalty;
	   }
       var index = arrayFind(arguments.accountLoyalty.getAccountLoyaltyTransactions(),this);
       if(index > 0) {
           arrayDeleteAt(arguments.accountLoyalty.getAccountLoyaltyTransactions(), index);
       }
       structDelete(variables,"accountLoyalty");
    }
    
    // Loyalty Program Accruement (many-to-one)
	public void function setLoyaltyAccruement(required any loyaltyAccruement) {
		variables.loyaltyAccruement = arguments.loyaltyAccruement;
		if(isNew() or !arguments.loyaltyAccruement.hasAccountLoyaltyTransaction( this )) {
			arrayAppend(arguments.loyaltyAccruement.getAccountLoyaltyTransactions(), this);
		}
	}
	public void function removeLoyaltyAccruement(any loyaltyAccruement) {
	   if(!structKeyExists(arguments, "loyaltyAccruement")) {
	   		arguments.loyaltyAccruement = variables.loyaltyAccruement;
	   }
       var index = arrayFind(arguments.loyaltyAccruement.getAccountLoyaltyTransactions(),this);
       if(index > 0) {
           arrayDeleteAt(arguments.loyaltyAccruement.getAccountLoyaltyTransactions(), index);
       }
       structDelete(variables,"loyaltyAccruement");
    }
    
 	// Loyalty Program Redemption (many-to-one) 
 	public void function setLoyaltyRedemption(required any loyaltyRedemption) { 
 		variables.loyaltyRedemption = arguments.loyaltyRedemption; 
 		if(isNew() or !arguments.loyaltyRedemption.hasAccountLoyaltyTransaction( this )) { 
 			arrayAppend(arguments.loyaltyRedemption.getAccountLoyaltyTransactions(), this); 
 		} 
 	} 
 	public void function removeLoyaltyRedemption(any loyaltyRedemption) { 
 		if(!structKeyExists(arguments, "loyaltyRedemption")) { 
 			arguments.loyaltyRedemption = variables.loyaltyRedemption; 
 		} 
 		var index = arrayFind(arguments.loyaltyRedemption.getAccountLoyaltyTransactions(), this); 
 		if(index > 0) { 
 			arrayDeleteAt(arguments.loyaltyRedemption.getAccountLoyaltyTransactions(), index); 
 		} 
 		structDelete(variables, "loyaltyRedemption"); 
 	}   
    
    // Order (many-to-one)
	public void function setOrder(required any order) {
		variables.order = arguments.order;
		if(isNew() or !arguments.order.hasAccountLoyaltyTransaction( this )) {
			arrayAppend(arguments.order.getAccountLoyaltyTransactions(), this);
		}
	}
	public void function removeOrder(any order) {
		if(!structKeyExists(arguments, "order")) {
			arguments.order = variables.order;
		}
		var index = arrayFind(arguments.order.getAccountLoyaltyTransactions(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.order.getAccountLoyaltyTransactions(), index);
		}
		structDelete(variables, "order");
	}
	
	// Order Item (many-to-one)
	public void function setOrderItem(required any orderItem) {
		variables.orderItem = arguments.orderItem;
		if(isNew() or !arguments.orderItem.hasAccountLoyaltyTransaction( this )) {
			arrayAppend(arguments.orderItem.getAccountLoyaltyTransactions(), this);
		}
	}
	public void function removeOrderItem(any orderItem) {
		if(!structKeyExists(arguments, "orderItem")) {
			arguments.orderItem = variables.orderItem;
		}
		var index = arrayFind(arguments.orderItem.getAccountLoyaltyTransactions(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.orderItem.getAccountLoyaltyTransactions(), index);
		}
		structDelete(variables, "orderItem");
	}
	
	// Order Fulfillment (many-to-one)
	public void function setOrderFulfillment(required any orderFulfillment) {
		variables.orderFulfillment = arguments.orderFulfillment;
		if(isNew() or !arguments.orderFulfillment.hasAccountLoyaltyTransaction( this )) {
			arrayAppend(arguments.orderFulfillment.getAccountLoyaltyTransactions(), this);
		}
	}
	public void function removeOrderFulfillment(any orderFulfillment) {
		if(!structKeyExists(arguments, "orderFulfillment")) {
			arguments.orderFulfillment = variables.orderFulfillment;
		}
		var index = arrayFind(arguments.orderFulfillment.getAccountLoyaltyTransactions(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.orderFulfillment.getAccountLoyaltyTransactions(), index);
		}
		structDelete(variables, "orderFulfillment");
	}
	
	// =============  END:  Bidirectional Helper Methods ===================

	// =============== START: Custom Validation Methods ====================
	
	// ===============  END: Custom Validation Methods =====================
	
	// =============== START: Custom Formatting Methods ====================
	
	// ===============  END: Custom Formatting Methods =====================
	
	// ============== START: Overridden Implicet Getters ===================
	
	// ==============  END: Overridden Implicet Getters ====================

	// ================== START: Overridden Methods ========================
	
	// ==================  END:  Overridden Methods ========================
	
	// =================== START: ORM Event Hooks  =========================
	
	// ===================  END:  ORM Event Hooks  =========================
	
	// ================== START: Deprecated Methods ========================
	
	// ==================  END:  Deprecated Methods ========================
}
