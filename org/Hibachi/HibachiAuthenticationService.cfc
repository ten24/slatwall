component output="false" accessors="true" extends="HibachiService" {

	property name="hibachiService" type="any";
	property name="hibachiSessionService" type="any";

	// ============================ PUBLIC AUTHENTICATION METHODS =================================
	
	public boolean function authenticateActionByAccount(required string action, required any account) {
		var authDetails = getActionAuthenticationDetailsByAccount(argumentcollection=arguments); 
		return authDetails.authorizedFlag;
	}
	
	public struct function getActionAuthenticationDetailsByAccount(required string action, required any account, struct restInfo) {
		
		var authDetails = {
			authorizedFlag = false,
			superUserAccessFlag = false,
			anyLoginAccessFlag = false,
			anyAdminAccessFlag = false,
			publicAccessFlag = false,
			entityPermissionAccessFlag = false,
			actionPermissionAccessFlag = false,
			forbidden = false,
			invalidToken = false,
			timeout = false
		};
		
		if(!(!isNull(arguments.account.getJwtToken()) && arguments.account.getJwtToken().verify())){
			authDetails.invalidToken = true;
		}
		
		// Check if the user is a super admin, if true no need to worry about security
		//Here superuser when not logged in is still false
		if( arguments.account.getSuperUserFlag() ) {
			authDetails.authorizedFlag = true;
			authDetails.superUserAccessFlag = true;
			return authDetails;
		}
		
		var subsystemName = listFirst( arguments.action, ":" );
		var sectionName = listFirst( listLast(arguments.action, ":"), "." );
		if(listLen(arguments.action, ".") eq 2) {
			var itemName = listLast( arguments.action, "." );	
		} else {
			var itemName = 'default';
		}
		
		var actionPermissions = getActionPermissionDetails();
		// Check if the subsystem & section are defined, if not then return true because that means authentication was not turned on
		if(!structKeyExists(actionPermissions, subsystemName) || !actionPermissions[ subsystemName ].hasSecureMethods || !structKeyExists(actionPermissions[ subsystemName ].sections, sectionName)) {
			authDetails.authorizedFlag = true;
			authDetails.publicAccessFlag = true;
			return authDetails;
		}

		// Check if the action is public, if public no need to worry about security
		if(listFindNocase(actionPermissions[ subsystemName ].sections[ sectionName ].publicMethods, itemName)){
			authDetails.authorizedFlag = true;
			authDetails.publicAccessFlag = true;
			return authDetails;
		}
		
		// All these potentials require the account to be logged in, and that it matches the hibachiScope
		if(getHibachiScope().getLoggedInFlag() && arguments.account.getAccountID() == getHibachiScope().getAccount().getAccountID()) {
			
			// Check if the action is anyLogin, if so and the user is logged in, then we can return true
			if(listFindNocase(actionPermissions[ subsystemName ].sections[ sectionName ].anyLoginMethods, itemName) && getHibachiScope().getLoggedInFlag()) {
				
				authDetails.authorizedFlag = true;
				authDetails.anyLoginAccessFlag = true;
				return authDetails;
			}
			
			// Look for the anyAdmin methods next to see if this is an anyAdmin method, and this user is some type of admin
			if(listFindNocase(actionPermissions[ subsystemName ].sections[ sectionName ].anyAdminMethods, itemName) && getHibachiScope().getLoggedInAsAdminFlag()) {
				authDetails.authorizedFlag = true;
				authDetails.anyAdminAccessFlag = true;
				return authDetails;
			}
			
			// Check to see if this is a defined secure method, and if so we can test it against the account
			if(listFindNocase(actionPermissions[ subsystemName ].sections[ sectionName ].secureMethods, itemName)) {
				
				var pgOK = false;
				for(var p=1; p<=arrayLen(arguments.account.getPermissionGroups()); p++){
					pgOK = authenticateSubsystemSectionItemActionByPermissionGroup(subsystem=subsystemName, section=sectionName, item=itemName, permissionGroup=arguments.account.getPermissionGroups()[p]); 
				}
				
				if(pgOk) {
					authDetails.authorizedFlag = true;
					authDetails.actionPermissionAccessFlag = true;
				}
			
				return authDetails;
			}
			
			// Check to see if the controller is an entity, and then verify against the entity itself
			if(getActionPermissionDetails()[ subsystemName ].sections[ sectionName ].entityController) {
				if ( left(itemName, 6) == "create" ) {
					authDetails.authorizedFlag = authenticateEntityCrudByAccount(crudType="create", entityName=right(itemName, len(itemName)-6), account=arguments.account);
				} else if ( left(itemName, 6) == "detail" ) {
					authDetails.authorizedFlag = authenticateEntityCrudByAccount(crudType="read", entityName=right(itemName, len(itemName)-6), account=arguments.account);
				} else if ( left(itemName, 6) == "delete" ) {
					authDetails.authorizedFlag = authenticateEntityCrudByAccount(crudType="delete", entityName=right(itemName, len(itemName)-6), account=arguments.account);
				} else if ( left(itemName, 4) == "edit" ) {
					authDetails.authorizedFlag = authenticateEntityCrudByAccount(crudType="update", entityName=right(itemName, len(itemName)-4), account=arguments.account);
				} else if ( left(itemName, 4) == "list" ) {
					authDetails.authorizedFlag = authenticateEntityCrudByAccount(crudType="read", entityName=right(itemName, len(itemName)-4), account=arguments.account);
				} else if ( left(itemName, 15) == "multiPreProcess" ) {
					authDetails.authorizedFlag = true;
				} else if ( left(itemName, 12) == "multiProcess" ) {
					authDetails.authorizedFlag = true;
				} else if ( left(itemName, 10) == "preProcess" ) {
					authDetails.authorizedFlag = true;
				} else if ( left(itemName, 7) == "process" ) {
					authDetails.authorizedFlag = true;
				} else if ( left(itemName, 4) == "save" ) {
					authDetails.authorizedFlag = authenticateEntityCrudByAccount(crudType="create", entityName=right(itemName, len(itemName)-4), account=arguments.account);
					if(!authDetails.authorizedFlag) {
						authDetails.authorizedFlag = authenticateEntityCrudByAccount(crudType="update", entityName=right(itemName, len(itemName)-4), account=arguments.account); 	
					}
				}
				
				if(authDetails.authorizedFlag) {
					authDetails.entityPermissionAccessFlag = true;
				}
			}
			// Check to see if the controller is for rest, and then verify against the entity itself
			if(getActionPermissionDetails()[ subsystemName ].sections[ sectionName ].restController){
				//require a token to validate
				if(!isNull(arguments.account.getJwtToken()) && arguments.account.getJwtToken().verify()){
					if (StructKeyExists(arguments.restInfo, "context")){
						var hasProcess = invokeMethod('new'&arguments.restInfo.entityName).hasProcessObject(arguments.restInfo.context);
					}else{
						var hasProcess = false;
					}
					if(hasProcess){
						authDetails.authorizedFlag = true;
					}else if(itemName == 'get'){
						authDetails.authorizedFlag = authenticateEntityCrudByAccount(crudType="read",entityName=arguments.restInfo.entityName,account=arguments.account);
					}else if(itemName == 'post'){
						if(arguments.restInfo.context == 'get'){
							authDetails.authorizedFlag = authenticateEntityCrudByAccount(crudType="read",entityName=arguments.restInfo.entityName,account=arguments.account);
						}else if(arguments.restInfo.context == 'save'){
							authDetails.authorizedFlag = authenticateEntityCrudByAccount(crudType="create", entityName=arguments.restInfo.entityName, account=arguments.account);
							if(!authDetails.authorizedFlag) {
								authDetails.authorizedFlag = authenticateEntityCrudByAccount(crudType="update", entityName=arguments.restInfo.entityName, account=arguments.account); 	
							}
						}else{
							authDetails.authorizedFlag = authenticateEntityCrudByAccount(crudType=arguments.restInfo.context,entityName=arguments.restInfo.entityName,account=arguments.account);
						}
					}
					if(authDetails.authorizedFlag) {
						authDetails.entityPermissionAccessFlag = true;
					}else{
						authDetails.forbidden = true;
					}
					
				}
			}
		}else{
			authDetails.timeout = true;
		}
		
		return authDetails;
	}
	
	public boolean function authenticateCollectionCrudByAccount(required string crudType, required any collection, required any account){
		return authenticateEntityCrudByAccount(crudType=arguments.crudType, entityName=arguments.collection.getCollectionObject(), account=arguments.account);
	}
	
	public boolean function authenticateEntityCrudByAccount(required string crudType, required string entityName, required any account) {
		// Check if the user is a super admin, if true no need to worry about security
		if( arguments.account.getSuperUserFlag() ) {
			return true;
		}
		
		// Loop over each permission group for this account, and ckeck if it has access
		for(var i=1; i<=arrayLen(arguments.account.getPermissionGroups()); i++){
			var pgOK = authenticateEntityByPermissionGroup(crudType=arguments.crudType, entityName=arguments.entityName, permissionGroup=arguments.account.getPermissionGroups()[i]);
			if(pgOK) {
				return true;
			}
		}
		
		// If for some reason not of the above were meet then just return false
		return false;
	}
	
	public boolean function isInternalRequest(){
		//domain contains http://domain/ so parse it
		var httpArray = listtoArray(cgi.http_referer,'/');
		if(arraylen(httpArray) >= 2){
			var domainReferer = httpArray[2];
		
			return domainReferer == cgi.http_host;
		}else{
			return false;
		}
	} 
	
	public numeric function getInvalidCredentialsStatusCode(){
		if(isInternalRequest()){
			//499 for angular requests so we don't interfere with existing iis or apache 401 authentications on the internal app
			return 499;
		}else{
			//401 for external api requests
			return 401;
		}
	}
	
	public boolean function authenticateCollectionPropertyIdentifierCrudByAccount(required crudType, required any collection, required string propertyIdentifier, required any account){
		var propertyIdentifierWithoutAlias = getService('hibachiCollectionService').getHibachiPropertyIdentifierByCollectionPropertyIdentifier(arguments.propertyIdentifier);
		var isObject = getService('hibachiService').getPropertyIsObjectByEntityNameAndPropertyIdentifier(entityName=arguments.collection.getCollectionObject(),propertyIdentifier=propertyIdentifierWithoutAlias);
		if(isObject){
			var lastEntity = getService('hibachiService').getLastEntityNameInPropertyIdentifier(entityName=arguments.collection.getCollectionObject(),propertyIdentifier=propertyIdentifierWithoutAlias);
		}else{
			var lastEntity = getService('hibachiService').getLastEntityNameInPropertyIdentifier(entityName=arguments.collection.getCollectionObject(),propertyIdentifier=propertyIdentifierWithoutAlias);
			var propertyStruct = getService('hibachiService').getPropertyByEntityNameAndPropertyName(lastEntity, listLast(propertyIdentifierWithoutAlias,'.'));
		}
		return authenticateEntityPropertyCrudByAccount(crudType=arguments.crudType, entityName=lastEntity, propertyName=listLast(propertyIdentifierWithoutAlias,'.'), account=arguments.account);
	}
	
	public boolean function authenticateEntityPropertyCrudByAccount(required string crudType, required string entityName, required string propertyName, required any account) {
		// Check if the user is a super admin, if true no need to worry about security
		if( arguments.account.getSuperUserFlag() ) {
			return true;
		}
		
		// Loop over each permission group for this account, and ckeck if it has access
		for(var i=1; i<=arrayLen(arguments.account.getPermissionGroups()); i++){
			var pgOK = authenticateEntityPropertyByPermissionGroup(crudType=arguments.crudType, entityName=arguments.entityName, propertyName=arguments.propertyName, permissionGroup=arguments.account.getPermissionGroups()[i]);
			if(pgOK) {
				return true;
			}
		}
		
		// If for some reason not of the above were meet then just return false
		return false;
	}
	
	// ================================ PUBLIC META INFO ==========================================
	
	public struct function getEntityPermissionDetails() {
		
		// First check to see if this is cached
		if(!structKeyExists(variables, "entityPermissionDetails")){
			
			// Create place holder struct for the data
			var entityPermissions = {};
			
			// Get all of the entities in the application
			var entityDirectoryArray = directoryList(expandPath('/#getApplicationValue('applicationKey')#/model/entity'));
			
			// Loop over each of the entities
			for(var e=1; e<=arrayLen(entityDirectoryArray); e++) {
				
				// Make sure that this is a .cfc
				if(listLast(entityDirectoryArray[e], '.') eq 'cfc') {
					
					// Get the entityName
					var entityName = listFirst(listLast(replace(entityDirectoryArray[e], '\', '/', 'all'), '/'), '.');
					
					// Get the entityMetaData which contains all the important permissions setup stuff
					var entityMetaData = createObject('component', '#getApplicationValue('applicationKey')#.model.entity.#entityName#').getThisMetaData();
					
					// Setup the permisions of this entity is setup for it
					if(structKeyExists(entityMetaData, "hb_permission") && (entityMetaData.hb_permission eq "this" || getHasPropertyByEntityNameAndPropertyIdentifier(entityName=entityName, propertyIdentifier=entityMetaData.hb_permission))) {
						
						// Setup basic placeholder info
						entityPermissions[ entityName ] = {};
						entityPermissions[ entityName ].properties = {};
						entityPermissions[ entityName ].mtmproperties = {};
						entityPermissions[ entityName ].mtoproperties = {};
						entityPermissions[ entityName ].otmproperties = {};
						
						// If for some reason this entities permissions are managed by a parent entity then define it as such
						if(entityMetaData.hb_permission neq "this") {
							entityPermissions[ entityName ].inheritPermissionEntityName = getLastEntityNameInPropertyIdentifier(entityName=entityName, propertyIdentifier=entityMetaData.hb_permission);
							entityPermissions[ entityName ].inheritPermissionPropertyName = listLast(entityMetaData.hb_permission, ".");	
						}
						
						// Loop over each of the properties
						for(var p=1; p<=arrayLen(entityMetaData.properties); p++) {
							
							// Make sure that this property should be added as a property that can have permissions
							if( (!structKeyExists(entityMetaData.properties[p], "fieldtype") || entityMetaData.properties[p].fieldtype neq "ID")
								&& (!structKeyExists(entityMetaData.properties[p], "persistent") || entityMetaData.properties[p].persistent)
								&& (!structKeyExists(entityMetaData.properties[p], "hb_populateEnabled") || entityMetaData.properties[p].hb_populateEnabled neq "false")) {
								
								// Add to ManyToMany Properties
								if(structKeyExists(entityMetaData.properties[p], "fieldtype") && entityMetaData.properties[p].fieldType eq "many-to-one") {
									entityPermissions[ entityName ].mtoproperties[ entityMetaData.properties[p].name ] = entityMetaData.properties[p];
								
								// Add to OneToMany Properties
								} else if (structKeyExists(entityMetaData.properties[p], "fieldtype") && entityMetaData.properties[p].fieldType eq "one-to-many") {
									entityPermissions[ entityName ].otmproperties[ entityMetaData.properties[p].name ] = entityMetaData.properties[p];
									
								// Add to ManyToMany Properties
								} else if (structKeyExists(entityMetaData.properties[p], "fieldtype") && entityMetaData.properties[p].fieldType eq "many-to-many") {
									entityPermissions[ entityName ].mtmproperties[ entityMetaData.properties[p].name ] = entityMetaData.properties[p];
								
								// Add to regular field Properties
								} else {
									entityPermissions[ entityName ].properties[ entityMetaData.properties[p].name ] = entityMetaData.properties[p];	
								}
							}
						}
						
						// Sort the structure in order by propertyName
						structSort(entityPermissions[ entityName ].properties, "text", "ASC", "name");
					}
				}
			}
			
			// Update the cached value to be used in the future
			variables.entityPermissionDetails = entityPermissions;
		}
		return variables.entityPermissionDetails;
	}
	
	public struct function getActionPermissionDetails(){
		
		// First check to see if this is cached
		if(!structKeyExists(variables, "actionPermissionDetails")){
			
			// Setup the all permisions structure which will later be set to the variables scope
			var allPermissions={};
			
			// Loop over each of the authentication subsytems
			for(var subsystemName in getAuthenticationSubsystemNamesArray()) {
				
				var subsystemPermissions = getSubsytemActionPermissionDetails( subsystemName );
				if(!isNull(subsystemPermissions)) {
					allPermissions[ subsystemName ] = subsystemPermissions;
				}
				
			} // End Subsytem Loop
			
			variables.actionPermissionDetails = allPermissions;
		}
		return variables.actionPermissionDetails;
	}
	
	public any function getSubsytemActionPermissionDetails( required string subsystemName ) {
		// Figure out the correct directory for the subsytem
		var ssDirectory = getApplicationValue('application').getSubsystemDirPrefix( arguments.subsystemName );
		
		// expand the path of the controllers sub-directory
		var ssControllerPath = expandPath( "/#getApplicationValue('applicationKey')#" ) & "/#ssDirectory#/controllers";
		
		// Make sure the controllers sub-directory is actually there
		if(directoryExists(ssControllerPath)) {
			
			// Setup subsytem structure
			var subsystemPermissions = {
				hasSecureMethods = false,
				sections = {}
			};
			
			// Grab a list of all the files in the controllers directory
			var ssDirectoryList = directoryList(ssControllerPath);
			
			// Loop over each file
			for(var d=1; d<=arrayLen(ssDirectoryList); d++) {
				
				var section = listFirst(listLast(ssDirectoryList[d],"/\"),".");
				var obj = createObject('component', '#getApplicationValue('applicationKey')#.#replace(ssDirectory, '/','.','all')#controllers.#section#');
				
				// Setup section structure
				subsystemPermissions.sections[ section ] = {
					anyAdminMethods = "",
					anyLoginMethods = "",
					publicMethods = "",
					secureMethods = "",
					restController = false,
					entityController = false
				};
				
				// Check defined permissions
				if(structKeyExists(obj, 'anyAdminMethods')){
					subsystemPermissions.sections[ section ].anyAdminMethods = obj.anyAdminMethods;
				}
				if(structKeyExists(obj, 'anyLoginMethods')){
					subsystemPermissions.sections[ section ].anyLoginMethods = obj.anyLoginMethods;
				}
				if(structKeyExists(obj, 'publicMethods')){
					subsystemPermissions.sections[ section ].publicMethods = obj.publicMethods;
				}
				if(structKeyExists(obj, 'secureMethods')){
					subsystemPermissions.sections[ section ].secureMethods = obj.secureMethods;
				}
				
				// Check for Controller types
				if(structKeyExists(obj, 'entityController') && isBoolean(obj.entityController) && obj.entityController) {
					subsystemPermissions.sections[ section ].entityController = true;
				}
				if(structKeyExists(obj, 'restController') && isBoolean(obj.restController) && obj.restController) {
					subsystemPermissions.sections[ section ].restController = true;
				}
				
				// Setup the 'hasSecureMethods' value
				if(len(subsystemPermissions.sections[ section ].secureMethods & subsystemPermissions.sections[ section ].anyAdminMethods & subsystemPermissions.sections[ section ].anyLoginMethods)) {
					subsystemPermissions.hasSecureMethods = true;
				}
				
			} // END Section Loop
		
			return subsystemPermissions;
			
		}
	}
	
	public array function getAuthenticationSubsystemNamesArray() {
		return listToArray(getApplicationValue("hibachiConfig").authenticationSubsystems);
	}
	
	public void function clearEntityPermissionDetails(){
		if(structKeyExists(variables, "entityPermissionDetails")) {
			structDelete(variables, "entityPermissionDetails");
		}
	}
	
	public void function clearActionPermissionDetails(){
		if(structKeyExists(variables, "actionPermissionDetails")) {
			structDelete(variables, "actionPermissionDetails");
		}
	}
	
	// ============================ PRIVATE HELPER FUNCTIONS =======================================
	
	public boolean function authenticateSubsystemActionByPermissionGroup(required string subsystem, required any permissionGroup) {
		// Pull the permissions detail struct out of the permission group
		var permissions = arguments.permissionGroup.getPermissionsByDetails();
		
		if(structKeyExists(permissions.action.subsystems, arguments.subsystem) && structKeyExists(permissions.action.subsystems[arguments.subsystem], "permission") ) {
			if( !isNull(permissions.action.subsystems[arguments.subsystem].permission.getAllowActionFlag()) && permissions.action.subsystems[arguments.subsystem].permission.getAllowActionFlag()) {
				return true;
			} else {
				return false;
			}
		}
		
		return false;
	}
	
	public boolean function authenticateSubsystemSectionActionByPermissionGroup(required string subsystem, required string section, required any permissionGroup) {
		// Pull the permissions detail struct out of the permission group
		var permissions = arguments.permissionGroup.getPermissionsByDetails();
		
		if(structKeyExists(permissions.action.subsystems, arguments.subsystem) && structKeyExists(permissions.action.subsystems[arguments.subsystem].sections, arguments.section) && structKeyExists(permissions.action.subsystems[arguments.subsystem].sections[ arguments.section ], "permission") ) {
			if( !isNull(permissions.action.subsystems[arguments.subsystem].sections[ arguments.section ].permission.getAllowActionFlag()) && permissions.action.subsystems[arguments.subsystem].sections[ arguments.section ].permission.getAllowActionFlag()) {
				return true;
			} else {
				return false;
			}
		}
		
		return authenticateSubsystemActionByPermissionGroup(subsystem=arguments.subsystem, permissionGroup=arguments.permissionGroup);
	}
	
	public boolean function authenticateSubsystemSectionItemActionByPermissionGroup(required string subsystem, required string section, required string item, required any permissionGroup) {
		// Pull the permissions detail struct out of the permission group
		var permissions = arguments.permissionGroup.getPermissionsByDetails();
		
		if(structKeyExists(permissions.action.subsystems, arguments.subsystem) && structKeyExists(permissions.action.subsystems[arguments.subsystem].sections, arguments.section) && structKeyExists(permissions.action.subsystems[arguments.subsystem].sections[arguments.section].items, arguments.item) ) {
			if( !isNull(permissions.action.subsystems[arguments.subsystem].sections[arguments.section].items[arguments.item].getAllowActionFlag()) && permissions.action.subsystems[arguments.subsystem].sections[arguments.section].items[arguments.item].getAllowActionFlag()) {
				return true;
			} else {
				return false;
			}
		}
		
		return authenticateSubsystemSectionActionByPermissionGroup(subsystem=arguments.subsystem, section=arguments.section, permissionGroup=arguments.permissionGroup);
	}
	
	public boolean function authenticateEntityByPermissionGroup(required string crudType, required string entityName, required any permissionGroup) {
		// Pull the permissions detail struct out of the permission group
		var permissions = arguments.permissionGroup.getPermissionsByDetails();
		var permissionDetails = getEntityPermissionDetails();
		
		// Check for entity specific values
		if(structKeyExists(permissions.entity.entities, arguments.entityName) && structKeyExists(permissions.entity.entities[arguments.entityName], "permission") && !isNull(permissions.entity.entities[arguments.entityName].permission.invokeMethod("getAllow#arguments.crudType#Flag"))) {
			if( permissions.entity.entities[arguments.entityName].permission.invokeMethod("getAllow#arguments.crudType#Flag") ) {
				return true;
			} else {
				return false;
			}
		}
		
		// Check for an inherited permission
		if(structKeyExists(permissionDetails, arguments.entityName) && structKeyExists(permissionDetails[arguments.entityName], "inheritPermissionEntityName")) {
			return authenticateEntityByPermissionGroup(crudType=arguments.crudType, entityName=permissionDetails[arguments.entityName].inheritPermissionEntityName, permissionGroup=arguments.permissionGroup);
		}	
		
		// Check for generic permssion
		if(structKeyExists(permissions.entity, "permission") && !isNull(permissions.entity.permission.invokeMethod("getAllow#arguments.crudType#Flag")) && permissions.entity.permission.invokeMethod("getAllow#arguments.crudType#Flag")) {
			return true;
		}
		
		return false;
	}
	
	public boolean function authenticateEntityPropertyByPermissionGroup(required string crudType, required string entityName, required string propertyName, required any permissionGroup) {
		// Pull the permissions detail struct out of the permission group
		var permissions = arguments.permissionGroup.getPermissionsByDetails();
		
		// Check first to see if this entity was defined
		if(structKeyExists(permissions.entity.entities, arguments.entityName) && structKeyExists(permissions.entity.entities[arguments.entityName].properties, arguments.propertyName) && !isNull(permissions.entity.entities[ arguments.entityName ].properties[ arguments.propertyName ].invokeMethod("getAllow#arguments.crudType#Flag"))) {
			if( permissions.entity.entities[ arguments.entityName ].properties[ arguments.propertyName ].invokeMethod("getAllow#arguments.crudType#Flag") ) {
				return true;
			} else {
				return false;
			}
		}
		
		// If there was an entity defined, and special property values have been defined then we need to return false
		if (structKeyExists(permissions.entity.entities, arguments.entityName) && structCount(permissions.entity.entities[arguments.entityName].properties)) {
			return false;
			
		}
		
		return authenticateEntityByPermissionGroup(crudType=arguments.crudType, entityName=arguments.entityName, permissionGroup=arguments.permissionGroup);
	}
	
	
	
}
