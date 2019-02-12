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
component displayname="Attribute" entityname="SlatwallAttribute" table="SwAttribute" persistent="true" output="false" accessors="true" extends="HibachiEntity" cacheuse="transactional" hb_serviceName="attributeService" hb_permission="attributeSet.attributes" {


	// Persistent Properties
	property name="attributeID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
	property name="activeFlag" hb_populateEnabled="public" ormtype="boolean" default=1;
	property name="displayOnOrderDetailFlag" ormtype="boolean" default=0;
	property name="attributeName" hb_populateEnabled="public" ormtype="string";
	property name="attributeCode" hb_populateEnabled="public" ormtype="string" index="PI_ATTRIBUTECODE";
	property name="attributeDescription" hb_populateEnabled="public" ormtype="string" length="4000" ;
	property name="attributeHint" hb_populateEnabled="public" ormtype="string";
	property name="attributeInputType" hb_populateEnabled="public" ormtype="string" hb_formFieldType="select" hb_formatType="rbKey";
	property name="defaultValue" hb_populateEnabled="public" ormtype="string";
	property name="formEmailConfirmationFlag" hb_populateEnabled="public" ormtype="boolean" default="false" ;
	property name="requiredFlag" hb_populateEnabled="public" ormtype="boolean" default="false" ;
	property name="sortOrder" ormtype="integer" sortContext="attributeSet";
	property name="validationMessage" hb_populateEnabled="public" ormtype="string";
	property name="validationRegex" hb_populateEnabled="public" ormtype="string";
	property name="decryptValueInAdminFlag" ormtype="boolean";
	property name="relatedObject" hb_populateEnabled="public" ormtype="string" hb_formFieldType="select";
	property name="maxFileSize" hb_populateEnabled="public" ormtype="integer";
	property name="customPropertyFlag" ormtype="boolean" default="false";
	property name="isMigratedFlag" ormtype="boolean" default="false";

	property name="relatedObjectCollectionConfig" ormtype="string" length="8000" hb_auditable="false" hb_formFieldType="json" hint="json object used to construct the base collection HQL query";
	property name="urlTitle" ormtype="string" unique="true" description="URL Title defines the string in a URL that Slatwall will use to identify this attribute.  For Example: http://www.myslatwallsite.com/att/my-url-title/ where att is the global attribute url key, and my-url-title is the urlTitle of this attribtue";
	// Calculated Properties

	// Related Object Properties (many-to-one)
	property name="typeSet" cfc="Type" fieldtype="many-to-one" fkcolumn="typeSetID";
	property name="attributeSet" cfc="AttributeSet" fieldtype="many-to-one" fkcolumn="attributeSetID" hb_optionsNullRBKey="define.select";
	property name="validationType" cfc="Type" fieldtype="many-to-one" fkcolumn="validationTypeID" hb_optionsNullRBKey="define.select" hb_optionsSmartListData="f:parentType.systemCode=validationType";
	property name="form" cfc="Form" fieldtype="many-to-one" fkcolumn="formID";
	property name="attributeOptionSource" cfc="Attribute" fieldtype="many-to-one" fkcolumn="attributeOptionSourceID" hb_formFieldType="select";

	// Related Object Properties (one-to-many)
	property name="attributeOptions" singularname="attributeOption" cfc="AttributeOption" fieldtype="one-to-many" fkcolumn="attributeID" inverse="true" cascade="all-delete-orphan" orderby="sortOrder";
	property name="attributeValues" singularname="attributeValue" cfc="AttributeValue" fieldtype="one-to-many" fkcolumn="attributeID" inverse="true" cascade="delete-orphan";

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
	property name="attributeInputTypeOptions" persistent="false";
	property name="attributeValueUploadDirectory" persistent="false";
	property name="formFieldType" persistent="false";
	property name="relatedObjectOptions" persistent="false";
	property name="typeSetOptions" persistent="false";
	property name="validationTypeOptions" persistent="false";
	property name="relatedObjectCollectionConfigStruct" persistent="false";
	property name="attributeOptionSourceOptions" type="array" persistent="false";

	// Deprecated Properties
	property name="attributeType" persistent="false";

	// ==================== START: Logical Methods =========================

	// ====================  END: Logical Methods ==========================

	// ============ START: Non-Persistent Property Methods =================

	public array function getAttributeOptionSourceOptions(){
		if(!structKeyExists(variables,'attributeOptionSourceOptions')){
			var attributeOptionSourceOptionsCollectionList = getService('attributeService').getAttributeCollectionList();
			attributeOptionSourceOptionsCollectionList.setDisplayProperties('attributeName|name,attributeID|value');
			attributeOptionSourceOptionsCollectionList.addFilter('attributeInputType','checkboxGroup,multiselect,radioGroup,select','IN');
			attributeOptionSourceOptionsCollectionList.addFilter('attributeOptionSource','NULL','IS');
			attributeOptionSourceOptionsCollectionList.addFilter('attributeID',getAttributeID(),'!=');
			variables.attributeOptionSourceOptions = attributeOptionSourceOptionsCollectionList.getRecords();
			arrayprepend(variables.attributeOptionSourceOptions,{name="None",value=""});
		}

		return variables.attributeOptionSourceOptions;
	}

	public struct function getRelatedObjectCollectionConfigStruct(){
		if(!structKeyExists(variables,'relatedObjectCollectionConfigStruct')){
			variables.relatedObjectCollectionConfigStruct = deserializeJson(getRelatedObjectCollectionConfig());
		}
		return variables.relatedObjectCollectionConfigStruct;
	}

	public string function getRelatedObjectCollectionConfig(){
		if(!structKeyExists(variables,'relatedObjectCollectionConfig')){
			var entityCollectionList = getService('HibachiService').getCollectionList(getRelatedObject());

			variables.relatedObjectCollectionConfig = serializeJson(entityCollectionList.getCollectionConfigStruct());
		}
		return variables.relatedObjectCollectionConfig;
	}

	public void function setRelatedObjectCollectionConfig(string relatedObjectCollectionConfig){
		variables.relatedObjectCollectionConfig = arguments.relatedObjectCollectionConfig;
	}

	public array function getAttributeOptions(string orderby, string sortType="text", string direction="asc") {

		if(!isNull(getAttributeOptionSource())){
    		var currentAttributeOptions = getAttributeOptionSource().getAttributeOptions();
    	}else{
    		var currentAttributeOptions = variables.attributeOptions;
    	}

		if(!structKeyExists(arguments,"orderby")) {
			return currentAttributeOptions;
		} else {
			return getService("hibachiUtilityService").sortObjectArray(currentAttributeOptions,arguments.orderby,arguments.sortType,arguments.direction);
		}
	}

	public array function getAttributeInputTypeOptions() {
		return [
			{value="checkbox", name=rbKey("entity.attribute.attributeInputType.checkbox")},
			{value="checkboxGroup", name=rbKey("entity.attribute.attributeInputType.checkboxGroup")},
			{value="date", name=rbKey("entity.attribute.attributeInputType.date")},
			{value="dateTime", name=rbKey("entity.attribute.attributeInputType.dateTime")},
			{value="email", name=rbKey("etity.attribute.attributeInputType.email")},
			{value="file", name=rbKey("entity.attribute.attributeInputType.file")},
			{value="multiselect", name=rbKey("entity.attribute.attributeInputType.multiselect")},
			{value="password", name=rbKey("entity.attribute.attributeInputType.password")},
			{value="radioGroup", name=rbKey("entity.attribute.attributeInputType.radioGroup")},
			{value="relatedObjectSelect", name=rbKey("entity.attribute.attributeInputType.relatedObjectSelect")},
			{value="relatedObjectMultiselect", name=rbKey("entity.attribute.attributeInputType.relatedObjectMultiselect")},
			{value="select", name=rbKey("entity.attribute.attributeInputType.select")},
			{value="typeSelect", name=rbKey("entity.attribute.attributeInputType.typeSelect")},
			{value="text", name=rbKey("entity.attribute.attributeInputType.text")},
			{value="textArea", name=rbKey("entity.attribute.attributeInputType.textArea")},
			{value="time", name=rbKey("entity.attribute.attributeInputType.time")},
			{value="wysiwyg", name=rbKey("entity.attribute.attributeInputType.wysiwyg")},
			{value="yesNo", name=rbKey("entity.attribute.attributeInputType.yesNo")}
		];
    }

    public string function getAttributeValueUploadDirectory() {
		var uploadDirectory = setting('globalAssetsFileFolderPath') & "/";

		if(!isNull(getAttributeCode()) && len(getAttributeCode())) {
			uploadDirectory &= "#lcase(getAttributeCode())#/";
		}

		return uploadDirectory;
	}

	public string function getFormFieldType() {
		if(!structKeyExists(variables, "formFieldType")) {
			variables.formFieldType = "text";
			if(!isNull(getAttributeInputType())) {
				variables.formFieldType = getAttributeInputType();
			}
			if(variables.formFieldType == 'typeSelect') {
				variables.formFieldType = 'select';
			} else if(variables.formFieldType == 'relatedObjectSelect') {
				variables.formFieldType = 'listingSelect';
			} else if (variables.formFieldType == 'relatedObjectMultiselect') {
				variables.formFieldType = 'listingMultiselect';
			}
		}
		return variables.formFieldType;
	}

	public array function getRelatedObjectOptions() {
		if(!structKeyExists(variables, "relatedObjectOptions")) {
			var emd = getService("hibachiService").getEntitiesMetaData();
			var enArr = listToArray(structKeyList(emd));
			arraySort(enArr,"text");
			variables.relatedObjectOptions = [{name=getHibachiScope().rbKey('define.select'), value=''}];
			for(var i=1; i<=arrayLen(enArr); i++) {
				arrayAppend(variables.relatedObjectOptions, {name=rbKey('entity.#enArr[i]#'), value=enArr[i]});
			}
		}
		return variables.relatedObjectOptions;
	}

	public array function getTypeSetOptions() {
		if(!structKeyExists(variables, "typeSetOptions")) {
			var smartList = getService("typeService").getTypeSmartList();
			smartList.addSelect(propertyIdentifier="typeName", alias="name");
			smartList.addSelect(propertyIdentifier="typeID", alias="value");
			smartList.addFilter(propertyIdentifier="parentType", value="NULL");
			smartList.addOrder("typeName|ASC");

			variables.typeSetOptions = smartList.getRecords();
			arrayPrepend(variables.typeSetOptions, {value="", name=rbKey('define.select')});
		}
		return variables.typeSetOptions;
    }

    public array function getValidationTypeOptions() {
		if(!structKeyExists(variables, "validationTypeOptions")) {
			var smartList = getService("typeService").getTypeSmartList();
			smartList.addSelect(propertyIdentifier="typeName", alias="name");
			smartList.addSelect(propertyIdentifier="typeID", alias="value");
			smartList.addFilter(propertyIdentifier="parentType.systemCode", value="validationType");
			variables.validationTypeOptions = smartList.getRecords();
			arrayPrepend(variables.validationTypeOptions, {value="", name=rbKey('define.none')});
		}
		return variables.validationTypeOptions;
    }



	public array function getAttributeOptionsOptions() {
		if(!structKeyExists(variables, "attributeOptionsOptions")) {
			variables.attributeOptionsOptions = [];

			var unselectedValue = {};
			unselectedValue['name'] = rbKey('define.select');
			unselectedValue['value'] = '';

			if(listFindNoCase('checkBoxGroup,multiselect,radioGroup,select', getAttributeInputType())) {
				if(!isNull(getAttributeOptionSource())){
		    		var smartlist = getAttributeOptionSource().getAttributeOptionsSmartList();
		    	}else{
				var smartList = this.getAttributeOptionsSmartList();
				}
				smartList.addSelect(propertyIdentifier="attributeOptionLabel", alias="name");
				smartList.addSelect(propertyIdentifier="attributeOptionValue", alias="value");
				smartList.addOrder("sortOrder|ASC");
				variables.attributeOptionsOptions = smartList.getRecords();

				if(
					getAttributeInputType() == 'select'
					&& (
						arraylen(variables.attributeOptionsOptions)
						&& variables.attributeOptionsOptions[1]['value'] != ''
					) || !arraylen(variables.attributeOptionsOptions)
				) {
					arrayPrepend(variables.attributeOptionsOptions, unselectedValue);
				}

			} else if(listFindNoCase('relatedObjectSelect', getAttributeInputType()) && !isNull(getRelatedObject())) {

				var entityService = getService( "hibachiService" ).getServiceByEntityName( getRelatedObject() );
				var smartList = entityService.invokeMethod("get#getRelatedObject()#SmartList");
				var exampleEntity = entityService.invokeMethod("new#getRelatedObject()#");

				smartList.addSelect(propertyIdentifier=exampleEntity.getSimpleRepresentationPropertyName(), alias="name");
				smartList.addSelect(propertyIdentifier=getService( "hibachiService" ).getPrimaryIDPropertyNameByEntityName( getRelatedObject() ), alias="value");

				variables.attributeOptionsOptions = smartList.getRecords();

				arrayPrepend(variables.attributeOptionsOptions, unselectedValue);

			} else if(listFindNoCase('typeSelect', getAttributeInputType()) && !isNull(getTypeSet())) {

				var smartList = getService('typeService').getTypeSmartList();
				smartList.addSelect(propertyIdentifier='typeName', alias='name');
				smartList.addSelect(propertyIdentifier='typeID', alias='value');
				smartList.addFilter(propertyIdentifier='parentType.typeID', value=getTypeSet().getTypeID());

				variables.attributeOptionsOptions = smartList.getRecords();
				arrayPrepend(variables.attributeOptionsOptions,unselectedValue);
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

	/// Form (many-to-one)
	public void function setForm(required any form) {
		variables.form = arguments.form;
		if(isNew() or !arguments.form.hasFormQuestion( this )) {
			arrayAppend(arguments.form.getFormQuestions(), this);
		}
	}
	public void function removeForm(any form) {
		if(!structKeyExists(arguments, "form")) {
			arguments.form = variables.form;
		}
		var index = arrayFind(arguments.form.getFormQuestions(), this);
		if(index > 0) {
			arrayDeleteAt(arguments.form.getFormQuestions(), index);
		}
		structDelete(variables, "form");
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
	
	public boolean function isValidPropertyName(){
		if(
			isNull(getAttributeSet())
			|| isNull(getAttributeCode())
		){
			return false;
		}
		
		return !getService('HibachiService').getEntityHasPropertyByEntityName(
			getAttributeSet().getAttributeSetObject(),
			getAttributeCode()	
		);
	}

	public boolean function isValidString(string stringValue){
		var attributeCodeLength = len(getAttributeCode());

		return attributeCodeLength < len(arguments.stringValue)
		|| (attributeCodeLength >= len(arguments.stringValue)
		&& lcase(right(getAttributeCode(),len(arguments.stringValue)))!=lcase(arguments.stringValue));
	}

	public boolean function isValidAttributeCode(){
		//attribute code cannot begin with a string
		var isValid = refind("^[a-zA-Z][a-zA-Z0-9_]*$",getAttributeCode());

		return isValid
		&& isValidString("Options")
		&& isValidString("Count")
		&& isValidString("AssignedIDList")
		&& isValidString("OptionsSmartList")
		&& isValidString("SmartList")
		&& isValidString("CollectionList")
		&& isValidString("Struct")
		&& isValidString("ID")
		&& isValidString("FileURL")
		&& isValidString("UploadDirectory")
		;
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

	public any function getAttributeOptionsSmartlist() {
		return getPropertySmartList( "attributeOptions" );
	}

	// ==================  END:  Overridden Methods ========================

	// =================== START: ORM Event Hooks  =========================

	// ===================  END:  ORM Event Hooks  =========================

	// ================== START: Deprecated Methods ========================

	public any function getAttributeType() {
		if(!structKeyExists(variables, "attributeType") && !isNull(getAttributeInputType()) ) {
			variables.attributeType = getService('settingService').newType();
			variables.attributeType.setSystemCode( "at#getAttributeInputType()#" );
		}
		if(structKeyExists(variables, "attributeType")) {
			return variables.attributeType;
		}
	}

	// ==================  END:  Deprecated Methods ========================

}
