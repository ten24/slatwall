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
component displayname="App" entityname="SlatwallApp" table="SwApp" persistent="true" output="false" accessors="true" extends="HibachiEntity" cacheuse="transactional" hb_serviceName="appService" hb_permission="this" hb_processContexts="" {

	// Persistent Properties
	property name="appID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="appName" ormtype="string";
	property name="appCode" ormtype="string" unique="true" index="PI_APPCODE";
	property name="appRootPath" ormtype="string";

	// Related Object Properties (many-to-one)
	property name="integration" hb_populateEnabled="public" cfc="Integration" fieldtype="many-to-one" fkcolumn="integrationID";

	// Related Object Properties (one-to-many)
	property name="sites" type="array" cfc="Site" singularname="site" fieldtype="one-to-many" fkcolumn="appID" cascade="all-delete-orphan" inverse="true";

	// Related Object Properties (many-to-many - owner)

	// Related Object Properties (many-to-many - inverse)

	// Remote properties
	property name="remoteID" hb_populateEnabled="false" ormtype="string" hint="Only used when integrated with a remote system";

	// Audit Properties
	property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="createdByAccountID" hb_populateEnabled="false" ormtype="string";
	property name="modifiedDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="modifiedByAccountID" hb_populateEnabled="false" ormtype="string";

	// Non Persistent
	property name="appPath" persistent="false";

	public string function getAppPath(){
		if(!structKeyExists(variables,'appPath')){
			var appsPath = expandPath('/Slatwall/custom/apps');
			variables.appPath = appsPath & '/' & getAppCode();
		}
		return variables.appPath;
	}

	// ============ START: Non-Persistent Property Methods =================

	// ============  END:  Non-Persistent Property Methods =================

	// ============= START: Bidirectional Helper Methods ===================

	// Sites (one-to-many)
	public void function addSite(required any site) {
		arguments.site.setApp( this );
	}
	public void function removeSite(required any site) {
		arguments.site.removeApp( this );
	}

	// integration (many-to-one)
	public void function setIntegration(required any Integration) {
		variables.Integration = arguments.Integration;
		if(isNew() or !arguments.Integration.hasApp( this )) {
			arrayAppend(arguments.Integration.getApps(), this);
		}
	}
	public void function removeIntegration(any Integration) {
		if(!structKeyExists(arguments, "Integration")) {
			arguments.Integration = variables.Integration;
		}
		var index = arrayFind(arguments.Integration.getApps(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.Integration.getApps(), index);
		}
		structDelete(variables, "Integration");
	}

	// =============  END:  Bidirectional Helper Methods ===================

	// ============= START: Overridden Smart List Getters ==================

	// =============  END: Overridden Smart List Getters ===================

	// ================== START: Overridden Methods ========================

	public string function getAppRootPath(){
		if(!structKeyExists(variables,'appRootPath') && !isNull(getAppCode())){
			variables.appRootPath = '/custom/apps/' & getAppCode();
		}
		return variables.appRootPath;
	}

	// ==================  END:  Overridden Methods ========================

	// =================== START: ORM Event Hooks  =========================

	// ===================  END:  ORM Event Hooks  =========================

	// ================== START: Deprecated Methods ========================

	// ==================  END:  Deprecated Methods ========================

}

