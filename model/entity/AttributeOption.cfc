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
component displayname="Attribute Option" entityname="SlatwallAttributeOption" table="SwAttributeOption" persistent="true" accessors="true" output="false" extends="HibachiEntity" cacheuse="transactional" hb_serviceName="attributeService" hb_property="attribute.attributeOptions" {

	// Persistent Properties
	property name="attributeOptionID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="attributeOptionValue" ormtype="string";
	property name="attributeOptionLabel" ormtype="string";
	property name="sortOrder" ormtype="integer" sortContext="attribute";

	// Calculated Properties

	// Related Object Properties (many-to-one)
	property name="attribute" cfc="Attribute" fieldtype="many-to-one" fkcolumn="attributeID";

	// Related Object Properties (one-to-many)
	property name="attributeValues" singularname="attributeValue" cfc="AttributeValue" fieldtype="one-to-many" fkcolumn="attributeOptionID" cascade="all-delete-orphan" inverse="true";

	// Related Object Properties (many-to-many - owner)

	// Related Object Properties (many-to-many - inverse)

	// Remote Properties
	property name="remoteID" hb_populateEnabled="false" ormtype="string";

	// Audit Properties
	property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="createdByAccountID" hb_populateEnabled="false" ormtype="string";
	property name="modifiedDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="modifiedByAccountID" hb_populateEnabled="false" ormtype="string";

	// Non-Persistent Properties

	// Deprecated Properties


	// ==================== START: Logical Methods =========================

	// ====================  END: Logical Methods ==========================

	// ============ START: Non-Persistent Property Methods =================

	public string function getAttributeOptionLabel() {
		if(structkeyExists(variables,"attributeOptionLabel")) {
			return variables["attributeOptionLabel"];
		} else if( !isNull(getAttributeOptionValue()) ) {
			return hibachiHTMLEditFormat( getAttributeOptionValue() );
		}else{
			return "";
		}
	}

	public any function getEntityWithOptionSmartList() {
		var relatedObject = getAttribute().getAttributeSet().getAttributeSetObject();
		var entityService = getService( "hibachiService" ).getServiceByEntityName(relatedObject);
		var smartList = entityService.invokeMethod("get#relatedObject#SmartList");

		smartList.addFilter(getAttribute().getAttributeCode(), getAttributeOptionValue());

		return smartList;

	}

	// ============  END:  Non-Persistent Property Methods =================

	// ============= START: Bidirectional Helper Methods ===================

	// Attribute (many-to-one)
	public void function setAttribute(required any attribute) {
		variables.attribute = arguments.attribute;
		if(isNew() or !arguments.attribute.hasAttributeOption( this )) {
			arrayAppend(arguments.attribute.getAttributeOptions(), this);
		}
	}
	public void function removeAttribute(any attribute) {
		if(!structKeyExists(arguments, "attribute")) {
			arguments.attribute = variables.attribute;
		}
		var index = arrayFind(arguments.attribute.getAttributeOptions(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.attribute.getAttributeOptions(), index);
		}
		structDelete(variables, "attribute");
	}

	// Attribute Values (one-to-many)
	public void function addAttributeValue(required any attributeValue) {
		arguments.attributeValue.setAttributeOption( this );
	}
	public void function removeAttributeValue(required any attributeValue) {
		arguments.attributeValue.removeAttributeOption( this );
	}

	// =============  END:  Bidirectional Helper Methods ===================

	// =============== START: Custom Validation Methods ====================

	// ===============  END: Custom Validation Methods =====================

	// =============== START: Custom Formatting Methods ====================

	// ===============  END: Custom Formatting Methods =====================

	// ============== START: Overridden Implicit Getters ===================

	// ==============  END: Overridden Implicit Getters ====================

	// ============= START: Overridden Smart List Getters ==================

	// =============  END: Overridden Smart List Getters ===================

	// ================== START: Overridden Methods ========================

	public string function getSimpleRepresentationPropertyName() {
		return "attributeOptionLabel";
	}

	// ==================  END:  Overridden Methods ========================

	// =================== START: ORM Event Hooks  =========================

	// ===================  END:  ORM Event Hooks  =========================

	// ================== START: Deprecated Methods ========================

	// ==================  END:  Deprecated Methods ========================

}

