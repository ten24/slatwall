component output="false" accessors="true" extends="HibachiService" {
	property name="hibachiService" type="any";

	// ===================== START: Logical Methods ===========================
	public string function getCollectionObjectByCasing(required collection, required string casing){
		switch(arguments.casing){
			case 'lower':
				return lcase(arguments.collection.getCollectionObject());
				break;
			case 'camel':
				return lcase(Left(arguments.collection.getCollectionObject(),1)) & right(arguments.collection.getCollectionObject(), Len(arguments.collection.getCollectionObject()) - 1);
				break;
		}
		throw('#arguments.casing# not a valid casing.');
	}

	public any function getHibachiPropertyIdentifierByCollectionPropertyIdentifier(required string collectionPropertyIdentifier){
		var hibachiPropertyIdentifier = arguments.collectionPropertyIdentifier;
		hibachiPropertyIdentifier = Replace(hibachiPropertyIdentifier,'_','.','all');
		if(left(hibachiPropertyIdentifier,1) == '.'){
			hibachiPropertyIdentifier = listRest(hibachiPropertyIdentifier,'.');
		}
		return hibachiPropertyIdentifier;
	}

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
		return UCase(left(arguments.phrase,1)) & Right(arguments.phrase,Len(arguments.phrase)-1);
	}

	public any function getTransientCollectionByEntityName(required string entityName, struct data){
		var collectionOptions = this.getCollectionOptionsFromData(arguments.data); 
		var collectionEntity = this.newCollection();
		var properlyCasedShortEntityName = getProperlyCasedShortEntityName(arguments.entityName);
		collectionEntity.setCollectionObject(properlyCasedShortEntityName,collectionOptions.defaultColumns);

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
	public any function getFormattedPageRecord(required any pageRecord, required any propertyIdentifier, any collectionEntity){
		//populate pageRecordStruct with pageRecord info based on the passed in property identifier
		var pageRecordStruct = {};

		if(isObject(arguments.pageRecord)) {
			try{
				var value = arguments.pageRecord.getValueByPropertyIdentifier( propertyIdentifier=arguments.propertyIdentifier, formatValue=true );
				if((len(value) == 3 and value eq "YES") or (len(value) == 2 and value eq "NO")) {
					pageRecordStruct[ arguments.propertyIdentifier ] = this.capitalCase(lcase(value)) & " ";
				} else {
					pageRecordStruct[ arguments.propertyIdentifier ] = value;
				}
			}catch(any e){
				var value = '';
			}

		}else{

			if(structKeyExists(arguments.pageRecord,propertyIdentifier)){
				if(isObject(arguments.pageRecord[arguments.propertyIdentifier])){
					var nestedPropertyIdentifiers = arguments.pageRecord[arguments.propertyIdentifier].getDefaultPropertyIdentifierArray();
					pageRecordStruct[arguments.propertyIdentifier] = getFormattedObjectRecords([arguments.pageRecord[arguments.propertyIdentifier]],nestedPropertyIdentifiers,arguments.collectionEntity);
				}else if(isArray(arguments.pageRecord[arguments.propertyIdentifier])){

					//pageRecordStruct[ arguments.propertyIdentifier ] = value;
					//retrieve one-to-many using default properties
					pageRecordStruct[arguments.propertyIdentifier] = [];
					for(var arrayItem in arguments.pageRecord[arguments.propertyIdentifier]){
						var defaultCollectionProperties = arrayItem.getDefaultCollectionProperties();
						var value = {};
						for(var property in defaultCollectionProperties){
							value[property.name] = arrayItem.getValueByPropertyIdentifier(propertyIdentifier=property.name,format=true);
						}
						arrayAppend(pageRecordStruct[arguments.propertyIdentifier],value);
					}
				}else{
					var value = arguments.pageRecord[arguments.propertyIdentifier];
					if((len(value) == 3 and value eq "YES") or (len(value) == 2 and value eq "NO")) {

						pageRecordStruct[ arguments.propertyIdentifier ] = this.capitalCase(lcase(value)) & " ";
					} else {
						pageRecordStruct[ arguments.propertyIdentifier ] = value;
					}
				}
			}else{
				pageRecordStruct[ arguments.propertyIdentifier ] = " ";
			}
		}
		return pageRecordStruct;
	}

	public array function getFormattedObjectRecords(required array objectRecords, required array propertyIdentifiers, any collectionEntity){
		//validate columns against entities default property identifiers
		var formattedObjectRecords = [];
		for(var i=1; i<=arrayLen(arguments.objectRecords); i++) {
			var thisRecord = {};
			for(var p=1; p<=arrayLen(arguments.propertyIdentifiers); p++) {
				if(arguments.propertyIdentifiers[p] neq 'pageRecords'){
					structAppend(thisRecord,getFormattedPageRecord(arguments.objectRecords[i],arguments.propertyIdentifiers[p],arguments.collectionEntity));
				}
			}
			arrayAppend(formattedObjectRecords, thisRecord);
		}
		return formattedObjectRecords;
	}

	public any function getBadCollectionInfo(required any collectionEntity){
		formattedPageRecords[ "pageRecords" ] = [];

		formattedPageRecords[ "recordsCount" ] = 0;
		formattedPageRecords[ "pageRecordsCount" ] = 0;
		formattedPageRecords[ "pageRecordsShow"] = arguments.collectionEntity.getPageRecordsShow();
		formattedPageRecords[ "pageRecordsStart" ] = 0;
		formattedPageRecords[ "pageRecordsEnd" ] = 0;
		formattedPageRecords[ "currentPage" ] = arguments.collectionEntity.getCurrentPage();
		formattedPageRecords[ "totalPages" ] = arguments.collectionEntity.getTotalPages();
		formattedPageRecords['failed'] = true;
	}

	public any function getFormattedPageRecords(required any collectionEntity, required array propertyIdentifiers){

		var formattedPageRecords = {};
		var paginatedCollectionOfEntities = collectionEntity.getPageRecords(formatRecords=false);
		if(ArrayLen(paginatedCollectionOfEntities) == 1 && structKeyExists(paginatedCollectionOfEntities[1],'failedCollection')){
			formattedPageRecords = getBadCollectionInfo(arguments.collectionEntity);
		}else{

			formattedPageRecords[ "pageRecords" ] = getFormattedObjectRecords(paginatedCollectionOfEntities,arguments.propertyIdentifiers,arguments.collectionEntity);
			formattedPageRecords[ "recordsCount" ] = arguments.collectionEntity.getRecordsCount();
			formattedPageRecords[ "pageRecordsCount" ] = arrayLen(arguments.collectionEntity.getPageRecords(formatRecords=false));
			formattedPageRecords[ "pageRecordsShow"] = arguments.collectionEntity.getPageRecordsShow();
			formattedPageRecords[ "pageRecordsStart" ] = arguments.collectionEntity.getPageRecordsStart();
			formattedPageRecords[ "pageRecordsEnd" ] = arguments.collectionEntity.getPageRecordsEnd();
			formattedPageRecords[ "currentPage" ] = arguments.collectionEntity.getCurrentPage();
			formattedPageRecords[ "totalPages" ] = arguments.collectionEntity.getTotalPages();
			if(arrayLen(arguments.collectionEntity.getProcessObjectArray())){
				var processObject = arguments.collectionEntity.getProcessObjectArray()[1];
				formattedPageRecords[ "processObjects" ] = getFormattedObjectRecords(arguments.collectionEntity.getProcessObjectArray(),this.getProcessObjectProperties(processObject,arguments.collectionEntity),arguments.collectionEntity);
			}

		}
		return formattedPageRecords;
	}

	public array function getProcessObjectProperties(required any processObject, required any collectionEntity){
		var properties = arguments.processObject.getProperties();
		var processObjectProperties = [];
		for(var property in properties){
			if(!structKeyExists(property,'persistent') && lcase(property.name) != lcase(arguments.collectionEntity.getCollectionObject())){
				arrayAppend(processObjectProperties,property.name);
			}
		}
		return processObjectProperties;
	}

	public any function getFormattedRecords(required any collectionEntity, required array propertyIdentifiers){

		var collectionOfEntities = collectionEntity.getRecords(formatRecords=false);

		var formattedRecords[ "records" ] = getFormattedObjectRecords(collectionOfEntities,arguments.propertyIdentifiers,arguments.collectionEntity);

		return formattedRecords;
	}

	private array function getPropertyIdentifierArray(required string entityName, boolean showNonPersistent = false){
		//if we were supplied with a list of property identifiers then we should only return whats on that list
		/* TODO: validate that the user is allowed to return the column*/

		//by now we have a baseEntityName and a collectionEntity so now we need to check if we are filtering the collection
		var defaultEntityProperties = (showNonPersistent) ? getPropertiesByEntityName(entityName) : getDefaultPropertiesByEntityName(entityName);
		var propertyIdentifiersList = getPropertyIdentifiersList(defaultEntityProperties);
		// Turn the property identifiers into an array
		return listToArray( propertyIdentifiersList );
	}

	//even though void return type it still makes changes to the collectionConfigStuct
	private void function addColumnsToCollectionConfigStructByPropertyIdentifierList(required any collectionEntity, required string propertyIdentifierList, boolean enforceAuthorization=true){
		arguments.collectionEntity.setEnforceAuthorization(arguments.enforceAuthorization);
		var collectionConfigStruct = arguments.collectionEntity.getCollectionConfigStruct();
		if(structKeyExists(collectionConfigStruct,'columns')){
			var columnsArray = collectionConfigStruct.columns;
		}else{
			var columnsArray = [];
		}

		var propertyIdentifiersArray = ListToArray(arguments.propertyIdentifierList);
		for(propertyIdentifierItem in propertyIdentifiersArray){
			if(
				!arguments.collectionEntity.getEnforceAuthorization() || getHibachiScope().authenticateCollectionPropertyIdentifier('read', this, propertyIdentifierItem)
			){
				columnStruct = {
					propertyIdentifier = "#propertyIdentifierItem#"
				};
				ArrayAppend(columnsArray,columnStruct);
			}
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

	public any function getTransientCollectionConfigStructByURLParams(required any data){
		//propertyIdentifers
		collectionConfigStruct = {};
		collectionConfigStruct = {
			baseEntityName = '#getDao('HibachiDao').getApplicationKey()##arguments.data.entityName#',
			baseEntityAlias = '_' & lcase(arguments.data.entityName)
		};

		if(!isnull(arguments.data.filterConfig)){
			collectionConfigStruct.filterGroups = deserializeJson(arguments.data.filterConfig);
		}

		if(!isNull(arguments.data.joinsConfig)){
			collectionConfigStruct.joins = deserializeJson(arguments.data.joinsConfig);
		}

		if(!isNull(arguments.data.orderByConfig)){
			collectionConfigStruct.orderBy = deserializeJson(arguments.data.orderByConfig);
		}

		if(!isNull(arguments.data.columnsConfig)){
			collectionConfigStruct.columns = deserializeJson(arguments.data.columnsConfig);
		}


		//adds to columns section if preceeded by a period then add to joins section, check for parenthesis for aggregates
		//&propertyIdentifiers=propertyIdentifier,join.propertyIdentifier,aggregate|join.propertyIdentifier
		/*if(!isNull(arguments.data.propertyIdentifiers)){
			var columnsAndJoinsStruct = getColumnsAndJoinsStructByUrlPropertyIdentifiersList(arguments.data.propertyIdentifiers);
			collectionConfigStruct.columns = columnsAndJoinsStruct.columns;
			collectionConfigStruct.joins = columnsAndJoinsStruct.joins;
		}*/

		//this should handle sorting
		//&orderBy=propertyIdentifier|direction
		/*if(!isNull(arguments.data.orderBy)){
			collectionConfig.orderBy = getOrderByArrayByURLParams(arguments.data.orderBy);
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


		/*if(!isNull(arguments.data.filterGroups)){
			collectionConfig.filterGroups = getFilterGroupsArray(arguments.data.filterGroups);
		}*/

		return collectionConfigStruct;
	}

	/**
		Examples of each type of filter:
		?p:show=50
		?p:current=1
		?r:calculatedsaleprice=20^50
		?r:calculatedSalePrice=^50
		?f:accountName:eq=someName  - adds the filter.
		?fr:accountName:eq=someName - removes the filter
		?orderby=someKey|direction
		?orderBy=someKey|direction,someOtherKey|direction ...

		Using coldfusion operator versions - gt,lt,gte,lte,eq,neq,like

	*/
	public string function buildURL(required string queryAddition, boolean appendValues=true, boolean toggleKeys=true, string currentURL="") {
		// Generate full URL if one wasn't passed in
		if(!len(arguments.currentURL)) {
			if(len(cgi.query_string)) {
				arguments.currentURL &= "?" & CGI.QUERY_STRING;
			}
		}

		var modifiedURL = "?";
		variables.dataKeyDelimiter = ":";
		variables.valuedelimiter = ",";
		// Turn the old query string into a struct
		var oldQueryKeys = {};

		if(findNoCase("?", arguments.currentURL)) {
			var oldQueryString = right(arguments.currentURL, len(arguments.currentURL) - findNoCase("?", arguments.currentURL));
			for(var i=1; i<=listLen(oldQueryString, "&"); i++) {
				var keyValuePair = listGetAt(oldQueryString, i, "&");
				oldQueryKeys[listFirst(keyValuePair,"=")] = listLast(keyValuePair,"=");
			}
		}

		// Turn the added query string to a struct
		var newQueryKeys = {};
		for(var i=1; i<=listLen(arguments.queryAddition, "&"); i++) {
			var keyValuePair = listGetAt(arguments.queryAddition, i, "&");
			newQueryKeys[listFirst(keyValuePair,"=")] = listLast(keyValuePair,"=");
		}


		// Get all keys and values from the old query string added
		for(var key in oldQueryKeys) {
			if(key != "P#variables.dataKeyDelimiter#Current" && key != "P#variables.dataKeyDelimiter#Start" && key != "P#variables.dataKeyDelimiter#Show") {
				if(!structKeyExists(newQueryKeys, key)) {
					modifiedURL &= "#key#=#oldQueryKeys[key]#&";
				} else {
					if(arguments.toggleKeys && structKeyExists(oldQueryKeys, key) && structKeyExists(newQueryKeys, key) && oldQueryKeys[key] == newQueryKeys[key]) {
						structDelete(newQueryKeys, key);
					} else if(arguments.appendValues) {
						for(var i=1; i<=listLen(newQueryKeys[key], variables.valueDelimiter); i++) {
							var thisVal = listGetAt(newQueryKeys[key], i, variables.valueDelimiter);
							var findCount = listFindNoCase(oldQueryKeys[key], thisVal, variables.valueDelimiter);
							if(findCount) {
								newQueryKeys[key] = listDeleteAt(newQueryKeys[key], i, variables.valueDelimiter);
								if(arguments.toggleKeys) {
									oldQueryKeys[key] = listDeleteAt(oldQueryKeys[key], findCount);
								}
							}
						}
						if(len(oldQueryKeys[key]) && len(newQueryKeys[key])) {
								modifiedURL &= "#key#=#oldQueryKeys[key]##variables.valueDelimiter##newQueryKeys[key]#&";
						} else if(len(oldQueryKeys[key])) {
							modifiedURL &= "#key#=#oldQueryKeys[key]#&";
						}
						structDelete(newQueryKeys, key);
					}
				}
			}
		}

		// Get all keys and values from the additional query string added
		for(var key in newQueryKeys) {
			if(key != "P#variables.dataKeyDelimiter#Current" && key != "P#variables.dataKeyDelimiter#Start" && key != "P#variables.dataKeyDelimiter#Show") {
				modifiedURL &= "#key#=#newQueryKeys[key]#&";
			}
		}

		if(!structKeyExists(newQueryKeys, "P#variables.dataKeyDelimiter#Show")) {
			// Add the correct page start
			if( structKeyExists(newQueryKeys, "P#variables.dataKeyDelimiter#Start") ) {
				modifiedURL &= "P#variables.dataKeyDelimiter#Start=#newQueryKeys[ 'P#variables.dataKeyDelimiter#Start' ]#&";
			} else if( structKeyExists(newQueryKeys, "P#variables.dataKeyDelimiter#Current") ) {
				modifiedURL &= "P#variables.dataKeyDelimiter#Current=#newQueryKeys[ 'P#variables.dataKeyDelimiter#Current' ]#&";
			}
		}

		// Add the correct page show
		if( structKeyExists(newQueryKeys, "P#variables.dataKeyDelimiter#Show") ) {
			modifiedURL &= "P#variables.dataKeyDelimiter#Show=#newQueryKeys[ 'P#variables.dataKeyDelimiter#Show' ]#&";
		} else if( structKeyExists(oldQueryKeys, "P#variables.dataKeyDelimiter#Show") ) {
			modifiedURL &= "P#variables.dataKeyDelimiter#Show=#oldQueryKeys[ 'P#variables.dataKeyDelimiter#Show' ]#&";
		}

		if(right(modifiedURL, 1) eq "&") {
			modifiedURL = left(modifiedURL, len(modifiedURL)-1);
		} else if (right(modifiedURL, 1) eq "?") {
			modifiedURL = "?c=1";
		}

		return modifiedURL;
	}



	public any function applyData(required any collection){
		arguments.collection.applyData();
	}

	public any function getCollectionOptionsFromData(required struct data){
		//get entity service by entity name
		var currentPage = "";
		if(structKeyExists(arguments.data,'P:Current')){
			currentPage = arguments.data['P:Current'];
		}else if(structKeyExists(arguments.data, 'currentPage')){
			currentPage = arguments.data['currentPage'];
		}
		var pageShow = "";
		
		if(structKeyExists(arguments.data,'P:Show')){
			pageShow = arguments.data['P:Show'];
		} else if(structKeyExists(arguments.data, 'pageShow')){
			pageShow = arguments.data['pageShow'];
		}

		var keywords = "";
		if(structKeyExists(arguments.data,'keywords')){
			keywords = arguments.data['keywords'];
		}
		var filterGroupsConfig = "";
		if(structKeyExists(arguments.data,'filterGroupsConfig')){
			filterGroupsConfig = arguments.data['filterGroupsConfig'];
		}
		var joinsConfig = "";
		if(structKeyExists(arguments.data,'joinsConfig')){
			joinsConfig = arguments.data['joinsConfig'];
		}

		var orderByConfig = "";
		if(structKeyExists(arguments.data,'orderByConfig')){
			orderByConfig = arguments.data['orderByConfig'];
		}

		var groupBysConfig = "";
		if(structKeyExists(arguments.data,'groupBysConfig')){
			groupBysConfig = arguments.data['groupBysConfig'];
		}

		var propertyIdentifiersList = "";
		if(structKeyExists(arguments.data,"propertyIdentifiersList")){
			propertyIdentifiersList = arguments.data['propertyIdentifiersList'];
		}

		var columnsConfig = "";
		if(structKeyExists(arguments.data,'columnsConfig')){
			columnsConfig = arguments.data['columnsConfig'];
		}

		var isDistinct = false;
		if(structKeyExists(arguments.data, "isDistinct")){
			isDistinct = arguments.data['isDistinct'];
		}

		var allRecords = false;
		if(structKeyExists(arguments.data,'allRecords')){
			allRecords = arguments.data['allRecords'];
		}

		var dirtyRead = false;
		if(structKeyExists(arguments.data, 'dirtyRead')){
			dirtyRead = true;
		}

		var defaultColumns = false;
		if(structKeyExists(arguments.data,'defaultColumns')){
			defaultColumns = arguments.data['defaultColumns'];
		}

		var processContext = '';
		if(structKeyExists(arguments.data,'processContext')){
			processContext = arguments.data['processContext'];
		}

		var collectionOptions = {
			currentPage=currentPage,
			pageShow=pageShow,
			keywords=keywords,
			filterGroupsConfig=filterGroupsConfig,
			joinsConfig=joinsConfig,
			propertyIdentifiersList=propertyIdentifiersList,
			isDistinct=isDistinct,
			columnsConfig=columnsConfig,
			orderByConfig=orderByConfig,
			groupBysConfig=groupBysConfig,
			allRecords=allRecords,
			dirtyRead=dirtyRead,
			defaultColumns=defaultColumns,
			processContext=processContext
		};
		return collectionOptions;
	}

	public any function getAPIResponseForEntityName(required string entityName, required struct data, boolean enforceAuthorization=true, string whiteList){

		var collectionOptions = this.getCollectionOptionsFromData(arguments.data);
		var collectionEntity = getTransientCollectionByEntityName(arguments.entityName,collectionOptions);
		
		collectionEntity.setEnforceAuthorization(arguments.enforceAuthorization);

		if (!isNull(whiteList)){
			var authorizedPropertyList = whiteList.split(",");
			for(var authorizedProperty in authorizedPropertyList){
				collectionEntity.addAuthorizedProperty(authorizedProperty);
			}
		}
		var collectionConfigStruct = collectionEntity.getCollectionConfigStruct();

		if(!structKeyExists(collectionConfigStruct,'filterGroups')){
			collectionConfigStruct.filterGroups = [];
		}
		if(!structKeyExists(collectionConfigStruct,'joins')){
			collectionConfigStruct.joins = [];
		}
		if(!structKeyExists(collectionConfigStruct,'isDistinct')){
			collectionConfigStruct.isDistinct = false;
		}
		return getAPIResponseForCollection(collectionEntity,collectionOptions,collectionEntity.getEnforceAuthorization());

	}


	public any function getAPIResponseForBasicEntityWithID(required string entityName, required string entityID, required struct data){
		var collectionOptions = this.getCollectionOptionsFromData(arguments.data);
		var collectionEntity = getTransientCollectionByEntityName(arguments.entityName,collectionOptions);

		//set up search by id

		var collectionConfigStruct = collectionEntity.getCollectionConfigStruct();
		if(!structKeyExists(collectionConfigStruct,'filterGroups')){
			collectionConfigStruct.filterGroups = [];
		}
		if(!structKeyExists(collectionConfigStruct,'joins')){
			collectionConfigStruct.joins = [];
		}
		if(!structKeyExists(collectionConfigStruct,'isDistinct')){
			collectionConfigStruct.isDistinct = false;
		}


		var propertyIdentifier = '_' & lcase(arguments.entityName) & '.id';
		var filterStruct = createFilterStruct(propertyIdentifier,'=',arguments.entityID);

		if(!len(collectionOptions.filterGroupsConfig)){
			var filterGroupsConfig = [{
				filterGroup = []
			}];
		}else{
			var filterGroupsConfig = deserializeJson(collectionOptions.filterGroupsConfig);
		}

		arrayAppend(filterGroupsConfig[1].filterGroup,filterStruct);


		collectionOptions.filterGroupsConfig = serializeJson(filterGroupsConfig);

		var collectionResponse = getAPIResponseForCollection(collectionEntity,collectionOptions);
		var response = {};

		if(arrayLen(collectionEntity.getProcessObjectArray())){
			response = {};
			response['data'] = collectionResponse.pageRecords[1];
			response['processData'] = collectionResponse.processObjectArray[1];
		}else{
			response = collectionResponse.pageRecords[1];
		}

		return response;
	}

	public any function getAPIResponseForCollection(required any collectionEntity, required struct data, boolean enforceAuthorization=true){
		var response = {};
		var collectionOptions = this.getCollectionOptionsFromData(arguments.data);
		arguments.collectionEntity.setEnforceAuthorization(arguments.enforceAuthorization);

		if(getHibachiScope().authenticateCollection('read', arguments.collectionEntity) || !arguments.collectionEntity.getEnforceAuthorization()){
			if(structkeyExists(collectionOptions,'currentPage') && len(collectionOptions.currentPage)){
				collectionEntity.setCurrentPageDeclaration(collectionOptions.currentPage);
			}
			if(structKeyExists(collectionOptions,'pageShow') && len(collectionOptions.pageShow)){
				collectionEntity.setPageRecordsShow(collectionOptions.pageShow);
			}
			if(structKeyExists(collectionOptions,'keywords') && len(collectionOptions.keywords)){
				collectionEntity.setKeywords(collectionOptions.keywords);
			}

			if(structKeyExists(collectionOptions,'propertyIdentifiersList') && len(collectionOptions.propertyIdentifiersList)){
				addColumnsToCollectionConfigStructByPropertyIdentifierList(arguments.collectionEntity,collectionOptions.propertyIdentifiersList,arguments.collectionEntity.getEnforceAuthorization());
				var collectionPropertyIdentifiers = [];
			}else{
				var collectionPropertyIdentifiers = getPropertyIdentifierArray(collectionEntity.getCollectionObject());
			}
			if(structKeyExists(collectionOptions,'filterGroupsConfig') && len(collectionOptions.filterGroupsConfig)){
				collectionEntity.getCollectionConfigStruct().filterGroups = deserializeJson(collectionOptions.filterGroupsConfig);
			}

			if(structKeyExists(collectionOptions,'columnsConfig') && len(collectionOptions.columnsConfig)){
				collectionEntity.getCollectionConfigStruct().columns = deserializeJson(collectionOptions.columnsConfig);
				//look for non persistent columns
				for(var column in collectionEntity.getCollectionConfigStruct().columns){
					if(structKeyExists(column,'persistent') && column.persistent == false){
						//overide collectionPropertyIdentifiers
						collectionPropertyIdentifiers = getPropertyIdentifierArray(collectionEntity.getCollectionObject(), true);
						break;
					}
				}
			}

			if(structKeyExists(collectionOptions,'joinsConfig') && len(collectionOptions.joinsConfig)){
				collectionEntity.getCollectionConfigStruct().joins = deserializeJson(collectionOptions.joinsConfig);

				for(var currentJoin = 1; currentJoin <= arraylen(collectionEntity.getCollectionConfigStruct().joins); currentJoin++){

					var currentJoinParts = ListToArray(collectionEntity.getCollectionConfigStruct().joins[currentJoin]['associationName'], '.');
					var current_object = getService('hibachiService').getPropertiesStructByEntityName(arguments.collectionEntity.getCollectionObject());

					for (var i = 1; i <= arraylen(currentJoinParts); i++) {
						if(structKeyExists(current_object, currentJoinParts[i]) && structKeyExists(current_object[currentJoinParts[i]], 'cfc')){
							if(structKeyExists(current_object[currentJoinParts[i]], 'singularname')){
								collectionEntity.setHasManyRelationFilter(true);
								break;
							}
							current_object = getService('hibachiService').getPropertiesStructByEntityName(current_object[currentJoinParts[i]]['cfc']);
						}
					}
					if(collectionEntity.getHasManyRelationFilter()){
						break;
					}
				}
			}

			if(structKeyExists(collectionOptions,'orderByConfig') && len(collectionOptions.orderByConfig)){
				collectionEntity.getCollectionConfigStruct().orderBy = deserializeJson(collectionOptions.orderByConfig);
			}
			if(structKeyExists(collectionOptions,'groupBysConfig') && len(collectionOptions.groupBysConfig)){
				collectionEntity.getCollectionConfigStruct().groupBys = deserializeJson(collectionOptions.groupBysConfig);
			}

			if(structKeyExists(collectionOptions,'processContext') && len(collectionOptions.processContext)){
				collectionEntity.setProcessContext(collectionOptions.processContext);
			}
			if(structKeyExists(collectionOptions,'isDistict')){
				collectionEntity.getCollectionConfigStruct().isDistinct = collectionOptions.isDistinct;
			}
			if(structKeyExists(collectionOptions,'dirtyRead')){
				collectionEntity.setDirtyReadFlag(collectionOptions.dirtyRead);
			}

			var defaultPropertyIdentifiers = getPropertyIdentifierArray('collection');

			for(var p=1; p<=arrayLen(defaultPropertyIdentifiers); p++) {
				response[ defaultPropertyIdentifiers[p] ] = arguments.collectionEntity.getValueByPropertyIdentifier( propertyIdentifier=defaultPropertyIdentifiers[p],format=true );
			}

			var aggregatePropertyIdentifierArray = [];
			var attributePropertyIdentifierArray = [];
			//get default property identifiers for the records that the collection refers to


			if(structKeyExists(collectionEntity.getCollectionConfigStruct(),'columns')){
				for (var column in collectionEntity.getCollectionConfigStruct().columns){
					var piAlias = Replace(Replace(column.propertyIdentifier,'.','_','all'),collectionEntity.getCollectionConfigStruct().baseEntityAlias&'_','');

					if(!ArrayFind(collectionPropertyIdentifiers,piAlias)){
						ArrayAppend(collectionPropertyIdentifiers,piAlias);
					}
					//add all aggregates by alias
					if(structKeyExists(column,'aggregate')){
						ArrayAppend(aggregatePropertyIdentifierArray,column.aggregate.aggregateAlias);
					}
					//add all attributes by alias

					if(structKeyExists(column,'attributeID')){
						ArrayAppend(attributePropertyIdentifierArray,piAlias);
					}

				}
			}

			var authorizedProperties = getAuthorizedProperties(arguments.collectionEntity, collectionPropertyIdentifiers, aggregatePropertyIdentifierArray,attributePropertyIdentifierArray,arguments.collectionEntity.getEnforceAuthorization());
			for(var authorizedProperty in authorizedProperties){
				arguments.collectionEntity.addAuthorizedProperty(authorizedProperty);
			}

			var collectionStruct = {};
			if(structKeyExists(collectionOptions,'allRecords') && collectionOptions.allRecords == 'true'){
				collectionStruct = getFormattedRecords(arguments.collectionEntity,arguments.collectionEntity.getAuthorizedProperties());
			}else{
				//paginated collection struct
				collectionStruct = getFormattedPageRecords(arguments.collectionEntity,arguments.collectionEntity.getAuthorizedProperties());
			}
			structAppend(response,collectionStruct);
		}
		return response;
	}

	public array function getAuthorizedProperties(required any collectionEntity, any collectionPropertyIdentifiers=[], any aggregatePropertyIdentifierArray=[], any attributePropertyIdentifierArray=[], boolean enforeAuthorization=true){
		var authorizedProperties = [];
		for(var collectionPropertyIdentifier in arguments.collectionPropertyIdentifiers){
			if(
				getHibachiScope().authenticateCollectionPropertyIdentifier('read', arguments.collectionEntity,collectionPropertyIdentifier)
				|| (
					!arguments.enforeAuthorization
					&& !findnocase('_',collectionPropertyIdentifier)
				)
			){
				arrayAppend(authorizedProperties,collectionPropertyIdentifier);
			}
		}
		for(var aggregatePropertyIdentifier in arguments.aggregatePropertyIdentifierArray){
			arrayAppend(authorizedProperties,aggregatePropertyIdentifier);
		}
		for(var attributePropertyIdentifier in arguments.attributePropertyIdentifierArray){

			arrayAppend(authorizedProperties,attributePropertyIdentifier);
		}

		return authorizedProperties;
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

	public array function getExportableColumnsByCollectionConfig(required struct collectionConfig){
		var exportableColumns = [];
		for(var column in arguments.collectionConfig.columns){
			if(StructKeyExists(column, "isExportable") && column.isExportable == true){
				ArrayAppend(exportableColumns, column);
			}
		}
		return exportableColumns;
	}

	public void function collectionsExport(required struct data) {
			param name="data.date" default="#dateFormat(now(), 'mm/dd/yyyy')#"; 							//<--The fileName of the report to export.
			param name="data.collectionExportID" default="" type="string"; 											//<--The collection to export ID
			var collectionEntity = this.getCollectionByCollectionID("#arguments.data.collectionExportID#");

			if(structKeyExists(arguments.data,'ids') && !isNull(arguments.data.ids) && arguments.data.ids != 'undefined' && arguments.data.ids != ''){
				var propertyIdentifier = '_' & getService('hibachiCollectionService').getCollectionObjectByCasing(collectionEntity,'camel') & '.' & getService('hibachiService').getPrimaryIDPropertyNameByEntityName(collectionEntity.getCollectionObject());
				var filterGroup = {
					propertyIdentifier = propertyIdentifier,
					comparisonOperator = 'IN',
					value = arguments.data.ids
				};
				collectionEntity.getCollectionConfigStruct().filterGroups = [
					{
						'filterGroup'=[

						]
					}
				];
				arrayAppend(collectionEntity.getCollectionConfigStruct().filterGroups[1].filterGroup,filterGroup);
		}else if(!isnull(collectionEntity.getParentCollection())){
			var filterGroupArray = [];
			if(!isnull(collectionEntity.getCollectionConfigStruct().filterGroups) && arraylen(collectionEntity.getCollectionConfigStruct().filterGroups)){
				filterGroupArray = collectionEntity.getCollectionConfigStruct().filterGroups;
			}
			var parentCollectionStruct = collectionEntity.getParentCollection().getCollectionConfigStruct();
			if (!isnull(parentCollectionStruct.filterGroups) && arraylen(parentCollectionStruct.filterGroups)) {
				collectionEntity.getCollectionConfigStruct().filterGroups = collectionEntity.mergeCollectionFilter(parentCollectionStruct.filterGroups, filterGroupArray);
				if(structKeyExists(parentCollectionStruct, 'joins')){
					collectionEntity.mergeJoins(parentCollectionStruct.joins);
				}
			}
			}
			var exportCollectionConfigData = {};
			exportCollectionConfigData['collectionConfig']=serializeJson(collectionEntity.getCollectionConfigStruct());
			if(structKeyExists(arguments.data,'keywords')){
				exportCollectionConfigData['keywords']=arguments.data.keywords;
			}
			this.collectionConfigExport(exportCollectionConfigData);
	}//<--end function

	public void function collectionConfigExport(required struct data) {
		param name="arguments.data.collectionConfig" type="string" pattern="^{.*}$";

		arguments.data.collectionConfig = DeserializeJSON(arguments.data.collectionConfig);

		var collectionEntity = getCollectionList(arguments.data.collectionConfig.baseEntityName);
		if(structKeyExists(arguments.data,'keywords')){
			collectionEntity.setKeywords(arguments.data.keywords);
		}

		arguments.data.collectionConfig.columns = getExportableColumnsByCollectionConfig(arguments.data.collectionConfig);
		arguments.data.collectionConfig["allRecords"] = true;
		collectionEntity.setCollectionConfig(serializeJSON(arguments.data.collectionConfig));
		var collectionData = collectionEntity.getRecords(forExport=true,formatRecords=false);
		var headers = getHeadersListByCollection(collectionEntity);
		getHibachiService().export( collectionData, headers, headers, arguments.data.collectionConfig.baseEntityName, "csv" );
	}

	public string function getHeadersListByCollection(required any collectionEntity){
		var headersList = '';
		var columns = arguments.collectionEntity.getCollectionConfigStruct().columns;
		for(var column in columns){
			headersList = listAppend(headersList,arguments.collectionEntity.getColumnAlias(column));
		}
		return headersList;
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
