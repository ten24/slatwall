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
component entityname="SlatwallPromotionRewardCurrency" table="SwPromotionRewardCurrency" persistent="true" accessors="true" extends="HibachiEntity" cacheuse="transactional" hb_serviceName="promotionService" {
	
	// Persistent Properties
	property name="promotionRewardCurrencyID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="amount" ormtype="big_decimal" hb_formatType="currency" hb_rbKey='entity.promotionReward.amount';
	
	// Related Object Properties (many-to-one)
	property name="currency" cfc="Currency" fieldtype="many-to-one" fkcolumn="currencyCode";
	property name="promotionReward" cfc="PromotionReward" fieldtype="many-to-one" fkcolumn="promotionRewardID";
	
	// Related Object Properties (one-to-many)
	
	// Related Object Properties (many-to-many - owner)

	// Related Object Properties (many-to-many - inverse)
	
	// Non Update-Insert Properties
	property name="currencyCode" insert="false" update="false";
	
	// Remote Properties
	property name="remoteID" ormtype="string";
	
	// Audit Properties
	property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="createdByAccountID" hb_populateEnabled="false" ormtype="string";
	property name="modifiedDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="modifiedByAccountID" hb_populateEnabled="false" ormtype="string";
	
	// Non-Persistent Properties

	// ============ START: Non-Persistent Property Methods =================
	
	public string function getCurrencyCode(){
		if(!structKeyExists(variables, "currencyCode")) {
			if(!isnull(this.getCurrency())){
				variables.currencyCode=this.getCurrency().getCurrencyCode();
			}else{
				variables.currencyCode=this.setting('skuCurrency');
			}
		}
		return variables.currencyCode;
	}

	// ============  END:  Non-Persistent Property Methods =================
		
	// ============= START: Bidirectional Helper Methods ===================
	
	// Promotion Reward (many-to-one)
	public void function setPromotionReward(required any promotionReward) {
		variables.promotionReward = arguments.promotionReward;
		if(isNew() or !arguments.promotionReward.hasPromotionRewardCurrency( this )) {
			arrayAppend(arguments.promotionReward.getPromotionRewardCurrencies(), this);
		}
	}
	public void function removePromotionReward(any promotionReward) {
		if(!structKeyExists(arguments, "promotionReward")) {
			arguments.promotionReward = variables.promotionReward;
		}
		var index = arrayFind(arguments.promotionReward.getPromotionRewardCurrencies(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.promotionReward.getPromotionRewardCurrencies(), index);
		}
		structDelete(variables, "promotionReward");
	}
	
	// =============  END:  Bidirectional Helper Methods ===================

	// =============== START: Custom Validation Methods ====================
	
	// ===============  END: Custom Validation Methods =====================
	
	// =============== START: Custom Formatting Methods ====================
	
	// ===============  END: Custom Formatting Methods =====================

	// ================== START: Overridden Methods ========================
	
	public string function getSimpleRepresentation() {
		return getPromotionReward().getRewardType() & " - " & getCurrency().getCurrencyCode(); 
	}
	
	// ==================  END:  Overridden Methods ========================
	
	// =================== START: ORM Event Hooks  =========================
	
	// ===================  END:  ORM Event Hooks  =========================
	
	// ================== START: Deprecated Methods ========================
	
	// ==================  END:  Deprecated Methods ========================
}
