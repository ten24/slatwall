/// <reference path="../../typings/tsd.d.ts" />
/// <reference path="../../typings/slatwallTypescript.d.ts" />
import {hibachimodule} from "../../../../org/Hibachi/client/src/hibachi/hibachi.module";
import {workflowmodule} from "../../../../org/Hibachi/client/src/workflow/workflow.module";
import {entitymodule} from "../../../../org/Hibachi/client/src/entity/entity.module";
import {contentmodule} from "../content/content.module";
import {formbuildermodule} from "../formbuilder/formbuilder.module";
import {giftcardmodule} from "../giftcard/giftcard.module";
import {optiongroupmodule} from "../optiongroup/optiongroup.module";
import {orderitemmodule} from "../orderitem/orderitem.module";
import {productmodule} from "../product/product.module";
import {productbundlemodule} from "../productbundle/productbundle.module";

//constant
import {SlatwallPathBuilder} from "./services/slatwallpathbuilder";

//directives
import {SWCurrencyFormatter} from "./components/swcurrencyformatter"
//filters

import {SWCurrency} from "./filters/swcurrency";

//declare variables out of scope
declare var $:any;

var slatwalladminmodule = angular.module('slatwalladmin',[
  //custom modules
  hibachimodule.name,
  entitymodule.name,
  contentmodule.name,
  formbuildermodule.name,
  giftcardmodule.name,
  optiongroupmodule.name,
  orderitemmodule.name,
  productmodule.name,
  productbundlemodule.name,
  workflowmodule.name
])
.constant("baseURL", $.slatwall.getConfig().baseURL)
.constant('slatwallPathBuilder', new SlatwallPathBuilder())
.config(["$provide",'$logProvider','$filterProvider','$httpProvider','$routeProvider','$injector','$locationProvider','datepickerConfig', 'datepickerPopupConfig','slatwallPathBuilder','appConfig',
     ($provide, $logProvider,$filterProvider,$httpProvider,$routeProvider,$injector,$locationProvider,datepickerConfig, datepickerPopupConfig,slatwallPathBuilder,appConfig) =>
  {
      //configure partials path properties
     slatwallPathBuilder.setBaseURL($.slatwall.getConfig().baseURL);
     slatwallPathBuilder.setBasePartialsPath('/admin/client/src/');

     datepickerConfig.showWeeks = false;
     datepickerConfig.format = 'MMM dd, yyyy hh:mm a';
     datepickerPopupConfig.toggleWeeksText = null;

     


     // route provider configuration


 }])
 .run(['$rootScope','$filter','$anchorScroll','$hibachi','dialogService','observerService','utilityService','slatwallPathBuilder', ($rootScope,$filter,$anchorScroll,$hibachi,dialogService,observerService,utilityService,slatwallPathBuilder) => {
        $anchorScroll.yOffset = 100;

        $rootScope.openPageDialog = function( partial ) {
            dialogService.addPageDialog( partial );
        };

        $rootScope.closePageDialog = function( index ) {
            dialogService.removePageDialog( index );
        };

        // $rootScope.loadedResourceBundle = false;
        // $rootScope.loadedResourceBundle = $hibachi.hasResourceBundle();
        $rootScope.createID = utilityService.createID;

        // var rbListener = $rootScope.$watch('loadedResourceBundle',function(newValue,oldValue){
        //     if(newValue !== oldValue){
        //         $rootScope.$broadcast('hasResourceBundle');
        //         rbListener();
        //     }
        // });

    }])
 //services
//directives
.directive('swCurrencyFormatter',SWCurrencyFormatter.Factory())
//filters

.filter('swcurrency',['$sce','$log','$hibachi',SWCurrency.Factory])

;
export{
    slatwalladminmodule
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

//     }]).run(['$rootScope','$filter','$anchorScroll','$hibachi','dialogService','observerService','utilityService', ($rootScope,$filter,$anchorScroll,$hibachi,dialogService,observerService,utilityService) => {
//         $anchorScroll.yOffset = 100;

//         $rootScope.openPageDialog = function( partial ) {
//             dialogService.addPageDialog( partial );
//         };

//         $rootScope.closePageDialog = function( index ) {
//             dialogService.removePageDialog( index );
//         };

//         $rootScope.loadedResourceBundle = false;
//         $rootScope.loadedResourceBundle = $hibachi.hasResourceBundle();
//         $rootScope.buildUrl = $hibachi.buildUrl;
//         $rootScope.createID = utilityService.createID;

//         var rbListener = $rootScope.$watch('loadedResourceBundle',function(newValue,oldValue){
//             if(newValue !== oldValue){
//                 $rootScope.$broadcast('hasResourceBundle');
//                 rbListener();
//             }
//         });

//     }])
// })();
