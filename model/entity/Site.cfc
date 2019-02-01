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
component entityname="SlatwallSite" table="SwSite" persistent="true" accessors="true" extends="HibachiEntity" cacheuse="transactional" hb_serviceName="siteService" hb_permission="this" {

	// Persistent Properties
	property name="siteID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="siteName" ormtype="string";
	property name="siteCode" ormtype="string" index="PI_SITECODE";
	property name="domainNames" ormtype="string";
	property name="allowAdminAccessFlag" ormtype="boolean";
	property name="resetSettingCache" ormtype="boolean";
	// CMS Properties
	property name="cmsSiteID" ormtype="string" index="RI_CMSSITEID";

	// Related Object Properties (many-to-one)
	property name="app" hb_populateEnabled="public" cfc="App" fieldtype="many-to-one" fkcolumn="appID"  hb_cascadeCalculate="true";

	// Related Object Properties (one-to-many)
	property name="attributeValues" singularname="attributeValue" cfc="AttributeValue" fieldtype="one-to-many" type="array" fkcolumn="siteID" cascade="all-delete-orphan" inverse="true";
	property name="contents" singularname="content" cfc="Content" type="array" fieldtype="one-to-many" cascade="all-delete-orphan" fkcolumn="siteID" inverse="true" lazy="extra";

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
	property name="sitePath" persistent="false";
	property name="templatesPath" persistent="false";
	property name="assetsPath" persistent="false";

	public boolean function getAllowAdminAccessFlag() {
		if(isNull(variables.allowAdminAccessFlag)) {
			variables.allowAdminAccessFlag = 0;
		}
		return variables.allowAdminAccessFlag;
	}

	public boolean function isSlatwallCMS(){
		return !isNull(this.getApp()) && !isNull(this.getApp().getIntegration()) && !isNull(this.getApp().getIntegration().getintegrationPackage()) && this.getapp().getintegration().getintegrationPackage() == 'slatwallcms';
	}

	public string function getSitePath(){
		if(!structKeyExists(variables,'sitePath')){
			variables.sitePath = getApp().getAppPath() & '/' & getSiteCode() & '/';
		}
		return variables.sitePath;
	}

	public string function getTemplatesPath(){
		if(!structKeyExists(variables,'templatesPath')){
			variables.templatesPath = getSitePath() & 'templates/';
		}
		return variables.templatesPath;
	}

	public string function getAssetsPath(){
		if(!structKeyExists(variables,'assetsPath')){
			variables.assetsPath = getSitePath() & 'assets/';
		}
		return variables.assetsPath;
	}

	public string function getSharedAssetsPath(){
		return getService('siteService').getSharedAssetsPath();
	}

	// ============ START: Non-Persistent Property Methods =================

	// ============  END:  Non-Persistent Property Methods =================

	// ============= START: Bidirectional Helper Methods ===================

	// App (many-to-one)
	public void function setApp(required any app) {
		variables.app = arguments.app;
		if(isNew() or !arguments.app.hasSite( this )) {
			arrayAppend(arguments.app.getSites(), this);
		}
	}
	public void function removeApp(any app) {
		if(!structKeyExists(arguments, "app")) {
			arguments.app = variables.app;
		}
		var index = arrayFind(arguments.app.getSites(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.app.getSites(), index);
		}
		structDelete(variables, "app");
	}

	// Attribute Values (one-to-many)
	public void function addAttributeValue(required any attributeValue) {
		arguments.attributeValue.setSite( this );
	}
	public void function removeAttributeValue(required any attributeValue) {
		arguments.attributeValue.removeSite( this );
	}


	// =============  END:  Bidirectional Helper Methods ===================

	// =============== START: Custom Validation Methods ====================

	// ===============  END: Custom Validation Methods =====================

	// =============== START: Custom Formatting Methods ====================

	// ===============  END: Custom Formatting Methods =====================

	// ================== START: Overridden Methods ========================

	// ==================  END:  Overridden Methods ========================

	// =================== START: ORM Event Hooks  =========================

	// ===================  END:  ORM Event Hooks  =========================

	// ================== START: Deprecated Methods ========================

	// ==================  END:  Deprecated Methods ========================
}
