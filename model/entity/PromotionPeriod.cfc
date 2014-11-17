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
component displayname="Promotion Period" entityname="SlatwallPromotionPeriod" table="SwPromotionPeriod" persistent="true" extends="HibachiEntity" cacheuse="transactional" hb_serviceName="promotionService" hb_permission="promotion.promotionPeriods" {
	
	// Persistent Properties
	property name="promotionPeriodID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="startDateTime" ormtype="timestamp" hb_formatType="dateTime" hb_nullRBKey="define.forever";
	property name="endDateTime" ormtype="timestamp" hb_formatType="dateTime" hb_nullRBKey="define.forever";
	property name="maximumUseCount" ormtype="integer" notnull="false"  hb_nullRBKey="define.unlimited";
	property name="maximumAccountUseCount" ormtype="integer" notnull="false"  hb_nullRBKey="define.unlimited";
	
	// Related Object Properties (many-to-one)
	property name="promotion" cfc="Promotion" fieldtype="many-to-one" fkcolumn="promotionID" fetch="join";
	
	// Related Object Properties (one-to-many)   
	property name="promotionRewards" singularname="promotionReward" cfc="PromotionReward" fieldtype="one-to-many" fkcolumn="promotionPeriodID" cascade="all-delete-orphan" inverse="true";
	property name="promotionQualifiers" singularname="promotionQualifier" cfc="PromotionQualifier" fieldtype="one-to-many" fkcolumn="promotionPeriodID" cascade="all-delete-orphan" inverse="true";
	
	// Remote Properties
	property name="remoteID" ormtype="string";
	
	// Audit Properties
	property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="createdByAccountID" hb_populateEnabled="false" ormtype="string";
	property name="modifiedDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="modifiedByAccountID" hb_populateEnabled="false" ormtype="string";
	
 	// Non-persistent properties
	property name="currentFlag" type="boolean" persistent="false"; 
 	
 	
 	public boolean function hasMaximumAccountUseCount(){
 		return !isNull(this.getMaximumAccountUseCount()) && this.getMaximumAccountUseCount() gt 0;
 	}
 	
 	public boolean function hasMaximumUseCount(){
 		return !isNull(this.getMaximumUseCount()) && this.getMaximumUseCount() gt 0;
 	}
 
 	public boolean function isCurrent() {
		var currentDateTime = now();
		return getStartDateTime() <= currentDateTime && getEndDateTime() > currentDateTime;
	}
	
	public boolean function isExpired() {
		return isDate(getEndDateTime()) && getEndDateTime() < now();
	}
	
	public boolean function isDeletable () {
		return !isExpired() && getPromotion().isDeletable();
	}
	
	public string function getSimpleRepresentation() {
		return getPromotion().getPromotionName();
	}

	// ============= START: Bidirectional Helper Methods ===================
	
	// Promotion (many-to-one)
	public void function setPromotion(required any promotion) {    
		variables.promotion = arguments.promotion;    
		if(isNew() or !arguments.promotion.hasPromotionPeriod( this )) {    
			arrayAppend(arguments.promotion.getPromotionPeriods(), this);    
		}    
	}    
	public void function removePromotion(any promotion) {    
		if(!structKeyExists(arguments, "promotion")) {    
			arguments.promotion = variables.promotion;    
		}    
		var index = arrayFind(arguments.promotion.getPromotionPeriods(), this);    
		if(index > 0) {    
			arrayDeleteAt(arguments.account.getPromotionPeriods(), index);    
		}    
		structDelete(variables, "promotion");    
	}
	
	// Promotion Rewards (one-to-many)
	public void function addPromotionReward(required any promotionReward) {
	   arguments.promotionReward.setPromotionPeriod(this);
	}
	
	public void function removePromotionReward(required any promotionReward) {
		arguments.promotionReward.removePromotionPeriod(this);
	}
	
	// Promotion Qualifiers (one-to-many)    
	public void function addPromotionQualifier(required any promotionQualifier) {    
		arguments.promotionQualifier.setPromotionPeriod( this );    
	}    
	public void function removePromotionQualifier(required any promotionQualifier) {    
		arguments.PromotionQualifier.removePromotionPeriod( this );    
	}
	
	// =============  END:  Bidirectional Helper Methods ===================

	
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
	
	// =============== START: Custom Formatting Methods ====================
	
	// ===============  END: Custom Formatting Methods =====================
		
	// ============= START: Bidirectional Helper Methods ===================
	
	// =============  END:  Bidirectional Helper Methods ===================
	
	// =================== START: ORM Event Hooks  =========================
	
	// ===================  END:  ORM Event Hooks  =========================
	
	
}
