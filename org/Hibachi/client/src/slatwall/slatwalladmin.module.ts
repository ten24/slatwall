/// <reference path="../../typings/tsd.d.ts" />
/// <reference path="../../typings/slatwallTypeScript.d.ts" />
import {hibachimodule} from "../hibachi/hibachi.module";
import {SlatwallInterceptor,ISlatwall,ISlatwallConfig,SlatwallJQueryStatic} from "./services/slatwallinterceptor";
import {ngslatwallmodule} from "../ngslatwall/ngslatwall.module";
import {ngslatwallmodelmodule} from "../ngslatwallmodel/ngslatwallmodel.module";
import {contentmodule} from "../content/content.module";
import {giftcardmodule} from "../giftcard/giftcard.module";
import {optiongroupmodule} from "../optiongroup/optiongroup.module";
import {orderitemmodule} from "../orderitem/orderitem.module";
import {productmodule} from "../product/product.module";
import {productbundlemodule} from "../productbundle/productbundle.module";
import {workflowmodule} from "../workflow/workflow.module";
import {entitymodule} from "../entity/entity.module";
//filters
import {EntityRBKey} from "./filters/entityrbkey";
import {SWCurrency} from "./filters/swcurrency";

//declare variables out of scope
declare var slatwallAngular:any;
declare var $:SlatwallJQueryStatic;

var slatwalladminmodule = angular.module('slatwalladmin',[
  //Angular Modules
  'ngAnimate',
  'ngSanitize',
  //custom modules
  hibachimodule.name,
  ngslatwallmodule.name,
  ngslatwallmodelmodule.name,
  entitymodule.name,
  contentmodule.name,
  giftcardmodule.name, 
  optiongroupmodule.name,
  orderitemmodule.name,
  productmodule.name,
  productbundlemodule.name,
  workflowmodule.name,
  //3rdParty modules
  'ui.bootstrap'

])
.constant("baseURL", $.slatwall.getConfig().baseURL)
.config(["$provide",'$logProvider','$filterProvider','$httpProvider','$routeProvider','$injector','$locationProvider','datepickerConfig', 'datepickerPopupConfig','pathBuilderConfig',
     ($provide, $logProvider,$filterProvider,$httpProvider,$routeProvider,$injector,$locationProvider,datepickerConfig, datepickerPopupConfig,pathBuilderConfig) =>
  {
      //configure partials path properties
     pathBuilderConfig.setBaseURL($.slatwall.getConfig().baseURL);
     pathBuilderConfig.setBasePartialsPath('/org/Hibachi/client/src/');

     datepickerConfig.showWeeks = false;
     datepickerConfig.format = 'MMM dd, yyyy hh:mm a';
     datepickerPopupConfig.toggleWeeksText = null;
     if(slatwallAngular.hashbang){
         $locationProvider.html5Mode( false ).hashPrefix('!');
     }
     //
     //$provide.constant("baseURL", $.slatwall.getConfig().baseURL);


    //  var _partialsPath = $.slatwall.getConfig().baseURL + '/admin/client/partials/';

    //   $provide.constant("partialsPath", _partialsPath);
    //  $provide.constant("productBundlePartialsPath", _partialsPath+'productbundle/');


    //  angular.forEach(slatwallAngular.constantPaths, function(constantPath,key){
    //      var constantKey = constantPath.charAt(0).toLowerCase()+constantPath.slice(1)+'PartialsPath';
    //      var constantPartialsPath = _partialsPath+constantPath.toLowerCase()+'/';
    //      $provide.constant(constantKey, constantPartialsPath);
    //  });

     $logProvider.debugEnabled( $.slatwall.getConfig().debugFlag );
     $filterProvider.register('likeFilter',function(){
         return function(text){
             if(angular.isDefined(text) && angular.isString(text)){
                 return text.replace(new RegExp('%', 'g'), '');

             }
         };
     });

     $filterProvider.register('truncate',function(){
         return function (input, chars, breakOnWord) {
             if (isNaN(chars)) return input;
             if (chars <= 0) return '';
             if (input && input.length > chars) {
                 input = input.substring(0, chars);
                 if (!breakOnWord) {
                     var lastspace = input.lastIndexOf(' ');
                     //get last space
                     if (lastspace !== -1) {
                         input = input.substr(0, lastspace);
                     }
                 }else{
                     while(input.charAt(input.length-1) === ' '){
                         input = input.substr(0, input.length -1);
                     }
                 }
                 return input + '...';
             }
             return input;
         };
     });

     $httpProvider.interceptors.push('slatwallInterceptor');
     console.log($httpProvider.interceptors);
    console.log(hibachimodule);
     // route provider configuration


 }])
 .run(['$rootScope','$filter','$anchorScroll','$slatwall','dialogService','observerService','utilityService','pathBuilderConfig', ($rootScope,$filter,$anchorScroll,$slatwall,dialogService,observerService,utilityService,pathBuilderConfig) => {
        $anchorScroll.yOffset = 100;

        $rootScope.openPageDialog = function( partial ) {
            dialogService.addPageDialog( pathBuilderConfig.buildPartialsPath(partial) );
        };

        $rootScope.closePageDialog = function( index ) {
            dialogService.removePageDialog( index );
        };

        $rootScope.loadedResourceBundle = false;
        $rootScope.loadedResourceBundle = $slatwall.hasResourceBundle();
        $rootScope.buildUrl = $slatwall.buildUrl;
        $rootScope.createID = utilityService.createID;

        var rbListener = $rootScope.$watch('loadedResourceBundle',function(newValue,oldValue){
            if(newValue !== oldValue){
                $rootScope.$broadcast('hasResourceBundle');
                rbListener();
            }
        });

    }])
 //services
