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
component displayname="Promotion" entityname="SlatwallPromotion" table="SwPromotion" persistent="true" extends="HibachiEntity" cacheuse="transactional" hb_serviceName="promotionService" hb_permission="this" {
	
	// Persistent Properties
	property name="promotionID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="promotionName" ormtype="string";
	property name="promotionSummary" ormtype="string" length="1000";
	property name="promotionDescription" ormtype="string" length="4000";
	property name="activeFlag" ormtype="boolean" default="1";
	
	// Related Object Properties (many-to-one)
	property name="defaultImage" cfc="Image" fieldtype="many-to-one" fkcolumn="defaultImageID";
	
	// Related Object Properties (one-to-many)
	property name="promotionPeriods" singularname="promotionPeriod" cfc="PromotionPeriod" fieldtype="one-to-many" fkcolumn="promotionID" cascade="all-delete-orphan" inverse="true";    
	property name="promotionCodes" singularname="promotionCode" cfc="PromotionCode" fieldtype="one-to-many" fkcolumn="promotionID" cascade="all-delete-orphan" inverse="true";
	property name="appliedPromotions" singularname="appliedPromotion" cfc="PromotionApplied" fieldtype="one-to-many" fkcolumn="promotionID" cascade="all" inverse="true";
	property name="attributeValues" singularname="attributeValue" cfc="AttributeValue" fieldtype="one-to-many" type="array" fkcolumn="promotionID" cascade="all-delete-orphan" inverse="true";
	
	// Remote Properties
	property name="remoteID" ormtype="string";
	
	// Audit Properties
	property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="createdByAccountID" hb_populateEnabled="false" ormtype="string";
	property name="modifiedDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="modifiedByAccountID" hb_populateEnabled="false" ormtype="string";
	
	// Non-persistent properties
	property name="currentFlag" type="boolean" persistent="false";
	property name="currentPromotionPeriodFlag" type="boolean" persistent="false";
	property name="currentPromotionCodeFlag" type="boolean" persistent="false";
	property name="promotionCodesDeletableFlag" type="boolean" persistent="false"; 
	
	// ============ START: Non-Persistent Property Methods =================

	public boolean function getCurrentFlag() {
		if(!structKeyExists(variables, "currentFlag")) {
			variables.currentFlag = false;
			if( getCurrentPromotionPeriodFlag() && ( !arrayLen(getPromotionCodes()) || getCurrentPromotionCodeFlag() ) ) {
				variables.currentFlag = true;
			}
		}
		
		return variables.currentFlag;
	}
	
	
	public boolean function getCurrentPromotionPeriodFlag() {
		if(!structKeyExists(variables, "currentPromotionPeriodFlag")) {
			variables.currentPromotionPeriodFlag = false;
			for( var i=1; i<= arrayLen(getPromotionPeriods()); i++ ) {
				if(getPromotionPeriods()[i].getCurrentFlag()) {
					variables.currentPromotionPeriodFlag = true;
					break;
				}
			}
		}
		
		return variables.currentPromotionPeriodFlag;
	}
	
	public boolean function getCurrentPromotionCodeFlag() {
		if(!structKeyExists(variables, "currentPromotionCodeFlag")) {
			variables.currentPromotionCodeFlag = false;
			for( var i=1; i<= arrayLen(getPromotionCodes()); i++ ) {
				if(getPromotionCodes()[i].getCurrentFlag()) {
					variables.currentPromotionCodeFlag = true;
					break;
				}
			}	
		}
		
		return variables.currentPromotionCodeFlag;
	}
	
	public boolean function getPromotionCodesDeletableFlag() {
		if(!structKeyExists(variables,"promotionCodeDeletableFlag")) {
			variables.promotionCodeDeleteableFlag = true;
			for(var promotionCode in getPromotionCodes()) {
				if(!promotionCode.isDeletable()) {
					variables.promotionCodeDeleteableFlag = false;
					break;		
				}
			}
		}
		return variables.promotionCodeDeleteableFlag;
	}
	
	// ============  END:  Non-Persistent Property Methods =================
		
	// ============= START: Bidirectional Helper Methods ===================

	// promotionPeriods (one-to-many)
	public void function addPromotionPeriod(required any PromotionPeriod) {
		arguments.PromotionPeriod.setPromotion( this );
	}
	public void function removePromotionPeriod(required any PromotionPeriod) {
		arguments.PromotionPeriod.removePromotion( this );
	}
	
	// promotionCodes (one-to-many)
	public void function addPromotionCode(required any promotionCode) {
		arguments.promotionCode.setPromotion(this);
	}
	
	public void function removePromotionCode(required any promotionCode) {
	   arguments.promotionCode.removePromotion(this);
	}
	
	// appliedPromotions (one-to-many)
	public void function addAppliedPromotion(required any promotionApplied) {
	   arguments.promotionApplied.setPromotion(this);
	}
	
	public void function removeAppliedPromotion(required any promotionApplied) {
		arguments.promotionApplied.removePromotion(this);
	}
	
	// Attribute Values (one-to-many)    
 	public void function addAttributeValue(required any attributeValue) {    
 		arguments.attributeValue.setPromotion( this );    
 	}    
 	public void function removeAttributeValue(required any attributeValue) {    
 		arguments.attributeValue.removePromotion( this );    
 	}
 	
	// =============  END:  Bidirectional Helper Methods ===================

	// ================== START: Overridden Methods ========================
	
	public boolean function isDeletable() {
		return arrayLen( getAppliedPromotions() ) == 0;
	}
	
	// ==================  END:  Overridden Methods ========================
	
	// =================== START: ORM Event Hooks  =========================
	
	// ===================  END:  ORM Event Hooks  =========================
	
	
}
