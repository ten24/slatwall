component output="false" accessors="true" {
	
	property name="fw" type="any";
	property name="hibachiService" type="any";
	
	public void function init( required any fw ) {
		setFW( arguments.fw );
	}
	
	
	public any function before( required struct rc ) {
		arguments.rc.apiRequest = true;
		getFW().setView("public:main.blank");
	}
	
	private string function capitalCase(required string phrase){
        return reReplace(arguments.phrase, "\b(\w)(\w*)?\b", "\U\1\L\2", "ALL"); 
	}
	
	public any function get( required struct rc ) {
		if(!structKeyExists(arguments.rc, "entityName")) {
			arguments.rc.apiResponse['account'] = arguments.rc.$.slatwall.invokeMethod("getAccountData");
			arguments.rc.apiResponse['cart'] = arguments.rc.$.slatwall.invokeMethod("getCartData");
				
		} else {
			
			var entityService = getHibachiService().getServiceByEntityName( entityName=arguments.rc.entityName );
			
			// Lets figure out the properties that need to be returned
			if(!structKeyExists(rc, "propertyIdentifiers")) {
				rc.propertyIdentifiers = "";
				var entityProperties = getHibachiService().getPropertiesByEntityName( rc.entityName );
				
				for(var i=1; i<=arrayLen(entityProperties); i++) {
					if( (!structKeyExists(entityProperties[i], "fieldtype") || entityProperties[i].fieldtype == "ID") && (!structKeyExists(entityProperties[i], "persistent") || entityProperties[i].persistent)) {
						rc.propertyIdentifiers = listAppend(rc.propertyIdentifiers, entityProperties[i].name);
					} else if(structKeyExists(entityProperties[i], "fieldtype") && entityProperties[i].fieldType == "many-to-one") {
						rc.propertyIdentifiers = listAppend(rc.propertyIdentifiers, "#entityProperties[i].name#.#getHibachiService().getPrimaryIDPropertyNameByEntityName(entityProperties[i].cfc)#" );
					}
				}
			}
			
			// Turn the property identifiers into an array
			var piArray = listToArray( rc.propertyIdentifiers );
			rc.response = {};
			
			if(!structKeyExists(arguments.rc, "entityID")) {
				// parse rc looking for property keys that belong to this entity... and call entityLoad
				variables.collectionService = "collectionService";
				var collectionEntity = request.slatwallScope.getService( variables.collectionService ).newCollection();
				var capitalCaseEntityName = capitalCase(entityName);
				collectionEntity.setBaseEntityName('Slatwall#capitalCaseEntityName#');
				var collectionConfigStruct = {
					baseEntityName="Slatwall#capitalCaseEntityName#",
					baseEntityAlias="#capitalCaseEntityName#"
				};
				collectionEntity.setCollectionConfigStruct(collectionConfigStruct);
				var collectionListPageRecords = collectionEntity.getPageRecords();
				
				
				rc.response[ "pageRecords" ] = [];
				for(var i=1; i<=arrayLen(collectionListPageRecords); i++) {
					var thisRecord = {};
					for(var p=1; p<=arrayLen(piArray); p++) {
						var value = collectionListPageRecords[i].getValueByPropertyIdentifier( propertyIdentifier=piArray[p], formatValue=true );
						if((len(value) == 3 and value eq "YES") or (len(value) == 2 and value eq "NO")) {
							thisRecord[ piArray[p] ] = value & " ";
						} else {
							thisRecord[ piArray[p] ] = value;
						}
					}
					arrayAppend(rc.response[ "pageRecords" ], thisRecord);
				}
				
				
			} else {
				var entity = entityService.invokeMethod("get#arguments.rc.entityName#", {1=arguments.rc.entityID, 2=true});
				for(var p=1; p<=arrayLen(piArray); p++) {
					rc.response[ piArray[p] ] = entity.getValueByPropertyIdentifier( propertyIdentifier=piArray[p], formatValue=true );
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