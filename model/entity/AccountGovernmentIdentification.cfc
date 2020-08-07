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
component displayname="Account Government Identification" entityname="SlatwallAccountGovernmentIdentification" table="SwAccountGovernmentId" persistent="true" accessors="true" output="false" extends="HibachiEntity" cacheuse="transactional" hb_serviceName="accountService" hb_permission="account.accountGovernmentIdentifications" {
	
	// Persistent Properties
	property name="accountGovernmentIdentificationID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="" column="accountGovIdentificationID";
	property name="governmentIdentificationNumberEncrypted" ormtype="string" hb_auditable="false" column="governmentIdNumberEncrypted";
	property name="governmentIdentificationNumberEncryptedGenerator" ormtype="string" hb_auditable="false" column="governmentIdNumberEncryptedGen";
	property name="governmentIdentificationNumberEncryptedDateTime" ormtype="timestamp" hb_auditable="false" column="governmentIdNumberEncryptedDT";
	property name="governmentIdentificationLastFour" ormtype="string" column="governmentIdLastFour";
	
	// Related Object Properties (Many-To-One)
	property name="account" cfc="Account" fieldtype="many-to-one" fkcolumn="accountID";
	property name="governmentIdentificationType" hb_populateEnabled="public" cfc="Type" fieldtype="many-to-one" fkcolumn="governmentIdType" hb_optionsNullRBKey="define.select" hb_optionsSmartListData="f:parentType.systemCode=accountGovernmentIdType";
	// Remote properties
	property name="remoteID" hb_populateEnabled="false" ormtype="string" hint="Only used when integrated with a remote system";
	
	// Audit Properties
	property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="createdByAccountID" hb_populateEnabled="false" ormtype="string";
	property name="modifiedDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="modifiedByAccountID" hb_populateEnabled="false" ormtype="string";
	
	
	property name="governmentIdentificationNumber" persistent="false";
	
	// ============ START: Non-Persistent Property Methods =================
	
	// ============  END:  Non-Persistent Property Methods =================
	
	// ============= START: Bidirectional Helper Methods ===================
	
	// Account (many-to-one)    	//CUSTOM PROPERTIES BEGIN
property name="governmentIdentificationNumberHashed" ormtype="string" hb_auditable="false" column="governmentIdNumberHashed" hint="Using this for unique gov-ID validation";

//CUSTOM PROPERTIES END
	public void function setAccount(required any account) {    
		variables.account = arguments.account;    
		if(isNew() || !arguments.account.hasAccountGovernmentIdentifications( this )) {    
			arrayAppend(arguments.account.getAccountGovernmentIdentifications(), this);    
		}
	}
	
	public void function removeAccount(any account) {    
		if(!structKeyExists(arguments, "account")) {    
			arguments.account = variables.account;    
		}    
		var index = arrayFind(arguments.account.getAccountGovernmentIdentifications(), this);    
		if(index > 0) {    
			arrayDeleteAt(arguments.account.getAccountGovernmentIdentifications(), index);    
		}    
		structDelete(variables, "account");    
	}
	
	// =============  END:  Bidirectional Helper Methods ===================
	
	// ================== START: Overridden Methods ========================
	
	public string function getSimpleRepresentationPropertyName() {
		return "governmentIdentificationLastFour";
	}
	
	public string function getGovernmentIdentificationNumber() {
		if(!structKeyExists(variables,"governmentIdentificationNumber")) {
			if(nullReplace(getGovernmentIdentificationNumberEncrypted(), "") != "") {
				variables.governmentIdentificationNumber = decryptProperty("governmentIdentificationNumber");
			} else {
				variables.governmentIdentificationNumber = "";
			}
		}
		return variables.governmentIdentificationNumber;
	}
	
	public void function setGovernmentIdentificationNumber(required string governmentIdentificationNumber) {

		this.getService('accountService')
		.updateGovernmentIdentificationNumberProperties(this, arguments.governmentIdentificationNumber);
		
		if(len(arguments.governmentIdentificationNumber)) {
			variables.governmentIdentificationNumber = arguments.governmentIdentificationNumber;
			encryptProperty('governmentIdentificationNumber');
		} else {
			structDelete(variables, "governmentIdentificationNumber");
		}
	}
	
	public void function setGovernmentIdentificationLastFour(string lastFour){
		if(!structKeyExists(arguments,'lastFour')){
			structDelete(variables,'governmentIdentificationLastFour');
		}else{
			variables.governmentIdentificationLastFour = arguments.lastFour;
		}
	}
	
	// ==================  END:  Overridden Methods ========================

	// ================== START: Overridden Methods ========================
	
	// ==================  END:  Overridden Methods ========================
	
	// =================== START: ORM Event Hooks  =========================
	
	// ===================  END:  ORM Event Hooks  =========================	//CUSTOM FUNCTIONS BEGIN

public boolean function validateGovernmentIdentificationNumber() {
		var governmentID = this.getGovernmentIdentificationNumber();
		var siteCreatedCountry = this.getAccount().getAccountCreatedSite().getRemoteID();
		
		if ( 'USA' == siteCreatedCountry ) {
			return ( 9 == len( governmentID ) );
		} else if ( 'CAN' == siteCreatedCountry ) {
			return ( 9 == len( governmentID ) || 10 == len( governmentID ) );
		}
		
		return true;
	}
	
	public boolean function validateGovernmentIdIsUniquePerCountry() {
		if(!isNull(getGovernmentIdentificationNumberHashed())){
			return getDAO("accountDAO").getGovernmentIdNotInUseFlag(
					this.getGovernmentIdentificationNumberHashed(),
					this.getAccount().getAccountCreatedSite().getSiteID(),
					this.getAccount().getAccountID()
			);
		}
		return true;
	}
	
//CUSTOM FUNCTIONS END
}