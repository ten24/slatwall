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

component extends="HibachiService" accessors="true" output="false" {
	
	// ===================== START: Logical Methods ===========================
	//returns meta data about the objects properties
	public array function getEntityNameOptions() {
		var entitiesMetaData = getEntitiesMetaData();
		var entitiesArray = listToArray(structKeyList(entitiesMetaData));
		arraySort(entitiesArray,"text");
		
		var options = [];
		for(var value in entitiesArray) {
			var option = {};
			option["name"] = rbKey('entity.#value#');
			option["value"] = value; 
			arrayAppend(options, option);
		}
		
		var option = {};
		option["name"] = rbKey('define.select');
		option["value"] = ""; 
		
		arrayPrepend(options, option);
		return options;
	}
	
	/*public array function getCollectionOptionsByEntityName( required string EntityName ) {
		var smartList = this.getCollectionSmartList();
		
		smartList.addSelect('collectionName', 'name');
		smartList.addSelect('collectionID', 'value');
		smartList.addOrder('collectionName|ASC');
		
		var option = {};
		option["name"] = rbKey('define.new');
		option["value"] = ""; 
		
		var options = smartList.getRecords(); 
		
		arrayPrepend(options, option);
		
		return options;
	}*/
	
	public any function getEntityNameColumnProperties( required string EntityName ) {
		var returnArray = getentityNameProperties( arguments.entityName );
		for(var i=arrayLen(returnArray); i>=1; i--) {
			if(listFindNoCase('one-to-many,many-to-many', returnArray[i].fieldType)) {
				arrayDeleteAt(returnArray, i);	
			}
		}
		var noneOption = {};
		noneOption["propertyIdentifier"] = "";
		noneOption["title"] = "#rbKey('define.add')# / #rbKey('define.remove')#";
		arrayPrepend(returnArray, noneOption);
		return returnArray;
	}
	
	//returns an array of the entityNamesProperties in structs{ entityName,fieldType,propertyIdentifier,title }
	public any function getEntityNameProperties( required string EntityName ) {
		var returnArray = [];
		var sortArray = [];
		var attributeCodesList = getHibachiCacheService().getOrCacheFunctionValue("attributeService_getAttributeCodesListByAttributeSetType_ast#getProperlyCasedShortEntityName(arguments.entityName)#", "attributeService", "getAttributeCodesListByAttributeSetType", {1="ast#getProperlyCasedShortEntityName(arguments.entityName)#"});
		var properties = getPropertiesStructByEntityName(arguments.entityName);
		
		for(var attributeCode in listToArray(attributeCodesList)) {
			arrayAppend(sortArray, attributeCode);
			arraySort(sortArray, "textnocase");
			
			var add = {};
			add['propertyIdentifier'] = attributeCode;
			add['fieldType'] = 'column';
			
			arrayInsertAt(returnArray, arrayFindNoCase(sortArray, attributeCode), add);
		}
		
		for(var property in properties) {
			
			if(!structKeyExists(properties[property], "persistent") || properties[property].persistent) {
				arrayAppend(sortArray, property);
				arraySort(sortArray, "textnocase");
				
				var add = {};
				add['propertyIdentifier'] = property;
				add['title'] = rbKey("entity.#arguments.entityName#.#property#");
				if(structKeyExists(properties[property], "fieldtype")) {
					add['fieldType'] = properties[property].fieldType;
					if(structKeyExists(properties[property], "cfc")) {
						add['entityName'] = listLast(properties[property].cfc, '.');	
					}
				} else {
					add['fieldType'] = 'column';
				}
				
				var position = arrayFindNoCase(sortArray, property);
				
				if(arrayLen(returnArray) && position <= arrayLen(returnArray)) {
					arrayInsertAt(returnArray, position, add);		
				} else {
					arrayAppend(returnArray, add);
				}
			}
			
		}
		
		return returnArray;
	}
	
	public string function capitalCase(required string phrase){
        return reReplace(arguments.phrase, "\b(\w)(\w*)?\b", "\U\1\L\2", "ALL"); 
	}
	
	public any function getTransientCollectionByEntityName(required string entityName){
		var collectionEntity = this.newCollection();
		var capitalCaseEntityName = capitalCase(arguments.entityName);
		collectionEntity.setBaseEntityName('Slatwall#capitalCaseEntityName#');
		var collectionConfigStruct = {
			baseEntityName="Slatwall#capitalCaseEntityName#",
			baseEntityAlias="#capitalCaseEntityName#"
		};
		collectionEntity.setCollectionConfigStruct(collectionConfigStruct);
		return collectionEntity;
	}
	
	public any function getFormattedPageRecords(required any collectionEntity, required array propertyIdentifiers){
		var paginatedCollectionOfEntities = collectionEntity.getPageRecords();
		
		var formattedPageRecords[ "pageRecords" ] = [];
		for(var i=1; i<=arrayLen(paginatedCollectionOfEntities); i++) {
			var thisRecord = {};
			for(var p=1; p<=arrayLen(arguments.propertyIdentifiers); p++) {
				if(arguments.propertyIdentifiers[p] neq 'pageRecords'){
					//check if page records returns an array of orm objects or hashmap structs and handle them appropriatley
					if(isObject(paginatedCollectionOfEntities[i])) {
						var value = paginatedCollectionOfEntities[i].getValueByPropertyIdentifier( propertyIdentifier=arguments.propertyIdentifiers[p], formatValue=true );
						if((len(value) == 3 and value eq "YES") or (len(value) == 2 and value eq "NO")) {
							thisRecord[ arguments.propertyIdentifiers[p] ] = value & " ";
						} else {
							thisRecord[ arguments.propertyIdentifiers[p] ] = value;
						}
					
					}else{
						if(structKeyExists(paginatedCollectionOfEntities[i],arguments.propertyIdentifiers[p])){
							var value = paginatedCollectionOfEntities[i][arguments.propertyIdentifiers[p]];
							if((len(value) == 3 and value eq "YES") or (len(value) == 2 and value eq "NO")) {
								thisRecord[ arguments.propertyIdentifiers[p] ] = value & " ";
							} else {
								thisRecord[ arguments.propertyIdentifiers[p] ] = value;
							}
						}
					}
				}
					
			}
			arrayAppend(formattedPageRecords[ "pageRecords" ], thisRecord);
		}
		/* TODO:add the commented properties*/
		formattedPageRecords[ "recordsCount" ] = arguments.collectionEntity.getRecordsCount();
		formattedPageRecords[ "pageRecordsCount" ] = arrayLen(arguments.collectionEntity.getPageRecords());
		formattedPageRecords[ "pageRecordsShow"] = arguments.collectionEntity.getPageRecordsShow();
		formattedPageRecords[ "pageRecordsStart" ] = arguments.collectionEntity.getPageRecordsStart();
		formattedPageRecords[ "pageRecordsEnd" ] = arguments.collectionEntity.getPageRecordsEnd();
		formattedPageRecords[ "currentPage" ] = arguments.collectionEntity.getCurrentPage();
		formattedPageRecords[ "totalPages" ] = arguments.collectionEntity.getTotalPages();
		
		return formattedPageRecords;
	}
	
	private array function getPropertyIdentifierList(required string entityName){
		//if we were supplied with a list of property identifiers then we should only return whats on that list
		/* TODO: validate that the user is allowed to return the column*/
		
		//by now we have a baseEntityName and a collectionEntity so now we need to check if we are filtering the collection
		var defaultEntityProperties = getDefaultPropertiesByEntityName( entityName );
		var propertyIdentifiersList = getPropertyIdentifiersList(defaultEntityProperties);
		// Turn the property identifiers into an array
		return listToArray( propertyIdentifiersList );
	}
	
	//even though void return type it still makes changes to the collectionConfigStuct
	private void function addColumnsToCollectionConfigStructByPropertyIdentifierList(required any collectionEntity, required string propertyIdentifierList){
		var collectionConfig = arguments.collectionEntity.getCollectionConfigStruct();
		if(structKeyExists(collectionConfig,'columns')){
			var columnsArray = collectionConfig.columns;
		}else{
			var columnsArray = [];
		}
		
		var columnsArray = [];
		var propertyIdentifiersArray = ListToArray(arguments.propertyIdentifierList);
		for(propertyIdentifierItem in propertyIdentifiersArray){
			columnStruct = {
				propertyIdentifier = "#propertyIdentifierItem#"
			};
			ArrayAppend(columnsArray,columnStruct);
		}
		collectionConfig.columns = columnsArray;
		
	}
	
	public any function getAPIResponseForEntityName(required string entityName, string propertyIdentifiersList = ""){
		/*try{*/
			collectionEntity = getTransientCollectionByEntityName(arguments.entityName);
			
			//if propertyIdentifiers were specified add selects so we can refine what columns to return
			if(len(arguments.propertyIdentifiersList)){
				addColumnsToCollectionConfigStructByPropertyIdentifierList(collectionEntity,arguments.propertyIdentifiersList);
				
			}
			
			var defaultPropertyIdentifiers = getPropertyIdentifierList(arguments.entityName);
			
			return getFormattedPageRecords(collectionEntity,defaultPropertyIdentifiers);
		
		/*}catch(any e){
			var apiResponse.statusCode = "500";
			//e.message is probably too much info for the api response
			apiResponse.statusText = "entity name #arguments.entityName# does not exist";
			return apiResponse;
		}*/
		
	}
	
	public any function getAPIResponseForBasicEntityWithID(required string entityName, required string entityID, string propertyIdentifiers = ""){
		//check entityname otherwise inform the user of the error
		try{
			var collectionEntity = getTransientCollectionByEntityName(arguments.entityName);
			var collectionConfigStruct = collectionEntity.getCollectionConfigStruct();
	
			var defaultPropertyIdentifiers = getPropertyIdentifierList(arguments.entityName);
	
			//set up search by id				
			if(!structKeyExists(collectionConfigStruct,'filterGroups')){
				collectionConfigStruct.filterGroups = [];
			}
			var capitalCaseEntityName = capitalCase(arguments.entityName);
			var propertyIdentifier = capitalCaseEntityName & '.#arguments.entityName#ID';
			var filterStruct = createFilterStruct(propertyIdentifier,'=',arguments.entityID);
			
			var filterGroupStruct.filterGroup = [];
			arrayappend(filterGroupStruct.filterGroup,filterStruct);
			
			arrayAppend(collectionConfigStruct.filterGroups,filterGroupStruct);
			
			var paginatedCollectionOfEntities = collectionEntity.getPageRecords();
		}catch(any e){
			var response.statusCode = "500";
			response.statusText = "entity name #arguments.entityName# does not exist";
			return response;
		}
		//check that id exists otherwise inform the user
		try{
			var response = {};
			for(var p=1; p<=arrayLen(defaultPropertyIdentifiers); p++) {
				response[ defaultPropertyIdentifiers[p] ] = paginatedCollectionOfEntities[1].getValueByPropertyIdentifier( propertyIdentifier=defaultPropertyIdentifiers[p],format=true );
			}
			return response;
		}catch(any e){
			var response.statusCode = "500";
			response.statusText = "entity ID #arguments.entityID# for #arguments.entityName# does not exist";
			return response;
		}
		
	}
	
	public any function getAPIResponseForCollection(required any collectionEntity, string propertyIdentifiers = ""){
		try{
			var defaultPropertyIdentifiers = getPropertyIdentifierList('collection');
			var response = {};
			for(var p=1; p<=arrayLen(defaultPropertyIdentifiers); p++) {
				response[ defaultPropertyIdentifiers[p] ] = arguments.collectionEntity.getValueByPropertyIdentifier( propertyIdentifier=defaultPropertyIdentifiers[p],format=true );
			}
			
			//get default property identifiers for the records that the collection refers to
			var collectionPropertyIdentifiers = getPropertyIdentifierList(collectionEntity.getBaseEntityName());;
			
			var paginatedCollectionOfEntities = arguments.collectionEntity.getPageRecords();
			var collectionPaginationStruct = getFormattedPageRecords(arguments.collectionEntity,collectionPropertyIdentifiers);
			
			structAppend(response,collectionPaginationStruct);
			return response;
		}catch(any e){
			//request would have failed earlier getting to this point. If it still fails still notify user 
			var response.statusCode = "500";
			response.statusText = "request could not be processed";
			return response;
		}
	}
	
	public string function getPropertyIdentifiersList(required any entityProperties){
		// Lets figure out the properties that need to be returned
		var propertyIdentifiers = "";
			
		for(var i=1; i<=arrayLen(arguments.entityProperties); i++) {
			propertyIdentifiers = listAppend(propertyIdentifiers, arguments.entityProperties[i].name);
		}
		return propertyIdentifiers;
	}
	
	public struct function createFilterStruct(required string propertyIdentifier, required string comparisonOperator, required string value){
		var filterStruct = {
			propertyIdentifier=arguments.propertyIdentifier,
			comparisonOperator = arguments.comparisonOperator,
			value = arguments.value
		};
		return filterStruct;
	}
	
	public struct function createColumnStruct(required string propertyIdentifier){
		var columnStruct = {
			propertyIdentifier=arguments.propertyIdentifier
		};
		return columnStruct;
	}
	
	// =====================  END: Logical Methods ============================
	
	// ===================== START: DAO Passthrough ===========================
	
	// ===================== START: DAO Passthrough ===========================
	
	// ===================== START: Process Methods ===========================
	
	// =====================  END: Process Methods ============================
	
	// ====================== START: Status Methods ===========================
	
	// ======================  END: Status Methods ============================
	
	// ====================== START: Save Overrides ===========================
	
	// ======================  END: Save Overrides ============================
	
	// ==================== START: Smart List Overrides =======================
	
	// ====================  END: Smart List Overrides ========================
	
	// ====================== START: Get Overrides ============================
	
	// ======================  END: Get Overrides =============================
	
	// ===================== START: Delete Overrides ==========================
	
	// =====================  END: Delete Overrides ===========================
	
}