/// <reference path='../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../typings/tsd.d.ts' />
//services
// import {AccountService} from "./services/accountservice";
// import {CartService} from "./services/cartservice";
// import {UtilityService} from "./services/utilityservice";
// import {SelectionService} from "./services/selectionservice";
// import {ObserverService} from "./services/observerservice";
// import {FormService} from "./services/formservice";
// import {MetaDataService} from "./services/metadataservice";
//controllers
import {OtherWiseController} from "./controllers/otherwisecontroller";
import {RouterController} from "./controllers/routercontroller";
//directives
import {SWDetailTabs} from "./components/swdetailtabs";
import {SWDetail} from "./components/swdetail";
import {SWList} from "./components/swlist";
import {coremodule} from "../core/core.module";

declare var $:any;

var entitymodule = angular.module('hibachi.entity',['ngRoute',coremodule.name])
.config(['$routeProvider','$injector','$locationProvider','appConfig',
($routeProvider,$injector,$locationProvider,appConfig)=>{
     //detect if we are in hashbang mode
     var vars:any = {};
     var parts:any = window.location.href.replace(/[?&]+([^=&]+)#([^/]*)/gi, (m:any,key:string,value:string):any=> {
        vars[key] = value;
     });

     if(vars.ng){
         $locationProvider.html5Mode( false ).hashPrefix('!');
     }
    
    $routeProvider.when('/entity/:entityName/', {
         template: function(params){
             var entityDirectiveExists = $injector.has('sw'+params.entityName+'ListDirective');
             if(entityDirectiveExists){
                 return '<sw-'+params.entityName.toLowerCase()+'-list>';
             }else{
                 return '<sw-list></sw-list>';
             }
         },
         controller: 'routerController'
     }).when('/entity/:entityName/:entityID', {
         template: function(params){
             var entityDirectiveExists = $injector.has('sw'+params.entityName+'DetailDirective');
             if(entityDirectiveExists){
                 return '<sw-'+params.entityName.toLowerCase()+'-detail>';
             }else{
                 return '<sw-detail></sw-detail>';
             }
         },
         controller: 'routerController',
     })
//        .otherwise({
//         //controller:'otherwiseController'
//         templateUrl: appConfig.baseURL + '/admin/client/js/partials/otherwise.html',
//     });
}])
.constant('coreEntityPartialsPath','entity/components/')
//services

//controllers
.controller('otherwiseController',OtherWiseController)
.controller('routerController',RouterController)
//filters

//directives
.directive('swDetail',SWDetail.Factory())
.directive('swDetailTabs',SWDetailTabs.Factory())
.directive('swList',SWList.Factory())
//components

;
export{
	entitymodule
}