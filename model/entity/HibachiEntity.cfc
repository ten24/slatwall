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
component output="false" accessors="true" persistent="false" extends="Slatwall.org.Hibachi.HibachiEntity" {

	property name="assignedAttributeSetSmartList" type="struct" persistent="false";
	property name="attributeValuesByAttributeIDStruct" type="struct" persistent="false";
	property name="attributeValuesByAttributeCodeStruct" type="struct" persistent="false";

	// @hint Override the populate method to look for custom attributes
	public any function populate( required struct data={} ) {

		// Call the super populate to do all the standard logic
		super.populate(argumentcollection=arguments);

		// Loop over attribute sets
		for(var attributeSet in getAssignedAttributeSetSmartList().getRecords()) {
			
			// Loop over attributes
			for(var attribute in attributeSet.getAttributes()) {
				if(structKeyExists(arguments.data, attribute.getAttributeCode())) {
					setAttributeValue( attribute.getAttributeCode(), nullReplace(data[ attribute.getAttributeCode() ], "") );
				}
			}
			
		}

		// Return this object
		return this;
	}

	// @hint Returns an array of comments related to this entity
	public array function getComments( boolean publicFlag ) {
		if(!structKeyExists(variables, "comments")) {
			arguments.primaryIDPropertyName = getPrimaryIDPropertyName();
			arguments.primaryIDValue = getPrimaryIDValue();
			variables.comments = getService("commentService").getRelatedCommentsForEntity( argumentCollection=arguments );
		}
		return variables.comments;
	}
	
	// @hint Returns an array of files related to this entity
	public array function getFiles() {
		if(!structKeyExists(variables, "files")) {
			arguments.baseID = getPrimaryIDValue();
			variables.files = getService("fileService").getRelatedFilesForEntity(argumentCollection=arguments);
		}
		return variables.files;
	}

	// @hint helper function to return a Setting
	public any function setting(required string settingName, array filterEntities=[], formatValue=false) {
		return getService("settingService").getSettingValue(settingName=arguments.settingName, object=this, filterEntities=arguments.filterEntities, formatValue=arguments.formatValue);
	}

	// @hint helper function to return the details of a setting
	public struct function getSettingDetails(required any settingName, array filterEntities=[]) {
		return getService("settingService").getSettingDetails(settingName=arguments.settingName, object=this, filterEntities=arguments.filterEntities);
	}

	// Attribute Value
	public boolean function hasAttributeCode( required string attributeCode ) {
		return getService("hibachiService").getEntityHasAttributeByEntityName( getClassName(), arguments.attributeCode );
	}
	
	public array function getAttributeValuesForEntity() {
		if(!structKeyExists(variables, "attributeValuesForEntity")) {
			variables.attributeValuesForEntity = [];
			if(hasProperty("attributeValues")) {
				var primaryIDPropertyIdentifier = "#replace(getEntityName(), 'Slatwall', '')#.#getPrimaryIDPropertyName()#";
				primaryIDPropertyIdentifier = lcase(left(primaryIDPropertyIdentifier, 1)) & right(primaryIDPropertyIdentifier, len(primaryIDPropertyIdentifier)-1);
				variables.attributeValuesForEntity = getService("attributeService").getAttributeValuesForEntity(primaryIDPropertyIdentifier=primaryIDPropertyIdentifier, primaryIDValue=getPrimaryIDValue());
			}
		}
		return variables.attributeValuesForEntity;
	}

	public any function getAttributeValue(required string attribute, returnEntity=false){
		var attributeValueEntity = "";

		// If an ID was passed, and that value exists in the ID struct then use it
		if(len(arguments.attribute) eq 32 && structKeyExists(getAttributeValuesByAttributeIDStruct(), arguments.attribute) ) {
			attributeValueEntity = getAttributeValuesByAttributeIDStruct()[arguments.attribute];

		// If some other string was passed check the attributeCode struct for it's existance
		} else if( structKeyExists(getAttributeValuesByAttributeCodeStruct(), arguments.attribute) ) {
			attributeValueEntity = getAttributeValuesByAttributeCodeStruct()[arguments.attribute];

		}

		// Value Entity Found, and we are returning the entire thing
		if( isObject(attributeValueEntity) && arguments.returnEntity) {
			return attributeValueEntity;

		// Value Entity Found and we are just returning the value (or the default for that attribute)
		} else if ( isObject(attributeValueEntity) ){
			if(!isNull(attributeValueEntity.getAttributeValue()) && len(attributeValueEntity.getAttributeValue())) {
				return attributeValueEntity.getAttributeValue();
			} else if (!isNull(attributeValueEntity.getAttribute().getDefaultValue()) && len(attributeValueEntity.getAttribute().getDefaultValue())) {
				return attributeValueEntity.getAttribute().getDefaultValue();
			}

		// Attribute was not found, and we wanted an entity back
		} else if(arguments.returnEntity) {
			var newAttributeValue = getService("attributeService").newAttributeValue();
			newAttributeValue.setAttributeValueType( lcase( replace(getEntityName(),'Slatwall','') ) );
			var thisAttribute = getService("attributeService").getAttributeByAttributeCode( arguments.attribute );
			if(isNull(thisAttribute) && len(arguments.attribute) eq 32) {
				thisAttribute = getService("attributeService").getAttributeByAttributeID( arguments.attribute );
			}
			if(!isNull(thisAttribute)) {
				newAttributeValue.setAttribute( thisAttribute );
			}
			//newAttributeValue.invokeMethod("set#getClassName()#", {1=this});
			return newAttributeValue;

		}

		// If the attributeValueEntity wasn't found, then lets just go look at the actual attribute object by ID/CODE for a defaultValue
		if(len(arguments.attribute) eq 32) {
			var attributeEntity = getService("attributeService").getAttribute(arguments.attribute);
		} else {
			var attributeEntity = getService("attributeService").getAttributeByAttributeCode(arguments.attribute);
		}
		if(!isNull(attributeEntity) && !isNull(attributeEntity.getDefaultValue()) && len(attributeEntity.getDefaultValue())) {
			return attributeEntity.getDefaultValue();
		}

		return "";
	}
	
	public any function setAttributeValue(required string attribute, required any value){
		
		var attributeValueEntity = getAttributeValue( arguments.attribute, true);
		attributeValueEntity.setAttributeValue( arguments.value );
		attributeValueEntity.invokeMethod("set#attributeValueEntity.getAttributeValueType()#", {1=this});

		// If this attribute value is new, then we can add it to the array
		if(attributeValueEntity.isNew()) {
			this.addAttributeValue( attributeValueEntity );
		}

		// Update the cache for this attribute value
		getAttributeValuesByAttributeCodeStruct()[ attributeValueEntity.getAttribute().getAttributeCode() ] = attributeValueEntity;
		getAttributeValuesByAttributeIDStruct()[ attributeValueEntity.getAttribute().getAttributeID() ] = attributeValueEntity;
			
	}

	public any function getAssignedAttributeSetSmartList(){
		if(!structKeyExists(variables, "assignedAttributeSetSmartList")) {
			variables.assignedAttributeSetSmartList = getService("attributeService").getAttributeSetSmartList();
			variables.assignedAttributeSetSmartList.setSelectDistinctFlag( true );
			variables.assignedAttributeSetSmartList.joinRelatedProperty("SlatwallAttributeSet", "attributes", "INNER", true);
			variables.assignedAttributeSetSmartList.addFilter('activeFlag', 1);
			variables.assignedAttributeSetSmartList.addFilter('globalFlag', 1);
			variables.assignedAttributeSetSmartList.addFilter('attributeSetType.systemCode', 'ast#replace(getEntityName(),'Slatwall','')#');
		}

		return variables.assignedAttributeSetSmartList;
	}

	public struct function getAttributeValuesByAttributeIDStruct() {
		if(!structKeyExists(variables, "attributeValuesByAttributeIDStruct")) {
			variables.attributeValuesByAttributeIDStruct = {};
			if(hasProperty("attributeValues")) {
				var attributeValues = getAttributeValuesForEntity();
				for(var i=1; i<=arrayLen(attributeValues); i++){
					variables.attributeValuesByAttributeIDStruct[ attributeValues[i].getAttribute().getAttributeID() ] = attributeValues[i];
				}
			}
		}

		return variables.attributeValuesByAttributeIDStruct;
	}

	public struct function getAttributeValuesByAttributeCodeStruct() {
		if(!structKeyExists(variables, "attributeValuesByAttributeCodeStruct")) {
			variables.attributeValuesByAttributeCodeStruct = {};
			if(hasProperty("attributeValues")) {
				var attributeValues = getAttributeValuesForEntity();
				for(var i=1; i<=arrayLen(attributeValues); i++){
					variables.attributeValuesByAttributeCodeStruct[ attributeValues[i].getAttribute().getAttributeCode() ] = attributeValues[i];
				}
			}
		}

		return variables.attributeValuesByAttributeCodeStruct;
	}

	public void function clearAttributeCache() {
		if(structKeyExists(variables, "attributeValuesByAttributeIDStruct")) {
			structDelete(variables, "attributeValuesByAttributeIDStruct");
		}
		if(structKeyExists(variables, "attributeValuesByAttributeCodeStruct")) {
			structDelete(variables, "attributeValuesByAttributeCodeStruct");
		}
	}

	public array function getPrintTemplates() {
		if(!structKeyExists(variables, "printTemplates")) {
			var sl = getService("templateService").getPrintTemplateSmartList();
			sl.addFilter('printTemplateObject', getClassName());
			variables.printTemplates = sl.getRecords();
		}
		return variables.printTemplates;
	}

	public array function getEmailTemplates() {
		if(!structKeyExists(variables, "emailTemplates")) {
			var sl = getService("templateService").getEmailTemplateSmartList();
			sl.addFilter('emailTemplateObject', getClassName());
			variables.emailTemplates = sl.getRecords();
		}
		return variables.emailTemplates;
	}
	
	public string function getShortReferenceID( boolean createNewFlag=false ) {
		return getService("dataService").getShortReferenceID(referenceObjectID=getPrimaryIDValue(), referenceObject=getClassName(), createNewFlag=arguments.createNewFlag);
	}

}