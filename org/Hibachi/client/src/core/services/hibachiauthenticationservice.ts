/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class HibachiAuthenticationService{
    
    //@ngInject
    constructor(
       public $rootScope:any,
       public $q,
       public appConfig,
       public $injector,
       public utilityService
    ){
        
    }
    
    public isSuperUser=()=>{
        return this.$rootScope.slatwall.role == 'superUser';
    }
    
    public authenticateActionByAccount=(action:string,processContext:string)=>{
        var authDetails:any = this.getActionAuthenticationDetailsByAccount(action,processContext);
        return authDetails.authorizedFlag;
    }
    
    
    
    public getActionAuthenticationDetailsByAccount=(action:string, processContext:string)=>{
        var authDetails = {
			authorizedFlag : false,
			superUserAccessFlag : false,
			anyLoginAccessFlag : false,
			anyAdminAccessFlag : false,
			publicAccessFlag : false,
			entityPermissionAccessFlag : false,
			actionPermissionAccessFlag : false,
			forbidden : false,
			invalidToken : false,
			timeout : false
		};
		
		if(this.isSuperUser()){
		    authDetails.authorizedFlag = true;
			authDetails.superUserAccessFlag = true;
		    return authDetails;
		}
		
		var subsystemName = action.split(':')[0];
		var sectionName = action.split(':')[1].split('.')[0];
		if(action.split('.').length > 1) {
			var itemName:string = action.split('.')[1];	
		} else {
			var itemName:string = 'default';
		}
		 
		if( (this.utilityService.left(itemName,10) == 'preprocess'  || this.utilityService.left(itemName,7) == 'process' )
			&& processContext 
			&& processContext.length
		){
			itemName += '_processContext';
		}
        
        var actionPermissions = this.getActionPermissionDetails();
        if(!actionPermissions){
            return false;
        }
        // Check if the subsystem & section are defined, if not then return true because that means authentication was not turned on
        if(
            !actionPermissions[subsystemName] 
            || !actionPermissions[ subsystemName ].hasSecureMethods 
            || !actionPermissions[ subsystemName ].sections[sectionName] 
        ){
            authDetails.authorizedFlag = true;
			authDetails.publicAccessFlag = true;
			return authDetails;
        }
        
        // Check if the action is public, if public no need to worry about security
		if(this.utilityService.listFindNoCase(actionPermissions[ subsystemName ].sections[ sectionName ].publicMethods, itemName)!=-1){
			authDetails.authorizedFlag = true;
			authDetails.publicAccessFlag = true;
			return authDetails;
		}
		
		// All these potentials require the account to be logged in, and that it matches the hibachiScope
		if(
		    this.$rootScope.slatwall.account 
		    && this.$rootScope.slatwall.account.accountID
		    && this.$rootScope.slatwall.account.accountID.length
		) {
			
			// Check if the action is anyLogin, if so and the user is logged in, then we can return true
			if(
			    this.utilityService.listFindNoCase(actionPermissions[ subsystemName ].sections[ sectionName ].anyLoginMethods, itemName)!=-1
			) {
			    authDetails.authorizedFlag = true;
				authDetails.anyLoginAccessFlag = true;
				return authDetails;
			}
			
			// Look for the anyAdmin methods next to see if this is an anyAdmin method, and this user is some type of admin
			if(this.utilityService.listFindNoCase(actionPermissions[ subsystemName ].sections[ sectionName ].anyAdminMethods, itemName)!=-1) {
				authDetails.authorizedFlag = true;
				authDetails.anyAdminAccessFlag = true;
				return authDetails;
			}
			
			// Check to see if this is a defined secure method, and if so we can test it against the account
			if(this.utilityService.listFindNoCase(actionPermissions[ subsystemName ].sections[ sectionName ].secureMethods, itemName)!=-1) {
				
				var pgOK = false;
				if(this.$rootScope.slatwall.authInfo.permissionGroups){
    				var accountPermissionGroups = this.$rootScope.slatwall.authInfo.permissionGroups;
    				if(accountPermissionGroups){
        				for(var p in accountPermissionGroups){
        					pgOK = this.authenticateSubsystemSectionItemActionByPermissionGroup(subsystemName, sectionName, itemName, accountPermissionGroups[p]); 
        					if(pgOK){
        						break;
        					}
        					
        				}
    				}
				}
				
				if(pgOK) {
					authDetails.authorizedFlag = true;
					authDetails.actionPermissionAccessFlag = true;
				}
			
				return authDetails;
			}
			//start line130
			// For process / preprocess strip out process context from item name		
			if( itemName.split('_').length > 1){ 
				itemName = itemName.split('_')[0]; 
			}
			
			// Check to see if the controller is an entity, and then verify against the entity itself
			if(this.getActionPermissionDetails()[ subsystemName ].sections[ sectionName ].entityController) {
				if ( this.utilityService.left(itemName, 6) == "create" ) {
					authDetails.authorizedFlag = this.authenticateEntityCrudByAccount("create", this.utilityService.right(itemName, itemName.length-6));
				} else if ( this.utilityService.left(itemName, 6) == "detail" ) {
					authDetails.authorizedFlag = this.authenticateEntityCrudByAccount("read", this.utilityService.right(itemName, itemName.length-6));
				} else if ( this.utilityService.left(itemName, 6) == "delete" ) {
					authDetails.authorizedFlag = this.authenticateEntityCrudByAccount("delete", this.utilityService.right(itemName, itemName.length-6));
				} else if ( this.utilityService.left(itemName, 4) == "edit" ) {
					authDetails.authorizedFlag = this.authenticateEntityCrudByAccount("update", this.utilityService.right(itemName, itemName.length-4));
				} else if ( this.utilityService.left(itemName, 4) == "list" ) {
					authDetails.authorizedFlag = this.authenticateEntityCrudByAccount("read", this.utilityService.right(itemName, itemName.length-4));
				} else if ( this.utilityService.left(itemName, 10) == "reportlist" ) {
					authDetails.authorizedFlag = this.authenticateEntityCrudByAccount("report", this.utilityService.right(itemName, itemName.length-10));
				} else if ( this.utilityService.left(itemName, 15) == "multiPreProcess" ) {
					authDetails.authorizedFlag = this.authenticateProcessByAccount(processContext, this.utilityService.right(itemName, itemName.length-15));
				} else if ( this.utilityService.left(itemName, 12) == "multiProcess" ) {
					authDetails.authorizedFlag = this.authenticateProcessByAccount(processContext, this.utilityService.right(itemName, itemName.length-12));
				} else if ( this.utilityService.left(itemName, 10) == "preProcess" ) {
					authDetails.authorizedFlag = this.authenticateProcessByAccount(processContext, this.utilityService.right(itemName, itemName.length-10));
				} else if ( this.utilityService.left(itemName, 7) == "process" ) {
					authDetails.authorizedFlag = this.authenticateProcessByAccount(processContext, this.utilityService.right(itemName, itemName.length-7));
				} else if ( this.utilityService.left(itemName, 4) == "save" ) {
					authDetails.authorizedFlag = this.authenticateEntityCrudByAccount("create", this.utilityService.right(itemName, itemName.length-4));
					if(!authDetails.authorizedFlag) {
						authDetails.authorizedFlag = this.authenticateEntityCrudByAccount("update", this.utilityService.right(itemName, itemName.length-4)); 	
					}
				}
				
				if(authDetails.authorizedFlag) {
					authDetails.entityPermissionAccessFlag = true;
				}
			}
			
			//TODO: see if this applies on the client side and how
			// Check to see if the controller is for rest, and then verify against the entity itself
			/*if(this.getActionPermissionDetails()[ subsystemName ].sections[ sectionName ].restController){
				//require a token to validate
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
					
			}*/
		}
		return authDetails;
    }
    
    
    
    public authenticateProcessByAccount = (processContext:string,entityName:string):boolean=>{
    	entityName = entityName.toLowerCase();
    	processContext = processContext.toLowerCase();
    	
    	// Check if the user is a super admin, if true no need to worry about security
		if( this.isSuperUser() ) {
			return true;
		}
		
		// Loop over each permission group for this account, and ckeck if it has access
		if(this.$rootScope.slatwall.authInfo.permissionGroups){
		    var accountPermissionGroups = this.$rootScope.slatwall.authInfo.permissionGroups;
    		for(var i in accountPermissionGroups){
    			var pgOK = this.authenticateProcessByPermissionGroup(processContext, entityName, accountPermissionGroups[i]);
    			if(pgOK) {
    				return true;
    			}
    		}
		}
		
		return false;
    }
    
    public authenticateEntityCrudByAccount=(crudType:string,entityName:string):boolean=>{
        crudType = this.utilityService.toCamelCase(crudType);
        entityName = entityName.toLowerCase();
        
        // Check if the user is a super admin, if true no need to worry about security
		if( this.isSuperUser()) {
			return true;
		}
		
		
		// Loop over each permission group for this account, and ckeck if it has access
		if(this.$rootScope.slatwall.authInfo.permissionGroups){
		    var accountPermissionGroups = this.$rootScope.slatwall.authInfo.permissionGroups;
    		for(var i in accountPermissionGroups){
    			var pgOK = this.authenticateEntityByPermissionGroup(crudType, entityName, accountPermissionGroups[i]);
    			if(pgOK) {
    				return true;
    			}
    		}
		}
		
		// If for some reason not of the above were meet then just return false
		return false;
    }
    
    public authenticateProcessByPermissionGroup = (processContext:string, entityName:string,permissionGroup:any):boolean=>{
    	var permissions = permissionGroup;
		var permissionDetails = this.getEntityPermissionDetails();
		
		entityName = entityName.toLowerCase();
		processContext = processContext.toLowerCase();
		
		if(!this.authenticateEntityByPermissionGroup('Process',entityName,permissionGroup)){
			return false;
		}
		
		//if nothing specific then all processes are ok
		if(!permissions.process.entities[entityName]){
			return true;
		}
		
		//if we find perms then what are they?
		if(
			permissions.process.entities[entityName]
			&& permissions.process.entities[entityName].context[processContext]
		){
			return permissions.process.entities[entityName].context[processContext].allowProcessFlag;
		}
		
		return false;
		
    }
    
    public authenticateEntityByPermissionGroup = (crudType,entityName,permissionGroup):boolean=>{
        // Pull the permissions detail struct out of the permission group
        
		var permissions = permissionGroup;
		var permissionDetails = this.getEntityPermissionDetails();
		
		// Check for entity specific values
		if(
		    permissions.entity.entities[entityName] 
		    && permissions.entity.entities[entityName]["permission"] 
		    && permissions.entity.entities[entityName].permission["allow"+crudType+"Flag"]
		) {
			if( 
			    permissions.entity.entities[entityName].permission["allow"+crudType+"Flag"] 
			) {
				return true;
			} else {
				return false;
			}
		}
		
		// Check for an inherited permission
		if(
		    permissionDetails[entityName]
		    && permissionDetails[entityName]["inheritPermissionEntityName"]
		) {
			return this.authenticateEntityByPermissionGroup(crudType, permissionDetails[entityName].inheritPermissionEntityName,permissionGroup);
		}	
		
		// Check for generic permssion
		if(
		    permissions.entity["permission"] 
		    && permissions.entity.permission["allow"+crudType+"Flag"] 
		    && permissions.entity.permission["allow"+crudType+"Flag"] 
		) {
			return true;
		}
		
		return false;
    }
    
    public authenticateSubsystemSectionItemActionByPermissionGroup=(subsystem:string,section:string,item:string,permissionGroup:any):boolean=>{
        // Pull the permissions detail struct out of the permission group
		var permissions = permissionGroup;
		
		if(
		    permissions.action.subsystems[subsystem]
		    && permissions.action.subsystems[subsystem].sections[section] 
		    && permissions.action.subsystems[subsystem].sections[section].items[item] 
		) {
			return
			    permissions.action.subsystems[subsystem].sections[section].items[item].allowActionFlag 
			    && permissions.action.subsystems[subsystem].sections[section].items[item].allowActionFlag
			;
		}
		
		return this.authenticateSubsystemSectionActionByPermissionGroup(subsystem=subsystem, section=section, permissionGroup=permissionGroup);
    }
    
    public authenticateSubsystemSectionActionByPermissionGroup = (subsystem:string,section:string,permissionGroup:any):boolean=>{
        // Pull the permissions detail struct out of the permission group
		var permissions = permissionGroup;
		
		if(
		    permissions.action.subsystems[subsystem] 
		    && permissions.action.subsystems[subsystem].sections[section] 
		    && permissions.action.subsystems[subsystem].sections[ section ]["permission"]
		) {
			if( 
			    permissions.action.subsystems[subsystem].sections[section ].permission.allowActionFlag 
			    && permissions.action.subsystems[subsystem].sections[ section ].permission.allowActionFlag
			) {
				return true;
			} else {
				return false;
			}
		}
		
		return this.authenticateSubsystemActionByPermissionGroup(subsystem=subsystem, permissionGroup=permissionGroup);
    }
    
    public authenticateSubsystemActionByPermissionGroup = (subsystem:string,permissionGroup:any):boolean=>{
        // Pull the permissions detail struct out of the permission group
		var permissions = permissionGroup;
		
		if(
		    permissions.action.subsystems[subsystem] 
		    && permissions.action.subsystems[subsystem]["permission"]
		) {
			if( permissions.action.subsystems[subsystem].permission.allowActionFlag 
			    && permissions.action.subsystems[subsystem].permission.allowActionFlag
			) {
				return true;
			} else {
				return false;
			}
		}
		
		return false;
    }
    
    public getActionPermissionDetails=()=>{
        return this.$rootScope.slatwall.authInfo.action;
    }
    
    public getEntityPermissionDetails=()=>{
        return this.$rootScope.slatwall.authInfo.entity;
    }
    
    
    public getUserRole=()=>{
        return this.$rootScope.slatwall.role;
    }
    
    public getRoleBasedData=  (jwtData)=>{
        switch(jwtData.role){
            case 'superUser':
                //no data is required for this role and we can assume they have access to everything
                break;
            case 'admin':
                this.getPublicRoleData();
                this.getPermissionGroupsData(jwtData.permissionGroups);
                break;
            case 'public':
                //only public data is required for this role and we can assume they have access to everything
                this.getPublicRoleData();
                break;
        }
    }
    
    public  getPublicRoleData = ()=>{
        var entityPromise = this.getEntityData();
        var actionPromise = this.getActionData();
        var publicRoleDataPromises = [entityPromise,actionPromise];
        var qPromise = this.$q.all(publicRoleDataPromises).then((data) => {
            if(!this.$rootScope.slatwall.authInfo){
                this.$rootScope.slatwall.authInfo = {};
            }
            this.$rootScope.slatwall.authInfo.entity = data[0];
            this.$rootScope.slatwall.authInfo.action = data[1];
            
        },(error) =>{
          throw('could not get public role data');
        });
        return qPromise;
    }
    
    public getEntityData=()=>{
        var $http = this.$injector.get('$http');
        var deferred = this.$q.defer();
        $http.get(this.appConfig.baseURL+'/custom/system/permissions/entity.json')
        .success((response:any,status,headersGetter) => {
            deferred.resolve(response);
        }).error((response:any,status) => {
            deferred.reject(response);
        });
        return deferred.promise
    }
    
    public getActionData=()=>{
        var deferred = this.$q.defer();
        var $http = this.$injector.get('$http');
        $http.get(this.appConfig.baseURL+'/custom/system/permissions/action.json')
        .success((response:any,status,headersGetter) => {
            deferred.resolve(response);
        }).error((response:any,status) => {
            deferred.reject(response);
        });
        return deferred.promise
    }
    
    public getPermissionGroupsData = (permissionGroupIDs)=>{
        var permissionGroupIDArray = permissionGroupIDs.split(',');
        var permissionGroupPromises = [];
        for(let i in permissionGroupIDArray){
            var permissionGroupID = permissionGroupIDArray[i];
            var permissionGroupPromise = this.getPermissionGroupData(permissionGroupID);
            permissionGroupPromises.push(permissionGroupPromise);
        }
        
        var qPromise = this.$q.all(permissionGroupPromises).then((data) => {
            if(!this.$rootScope.slatwall.authInfo){
                this.$rootScope.slatwall.authInfo = {};
            }
            for(let i in permissionGroupIDArray){
                var permissionGroupID = permissionGroupIDArray[i];
                if(!this.$rootScope.slatwall.authInfo['permissionGroups']){
                    this.$rootScope.slatwall.authInfo['permissionGroups']={};
                }
                this.$rootScope.slatwall.authInfo['permissionGroups'][permissionGroupID]=data[i];
            }
            
            
            
        },(error) =>{
          throw('could not get public role data');
        });
        return qPromise;
    }
    
    public getPermissionGroupData = (permissionGroupID)=>{
        var deferred = this.$q.defer();
        var $http = this.$injector.get('$http');
        $http.get(this.appConfig.baseURL+'/custom/system/permissions/'+permissionGroupID+'.json')
        .success((response:any,status,headersGetter) => {
            deferred.resolve(response);
        }).error((response:any,status) => {
            deferred.reject(response);
        });
        return deferred.promise
    }

}
export {
    HibachiAuthenticationService
}