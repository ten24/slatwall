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
component displayname="Account Loyalty Program" entityname="SlatwallAccountLoyalty" table="SwAccountLoyalty" persistent="true" accessors="true"  output="false" extends="HibachiEntity" cacheuse="transactional" hb_serviceName="accountService" hb_permission="account.accountLoyalties" hb_processContext="itemFulfilled,orderClosed,fulfillmentMethodUsed,enrollment,orderItemReceived,manualTransaction" {
	
	// Persistent Properties
	property name="accountLoyaltyID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="accountLoyaltyNumber" ormtype="string";

	// Related Object Properties (many-to-one)
	property name="account" cfc="Account" fieldtype="many-to-one" fkcolumn="accountID";
	property name="loyalty" cfc="Loyalty" fieldtype="many-to-one" fkcolumn="loyaltyID";
	
	// Related Object Properties (one-to-many)
	property name="accountLoyaltyTransactions" singularname="accountLoyaltyTransaction" type="array" fieldtype="one-to-many" fkcolumn="accountLoyaltyID" cfc="AccountLoyaltyTransaction" cascade="all-delete-orphan" inverse="true";
	
	// Remote Properties
	property name="remoteID" ormtype="string";
	
	// Audit Properties
	property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="createdByAccountID" hb_populateEnabled="false" ormtype="string";
	property name="modifiedDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="modifiedByAccountID" hb_populateEnabled="false" ormtype="string";
	
	// Non-Persistent Properties
	property name="lifetimeBalance" persistent="false";

	
	// ============ START: Non-Persistent Property Methods =================
	
	public any function getLifetimeBalance() {

		if( !structKeyExists(variables, "lifetimeBalance") ) {
			variables.lifetimeBalance = 0;
			
			// Loop over all the loyalty transactions of the account
			for( var loyaltyTransaction in this.getAccountLoyaltyTransactions() ) {
				var pointsIn = 0;
				var pointsOut = 0;
				
				if ( !isNull( loyaltyTransaction.getPointsIn() )) { 
					pointsIn = loyaltyTransaction.getPointsIn(); 
				}
				
				if ( !isNull( loyaltyTransaction.getPointsOut() )) { 
					pointsOut = loyaltyTransaction.getPointsOut(); 
				}
				
				// check expiration date and exclude expired points
				if (!isNull( loyaltyTransaction.getExpirationDateTime() )) {				
				 	if ( loyaltyTransaction.getExpirationDateTime() gt now() )  {
						variables.lifetimeBalance = getService('HibachiUtilityService').precisionCalculate(variables.lifetimeBalance + pointsIn - pointsOut);	
					}
				}
				else {
					variables.lifetimeBalance = getService('HibachiUtilityService').precisionCalculate(variables.lifetimeBalance + pointsIn - pointsOut);
				}
			}
		}

		return variables.lifetimeBalance;
	}
	
	// ============  END:  Non-Persistent Property Methods =================
		
	// ============= START: Bidirectional Helper Methods ===================
	
	// Account Loyalty Programs Transactions (one-to-many)
	public void function addAccountLoyaltyTransaction(required any accountLoyaltyTransaction) {    
		arguments.accountLoyaltyTransaction.setAccountLoyalty( this );    
	}    
	public void function removeAccountLoyaltyTransaction(required any accountLoyaltyTransaction) {    
		arguments.accountLoyaltyTransaction.removeAccountLoyalty( this );    
	}
	
	// Account (many-to-one)
	public void function setAccount(required any account) {
		variables.account = arguments.account;
		if(isNew() or !arguments.account.hasAccountLoyalty( this )) {
			arrayAppend(arguments.account.getAccountLoyalties(), this);
		}
	}
	
	public void function removeAccount(any account) {
		if(!structKeyExists(arguments, "account")) {
			arguments.account = variables.account;
		}
		var index = arrayFind(arguments.account.getAccountLoyalties(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.account.getAccountLoyalties(), index);
		}
		structDelete(variables, "account");
	}
	
	// Loyalty Program (many-to-one)
	public void function setLoyalty(required any loyalty) {
		variables.loyalty = arguments.loyalty;
		if(isNew() or !arguments.loyalty.hasAccountLoyalty( this )) {
			arrayAppend(arguments.loyalty.getAccountLoyalties(), this);
		}
	}
	public void function removeLoyalty(any loyalty) {
		if(!structKeyExists(arguments, "loyalty")) {
			arguments.loyalty = variables.loyalty;
		}
		var index = arrayFind(arguments.loyalty.getAccountLoyalties(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.loyalty.getAccountLoyalties(), index);
		}
		structDelete(variables, "loyalty");
	}
	
	// =============  END:  Bidirectional Helper Methods ===================

	// =============== START: Custom Validation Methods ====================
	
	// ===============  END: Custom Validation Methods =====================
	
	// =============== START: Custom Formatting Methods ====================
	
	// ===============  END: Custom Formatting Methods =====================
	
	// ============== START: Overridden Implicet Getters ===================
	
	// ==============  END: Overridden Implicet Getters ====================

	// ================== START: Overridden Methods ========================
	
	public string function getSimpleRepresentation() {
		var simpleRep = getLoyalty().getLoyaltyName();
		
		if( len(getAccountLoyaltyNumber()) ){
			simpleRep = simpleRep & " - " & getAccountLoyaltyNumber();
		}
		return simpleRep;
	}
	
	// ==================  END:  Overridden Methods ========================
	
	// =================== START: ORM Event Hooks  =========================
	
	// ===================  END:  ORM Event Hooks  =========================
	
	// ================== START: Deprecated Methods ========================
	
	// ==================  END:  Deprecated Methods ========================
}