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
component displayname="FormResponse" entityname="SlatwallFormResponse" table="SwFormResponse" persistent="true" accessors="true" extends="HibachiEntity" cacheuse="transactional" hb_serviceName="formService" {

	// Persistent Properties
	property name="formResponseID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";

	// Related Object Properties (many-to-one)
	property name="form" cfc="Form" fieldtype="many-to-one" fkcolumn="formID";

	// Related Object Properties (one-to-many)
	property name="attributeValues" singularname="attributeValue" cfc="AttributeValue" fieldtype="one-to-many" fkcolumn="formResponseID" cascade="all-delete-orphan";

	// Related Object Properties (many-to-many)

	// Remote Properties
	property name="remoteID" ormtype="string";

	// Audit Properties
	property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="createdByAccountID" hb_populateEnabled="false" ormtype="string";
	property name="modifiedDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="modifiedByAccountID" hb_populateEnabled="false" ormtype="string";

    property name="attributes" persistent="false"; 

	// ============ START: Non-Persistent Property Methods =================

	public any function getAttributes() {
        if(!structKeyExists(variables, "attributes")){
            variables.attributes = this.getForm().getFormQuestions(); 
        }
        return variables.attributes;
	} 

	public any function getFormEmailConfirmationValue(){
 		var attributeValueSmartList = getPropertySmartList('attributeValues'); 
 		attributeValueSmartList.addFilter('attribute.formEmailConfirmationFlag', true); 
 		var formEmailConfirmationValue = attributeValueSmartList.getFirstRecord(); 
 		if(!isNull(formEmailConfirmationValue)){
 			return formEmailConfirmationValue.getAttributeValue(); 
 		} 
 	} 

	// ============  END:  Non-Persistent Property Methods =================

	// ============= START: Bidirectional Helper Methods ===================

	/// Form (many-to-one)
	public void function setForm(required any form) {
		variables.form = arguments.form;
		if(isNew() or !arguments.form.hasFormResponse( this )) {
			arrayAppend(arguments.form.getFormResponses(), this);
		}
	}
	public void function removeForm(any form) {
		if(!structKeyExists(arguments, "form")) {
			arguments.form = variables.form;
		}
		var index = arrayFind(arguments.form.getFormResponses(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.form.getFormResponses(), index);
		}
		structDelete(variables, "formResponse");
	}

	// Attribute Values (one-to-many)
	public void function addAttributeValue(required any attributeValue) {
		arguments.attributeValue.setFormResponse( this );
	}
	public void function removeAttributeValue(required any attributeValue) {
		arguments.attributeValue.removeFormResponse( this );
	}

	// =============  END:  Bidirectional Helper Methods ===================

	// =============== START: Custom Validation Methods ====================

	// ===============  END: Custom Validation Methods =====================

	// =============== START: Custom Formatting Methods ====================

	// ===============  END: Custom Formatting Methods =====================

	// ============== START: Overridden Implicet Getters ===================

	// ==============  END: Overridden Implicet Getters ====================

	// ================== START: Overridden Methods ========================

    public any function getAttributeValuesByAttributeCodeStruct(){ 
        if(!structKeyExists(variables, "attributeValuesByAttributeCodeStruct")){
            variables.attributeValuesByAttributeCodeStruct = {}; 
            for (var attributeValue in this.getAttributeValues()){
                variables.attributeValuesByAttributeCodeStruct[attributeValue.getAttribute().getAttributeCode()] = attributeValue; 
            }
        } 
        return variables.attributeValuesByAttributeCodeStruct; 
    } 
    

    public any function onMissingMethod(required string missingMethodName, required any missingMethodArguments ){
		var attributeValuesByCode = getAttributeValuesByAttributeCodeStruct();
		var attributeCode = right(arguments.missingMethodName, len(arguments.missingMethodName)-3); 
		if (structKeyExists(attributeValuesByCode, attributeCode)) {
			return attributeValuesByCode[attributeCode].getAttributeValue();	
        }
        return super.onMissingMethod(arguments.missingMethodName, arguments.missingMethodArguments);
    }
	// ==================  END:  Overridden Methods ========================

	// =================== START: ORM Event Hooks  =========================

	// ===================  END:  ORM Event Hooks  =========================

	// ================== START: Deprecated Methods ========================

	// ==================  END:  Deprecated Methods ========================
}
