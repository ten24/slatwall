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
	}
	
	private any function getAPIResponseByEntityName(required string entityName){
		var entityService = getHibachiService().getServiceByEntityName( entityName=arguments.entityName );
		collectionEntity = collectionService.getTransientCollectionByEntityName(arguments.entityName);
		
		//by now we have a baseEntityName and a collectionEntity so now we need to check if we are filtering the collection
		var entityProperties = getHibachiService().getDefaultPropertiesByEntityName( entityName );
		var propertyIdentifiersList = collectionService.getPropertyIdentifiersList(entityProperties);
		// Turn the property identifiers into an array
		var propertyIdentifiers = listToArray( propertyIdentifiersList );
		return collectionService.getFormattedPageRecords(collectionEntity,propertyIdentifiers);
	}
	
	private any function getAPIResponseForBasicEntityByNameAndID(required string entityName, required string entityID){
		//var entityService = getHibachiService().getServiceByEntityName( entityName=arguments.entityName );
		var collectionEntity = collectionService.getTransientCollectionByEntityName(arguments.entityName);
		var collectionConfigStruct = collectionEntity.getCollectionConfigStruct();

		var entityProperties = getHibachiService().getDefaultPropertiesByEntityName( arguments.entityName );
		var propertyIdentifiersList = collectionService.getPropertyIdentifiersList(entityProperties);
		// Turn the property identifiers into an array
		var propertyIdentifiers = listToArray( propertyIdentifiersList );

		//set up search by id				
		if(!structKeyExists(collectionConfigStruct,'filterGroups')){
			collectionConfigStruct.filterGroups = [];
		}
		var capitalCaseEntityName = collectionService.capitalCase(arguments.entityName);
		var propertyIdentifier = capitalCaseEntityName & '.#arguments.entityName#ID';
		var filterStruct = collectionService.createFilterStruct(propertyIdentifier,'=',arguments.entityID);
		
		var filterGroupStruct.filterGroup = [];
		arrayappend(filterGroupStruct.filterGroup,filterStruct);
		
		arrayAppend(collectionConfigStruct.filterGroups,filterGroupStruct);
		
		var paginatedCollectionOfEntities = collectionEntity.getPageRecords();
		var respone = {};
		for(var p=1; p<=arrayLen(propertyIdentifiers); p++) {
			response[ propertyIdentifiers[p] ] = paginatedCollectionOfEntities[1].getValueByPropertyIdentifier( propertyIdentifier=propertyIdentifiers[p],format=true );
		}
		return response;
	}
	
	private any function getAPIResponseForCollectionEntityByID(required any collectionEntity){
		
		var entityProperties = getHibachiService().getDefaultPropertiesByEntityName( 'collection' );
		var propertyIdentifiersList = collectionService.getPropertyIdentifiersList(entityProperties);
		// Turn the property identifiers into an array
		var propertyIdentifiers = listToArray( propertyIdentifiersList );
		var response = {};
		for(var p=1; p<=arrayLen(propertyIdentifiers); p++) {
			response[ propertyIdentifiers[p] ] = arguments.collectionEntity.getValueByPropertyIdentifier( propertyIdentifier=propertyIdentifiers[p],format=true );
		}
		
		//get default property identifiers for the records that the collection refers to
		var collectionEntityProperties = getHibachiService().getDefaultPropertiesByEntityName( collectionEntity.getBaseEntityName() );
		var collectionPropertyIdentifiersList = collectionService.getPropertyIdentifiersList(collectionEntityProperties);
		// Turn the property identifiers into an array
		var collectionPropertyIdentifiers = listToArray( collectionPropertyIdentifiersList );
		
		var paginatedCollectionOfEntities = arguments.collectionEntity.getPageRecords();
		var collectionPaginationStruct = collectionService.getFormattedPageRecords(arguments.collectionEntity,collectionPropertyIdentifiers);
		
		structAppend(response,collectionPaginationStruct);
		return response;
	}
	
	public any function get( required struct rc ) {
		/* TODO: handle filter parametes, add Select statements as list to access one-to-many relationships.
			create a base default properties function that can be overridden at the entity level via function
			handle accessing collections by id
		*/
		//first check if we have an entityName value
		if(!structKeyExists(arguments.rc, "entityName")) {
			arguments.rc.apiResponse['account'] = arguments.rc.$.slatwall.invokeMethod("getAccountData");
			arguments.rc.apiResponse['cart'] = arguments.rc.$.slatwall.invokeMethod("getCartData");
				
		} else {
			//get entity service by entity name
			
			if(!structKeyExists(arguments.rc,'entityID')){
				
				arguments.rc.apiResponse = getAPIResponseByEntityName(arguments.rc.entityName);
			}else{
				//figure out if we have a collection or a basic entity
				var collectionEntity = collectionService.getCollectionByCollectionID(arguments.rc.entityID);
				if(isNull(collectionEntity)){
					arguments.rc.apiResponse = getAPIResponseForBasicEntityByNameAndID(arguments.rc.entityName,arguments.rc.entityID);
				}else{
					arguments.rc.apiResponse = getAPIResponseForCollectionEntityByID(collectionEntity);
				}
			}
		}
	}
	
	public any function post( required struct rc ) {
		param name="arguments.rc.context" default="save";
		param name="arguments.rc.entityID" default="";
		
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
		
		arguments.rc.apiResponse = {};
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