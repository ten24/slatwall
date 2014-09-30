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
component displayname="Promotion Code" entityname="SlatwallPromotionCode" table="SwPromotionCode" persistent="true" extends="HibachiEntity" cacheuse="transactional" hb_serviceName="promotionService" hb_permission="promotion.promotionCodes" {
	
	// Persistent Properties
	property name="promotionCodeID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="promotionCode" ormtype="string" index="PI_PROMOTIONCODE";
	property name="startDateTime" ormtype="timestamp" hb_formatType="dateTime" hb_nullRBKey="define.forever";
	property name="endDateTime" ormtype="timestamp" hb_formatType="dateTime" hb_nullRBKey="define.forever";
	property name="maximumUseCount" ormtype="integer" notnull="false" hb_nullRBKey="define.unlimited";
	property name="maximumAccountUseCount" ormtype="integer" notnull="false" hb_nullRBKey="define.unlimited";

	// Related Object Properties (many-to-one)
	property name="promotion" cfc="Promotion" fieldtype="many-to-one" fkcolumn="promotionID";
	
	// Related Object Properties (one-to-many)
	
	// Related Object Properties (many-to-many - owner)
	property name="accounts" singularname="account" cfc="Account" type="array" fieldtype="many-to-many" linktable="SwPromotionCodeAccount" fkcolumn="promotionCodeID" inversejoincolumn="accountID";
	
	// Related Object Properties (many-to-many - inverse)
	property name="orders" singularname="order" cfc="Order" type="array" fieldtype="many-to-many" linktable="SwOrderPromotionCode" fkcolumn="promotionCodeID" inversejoincolumn="orderID" inverse="true" lazy="extra";

	// Remote Properties
	property name="remoteID" ormtype="string";
	
	// Audit Properties
	property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="createdByAccountID" hb_populateEnabled="false" ormtype="string";
	property name="modifiedDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="modifiedByAccountID" hb_populateEnabled="false" ormtype="string";
	
	// Non-Persistent Properties
	property name="currentFlag" type="boolean" persistent="false";
	
    
	// ============ START: Non-Persistent Property Methods =================
	
	public boolean function getCurrentFlag() {
		if(!structKeyExists(variables, "currentFlag")) {
			variables.currentFlag = true;
			if( ( !isNull(getStartDateTime()) && getStartDateTime() > now() ) || ( !isNull(getEndDateTime()) && getEndDateTime() < now() ) ) {
				variables.currentFlag = false;
			}	
		}
		
		return variables.currentFlag;
	}
	
	// ============  END:  Non-Persistent Property Methods =================
		
	// ============= START: Bidirectional Helper Methods ===================

    // Promotion (many-to-one)
	public void function setPromotion(required any promotion) {
		variables.promotion = arguments.promotion;
		
		if(isNew() or !arguments.promotion.hasPromotionCode(this)) {
			arrayAppend(arguments.Promotion.getPromotionCodes(),this);
		}
	}

	public void function removePromotion(any promotion) {
		if(!structKeyExists(arguments, 'promotion')) {
			arguments.promotion = variables.promotion;
		}
		var index = arrayFind(arguments.promotion.getPromotionCodes(),this);
		
		if(index > 0) {
			arrayDeleteAt(arguments.promotion.getPromotionCodes(),index);
		}
		structDelete(variables, "promotion");
    }
    
	// Accounts (many-to-many - owner)
	public void function addAccount(required any account) {
		if(arguments.account.isNew() or !hasAccount(arguments.account)) {
			arrayAppend(variables.accounts, arguments.account);
		}
		if(isNew() or !arguments.account.hasPromotionCode( this )) {
			arrayAppend(arguments.account.getPromotionCodes(), this);
		}
	}
	public void function removeAccount(required any account) {
		var thisIndex = arrayFind(variables.accounts, arguments.account);
		if(thisIndex > 0) {
			arrayDeleteAt(variables.accounts, thisIndex);
		}
		var thatIndex = arrayFind(arguments.account.getPromotionCodes(), this);
		if(thatIndex > 0) {
			arrayDeleteAt(arguments.account.getPromotionCodes(), thatIndex);
		}
	}
	
	// ============ START: Non-Persistent Property Methods =================
	
	// ============  END:  Non-Persistent Property Methods =================
		
	// ============= START: Bidirectional Helper Methods ===================
	
	// =============  END:  Bidirectional Helper Methods ===================

	// =============== START: Custom Validation Methods ====================
	
	// ===============  END: Custom Validation Methods =====================
	
	// =============== START: Custom Formatting Methods ====================
	
	// ===============  END: Custom Formatting Methods =====================
	
	// ============== START: Overridden Implicet Getters ===================
	
	// ==============  END: Overridden Implicet Getters ====================

	// ================== START: Overridden Methods ========================
	
	public string function getSimpleRepresentationPropertyName() {
		return "promotionCode";
	}
	
	// ==================  END:  Overridden Methods ========================
	
	// =================== START: ORM Event Hooks  =========================
	
	public void function preInsert() {
		// Override the preInsert method to set a promotion code if one wasn't assinged
		if(isNull(getPromotionCode()) || getPromotionCode() == ""){
			setPromotionCode(createUUID());
		}
		super.preInsert();
    }
    
	// ===================  END:  ORM Event Hooks  =========================
	
	// ================== START: Deprecated Methods ========================
	
	// ==================  END:  Deprecated Methods ========================
}
