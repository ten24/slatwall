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
		param name="arguments.rc.apiResponse.statusCode" default="200";
		param name="arguments.rc.apiResponse.statusText" default="OK";
		param name="rc.contentType" default="application/json"; 
		//could possibly check whether we want a different contentType other than json in the future
		arguments.rc.apiResponse.contentType = rc.contentType;
	}
	
	/*public any function onMissingMethod(required string name, required struct rc){
		arguments.rc.apiResponse.statusCode = "400";
	}*/
	
	public any function get( required struct rc ) {
		/* TODO: handle filter parametes, add Select statements as list to access one-to-many relationships.
			create a base default properties function that can be overridden at the entity level via function
			handle accessing collections by id
		*/
		
		param name="arguments.rc.propertyIdentifiers" default="";
		
		//first check if we have an entityName value
		if(!structKeyExists(arguments.rc, "entityName")) {
			arguments.rc.apiResponse['account'] = arguments.rc.$.slatwall.invokeMethod("getAccountData");
			arguments.rc.apiResponse['cart'] = arguments.rc.$.slatwall.invokeMethod("getCartData");
				
		} else {
			//get entity service by entity name
			
			if(!structKeyExists(arguments.rc,'entityID')){
				//should be able to add select and where filters here
				var result = collectionService.getAPIResponseForEntityName(	arguments.rc.entityName,
																			arguments.rc.propertyIdentifiers);
				structAppend(arguments.rc.apiResponse,result);
			}else{
				//figure out if we have a collection or a basic entity
				var collectionEntity = collectionService.getCollectionByCollectionID(arguments.rc.entityID);
				if(isNull(collectionEntity)){
					//should only be able to add selects (&propertyIdentifier=)
					var result = collectionService.getAPIResponseForBasicEntityWithID(arguments.rc.entityName,
																				arguments.rc.entityID,
																				arguments.rc.propertyIdentifiers);
					structAppend(arguments.rc.apiResponse,result);
				}else{
					//should be able to add select and where filters here
					var result = collectionService.getAPIResponseForCollection(	collectionEntity,
																				arguments.rc.propertyIdentifiers);
					structAppend(arguments.rc.apiResponse,result);
				}
			}
		}
	}
	
	public any function post( required struct rc ) {
		param name="arguments.rc.context" default="save";
		param name="arguments.rc.entityID" default="";
		
		var entityService = getHibachiService().getServiceByEntityName( entityName=arguments.rc.entityName );
		//var entity = entityService.invokeMethod("get#arguments.rc.entityName#", {1=arguments.rc.entityID, 2=true});
		
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