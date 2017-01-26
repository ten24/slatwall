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

        $rootScope.createID = utilityService.createID;

        $rootScope.slatwall = $rootScope.hibachiScope;
        $rootScope.slatwall.getProcessObject = $hibachi.newEntity;
    }])
 //services
//directives
.directive('swCurrencyFormatter',SWCurrencyFormatter.Factory())
//controllers
.controller('preprocessaccount_addaccountpayment', ['$scope', '$compile',function($scope:any, $compile) {
    //Define the different payment types used here
    var paymentType = {aptCharge:"444df32dd2b0583d59a19f1b77869025",aptCredit:"444df32e9b448ea196c18c66e1454c46", aptAdjustment:"68e3fb57d8102b47acc0003906d16ddd"};
    
    $scope.totalAmountToApply = 0; //Default value to show on new form
    $scope.paymentTypeName = $.slatwall.rbKey('define.charge'); //Default payment type
    $scope.paymentTypeLock = true; //Used to lock down the order payment type dropdowns
    $scope.amount = 0;
    
    $scope.updatePaymentType = function() {
        //Change all order payment types here
        angular.forEach($scope.appliedOrderPayment, function(obj, key) {
            //Only change the payment type if the type isn't adjustment'
            if($scope.paymentType!=paymentType.aptAdjustment)
                obj.paymentType=$scope.paymentType;
        });
        
        if($scope.paymentType==paymentType.aptCharge) {
            $scope.paymentTypeName = $.slatwall.rbKey('define.charge');
            $scope.paymentTypeLock = true;
        } else if($scope.paymentType==paymentType.aptCredit) {
            $scope.paymentTypeName = $.slatwall.rbKey('define.credit');
            $scope.paymentTypeLock = true;
        } else if($scope.paymentType==paymentType.aptAdjustment) {
            $scope.paymentTypeLock = false;
            $scope.paymentTypeName = $.slatwall.rbKey('define.adjustment');
            $scope.amount = 0;
        }
        
        //Update the subtotal now that we changed the payment type
        $scope.updateSubTotal();
    }

    $scope.updateSubTotal = function() {
        $scope.totalAmountToApply = 0; //Reset the subtotal before we loop
        
        //Loop through all the amount fields and create a running subtotal
        angular.forEach($scope.appliedOrderPayment, function(obj, key) {
            //Don't count the field if its undefied or not a number
            if(obj.amount != undefined && !isNaN(obj.amount)) {
                //Charge / adjustment condition for subtotal
                if($scope.paymentType==paymentType.aptCharge || $scope.paymentType == paymentType.aptAdjustment) {
                    if(obj.paymentType==paymentType.aptCharge)
                        $scope.totalAmountToApply += parseFloat(obj.amount);
                    else if(obj.paymentType==paymentType.aptCredit)
                        $scope.totalAmountToApply -= parseFloat(obj.amount);

                //Credit condition for subtotal
                } else if($scope.paymentType==paymentType.aptCredit) {
                    if(obj.paymentType==paymentType.aptCharge)
                        $scope.totalAmountToApply -= parseFloat(obj.amount);
                    else if(obj.paymentType==paymentType.aptCredit)
                        $scope.totalAmountToApply += parseFloat(obj.amount);
                }
            }
        });

        //The amount not applied to an order
        $scope.amountUnapplied = (Math.round(($scope.amount - $scope.totalAmountToApply) * 100) / 100);
        $scope.accountBalanceChange = parseFloat($scope.amount);
        
        //Switch the account balance display amount to a negative if you are doing a charge
        if($scope.paymentType==paymentType.aptCharge)
            $scope.accountBalanceChange = parseFloat($scope.accountBalanceChange * -1); //If charge, change to neg since we are lowering account balance
        else if($scope.paymentType==paymentType.aptAdjustment)
            $scope.accountBalanceChange += parseFloat($scope.amountUnapplied); //If adjustment, use the amount unapplied to determine the balance change
    }
}])
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
