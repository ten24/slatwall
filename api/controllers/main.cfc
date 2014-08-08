component output="false" accessors="true" {
	
	property name="fw" type="any";
	property name="hibachiService" type="any";
	property name="collectionService" type="any";
	
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
		
	}
	
	public any function getExistingCollectionsByBaseEntity(required struct rc){
		var collectionEntity = collectionService.getTransientCollectionByEntityName('collection');
		var collectionConfigStruct = collectionEntity.getCollectionConfigStruct();
		collectionConfigStruct.columns = [
			{
				propertyIdentifier="Collection.collectionName"	
			},
			{
				propertyIdentifier="Collection.collectionConfig"	
			}
		];
			
		collectionConfigStruct.filterGroups = [
			{
				filterGroup = [
					{
						propertyIdentifier = "baseEntityName",
						comparisonOperator = "=",
						value=rc.entityName
					}
				]
			}
		];
			
		collectionConfigStruct.orderBy = [
			{
				propertyIdentifier="Collection.collectionName",
				direction="ASC"
			}
		];
		var data = {data=collectionEntity.getRecords()};
		
		structAppend(arguments.rc.apiResponse.content,data);
	}
	
	public any function getFilterPropertiesByBaseEntityName( required struct rc){
		var filterProperties = {
									data = hibachiService.getFilterPropertiesByEntityName(rc.entityName),
									entityName=rc.entityName
								};
		structAppend(arguments.rc.apiResponse.content, filterProperties);
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
			if(structKeyExists(rc,'P:Current')){
				var currentPage = rc['P:Current'];
			}
			var pageShow = 10;
			if(structKeyExists(rc,'P:Show')){
				var pageShow = rc['P:Show'];
			}
			
			//considering using all url variables to create a transient collectionConfig for api response
			var transientCollectionConfigStruct = collectionService.getTransientCollectionConfigStructByURLParams(arguments.rc);			
			
			if(!structKeyExists(arguments.rc,'entityID')){
				//should be able to add select and where filters here
				var result = collectionService.getAPIResponseForEntityName(	arguments.rc.entityName,
																			arguments.rc.propertyIdentifiers,
																			currentPage,
																			pageShow);
				structAppend(arguments.rc.apiResponse.content,result);
			}else{
				//figure out if we have a collection or a basic entity
				var collectionEntity = collectionService.getCollectionByCollectionID(arguments.rc.entityID);
				if(isNull(collectionEntity)){
					//should only be able to add selects (&propertyIdentifier=)
					var result = collectionService.getAPIResponseForBasicEntityWithID(arguments.rc.entityName,
																				arguments.rc.entityID,
																				arguments.rc.propertyIdentifiers,
																				currentPage,
																				pageShow);
					structAppend(arguments.rc.apiResponse.content,result);
				}else{
					//should be able to add select and where filters here
					var result = collectionService.getAPIResponseForCollection(	collectionEntity,
																				arguments.rc.propertyIdentifiers,
																				currentPage,
																				pageShow);
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
			arguments.rc.apiResponse.content.messages = [];
		}
		
		var entityService = getHibachiService().getServiceByEntityName( entityName=arguments.rc.entityName );
		var entity = entityService.invokeMethod("get#arguments.rc.entityName#", {1=arguments.rc.entityID, 2=true});
		// SAVE
		if(arguments.rc.context eq 'save') {
			entity = entityService.invokeMethod("save#arguments.rc.entityName#", {1=entity, 2=arguments.rc});
		// DELETE
		} else if (arguments.rc.context eq 'delete') {
			var deleteOK = entityService.invokeMethod("delete#arguments.rc.entityName#", {1=entity});
		
		// PROCESS
		} else {
			entity = entityService.invokeMethod("process#arguments.rc.entityName#", {1=entity, 2=arguments.rc, 3=arguments.rc.context});
		}

		if(!isnull(arguments.rc.propertyIdentifiers)){
			//respond with data
			arguments.rc.apiResponse.content.data = {};
			for(propertyIdentifier in arguments.rc.propertyIdentifiers){
				//check if method exists before trying to retrieve a property
				if(isDefined('entity.get#propertyIdentifier#')){
					arguments.rc.apiResponse.content.data[propertyIdentifier] = entity.invokeMethod("get#propertyIdentifier#");
				}
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
			var successMessageData = {message = "#rc.context# #arguments.rc.entityName# successful", type="success"};
			arrayAppend(arguments.rc.apiResponse.content.messages,successMessageData);
		}
		
		if(!isnull(entity.getHibachiMessages()) && structCount(entity.getHibachiMessages().getMessages())){
			var messages = entity.getHibachiMessages().getMessages();
			for(message in messages){
				var messageData ={
					message = messages[message],
					messageType = ""
				};
				arrayAppend(arguments.rc.apiResponse.content.messages,messageData);	
			}
		}
		
		if(!isnull(entity.getHibachiErrors()) && structCount(entity.getHibachiErrors().getErrors())){
			arguments.rc.apiResponse.content.errors = entity.getHibachiErrors().getErrors();
		}
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
		
		GET http://www.mysite.com/slatwall/api/product/ -> retuns collection of all products
		GET http://www.mysite.com/slatwall/?slatAction=api:main.get&entityName=product
		
		GET http://www.mysite.com/slatwall/api/product/2837401982340918274091987234/ -> retuns just that one product
		
		POST http://www.mysite.com/slatwall/api/product/ -> Insert a new entity
		POST http://www.mysite.com/slatwall/api/product/12394871029834701982734/ -> Update Existing Entity
		POST http://www.mysite.com/slatwall/api/product/12394871029834701982734/?context=delete -> Delete Existing Entity
		POST http://www.mysite.com/slatwall/api/product/12394871029834701982734/?context=addSku -> Add A Sku To An Entity
		
		*/
	
}
