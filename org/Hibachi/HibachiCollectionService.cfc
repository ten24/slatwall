component output="false" accessors="true" extends="HibachiService" {
	property name="hibachiService" type="any";
	property name="HibachiUtilityService" type="any";
	property name="aliasMap" type="struct";
	property name="collectionCache" type="struct";
	
	
	
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
	
	public struct function getCollectionCache(){
		if(!structKeyExists(variables,'collectionCache')){
			variables.collectionCache = {};
		}
		
		return variables.collectionCache;
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

	public any function getBadCollectionInfo(required any collectionEntity, string failedCollectionMessage){
		formattedPageRecords[ "pageRecords" ] = [];

		formattedPageRecords[ "recordsCount" ] = 0;
		formattedPageRecords[ "pageRecordsCount" ] = 0;
		formattedPageRecords[ "pageRecordsShow"] = arguments.collectionEntity.getPageRecordsShow();
		formattedPageRecords[ "pageRecordsStart" ] = 0;
		formattedPageRecords[ "pageRecordsEnd" ] = 0;
		formattedPageRecords[ "currentPage" ] = arguments.collectionEntity.getCurrentPage();
		formattedPageRecords[ "totalPages" ] = arguments.collectionEntity.getTotalPages();
		formattedPageRecords['failed'] = true;
		var context = getPageContext();
		var status = 500;
		var statusMessage = "collection failed";
		if(getApplicationValue('errorDisplayFlag')){
			statusMessage &= ":#failedCollectionMessage#";
		}
		context.getResponse().setStatus(status, statusMessage);
	}

	public any function getFormattedPageRecords(required any collectionEntity, required array propertyIdentifiers){

		var formattedPageRecords = {};
		var paginatedCollectionOfEntities = collectionEntity.getPageRecords(formatRecords=false);
		if(ArrayLen(paginatedCollectionOfEntities) == 1 && structKeyExists(paginatedCollectionOfEntities[1],'failedCollection')){
			formattedPageRecords = getBadCollectionInfo(arguments.collectionEntity,paginatedCollectionOfEntities[1]['failedCollection']);
		}else{

			formattedPageRecords[ "pageRecords" ] = getFormattedObjectRecords(paginatedCollectionOfEntities,arguments.propertyIdentifiers,arguments.collectionEntity);
			var recordsCountData = arguments.collectionEntity.getRecordsCountData();
			for(var key in recordsCountData){
				var recordsCountDataItem = recordsCountData[key];
				formattedPageRecords[ key ] = recordsCountDataItem;
			}
			//return aggregates data
			
			formattedPageRecords[ "pageRecordsCount" ] = arrayLen(arguments.collectionEntity.getPageRecords(formatRecords=false));
			formattedPageRecords[ "pageRecordsShow"] = arguments.collectionEntity.getPageRecordsShow();
			formattedPageRecords[ "pageRecordsStart" ] = arguments.collectionEntity.getPageRecordsStart();
			formattedPageRecords[ "pageRecordsEnd" ] = arguments.collectionEntity.getPageRecordsEnd();
			formattedPageRecords[ "currentPage" ] = arguments.collectionEntity.getCurrentPage();
			formattedPageRecords[ "totalPages" ] = arguments.collectionEntity.getTotalPages();
			formattedPageRecords[ "aggregations" ] = arguments.collectionEntity.getAggregations();
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

		var collectionObject = lcase(arguments.collectionEntity.getCollectionObject());
		var collectionObjectLength = len(collectionObject);

		var propertyIdentifiersArray = ListToArray(arguments.propertyIdentifierList);
		for(var propertyIdentifierItem in propertyIdentifiersArray){

			if(left(propertyIdentifierItem,collectionObjectLength+1) != '_#collectionObject#'){
				propertyIdentifierItem = '_#collectionObject#.#propertyIdentifierItem#';

			}
			if(
				!arguments.collectionEntity.getEnforceAuthorization() || getHibachiScope().authenticateCollectionPropertyIdentifier('read', arguments.collectionEntity, propertyIdentifierItem)
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
			var orderByArray = collectionConfigStruct['orderBy'];
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
			collectionConfigStruct['filterGroups'] = [];
		}
		var capitalCaseEntityName = capitalCase(arguments.entityName);
		var propertyIdentifier = capitalCaseEntityName & '.#arguments.entityName#ID';
		var filterStruct = createFilterStruct(propertyIdentifier,'=',arguments.entityID);

		var filterGroupStruct.filterGroup = [];
		arrayappend(filterGroupStruct.filterGroup,filterStruct);

		arrayAppend(collectionConfigStruct['filterGroups'],filterGroupStruct);*/
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
			collectionConfigStruct['filterGroups'] = deserializeJson(arguments.data.filterConfig);
		}
		
		if(!isNull(arguments.data.joinsConfig)){
			collectionConfigStruct.joins = deserializeJson(arguments.data.joinsConfig);
		}

		if(!isNull(arguments.data.orderByConfig)){
			collectionConfigStruct['orderBy'] = deserializeJson(arguments.data.orderByConfig);
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
			collectionConfig['orderBy'] = getOrderByArrayByURLParams(arguments.data.orderBy);
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
	public string function buildURL(required string queryAddition, boolean appendValues=true, boolean toggleKeys=true, string currentURL="", string delimiter=",") {
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
				//added final list last argument, include empty values, set to true to avoid problem of duplicating query key when it's empty
				oldQueryKeys[listFirst(keyValuePair,"=")] = listLast(keyValuePair,"=",true);
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
				// decode needed in cases where the filter value is encoded (ex: The filter originally had a space before being passed into the query string)
				oldQueryKeys[key] = URLDecode(oldQueryKeys[key]);
				if(!structKeyExists(newQueryKeys, key)) {
					modifiedURL &= "#key#=#oldQueryKeys[key]#&";
				} else {
					if(arguments.toggleKeys && structKeyExists(oldQueryKeys, key) && structKeyExists(newQueryKeys, key) && oldQueryKeys[key] == newQueryKeys[key]) {
						structDelete(newQueryKeys, key);
					} else if(arguments.appendValues) {
						arguments.delimiter = variables.valuedelimiter;
						if(findNoCase('like',right(key,4))){
							arguments.delimiter = '|';
						}
					
						for(var i=1; i<=listLen(newQueryKeys[key], arguments.delimiter); i++) {
							var thisVal = listGetAt(newQueryKeys[key], i, arguments.delimiter);
							var findCount = listFindNoCase(oldQueryKeys[key], thisVal, delimiter);
							if(findCount) {
								newQueryKeys[key] = listDeleteAt(newQueryKeys[key], i, arguments.delimiter);
								if(arguments.toggleKeys) {
									oldQueryKeys[key] = listDeleteAt(oldQueryKeys[key], findCount, arguments.delimiter);
								}
							}
						}
						if(len(oldQueryKeys[key]) && len(newQueryKeys[key])) {
								modifiedURL &= "#key#=#oldQueryKeys[key]##arguments.delimiter##newQueryKeys[key]#&";
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
		return getHibachiUtilityService().hibachiHTMLEditFormat(modifiedURL);
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
		//combine the different params to prevent forked logic
		if(structKeyExists(arguments.data, 'pageShow')){
			arguments.data['P:Show'] = arguments.data['pageShow'];
		}
		//if using p:show param then put a limit. This shouldn't affect getRecords
		if(structKeyExists(arguments.data,'P:Show')){
			pageShow = arguments.data['P:Show'];
			//prevent getting too many records
			var globalAPIPageShowLimit = getService("SettingService").getSettingValue("globalAPIPageShowLimit");
			if(pageShow > globalAPIPageShowLimit){
				pageShow = globalAPIPageShowLimit; 
			}
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
		//by default don't use any generated joinsConfigs unless explicitly defined. 90% of joins should be handled on the backend
		if((structKeyExists(arguments.data,'useJoinsConfig') && arguments.data.useJoinsConfig) && structKeyExists(arguments.data,'joinsConfig')){
			joinsConfig = arguments.data['joinsConfig'];
		}

		var orderByConfig = "";
		if(structKeyExists(arguments.data,'orderByConfig')){
			orderByConfig = arguments.data['orderByConfig'];
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
		
		var isReport = false;
		if(structKeyExists(arguments.data,'isReport')){
			isReport = arguments.data['isReport'];
		}
		
		var periodInterval = "";
		if(structKeyExists(arguments.data,'periodInterval')){
			periodInterval = arguments.data['periodInterval'];
			isReport = true;
		}

		var allRecords = false;
		if(structKeyExists(arguments.data,'allRecords')){
			allRecords = arguments.data['allRecords'];
		}

		var dirtyRead = false;
		if(structKeyExists(arguments.data, 'dirtyRead')){
			dirtyRead = true;
		}
		

		var useElasticSearch = false;
		if(structKeyExists(arguments.data, 'useElasticSearch')){
			useElasticSearch = arguments.data['useElasticSearch'];
		}

		var splitKeywords = true;
		if(structKeyExists(arguments.data, 'splitKeywords')){
			splitKeywords = arguments.data['splitKeywords'];
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
			allRecords=allRecords,
			dirtyRead=dirtyRead,
			useElasticSearch=useElasticSearch,
			splitKeywords=splitKeywords,
			defaultColumns=defaultColumns,
			processContext=processContext,
			isReport=isReport
			
		};
		if(len(periodInterval)){
			collectionOptions.periodInterval=periodInterval;
		}
		
		return collectionOptions;
	}

	public any function getAPIResponseForEntityName(required string entityName, required struct data, boolean enforceAuthorization=true, string whiteList){
		
		if(!structKeyExists(arguments.data,'propertyIdentifiersList') && !structKeyExists(arguments.data,'defaultColumns')){
			arguments.data['defaultColumns'] = true;
		}
		
		var collectionOptions = this.getCollectionOptionsFromData(arguments.data);
		var collectionEntity = getTransientCollectionByEntityName(arguments.entityName,collectionOptions);
		collectionEntity.setEnforceAuthorization(arguments.enforceAuthorization);
		if (!isNull(whiteList)){
			var authorizedPropertyList = whiteList.split(",");
			for(var authorizedProperty in authorizedPropertyList){
				collectionEntity.addAuthorizedProperty(authorizedProperty);
			}
		}

		if(structKeyExists(arguments.data, "restRequestFlag") && arguments.data.restRequestFlag){
			collectionEntity.applyData(); 
 		} 
		
		return getAPIResponseForCollection(collectionEntity,collectionOptions,collectionEntity.getEnforceAuthorization());

	}


	public any function getAPIResponseForBasicEntityWithID(required string entityName, required string entityID, required struct data){
		var collectionOptions = this.getCollectionOptionsFromData(arguments.data);
		var collectionEntity = getTransientCollectionByEntityName(arguments.entityName,collectionOptions);

		//set up search by id

		var collectionConfigStruct = collectionEntity.getCollectionConfigStruct();
		if(!structKeyExists(collectionConfigStruct,'filterGroups')){
			collectionConfigStruct['filterGroups'] = [];
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

		if(!arguments.collectionEntity.getEnforceAuthorization() || getHibachiScope().authenticateCollection('read', arguments.collectionEntity)){
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
				collectionEntity.getCollectionConfigStruct()['filterGroups'] = deserializeJson(collectionOptions.filterGroupsConfig);
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
				collectionEntity.getCollectionConfigStruct()['orderBy'] = deserializeJson(collectionOptions.orderByConfig);
			}
			if(structKeyExists(collectionOptions,'groupBysConfig') && len(collectionOptions.groupBysConfig)){
				collectionEntity.getCollectionConfigStruct().groupBys = deserializeJson(collectionOptions.groupBysConfig);
			}

			if(structKeyExists(collectionOptions,'processContext') && len(collectionOptions.processContext)){
				collectionEntity.setProcessContext(collectionOptions.processContext);
			}
			if(structKeyExists(collectionOptions,'isDistinct')){
				collectionEntity.getCollectionConfigStruct().isDistinct = collectionOptions.isDistinct;
			}
			if(structKeyExists(collectionOptions,'dirtyRead')){
				collectionEntity.setDirtyReadFlag(collectionOptions.dirtyRead);
			}
			if(structKeyExists(collectionOptions,'useElasticSearch')){
				collectionEntity.setUseElasticSearch(collectionOptions.useElasticSearch);
			} 
			if(structKeyExists(collectionOptions,'splitKeywords')){
				collectionEntity.setSplitKeywords(collectionOptions.splitKeywords);
			}
			if(structKeyExists(collectionOptions,'periodInterval')){
				collectionEntity.getCollectionConfigStruct()['periodInterval'] = collectionOptions['periodInterval'];
				collectionEntity.setReportFlag(1);
			}
			

			var defaultPropertyIdentifiers = getPropertyIdentifierArray('collection');

			for(var p=1; p<=arrayLen(defaultPropertyIdentifiers); p++) {
				response[ defaultPropertyIdentifiers[p] ] = arguments.collectionEntity.getValueByPropertyIdentifier( propertyIdentifier=defaultPropertyIdentifiers[p],format=true );
			}
			response['collectionConfig'] = serializeJson(arguments.collectionEntity.getCollectionConfigStruct());
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
					
					//add all columns with custom alias
					if(structKeyExists(column,'alias')){
						ArrayAppend(collectionPropertyIdentifiers,column.alias);
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
				(
					!arguments.enforeAuthorization
					&& !findnocase('_',collectionPropertyIdentifier)
				)||
				getHibachiScope().authenticateCollectionPropertyIdentifier('read', arguments.collectionEntity,collectionPropertyIdentifier)
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
		param name="data.date" default="#dateFormat(now(), 'mm/dd/yyyy')#"; //<--The fileName of the report to export.
		param name="data.collectionExportID" default="" type="string";      //<--The collection to export ID

		//short circuit to prevent non admin use
		if(!getHibachiScope().getAccount().getAdminAccountFlag()){
			return;
		}

		var collectionEntity = this.getCollectionByCollectionID("#arguments.data.collectionExportID#");

		if(structKeyExists(arguments.data,'ids') && !isNull(arguments.data.ids) && arguments.data.ids != 'undefined' && arguments.data.ids != ''){
			var propertyIdentifier = '_' & getService('hibachiCollectionService').getCollectionObjectByCasing(collectionEntity,'camel') & '.' & getService('hibachiService').getPrimaryIDPropertyNameByEntityName(collectionEntity.getCollectionObject());
			var filterGroup = {
				propertyIdentifier = propertyIdentifier,
				comparisonOperator = 'IN',
				value = arguments.data.ids
			};
			collectionEntity.getCollectionConfigStruct()['filterGroups'] = [
				{
					'filterGroup'=[

					]
				}
			];
			arrayAppend(collectionEntity.getCollectionConfigStruct()['filterGroups'][1].filterGroup,filterGroup);
		
		}else if(!isnull(collectionEntity.getParentCollection())){
			var filterGroupArray = [];
			if(!isnull(collectionEntity.getCollectionConfigStruct()['filterGroups']) && arraylen(collectionEntity.getCollectionConfigStruct()['filterGroups'])){
				filterGroupArray = collectionEntity.getCollectionConfigStruct()['filterGroups'];
			}
			var parentCollectionStruct = collectionEntity.getParentCollection().getCollectionConfigStruct();
			if (!isnull(parentCollectionStruct['filterGroups']) && arraylen(parentCollectionStruct['filterGroups'])) {
				collectionEntity.getCollectionConfigStruct()['filterGroups'] = collectionEntity.mergeCollectionFilter(parentCollectionStruct['filterGroups'], filterGroupArray);
				if(structKeyExists(parentCollectionStruct, 'joins')){
					collectionEntity.mergeJoins(parentCollectionStruct.joins);
				}
			}
		}
		if(!isNull(collectionEntity.getMergeCollection())){
			var headers1 = getHeadersListByCollection(collectionEntity);
			var title1 = getHeadersListByCollection(collectionEntity, true);
			
			var headers2 = getHeadersListByCollection(collectionEntity.getMergeCollection());
			var title2 = getHeadersListByCollection(collectionEntity.getMergeCollection(), true);
			
			var mergedTitles = ListRemoveDuplicates(listAppend(title1, title2));
			var mergedHeaders = ListRemoveDuplicates(listAppend(headers1, headers2));
			
			var collectionData = getMergedCollectionData(collectionEntity, data);
			
			getHibachiService().export( collectionData, mergedHeaders, mergedTitles, collectionEntity.getCollectionObject(), "csv" );
			return;
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
		
		//short circuit to prevent non admin use
		if(!getHibachiScope().getAccount().getAdminAccountFlag()){
			return;
		}
		
		arguments.data.collectionConfig = DeserializeJSON(arguments.data.collectionConfig);
		
		var collectionEntity = getCollectionList(arguments.data.collectionConfig.baseEntityName);
		if(structKeyExists(arguments.data,'keywords')){
			collectionEntity.setKeywords(arguments.data.keywords);
		}
		arguments.data.collectionConfig.columns = getExportableColumnsByCollectionConfig(arguments.data.collectionConfig);
		arguments.data.collectionConfig["allRecords"] = true;
		collectionEntity.setCollectionConfig(serializeJSON(arguments.data.collectionConfig));

		if(ArrayLen(arguments.data.collectionConfig.columns) == 0){
			var defaultCollectionProperties = this.new(arguments.data.collectionConfig.baseEntityName).getDefaultCollectionProperties();
			for(var property in defaultCollectionProperties){	
				collectionEntity.addDisplayProperty(property['name'], '', {isExportable=true});
			}
		} 
		
		if(structKeyExists(arguments.data,'exportFileName')){
			collectionEntity.setExportFileName(arguments.data.exportFileName);
		}

		var collectionConfigData = getCollectionConfigExportDataByCollection(collectionEntity);
		getHibachiService().export( argumentCollection=collectionConfigData );
	}

	public query function getMergedCollectionData(required any collection1, any data){
		var collection2 = arguments.collection1.getMergeCollection();


		if(structKeyExists(arguments.data,'keywords')){
			collection1.setKeywords(arguments.data.keywords);
		}
		var primaryIDPropertyName = getPrimaryIDPropertyNameByEntityName(collection1.getCollectionObject());
		
		//Because we need to be able to join the collections later, we need to force the primaryIDProperty to be exportable
		collection1 = forcePrimaryIDExportable( collection1 );
		collection2 = forcePrimaryIDExportable( collection2 );
		
		var collection1Headers = getHeadersListByCollection(collection1);
		var collection2Headers = getHeadersListByCollection(collection2);
		var collection1Data = this.transformArrayOfStructsToQuery(collection1.getRecords(forExport=true,formatRecords=false), ListToArray(collection1Headers));
		var collection2Data = this.transformArrayOfStructsToQuery(collection2.getRecords(forExport=true,formatRecords=false), ListToArray(collection2Headers));

		if(collection2Data.recordCount > 0){
			var rightIDQuery = new Query();
			rightIDQuery.setDBType('Query');
			rightIDQuery.setAttributes(collection2Data = collection2Data);
			var rightIDSQL = "SELECT #primaryIDPropertyName# as primaryID FROM collection2Data";
			var rightIDs = rightIDQuery.execute(sql=rightIDSql).getResult();
			rightIDs = quotedValueList(rightIDs.primaryID);
		}else{
			rightIDs = '';
		}

		if(collection1Data.recordCount > 0){
			//Only needed in order to set typename for all collection1Data columns
			var leftIDQuery = new Query();
			leftIDQuery.setDBType('Query');
			leftIDQuery.setAttributes(collection1Data = collection1Data);
			var leftIDSQL = "SELECT #primaryIDPropertyName# as primaryID FROM collection1Data";
			leftIDQuery.execute(sql=leftIDSql);
		}

		if(!collection1Data.recordCount && !collection2Data.recordCount){
			return collection1Data;
		}
		var mainSql = "	SELECT #getMergedColumnList(collection1Headers,collection2Headers)#
						FROM collection1Data, collection2Data
						WHERE collection1Data.#primaryIDPropertyName# = collection2Data.#primaryIDPropertyName#";
		var leftSql = "	SELECT * FROM collection1Data";
		if(len(rightIDs)){
			leftSql &= " WHERE collection1Data.#primaryIDPropertyName# NOT IN (#rightIDs#)";
		}

		for(var column in getCollection2UniqueColumns(collection1Headers, collection2Headers)){
			QueryAddColumn(collection1Data, column, 'VarChar',[]);
		};

		var joinQuery = new Query();
		joinQuery.setDBType('Query');
		joinQuery.setAttributes(collection1Data = collection1Data, collection2Data = collection2Data);
		var joinSql = mainSql & " union all " & leftSql;
		var joinResult = joinQuery.execute(sql=joinSql).getResult();
		return joinResult;
	}

	private string function getMergedColumnList(required string collection1Headers, required string collection2Headers){
		var collection2Columns = '';
		for(var column in getCollection2UniqueColumns(arguments.collection1Headers, arguments.collection2Headers)){
			collection2Columns = listAppend(collection2Columns, 'collection2Data.#column#',',');
		};
		var collection1Columns = '';
		for(var header in arguments.collection1Headers){
			collection1Columns = listAppend(collection1Columns, 'collection1Data.#header#', ',');
		};
 		return listAppend(collection1Columns, collection2Columns);
	}

	private string function getCollection2UniqueColumns(required string collection1Headers, required string collection2Headers){
		var collection2UniqueColumns = '';
		for(var column in arguments.collection2Headers){
			if(!listFindNoCase(arguments.collection1Headers, column)){
				collection2UniqueColumns = ListAppend(collection2UniqueColumns, column, ',');
			}
		}
		return collection2UniqueColumns;
	}
	
	public struct function getCollectionConfigExportDataByCollection(required any collectionEntity){
		var exportFileName = "";
		
		//short circuit to prevent non admin use
		if(!getHibachiScope().getAccount().getAdminAccountFlag()){
			return;
		}
		
		if(!isNull(arguments.collectionEntity.getExportFileName()) && Len(arguments.collectionEntity.getExportFileName())) {
			exportFileName = arguments.collectionEntity.getExportFileName();
		} else {
			exportFileName = arguments.collectionEntity.getCollectionConfigStruct().baseEntityName;
		}
		
		var collectionData = arguments.collectionEntity.getRecords(forExport=true,formatRecords=false);
		var headers = getHeadersListByCollection(arguments.collectionEntity);
		var title =  getHeadersListByCollection(arguments.collectionEntity, true);
		
		var collectionConfigData = {
			data=collectionData, 
			columns=headers, 
			columnNames=title, 
			fileName=exportFileName, 
			fileType = 'csv', 
			downloadFile=true
		};
		
		return collectionConfigData;
	}

	public string function getHeadersListByCollection(required any collectionEntity, boolean getTitleFlag = false){
		var headersList = '';
		var columns = arguments.collectionEntity.getCollectionConfigStruct().columns;
		for(var column in columns){
			if(StructKeyExists(column, "isExportable") && column.isExportable == true){
				if (arguments.getTitleFlag){
					if ( structKeyExists(column, 'displayTitle') ){
						headersList = listAppend(headersList, column.displayTitle);
					} else {
						headersList = listAppend(headersList, column.title);
					}
				}else {
					headersList = listAppend(headersList,arguments.collectionEntity.getColumnAlias(column));
				}
			}
		}
		return headersList;
	}
	
	public any function forcePrimaryIDExportable (required any collectionEntity){
		var primaryIDPropertyName = getPrimaryIDPropertyNameByEntityName(arguments.collectionEntity.getCollectionObject());
		
		for (var column in arguments.collectionEntity.getCollectionConfigStruct().columns){
			if (
				column.ormtype == 'id' 
				&& structKeyExists(column,'key')
				&& column.key == primaryIDPropertyName
			){
				column.isExportable = true;
				break;
			}
		}
		arguments.collectionEntity.setCollectionConfig( serializeJson(arguments.collectionEntity.getCollectionConfigStruct()) );
		
		return arguments.collectionEntity;
	}
	
	public void function applyDataForStandardFilter(required any collection, required any data, string excludesList="", string key){
		var prop = listToArray(arguments.key,':')[2];
		if(
			arguments.collection.hasPropertyByPropertyIdentifier(prop) 
			&& arguments.collection.getPropertyIdentifierIsPersistent(prop) 
			&& listFind(trim(arguments.excludesList),trim(prop)) == 0 
		){
			var dataToFilterOn = data[arguments.key]; //value of the filter.

			var comparison = "=";
			try{
				comparison = listToArray(arguments.key,':')[3];
			}catch(any e){
				comparison = "=";
			}
			if (!isNull(comparison)){
				if (comparison == 'eq'){
					if(listLen(dataToFilterOn) == 1){
						comparison = "=";
					}else{
						comparison = "in";
					}
				}
				if (comparison == 'gte'){
					comparison = ">=";
				}
				if (comparison == 'lte'){
					comparison = "<=";
				}
				if (comparison == 'gt'){
					comparison = ">";
				}
				if (comparison == 'lt'){
					comparison = "<";
				}
				if (comparison == 'neq'){
					comparison = "!=";
				}
			}

			if (comparison == 'like'){
				var dataToFilterOnArray = listToArray(dataToFilterOn,'|');

				for(var i=1; i <= arraylen(dataToFilterOnArray);i++){
					var item = dataToFilterOnArray[i];
					var filterData = {
						propertyIdentifier=prop,
						value='#item#%',
						comparisonOperator=comparison
					};

					if(i > 1){
						filterData.logicalOperator = 'OR';
					}

					if(!structKeyExists(arguments.collection.getCollectionConfigStruct(),'filterGroups')){
						arguments.collection.getCollectionConfigStruct()['filterGroups'] = [{"filterGroup"=[]}];
					}

					filterData['filterGroupAlias'] = "like#prop#";
					filterData['filterGroupLogicalOperator'] = "AND";

					if(!arguments.collection.hasFilterByFilterGroup(filterData,arguments.collection.getCollectionConfigStruct()['filterGroups'][arguments.collection.getFilterGroupIndexByFilterGroupAlias(filterData['filterGroupAlias'])]['filterGroup'])){
						arguments.collection.addFilter(argumentCollection=filterData);
				}
					arguments.collection.setFilterDataApplied(true);

			}

			}else{
				var filter = {
					propertyIdentifier=prop,
					value=dataToFilterOn,
					comparisonOperator=comparison
				};

				if(
					!structKeyExists(arguments.collection.getCollectionConfigStruct(),'filterGroups')
					|| !arrayLen(arguments.collection.getCollectionConfigStruct()['filterGroups'])
					|| !arguments.collection.hasFilterByFilterGroup(filter,arguments.collection.getCollectionConfigStruct()['filterGroups'][1]['filterGroup'])
				){
					if(listFind(trim(arguments.excludesList),trim(prop)) > 0 ){
						arguments.collection.removeFilter(prop, dataToFilterOn, comparison);
					}else{
						arguments.collection.addFilter(prop, dataToFilterOn, comparison);
					}
				}

				arguments.collection.setFilterDataApplied(true);
			}

		}
	}
	
	public void function applyDataForFilters(required any collection, required any data, string excludesList="", string key){
		//handle filters.
		
		if(isValid('string',arguments.data[arguments.key])){
			if (left(arguments.key, 3) == "fr:"){

				var prop = listToArray(arguments.key,':')[2];

				if(arguments.collection.hasPropertyByPropertyIdentifier(prop) && arguments.collection.getPropertyIdentifierIsPersistent(prop)){
					var dataToFilterOn = arguments.data[arguments.key]; //value of the filter.

					var comparison = "=";
					try{
						comparison = listToArray(arguments.key,':')[3];
					}catch(any e){
						comparison = "=";
					}
					if (!isNull(comparison)){
						if (comparison == 'eq'){
							if(listLen(dataToFilterOn) == 1){
								comparison = "=";
							}else{
								comparison = "in";
							}
						}
						if (comparison == 'gte'){
							comparison = ">=";
						}
						if (comparison == 'lte'){
							comparison = "<=";
						}
						if (comparison == 'gt'){
							comparison = ">";
						}
						if (comparison == 'lt'){
							comparison = "<";
						}
						if (comparison == 'neq'){
							comparison = "!=";
						}
						if (comparison == 'like'){
							dataToFilterOn = "%#dataToFilterOn#%";
						}
					}
					arguments.collection.removeFilter(prop,dataToFilterOn,comparison);
				}
			}
			//handle filters.
			if (left(arguments.key, 2) == "f:"){
				applyDataForStandardFilter(argumentCollection=arguments);
			}

			//Handle Range
			if (left(arguments.key, 2) == "r:"){
				var value = arguments.data[arguments.key];
				var ranges = listToArray(value);
				var filterParts = "#listToArray(arguments.key, ':')#";
				var prop = filterParts[2];//property
				if(
					arguments.collection.hasPropertyByPropertyIdentifier(prop) 
					&& arguments.collection.getPropertyIdentifierIsPersistent(prop) 
					&& listFind(trim(arguments.excludesList),trim(prop)) == 0
				){
					var ormtype = arguments.collection.getOrmTypeByPropertyIdentifier(prop);
					var rangeValues = listToArray(data[arguments.key]);//value 20^40,100^ for example.

					for(var i=1; i <= arraylen(rangeValues);i++){
						var rangeValue = rangeValues[i];
						var rangeArray = listToArray(rangeValue,'^');
						var rangeLen = 0;
						if (isArray(rangeArray)){
							rangeLen = arrayLen(rangeArray);
						}

						if (rangeLen > 1){
							var filterData = {
								propertyIdentifier=prop,
								value=replace(rangeValue,'^','-'),
								comparisonOperator='BETWEEN',
								ormtype=ormtype
							};
						}else if (rangeLen == 1 && left(rangeValue, 1) == "^"){
							var filterData = {
								propertyIdentifier=prop,
								value=replace(rangeValue,'^',''),
								comparisonOperator='<=',
								ormtype=ormtype
							};
						}else if (rangeLen == 1 && right(rangeValue, 1) == "^"){
							var filterData = {
								propertyIdentifier=prop,
								value=replace(rangeValue,'^',''),
								comparisonOperator='>=',
								ormtype=ormtype
							};
						}else{
							//can't build because there is not enough range information.
							return;
						}


						if(i > 1){
							filterData.logicalOperator = 'OR';
						}

						if(!structKeyExists(arguments.collection.getCollectionConfigStruct(),'filterGroups')){
							arguments.collection.getCollectionConfigStruct()['filterGroups'] = [{'filterGroup'=[]}];
						}

						filterData['filterGroupAlias'] = "range#prop#";
						filterData['filterGroupLogicalOperator'] = "AND";



						if(!arguments.collection.hasFilterByFilterGroup(
							filterData,arguments.collection.getCollectionConfigStruct()['filterGroups'][arguments.collection.getFilterGroupIndexByFilterGroupAlias(filterData['filterGroupAlias'])]['filterGroup'])){
							arguments.collection.addFilter(argumentCollection=filterData);
						}
						arguments.collection.setFilterDataApplied(true);
						//get the data value for the range. for example 20^40, ^40 (0 to 40), 100^ (more than 100)

						//;
					}
				}
			}
		}
	}
	
	public void function applyData(required any collection, required any data=url, string excludesList=""){
		var filterKeyList = "";
		var hibachiBaseEntity = "";
		hibachiBaseEntity = arguments.collection.getCollectionObject();

		if(!isStruct(data) && isSimpleValue(data)) {
			arguments.data = getHibachiUtilityService().convertNVPStringToStruct(arguments.data);
			filterKeyList = structKeyList(arguments.data);
		}
		//Simple Filters
		if(!arguments.collection.hasFilterDataApplied()){
			for (var key in arguments.data){

				applyDataForFilters(arguments.collection,arguments.data,arguments.excludesList,key);
				//OrderByList
				var orderBys = data[key];
				if (left(key,7)=='orderBy'){
					if(len(arguments.excludesList)){ 
						var propertiesToExclude = listToArray(arguments.excludesList);
						for(var propertyToExclude in propertiesToExclude){
							orderBys = getHibachiUtilityService().removeListValue(orderBys,propertyToExclude & '|DESC');	
							orderBys = getHibachiUtilityService().removeListValue(orderBys,propertyToExclude & '|ASC');	
						}   

					}
					//this is a list.
					arguments.collection.setOrderBy(orderBys);
				}


				//Handle pagination.
				if(findNoCase('p:current', key) && isNumeric(data[key]) ){
					var currentPage = data[key];
				}
				if (!isNull(currentPage)){
					data['currentPageDeclaration'] = currentPage;
					arguments.collection.setCurrentPageDeclaration(currentPage);
				}

				if(findNoCase('p:show', key) && isNumeric(data[key])){
					var pageShow = data[key];
				}

				if (!isNull(pageShow)){
					if(pageShow >= 1)
					{
						arguments.collection.setPageRecordsShow(pageShow);
					}

				}

			}
		}
	}


	// =====================  END: Logical Methods ============================

	// ===================== START: DAO Passthrough ===========================

	// ===================== START: DAO Passthrough ===========================

	// ===================== START: Process Methods ===========================
	
	public any function processCollection_clearCache(required any collection){
		var cacheKeyPrefix = '_report_#arguments.collection.getCollectionID()#';
		getService('HibachiCacheService').resetCachedKeyByPrefix(cacheKeyPrefix,true);	
		return arguments.collection;
	}

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
