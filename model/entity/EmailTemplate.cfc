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
component displayname="EmailTemplate" entityname="SlatwallEmailTemplate" table="SwEmailTemplate" persistent="true" accessors="true" extends="HibachiEntity" cacheuse="transactional" hb_serviceName="templateService" hb_permission="this" {

	// Persistent Properties
	property name="emailTemplateID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="emailTemplateName" ormtype="string";
	property name="emailTemplateObject" ormtype="string" hb_formFieldType="select";
	property name="emailTemplateFile" ormtype="string" hb_formFieldType="select";
	property name="emailBodyHTML" ormtype="string" length="4000";
	property name="emailBodyText" ormtype="string" length="4000";
	property name="logEmailFlag" ormtype="boolean";

	// Related Object Properties (many-to-one)

	// Related Object Properties (one-to-many)
	property name="eventTriggers" singularname="eventTrigger" cfc="EventTrigger" fieldtype="one-to-many" fkcolumn="emailTemplateID" cascade="all" inverse="true" lazy="extra";
	property name="forms" singularname="form" cfc="Form" fieldtype="one-to-many" fkcolumn="emailTemplateID" cascade="all";
	// Related Object Properties (many-to-many)

	// Remote Properties
	property name="remoteID" ormtype="string";

	// Audit Properties
	property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="createdByAccountID" hb_populateEnabled="false" ormtype="string";
	property name="modifiedDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="modifiedByAccountID" hb_populateEnabled="false" ormtype="string";

	// Non-Persistent Properties
	property name="emailTemplateObjectOptions" persistent="false";
	property name="emailTemplateFileOptions" persistent="false";


	// ============ START: Non-Persistent Property Methods =================

	public array function getEmailTemplateObjectOptions() {
		if(!structKeyExists(variables, "emailTemplateObjectOptions")) {
			var emd = getService("hibachiService").getEntitiesMetaData();
			var enArr = listToArray(structKeyList(emd));
			arraySort(enArr,"text");
			variables.emailTemplateObjectOptions = [{name=getHibachiScope().rbKey('define.select'), value=''}];
			for(var i=1; i<=arrayLen(enArr); i++) {
				arrayAppend(variables.emailTemplateObjectOptions, {name=rbKey('entity.#enArr[i]#'), value=enArr[i]});
			}
		}
		return variables.emailTemplateObjectOptions;
	}

	public array function getEmailTemplateFileOptions() {
		if(!structKeyExists(variables, "emailTemplateFileOptions")) {
			variables.emailTemplateFileOptions = getService("templateService").getTemplateFileOptions( templateType="email", objectName=getEmailTemplateObject() );
			arrayPrepend(variables.emailTemplateFileOptions, {name=getHibachiScope().rbKey('define.none'), value=''});
		}
		return variables.emailTemplateFileOptions;
	}

	// ============  END:  Non-Persistent Property Methods =================

	// ============= START: Bidirectional Helper Methods ===================

	// Attributes (one-to-many)
	public void function addForm(required any form) {
		arguments.form.setEmailTemplate( this );
	}
	public void function removeForm(required any form) {
		arguments.form.removeEmailTemplate( this );
	}

	// =============  END:  Bidirectional Helper Methods ===================

	// ================== START: Overridden Methods ========================

	public any function getEmailBodyHTML() {
		if(!structKeyExists(variables, "emailBodyHTML")) {
			variables.emailBodyHTML = "";
		}
		return variables.emailBodyHTML;
	}

	public any function getEmailBodyText() {
		if(!structKeyExists(variables, "emailBodyText")) {
			variables.emailBodyText = "";
		}
		return variables.emailBodyText;
	}

	// ==================  END:  Overridden Methods ========================

	// =================== START: ORM Event Hooks  =========================

	// ===================  END:  ORM Event Hooks  =========================
}
