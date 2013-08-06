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
component entityname="SlatwallTerm" table="SlatwallTerm" persistent="true" accessors="true" extends="HibachiEntity" cacheuse="transactional" hb_serviceName="settingService" hb_permission="this" {
	
	// Persistent Properties
	property name="termID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="termName" ormtype="string";
	property name="termHours" ormtype="integer";
	property name="termDays" ormtype="integer";
	property name="termMonths" ormtype="integer";
	property name="termYears" ormtype="integer";
	property name="sortOrder" ormtype="integer";
	
	// Related Object Properties (many-to-one)
	
	// Related Object Properties (one-to-many)
	property name="paymentTerms" hb_populateEnabled="false" singularname="paymentTerm" cfc="PaymentTerm" type="array" fieldtype="one-to-many" fkcolumn="termID" cascade="all" inverse="true" lazy="extra"; 															// Extra Lazy because it is only used for validation
	property name="initialSubscriptionTerms" hb_populateEnabled="false" singularname="initialSubscriptionTerm" cfc="SubscriptionTerm" type="array" fieldtype="one-to-many" fkcolumn="initialTermID" cascade="all" inverse="true" lazy="extra"; 						// Extra Lazy because it is only used for validation
	property name="renewalSubscriptionTerms" hb_populateEnabled="false" singularname="renewalSubscriptionTerm" cfc="SubscriptionTerm" type="array" fieldtype="one-to-many" fkcolumn="renewalTermID" cascade="all" inverse="true" lazy="extra"; 						// Extra Lazy because it is only used for validation
	property name="gracePeriodSubscriptionTerms" hb_populateEnabled="false" singularname="gracePeriodSubscriptionTerm" cfc="SubscriptionTerm" type="array" fieldtype="one-to-many" fkcolumn="gracePeriodTermID" cascade="all" inverse="true" lazy="extra"; 			// Extra Lazy because it is only used for validation
	property name="initialSubscriptionUsageTerms" hb_populateEnabled="false" singularname="initialSubscriptionUsageTerm" cfc="SubscriptionUsage" type="array" fieldtype="one-to-many" fkcolumn="initialTermID" cascade="all" inverse="true" lazy="extra";				// Extra Lazy because it is only used for validation
	property name="renewalSubscriptionUsageTerms" hb_populateEnabled="false" singularname="renewalSubscriptionUsageTerm" cfc="SubscriptionUsage" type="array" fieldtype="one-to-many" fkcolumn="renewalTermID" cascade="all" inverse="true" lazy="extra";				// Extra Lazy because it is only used for validation
	property name="gracePeriodSubscriptionUsageTerms" hb_populateEnabled="false" singularname="gracePeriodSubscriptionUsageTerm" cfc="SubscriptionUsage" type="array" fieldtype="one-to-many" fkcolumn="gracePeriodTermID" cascade="all" inverse="true" lazy="extra";	// Extra Lazy because it is only used for validation
	
	// Related Object Properties (many-to-many)
	
	// Remote properties
	property name="remoteID" ormtype="string";
	
	// Audit Properties
	property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="createdByAccount" hb_populateEnabled="false" cfc="Account" fieldtype="many-to-one" fkcolumn="createdByAccountID";
	property name="modifiedDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="modifiedByAccount" hb_populateEnabled="false" cfc="Account" fieldtype="many-to-one" fkcolumn="modifiedByAccountID";
	
	// Non-Persistent Properties

	public any function getEndDate(any startDate = now()) {
		var endDate = arguments.startDate;
		endDate = dateAdd('yyyy',val(getTermYears()),endDate);
		endDate = dateAdd('m',val(getTermMonths()),endDate);
		endDate = dateAdd('d',val(getTermDays()),endDate);
		endDate = dateAdd('h',val(getTermHours()),endDate);
		return endDate;
	}

	
	// ============ START: Non-Persistent Property Methods =================
	
	// ============  END:  Non-Persistent Property Methods =================
		
	// ============= START: Bidirectional Helper Methods ===================
	
	// Payment Terms (one-to-many)    
	public void function addPaymentTerm(required any paymentTerm) {    
		arguments.paymentTerm.setTerm( this );    
	}    
	public void function removePaymentTerm(required any paymentTerm) {    
		arguments.paymentTerm.removeTerm( this );    
	}
	
	// Initial Subscription Terms (one-to-many)
	public void function addInitialSubscriptionTerm(required any initialSubscriptionTerm) {
		arguments.initialSubscriptionTerm.setInitialTerm( this );
	}
	public void function removeInitialSubscriptionTerm(required any initialSubscriptionTerm) {
		arguments.initialSubscriptionTerm.removeInitialTerm( this );
	}
	
	// Renewal Subscription Terms (one-to-many)
	public void function addRenewalSubscriptionTerm(required any renewalSubscriptionTerm) {
		arguments.renewalSubscriptionTerm.setRenewalTerm( this );
	}
	public void function removeRenewalSubscriptionTerm(required any renewalSubscriptionTerm) {
		arguments.renewalSubscriptionTerm.removeRenewalTerm( this );
	}

	// Grace Period Subscription Terms (one-to-many)
	public void function addGracePeriodSubscriptionTerm(required any gracePeriodSubscriptionTerm) {
		arguments.gracePeriodSubscriptionTerm.setGracePeriodTerm( this );
	}
	public void function removeGracePeriodSubscriptionTerm(required any gracePeriodSubscriptionTerm) {
		arguments.gracePeriodSubscriptionTerm.removeGracePeriodTerm( this );
	}
	
	// Initial Subscription Usage Terms (one-to-many)
	public void function addInitialSubscriptionUsageTerm(required any initialSubscriptionUsageTerm) {
		arguments.initialSubscriptionUsageTerm.setInitialTerm( this );
	}
	public void function removeInitialSubscriptionUsageTerm(required any initialSubscriptionUsageTerm) {
		arguments.initialSubscriptionUsageTerm.removeInitialTerm( this );
	}
	
	// Renewal Subscription Terms (one-to-many)
	public void function addRenewalSubscriptionUsageTerm(required any renewalSubscriptionUsageTerm) {
		arguments.renewalSubscriptionUsageTerm.setRenewalTerm( this );
	}
	public void function removeRenewalSubscriptionUsageTerm(required any renewalSubscriptionUsageTerm) {
		arguments.renewalSubscriptionUsageTerm.removeRenewalTerm( this );
	}

	// Grace Period Subscription Terms (one-to-many)
	public void function addGracePeriodSubscriptionUsageTerm(required any gracePeriodSubscriptionUsageTerm) {
		arguments.gracePeriodSubscriptionUsageTerm.setGracePeriodTerm( this );
	}
	public void function removeGracePeriodSubscriptionUsageTerm(required any gracePeriodSubscriptionUsageTerm) {
		arguments.gracePeriodSubscriptionUsageTerm.removeGracePeriodTerm( this );
	}

	// =============  END:  Bidirectional Helper Methods ===================

	// ================== START: Overridden Methods ========================
	
	// ==================  END:  Overridden Methods ========================
	
	// =================== START: ORM Event Hooks  =========================
	
	// ===================  END:  ORM Event Hooks  =========================
}
