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
component displayname="Loyalty" entityname="SlatwallLoyalty" table="SwLoyalty" persistent="true" extends="HibachiEntity" cacheuse="transactional" hb_serviceName="loyaltyService" hb_permission="this" {
	
	// Persistent Properties
	property name="loyaltyID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="loyaltyName" ormtype="string";
	property name="activeFlag" ormtype="boolean" default="1";
	
	// Related Object Properties (one-to-many)
	property name="loyaltyAccruements" singularname="loyaltyAccruement" cfc="LoyaltyAccruement" type="array" fieldtype="one-to-many" fkcolumn="loyaltyID" cascade="all-delete-orphan" inverse="true";
	property name="loyaltyRedemptions" singularname="loyaltyRedemption" cfc="LoyaltyRedemption" type="array" fieldtype="one-to-many" fkcolumn="loyaltyID" cascade="all-delete-orphan" inverse="true";
	property name="accountLoyalties" singularname="accountLoyalty" cfc="AccountLoyalty" type="array" fieldtype="one-to-many" fkcolumn="loyaltyID" cascade="all-delete-orphan" inverse="true";
	property name="loyaltyTerms" singularname="loyaltyTerm" cfc="LoyaltyTerm" type="array" fieldtype="one-to-many" fkcolumn="loyaltyID" cascade="all-delete-orphan" inverse="true";
		
	// Remote Properties
	property name="remoteID" ormtype="string";
	
	// Audit Properties
	property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="createdByAccountID" hb_populateEnabled="false" ormtype="string";
	property name="modifiedDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="modifiedByAccountID" hb_populateEnabled="false" ormtype="string";
	
	// Non-Persistent Properties

	
	// ============ START: Non-Persistent Property Methods =================
	
	// ============  END:  Non-Persistent Property Methods =================
		
	// ============= START: Bidirectional Helper Methods ===================
	
	// Loyalty Program Accruements (one-to-many)
	public void function addLoyaltyAccruement(required any loyaltyAccruement) {
		arguments.loyaltyAccruement.setLoyalty( this );
	}
	public void function removeLoyaltyAccruement(required any loyaltyAccruement) {
		arguments.loyaltyAccruement.removeLoyalty( this );
	}
	
	// Loyalty Program Redemptions (one-to-many)    
	public void function addLoyaltyRedemption(required any loyaltyRedemption) {    
		arguments.loyaltyRedemption.setLoyalty( this );    
	}    
	public void function removeLoyaltyRedemption(required any loyaltyRedemption) {    
		arguments.loyaltyRedemption.removeLoyalty( this );    
	}
	
	// Account Loyalty Programs (one-to-many)
	public void function addAccountLoyalty(required any accountLoyalty) {    
		arguments.accountLoyalty.setLoyalty( this );    
	}    
	public void function removeAccountLoyalty(required any accountLoyalty) {    
		arguments.accountLoyalty.removeLoyalty( this );    
	}
	
	// Loyalty Terms (one-to-many)
	public void function addLoyaltyTerm(required any loyaltyTerm) {    
		arguments.loyaltyTerm.setLoyalty( this );    
	}    
	public void function removeLoyaltyTerm(required any loyaltyTerm) {    
		arguments.loyaltyTerm.removeLoyalty( this );    
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