.service('slatwallInterceptor', SlatwallInterceptor.Factory())
//filters
.filter('entityRBKey',['$slatwall',EntityRBKey.Factory])
.filter('swcurrency',['$sce','$log','$slatwall',SWCurrency.Factory])
;
export{
    slatwalladminmodule,
    slatwallAngular
};
// ((): void => {

//     var app = angular.module('slatwalladmin', ['hibachi','ngSlatwall','ngSlatwallModel','ui.bootstrap','ngAnimate','ngRoute','ngSanitize','ngCkeditor']);
//     app.config(
//         ["$provide",'$logProvider','$filterProvider','$httpProvider','$routeProvider','$injector','$locationProvider','datepickerConfig', 'datepickerPopupConfig',
//         ($provide, $logProvider,$filterProvider,$httpProvider,$routeProvider,$injector,$locationProvider,datepickerConfig, datepickerPopupConfig) =>
//      {
//         datepickerConfig.showWeeks = false;
//         datepickerConfig.format = 'MMM dd, yyyy hh:mm a';
//             datepickerPopupConfig.toggleWeeksText = null;
//         if(slatwallAngular.hashbang){
//             $locationProvider.html5Mode( false ).hashPrefix('!');
//         }
//         //
//         $provide.constant("baseURL", $.slatwall.getConfig().baseURL);

//         var _partialsPath = $.slatwall.getConfig().baseURL + '/admin/client/partials/';

//         $provide.constant("partialsPath", _partialsPath);
//         $provide.constant("productBundlePartialsPath", _partialsPath+'productbundle/');


//         angular.forEach(slatwallAngular.constantPaths, function(constantPath,key){
//             var constantKey = constantPath.charAt(0).toLowerCase()+constantPath.slice(1)+'PartialsPath';
//             var constantPartialsPath = _partialsPath+constantPath.toLowerCase()+'/';
//             $provide.constant(constantKey, constantPartialsPath);
//         });

//         $logProvider.debugEnabled( $.slatwall.getConfig().debugFlag );
//         $filterProvider.register('likeFilter',function(){
//             return function(text){
//                 if(angular.isDefined(text) && angular.isString(text)){
//                     return text.replace(new RegExp('%', 'g'), '');

//                 }
//             };
//         });

//         $filterProvider.register('truncate',function(){
//             return function (input, chars, breakOnWord) {
//                 if (isNaN(chars)) return input;
//                 if (chars <= 0) return '';
//                 if (input && input.length > chars) {
//                     input = input.substring(0, chars);
//                     if (!breakOnWord) {
//                         var lastspace = input.lastIndexOf(' ');
//                         //get last space
//                         if (lastspace !== -1) {
//                             input = input.substr(0, lastspace);
//                         }
//                     }else{
//                         while(input.charAt(input.length-1) === ' '){
//                             input = input.substr(0, input.length -1);
//                         }
//                     }
//                     return input + '...';
//                 }
//                 return input;
//             };
//         });

//         $httpProvider.interceptors.push('slatwallInterceptor');

//         // route provider configuration
//         $routeProvider.when('/entity/:entityName/', {
//             template: function(params){
//                 var entityDirectiveExists = $injector.has('sw'+params.entityName+'ListDirective');
//                 if(entityDirectiveExists){
//                     return '<sw-'+params.entityName.toLowerCase()+'-list>';
//                 }else{
//                     return '<sw-list></sw-list>';
//                 }
//             },
//             controller: 'routerController'
//         }).when('/entity/:entityName/:entityID', {
//             template: function(params){
//                 var entityDirectiveExists = $injector.has('sw'+params.entityName+'DetailDirective');
//                 if(entityDirectiveExists){
//                     return '<sw-'+params.entityName.toLowerCase()+'-detail>';
//                 }else{
//                     return '<sw-detail></sw-detail>';
//                 }
//             },
//             controller: 'routerController',
//         }).otherwise({
//             //controller:'otherwiseController'
//             templateUrl: $.slatwall.getConfig().baseURL + '/admin/client/js/partials/otherwise.html',
//         });

//     }]).run(['$rootScope','$filter','$anchorScroll','$slatwall','dialogService','observerService','utilityService', ($rootScope,$filter,$anchorScroll,$slatwall,dialogService,observerService,utilityService) => {
//         $anchorScroll.yOffset = 100;

//         $rootScope.openPageDialog = function( partial ) {
//             dialogService.addPageDialog( partial );
//         };

//         $rootScope.closePageDialog = function( index ) {
//             dialogService.removePageDialog( index );
//         };

//         $rootScope.loadedResourceBundle = false;
//         $rootScope.loadedResourceBundle = $slatwall.hasResourceBundle();
//         $rootScope.buildUrl = $slatwall.buildUrl;
//         $rootScope.createID = utilityService.createID;

//         var rbListener = $rootScope.$watch('loadedResourceBundle',function(newValue,oldValue){
//             if(newValue !== oldValue){
//                 $rootScope.$broadcast('hasResourceBundle');
//                 rbListener();
//             }
//         });

//     }])
// })();
