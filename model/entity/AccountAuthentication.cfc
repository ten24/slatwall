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
component displayname="Account Authentication" entityname="SlatwallAccountAuthentication" table="SwAccountAuthentication" persistent="true" accessors="true" extends="HibachiEntity" cacheuse="transactional" hb_serviceName="accountService" hb_permission="account.accountAuthentications" {

	// Persistent Properties
	property name="accountAuthenticationID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="password" ormtype="string";
	property name="accessKey" ormtype="string";
	property name="accessKeyPassword" ormtype="string";
	property name="expirationDateTime" ormtype="timestamp";
	property name="integrationAccountID" ormtype="string";
	property name="integrationAccessToken" ormtype="string";
	property name="integrationAccessTokenExpiration" ormtype="string" column="integrationAccessTokenExp";
	property name="integrationRefreshToken" ormtype="string";
	property name="activeFlag" ormtype="boolean";
	property name="updatePasswordOnNextLoginFlag" ormtype="boolean";
	property name="authenticationDescription" ormtype="string";

	// Related Object Properties (many-to-one)
	property name="account" cfc="Account" fieldtype="many-to-one" fkcolumn="accountID" hb_optionsNullRBKey="define.select";
	property name="integration" cfc="Integration" fieldtype="many-to-one" fkcolumn="integrationID" hb_optionsNullRBKey="define.select";

	// Related Object Properties (one-to-many)

	// Related Object Properties (many-to-many - owner)

	// Related Object Properties (many-to-many - inverse)

	// Remote Properties
	property name="remoteID" ormtype="string";

	// Audit Properties
	property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="createdByAccountID" hb_populateEnabled="false" ormtype="string";
	property name="modifiedDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="modifiedByAccountID" hb_populateEnabled="false" ormtype="string";

	// Non-Persistent Properties
	property name="forceLogoutFlag" persistent="false";



	// ============ START: Non-Persistent Property Methods =================

	public boolean function getForceLogoutFlag() {
		/*
			//if(!isNull(session.getAccountAuthentication().getIntegration()) && !currentSession.getAccountAuthentication().getIntegration().getIntegrationCFC( "authentication" ).verifySessionLogin( currentSession )) {

			// Check with the auto logout setting of the authentication
			} else if( listLen(currentSession.getAccountAuthentication().setting('accountAuthenticationAutoLogoutTimespan')) eq 4 ) {
				var tsArr = listToArray(currentSession.getAccountAuthentication().setting('accountAuthenticationAutoLogoutTimespan'));
				var autoExpireDateTime = currentSession.getLastRequestDateTime() + createTimeSpan(tsArr[1],tsArr[2],tsArr[3],tsArr[4]);
				if(autoExpireDateTime lt now()) {
					logoutAccount();
				}
			}
			*/

		return false;
	}

	// ============  END:  Non-Persistent Property Methods =================

	// ============= START: Bidirectional Helper Methods ===================

	// Account (many-to-one)
	public void function setAccount(required any account) {
		variables.account = arguments.account;
		if(isNew() or !arguments.account.hasAccountAuthentication( this )) {
			arrayAppend(arguments.account.getAccountAuthentications(), this);
		}
	}
	public void function removeAccount(any account) {
		if(!structKeyExists(arguments, "account")) {
			arguments.account = variables.account;
		}
		var index = arrayFind(arguments.account.getAccountAuthentications(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.account.getAccountAuthentications(), index);
		}
		structDelete(variables, "account");
	}

	// =============  END:  Bidirectional Helper Methods ===================

	// =============== START: Custom Validation Methods ====================

	// ===============  END: Custom Validation Methods =====================

	// =============== START: Custom Formatting Methods ====================

	// ===============  END: Custom Formatting Methods =====================

	// ================== START: Overridden Methods ========================

	public string function getSimpleRepresentation() {
		var rep = "";
		if(!isNull(getAccessKey())){
			rep &= "API Access Key - #getAuthenticationDescription()#";

			// If this is a
			if(getHibachiScope().getAccount().getSuperUserFlag() || getHibachiScope().getAccount().getAccountID() == getAccount().getAccountID()){
				 rep &= "<br />#getAccessKey()#";
			}
		} else if(isNull(getIntegration())) {
			rep &= "Slatwall";
			if(isNull(getPassword())) {
				rep &= " - #rbKey('define.temporary')# #rbKey('define.reset')#";
			}
		} else {
			rep &= getIntegration().getIntegrationName();
		}

		if(!isNull(getExpirationDateTime())) {
			rep &= " - #rbKey('define.expires')#: #getFormattedValue('expirationDateTime')#";
		}

		return rep;
	}

	// ==================  END:  Overridden Methods ========================

	// =================== START: ORM Event Hooks  =========================

	// ===================  END:  ORM Event Hooks  =========================

	// ================== START: Deprecated Methods ========================

	// ==================  END:  Deprecated Methods ========================
}
