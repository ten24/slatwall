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
	
	public any function get( required struct rc ) {
		if(!structKeyExists(arguments.rc, "entityName")) {
			arguments.rc.apiResponse['account'] = arguments.rc.$.slatwall.invokeMethod("getAccountData");
			arguments.rc.apiResponse['cart'] = arguments.rc.$.slatwall.invokeMethod("getCartData");
				
		} else {
			
			var entityService = getHibachiService().getServiceByEntityName( entityName=arguments.rc.entityName );
		
			
		
			
			if(!structKeyExists(arguments.rc, "entityID")) {
				// parse rc looking for property keys that belong to this entity... and call entityLoad
				var entity = entityService.invokeMethod("get#arguments.rc.entityName#SmartList", {1=arguments.rc.entityID, 2=true});
			} else {
				var entity = entityService.invokeMethod("get#arguments.rc.entityName#", {1=arguments.rc.entityID, 2=true});
				arguments.rc.apiResponse = entity;
				// return that entity based on the ID
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