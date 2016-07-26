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

component  extends="HibachiService" accessors="true" {

	property name="attributeDAO";

	// ===================== START: Logical Methods ===========================
	
	
	
	private struct function getAttributeSetMetaData(required attributeSet){
		
		var attributeSetMetaData = {};
		attributeSetMetaData['attributeSetName'] = attributeSet.getAttributeSetName();
		attributeSetMetaData['attributeSetCode'] = attributeSet.getAttributeSetCode();
		attributeSetMetaData['attributeSetDescription'] = attributeSet.getAttributeSetDescription();
		
		attributeSetMetaData['attributes'] = {};
		var attributesCollectionList = attributeSet.getAttributesCollectionList();
		var displayPropertiesList = 'attributeCode,attributeDescription,attributeHint,attributeInputType,attributeName,defaultValue,relatedObject,requiredFlag,sortOrder,validationMessage,validationRegex';
		attributesCollectionList.setDisplayProperties(displayPropertiesList);
		var attributes = attributeSet.getAttributesCollectionList().getRecords();
		for(var attribute in attributes){
			attributeSetMetaData['attributes'][attribute['attributeCode']] = attribute;
		}
		
		return attributeSetMetaData;
	}
	
	public any function getAttributeModel(){
		var model = {};
        var entitiesListArray = listToArray(structKeyList(getHibachiScope().getService('hibachiService').getEntitiesMetaData()));
        for(var entityName in entitiesListArray) {
        	var attributeSetMetaDataStruct = {};
        	if(entityName == 'Account')
            if(getHibachiCacheService().hasCachedValue('attributeService_getAttributeModel_#entityName#')){
	            attributeSetMetaDataStruct = getHibachiCacheService().getCachedValue('attributeService_getAttributeModel_#entityName#');
			}else{
				var entity = getHibachiScope().getService('hibachiService').getEntityObject(entityName);
				var assignedAttributes = entity.getAssignedAttributeSetSmartList().getRecords(true);
				if(arrayLen(assignedAttributes)){
					for(var attributeSet in assignedAttributes){
						var attributeSetMeta = getAttributeSetMetaData(attributeSet);
						attributeSetMetaDataStruct[attributeSet.getAttributeSetCode()]=attributeSetMeta;
					}
					getHibachiCacheService().setCachedValue('attributeService_getAttributeModel_#entityName#',attributeSetMetaDataStruct);
				}
			}
			
			if(structCount(attributeSetMetaDataStruct)){
				model[entityName] = attributeSetMetaDataStruct;	
			}
			
			
        }

        return model;
	}

	public string function getAttributeCodesListByAttributeSetObject( required string attributeSetObject ) {
		var attributeCodeList = "";
		var rs = getAttributeDAO().getAttributeCodesQueryByAttributeSetObject( arguments.attributeSetObject );

		for(var i=1; i<=rs.recordCount; i++) {
			attributeCodeList = listAppend(attributeCodeList, rs[ "attributeCode" ][i]);
		}

		return attributeCodeList;
	}

	public any function getAttributeNameByAttributeCode(string attributeCode) {
		var key = 'attributeService_getAttributeNameByAttributeCode_#arguments.attributeCode#';
		if(getHibachiCacheService().hasCachedValue(key)) {
			return getHibachiCacheService().getCachedValue(key);
		}

		var attribute = this.getAttributeByAttributeCode(arguments.attributeCode);
		var atributeName = "";
		if (!isNull(attribute)) {
			atributeName = attribute.getAttributeName();
		}

		getHibachiCacheService().setCachedValue(key, atributeName);

		return atributeName;
	}

	// =====================  END: Logical Methods ============================

	// ===================== START: DAO Passthrough ===========================

	public array function getAttributeValuesForEntity() {
		return getAttributeDAO().getAttributeValuesForEntity(argumentcollection=arguments);
	}

	// ===================== START: DAO Passthrough ===========================

	// ===================== START: Process Methods ===========================

	// =====================  END: Process Methods ============================

	// ====================== START: Save Overrides ===========================

	public any function saveAttribute(required any attribute, struct data={}) {

		if(arguments.attribute.getAttributeInputType() == 'file'
			&& structKeyExists(arguments.data, "attributeCode")
			&& arguments.attribute.getAttributeCode() != arguments.data.attributeCode
		){
			for(var value in attribute.getAttributeValues()){
				var newPath = expandPath(replacenocase(value.getAttributeValueFileURL(),arguments.attribute.getAttributeCode(),arguments.data.attributeCode));
				var newFolder = replacenocase(newPath,value.getAttributeValue(),"");
				var oldPath = expandPath(value.getAttributeValueFileURL());
				if(!directoryExists(newFolder)){
					directoryCreate(newFolder);
				}
				filemove(oldPath, newPath);
			}
		}

		arguments.attribute = super.save(arguments.attribute, arguments.data);

		if(!arguments.attribute.hasErrors() && !isNull(arguments.attribute.getAttributeSet())) {
			getHibachiDAO().flushORMSession();

			getHibachiCacheService().resetCachedKey("attributeService_getAttributeCodesListByAttributeSetObject_#arguments.attribute.getAttributeSet().getAttributeSetObject()#");
			getHibachiCacheService().resetCachedKey("attributeService_getAttributeModel_#arguments.attribute.getAttributeSet().getAttributeSetObject()#");
		}

		return arguments.attribute;
	}

	// ======================  END: Save Overrides ============================

	// ====================== START: Delete Overrides =========================

	public boolean function deleteAttribute(required any attribute) {

		if(!isNull(arguments.attribute.getAttributeSet())) {
			var attributeSetObject = arguments.attribute.getAttributeSet().getAttributeSetObject();
		}

		var deleteOK = super.delete(arguments.attribute);

		// Clear the cached value of acceptable
		if(deleteOK && !isNull(attributeSetObject)) {
			getHibachiDAO().flushORMSession();

			getHibachiCacheService().resetCachedKey("attributeService_getAttributeCodesListByAttributeSetObject_#attributeSetObject#");
		}

		return deleteOK;
	}

	public boolean function deleteAttributeValue(required any attributeValue) {
		var filePath = ExpandPath(arguments.attributeValue.getAttributeValueFileURL());
		var isFile = arguments.attributeValue.getAttribute().getAttributeInputType() == 'file';
		var deleteOK = super.delete(arguments.attributeValue);
		if(deleteOK && isFile && FileExists(filePath)){
			FileDelete(filePath);
		}
		return deleteOK;
	}

	public boolean function deleteAttributeOption(required any attributeOption) {
		if(arguments.attributeOption.isDeletable()) {
			getAttributeDAO().removeAttributeOptionFromAllAttributeValues( arguments.attributeOption.getAttributeOptionID() );

			return super.delete(arguments.attributeOption);
		}

		return false;
	}

	// ======================  END: Delete Overrides ==========================

	// ==================== START: Smart List Overrides =======================

	// ====================  END: Smart List Overrides ========================

	// ====================== START: Get Overrides ============================

	// ======================  END: Get Overrides =============================

}

