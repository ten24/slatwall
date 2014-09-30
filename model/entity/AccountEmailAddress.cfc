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
component displayname="Account Email Address" entityname="SlatwallAccountEmailAddress" table="SwAccountEmailAddress" persistent="true" accessors="true" output="false" extends="HibachiEntity" cacheuse="transactional" hb_serviceName="accountService" hb_permission="account.accountEmailAddresses" hb_processContext="sendVerificationEmail,verify" {
	
	// Persistent Properties
	property name="accountEmailAddressID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="emailAddress" hb_populateEnabled="public" ormtype="string" hb_formatType="email";
	property name="verifiedFlag" hb_populateEnabled="false" ormtype="boolean";
	property name="verificationCode" hb_populateEnabled="false" ormtype="string";
	
	// Calculated Properties
	
	// Related Object Properties (many-to-one)
	property name="account" cfc="Account" fieldtype="many-to-one" fkcolumn="accountID";
	property name="accountEmailType" hb_populateEnabled="public" cfc="Type" fieldtype="many-to-one" fkcolumn="accountEmailTypeID" hb_optionsNullRBKey="define.select" hb_optionsSmartListData="f:parentType.systemCode=accountEmailType";
	
	// Related Object Properties (one-to-many)
	
	// Related Object Properties (many-to-many - owner)
	
	// Related Object Properties (many-to-many - inverse)
	
	// Remote properties
	property name="remoteID" hb_populateEnabled="false" ormtype="string";
	
	// Audit Properties
	property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="createdByAccountID" hb_populateEnabled="false" ormtype="string";
	property name="modifiedDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="modifiedByAccountID" hb_populateEnabled="false" ormtype="string";
	
	// Non Persistent
	property name="primaryEmailAddressNotInUseFlag" persistent="false";
	property name="primaryFlag" persistent="false";
	
	// Deprecated Properties
	
	
	// ==================== START: Logical Methods =========================
	
	// ====================  END: Logical Methods ==========================
	
	// ============ START: Non-Persistent Property Methods =================
	
	public boolean function getPrimaryEmailAddressNotInUseFlag() {
		if(!structKeyExists(variables, "primaryEmailAddressNotInUseFlag")) {
			variables.primaryEmailAddressNotInUseFlag = true;
			if(!isNull(getEmailAddress())) {
				if(!isNull(getAccount())) {
					variables.primaryEmailAddressNotInUseFlag = getService("accountService").getPrimaryEmailAddressNotInUseFlag( emailAddress=getEmailAddress(), accountID=getAccount().getAccountID() );
				} else {
					variables.primaryEmailAddressNotInUseFlag = getService("accountService").getPrimaryEmailAddressNotInUseFlag( emailAddress=getEmailAddress() );	
				}
			}
		}
		
		return variables.primaryEmailAddressNotInUseFlag;
	}
	
	public boolean function getPrimaryFlag() {
		if(!structKeyExists(variables, "primaryFlag")) {
			variables.primaryFlag = true;
			if(!isNull(getAccount())) {
				variables.primaryFlag = getAccount().getPrimaryEmailAddress().getAccountEmailAddressID() == this.getAccountEmailAddressID();
			}
		}
		
		return variables.primaryFlag;
	}
	
	
	// ============  END:  Non-Persistent Property Methods =================
		
	// ============= START: Bidirectional Helper Methods ===================
	
	
	// Account (many-to-one)
	public void function setAccount(required any account) {
		variables.account = arguments.account;
		if(isNew() or !arguments.account.hasAccountEmailAddress( this )) {
			arrayAppend(arguments.account.getAccountEmailAddresses(), this);
		}
	}
	public void function removeAccount(any account) {
		if(!structKeyExists(arguments, "account")) {
			arguments.account = variables.account;
		}
		var index = arrayFind(arguments.account.getAccountEmailAddresses(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.account.getAccountEmailAddresses(), index);
		}
		structDelete(variables, "account");
	}
	
	
	// =============  END:  Bidirectional Helper Methods ===================

	// =============== START: Custom Validation Methods ====================
	
	// ===============  END: Custom Validation Methods =====================
	
	// =============== START: Custom Formatting Methods ====================
	
	// ===============  END: Custom Formatting Methods =====================
	
	// ============== START: Overridden Implicit Getters ===================
	
	public any function getVerifiedFlag() {
		if(!structKeyExists(variables, "verifiedFlag")) {
			variables.verifiedFlag = 0;
		}
		return variables.verifiedFlag;
	}
	
	public string function getVerificationCode() {
		if(!structKeyExists(variables, "verificationCode")) {
			variables.verificationCode = createHibachiUUID();
		}
		return variables.verificationCode;
	}
	
	// ==============  END: Overridden Implicit Getters ====================
	
	// ============= START: Overridden Smart List Getters ==================
	
	// =============  END: Overridden Smart List Getters ===================

	// ================== START: Overridden Methods ========================
	
	public string function getSimpleRepresentationPropertyName() {
		return "emailAddress";
	}
	
	// ==================  END:  Overridden Methods ========================
	
	// =================== START: ORM Event Hooks  =========================
	
	// ===================  END:  ORM Event Hooks  =========================
	
	// ================== START: Deprecated Methods ========================
	
	// ==================  END:  Deprecated Methods ========================
	
	
}

