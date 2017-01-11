component output="false" accessors="true" extends="HibachiController" {

    property name="fw" type="any";
    property name="hibachiCollectionService" type="any";
    property name="hibachiService" type="any";
    property name="hibachiUtilityService" type="any";

    this.restController = true;

    this.anyAdminMethods='';
    this.anyAdminMethods=listAppend(this.anyAdminMethods, 'getObjectOptions');
    this.anyAdminMethods=listAppend(this.anyAdminMethods, 'getExistingCollectionsByBaseEntity');
    this.anyAdminMethods=listAppend(this.anyAdminMethods, 'getFilterPropertiesByBaseEntityName');
    this.anyAdminMethods=listAppend(this.anyAdminMethods, 'getProcessObject');
	this.anyAdminMethods=listAppend(this.anyAdminMethods, 'getProcessMethodOptionsByEntityName');
    this.anyAdminMethods=listAppend(this.anyAdminMethods, 'getPropertyDisplayData');
    this.anyAdminMethods=listAppend(this.anyAdminMethods, 'getPropertyDisplayOptions');
    this.anyAdminMethods=listAppend(this.anyAdminMethods, 'getValidation');
    this.anyAdminMethods=listAppend(this.anyAdminMethods, 'getValidation');
    this.anyAdminMethods=listAppend(this.anyAdminMethods, 'getEventOptionsByEntityName');
    this.anyAdminMethods=listAppend(this.anyAdminMethods, 'put');
    this.anyAdminMethods=listAppend(this.anyAdminMethods, 'delete');
    this.anyAdminMethods=listAppend(this.anyAdminMethods, 'log');

    this.publicMethods='';
    this.publicMethods=listAppend(this.publicMethods, 'getResizedImageByProfileName');
    this.publicMethods=listAppend(this.publicMethods, 'getDetailTabs');
    this.publicMethods=listAppend(this.publicMethods, 'noaccess');
    this.publicMethods=listAppend(this.publicMethods, 'login');
    this.publicMethods=listAppend(this.publicMethods, 'getResourceBundle');
    this.publicMethods=listAppend(this.publicMethods, 'getCurrencies');
    this.publicMethods=listAppend(this.publicMethods, 'getModel');
    this.publicMethods=listAppend(this.publicMethods, 'getAttributeModel');
    this.publicMethods=listAppend(this.publicMethods, 'getConfig');
    this.publicMethods=listAppend(this.publicMethods, 'getInstantiationKey');

    this.secureMethods='';
    this.secureMethods=listAppend(this.secureMethods, 'getFormResponses');
    this.secureMethods=listAppend(this.secureMethods, 'exportFormResponses');
    this.secureMethods=listAppend(this.secureMethods, 'get');
    this.secureMethods=listAppend(this.secureMethods, 'post');


    public void function init( required any fw ) {
        setFW( arguments.fw );
    }

    public any function before( required struct rc ) {

        arguments.rc.apiRequest = true;

        getFW().setView("public:main.blank");
        arguments.rc.headers["Content-Type"] = "application/json";

        if(isnull(arguments.rc.apiResponse.content)){
            arguments.rc.apiResponse.content = {};
        }
		
		if(
			structKeyExists(GetHttpRequestData(),'headers')
			&& structKeyExists(GetHttpRequestData().headers,'Content-Type')
			&& FindNoCase('application/json',GetHttpRequestData().headers['Content-Type'])
		){
			structAppend(arguments.rc,deserializeJson(ToString(GetHttpRequestData().content)));
		}
        if(!isNull(arguments.rc.context) && arguments.rc.context == 'GET'
            && structKEyExists(arguments.rc, 'serializedJSONData')
            && isSimpleValue(arguments.rc.serializedJSONData)
            && isJSON(arguments.rc.serializedJSONData)
        ) {
            StructAppend(arguments.rc,deserializeJSON(arguments.rc.serializedJSONData));
        }

        //could possibly check whether we want a different contentType other than json in the future example:xml

    }

    public void function getConfig(required struct rc){
    	var responseValue = {};
    	if(!getService('HibachiCacheService').hasCachedValue('HibachiControllerRest_getConfig')){
    		var config = {};
    		config = getService('HibachiSessionService').getConfig();
    		config[ 'modelConfig' ] = getModel(arguments.rc);
    		responseValue['data'] = config;
    		responseValue = serializeJson(responseValue);
    		getService('HibachiCacheService').setCachedValue('HibachiControllerRest_getConfig',responseValue);
    	}else{
    		responseValue = getService('HibachiCacheService').getCachedValue('HibachiControllerRest_getConfig');
    	}
    	var context = getPageContext();
		context.getOut().clearBuffer();
		var response = context.getResponse();
    	
    	response.setHeader('Content-Type',"application/json");
    	
    	writeOutput(responseValue);abort;
    }

    public void function getInstantiationKey(required struct rc){
    	var data = {};
    	data['instantiationKey'] = '#getApplicationValue('instantiationKey')#';
    	var modelCacheKey = "attributeService_getAttributeModel_CacheKey";
    	if(getService('HibachiCacheService').hasCachedValue(modelCacheKey)){
    		data['attributeCacheKey'] = getService('HibachiCacheService').getCachedValue(modelCacheKey);
    	}else{
    		var attributeMetaData = getService('attributeService').getAttributeModel();
    		data['attributeCacheKey'] = hash(serializeJson(attributeMetaData),'MD5');
    		getService('HibachiCacheService').setCachedValue(modelCacheKey,data['attributeCacheKey']);
    	}
    	
    	arguments.rc.apiResponse.content['data']=data;
    }

    public void function getCurrencies(required struct rc){
        var currenciesCollection = getHibachiScope().getService('hibachiCollectionService').getCurrencyCollectionList();
        currenciesCollection.setDisplayProperties('currencyCode,currencySymbol');
        var currencyStruct = {};
        for(var currency in currenciesCollection.getRecords()){
            currencyStruct[currency['currencyCode']] = currency['currencySymbol'];
        }

        arguments.rc.apiResponse.content['data'] = currencyStruct;
    }

    public void function login(required struct rc){

        if(!getHibachiScope().getLoggedInFlag()){
            //if account doesn't exist than one is create
            var account = getService('AccountService').processAccount(getHibachiScope().getAccount(), rc, "login");
            var authorizeProcessObject = rc.fw.getHibachiScope().getAccount().getProcessObject("login").populate(arguments.rc);
            arguments.rc.apiResponse.content['messages'] = [];
            var updateProcessObject = rc.fw.getHibachiScope().getAccount().getProcessObject("updatePassword");
            if(account.hasErrors()){
                for(var processObjectKey in account.getErrors().processObjects){
                    var processObject = account.getProcessObject(processObjectKey);
                    arguments.rc.apiResponse.content['errors'] = processObject.getErrors();
                    for(var errorKey in processObject.getErrors()){
                        var messageStruct = {};
                        messageStruct['message'] = processObject.getErrors()[errorKey];
                        arrayAppend(arguments.rc.apiResponse.content['messages'],messageStruct);
                    }
                }
                var pc = getpagecontext().getresponse();
                pc.getresponse().setstatus(getHibachiScope().getService("hibachiAuthenticationService").getInvalidCredentialsStatusCode());
                return;
            }
        }

        if(getHibachiScope().getLoggedinFlag()){
            arguments.rc.apiResponse.content['token'] = getService('HibachiJWTService').createToken();
        }

    }

    public void function noaccess(required struct rc){
        var message = {};
        message['message'] =arguments.rc.pagetitle;
        message['messageType']="error";
        arrayAppend(arguments.rc['messages'],message);
        arguments.rc.apiResponse.content.success = false;
        var context = getPageContext();
        context.getOut().clearBuffer();
        var response = context.getResponse();
        response.setStatus(403);
    }

    public any function getDetailTabs(required struct rc){
        var detailTabs = [];
        var entityFolderName = getService('HibachiService').getProperlyCasedShortEntityName(arguments.rc.entityName);
        var tabsDirectory = expandPath( '/#getApplicationValue('applicationKey')#' ) & '/org/Hibachi/client/src/entity/components/#entityFolderName#/';
	    if(FileExists(tabsDirectory & 'tabsConfig.json')){
		    detailTabs =  DeserializeJSON(FileRead(tabsDirectory & 'tabsConfig.json'));
	    }else{
		    var tabFilesList = directorylist(tabsDirectory,false,'query','*.html');
		    for(var tabFile in tabFilesList){
			    var tab = {
				    "tabName" = tabFile.name,
				    "openTab" = (tabFile.name == 'basic.html')
			    };
			    arrayAppend(detailTabs,tab);
		    }
	    }
        arguments.rc.apiResponse.content['data'] = detailTabs;
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
            arguments.rc.apiResponse.content['resizedImagePaths'] = [];
            var skus = [];

            //smart list to load up sku array
            var skuSmartList = getHibachiScope().getService('skuService').getSkuSmartList();
            skuSmartList.addInFilter('skuID',rc.skuIDs);

            if( skuSmartList.getRecordsCount() > 0){
                var skus = skuSmartList.getRecords();

                for  (var sku in skus){
                    ArrayAppend(arguments.rc.apiResponse.content['resizedImagePaths'], sku.getResizedImagePath(width=imageWidth, height=imageHeight));
                }
            }
    }


    public any function getValidationPropertyStatus(required struct rc){

        var service = getHibachiScope().getService("hibachiValidationService");
        var objectName = arguments.rc.object;
        var propertyIdentifier = arguments.rc.propertyIdentifier;
        var value = arguments.rc.value;
        var entity = getService('hibachiService').invokeMethod('new#objectName#');
        entity.invokeMethod('set#propertyIdentifier#',{1=value});


        var response["uniqueStatus"] = service.validate_unique(entity, propertyIdentifier);
        arguments.rc.apiResponse.content = response;

    }
    public any function getObjectOptions(required struct rc){
        var data = getService('hibachiCollectionService').getObjectOptions();
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

        var collectionEntity = getService('hibachiCollectionService').getTransientCollectionByEntityName('collection',collectionOptions);
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
        //var data = {data=collectionEntity.getRecords()};
        arguments.rc.apiResponse.content['data'] = collectionEntity.getRecords(formatRecords=false);
    }

    public any function getFilterPropertiesByBaseEntityName( required struct rc){
        var entityName = rereplace(rc.entityName,'_','');
        var includeNonPersistent = false;

		if(structKeyExists(arguments.rc,'includeNonPersistent') && IsBoolean(arguments.rc.includeNonPersistent)){
			includeNonPersistent = arguments.rc.includeNonPersistent;
		}
		arguments.rc.apiResponse.content['data'] = [];

        var filterProperties = getHibachiService().getPropertiesWithAttributesByEntityName(entityName, includeNonPersistent);

        for(var filterProperty in filterProperties){
            if(
                getHibachiScope().authenticateEntityProperty('read', entityName, filterProperty.name)
                || (structKeyExists(filterProperty,'fieldtype') && filterProperty.fieldtype == 'id')
            ){
                arrayAppend(arguments.rc.apiResponse.content['data'],filterProperty);
            }
        }
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
        var resourceBundle = getService('HibachiRBService').getResourceBundle(arguments.rc.locale);
        var data = {};
        //cache RB for 1 day or until a reload
        //lcase all the resourceBundle keys so we can have consistent casing for the js
        for(var key in resourceBundle){
            data[lcase(key)] = resourceBundle[key];
        }
        arguments.rc.apiResponse.content['data'] = data;
        arguments.rc.headers['Expires'] = 900;
    }

    public any function getPropertyDisplayOptions(required struct rc){
        /*
            arguments-
            entityName
            property
            argumentsCollection
        */
        var data = [];
        var entity = getService('hibachiService').invokeMethod('new#arguments.rc.entityName#');
        
        if(entity.hasAttributeCode(arguments.rc.property)){
        	var attribute = getService('attributeService').getAttributeByAttributeCode(arguments.rc.property);
        	
        	data = attribute.getAttributeOptionsOptions();
        }else{
        	if(isNull(arguments.rc.argument1)){
	            data = entity.invokeMethod('get#arguments.rc.property#Options');
	        }else{
	            data = entity.invokeMethod('get#arguments.rc.property#Options',{1=arguments.rc.argument1});
	        }
        }
        

        //if it contains an empty value make it the first item
        var emptyValue = javacast('null','');
        var dataCount = arrayLen(data);
        var emptyValueIndex = 0;
        for(var i = 1; i <= dataCount; i++){
            if(structKeyExists(data[i],'VALUE') && data[i]['value'] == ''){
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
        var eventNameOptions = getService('hibachiEventService').getEventNameOptionsForObject(arguments.rc.entityName);
        arguments.rc.apiResponse.content['data'] = eventNameOptions;
    }

	public void function getProcessMethodOptionsByEntityName(required struct rc){
		var processOptions = [];
		var allProcessMethods = getHibachiService().getEntitiesProcessContexts();
		if(structKeyExists(allProcessMethods, arguments.rc.entityName)){
			for(var processMethod in allProcessMethods[arguments.rc.entityName]){
				arrayAppend(processOptions, {
					'name' = rbKey('entity.#arguments.rc.entityName#.process.#processMethod#'),
					'value' = 'process#arguments.rc.entityName#_#processMethod#'
				});
			}
		}
		arguments.rc.apiResponse.content['data'] = processOptions;
	}

    private void function formatEntity(required any entity, required any model){

        model.entities[entity.getClassName()] = entity.getPropertiesStruct();
        model.entities[entity.getClassName()]['className'] = entity.getClassName();

        var metaData = getMetaData(entity);
        var isProcessObject = Int(Find('_',entity.getClassName()) gt 0);

        if (structKeyExists(metaData,'hb_parentPropertyName')){
            model.entities[entity.getClassName()]['hb_parentPropertyName'] = metaData.hb_parentPropertyName;
        }
        if(structKeyExists(metaData,'hb_childPropertyName')){
            model.entities[entity.getClassName()]['hb_childPropertyName'] = metaData.hb_childPropertyName;
        }

        model.validations[entity.getClassName()] = getHibachiScope().getService('hibachiValidationService').getValidationStruct(entity);
        model.defaultValues[entity.getClassName()] = {};


        for(var property in entity.getProperties()){
            //<!--- Make sure that this property is a persistent one --->
            if (!structKeyExists(property, "persistent") && ( !structKeyExists(property,"fieldtype") || listFindNoCase("column,id", property.fieldtype) )){
                if(!isProcessObject){
                    try{
                        var defaultValue = entity.invokeMethod('get#property.name#');
                    }catch(any e){
                        defaultValue = javacast('null','');
                    }
                    if (isNull(local.defaultValue)){
                        model.defaultValues[entity.getClassName()][property.name] = javacast('null','');
                    }else if (structKeyExists(local.property, "ormType") and listFindNoCase('boolean,int,integer,float,big_int,big_decimal', local.property.ormType)){
                        model.defaultValues[entity.getClassName()][property.name] = defaultValue;
                    }else if (structKeyExists(local.property, "ormType") and listFindNoCase('string', local.property.ormType)){
                        if(structKeyExists(local.property, "hb_formFieldType") and local.property.hb_formFieldType eq "json"){
                            model.defaultValues[entity.getClassName()][property.name] = deserializeJson(defaultValue);
                        }else{
                            model.defaultValues[entity.getClassName()][property.name] = defaultValue;
                        }
                    }else if(structKeyExists(local.property, "ormType") and local.property.ormType eq 'timestamp'){
                        model.defaultValues[entity.getClassName()][property.name] = defaultValue;
                    }else{
                        model.defaultValues[entity.getClassName()][property.name] = defaultValue;
                    }
                }else{
                    try{
                        var defaultValue = entity.invokeMethod('get#property.name#');
                    }catch(any e){
                        defaultValue = javacast('null','');
                    }
                    if (!isNull(defaultValue)){
                        if(isObject(defaultValue)){
                            model.defaultValues[entity.getClassName()][property.name] = '';
                        }else{
                            if(isStruct(defaultValue)){
                                model.defaultValues[entity.getClassName()][property.name] = defaultValue;
                            }else{
                                model.defaultValues[entity.getClassName()][property.name] = '#defaultValue#';
                            }
                        }

                    }else{
                        //model.defaultValues[entity.getClassName()][property.name] = '#defaultValue#';
                    }
                }
            }
        }
    }
    
    public void function getAttributeModel(required struct rc){
    	arguments.rc.apiResponse.content['data'] = getService('attributeService').getAttributeModel();
    }

    private any function getModel(required struct rc){
        var model = {};
        if(!getService('HibachiCacheService').hasCachedValue('objectModel')){
            var entities = [];
            var processContextsStruct = rc.$[#getDao('hibachiDao').getApplicationKey()#].getService('hibachiService').getEntitiesProcessContexts();
            var entitiesListArray = listToArray(structKeyList(rc.$[#getDao('hibachiDao').getApplicationKey()#].getService('hibachiService').getEntitiesMetaData()));


            model['entities'] = {};
            model['validations'] = {};
            model['defaultValues'] = {};

            for(var entityName in entitiesListArray) {
                var entity = rc.$[#getDao('hibachiDao').getApplicationKey()#].getService('hibachiService').getEntityObject(entityName);

                formatEntity(entity,model);
                //add process objects to the entites array
                if(structKeyExists(processContextsStruct,entityName)){
                    var processContexts = processContextsStruct[entityName];
                    for(var processContext in processContexts){
                        if(entity.hasProcessObject(processContext)){

                            formatEntity(entity.getProcessObject(processContext),model);
                        }

                    }
                }
            }

            ORMClearSession();
            getService('HibachiCacheService').setCachedValue('objectModel',model);
        }else{
        	model = getService('HibachiCacheService').getCachedValue('objectModel');
        }
        
        return model;
    }

    public void function exportFormResponses(required struct rc){
		var formQuestions = getDAO('FormDAO').getFormQuestionColumnHeaderData(arguments.rc.formID);
		var untransformedData = getDAO('FormDAO').getFormQuestionAndFormResponsesRawData(arguments.rc.formID);
		var exportList = "";
		if(arrayLen(formQuestions) && arrayLen(untransformedData)){
			for(var question in formQuestions){
				exportList = listAppend(exportList, question["question"]);
			}
			var transformedData = getService("FormService").transformFormResponseData(untransformedData);

			for(var row in transformedData){
				for(var question in formQuestions){
					if(!isNull(question["questionID"]) && structkeyexists(row, question["questionID"])){
						exportList = listAppend(exportList, row[question["questionID"]]);
					} else {
						exportList = listAppend(exportList, " ");
					}
				}
			}

			var fileNameWithExt = "formResponse.csv";

			if(structKeyExists(application,"tempDir")){
				var filePath = application.tempDir & "/" & fileNameWithExt;
			} else {
				var filePath = GetTempDirectory() & fileNameWithExt;
			}

			fileWrite(filePath,exportList);

			getService("HibachiUtilityService").downloadFile(fileNameWithExt,filePath,"application/csv",true);
		}
    }



    public void function getFormResponses(required struct rc){

		var formToFetch = getService('FormService').getForm(arguments.rc.formID);
		var formQuestions = getDAO('FormDAO').getFormQuestionColumnHeaderData(arguments.rc.formID);
		arrayAppend(formQuestions, {"question"=getHibachiScope().getRBKey("entity.FormResponse.createdDateTime"), "questionID"="createdDateTime"});
		var numberOfQuestions = arrayLen(formQuestions);

    	var untransformedData = getDAO('FormDAO').getFormQuestionAndFormResponsesRawData(arguments.rc.formID, numberOfQuestions, arguments.rc.currentPage, arguments.rc.pageShow);

		if(numberOfQuestions && arrayLen(untransformedData)){
			arguments.rc.apiResponse.content['columnRecords'] = formQuestions;
			arguments.rc.apiResponse.content['pageRecords'] = getService("FormService").transformFormResponseData(untransformedData);

			//pagination properties
			arguments.rc.apiResponse.content['recordsCount'] = formToFetch.getFormResponsesCount();
			arguments.rc.apiResponse.content['pageRecordsStart'] = ((arguments.rc.currentPage-1)*arguments.rc.pageShow) + 1;
			var pageRecordsEnd = arguments.rc.apiResponse.content['pageRecordsStart'] + arguments.rc.pageShow - 1;
			if(pageRecordsEnd > arguments.rc.apiResponse.content['recordsCount']) {
				pageRecordsEnd = arguments.rc.apiResponse.content['recordsCount'];
			}
			arguments.rc.apiResponse.content['pageRecordsEnd'] = pageRecordsEnd;
			arguments.rc.apiResponse.content['totalPages'] = ceiling(formToFetch.getFormResponsesCount() / arguments.rc.pageShow);
		} else {
			arguments.rc.apiResponse.content['columnRecords'] = [];
			arguments.rc.apiResponse.content['pageRecords'] = [];
		}
    }

    public any function get( required struct rc ) {
        /* TODO: handle filter parametes, add Select statements as list to access one-to-many relationships.
            create a base default properties function that can be overridden at the entity level via function
            handle accessing collections by id
        */
        param name="arguments.rc.propertyIdentifiers" default="";
        //first check if we have an entityName value
        if(!structKeyExists(arguments.rc, "entityName")) {
            arguments.rc.apiResponse.content['account'] = getHibachiScope().invokeMethod("getAccountData");
            arguments.rc.apiResponse.content['cart'] = getHibachiScope().invokeMethod("getCartData");
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

            var orderByConfig = "";
            if(structKeyExists(arguments.rc,'orderByConfig')){
                orderByConfig = arguments.rc['orderByConfig'];
            }

            var groupBysConfig = "";
            if(structKeyExists(arguments.rc,'groupBysConfig')){
                groupBysConfig = arguments.rc['groupBysConfig'];
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
                orderByConfig=orderByConfig,
                groupBysConfig=groupBysConfig,
                allRecords=allRecords,
                defaultColumns=defaultColumns,
                processContext=processContext
            };

            //considering using all url variables to create a transient collectionConfig for api response
            if(!structKeyExists(arguments.rc,'entityID')){
                //should be able to add select and where filters here
                var result = getService('hibachiCollectionService').getAPIResponseForEntityName(    arguments.rc.entityName,
                                                                            collectionOptions);

                structAppend(arguments.rc.apiResponse.content,result);
            }else{

                var collectionEntity = getService('hibachiCollectionService').getCollectionByCollectionID(arguments.rc.entityID);
                //figure out if we have a collection or a basic entity
                if(isNull(collectionEntity)){
                    //should only be able to add selects (&propertyIdentifier=)
                    var result = getService('hibachiCollectionService').getAPIResponseForBasicEntityWithID(arguments.rc.entityName,
                                                                                arguments.rc.entityID,
                                                                                collectionOptions);
                    structAppend(arguments.rc.apiResponse.content,result);
                }else{
                    //should be able to add select and where filters here
                    var result = getService('hibachiCollectionService').getAPIResponseForCollection(    collectionEntity,
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
        if(lcase(arguments.rc.context)=='get'){
        	get(arguments.rc);
        }else{
        	if(isNull(arguments.rc.apiResponse.content.messages)){
	            arguments.rc.apiResponse.content['messages'] = [];
	        }

	        if(structKEyExists(arguments.rc, 'serializedJSONData') && isSimpleValue(arguments.rc.serializedJSONData) && isJSON(arguments.rc.serializedJSONData)) {
	            var structuredData = deserializeJSON(arguments.rc.serializedJSONData);
	        } else {
	            var structuredData = arguments.rc;
	        }

	        if(structKeyExists(arguments.rc,'swProcess')){
	            arguments.rc.context = arguments.rc.swProcess;
	            structDelete(arguments.rc,'swProcess');
	        }

	        //if entityname is not specified then we are using the public api and it should act upon the current users session
	        if(!structKeyExists(arguments.rc, "entityName")) {
	            arguments.rc.entityName = 'Session';
	            var entityService = getService('HibachiSessionService');
	            var entity = getHibachiScope().getSession();
	        }else{
	            var entityService = getHibachiService().getServiceByEntityName( entityName=arguments.rc.entityName );
	            var entity = entityService.invokeMethod("get#arguments.rc.entityName#", {1=arguments.rc.entityID, 2=true});
	        }

	        // SAVE
	        if(arguments.rc.context eq 'save') {
	            entity = entityService.invokeMethod("save#arguments.rc.entityName#", {1=entity, 2=structuredData});
	        // DELETE
	        } else if (arguments.rc.context eq 'delete') {
	            var deleteOK = entityService.invokeMethod("delete#arguments.rc.entityName#", {1=entity});
	        // PROCESS
	        } else {
	            entity = entityService.invokeMethod("process#arguments.rc.entityName#", {1=entity, 2=structuredData, 3=arguments.rc.context});
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
	                    pageRecords = getService('hibachiCollectionService').getFormattedObjectRecords(pageRecords,propertyIdentifiers);
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
	                entityName = rbKey('entity.#entity.getClassName()#')
	            };

	            var successMessage = getHibachiUtilityService().replaceStringTemplate( getHibachiScope().rbKey( "api.main.#entity.getClassName()#.#rc.context#_success" ), replaceValues);
	            getHibachiScope().showMessage( successMessage, "success" );

	            getHibachiScope().showMessage( replace(getHibachiScope().rbKey( "api.main.#rc.context#_success" ), "${EntityName}", replaceValues.entityName, "all" ) , "success");
	        }

	        if(!isnull(entity.getHibachiErrors()) && structCount(entity.getHibachiErrors().getErrors())){
	            arguments.rc.apiResponse.content.errors = entity.getHibachiErrors().getErrors();
	            getHibachiScope().showMessage( replace(getHibachiScope().rbKey( "api.main.#rc.context#_error" ), "${EntityName}", entity.getClassName(), "all" ) , "error");
	        }
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

	public any function log(required struct rc) {

		if(structKeyExists(arguments.rc,'exception') && !isNull(arguments.rc.exception)){

			var message = "Exception: #arguments.rc.exception#";

			if(structKeyExists(arguments.rc,'cause') && !isNull(arguments.rc.cause)){
				message &=  " Cause: #arguments.rc.cause#";
			}
			//throw the error so it will follow expected lifecycle
			throw(type="ClientError", message="#message#");
		}
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

