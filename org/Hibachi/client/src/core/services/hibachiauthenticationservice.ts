/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class HibachiAuthenticationService{
    
    //@ngInject
    constructor(
       public $rootScope:any,
       public $q,
       public appConfig,
       public $injector
    ){
        
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
            console.log(data);
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
        console.log(permissionGroupIDs);
        var permissionGroupIDArray = permissionGroupIDs.split(',');
        var permissionGroupPromises = [];
        for(let i in permissionGroupIDArray){
            var permissionGroupID = permissionGroupIDArray[i];
            var permissionGroupPromise = this.getPermissionGroupData(permissionGroupID);
            permissionGroupPromises.push(permissionGroupPromise);
        }
        
        var qPromise = this.$q.all(permissionGroupPromises).then((data) => {
            console.log(data);
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