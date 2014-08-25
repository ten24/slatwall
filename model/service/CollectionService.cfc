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
	
	public array function getObjectOptions() {
		if(!structKeyExists(variables, "ObjectOptions")) {
			var emd = getService("hibachiService").getEntitiesMetaData();
			var enArr = listToArray(structKeyList(emd));
			arraySort(enArr,"text");
			variables.ObjectOptions = [{name=getHibachiScope().rbKey('define.select'), value=''}];
			for(var i=1; i<=arrayLen(enArr); i++) {
				arrayAppend(variables.ObjectOptions, {name=rbKey('entity.#enArr[i]#'), value=enArr[i]});
			}
		}
		return variables.ObjectOptions;
	}
	
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
	
	public any function createTransientCollection(required string entityName, string collectionConfig = "", string propertyIdentifiersList = "", string filterList = "", string orderBysList = ""){
		
		var collectionEntity = getTransientCollectionByEntityName(arguments.entityName);
		
		if(arguments.collectionConfig neq ""){
			collectionEntity.setCollectionConfig(arguments.collectionConfig);
		}
		
		var collectionConfigStruct = collectionEntity.getCollectionConfigStruct();
		
		//now that we have the basic structure of the collectionconfigStruct, lets add the other things
		if(arguments.propertyIdentifiersList neq ''){
			addColumnsToCollectionConfigStructByPropertyIdentifierList(collectionEntity,arguments.propertyIdentifiersList);
		}
		if(len(arguments.orderBysList)){
			addOrderBysToCollectionConfigStructByPropertyIdentifierList(collectionEntity,arguments.orderBysList);
		}
		
		
		return collectionEntity;
		
	}
	
	private any function getFormattedPageRecord(required any pageRecord, required any propertyIdentifier){
		var pageRecordStruct = {};
		if(isObject(arguments.pageRecord)) {
			var value = arguments.pageRecord.getValueByPropertyIdentifier( propertyIdentifier=arguments.propertyIdentifier, formatValue=true );
			if((len(value) == 3 and value eq "YES") or (len(value) == 2 and value eq "NO")) {
				pageRecordStruct[ arguments.pageRecord.getPropertyTitle(arguments.propertyIdentifier) ] = value & " ";
			} else {
				pageRecordStruct[ arguments.pageRecord.getPropertyTitle(arguments.propertyIdentifier) ] = value;
			}
		
		}else{
			if(structKeyExists(arguments.pageRecord,propertyIdentifier)){
				if(isObject(arguments.pageRecord[arguments.propertyIdentifier])){
					var nestedPropertyIdentifiers = arguments.pageRecord[arguments.propertyIdentifier].getDefaultPropertyIdentifierArray();
					pageRecordStruct[arguments.propertyIdentifier] = getFormattedObjectRecords([arguments.pageRecord[arguments.propertyIdentifier]],nestedPropertyIdentifiers);
				}else if(isArray(arguments.pageRecord[arguments.propertyIdentifier])){
					writeDump(var=arguments.pageRecord[arguments.propertyIdentifier],top=2);abort;
				//	var nestedPropertyIdentifiers = arguments.pageRecord[arguments.propertyIdentifier].getDefaultPropertyIdentifierArray();
					//pageRecordStruct[arguments.propertyIdentifier] = getFormattedObjectRecords([arguments.pageRecord[arguments.propertyIdentifier]],nestedPropertyIdentifiers);
			
				}else{
					var value = arguments.pageRecord[arguments.propertyIdentifier];
					if((len(value) == 3 and value eq "YES") or (len(value) == 2 and value eq "NO")) {
						pageRecordStruct[ pageRecord.getPropertyTitle(arguments.propertyIdentifier) ] = value & " ";
					} else {
						pageRecordStruct[ pageRecord.getPropertyTitle(arguments.propertyIdentifier) ] = value;
					}
				}
			}
		}
		return pageRecordStruct;
	}
	
	public array function getFormattedObjectRecords(required array objectRecords, required array propertyIdentifiers){
		var formattedObjectRecords = [];
		for(var i=1; i<=arrayLen(arguments.objectRecords); i++) {
			var thisRecord = {};
			for(var p=1; p<=arrayLen(arguments.propertyIdentifiers); p++) {
				if(arguments.propertyIdentifiers[p] neq 'pageRecords'){
					//check if page records returns an array of orm objects or hashmap structs and handle them appropriatley
					structAppend(thisRecord,getFormattedPageRecord(arguments.objectRecords[i],arguments.propertyIdentifiers[p]));
				}
			}
			arrayAppend(formattedObjectRecords, thisRecord);
		}
		return formattedObjectRecords;
	}
	
	public any function getFormattedPageRecords(required any collectionEntity, required array propertyIdentifiers){
		var paginatedCollectionOfEntities = collectionEntity.getPageRecords();
		
		var formattedPageRecords[ "pageRecords" ] = getFormattedObjectRecords(paginatedCollectionOfEntities,arguments.propertyIdentifiers);
		
		formattedPageRecords[ "recordsCount" ] = arguments.collectionEntity.getRecordsCount();
		formattedPageRecords[ "pageRecordsCount" ] = arrayLen(arguments.collectionEntity.getPageRecords());
		formattedPageRecords[ "pageRecordsShow"] = arguments.collectionEntity.getPageRecordsShow();
		formattedPageRecords[ "pageRecordsStart" ] = arguments.collectionEntity.getPageRecordsStart();
		formattedPageRecords[ "pageRecordsEnd" ] = arguments.collectionEntity.getPageRecordsEnd();
		formattedPageRecords[ "currentPage" ] = arguments.collectionEntity.getCurrentPage();
		formattedPageRecords[ "totalPages" ] = arguments.collectionEntity.getTotalPages();
		
		return formattedPageRecords;
	}
	
	private array function getPropertyIdentifierArray(required string entityName){
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
		var collectionConfigStruct = arguments.collectionEntity.getCollectionConfigStruct();
		if(structKeyExists(collectionConfigStruct,'columns')){
			var columnsArray = collectionConfigStruct.columns;
		}else{
			var columnsArray = [];
		}
		
		var propertyIdentifiersArray = ListToArray(arguments.propertyIdentifierList);
		for(propertyIdentifierItem in propertyIdentifiersArray){
			columnStruct = {
				propertyIdentifier = "#propertyIdentifierItem#"
			};
			ArrayAppend(columnsArray,columnStruct);
		}
		collectionConfigStruct.columns = columnsArray;
	}
	
	//orderbys list format &orderbys=propertyIdentifier_direction,propertyIdentifier2_direction 
	private void function addOrderBysToCollectionConfigStructByOrderBysList(required any collectionEntity, required string orderBysList){
		var collectionConfigStruct = arguments.collectionEntity.getCollectionConfigStruct();
		if(structKeyExists(collectionConfigStruct,'orderBy')){
			var orderByArray = collectionConfigStruct.orderBy;
		}else{
			var orderByArray = [];
		}
		
		var orderBysListArray = ListToArray(arguments.orderBysList);
		for(orderBy in OrderBysListArray){
			orderByStruct = {
				propertyIdentifier = "#listFirst(orderBy,'_')#",
				direction = "#listLast(orderBy,'_')#"
			};
		}
		collectionConfigStruct.orderBys = orderBysArray;
	}
	
	//filter
	private void function addFiltersToCollectionConfigStructByParameters(required any collectionEntity, required string filterParameters){
		/*if(!structKeyExists(collectionConfigStruct,'filterGroups')){
			collectionConfigStruct.filterGroups = [];
		}
		var capitalCaseEntityName = capitalCase(arguments.entityName);
		var propertyIdentifier = capitalCaseEntityName & '.#arguments.entityName#ID';
		var filterStruct = createFilterStruct(propertyIdentifier,'=',arguments.entityID);
		
		var filterGroupStruct.filterGroup = [];
		arrayappend(filterGroupStruct.filterGroup,filterStruct);
		
		arrayAppend(collectionConfigStruct.filterGroups,filterGroupStruct);*/
	}
	
	private any function getColumnsAndJoinsStructPropertyIdentifiersList(propertyIdentifiersList){
		var columnsAndJoinsStruct = {};
		
		return columnsAndJoinsStruct;
	}
	
	public any function getTransientCollectionConfigStructByURLParams(required any rc){
		//propertyIdentifers
		var collectionConfigStruct = {
			baseEntityName = 'Slatwall#arguments.rc.entityName#',
			baseEntityAlias = rc.entityName
		};
		
		//adds to columns section if preceeded by a period then add to joins section, check for parenthesis for aggregates
		//&propertyIdentifiers=propertyIdentifier,join.propertyIdentifier,aggregate|join.propertyIdentifier
		/*if(!isNull(arguments.rc.propertyIdentifiers)){
			var columnsAndJoinsStruct = getColumnsAndJoinsStructByUrlPropertyIdentifiersList(arguments.rc.propertyIdentifiers);
			collectionConfigStruct.columns = columnsAndJoinsStruct.columns;
			collectionConfigStruct.joins = columnsAndJoinsStruct.joins;
		}*/

		//this should handle sorting 
		//&orderBy=propertyIdentifier|direction
		/*if(!isNull(arguments.rc.orderBy)){
			collectionConfig.orderBy = getOrderByArrayByURLParams(arguments.rc.orderBy);
		}*/
		
		//this should be how we handle filterGroups
		// + 
		//&filterGroups=propertyIdentifier,comparisonOperator,value|propertyIdentifier,comparisonOperator,value,logicalOperator
		//comparisonOperatorValues
		/*
		e = '='
		ne = '!='
		> = '>'
		< = '<'
		l = 'like'
		nl = 'not like'
		i = 'in'
		ni = 'not in'
		b = 'between'
		? = 'is null'
		n? = 'is not null'
		
		logicalOperatorValues
		+ = 'AND'
		- = 'OR'
		*/
	
										
		/*if(!isNull(arguments.rc.filterGroups)){
			collectionConfig.filterGroups = getFilterGroupsArray(arguments.rc.filterGroups);
		}*/
		
		return collectionConfigStruct;
	}
	
	public any function getAPIResponseForEntityName(required string entityName, string propertyIdentifiersList = "", numeric currentPage = 1, numeric pageShow = 10){
		var collectionEntity = getTransientCollectionByEntityName(arguments.entityName);
		collectionEntity.setCurrentPageDeclaration(arguments.currentPage);
		collectionEntity.setPageRecordsShow(arguments.pageShow);
		//if propertyIdentifiers were specified add selects so we can refine what columns to return
		if(len(arguments.propertyIdentifiersList)){
			addColumnsToCollectionConfigStructByPropertyIdentifierList(collectionEntity,arguments.propertyIdentifiersList);
		}
		
		if(len(arguments.propertyIdentifiersList)){
			var propertyIdentifierArray = ListToArray(arguments.propertyIdentifiersList);
			return getFormattedPageRecords(collectionEntity,propertyIdentifierArray);
		}else{
			var defaultPropertyIdentifiers = getPropertyIdentifierArray(arguments.entityName);
		
			return getFormattedPageRecords(collectionEntity,defaultPropertyIdentifiers);
		}
	}
	
	public any function getAPIResponseForBasicEntityWithID(required string entityName, required string entityID, string propertyIdentifiersList = "", numeric currentPage = 1, numeric pageShow = 10){
		var collectionEntity = getTransientCollectionByEntityName(arguments.entityName);
		collectionEntity.setCurrentPageDeclaration(arguments.currentPage);
		collectionEntity.setPageRecordsShow(arguments.pageShow);
		var collectionConfigStruct = collectionEntity.getCollectionConfigStruct();
		
		if(len(arguments.propertyIdentifiersList)){
			addColumnsToCollectionConfigStructByPropertyIdentifierList(collectionEntity,arguments.propertyIdentifiersList);
		}
		
		var defaultPropertyIdentifiers = getPropertyIdentifierArray(arguments.entityName);

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
		for(var p=1; p<=arrayLen(defaultPropertyIdentifiers); p++) {
			if(isObject(paginatedCollectionOfEntities[1])) {
				response[ defaultPropertyIdentifiers[p] ] = paginatedCollectionOfEntities[1].getValueByPropertyIdentifier( propertyIdentifier=defaultPropertyIdentifiers[p],format=true );
			}else{
				if(structKeyExists(paginatedCollectionOfEntities[1],defaultPropertyIdentifiers[p])){
					response[ defaultPropertyIdentifiers[p] ] = paginatedCollectionOfEntities[1][defaultPropertyIdentifiers[p]];
				}
			}
		}
		return response;
		
	}
	
	public any function getAPIResponseForCollection(required any collectionEntity, string propertyIdentifiersList = "", numeric currentPage=1, numeric pageShow = 10){
		collectionEntity.setCurrentPageDeclaration(arguments.currentPage);
		collectionEntity.setPageRecordsShow(arguments.pageShow);
		
		if(len(arguments.propertyIdentifiersList)){
			addColumnsToCollectionConfigStructByPropertyIdentifierList(arguments.collectionEntity,arguments.propertyIdentifiersList);
		}
		
		var defaultPropertyIdentifiers = getPropertyIdentifierArray('collection');
		var response = {};
		for(var p=1; p<=arrayLen(defaultPropertyIdentifiers); p++) {
			response[ defaultPropertyIdentifiers[p] ] = arguments.collectionEntity.getValueByPropertyIdentifier( propertyIdentifier=defaultPropertyIdentifiers[p],format=true );
		}
		
		//get default property identifiers for the records that the collection refers to
		var collectionPropertyIdentifiers = getPropertyIdentifierArray(collectionEntity.getBaseEntityName());;
		
		var paginatedCollectionOfEntities = arguments.collectionEntity.getPageRecords();
		var collectionPaginationStruct = getFormattedPageRecords(arguments.collectionEntity,collectionPropertyIdentifiers);
		
		structAppend(response,collectionPaginationStruct);
		return response;
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