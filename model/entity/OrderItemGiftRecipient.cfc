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
component displayname="Gift Recipient" entityname="SlatwallOrderItemGiftRecipient" table="SwOrderItemGiftRecipient" persistent="true" accessors="true" extends="HibachiEntity" cacheuse="transactional" {

	// Persistent Properties
	property name="orderItemGiftRecipientID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="firstName" ormtype="string" hb_populateEnabled="public";
	property name="lastName" ormtype="string" hb_populateEnabled="public";
	property name="emailAddress" ormtype="string" hb_populateEnabled="public";
	property name="quantity" ormtype="integer" hb_populateEnabled="public";
	property name="giftMessage" ormtype="string" length="4000" hb_populateEnabled="public";

	// Related Object Properties (many-to-one)
	property name="orderItem" cfc="OrderItem" fieldtype="many-to-one" fkcolumn="orderItemID";
	property name="account" cfc="Account" fieldtype="many-to-one" fkcolumn="accountID";

	// Related Object Properties (one-to-many)
    property name="giftCards" singularname="giftCard" cfc="GiftCard" fieldtype="one-to-many" fkcolumn="orderItemGiftRecipientID" cascade="all-delete-orphan";

	// Related Object Properties (many-to-many)

	// Remote Properties
	property name="remoteID" ormtype="string";

	// Audit Properties
	property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="createdByAccountID" hb_populateEnabled="false" ormtype="string";
	property name="modifiedDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="modifiedByAccountID" hb_populateEnabled="false" ormtype="string";

	// Non-Persistent Properties

	// ============ START: Non-Persistent Property Methods =================

    public boolean function hasAllAssignedGiftCards(){
        if(arrayLen(this.getGiftCards()) == this.getQuantity()){
            return true;
        } else {
            return false;
        }
    }

	//May only edit or delete recipient if all attached cards are eligible for this action
    public boolean function canEditOrDelete(){
    	for(var card in this.getGiftCards()){
    		if(!card.canEditOrDelete()){
    			return false;
    		}
    	}
    	return true;
   	}

    public numeric function getNumberOfUnassignedGiftCards(){
        return this.getQuantity() - arrayLen(this.getGiftCards());
    }

    public boolean function hasCorrectGiftMessageLength(){
        return getService("HibachiValidationService").validate_maxLength(this, "giftMessage", getService("SettingService").getSettingValue("globalGiftCardMessageLength"));
    }

	// ============  END:  Non-Persistent Property Methods =================

	// ============= START: Bidirectional Helper Methods ===================

	// Order Item (many-to-one)

	public void function setOrderItem(required any orderItem) {
		variables.orderItem = arguments.orderItem;
		if(isNew() or !arguments.orderItem.hasOrderItemGiftRecipient( this )) {
			arrayAppend(arguments.orderItem.getOrderItemGiftRecipients(), this);
		}
	}

	public void function removeOrderItem(any orderItem) {
		if(!structKeyExists(arguments, "orderItem")) {
			arguments.orderItem = variables.orderItem;
		}
		var index = arrayFind(arguments.orderItem.getOrderItemGiftRecipients(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.orderItem.getOrderItemGiftRecipients(), index);
		}
		structDelete(variables, "orderItem");
	}

    // Gift Card (one-to-many)
	public void function addGiftCard(required any giftCard){
		arguments.giftCard.setOrderItemGiftRecipient( this );
	}

	public void function removeGiftCardTransaction(required any giftCard){
		arguments.giftCard.removeOrderItemGiftRecipient( this );
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
		if(!isNull(this.getFirstName()) && !isNull(this.getLastName())){
			return this.getFirstName() & " " & this.getLastName();
		} else if(!isNull(getEmailAddress())){
			return getEmailAddress();
		}
		return '';
	}

	// ==================  END:  Overridden Methods ========================

	// =================== START: ORM Event Hooks  =========================

	// ===================  END:  ORM Event Hooks  =========================

	// ================== START: Deprecated Methods ========================

	// ==================  END:  Deprecated Methods ========================
}
