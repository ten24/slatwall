component output="false" accessors="true" extends="HibachiService" {

	property name="hibachiSessionService" type="any";

	// ============================ PUBLIC AUTHENTICATION METHODS =================================
	
	public boolean function authenticateActionByAccount(required string action, required any account) {
		
		// Check if the user is a super admin, if true no need to worry about security
		if( arguments.account.getSuperUserFlag() ) {
			return true;
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
			return true;
		}

		// Check if the action is public, if public no need to worry about security
		if(listFindNocase(actionPermissions[ subsystemName ].sections[ sectionName ].publicMethods, itemName)){
			return true;
		}
		
		// All these potentials require the account to be logged in, and that it matches the hibachiScope
		if(getHibachiScope().getLoggedInFlag() && arguments.account.getAccountID() == getHibachiScope().getAccount().getAccountID()) {
			
			// Check if the action is anyLogin, if so and the user is logged in, then we can return true
			if(listFindNocase(actionPermissions[ subsystemName ].sections[ sectionName ].anyLoginMethods, itemName) && getHibachiScope().getLoggedInFlag()) {
				return true;
			}
			
			// Look for the anyAdmin methods next to see if this is an anyAdmin method, and this user is some type of admin
			if(listFindNocase(actionPermissions[ subsystemName ].sections[ sectionName ].anyAdminMethods, itemName) && getHibachiScope().getLoggedInAsAdminFlag()) {
				return true;
			}
			
			// Check to see if this is a defined secure method, and if so we can test it against the account
			if(listFindNocase(actionPermissions[ subsystemName ].sections[ sectionName ].secureMethods, itemName)) {
				var pgOK = false;
				for(var p=1; p<=arrayLen(arguments.account.getPermissionGroups()); p++){
					pgOK = authenticateSubsystemSectionItemActionByPermissionGroup(subsystem=subsystemName, section=sectionName, item=itemName, permissionGroup=arguments.account.getPermissionGroups()[p]); 
				}
				return pgOK;
			}
			
			// Check to see if the controller is an entity or rest controller, and then verify against the entity itself
			if(getActionPermissionDetails()[ subsystemName ].sections[ sectionName ].entityController || getActionPermissionDetails()[ subsystemName ].sections[ sectionName ].restController) {
				if ( left(itemName, 6) == "create" ) {
					return authenticateEntityCrudByAccount(crudType="create", entityName=right(itemName, len(itemName)-6), account=arguments.account);
				} else if ( left(itemName, 6) == "detail" ) {
					return authenticateEntityCrudByAccount(crudType="read", entityName=right(itemName, len(itemName)-6), account=arguments.account);
				} else if ( left(itemName, 6) == "delete" ) {
					return authenticateEntityCrudByAccount(crudType="delete", entityName=right(itemName, len(itemName)-6), account=arguments.account);
				} else if ( left(itemName, 4) == "edit" ) {
					return authenticateEntityCrudByAccount(crudType="update", entityName=right(itemName, len(itemName)-4), account=arguments.account);
				} else if ( left(itemName, 4) == "list" ) {
					return authenticateEntityCrudByAccount(crudType="read", entityName=right(itemName, len(itemName)-4), account=arguments.account);
				} else if ( left(itemName, 15) == "multiPreProcess" ) {
					return true;
				} else if ( left(itemName, 12) == "multiProcess" ) {
					return true;
				} else if ( left(itemName, 10) == "preProcess" ) {
					return true;
				} else if ( left(itemName, 7) == "process" ) {
					return true;
				} else if ( left(itemName, 4) == "save" ) {
					var createOK = authenticateEntityCrudByAccount(crudType="create", entityName=right(itemName, len(itemName)-4), account=arguments.account);
					if(createOK) {
						return true;	
					}
					var updateOK = authenticateEntityCrudByAccount(crudType="update", entityName=right(itemName, len(itemName)-4), account=arguments.account);
					return updateOK;
				}
				
			}
		}
		
		return false;
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
			var aspArr = listToArray(getApplicationValue("hibachiConfig").authenticationSubsystems);
			for(var s=1; s<=arrayLen(aspArr); s++) {
				
				// Figure out the correct directory for the subsytem
				var ssDirectory = getApplicationValue('application').getSubsystemDirPrefix( aspArr[s] );
				
				// expand the path of the controllers sub-directory
				var ssControllerPath = expandPath( "/#getApplicationValue('applicationKey')#" ) & "/#ssDirectory#/controllers";
				
				// Make sure the controllers sub-directory is actually there
				if(directoryExists(ssControllerPath)) {
					
					// Setup subsytem structure
					allPermissions[ aspArr[s] ] = {
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
						allPermissions[ aspArr[s] ].sections[ section ] = {
							anyAdminMethods = "",
							anyLoginMethods = "",
							publicMethods = "",
							secureMethods = "",
							restController = false,
							entityController = false
						};
						
						// Check defined permissions
						if(structKeyExists(obj, 'anyAdminMethods')){
							allPermissions[ aspArr[s] ].sections[ section ].anyAdminMethods = obj.anyAdminMethods;
						}
						if(structKeyExists(obj, 'anyLoginMethods')){
							allPermissions[ aspArr[s] ].sections[ section ].anyLoginMethods = obj.anyLoginMethods;
						}
						if(structKeyExists(obj, 'publicMethods')){
							allPermissions[ aspArr[s] ].sections[ section ].publicMethods = obj.publicMethods;
						}
						if(structKeyExists(obj, 'secureMethods')){
							allPermissions[ aspArr[s] ].sections[ section ].secureMethods = obj.secureMethods;
						}
						
						// Check for Controller types
						if(structKeyExists(obj, 'entityController') && isBoolean(obj.entityController) && obj.entityController) {
							allPermissions[ aspArr[s] ].sections[ section ].entityController = true;
						}
						if(structKeyExists(obj, 'restController') && isBoolean(obj.restController) && obj.restController) {
							allPermissions[ aspArr[s] ].sections[ section ].restController = true;
						}
						
						// Setup the 'hasSecureMethods' value
						if(len(allPermissions[ aspArr[s] ].sections[ section ].secureMethods)) {
							allPermissions[ aspArr[s] ].hasSecureMethods = true;
						}
						
					} // END Section Loop
					
				}
				
			} // End Subsytem Loop
			
			variables.actionPermissionDetails = allPermissions;
		}
		return variables.actionPermissionDetails;
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
