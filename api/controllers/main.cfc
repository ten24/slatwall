component output="false" accessors="true" extends="Slatwall.org.Hibachi.HibachiController"{
	
	property name="fw" type="any";
	property name="collectionService" type="any";
	property name="hibachiService" type="any";
	property name="hibachiUtilityService" type="any";
	
	this.publicMethods='';
	
	this.anyAdminMethods='';
	this.anyAdminMethods=listAppend(this.anyAdminMethods, 'getObjectOptions');
	this.anyAdminMethods=listAppend(this.anyAdminMethods, 'getExistingCollectionsByBaseEntity');
	this.anyAdminMethods=listAppend(this.anyAdminMethods, 'getFilterPropertiesByBaseEntityName');
	this.anyAdminMethods=listAppend(this.anyAdminMethods, 'getProcessObject');
	this.anyAdminMethods=listAppend(this.anyAdminMethods, 'getPropertyDisplayData');
	this.anyAdminMethods=listAppend(this.anyAdminMethods, 'getResourceBundle');
	this.anyAdminMethods=listAppend(this.anyAdminMethods, 'getPropertyDisplayOptions');
	this.anyAdminMethods=listAppend(this.anyAdminMethods, 'getValidation');
	this.anyAdminMethods=listAppend(this.anyAdminMethods, 'getValidation');
	this.anyAdminMethods=listAppend(this.anyAdminMethods, 'getEventOptionsByEntityName');
	this.anyAdminMethods=listAppend(this.anyAdminMethods, 'get');
	this.anyAdminMethods=listAppend(this.anyAdminMethods, 'post');
	this.anyAdminMethods=listAppend(this.anyAdminMethods, 'put');
	this.anyAdminMethods=listAppend(this.anyAdminMethods, 'delete');
	
	public void function init( required any fw ) {
		setFW( arguments.fw );
	}
	
	public any function before( required struct rc ) {
		arguments.rc.apiRequest = true;
		getFW().setView("public:main.blank");
		//could possibly check whether we want a different contentType other than json in the future
		param name="rc.headers.contentType" default="application/json"; 
		arguments.rc.headers.contentType = rc.headers.contentType;
		if(isnull(arguments.rc.apiResponse.content)){
			arguments.rc.apiResponse.content = {};
		}
		if(!isNull(arguments.rc.context) && arguments.rc.context == 'GET' && structKEyExists(arguments.rc, 'serializedJSONData') && isSimpleValue(arguments.rc.serializedJSONData) && isJSON(arguments.rc.serializedJSONData)) {
			StructAppend(arguments.rc,deserializeJSON(arguments.rc.serializedJSONData));
		}
	}
	/**
	 * This will return the path to an image based on the skuIDs (sent as a comma seperated list)
	 * and a 'profile name' that determines the size of that image.
	 * http://slatwall/index.cfm?slatAction=api:main.getResizedImageByProfileName&profileName=orderItem&skuIDs=8a8080834721af1a0147220714810083,4028818d4b31a783014b5653ad5d00d2,4028818d4b05b871014b102acb0700d5
	 * ...should return three paths.
	 */
	public any function getResizedImageByProfileName(required struct rc){
 			var imageHeight = 60;
 			var imageWidth  = 60;
			
			if(arguments.rc.profileName == "orderItem"){
   				imageHeight = 90;
				imageWidth  = 90;
			}else if (arguments.rc.profileName == "skuDetail"){
    				imageHeight = 150;
    				imageWidth  = 150;
 			}
			arguments.rc.apiResponse.content = {};
			arguments.rc.apiResponse.content.resizedImagePaths = [];
			var skus = [];
			
			//smart list to load up sku array
			var skuSmartList = request.slatwallScope.getService('skuService').getSkuSmartList();
			skuSmartList.addInFilter('skuID',rc.skuIDs);
			
			if( skuSmartList.getRecordsCount() > 0){
				var skus = skuSmartList.getRecords();
				
				for  (var sku in skus){
		    		ArrayAppend(arguments.rc.apiResponse.content.resizedImagePaths, sku.getResizedImagePath(width=imageWidth, height=imageHeight));         
				}
			}
 	}

	
	public any function getValidationPropertyStatus(required struct rc){
			
		var service = request.slatwallScope.getService("hibachiValidationService");
		var objectName = arguments.rc.object;
		var propertyIdentifier = arguments.rc.propertyIdentifier;
		var value = arguments.rc.value;
		var entity = getService('hibachiService').invokeMethod('new#objectName#');
		entity.invokeMethod('set#propertyIdentifier#',{1=value});
		
		
		var response["uniqueStatus"] = service.validate_unique(entity, propertyIdentifier);
		arguments.rc.apiResponse.content = response;
		
	}
	public any function getObjectOptions(required struct rc){
		var data = getCollectionService().getObjectOptions();
		arguments.rc.apiResponse.content = {data=data};
	}
	
	public any function getExistingCollectionsByBaseEntity(required struct rc){
		var currentPage = 1;
			if(structKeyExists(arguments.rc,'P:Current')){
				currentPage = arguments.rc['P:Current'];
			}
			var pageShow = 10;
			if(structKeyExists(arguments.rc,'P:Show')){
				pageShow = arguments.rc['P:Show'];
			}
			
			
			var collectionOptions = {
				allRecords=true,
				defaultColumns=false
			};
		
		var collectionEntity = getCollectionService().getTransientCollectionByEntityName('collection',collectionOptions);
		var collectionConfigStruct = collectionEntity.getCollectionConfigStruct();
		collectionConfigStruct.columns = [
			{
				propertyIdentifier="_collection.collectionName"	
			},
			{
				propertyIdentifier="_collection.collectionID"	
			},
			{
				propertyIdentifier="_collection.collectionConfig"	
			}
		];
			
		collectionConfigStruct.filterGroups = [
			{
				filterGroup = [
					{
						propertyIdentifier = "_collection.collectionObject",
						comparisonOperator = "=",
						value=rc.entityName
					}
				]
			}
		];
			
		collectionConfigStruct.orderBy = [
			{
				propertyIdentifier="_collection.collectionName",
				direction="ASC"
			}
		];
		var data = {data=collectionEntity.getRecords()};
		arguments.rc.apiResponse.content['data'] = collectionEntity.getRecords();
	}
	
	public any function getFilterPropertiesByBaseEntityName( required struct rc){
		var entityName = rereplace(rc.entityName,'_','');
		arguments.rc.apiResponse.content['data'] = getHibachiService().getPropertiesWithAttributesByEntityName(entityName);
		arguments.rc.apiResponse.content['entityName'] = rc.entityName;
	}
	
	public any function getProcessObject(required struct rc){
		//need a Context, an entityName and propertyIdentifiers
		var entityService = getHibachiService().getServiceByEntityName( entityName=arguments.rc.entityName );
		if(isNull(rc.entityID)){
			var entity = entityService.invokeMethod("new#arguments.rc.entityName#");
		}else{
			var entity = entityService.invokeMethod( "get#arguments.rc.entityName#", {1=arguments.rc.entityID, 2=true} );
		}
		
		var processObjectExists = entity.hasProcessObject( rc.context);
		
		if(processObjectExists) {
			// Setup the processObject in the RC so that we can use it for our form
			rc.processObject = entity.getProcessObject( rc.context );
		}
		var data = {};
		data['validation'] = getService('hibachiValidationService').getValidationStruct(rc.processObject);
		var propertyIdentifiers = ListToArray(rc.propertyIdentifiersList);
		for(propertyIdentifier in propertyIdentifiers){
			var data[propertyIdentifier] = {};
			var propertyPath = listToArray(propertyIdentifier,'.');
			var count = 1;
			var value = javacast('null','');
			var propertyPathCount = arraylen(propertyPath);
			for(var property in propertyPath ){
				if(count eq 1){
					value = rc.processObject.invokeMethod('get#property#');
				}else{
					value = value.invokeMethod('get#property#');
				}
				if(count eq propertyPathCount && rc.processObject.invokeMethod('get#arguments.rc.entityName#').hasProperty(property)){
					data[propertyIdentifier]['title'] = rc.processObject.invokeMethod('get#arguments.rc.entityName#').getPropertyTitle( property );
					data[propertyIdentifier]['hint'] = rc.processObject.invokeMethod('get#arguments.rc.entityName#').getPropertyHint( property );
					data[propertyIdentifier]['fieldType'] = rc.processObject.invokeMethod('get#arguments.rc.entityName#').getFieldTypeByPropertyIdentifier( property );
					
				}
				count++;
			}
			
			if(!isNull(value)){
				data[propertyIdentifier]['value'] = value;
			}
			
		}
		arguments.rc.apiResponse.content['data'] = data;
	}
	/* pass in an entity name and property identifiers list and it will spit out releveant property display data*/
	public any function getPropertyDisplayData(required struct rc){
		var propertyIdentifiersArray = ListToArray(arguments.rc.propertyIdentifiersList);
		var data = {};
		for(propertyPath in propertyIdentifiersArray){
			var lastEntityName = getService('hibachiService').getLastEntityNameInPropertyIdentifier(arguments.rc.entityName,propertyPath);
			var entity = getService('hibachiService').invokeMethod('new#lastEntityName#');
			var property = ListLast(propertyPath,'.');
			data[property]['title'] = entity.getPropertyTitle( property );
			data[property]['hint'] = entity.getPropertyHint( property );
			data[property]['fieldType'] = entity.getFieldTypeByPropertyIdentifier( property );
		}
		
		arguments.rc.apiResponse.content['data'] = data;
	}
	
	public any function getResourceBundle(required struct rc){
		var dtExpires = (Now() + 60);
 
 		var strExpires = GetHTTPTimeString( dtExpires );
 
		getPageContext().getResponse().setHeader('expires',strExpires);
		
		var resourceBundle = getService('HibachiRBService').getResourceBundle(arguments.rc.locale);
		data = {};
		
		getPageContext().getResponse().setHeader('expires', GetHTTPTimeString( now() + 60 ));
		//lcase all the resourceBundle keys so we can have consistent casing for the js
		for(var key in resourceBundle){
			data[lcase(key)] = resourceBundle[key];
		}
		
		arguments.rc.apiResponse.content['data'] = data;
	}
	
	public any function getPropertyDisplayOptions(required struct rc){
		/*
			arguments-
			entityName
			property
			argumentsCollection
		*/
		var data = [];
		if(isNull(arguments.rc.argument1)){
			data = getService('hibachiService').invokeMethod('new#arguments.rc.entityName#').invokeMethod('get#arguments.rc.property#Options');
		}else{
			data = getService('hibachiService').invokeMethod('new#arguments.rc.entityName#').invokeMethod('get#arguments.rc.property#Options',{1=arguments.rc.argument1});
		}
		data = getService('HibachiUtilityService').arrayOfStructsSort(data,'name');
		
		//if it contains an empty value make it the first item
		var emptyValue = javacast('null','');
		var dataCount = arrayLen(data);
		var emptyValueIndex = 0;
		for(var i = 1; i <= dataCount; i++){
			if(structKeyExists(data[i],'VALUE') && data[i].VALUE == ''){
				emptyValue = data[i];	
				emptyValueIndex = i; 
			}
		}
		if(!isNull(emptyValue) && emptyValueIndex > 0){
			ArrayPrepend(data,emptyValue);
			ArrayDeleteAt(data,emptyValueIndex+1);
		}
		
		arguments.rc.apiResponse.content['data'] = data;
	}
	/* pass in an entity name and recieve validation*/
	public any function getValidation(required struct rc){
		var data = {};
		data['validation'] = getService('hibachiValidationService').getValidationStructByName(arguments.rc.entityName);
		arguments.rc.apiResponse.content['data'] = data;
	}
	
	public void function getEventOptionsByEntityName(required struct rc){
		var eventNameOptions = getService('hibachiEventService').getEventNameOptionsForObject(rc.entityName);
		arguments.rc.apiResponse.content['data'] = eventNameOptions;
	}
	
	public any function get( required struct rc ) {
		/* TODO: handle filter parametes, add Select statements as list to access one-to-many relationships.
			create a base default properties function that can be overridden at the entity level via function
			handle accessing collections by id
		*/
		
		param name="arguments.rc.propertyIdentifiers" default="";
		//first check if we have an entityName value
		if(!structKeyExists(arguments.rc, "entityName")) {
			arguments.rc.apiResponse.content['account'] = arguments.rc.$.slatwall.invokeMethod("getAccountData");
			arguments.rc.apiResponse.content['cart'] = arguments.rc.$.slatwall.invokeMethod("getCartData");
				
		} else {
			//get entity service by entity name
			var currentPage = 1;
			if(structKeyExists(arguments.rc,'P:Current')){
				currentPage = arguments.rc['P:Current'];
			}
			var pageShow = 10;
			if(structKeyExists(arguments.rc,'P:Show')){
				pageShow = arguments.rc['P:Show'];
			}
			
			var keywords = "";
			if(structKeyExists(arguments.rc,'keywords')){
				keywords = arguments.rc['keywords'];
			}
			var filterGroupsConfig = ""; 
			if(structKeyExists(arguments.rc,'filterGroupsConfig')){
				filterGroupsConfig = arguments.rc['filterGroupsConfig'];
			}
			var joinsConfig = ""; 
			if(structKeyExists(arguments.rc,'joinsConfig')){
				joinsConfig = arguments.rc['joinsConfig'];
			}
			
			var propertyIdentifiersList = "";
			if(structKeyExists(arguments.rc,"propertyIdentifiersList")){
				propertyIdentifiersList = arguments.rc['propertyIdentifiersList'];
			}
			
			var columnsConfig = "";
			if(structKeyExists(arguments.rc,'columnsConfig')){
				columnsConfig = arguments.rc['columnsConfig'];
			}
			
			var isDistinct = false;
			if(structKeyExists(arguments.rc, "isDistinct")){
				isDistinct = arguments.rc['isDistinct'];
			}
			
			var allRecords = false;
			if(structKeyExists(arguments.rc,'allRecords')){
				allRecords = arguments.rc['allRecords'];
			}
			
			var defaultColumns = false;
			if(structKeyExists(arguments.rc,'defaultColumns')){
				defaultColumns = arguments.rc['defaultColumns'];
			}
			
			var processContext = '';
			if(structKeyExists(arguments.rc,'processContext')){
				processContext = arguments.rc['processContext'];
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
				allRecords=allRecords,
				defaultColumns=defaultColumns,
				processContext=processContext
			};
			
			//considering using all url variables to create a transient collectionConfig for api response
			if(!structKeyExists(arguments.rc,'entityID')){
				//should be able to add select and where filters here
				var result = getCollectionService().getAPIResponseForEntityName(	arguments.rc.entityName,
																			collectionOptions);
				
				structAppend(arguments.rc.apiResponse.content,result);
			}else{
				//figure out if we have a collection or a basic entity
				var collectionEntity = getCollectionService().getCollectionByCollectionID(arguments.rc.entityID);
				if(isNull(collectionEntity)){
					//should only be able to add selects (&propertyIdentifier=)
					var result = getCollectionService().getAPIResponseForBasicEntityWithID(arguments.rc.entityName,
																				arguments.rc.entityID,
																				collectionOptions);
					structAppend(arguments.rc.apiResponse.content,result);
				}else{
					//should be able to add select and where filters here
					var result = getCollectionService().getAPIResponseForCollection(	collectionEntity,
																				collectionOptions);
					structAppend(arguments.rc.apiResponse.content,result);
				}
			}
		}
	}
	
	public any function post( required struct rc ) {
		param name="arguments.rc.context" default="save";
		param name="arguments.rc.entityID" default="";
		param name="arguments.rc.apiResponse.content.errors" default="";
		
		if(isNull(arguments.rc.apiResponse.content.messages)){
			arguments.rc.apiResponse.content['messages'] = [];
		}
		
		if(structKEyExists(arguments.rc, 'serializedJSONData') && isSimpleValue(arguments.rc.serializedJSONData) && isJSON(arguments.rc.serializedJSONData)) {
			var structuredData = deserializeJSON(arguments.rc.serializedJSONData);
		} else {
			var structuredData = arguments.rc;
		}
		
		var entityService = getHibachiService().getServiceByEntityName( entityName=arguments.rc.entityName );
		var entity = entityService.invokeMethod("get#arguments.rc.entityName#", {1=arguments.rc.entityID, 2=true});
		
		// SAVE
		if(arguments.rc.context eq 'save') {
			entity = entityService.invokeMethod("save#arguments.rc.entityName#", {1=entity, 2=structuredData});
		// DELETE
		} else if (arguments.rc.context eq 'delete') {
			var deleteOK = entityService.invokeMethod("delete#arguments.rc.entityName#", {1=entity});
		// PROCESS
		} else {
			entity = entityService.invokeMethod("process#arguments.rc.entityName#", {1=entity, 2=arguments.rc, 3=arguments.rc.context});
		}
		
		// respond with data
		arguments.rc.apiResponse.content['data'] = {};
		
		// Add ID's of any sub-property population
		arguments.rc.apiResponse.content['data'] = addPopulatedSubPropertyIDsToData(entity=entity, data=arguments.rc.apiResponse.content['data']);
		
		// Get any new ID's created by the post
		arguments.rc.apiResponse.content['data'][ entity.getPrimaryIDPropertyName() ] = entity.getPrimaryIDValue();
		
		
		if(!isnull(arguments.rc.propertyIdentifiersList)){
			//respond with data
			arguments.rc.apiResponse.content['data'] = {};
			var propertyIdentifiersArray = ListToArray(arguments.rc.propertyIdentifiersList);
			for(propertyIdentifier in propertyIdentifiersArray){
				//check if method exists before trying to retrieve a property
				/*if(propertyIdentifier == 'pageRecords'){
					var pageRecords = entity.getValueByPropertyIdentifier(propertyIdentifier=propertyIdentifier,format=true);
					var propertyIdentifiers = [];
					if(arraylen(pageRecords)){
						propertyIdentifiers = structKeyArray(pageRecords[1]);
					}	
					pageRecords = getService('collectionService').getFormattedObjectRecords(pageRecords,propertyIdentifiers);
					arguments.rc.apiResponse.content['data'][propertyIdentifier] = pageRecords;
				}else{*/
					arguments.rc.apiResponse.content['data'][propertyIdentifier] = entity.getValueByPropertyIdentifier(propertyIdentifier=propertyIdentifier);
				//}
			}
		}
		
		if(entity.hasErrors()){
			arguments.rc.apiResponse.content.success = false;
			var context = getPageContext();
    		context.getOut().clearBuffer();
    		var response = context.getResponse();
			response.setStatus(500);
			
		}else{
			arguments.rc.apiResponse.content.success = true;
			
			// Setup success response message
			var replaceValues = {
				entityName = rbKey('entity.#arguments.rc.entityName#')
			};
			
			var successMessage = getHibachiUtilityService().replaceStringTemplate( getHibachiScope().rbKey( "api.main.#entityName#.#rc.context#_success" ), replaceValues);
			getHibachiScope().showMessage( successMessage, "success" );
			
			getHibachiScope().showMessage( replace(getHibachiScope().rbKey( "api.main.#rc.context#_success" ), "${EntityName}", rbKey('entity.#arguments.rc.entityName#'), "all" ) , "success");
		}
		
		if(!isnull(entity.getHibachiErrors()) && structCount(entity.getHibachiErrors().getErrors())){
			arguments.rc.apiResponse.content.errors = entity.getHibachiErrors().getErrors();
			getHibachiScope().showMessage( replace(getHibachiScope().rbKey( "api.main.#rc.context#_error" ), "${EntityName}", rbKey('entity.#arguments.rc.entityName#'), "all" ) , "error");
		}
	}
	
	private struct function addPopulatedSubPropertyIDsToData(required any entity, required struct data) {
		if(isNull(arguments.entity.getPopulatedSubProperties())){
			return {};
		}
		for(var key in arguments.entity.getPopulatedSubProperties()) {
			
			var propertyData = arguments.entity.getPopulatedSubProperties()[key];
			
			// Many-To-One Populated Entity
			if(!isNull(propertyData) && isObject(propertyData)) {
				var mtoEntity = propertyData;
				arguments.data[ key ][ mtoEntity.getPrimaryIDPropertyName() ] = mtoEntity.getPrimaryIDValue();
				arguments.data[ key ] = addPopulatedSubPropertyIDsToData(propertyData, arguments.data[ key ]);
			
			// One-To-Many Populated Entities
			} else if (!isNull(propertyData) && isArray(propertyData)) {
				
				arguments.data[ key ] = [];
				
				for(var otmEntity in propertyData) {
					
					var thisData = {};
					thisData = addPopulatedSubPropertyIDsToData(otmEntity, thisData);
					thisData[ otmEntity.getPrimaryIDPropertyName() ] = otmEntity.getPrimaryIDValue();
					arrayAppend(arguments.data[ key ], thisData);
				}
				
			}
			
		}
		
		return arguments.data;
	}
	
	public any function put( required struct rc ) {
		arguments.rc.entityID = "";
		post(arguments.rc);
	}
	
	public any function delete( required struct rc ) {
		arguments.rc.context = "delete";
		post(arguments.rc);
	}
	
		/*
		
		GET http://www.mysite.com/slatwall/api/product/ -> returns a collection of all products
		GET http://www.mysite.com/slatwall/?slatAction=api:main.get&entityName=product
		
		GET http://www.mysite.com/slatwall/api/product/2837401982340918274091987234/ -> returns just that one product
		
		POST http://www.mysite.com/slatwall/api/product/ -> Insert a new entity
		POST http://www.mysite.com/slatwall/api/product/12394871029834701982734/ -> Update Existing Entity
		POST http://www.mysite.com/slatwall/api/product/12394871029834701982734/?context=delete -> Delete Existing Entity
		POST http://www.mysite.com/slatwall/api/product/12394871029834701982734/?context=addSku -> Add A Sku To An Entity
		
		*/
	
}
