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
component entityname="SlatwallSubscriptionTerm" table="SwSubscriptionTerm" persistent="true" accessors="true" extends="HibachiEntity" cacheuse="transactional" hb_serviceName="subscriptionService" hb_permission="this" {
	
	// Persistent Properties
	property name="subscriptionTermID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="subscriptionTermName" ormtype="string";
	property name="allowProrateFlag" ormtype="boolean" hb_formatType="yesno";
	property name="autoRenewFlag" ormtype="boolean" hb_formatType="yesno";
	property name="autoPayFlag" ormtype="boolean" hb_formatType="yesno";
	
	// Related Object Properties (many-to-one)
	property name="initialTerm" cfc="Term" fieldtype="many-to-one" fkcolumn="initialTermID";
	property name="renewalTerm" cfc="Term" fieldtype="many-to-one" fkcolumn="renewalTermID";
	property name="gracePeriodTerm" cfc="Term" fieldtype="many-to-one" fkcolumn="gracePeriodTermID";
	
	// Related Object Properties (one-to-many)
	property name="skus" singularname="sku" cfc="Sku" type="array" fieldtype="one-to-many" fkcolumn="subscriptionTermID" cascade="all" inverse="true";
	
	// Related Object Properties (many-to-many)
	
	// Remote properties
	property name="remoteID" ormtype="string";
	
	// Audit Properties
	property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="createdByAccount" hb_populateEnabled="false" cfc="Account" fieldtype="many-to-one" fkcolumn="createdByAccountID";
	property name="modifiedDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="modifiedByAccount" hb_populateEnabled="false" cfc="Account" fieldtype="many-to-one" fkcolumn="modifiedByAccountID";
	
	// Non-Persistent Properties



	// ============ START: Non-Persistent Property Methods =================
	
	// ============  END:  Non-Persistent Property Methods =================
		
	// ============= START: Bidirectional Helper Methods ===================
	
	// Initial Term (many-to-one)
	public void function setInitialTerm(required any initialTerm) {
		variables.initialTerm = arguments.initialTerm;
		if(isNew() or !arguments.initialTerm.hasInitialSubscriptionTerm( this )) {
			arrayAppend(arguments.initialTerm.getInitialSubscriptionTerms(), this);
		}
	}
	public void function removeInitialTerm(any initialTerm) {
		if(!structKeyExists(arguments, "initialTerm")) {
			arguments.initialTerm = variables.initialTerm;
		}
		var index = arrayFind(arguments.initialTerm.getInitialSubscriptionTerms(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.initialTerm.getInitialSubscriptionTerms(), index);
		}
		structDelete(variables, "initialTerm");
	}

	// Renewal Term (many-to-one)
	public void function setRenewalTerm(required any renewalTerm) {
		variables.renewalTerm = arguments.renewalTerm;
		if(isNew() or !arguments.renewalTerm.hasRenewalSubscriptionTerm( this )) {
			arrayAppend(arguments.renewalTerm.getRenewalSubscriptionTerms(), this);
		}
	}
	public void function removeRenewalTerm(any renewalTerm) {
		if(!structKeyExists(arguments, "renewalTerm")) {
			arguments.renewalTerm = variables.renewalTerm;
		}
		var index = arrayFind(arguments.renewalTerm.getRenewalSubscriptionTerms(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.renewalTerm.getRenewalSubscriptionTerms(), index);
		}
		structDelete(variables, "renewalTerm");
	}
	
	// Grace Period Term (many-to-one)
	public void function setGracePeriodTerm(required any gracePeriodTerm) {
		variables.gracePeriodTerm = arguments.gracePeriodTerm;
		if(isNew() or !arguments.gracePeriodTerm.hasGracePeriodSubscriptionTerm( this )) {
			arrayAppend(arguments.gracePeriodTerm.getGracePeriodSubscriptionTerms(), this);
		}
	}
	public void function removeGracePeriodTerm(any gracePeriodTerm) {
		if(!structKeyExists(arguments, "gracePeriodTerm")) {
			arguments.gracePeriodTerm = variables.gracePeriodTerm;
		}
		var index = arrayFind(arguments.gracePeriodTerm.getGracePeriodSubscriptionTerms(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.gracePeriodTerm.getGracePeriodSubscriptionTerms(), index);
		}
		structDelete(variables, "gracePeriodTerm");
	}

	// Skus (one-to-many)
	public void function addSku(required any sku) {
		arguments.sku.setSubscriptionTerm( this );
	}
	public void function removeSku(required any sku) {
		arguments.sku.removeSubscriptionTerm( this );
	}

	// =============  END:  Bidirectional Helper Methods ===================

	// ================== START: Overridden Methods ========================
	
	// ==================  END:  Overridden Methods ========================
	
	// =================== START: ORM Event Hooks  =========================
	
	// ===================  END:  ORM Event Hooks  =========================
}
