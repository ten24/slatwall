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
    
    public getRoleBasedData=()=>{
        switch(this.getUserRole()){
            case 'superUser':
                //no data is required for this role and we can assume they have access to everything
                break;
            case 'admin':
                this.getPublicRoleData();
                this.getPermissionGroupData();
                break;
            case 'public':
                //only public data is required for this role and we can assume they have access to everything
                this.getPublicRoleData();
                break;
        }
    }
    
    public getPublicRoleData = ()=>{
        var entityPromise = this.getEntityData();
        var actionPromise = this.getActionData()
        var publicRoleDataPromises = [entityPromise,actionPromise];
        return this.$q.all(publicRoleDataPromises).then((data) => {
            this.$rootScope.slatwall.authInfo = data;
            
        },(error) =>{
          throw('could not get public role data');
        });
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
        });;
        return deferred.promise
    }
    
    public getPermissionGroupData = ()=>{
        
    }

}
export {
    HibachiAuthenticationService
}