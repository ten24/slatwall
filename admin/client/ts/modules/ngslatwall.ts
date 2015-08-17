/// <reference path="../../../../client/typings/tsd.d.ts" />
/// <reference path="../../../../client/typings/slatwallTypeScript.d.ts" />
((): void => {
     var ngSlatwall = angular.module('ngSlatwall',[]);
    
})();
module ngSlatwall {
    export class $Slatwall{
        public _deferred;
        public _config;
        public resourceBundle;
        public _loadingResourceBundle;
        public _loadedResourceBundle;
        public _jsEntities;
        
        constructor(){
//            _deferred={};
//            _config={
//                dateFormat : 'MM/DD/YYYY',
//                timeFormat : 'HH:MM',
//                rbLocale : '',
//                baseURL : '/',
//                applicationKey : 'Slatwall',
//                debugFlag : true,
//                instantiationKey : '84552B2D-A049-4460-55F23F30FE7B26AD'
//            };
//           if(slatwallAngular.slatwallConfig){
//               angular.extend(this._config, slatwallAngular.slatwallConfig);
//           }
        }
        
        public static slatwallFactory(){
            setJsEntities = ():void =>{
                
            }
        }
        
        public $get(
            $q:ng.IQService,
            $http:ng.IHttpService,
            $timeout:ng.ITimeoutService,
            $log:ng.ILogService,
            $rootScope:ng.IRootScopeService,
            $location:ng.ILocationService,
            $anchorScroll:ng.IAnchorScrollService,
            utilityService:slatwalladmin.UtilityService,
            formService:slatwalladmin.FormService
        ) {
           return <any>$Slatwall.slatwallFactory.bind($Slatwall);
       }
        
    }
    angular.module('ngSlatwall').provider('$slatwall',$Slatwall);
   
}
        