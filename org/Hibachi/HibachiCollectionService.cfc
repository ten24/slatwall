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

	public any function getTransientCollectionByEntityName(required string entityName,struct collectionOptions){
		var collectionEntity = this.newCollection();
		var properlyCasedShortEntityName = getProperlyCasedShortEntityName(arguments.entityName);
		collectionEntity.setCollectionObject(properlyCasedShortEntityName,arguments.collectionOptions.defaultColumns);

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
			if(arrayLen(arguments.collectionEntity.getProcessObjects())){
				var processObject = arguments.collectionEntity.getProcessObjects()[1];
				formattedPageRecords[ "processObjects" ] = getFormattedObjectRecords(arguments.collectionEntity.getProcessObjects(),this.getProcessObjectProperties(processObject,arguments.collectionEntity),arguments.collectionEntity);
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
		var collectionConfigStruct = arguments.collectionEntity.getCollectionConfigStruct();
		if(structKeyExists(collectionConfigStruct,'columns')){
			var columnsArray = collectionConfigStruct.columns;
		}else{
			var columnsArray = [];
		}

		var propertyIdentifiersArray = ListToArray(arguments.propertyIdentifierList);
		for(propertyIdentifierItem in propertyIdentifiersArray){
			if(
				!arguments.enforceAuthorization || getHibachiScope().authenticateCollectionPropertyIdentifier('read', this, propertyIdentifierItem)
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

	public any function getTransientCollectionConfigStructByURLParams(required any rc){
		//propertyIdentifers
		collectionConfigStruct = {};
		collectionConfigStruct = {
			baseEntityName = '#getDao('HibachiDao').getApplicationKey()##arguments.rc.entityName#',
			baseEntityAlias = '_' & lcase(rc.entityName)
		};

		if(!isnull(arguments.rc.filterConfig)){
			collectionConfigStruct.filterGroups = deserializeJson(arguments.rc.filterConfig);
		}

		if(!isNull(arguments.rc.joinsConfig)){
			collectionConfigStruct.joins = deserializeJson(arguments.rc.joinsConfig);
		}

		if(!isNull(arguments.rc.orderByConfig)){
			collectionConfigStruct.orderBy = deserializeJson(arguments.rc.orderByConfig);
		}

		if(!isNull(arguments.rc.columnsConfig)){
			collectionConfigStruct.columns = deserializeJson(arguments.rc.columnsConfig);
		}


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

	public any function getAPIResponseForEntityName(required string entityName, required struct collectionOptions, boolean enforceAuthorization=true){

		var collectionEntity = getTransientCollectionByEntityName(arguments.entityName,arguments.collectionOptions);
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
		return getAPIResponseForCollection(collectionEntity,arguments.collectionOptions,arguments.enforceAuthorization);
	}

	public any function getAPIResponseForBasicEntityWithID(required string entityName, required string entityID, required struct collectionOptions){
		var collectionEntity = getTransientCollectionByEntityName(arguments.entityName,arguments.collectionOptions);

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

		if(!len(arguments.collectionOptions.filterGroupsConfig)){
			var filterGroupsConfig = [{
				filterGroup = []
			}];
		}else{
			var filterGroupsConfig = deserializeJson(arguments.collectionOptions.filterGroupsConfig);
		}

		arrayAppend(filterGroupsConfig[1].filterGroup,filterStruct);


		arguments.collectionOptions.filterGroupsConfig = serializeJson(filterGroupsConfig);

		var collectionResponse = getAPIResponseForCollection(collectionEntity,arguments.collectionOptions);
		var response = {};

		if(arrayLen(collectionEntity.getProcessObjects())){
			response = {};
			response['data'] = collectionResponse.pageRecords[1];
			response['processData'] = collectionResponse.processObjects[1];
		}else{
			response = collectionResponse.pageRecords[1];
		}

		return response;
	}

	public any function getAPIResponseForCollection(required any collectionEntity, required struct collectionOptions, boolean enforceAuthorization=true){
		var response = {};
		if(getHibachiScope().authenticateCollection('read', arguments.collectionEntity) || !arguments.enforceAuthorization){
			if(structkeyExists(arguments.collectionOptions,'currentPage')){
				collectionEntity.setCurrentPageDeclaration(arguments.collectionOptions.currentPage);
			}
			if(structKeyExists(arguments.collectionOptions,'pageShow')){
				collectionEntity.setPageRecordsShow(arguments.collectionOptions.pageShow);
			}
			if(structKeyExists(arguments.collectionOptions,'keywords')){
				collectionEntity.setKeywords(arguments.collectionOptions.keywords);
			}

			if(structKeyExists(arguments.collectionOptions,'propertyIdentifiersList') && len(arguments.collectionOptions.propertyIdentifiersList)){
				addColumnsToCollectionConfigStructByPropertyIdentifierList(arguments.collectionEntity,arguments.collectionOptions.propertyIdentifiersList,arguments.enforceAuthorization);
				var collectionPropertyIdentifiers = [];
			}else{
				var collectionPropertyIdentifiers = getPropertyIdentifierArray(collectionEntity.getCollectionObject());
			}
			if(structKeyExists(arguments.collectionOptions,'filterGroupsConfig') && len(arguments.collectionOptions.filterGroupsConfig)){
				collectionEntity.getCollectionConfigStruct().filterGroups = deserializeJson(arguments.collectionOptions.filterGroupsConfig);
			}

			if(structKeyExists(arguments.collectionOptions,'columnsConfig') && len(arguments.collectionOptions.columnsConfig)){
				collectionEntity.getCollectionConfigStruct().columns = deserializeJson(arguments.collectionOptions.columnsConfig);
				//look for non persistent columns
				for(var column in collectionEntity.getCollectionConfigStruct().columns){
					if(structKeyExists(column,'persistent') && column.persistent == false){
						//overide collectionPropertyIdentifiers
						collectionPropertyIdentifiers = getPropertyIdentifierArray(collectionEntity.getCollectionObject(), true);
						break;
					}
				}
			}

			if(structKeyExists(arguments.collectionOptions,'joinsConfig') && len(arguments.collectionOptions.joinsConfig)){
				collectionEntity.getCollectionConfigStruct().joins = deserializeJson(arguments.collectionOptions.joinsConfig);

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

			if(structKeyExists(arguments.collectionOptions,'orderByConfig') && len(arguments.collectionOptions.orderByConfig)){
				collectionEntity.getCollectionConfigStruct().orderBy = deserializeJson(arguments.collectionOptions.orderByConfig);
			}
			if(structKeyExists(arguments.collectionOptions,'groupBysConfig') && len(arguments.collectionOptions.groupBysConfig)){
				collectionEntity.getCollectionConfigStruct().groupBys = deserializeJson(arguments.collectionOptions.groupBysConfig);
			}

			if(structKeyExists(arguments.collectionOptions,'processContext') && len(arguments.collectionOptions.processContext)){
				collectionEntity.setProcessContext(arguments.collectionOptions.processContext);
			}
			if(structKeyExists(arguments.collectionOptions,'isDistict')){
				collectionEntity.getCollectionConfigStruct().isDistinct = arguments.collectionOptions.isDistinct;
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


			var authorizedProperties = getAuthorizedProperties(arguments.collectionEntity, collectionPropertyIdentifiers, aggregatePropertyIdentifierArray,attributePropertyIdentifierArray,enforceAuthorization);

			var collectionStruct = {};
			if(structKeyExists(arguments.collectionOptions,'allRecords') && arguments.collectionOptions.allRecords == 'true'){
				collectionStruct = getFormattedRecords(arguments.collectionEntity,authorizedProperties);
			}else{
				//paginated collection struct
				collectionStruct = getFormattedPageRecords(arguments.collectionEntity,authorizedProperties);
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
				|| !arguments.enforeAuthorization
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
