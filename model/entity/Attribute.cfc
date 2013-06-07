/*

    Slatwall - An Open Source eCommerce Platform
    Copyright (C) 2011 ten24, LLC

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
    
    Linking this library statically or dynamically with other modules is
    making a combined work based on this library.  Thus, the terms and
    conditions of the GNU General Public License cover the whole
    combination.
 
    As a special exception, the copyright holders of this library give you
    permission to link this library with independent modules to produce an
    executable, regardless of the license terms of these independent
    modules, and to copy and distribute the resulting executable under
    terms of your choice, provided that you also meet, for each linked
    independent module, the terms and conditions of the license of that
    module.  An independent module is a module which is not derived from
    or based on this library.  If you modify this library, you may extend
    this exception to your version of the library, but you are not
    obligated to do so.  If you do not wish to do so, delete this
    exception statement from your version.

Notes:

*/
component displayname="Attribute" entityname="SlatwallAttribute" table="SlatwallAttribute" persistent="true" output="false" accessors="true" extends="HibachiEntity" cacheuse="transactional" hb_serviceName="attributeService" hb_permission="attributeSet.attributes" {
	
	// Persistent Properties
	property name="attributeID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="activeFlag" ormtype="boolean" default=1;
	property name="attributeName" ormtype="string";
	property name="attributeCode" ormtype="string";
	property name="attributeDescription" ormtype="string" length="4000" ;
	property name="attributeHint" ormtype="string";
	property name="defaultValue" ormtype="string";
	property name="requiredFlag" ormtype="boolean" default="false" ;
	property name="sortOrder" ormtype="integer" sortContext="attributeSet";
	property name="validationMessage" ormtype="string";
	property name="validationRegex" ormtype="string";
	property name="decryptValueInAdminFlag" ormtype="boolean";
	
	// Related Object Properties (Many-To-One)
	property name="attributeSet" cfc="AttributeSet" fieldtype="many-to-one" fkcolumn="attributeSetID" hb_optionsNullRBKey="define.select";
	property name="attributeType" cfc="Type" fieldtype="many-to-one" fkcolumn="attributeTypeID" hb_optionsSmartListData="f:parentType.systemCode=attributeType" fetch="join";
	property name="validationType" cfc="Type" fieldtype="many-to-one" fkcolumn="validationTypeID" hb_optionsNullRBKey="define.select" hb_optionsSmartListData="f:parentType.systemCode=validationType";

	// Related Object Properties (One-To-Many)
	property name="attributeOptions" singularname="attributeOption" cfc="AttributeOption" fieldtype="one-to-many" fkcolumn="attributeID" inverse="true" cascade="all-delete-orphan" orderby="sortOrder";
	property name="attributeValues" singularname="attributeValue" cfc="AttributeValue" fieldtype="one-to-many" fkcolumn="attributeID" inverse="true" cascade="all-delete-orphan";
	
	// Audit properties
	property name="createdDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="createdByAccount" hb_populateEnabled="false" cfc="Account" fieldtype="many-to-one" fkcolumn="createdByAccountID";
	property name="modifiedDateTime" hb_populateEnabled="false" ormtype="timestamp";
	property name="modifiedByAccount" hb_populateEnabled="false" cfc="Account" fieldtype="many-to-one" fkcolumn="modifiedByAccountID";
	
	// Non-Persistent Properties
	property name="formFieldType" persistent="false";
	property name="attributeTypeOptions" persistent="false";
	property name="validationTypeOptions" persistent="false";
	
	public array function getAttributeOptions(string orderby, string sortType="text", string direction="asc") {
		if(!structKeyExists(arguments,"orderby")) {
			return variables.AttributeOptions;
		} else {
			return getService("hibachiUtilityService").sortObjectArray(variables.AttributeOptions,arguments.orderby,arguments.sortType,arguments.direction);
		}
	}

    // ============ START: Non-Persistent Property Methods =================
    
	public string function getFormFieldType() {
		if(!structKeyExists(variables, "formFieldType")) {
			var attributeTypeSystemCode = getAttributeType().getSystemCode();
			variables.formFieldType = right(attributeTypeSystemCode, len(attributeTypeSystemCode)-2);
		}
		return variables.formFieldType;
	}
	
	public array function getAttributeTypeOptions() {
		if(!structKeyExists(variables, "attributeTypeOptions")) {
			var smartList = getService("settingService").getTypeSmartList();
			smartList.addSelect(propertyIdentifier="type", alias="name");
			smartList.addSelect(propertyIdentifier="typeID", alias="value");
			smartList.addFilter(propertyIdentifier="parentType_systemCode", value="attributeType"); 
			smartList.addOrder("type|ASC");
			variables.attributeTypeOptions = smartList.getRecords();
		}
		return variables.attributeTypeOptions;
    }
   
    public array function getValidationTypeOptions() {
		if(!structKeyExists(variables, "validationTypeOptions")) {
			var smartList = getService("settingService").getTypeSmartList();
			smartList.addSelect(propertyIdentifier="type", alias="name");
			smartList.addSelect(propertyIdentifier="typeID", alias="value");
			smartList.addFilter(propertyIdentifier="parentType_systemCode", value="validationType"); 
			variables.validationTypeOptions = smartList.getRecords();
			arrayPrepend(variables.validationTypeOptions, {value="", name=rbKey('define.none')});
		}
		return variables.validationTypeOptions;
    }
	
	public array function getAttributeOptionsOptions() {
		if(!structKeyExists(variables, "attributeOptionsOptions")) {
			var smartList = getService("attributeOption").getAttributeOptionSmartList();
			smartList.addSelect(propertyIdentifier="attributeOptionLabel", alias="name");
			smartList.addSelect(propertyIdentifier="attributeOptionValue", alias="value");
			smartList.addFilter(propertyIdentifier="attribute_attributeID", value="#variables.attributeID#"); 
			smartList.addOrder("sortOrder|ASC");
			variables.attributeOptionsOptions = smartList.getRecords();
			if(variables.attributeType.getSystemCode() == "atSelect") {
				arrayPrepend(variables.attributeOptionsOptions, {value="", name=rbKey('define.select')});
			}
		}
		return variables.attributeOptionsOptions;
    }
   
	// ============  END:  Non-Persistent Property Methods =================
	
    // ============= START: Bidirectional Helper Methods ===================
    
	// Attribute Set (many-to-one)    
	public void function setAttributeSet(required any attributeSet) {    
		variables.attributeSet = arguments.attributeSet;
		if(isNew() or !arguments.attributeSet.hasAttribute( this )) {
			arrayAppend(arguments.attributeSet.getAttributes(), this);
		}
	}
	public void function removeAttributeSet(any attributeSet) {    
		if(!structKeyExists(arguments, "attributeSet")) {    
			arguments.attributeSet = variables.attributeSet;    
		}    
		var index = arrayFind(arguments.attributeSet.getAttributes(), this);    
		if(index > 0) {    
			arrayDeleteAt(arguments.attributeSet.getAttributes(), index);    
		}    
		structDelete(variables, "attributeSet");    
	}
    
	// Attribute Options (one-to-many)    
	public void function addAttributeOption(required any attributeOption) {    
		arguments.attributeOption.setAttribute( this );    
	}    
	public void function removeAttributeOption(required any attributeOption) {    
		arguments.attributeOption.removeAttribute( this );    
	}
	
	// Attribute Values (one-to-many)
	public void function addAttributeValue(required any attributeValue) {
		arguments.attributeValue.setAttribute( this );
	}
	public void function removeAttributeValue(required any attributeValue) {
		arguments.attributeValue.removeAttribute( this );
	}
	
	// =============  END:  Bidirectional Helper Methods ===================
	
	// ================== START: Overridden Methods ========================

	public any function getAttributeOptionsSmartlist() {
		return getPropertySmartList( "attributeOptions" );
	}
	
	// ==================  END:  Overridden Methods ========================
		
	// =================== START: ORM Event Hooks  =========================
	
	// ===================  END:  ORM Event Hooks  =========================
}
