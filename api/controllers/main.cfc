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
			
			//check if a collection exists by using entityName as collectionCode
			var collectionEntity = collectionService.getCollectionByCollectionCode(entityName);
			var baseEntityName = '';
			var isCollection = false;
			if(!isNull(collectionEntity)){
				//get the base entity that we can get propertyIdentifiers from
				baseEntityName = collectionEntity.getBaseEntityName();
				isCollection = true;
			}else{
				//if we didn't find an existing collection then is this one of our basic entities
				var entityService = getHibachiService().getServiceByEntityName( entityName=arguments.rc.entityName );
				baseEntityName = arguments.rc.entityName;
				collectionEntity = collectionService.getTransientCollectionByEntityName(arguments.rc.entityName);
			}
			
			//by now we have a baseEntityName and a collectionEntity so now we need to check if we are filtering the collection
			if(!structKeyExists(rc, "propertyIdentifiersList")) {
				var entityProperties = getHibachiService().getDefaultPropertiesByEntityName( baseEntityName );
				rc.propertyIdentifiersList = collectionService.getPropertyIdentifiersList(entityProperties);
			}
			//check the select parameters (?propertyIdentifiers=listitem1,listitem2) and add them to the list of items we are filtering on
			/* TODO: selects*/
			
			// Turn the property identifiers into an array
			var propertyIdentifiers = listToArray( rc.propertyIdentifiersList );
			
			rc.response = {};
			
			//check if we have an have an id. If so filter on the id otherwise give us paginated records
			if(!structKeyExists(arguments.rc, "entityID")) {
				//get the paginated records
				//var paginatedCollectionOfEntities = collectionEntity.getPageRecords();
				//format the records prior to serialization based on the property Idenifiers that should be returned
				rc.response = collectionService.getFormattedPageRecords(collectionEntity,propertyIdentifiers);
				
				//handle filter parameters and select list as well as expect unique
				
			} else {
				//if we have an entityId then add the entity id filter and expect that we return one object
				
				var collectionConfigStruct = collectionEntity.getCollectionConfigStruct();
				if(!structKeyExists(collectionConfigStruct,'filterGroups')){
					collectionConfigStruct.filterGroups = [];
				}
				var capitalCaseEntityName = collectionService.capitalCase(arguments.rc.entityName);
				var propertyIdentifier = capitalCaseEntityName & '.#arguments.rc.entityName#ID';
				var filterStruct = collectionService.createFilterStruct(propertyIdentifier,'=',rc.entityID);
				
				var filterGroupStruct.filterGroup = [];
				arrayappend(filterGroupStruct.filterGroup,filterStruct);
				
				arrayAppend(collectionConfigStruct.filterGroups,filterGroupStruct);
				
				var paginatedCollectionOfEntities = collectionEntity.getPageRecords();
				for(var p=1; p<=arrayLen(propertyIdentifiers); p++) {
					rc.response[ propertyIdentifiers[p] ] = paginatedCollectionOfEntities[1].getValueByPropertyIdentifier( propertyIdentifier=propertyIdentifiers[p],format=true );
				}
				
				// return that entity based on the ID
			}
			arguments.rc.apiResponse = serializeJSON(rc.response);
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