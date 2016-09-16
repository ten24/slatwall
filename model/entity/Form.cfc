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
component displayname="Form" entityname="SlatwallForm" table="SwForm" persistent="true" accessors="true" extends="HibachiEntity" cacheuse="transactional" hb_serviceName="formService"  hb_processContexts="addFormQuestion,addFormResponse"  {

	// Persistent Properties
	property name="formID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="formCode" ormtype="string";
	property name="formName" ormtype="string"; 
	property name="emailTo" ormtype="string";


	// Related Object Properties (many-to-one)
	//property name="emailTemplate" cfc="EmailTemplate" fieldtype="many-to-one" fkcolumn="emailTemplateID" cascade="all";

	// Related Object Properties (one-to-many)
	property name="formQuestions" singularname="formQuestion" hb_populateEnabled="public" cfc="Attribute" fieldtype="one-to-many" fkcolumn="formID" cascade="all-delete-orphan";
	property name="formResponses" singularname="formResponse" cfc="FormResponse" fieldtype="one-to-many" fkcolumn="formID" cascade="all-delete-orphan";

	// Related Object Properties (many-to-many)

	// Remote Properties
	property name="remoteID" ormtype="string";

	// Audit Properties
	property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="createdByAccountID" hb_populateEnabled="false" ormtype="string";
	property name="modifiedDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="modifiedByAccountID" hb_populateEnabled="false" ormtype="string";


	// ============ START: Non-Persistent Property Methods =================

	// ============  END:  Non-Persistent Property Methods =================

	// ============= START: Bidirectional Helper Methods ===================

	// Email Template (many-to-one)
	/*public void function setEmailTemplate(required any emailTemplate) {
		variables.emailTemplate = arguments.emailTemplate;
		if(isNew() or !arguments.emailTemplate.hasForm( this )) {
			arrayAppend(arguments.emailTemplate.getForms(), this);
		}
	}
	public void function removeEmailTemplate(any emailTemplate) {
		if(!structKeyExists(arguments, "emailTemplate")) {
			arguments.emailTemplate = variables.emailTemplate;
		}
		var index = arrayFind(arguments.emailTemplate.getForms(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.emailTemplate.getForms(), index);
		}
		structDelete(variables, "emailTemplate");
	}*/

	// Attributes (one-to-many)
	public void function addFormQuestion(required any formQuestion) {
		arguments.formQuestion.setForm( this );
	}
	public void function removeFormQuestion(required any formQuestion) {
		arguments.formQuestion.removeForm( this );
	}

	// Form Responses (one-to-many)
	public void function addFormResponse(required any formResponse) {
		arguments.formResponse.setForm( this );
	}
	public void function removeFormResponse(required any formResponse) {
		arguments.formResponse.removeForm( this );
	}

	// =============  END:  Bidirectional Helper Methods ===================

	// =============== START: Custom Validation Methods ====================

	// ===============  END: Custom Validation Methods =====================

	// =============== START: Custom Formatting Methods ====================

	// ===============  END: Custom Formatting Methods =====================

	// ============== START: Overridden Implicet Getters ===================

	// ==============  END: Overridden Implicet Getters ====================

	// ================== START: Overridden Methods ========================

	//Spoofed Attribute Set Methods to Allow for Compatibility with SlatwallAdminAttributeSetDisplayTag
	public any function getAttributesSmartList(){
		return this.getFormQuestionsSmartList();
	}

	public string function getAttributeSetObject(){
		return "FormResponse";
	}

	public string function getAttributeSetObjectPrimaryIDPropertyName(){
		return "FormResponseID";
	}

	public string function getSimpleRepresentation(){
		return this.getFormCode();
	}

	// ==================  END:  Overridden Methods ========================

	// =================== START: ORM Event Hooks  =========================

	// ===================  END:  ORM Event Hooks  =========================

	// ================== START: Deprecated Methods ========================

	// ==================  END:  Deprecated Methods ========================
}
