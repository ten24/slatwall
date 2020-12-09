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
component displayname="Gift Card" entityname="SlatwallGiftCard" table="SwGiftCard" persistent="true" accessors="true" extends="HibachiEntity" cacheuse="transactional" hb_serviceName="giftCardService" {

	// Persistent Properties
	property name="giftCardID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="giftCardCode" ormtype="string";
	property name="giftCardPin" ormtype="string";
	property name="expirationDate" ormtype="timestamp";
	property name="ownerFirstName" ormtype="string";
	property name="ownerLastName" ormtype="string";
	property name="ownerEmailAddress" ormtype="string";
    property name="activeFlag" ormtype="boolean";
    property name="issuedDate" ormtype="timestamp";
    property name="currencyCode" ormtype="string" length="3";
    //Calculated Properties
    property name="calculatedBalanceAmount" ormtype="big_decimal" hb_formatType="currency";

    //non-persistent properties
    property name="balanceAmount" persistent="false" hb_formatType="currency";

	// Related Object Properties (many-to-one)
	property name="originalOrderItem" cfc="OrderItem" fieldtype="many-to-one" fkcolumn="originalOrderItemID" cascade="all";
	property name="giftCardExpirationTerm" cfc="Term" fieldtype="many-to-one" fkcolumn="giftCardExpirationTermID" cascade="all";
	property name="ownerAccount" cfc="Account" fieldtype="many-to-one" fkcolumn="ownerAccountID";
    property name="orderItemGiftRecipient" cfc="OrderItemGiftRecipient" fieldtype="many-to-one" fkcolumn="orderItemGiftRecipientID" inverse="true" cascade="all";

	// Related Object Properties (one-to-many)
	property name="giftCardTransactions" singularname="giftCardTransaction" cfc="GiftCardTransaction" fieldtype="one-to-many" fkcolumn="giftCardID" inverse="true" cascade="all-delete-orphan";

	// Related Object Properties (many-to-many)

	// Remote Properties
	property name="remoteID" ormtype="string";

	// Audit Properties
	property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="createdByAccountID" hb_populateEnabled="false" ormtype="string";
	property name="modifiedDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="modifiedByAccountID" hb_populateEnabled="false" ormtype="string";


	// Non-Persistent Properties
	public any function getOrder(){
		if(!isNull(this.getOriginalOrderItem())){
			return this.getOriginalOrderItem().getOrder();
		} else {
			return false;
		}
	}

	public boolean function isExpired(){
		if(getService("SettingService").getSettingValue("skuGiftCardEnforceExpirationTerm")){
			if(!isNull(this.getExpirationDate())){
				return !dateCompare(this.getExpirationDate(), now()) == 1;
			}
		}
		return false;
	}

	public boolean function canEditOrDelete(){
		if(!isNull(this.getActiveFlag())||this.getActiveFlag()){
			return false;
		} else {
			return true;
		}
	}

	public numeric function getBalanceAmount(){
		var transactions = this.getGiftCardTransactions();
		var balance = 0;
		for(var transaction in transactions){
			if(!isNull(transaction.getCreditAmount())){
				balance = getService('HibachiUtilityService').precisionCalculate(balance + transaction.getCreditAmount());
			} else if(!isNull(transaction.getDebitAmount())){
				balance = getService('HibachiUtilityService').precisionCalculate(balance - transaction.getDebitAmount());
			}
		}
		return balance;
	}

	public string function getEmailAddress(){
		if(!isNull(this.getOwnerAccount())){
			return this.getOwnerAccount().getEmailAddress();
		} else {
			return this.getOwnerEmailAddress();
		}
	}

	public boolean function hasEmailBounce(){
		return getDAO("EmailBounceDAO").rejectedEmailExists(this.getOrderItemGiftRecipient().getEmailAddress());
	}

	// ============ START: Non-Persistent Property Methods =================

	// ============  END:  Non-Persistent Property Methods =================

	// ============= START: Bidirectional Helper Methods ===================


    // Order Item Gift Recipient (many-to-one)
	public void function setOrderItemGiftRecipient(required any orderItemGiftRecipient) {
		variables.orderItemGiftRecipient = arguments.orderItemGiftRecipient;
		if(isNew() or !arguments.orderItemGiftRecipient.hasGiftCard( this )) {
			arrayAppend(arguments.orderItemGiftRecipient.getGiftCards(), this);
		}
	}

	public void function removeOrderItemGiftRecipient(any orderItemGiftRecipient) {
		if(!structKeyExists(arguments, "orderItem")) {
			arguments.orderItem = variables.orderItem;
		}
		var index = arrayFind(arguments.orderItemGiftRecipient.getGiftCards(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.orderItemGiftRecipient.getGiftCards(), index);
		}
		structDelete(variables, "orderItemGiftRecipient");
	}

	// Original Order Item (Many-To-One)
	public void function setOriginalOrderItem(required any orderItem) {
		variables.originalOrderItem = arguments.orderItem;
		if(isNew() or !arguments.orderItem.hasGiftCard( this )) {
			arrayAppend(arguments.orderItem.getGiftCards(), this);
		}
	}
	public void function removeOriginalOrderItem(any orderItem) {
		if(!structKeyExists(arguments, "orderItem")) {
			arguments.orderItem = variables.originalOrderItem;
		}
		var index = arrayFind(arguments.orderItem.getGiftCards(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.orderItem.getGiftCards(), index);
		}
		structDelete(variables, "originalOrderItem");
	}

	// Owner Account (many-to-one)
	public void function setOwnerAccount(required any ownerAccount) {

		variables.ownerAccount = arguments.ownerAccount;
		if(isNew() or !arguments.ownerAccount.hasGiftCard( this )) {
			arrayAppend(arguments.ownerAccount.getGiftCards(), this);
		}
	}
	public void function removeOwnerAccount(any ownerAccount) {
		if(!structKeyExists(arguments, "ownerAccount")) {
			arguments.ownerAccount = variables.ownerAccount;
		}
		var index = arrayFind(arguments.ownerAccount.getGiftCards(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.ownerAccount.getGiftCards(), index);
		}
		structDelete(variables, "ownerAccount");
	}

	// Gift Card Transactions (one-to-many)
	public void function addGiftCardTransaction(required any giftCardTransaction){
		arguments.giftCardTransaction.setGiftCard( this );
	}

	public void function removeGiftCardTransaction(required any giftCardTransaction){
		arguments.giftCardTransaction.removeGiftCard( this );
	}

	// =============  END:  Bidirectional Helper Methods ===================

	// =============== START: Custom Validation Methods ====================

	// ===============  END: Custom Validation Methods =====================

	// =============== START: Custom Formatting Methods ====================

	// ===============  END: Custom Formatting Methods =====================

	// ============== START: Overridden Implicet Getters ===================

	// ==============  END: Overridden Implicet Getters ====================

	// ================== START: Overridden Methods ========================

	public string function getSimpleRepresentation()
	{
		return nullReplace(this.getOwnerFirstName(),"") & ' '
			 & nullReplace(this.getOwnerLastName(),"")
			 & ' - ' & nullReplace(this.getEmailAddress(),"")
			 & ' ( ' & formatValue(nullReplace(this.getBalanceAmount(),0),"currency") & ' ) ';
 	}

	// ==================  END:  Overridden Methods ========================

	// =================== START: ORM Event Hooks  =========================

	// ===================  END:  ORM Event Hooks  =========================

	// ================== START: Deprecated Methods ========================

	// ==================  END:  Deprecated Methods ========================
}
