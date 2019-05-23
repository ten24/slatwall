class HibachiAuthenticationService{

    //@ngInject
    //@ngInject
    constructor(
       public $window:ng.IWindowService
    ){
        this.$window = $window;
    }
    /*
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
        var publicRoleDataPromises = [this.getEntityData(),this.getActionData()];
        return this.$q.all(publicRoleDataPromises).then((data) => {
            console.log('test',data);
        },(error) =>{
           throw('could not get public role data');
        });
    }
    
    public getEntityData=()=>{
        var deferred = this.$q.defer();
        this.$http.get(this.appConfig.baseURL+'/custom/system/permissions/entity.json')
        .success((response:any,status,headersGetter) => {
            deferred.resolve(response);
        }).error((response:any,status) => {
            deferred.reject(response);
        });
        return deferred.promise
    }
    
    public getActionData=()=>{
        var deferred = this.$q.defer();
        this.$http.get(this.appConfig.baseURL+'/custom/system/permissions/action.json')
        .success((response:any,status,headersGetter) => {
            deferred.resolve(response);
        }).error((response:any,status) => {
            deferred.reject(response);
        });;
        return deferred.promise
    }
    
    public getPermissionGroupData = ()=>{
        
    }*/

}
export {
    HibachiAuthenticationService
}