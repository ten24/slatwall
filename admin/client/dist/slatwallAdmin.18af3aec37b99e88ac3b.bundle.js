/******/ (function(modules) { // webpackBootstrap
/******/ 	// install a JSONP callback for chunk loading
/******/ 	function webpackJsonpCallback(data) {
/******/ 		var chunkIds = data[0];
/******/ 		var moreModules = data[1];
/******/ 		var executeModules = data[2];
/******/
/******/ 		// add "moreModules" to the modules object,
/******/ 		// then flag all "chunkIds" as loaded and fire callback
/******/ 		var moduleId, chunkId, i = 0, resolves = [];
/******/ 		for(;i < chunkIds.length; i++) {
/******/ 			chunkId = chunkIds[i];
/******/ 			if(Object.prototype.hasOwnProperty.call(installedChunks, chunkId) && installedChunks[chunkId]) {
/******/ 				resolves.push(installedChunks[chunkId][0]);
/******/ 			}
/******/ 			installedChunks[chunkId] = 0;
/******/ 		}
/******/ 		for(moduleId in moreModules) {
/******/ 			if(Object.prototype.hasOwnProperty.call(moreModules, moduleId)) {
/******/ 				modules[moduleId] = moreModules[moduleId];
/******/ 			}
/******/ 		}
/******/ 		if(parentJsonpFunction) parentJsonpFunction(data);
/******/
/******/ 		while(resolves.length) {
/******/ 			resolves.shift()();
/******/ 		}
/******/
/******/ 		// add entry modules from loaded chunk to deferred list
/******/ 		deferredModules.push.apply(deferredModules, executeModules || []);
/******/
/******/ 		// run deferred modules when all chunks ready
/******/ 		return checkDeferredModules();
/******/ 	};
/******/ 	function checkDeferredModules() {
/******/ 		var result;
/******/ 		for(var i = 0; i < deferredModules.length; i++) {
/******/ 			var deferredModule = deferredModules[i];
/******/ 			var fulfilled = true;
/******/ 			for(var j = 1; j < deferredModule.length; j++) {
/******/ 				var depId = deferredModule[j];
/******/ 				if(installedChunks[depId] !== 0) fulfilled = false;
/******/ 			}
/******/ 			if(fulfilled) {
/******/ 				deferredModules.splice(i--, 1);
/******/ 				result = __webpack_require__(__webpack_require__.s = deferredModule[0]);
/******/ 			}
/******/ 		}
/******/
/******/ 		return result;
/******/ 	}
/******/
/******/ 	// The module cache
/******/ 	var installedModules = {};
/******/
/******/ 	// object to store loaded and loading chunks
/******/ 	// undefined = chunk not loaded, null = chunk preloaded/prefetched
/******/ 	// Promise = chunk loading, 0 = chunk loaded
/******/ 	var installedChunks = {
/******/ 		"slatwallAdmin": 0
/******/ 	};
/******/
/******/ 	var deferredModules = [];
/******/
/******/ 	// The require function
/******/ 	function __webpack_require__(moduleId) {
/******/
/******/ 		// Check if module is in cache
/******/ 		if(installedModules[moduleId]) {
/******/ 			return installedModules[moduleId].exports;
/******/ 		}
/******/ 		// Create a new module (and put it into the cache)
/******/ 		var module = installedModules[moduleId] = {
/******/ 			i: moduleId,
/******/ 			l: false,
/******/ 			exports: {}
/******/ 		};
/******/
/******/ 		// Execute the module function
/******/ 		modules[moduleId].call(module.exports, module, module.exports, __webpack_require__);
/******/
/******/ 		// Flag the module as loaded
/******/ 		module.l = true;
/******/
/******/ 		// Return the exports of the module
/******/ 		return module.exports;
/******/ 	}
/******/
/******/
/******/ 	// expose the modules object (__webpack_modules__)
/******/ 	__webpack_require__.m = modules;
/******/
/******/ 	// expose the module cache
/******/ 	__webpack_require__.c = installedModules;
/******/
/******/ 	// define getter function for harmony exports
/******/ 	__webpack_require__.d = function(exports, name, getter) {
/******/ 		if(!__webpack_require__.o(exports, name)) {
/******/ 			Object.defineProperty(exports, name, { enumerable: true, get: getter });
/******/ 		}
/******/ 	};
/******/
/******/ 	// define __esModule on exports
/******/ 	__webpack_require__.r = function(exports) {
/******/ 		if(typeof Symbol !== 'undefined' && Symbol.toStringTag) {
/******/ 			Object.defineProperty(exports, Symbol.toStringTag, { value: 'Module' });
/******/ 		}
/******/ 		Object.defineProperty(exports, '__esModule', { value: true });
/******/ 	};
/******/
/******/ 	// create a fake namespace object
/******/ 	// mode & 1: value is a module id, require it
/******/ 	// mode & 2: merge all properties of value into the ns
/******/ 	// mode & 4: return value when already ns object
/******/ 	// mode & 8|1: behave like require
/******/ 	__webpack_require__.t = function(value, mode) {
/******/ 		if(mode & 1) value = __webpack_require__(value);
/******/ 		if(mode & 8) return value;
/******/ 		if((mode & 4) && typeof value === 'object' && value && value.__esModule) return value;
/******/ 		var ns = Object.create(null);
/******/ 		__webpack_require__.r(ns);
/******/ 		Object.defineProperty(ns, 'default', { enumerable: true, value: value });
/******/ 		if(mode & 2 && typeof value != 'string') for(var key in value) __webpack_require__.d(ns, key, function(key) { return value[key]; }.bind(null, key));
/******/ 		return ns;
/******/ 	};
/******/
/******/ 	// getDefaultExport function for compatibility with non-harmony modules
/******/ 	__webpack_require__.n = function(module) {
/******/ 		var getter = module && module.__esModule ?
/******/ 			function getDefault() { return module['default']; } :
/******/ 			function getModuleExports() { return module; };
/******/ 		__webpack_require__.d(getter, 'a', getter);
/******/ 		return getter;
/******/ 	};
/******/
/******/ 	// Object.prototype.hasOwnProperty.call
/******/ 	__webpack_require__.o = function(object, property) { return Object.prototype.hasOwnProperty.call(object, property); };
/******/
/******/ 	// __webpack_public_path__
/******/ 	__webpack_require__.p = "";
/******/
/******/ 	var jsonpArray = window["webpackJsonp"] = window["webpackJsonp"] || [];
/******/ 	var oldJsonpFunction = jsonpArray.push.bind(jsonpArray);
/******/ 	jsonpArray.push = webpackJsonpCallback;
/******/ 	jsonpArray = jsonpArray.slice();
/******/ 	for(var i = 0; i < jsonpArray.length; i++) webpackJsonpCallback(jsonpArray[i]);
/******/ 	var parentJsonpFunction = oldJsonpFunction;
/******/
/******/
/******/ 	// add entry module to deferred list
/******/ 	deferredModules.push([0,"slatwallAdminVendor","hibachiAdmin"]);
/******/ 	// run deferred modules when ready
/******/ 	return checkDeferredModules();
/******/ })
/************************************************************************/
/******/ ({

/***/ "//ZH":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
exports.slatwalladminmodule = void 0;
/// <reference path="../../typings/tsd.d.ts" />
/// <reference path="../../typings/slatwallTypescript.d.ts" />
var hibachi_module_1 = __webpack_require__("LX6P");
var workflow_module_1 = __webpack_require__("nsTM");
var collection_module_1 = __webpack_require__("ckC0");
var listing_module_1 = __webpack_require__("9Z1j");
var card_module_1 = __webpack_require__("EUGx");
var account_module_1 = __webpack_require__("HEII");
var address_module_1 = __webpack_require__("NsNA");
var content_module_1 = __webpack_require__("aVY8");
var formbuilder_module_1 = __webpack_require__("FQTS");
var giftcard_module_1 = __webpack_require__("wXpQ");
var optiongroup_module_1 = __webpack_require__("SDCo");
var orderitem_module_1 = __webpack_require__("aPIn");
var orderfulfillment_module_1 = __webpack_require__("/SnR");
var fulfillmentbatchdetail_module_1 = __webpack_require__("GWu+");
var orderdeliverydetail_module_1 = __webpack_require__("uiTr");
var order_module_1 = __webpack_require__("jDc/");
var product_module_1 = __webpack_require__("iC/t");
var productbundle_module_1 = __webpack_require__("lEbT");
var site_module_1 = __webpack_require__("wbyE");
var sku_module_1 = __webpack_require__("wEhO");
var subscriptionusage_module_1 = __webpack_require__("UX9i");
var term_module_1 = __webpack_require__("K6E2");
//constant
var slatwallpathbuilder_1 = __webpack_require__("t8vH");
//filters
//pace-js
var pace = __webpack_require__("r6bc");
pace.start();
var slatwalladminmodule = angular.module('slatwalladmin', [
    // core modules
    hibachi_module_1.hibachimodule.name,
    workflow_module_1.workflowmodule.name,
    collection_module_1.collectionmodule.name,
    listing_module_1.listingmodule.name,
    card_module_1.cardmodule.name,
    //custom modules
    account_module_1.accountmodule.name,
    address_module_1.addressmodule.name,
    content_module_1.contentmodule.name,
    formbuilder_module_1.formbuildermodule.name,
    giftcard_module_1.giftcardmodule.name,
    optiongroup_module_1.optiongroupmodule.name,
    orderitem_module_1.orderitemmodule.name,
    orderfulfillment_module_1.orderfulfillmentmodule.name,
    fulfillmentbatchdetail_module_1.fulfillmentbatchdetailmodule.name,
    orderdeliverydetail_module_1.orderdeliverydetailmodule.name,
    order_module_1.ordermodule.name,
    product_module_1.productmodule.name,
    productbundle_module_1.productbundlemodule.name,
    site_module_1.sitemodule.name,
    sku_module_1.skumodule.name,
    subscriptionusage_module_1.subscriptionusagemodule.name,
    term_module_1.termmodule.name
])
    .constant("baseURL", $.slatwall.getConfig().baseURL)
    .constant('slatwallPathBuilder', new slatwallpathbuilder_1.SlatwallPathBuilder())
    .constant('isAdmin', true)
    .config(["$provide", '$logProvider', '$filterProvider', '$httpProvider', '$routeProvider', '$injector', '$locationProvider', 'datepickerConfig', 'datepickerPopupConfig', 'slatwallPathBuilder', 'appConfig', function ($provide, $logProvider, $filterProvider, $httpProvider, $routeProvider, $injector, $locationProvider, datepickerConfig, datepickerPopupConfig, slatwallPathBuilder, appConfig) {
        //configure partials path properties
        slatwallPathBuilder.setBaseURL($.slatwall.getConfig().baseURL);
        slatwallPathBuilder.setBasePartialsPath('/admin/client/src/');
        datepickerConfig.showWeeks = false;
        datepickerConfig.format = 'MMM dd, yyyy hh:mm a';
        datepickerPopupConfig.toggleWeeksText = null;
        // route provider configuration
    }])
    .run(['$rootScope', '$filter', '$anchorScroll', '$hibachi', 'dialogService', 'observerService', 'utilityService', 'slatwallPathBuilder', function ($rootScope, $filter, $anchorScroll, $hibachi, dialogService, observerService, utilityService, slatwallPathBuilder) {
        $anchorScroll.yOffset = 100;
        $rootScope.openPageDialog = function (partial) {
            dialogService.addPageDialog(partial);
        };
        $rootScope.closePageDialog = function (index) {
            dialogService.removePageDialog(index);
        };
        $rootScope.createID = utilityService.createID;
        $rootScope.slatwall = $rootScope.hibachiScope;
        $rootScope.slatwall.getProcessObject = $hibachi.newEntity;
    }])
    //services
    //directives
    //controllers
    .controller('preprocessaccount_addaccountpayment', ['$scope', '$compile', function ($scope, $compile) {
        //Define the different payment types used here
        var paymentType = { aptCharge: "444df32dd2b0583d59a19f1b77869025", aptCredit: "444df32e9b448ea196c18c66e1454c46", aptAdjustment: "68e3fb57d8102b47acc0003906d16ddd" };
        $scope.totalAmountToApply = 0; //Default value to show on new form
        $scope.paymentTypeName = $.slatwall.rbKey('define.charge'); //Default payment type
        $scope.paymentTypeLock = true; //Used to lock down the order payment type dropdowns
        $scope.amount = 0;
        $scope.updatePaymentType = function () {
            //Change all order payment types here
            angular.forEach($scope.appliedOrderPayment, function (obj, key) {
                //Only change the payment type if the type isn't adjustment'
                if ($scope.paymentType != paymentType.aptAdjustment)
                    obj.paymentType = $scope.paymentType;
            });
            if ($scope.paymentType == paymentType.aptCharge) {
                $scope.paymentTypeName = $.slatwall.rbKey('define.charge');
                $scope.paymentTypeLock = true;
            }
            else if ($scope.paymentType == paymentType.aptCredit) {
                $scope.paymentTypeName = $.slatwall.rbKey('define.credit');
                $scope.paymentTypeLock = true;
            }
            else if ($scope.paymentType == paymentType.aptAdjustment) {
                $scope.paymentTypeLock = false;
                $scope.paymentTypeName = $.slatwall.rbKey('define.adjustment');
                $scope.amount = 0;
            }
            //Update the subtotal now that we changed the payment type
            $scope.updateSubTotal();
        };
        $scope.updateSubTotal = function () {
            $scope.totalAmountToApply = 0; //Reset the subtotal before we loop
            //Loop through all the amount fields and create a running subtotal
            angular.forEach($scope.appliedOrderPayment, function (obj, key) {
                //Don't count the field if its undefied or not a number
                if (obj.amount != undefined && !isNaN(obj.amount)) {
                    //Charge / adjustment condition for subtotal
                    if ($scope.paymentType == paymentType.aptCharge) {
                        $scope.totalAmountToApply += parseFloat(obj.amount);
                        //Credit condition for subtotal
                    }
                    else if ($scope.paymentType == paymentType.aptCredit) {
                        $scope.totalAmountToApply -= parseFloat(obj.amount);
                    }
                    else if ($scope.paymentType == paymentType.aptAdjustment) {
                        if (obj.paymentType == paymentType.aptCharge) {
                            $scope.totalAmountToApply += parseFloat(obj.amount);
                        }
                        else if (obj.paymentType == paymentType.aptCredit) {
                            $scope.totalAmountToApply -= parseFloat(obj.amount);
                        }
                    }
                }
            });
            //The amount not applied to an order
            $scope.amountUnapplied = (Math.round(($scope.amount - $scope.totalAmountToApply + $scope.amountUnassigned) * 100) / 100);
            $scope.accountBalanceChange = parseFloat($scope.amount);
            //Switch the account balance display amount to a negative if you are doing a charge
            if ($scope.paymentType == paymentType.aptCharge)
                $scope.accountBalanceChange = parseFloat(($scope.accountBalanceChange * -1).toString()); //If charge, change to neg since we are lowering account balance
            else if ($scope.paymentType == paymentType.aptAdjustment)
                $scope.accountBalanceChange += parseFloat($scope.amountUnapplied); //If adjustment, use the amount unapplied to determine the balance change
        };
    }]);
exports.slatwalladminmodule = slatwalladminmodule;
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


/***/ }),

/***/ "/SnR":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
exports.orderfulfillmentmodule = void 0;
/// <reference path='../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../typings/tsd.d.ts' />
//modules
var core_module_1 = __webpack_require__("pwA0");
//services
var orderfulfillmentservice_1 = __webpack_require__("PDZZ");
//controllers
//directives
var sworderfulfillmentlist_1 = __webpack_require__("kZ4t");
//models 
var orderfulfillmentmodule = angular.module('orderFulfillment', [core_module_1.coremodule.name])
    .config([function () {
    }]).run([function () {
    }])
    //constants
    .constant('orderFulfillmentPartialsPath', 'orderfulfillment/components/')
    //services
    .service('orderFulfillmentService', orderfulfillmentservice_1.OrderFulfillmentService)
    //controllers
    //directives
    .directive('swOrderFulfillmentList', sworderfulfillmentlist_1.SWOrderFulfillmentList.Factory());
exports.orderfulfillmentmodule = orderfulfillmentmodule;


/***/ }),

/***/ 0:
/***/ (function(module, exports, __webpack_require__) {

module.exports = __webpack_require__("63UH");


/***/ }),

/***/ "0BnN":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
exports.SWResizedImage = void 0;
/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
var SWResizedImage = /** @class */ (function () {
    function SWResizedImage($http, $log, $q, $hibachi, orderItemPartialsPath, slatwallPathBuilder) {
        return {
            restrict: 'E',
            scope: {
                orderItem: "=",
            },
            templateUrl: slatwallPathBuilder.buildPartialsPath(orderItemPartialsPath) + "orderitem-image.html",
            link: function (scope, element, attrs) {
                var profileName = attrs.profilename;
                var skuID = scope.orderItem.data.sku.data.skuID;
                //Get the template.
                //Call slatwallService to get the path from the image.
                $hibachi.getResizedImageByProfileName(profileName, skuID)
                    .then(function (response) {
                    $log.debug(response.resizedImagePaths[0]);
                    scope.orderItem.imagePath = response.resizedImagePaths[0];
                });
            }
        };
    }
    SWResizedImage.Factory = function () {
        var directive = function ($http, $log, $q, $hibachi, orderItemPartialsPath, slatwallPathBuilder) { return new SWResizedImage($http, $log, $q, $hibachi, orderItemPartialsPath, slatwallPathBuilder); };
        directive.$inject = [
            '$http', '$log', '$q', '$hibachi', 'orderItemPartialsPath',
            'slatwallPathBuilder'
        ];
        return directive;
    };
    return SWResizedImage;
}());
exports.SWResizedImage = SWResizedImage;


/***/ }),

/***/ "0JmH":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
exports.SWAddOrderItemGiftRecipient = exports.SWAddOrderItemRecipientController = void 0;
/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
var giftrecipient_1 = __webpack_require__("XMpE");
var SWAddOrderItemRecipientController = /** @class */ (function () {
    //@ngInject
    SWAddOrderItemRecipientController.$inject = ["$hibachi", "collectionConfigService", "entityService", "observerService"];
    function SWAddOrderItemRecipientController($hibachi, collectionConfigService, entityService, observerService) {
        var _this = this;
        this.$hibachi = $hibachi;
        this.collectionConfigService = collectionConfigService;
        this.entityService = entityService;
        this.observerService = observerService;
        this.unassignedCountArray = [];
        this.addGiftRecipientFromAccountList = function (account) {
            var giftRecipient = new giftrecipient_1.GiftRecipient();
            giftRecipient.firstName = account.firstName;
            giftRecipient.lastName = account.lastName;
            giftRecipient.emailAddress = account.primaryEmailAddress_emailAddress;
            giftRecipient.account = true;
            _this.orderItemGiftRecipients.push(giftRecipient);
            _this.searchText = "";
        };
        this.getUnassignedCountArray = function () {
            if (_this.getUnassignedCount() < _this.unassignedCountArray.length) {
                _this.unassignedCountArray.splice(_this.getUnassignedCount(), _this.unassignedCountArray.length);
            }
            if (_this.getUnassignedCount() > _this.unassignedCountArray.length) {
                for (var i = _this.unassignedCountArray.length + 1; i <= _this.getUnassignedCount(); i++) {
                    _this.unassignedCountArray.push({ name: i, value: i });
                }
            }
            return _this.unassignedCountArray;
        };
        this.getAssignedCount = function () {
            _this.assignedCount = 0;
            angular.forEach(_this.orderItemGiftRecipients, function (orderItemGiftRecipient) {
                _this.assignedCount += orderItemGiftRecipient.quantity;
            });
            return _this.assignedCount;
        };
        this.getUnassignedCount = function () {
            _this.unassignedCount = _this.quantity;
            angular.forEach(_this.orderItemGiftRecipients, function (orderItemGiftRecipient) {
                _this.unassignedCount -= orderItemGiftRecipient.quantity;
            });
            return _this.unassignedCount;
        };
        this.addGiftRecipient = function () {
            if (_this.currentGiftRecipient.forms.createRecipient.$valid) {
                _this.observerService.notify('updateBindings').then(function () {
                    _this.showInvalidAddFormMessage = true;
                    _this.adding = false;
                    var giftRecipient = new giftrecipient_1.GiftRecipient();
                    angular.extend(giftRecipient, _this.currentGiftRecipient.data);
                    _this.orderItemGiftRecipients.push(giftRecipient);
                    _this.searchText = "";
                    _this.currentGiftRecipient = _this.entityService.newEntity("OrderItemGiftRecipient");
                });
            }
            else {
                _this.showInvalidAddFormMessage = true;
            }
        };
        this.cancelAddRecipient = function () {
            _this.adding = false;
            _this.currentGiftRecipient.reset();
            _this.searchText = "";
            _this.showInvalidAddFormMessage = false;
        };
        this.startFormWithName = function (searchString) {
            if (searchString === void 0) { searchString = _this.searchText; }
            _this.adding = !_this.adding;
            if (_this.adding) {
                _this.currentGiftRecipient.forms.createRecipient.$setUntouched();
                _this.currentGiftRecipient.forms.createRecipient.$setPristine();
                if (searchString != "") {
                    _this.currentGiftRecipient.firstName = searchString;
                    _this.searchText = "";
                }
            }
        };
        this.getTotalQuantity = function () {
            var totalQuantity = 0;
            angular.forEach(_this.orderItemGiftRecipients, function (orderItemGiftRecipient) {
                totalQuantity += orderItemGiftRecipient.quantity;
            });
            return totalQuantity;
        };
        this.getMessageCharactersLeft = function () {
            if (_this.currentGiftRecipient.giftMessage && _this.currentGiftRecipient.giftMessage != null) {
                return 250 - _this.currentGiftRecipient.giftMessage.length;
            }
            else {
                return 250;
            }
        };
        if (angular.isUndefined(this.adding)) {
            this.adding = false;
        }
        if (angular.isUndefined(this.assignedCount)) {
            this.assignedCount = 0;
        }
        if (angular.isUndefined(this.searchText)) {
            this.searchText = "";
        }
        var count = 1;
        this.currentGiftRecipient = this.entityService.newEntity("OrderItemGiftRecipient");
        if (angular.isUndefined(this.orderItemGiftRecipients)) {
            this.orderItemGiftRecipients = [];
        }
        if (angular.isUndefined(this.showInvalidAddFormMessage)) {
            this.showInvalidAddFormMessage = false;
        }
        this.typeaheadCollectionConfig = collectionConfigService.newCollectionConfig('Account');
        this.typeaheadCollectionConfig.addDisplayProperty("accountID,firstName,lastName,primaryEmailAddress.emailAddress");
        this.typeaheadCollectionConfig.addFilter("primaryEmailAddress", "null", "is not");
    }
    return SWAddOrderItemRecipientController;
}());
exports.SWAddOrderItemRecipientController = SWAddOrderItemRecipientController;
var SWAddOrderItemGiftRecipient = /** @class */ (function () {
    function SWAddOrderItemGiftRecipient($hibachi, giftCardPartialsPath, slatwallPathBuilder) {
        this.$hibachi = $hibachi;
        this.giftCardPartialsPath = giftCardPartialsPath;
        this.slatwallPathBuilder = slatwallPathBuilder;
        this.require = "^form";
        this.restrict = "EA";
        this.transclude = true;
        this.scope = {};
        this.bindToController = {
            "quantity": "=?",
            "orderItemGiftRecipients": "=?",
            "adding": "=?",
            "searchText": "=?",
            "currentgiftRecipient": "=?",
            "showInvalidAddFormMessage": "=?",
            "showInvalidRowMessage": "=?",
            "tableForm": "=?",
            "recipientAddForm": "=?"
        };
        this.controller = SWAddOrderItemRecipientController;
        this.controllerAs = "addGiftRecipientControl";
        this.link = function ($scope, element, attrs) {
        };
        this.templateUrl = slatwallPathBuilder.buildPartialsPath(giftCardPartialsPath) + "/addorderitemgiftrecipient.html";
    }
    SWAddOrderItemGiftRecipient.Factory = function () {
        var directive = function ($hibachi, giftCardPartialsPath, slatwallPathBuilder) { return new SWAddOrderItemGiftRecipient($hibachi, giftCardPartialsPath, slatwallPathBuilder); };
        directive.$inject = [
            '$hibachi',
            'giftCardPartialsPath',
            'slatwallPathBuilder'
        ];
        return directive;
    };
    SWAddOrderItemGiftRecipient.$inject = ["$hibachi"];
    return SWAddOrderItemGiftRecipient;
}());
exports.SWAddOrderItemGiftRecipient = SWAddOrderItemGiftRecipient;


/***/ }),

/***/ "1uds":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
exports.OrderTemplateService = void 0;
/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
var OrderTemplateService = /** @class */ (function () {
    //@ngInject
    OrderTemplateService.$inject = ["$http", "$q", "$hibachi", "entityService", "cacheService", "collectionConfigService", "observerService", "rbkeyService", "requestService", "utilityService", "alertService"];
    function OrderTemplateService($http, $q, $hibachi, entityService, cacheService, collectionConfigService, observerService, rbkeyService, requestService, utilityService, alertService) {
        var _this = this;
        this.$http = $http;
        this.$q = $q;
        this.$hibachi = $hibachi;
        this.entityService = entityService;
        this.cacheService = cacheService;
        this.collectionConfigService = collectionConfigService;
        this.observerService = observerService;
        this.rbkeyService = rbkeyService;
        this.requestService = requestService;
        this.utilityService = utilityService;
        this.alertService = alertService;
        this.orderTemplatePropertyIdentifierList = 'subtotal,total,fulfillmentTotal,fulfillmentDiscount';
        this.orderTemplateItemPropertyIdentifierList = ''; //this get's programitically set
        this.editablePropertyIdentifierList = '';
        this.searchablePropertyIdentifierList = 'skuCode';
        this.pricePropertyIdentfierList = 'priceByCurrencyCode,total';
        this.viewAndEditOrderTemplateItemsInitialized = false;
        this.defaultColumnConfig = {
            isVisible: true,
            isSearchable: false,
            isDeletable: true,
            isEditable: false
        };
        this.editColumnConfig = {
            isVisible: true,
            isSearchable: false,
            isDeletable: true,
            isEditable: true
        };
        this.searchableColumnConfig = {
            isVisible: true,
            isSearchable: true,
            isDeletable: true,
            isEditable: false
        };
        this.nonVisibleColumnConfig = {
            isVisible: false,
            isSearchable: false,
            isDeletable: false,
            isEditable: false
        };
        this.priceColumnConfig = {
            isVisible: true,
            isSearchable: false,
            isDeletable: false,
            isEditable: false
        };
        this.initializeViewAndEditOrderTemplateItemsCollection = function (collectionType) {
            if (_this.viewAndEditOrderTemplateItemsInitialized) {
                switch (collectionType) {
                    case 'view':
                        return _this.viewOrderTemplateItemsCollection;
                    case 'edit':
                        return _this.editOrderTemplateItemsCollection;
                    default:
                        return;
                }
            }
            for (var i = 0; i < _this.orderTemplateDisplayProperties.length; i++) {
                var columnConfig = _this.getColumnConfigForSkuOrOrderTemplateItemPropertyIdentifier(_this.orderTemplateDisplayProperties[i], i, _this.originalOrderTemplatePropertyLength);
                _this.editOrderTemplateItemsCollection.addDisplayProperty(_this.orderTemplateDisplayProperties[i], '', columnConfig);
                columnConfig.isEditable = false; //we never need editable columns in the view config
                _this.viewOrderTemplateItemsCollection.addDisplayProperty(_this.orderTemplateDisplayProperties[i], '', columnConfig);
            }
            _this.viewOrderTemplateItemsCollection.addDisplayProperty('orderTemplateItemID', '', _this.nonVisibleColumnConfig);
            _this.viewOrderTemplateItemsCollection.addFilter('orderTemplate.orderTemplateID', _this.orderTemplate.orderTemplateID, '=', undefined, true);
            _this.viewOrderTemplateItemsCollection.addDisplayProperty('quantity', _this.rbkeyService.rbKey('entity.OrderTemplateItem.quantity'), _this.editColumnConfig);
            _this.editOrderTemplateItemsCollection.addDisplayProperty('orderTemplateItemID', '', _this.nonVisibleColumnConfig);
            _this.editOrderTemplateItemsCollection.addDisplayProperty('quantity', _this.rbkeyService.rbKey('entity.OrderTemplateItem.quantity'), _this.defaultColumnConfig);
            _this.editOrderTemplateItemsCollection.addFilter('orderTemplate.orderTemplateID', _this.orderTemplate.orderTemplateID, '=', undefined, true);
            _this.viewAndEditOrderTemplateItemsInitialized = true;
            switch (collectionType) {
                case 'view':
                    return _this.viewOrderTemplateItemsCollection;
                case 'edit':
                    return _this.editOrderTemplateItemsCollection;
                default:
                    return;
            }
        };
        this.initializeAddSkuCollection = function (addSkuCollection, includePrice) {
            if (includePrice === void 0) { includePrice = true; }
            if (_this.addSkuIntialized && addSkuCollection == null) {
                return _this.addSkuCollection;
            }
            if (addSkuCollection == null) {
                var addSkuCollection = _this.addSkuCollection;
            }
            for (var j = 0; j < _this.skuDisplayProperties.length; j++) {
                if (!includePrice && _this.pricePropertyIdentfierList.indexOf(_this.skuDisplayProperties[j]) !== -1) {
                    continue;
                }
                var columnConfig = _this.getColumnConfigForSkuOrOrderTemplateItemPropertyIdentifier(_this.skuDisplayProperties[j], j, _this.originalSkuDisplayPropertyLength);
                addSkuCollection.addDisplayProperty(_this.skuDisplayProperties[j], '', columnConfig);
            }
            addSkuCollection.addDisplayProperty('skuID', '', _this.nonVisibleColumnConfig);
            if (addSkuCollection == null) {
                addSkuCollection.addFilter('activeFlag', true, '=', undefined, true);
                addSkuCollection.addFilter('publishedFlag', true, '=', undefined, true);
                addSkuCollection.addFilter('product.activeFlag', true, '=', undefined, true);
                addSkuCollection.addFilter('product.publishedFlag', true, '=', undefined, true);
            }
            _this.addSkuIntialized = true;
            return addSkuCollection;
        };
        this.setAdditionalOrderTemplateItemPropertiesToDisplay = function (additionalOrderTemplateItemPropertiesToDisplay) {
            _this.orderTemplateItemPropertyIdentifierList.concat(additionalOrderTemplateItemPropertiesToDisplay.split(','));
        };
        this.getViewOrderTemplateItemCollection = function () {
            return _this.initializeViewAndEditOrderTemplateItemsCollection('view');
        };
        this.getEditOrderTemplateItemCollection = function () {
            return _this.initializeViewAndEditOrderTemplateItemsCollection('edit');
        };
        this.getAddSkuCollection = function (addSkuCollection, includePrice) {
            if (includePrice === void 0) { includePrice = true; }
            return _this.initializeAddSkuCollection(addSkuCollection, includePrice);
        };
        this.setOrderTemplateID = function (orderTemplateID) {
            _this.orderTemplateID = orderTemplateID;
        };
        this.setOrderTemplate = function (orderTemplate) {
            _this.orderTemplate = orderTemplate;
            _this.setOrderTemplateID(orderTemplate.orderTemplateID);
            _this.priceColumnConfig['arguments'] = {
                'currencyCode': orderTemplate.currencyCode,
                'accountID': orderTemplate.account_accountID
            };
        };
        this.setAdditionalSkuPropertiesToDisplay = function (skuPropertiesToDisplay) {
            _this.additionalSkuPropertiesToDisplay = skuPropertiesToDisplay;
            var properties = _this.additionalSkuPropertiesToDisplay.split(',');
            for (var i = 0; i < properties.length; i++) {
                _this.orderTemplateDisplayProperties.push("sku." + properties[i]);
                _this.skuDisplayProperties.push(properties[i]);
            }
        };
        this.setSkuPropertyColumnConfigs = function (skuPropertyColumnConfigs) {
            _this.skuPropertyColumnConfigs = skuPropertyColumnConfigs;
        };
        this.refreshListing = function (listingID) {
            var state = {
                type: 'setCurrentPage',
                payload: 1
            };
            _this.observerService.notifyById('swPaginationAction', listingID, state);
        };
        this.refreshOrderTemplateItemListing = function () {
            _this.refreshListing('OrderTemplateDetailOrderItems');
        };
        this.refreshOrderTemplatePromotionListing = function () {
            _this.refreshListing('orderTemplatePromotions');
        };
        this.refreshOrderTemplateGiftCardListing = function () {
            _this.refreshListing('orderTemplateGiftCards');
        };
        this.setOrderTemplatePropertyIdentifierList = function (orderTemplatePropertyIdentifierList) {
            _this.orderTemplatePropertyIdentifierList = _this.setOrderTemplateItemPropertyIdentifierList(orderTemplatePropertyIdentifierList);
        };
        this.setOrderTemplateItemPropertyIdentifierList = function (orderTemplatePropertyIdentifierList) {
            var propsToAdd = orderTemplatePropertyIdentifierList.split(',');
            if (_this.orderTemplateItemPropertyIdentifierList == null) {
                _this.orderTemplateItemPropertyIdentifierList = '';
            }
            for (var i = 0; i < propsToAdd.length; i++) {
                _this.orderTemplateItemPropertyIdentifierList += 'orderTemplate.' + propsToAdd[i];
                if (i + 1 !== propsToAdd.length)
                    _this.orderTemplateItemPropertyIdentifierList += ',';
            }
            return orderTemplatePropertyIdentifierList;
        };
        this.getColumnConfigForSkuOrOrderTemplateItemPropertyIdentifier = function (propertyIdentifier, index, originalLength) {
            var lastProperty = _this.$hibachi.getLastPropertyNameInPropertyIdentifier(propertyIdentifier);
            if (_this.editablePropertyIdentifierList.indexOf(lastProperty) !== -1) {
                var columnConfig = angular.copy(_this.editColumnConfig);
                if (_this.searchablePropertyIdentifierList.indexOf(lastProperty) !== -1) {
                    columnConfig.isSearchable = true;
                }
                return columnConfig;
            }
            else if (_this.pricePropertyIdentfierList.indexOf(lastProperty) !== -1) {
                return angular.copy(_this.priceColumnConfig);
            }
            else if (_this.searchablePropertyIdentifierList.indexOf(lastProperty) !== -1) {
                return angular.copy(_this.searchableColumnConfig);
            }
            else if (index + 1 > originalLength && (index - originalLength) < _this.skuPropertyColumnConfigs.length) {
                return angular.copy(_this.skuPropertyColumnConfigs[index - originalLength]);
            }
            else {
                return angular.copy(_this.defaultColumnConfig);
            }
        };
        this.addOrderTemplateItem = function (state) {
            if (isNaN(parseFloat(state.priceByCurrencyCode))) {
                var alert = _this.alertService.newAlert();
                alert.msg = _this.rbkeyService.rbKey("validate.processOrder_addOrderitem.price.notIsDefined");
                alert.type = "error";
                alert.fade = true;
                _this.alertService.addAlert(alert);
                _this.observerService.notify("addOrderItemStopLoading", {});
                return;
            }
            var formDataToPost = {
                entityID: _this.orderTemplateID,
                entityName: 'OrderTemplate',
                context: 'addOrderTemplateItem',
                propertyIdentifiersList: _this.orderTemplatePropertyIdentifierList,
                skuID: state.skuID,
                quantity: state.quantity
            };
            var processUrl = _this.$hibachi.buildUrl('api:main.post');
            var adminRequest = _this.requestService.newAdminRequest(processUrl, formDataToPost);
            adminRequest.promise.then(function (response) {
            }, function (reason) {
            });
        };
        this.addPromotionalOrderTemplateItem = function (state) {
            var formDataToPost = {
                entityID: _this.orderTemplateID,
                entityName: 'OrderTemplate',
                context: 'addOrderTemplateItem',
                propertyIdentifiersList: _this.orderTemplatePropertyIdentifierList,
                skuID: state.skuID,
                quantity: state.quantity,
                temporaryFlag: true
            };
            var processUrl = _this.$hibachi.buildUrl('api:main.post');
            var adminRequest = _this.requestService.newAdminRequest(processUrl, formDataToPost);
            adminRequest.promise.then(function (response) {
            }, function (reason) {
            });
        };
        this.editOrderTemplateItem = function (state) {
            var formDataToPost = {
                entityID: state.orderTemplateItemID,
                entityName: 'OrderTemplateItem',
                context: 'save',
                propertyIdentifiersList: _this.orderTemplateItemPropertyIdentifierList,
                quantity: state.quantity
            };
            var processUrl = _this.$hibachi.buildUrl('api:main.post');
            var adminRequest = _this.requestService.newAdminRequest(processUrl, formDataToPost);
            adminRequest.promise.then(function (response) {
            }, function (reason) {
            });
        };
        this.removeOrderTemplatePromotionCode = function (state) {
            var formDataToPost = {
                entityID: _this.orderTemplateID,
                entityName: 'OrderTemplate',
                context: 'removePromotionCode',
                propertyIdentifiersList: _this.orderTemplatePropertyIdentifierList,
                promotionCodeID: state.promotionCodeID
            };
            var processUrl = _this.$hibachi.buildUrl('api:main.post');
            var adminRequest = _this.requestService.newAdminRequest(processUrl, formDataToPost);
            adminRequest.promise.then(function (response) {
            }, function (reason) {
            });
        };
        this.removeOrderTemplateGiftCard = function (state) {
            var formDataToPost = {
                entityID: _this.orderTemplateID,
                entityName: 'OrderTemplate',
                context: 'removeAppliedGiftCard',
                propertyIdentifiersList: _this.orderTemplatePropertyIdentifierList,
                orderTemplateAppliedGiftCardID: state.orderTemplateAppliedGiftCardID
            };
            var processUrl = _this.$hibachi.buildUrl('api:main.post');
            var adminRequest = _this.requestService.newAdminRequest(processUrl, formDataToPost);
            adminRequest.promise.then(function (response) {
            }, function (reason) {
            });
        };
        this.deleteOrderTemplateItem = function (state) {
            var formDataToPost = {
                entityID: _this.orderTemplateID,
                entityName: 'OrderTemplate',
                orderTemplateItemID: state.orderTemplateItemID,
                context: 'removeOrderTemplateItem',
                propertyIdentifiersList: _this.orderTemplatePropertyIdentifierList
            };
            var processUrl = _this.$hibachi.buildUrl('api:main.post');
            var adminRequest = _this.requestService.newAdminRequest(processUrl, formDataToPost);
            adminRequest.promise.then(function (response) {
            }, function (reason) {
            });
        };
        this.observerService.attach(this.addOrderTemplateItem, 'addOrderTemplateItem');
        this.observerService.attach(this.addPromotionalOrderTemplateItem, 'addPromotionalOrderTemplateItem');
        this.observerService.attach(this.editOrderTemplateItem, 'editOrderTemplateItem');
        this.observerService.attach(this.deleteOrderTemplateItem, 'deleteOrderTemplateItem');
        this.observerService.attach(this.removeOrderTemplatePromotionCode, 'OrderTemplateRemovePromotionCode');
        this.observerService.attach(this.removeOrderTemplateGiftCard, 'OrderTemplateRemoveGiftCard');
        this.observerService.attach(this.refreshOrderTemplateItemListing, 'OrderTemplateAddOrderTemplateItemSuccess');
        this.observerService.attach(this.refreshOrderTemplateItemListing, 'OrderTemplateItemDeleteSuccess');
        this.observerService.attach(this.refreshOrderTemplateItemListing, 'OrderTemplateRemoveOrderTemplateItemSuccess');
        this.observerService.attach(this.refreshOrderTemplatePromotionListing, 'OrderTemplateAddPromotionCodeSuccess');
        this.observerService.attach(this.refreshOrderTemplatePromotionListing, 'OrderTemplateRemovePromotionCodeSuccess');
        this.observerService.attach(this.refreshOrderTemplateGiftCardListing, 'OrderTemplateApplyGiftCardSuccess');
        this.observerService.attach(this.refreshOrderTemplateGiftCardListing, 'OrderTemplateRemoveAppliedGiftCardSuccess');
        this.orderTemplateDisplayProperties = ['sku.skuCode', 'sku.skuDefinition', 'sku.product.productName', 'sku.priceByCurrencyCode', 'total'];
        this.skuDisplayProperties = ['skuCode', 'skuDefinition', 'product.productName', 'priceByCurrencyCode'];
        this.originalOrderTemplatePropertyLength = this.orderTemplateDisplayProperties.length;
        this.originalSkuDisplayPropertyLength = this.skuDisplayProperties.length;
        this.viewOrderTemplateItemsCollection = this.collectionConfigService.newCollectionConfig('OrderTemplateItem');
        this.editOrderTemplateItemsCollection = this.collectionConfigService.newCollectionConfig('OrderTemplateItem');
        this.addSkuCollection = this.collectionConfigService.newCollectionConfig('Sku');
    }
    return OrderTemplateService;
}());
exports.OrderTemplateService = OrderTemplateService;


/***/ }),

/***/ "2DFJ":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
exports.SWSkuPriceQuantityEditController = exports.SWSkuPriceQuantityEdit = void 0;
/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
var SWSkuPriceQuantityEditController = /** @class */ (function () {
    //@ngInject
    SWSkuPriceQuantityEditController.$inject = ["$q", "$hibachi", "collectionConfigService", "listingService", "observerService", "skuPriceService", "$scope"];
    function SWSkuPriceQuantityEditController($q, $hibachi, collectionConfigService, listingService, observerService, skuPriceService, $scope) {
        var _this = this;
        this.$q = $q;
        this.$hibachi = $hibachi;
        this.collectionConfigService = collectionConfigService;
        this.listingService = listingService;
        this.observerService = observerService;
        this.skuPriceService = skuPriceService;
        this.$scope = $scope;
        this.skuPrices = [];
        this.showSave = true;
        this.refreshSkuPrices = function () {
            _this.skuPriceService.loadSkuPricesForSku(_this.skuSkuId).finally(function () {
                _this.getSkuPrices();
            });
        };
        this.updateSkuPrices = function () {
            angular.forEach(_this.skuPrices, function (value, key) {
                if (key > 0) {
                    var formName = _this.columnPropertyIdentifier + value.data.skuPriceID;
                    value.forms[formName].$setDirty(true);
                    if (angular.isDefined(value.forms[formName][_this.columnPropertyIdentifier]) &&
                        angular.isFunction(value.forms[formName][_this.columnPropertyIdentifier].$setDirty)) {
                        value.forms[formName][_this.columnPropertyIdentifier].$setDirty(true);
                    }
                    value.data[_this.columnPropertyIdentifier] = _this.skuPrice.data[_this.columnPropertyIdentifier];
                }
            });
        };
        this.saveSkuPrices = function () {
            var savePromises = [];
            angular.forEach(_this.skuPrices, function (value, key) {
                if (value.skuPriceID.length) {
                    if (key > 0) {
                        savePromises.push(value.$$save());
                    }
                }
            });
            _this.savePromise = _this.$q.all(savePromises);
            _this.savePromise.then(function (response) {
                //success
            }, function (reason) {
                //failure
            });
            return _this.savePromise;
        };
        this.getSkuPrices = function () {
            var promise = _this.skuPriceService.getSkuPricesForQuantityRange(_this.skuSkuId, _this.minQuantity, _this.maxQuantity, undefined, _this.priceGroupPriceGroupId);
            promise.then(function (data) {
                _this.skuPrices = data;
            });
            return promise;
        };
        if (angular.isDefined(this.pageRecord)) {
            this.pageRecord.edited = false;
        }
        if (angular.isDefined(this.skuSkuId) && angular.isUndefined(this.skuPrice)) {
            var skuPriceData = {
                skuPriceID: this.skuPriceId,
                minQuantity: parseInt(this.minQuantity),
                maxQuantity: parseInt(this.maxQuantity),
                currencyCode: this.currencyCode,
                price: this.price
            };
            this.skuPrice = this.$hibachi.populateEntity("SkuPrice", skuPriceData);
            this.priceGroup = this.$hibachi.populateEntity('PriceGroup', { priceGroupID: this.priceGroupPriceGroupId });
            this.skuPrice.$$setPriceGroup(this.priceGroup);
            this.skuPriceService.setSkuPrices(this.skuSkuId, [this.skuPrice]);
            this.refreshSkuPrices();
            this.observerService.attach(this.refreshSkuPrices, "skuPricesUpdate");
        }
    }
    return SWSkuPriceQuantityEditController;
}());
exports.SWSkuPriceQuantityEditController = SWSkuPriceQuantityEditController;
var SWSkuPriceQuantityEdit = /** @class */ (function () {
    function SWSkuPriceQuantityEdit(scopeService, skuPartialsPath, slatwallPathBuilder) {
        var _this = this;
        this.scopeService = scopeService;
        this.skuPartialsPath = skuPartialsPath;
        this.slatwallPathBuilder = slatwallPathBuilder;
        this.restrict = 'EA';
        this.scope = {};
        this.bindToController = {
            skuPrice: "=?",
            skuPriceId: "@",
            currencyCode: "@",
            skuSkuId: "@",
            column: "=?",
            columnPropertyIdentifier: "@",
            minQuantity: "@",
            maxQuantity: "@",
            price: "@",
            showSave: "=?",
            listingDisplayId: "@?",
            priceGroupPriceGroupId: "@?"
        };
        this.controller = SWSkuPriceQuantityEditController;
        this.controllerAs = "swSkuPriceQuantityEdit";
        this.compile = function (element, attrs) {
            return {
                pre: function ($scope, element, attrs) {
                    //have to do our setup here because there is no direct way to pass the pageRecord into this transcluded directive
                    var currentScope = _this.scopeService.getRootParentScope($scope, "pageRecord");
                    if (angular.isDefined(currentScope["pageRecord"])) {
                        $scope.swSkuPriceQuantityEdit.pageRecord = currentScope["pageRecord"];
                    }
                    var currentScope = _this.scopeService.getRootParentScope($scope, "pageRecordKey");
                    if (angular.isDefined(currentScope["pageRecordKey"])) {
                        $scope.swSkuPriceQuantityEdit.pageRecordIndex = currentScope["pageRecordKey"];
                    }
                },
                post: function ($scope, element, attrs) {
                }
            };
        };
        this.templateUrl = slatwallPathBuilder.buildPartialsPath(skuPartialsPath) + "skupricequantityedit.html";
    }
    SWSkuPriceQuantityEdit.Factory = function () {
        var directive = function (scopeService, skuPartialsPath, slatwallPathBuilder) { return new SWSkuPriceQuantityEdit(scopeService, skuPartialsPath, slatwallPathBuilder); };
        directive.$inject = [
            'scopeService',
            'skuPartialsPath',
            'slatwallPathBuilder'
        ];
        return directive;
    };
    return SWSkuPriceQuantityEdit;
}());
exports.SWSkuPriceQuantityEdit = SWSkuPriceQuantityEdit;


/***/ }),

/***/ "4ARy":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
Object.defineProperty(exports, "__esModule", { value: true });
exports.SWProductDeliveryScheduleDates = exports.SWProductDeliveryScheduleDatesController = void 0;
var SWProductDeliveryScheduleDatesController = /** @class */ (function () {
    //@ngInject
    SWProductDeliveryScheduleDatesController.$inject = ["$scope", "collectionConfigService"];
    function SWProductDeliveryScheduleDatesController($scope, collectionConfigService) {
        var _this = this;
        this.$scope = $scope;
        this.collectionConfigService = collectionConfigService;
        this.sortDeliveryScheduleDates = function () {
            _this.deliverScheduleDates.sort(function (a, b) {
                var a1 = Date.parse(a.deliveryScheduleDateValue);
                a1 = a1.getTime();
                var b1 = Date.parse(b.deliveryScheduleDateValue);
                b1 = b1.getTime();
                if (a1 > b1)
                    return 1;
                if (a1 < b1)
                    return -1;
                return 0;
            });
        };
        this.removeDeliveryScheduleDate = function (index) {
            _this.deliverScheduleDates.splice(index, 1);
            _this.sortDeliveryScheduleDates();
        };
        this.getDeliveryScheduleDates = function () {
            console.log(_this.collectionConfigService);
            var deliveryScheduleDateCollection = _this.collectionConfigService.newCollectionConfig('DeliveryScheduleDate');
            deliveryScheduleDateCollection.addFilter('product.productID', _this.productId);
            deliveryScheduleDateCollection.setAllRecords(true);
            deliveryScheduleDateCollection.getEntity().then(function (data) {
                _this.deliverScheduleDates = data.records;
                for (var i in _this.deliverScheduleDates) {
                    _this.deliverScheduleDates[i].formattedDate = Date.parse(_this.deliverScheduleDates[i].deliveryScheduleDateValue);
                }
            });
        };
        this.addDate = function (newDeliverScheduleDate) {
            if (newDeliverScheduleDate.deliveryScheduleDateValue) {
                var deliverScheduleDate = angular.copy(newDeliverScheduleDate);
                deliverScheduleDate.deliveryScheduleDateValue = deliverScheduleDate.deliveryScheduleDateValue.toString().slice(0, 24);
                _this.deliverScheduleDates.push(deliverScheduleDate);
                _this.sortDeliveryScheduleDates();
            }
        };
        this.getDeliveryScheduleDates();
        this.$scope.$watch('swProductDeliveryScheduleDates.deliverScheduleDates', function (newValue, oldValue) {
            if (newValue && newValue != oldValue) {
                _this.sortDeliveryScheduleDates();
            }
        });
        this.currentDateTime = Date.today();
        console.log(this.currentDateTime, 'test');
    }
    return SWProductDeliveryScheduleDatesController;
}());
exports.SWProductDeliveryScheduleDatesController = SWProductDeliveryScheduleDatesController;
var SWProductDeliveryScheduleDates = /** @class */ (function () {
    //@ngInject
    SWProductDeliveryScheduleDates.$inject = ["productPartialsPath", "slatwallPathBuilder"];
    function SWProductDeliveryScheduleDates(productPartialsPath, slatwallPathBuilder) {
        this.productPartialsPath = productPartialsPath;
        this.slatwallPathBuilder = slatwallPathBuilder;
        this.restrict = "EA";
        this.scope = {};
        this.bindToController = {
            productId: "@",
            edit: "="
        };
        this.controller = SWProductDeliveryScheduleDatesController;
        this.controllerAs = "swProductDeliveryScheduleDates";
        this.link = function (scope, element, attrs) {
            scope.openCalendarStart = function ($event) {
                $event.preventDefault();
                $event.stopPropagation();
                scope.openedCalendarStart = true;
            };
            scope.openCalendarEnd = function ($event) {
                $event.preventDefault();
                $event.stopPropagation();
                scope.openedCalendarEnd = true;
            };
        };
        this.templateUrl = slatwallPathBuilder.buildPartialsPath(productPartialsPath) + "/productdeliveryscheduledates.html";
    }
    SWProductDeliveryScheduleDates.Factory = function () {
        var directive = function (productPartialsPath, slatwallPathBuilder) { return new SWProductDeliveryScheduleDates(productPartialsPath, slatwallPathBuilder); };
        directive.$inject = [
            'productPartialsPath',
            'slatwallPathBuilder'
        ];
        return directive;
    };
    return SWProductDeliveryScheduleDates;
}());
exports.SWProductDeliveryScheduleDates = SWProductDeliveryScheduleDates;


/***/ }),

/***/ "4fWv":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
exports.CreateBundleController = void 0;
/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
var CreateBundleController = /** @class */ (function () {
    //@ngInject
    CreateBundleController.$inject = ["$scope", "$location", "$log", "$rootScope", "$window", "$hibachi", "dialogService", "alertService", "productBundleService", "formService", "productBundlePartialsPath"];
    function CreateBundleController($scope, $location, $log, $rootScope, $window, $hibachi, dialogService, alertService, productBundleService, formService, productBundlePartialsPath) {
        var _this = this;
        this.$scope = $scope;
        this.$location = $location;
        this.$log = $log;
        this.$rootScope = $rootScope;
        this.$window = $window;
        this.$hibachi = $hibachi;
        this.dialogService = dialogService;
        this.alertService = alertService;
        this.productBundleService = productBundleService;
        this.formService = formService;
        this.productBundlePartialsPath = productBundlePartialsPath;
        this.$inject = [
            '$scope',
            '$location',
            '$log',
            '$rootScope',
            '$window',
            '$hibachi',
            'dialogService',
            'alertService',
            'productBundleService',
            'formService',
            'productBundlePartials'
        ];
        $scope.productBundlePartialsPath = productBundlePartialsPath;
        this.productBundleService = productBundleService;
        var getParameterByName = function (name) {
            name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
            var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"), results = regex.exec(location.search);
            return results === null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
        };
        $scope.$id = "create-bundle-controller";
        //if this view is part of the dialog section, call the inherited function
        if (angular.isDefined($scope.scrollToTopOfDialog)) {
            $scope.scrollToTopOfDialog();
        }
        var productID = getParameterByName('productID');
        var productBundleConstructor = function () {
            $log.debug($scope);
            if (angular.isDefined($scope.product)) {
                for (var form in $scope.product.forms) {
                    formService.resetForm($scope.product.forms[form]);
                }
                if (angular.isDefined($scope.product.data.skus[0])) {
                    for (var form in $scope.product.data.skus[0].forms) {
                        formService.resetForm($scope.product.data.skus[0].forms[form]);
                    }
                }
                if (angular.isDefined($scope.product.data.skus[0].data.productBundleGroups.selectedProductBundleGroup)) {
                    for (var form in $scope.product.data.skus[0].data.productBundleGroups.selectedProductBundleGroup.forms) {
                        formService.resetForm($scope.product.data.skus[0].data.productBundleGroups.selectedProductBundleGroup.forms[form]);
                    }
                }
            }
            $scope.product = $hibachi.newProduct();
            var brand = $hibachi.newBrand();
            var productType = $hibachi.newProductType();
            $scope.product.$$setBrand(brand);
            $scope.product.$$setProductType(productType);
            $scope.product.$$addSku();
            $scope.product.data.skus[0].data.productBundleGroups = [];
        };
        $scope.productBundleGroup;
        if (angular.isDefined(productID) && productID !== '') {
            var productPromise = $hibachi.getProduct({ id: productID });
            productPromise.promise.then(function () {
                $log.debug(productPromise.value);
                productPromise.value.$$getSkus().then(function () {
                    productPromise.value.data.skus[0].$$getProductBundleGroups().then(function () {
                        $scope.product = productPromise.value;
                        angular.forEach($scope.product.data.skus[0].data.productBundleGroups, function (productBundleGroup) {
                            productBundleGroup.$$getProductBundleGroupType();
                            _this.productBundleService.decorateProductBundleGroup(productBundleGroup);
                            productBundleGroup.data.$$editing = false;
                        });
                    });
                });
            }, productBundleConstructor());
        }
        else {
            productBundleConstructor();
        }
    }
    return CreateBundleController;
}());
exports.CreateBundleController = CreateBundleController;


/***/ }),

/***/ "4tEo":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
exports.SWGiftCardBalance = exports.SWGiftCardBalanceController = void 0;
/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
var SWGiftCardBalanceController = /** @class */ (function () {
    function SWGiftCardBalanceController(collectionConfigService) {
        var _this = this;
        this.collectionConfigService = collectionConfigService;
        this.init = function () {
            _this.initialBalance = 0;
            var totalDebit = 0;
            var totalCredit = 0;
            var transactionConfig = _this.collectionConfigService.newCollectionConfig('GiftCardTransaction');
            transactionConfig.setDisplayProperties("giftCardTransactionID, creditAmount, debitAmount, giftCard.giftCardID");
            transactionConfig.addFilter('giftCard.giftCardID', _this.giftCard.giftCardID);
            transactionConfig.setAllRecords(true);
            transactionConfig.setOrderBy("createdDateTime|DESC");
            var transactionPromise = transactionConfig.getEntity();
            transactionPromise.then(function (response) {
                _this.transactions = response.records;
                var initialCreditIndex = _this.transactions.length - 1;
                _this.initialBalance = _this.transactions[initialCreditIndex].creditAmount;
                angular.forEach(_this.transactions, function (transaction, index) {
                    if (!angular.isString(transaction.debitAmount)) {
                        totalDebit += transaction.debitAmount;
                    }
                    if (!angular.isString(transaction.creditAmount)) {
                        totalCredit += transaction.creditAmount;
                    }
                });
                _this.currentBalance = totalCredit - totalDebit;
                _this.balancePercentage = parseInt(((_this.currentBalance / _this.initialBalance) * 100).toString());
            });
        };
        this.init();
    }
    SWGiftCardBalanceController.$inject = ["collectionConfigService"];
    return SWGiftCardBalanceController;
}());
exports.SWGiftCardBalanceController = SWGiftCardBalanceController;
var SWGiftCardBalance = /** @class */ (function () {
    function SWGiftCardBalance(collectionConfigService, giftCardPartialsPath, slatwallPathBuilder) {
        this.collectionConfigService = collectionConfigService;
        this.giftCardPartialsPath = giftCardPartialsPath;
        this.slatwallPathBuilder = slatwallPathBuilder;
        this.scope = {};
        this.bindToController = {
            giftCard: "=?",
            transactions: "=?",
            initialBalance: "=?",
            currentBalance: "=?",
            balancePercentage: "=?"
        };
        this.controller = SWGiftCardBalanceController;
        this.controllerAs = "swGiftCardBalance";
        this.link = function (scope, element, attrs) {
        };
        this.templateUrl = slatwallPathBuilder.buildPartialsPath(giftCardPartialsPath) + "/balance.html";
        this.restrict = "EA";
    }
    SWGiftCardBalance.Factory = function () {
        var directive = function (collectionConfigService, giftCardPartialsPath, slatwallPathBuilder) { return new SWGiftCardBalance(collectionConfigService, giftCardPartialsPath, slatwallPathBuilder); };
        directive.$inject = [
            'collectionConfigService',
            'giftCardPartialsPath',
            'slatwallPathBuilder'
        ];
        return directive;
    };
    return SWGiftCardBalance;
}());
exports.SWGiftCardBalance = SWGiftCardBalance;


/***/ }),

/***/ "50Jh":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
exports.SWOrderItem = void 0;
/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
var SWOrderItem = /** @class */ (function () {
    //@ngInject
    SWOrderItem.$inject = ["$log", "$compile", "$http", "$templateCache", "$hibachi", "$timeout", "collectionConfigService", "orderItemPartialsPath", "slatwallPathBuilder"];
    function SWOrderItem($log, $compile, $http, $templateCache, $hibachi, $timeout, collectionConfigService, orderItemPartialsPath, slatwallPathBuilder) {
        return {
            restrict: "A",
            scope: {
                orderItem: "=",
                orderId: "@",
                attributes: "=",
                paginator: "=?"
            },
            templateUrl: slatwallPathBuilder.buildPartialsPath(orderItemPartialsPath) + "orderitem.html",
            link: function (scope, element, attr) {
                $log.debug('order item init');
                $log.debug(scope.orderItem);
                scope.orderItem.clicked = false; //Never been clicked
                scope.orderItem.details = [];
                scope.orderItem.events = [];
                scope.orderItem.queuePosition;
                scope.orderItem.onWaitlist = false;
                scope.orderItem.isPending = false;
                scope.orderItem.isRegistered = false;
                var foundPosition = false;
                if (scope.orderItem.data.sku.data.product.data.productType.data.systemCode === 'event') {
                    var eventRegistrationPromise = scope.orderItem.$$getEventRegistrations();
                    eventRegistrationPromise.then(function () {
                        angular.forEach(scope.orderItem.data.eventRegistrations, function (eventRegistration) {
                            $log.debug(eventRegistration);
                            var eventRegistrationPromise = eventRegistration.$$getEventRegistrationStatusType();
                            eventRegistrationPromise.then(function (rec) {
                                $log.debug(rec);
                                angular.forEach(rec.records, function (record) {
                                    $log.debug("Records");
                                    $log.debug(record.eventRegistrationStatusType);
                                    angular.forEach(record.eventRegistrationStatusType, function (statusType) {
                                        if ((angular.isDefined(statusType.systemCode) && statusType.systemCode !== null) && statusType.systemCode === "erstWaitlisted") {
                                            scope.orderItem.onWaitlist = true;
                                            $log.debug("Found + " + statusType.systemCode);
                                            //Because the customer is waitlisted, we need to get the number of customers ahead of them in the queue.
                                            var position = getPositionInQueueFor(scope.orderItem);
                                            scope.orderItem.queuePosition = position;
                                        }
                                        else if ((angular.isDefined(statusType.systemCode) && statusType.systemCode !== null) && statusType.systemCode === "erstRegistered") {
                                            scope.orderItem.isRegistered = true;
                                            $log.debug("Found + " + statusType.systemCode);
                                        }
                                        else if ((angular.isDefined(statusType.systemCode) && statusType.systemCode !== null) && statusType.systemCode === "erstPendingApproval") {
                                            scope.orderItem.isPending = true;
                                            $log.debug("Found + " + statusType.systemCode);
                                        }
                                        else {
                                            $log.error("Couldn't resolve a status type for: " + statusType.systemCode);
                                        }
                                    });
                                });
                            });
                        });
                    });
                }
                /**
                * Returns the current position in the queue for an orderItem that's on the waiting list.
                */
                var getPositionInQueueFor = function (orderItem) {
                    $log.debug("Retrieving position in Queue: ");
                    var queueConfig = [
                        {
                            "propertyIdentifier": "_eventregistration.waitlistQueuePositionStruct",
                            "isVisible": true,
                            "persistent": false,
                            "title": "Event Registrations"
                        }
                    ];
                    var queueGroupsConfig = [
                        {
                            "filterGroup": [
                                {
                                    "propertyIdentifier": "_eventregistration.orderItem.orderItemID",
                                    "comparisonOperator": "=",
                                    "value": orderItem.$$getID(),
                                }
                            ]
                        }
                    ];
                    var queueOptions = {
                        columnsConfig: angular.toJson(queueConfig),
                        filterGroupsConfig: angular.toJson(queueGroupsConfig),
                        allRecords: true
                    };
                    var positionPromise = $hibachi.getEntity('EventRegistration', queueOptions);
                    $log.debug(positionPromise);
                    positionPromise.then(function (value) {
                        angular.forEach(value.records, function (position) {
                            $log.debug("Position: " + position.waitlistQueuePositionStruct);
                            if (position.waitlistQueuePositionStruct !== -1) {
                                scope.orderItem.queuePosition = position.waitlistQueuePositionStruct; //Use the value.
                                return position.waitlistQueuePositionStruct;
                            }
                        });
                    });
                };
                //define how we get child order items
                var columnsConfig = [
                    {
                        "isDeletable": false,
                        "isExportable": true,
                        "propertyIdentifier": "_orderitem.orderItemID",
                        "ormtype": "id",
                        "isVisible": true,
                        "isSearchable": true,
                        "title": "Order Item ID"
                    },
                    {
                        "title": "Order Item Type",
                        "propertyIdentifier": "_orderitem.orderItemType",
                        "isVisible": true,
                        "isDeletable": true
                    },
                    {
                        "title": "Order Item Price",
                        "propertyIdentifier": "_orderitem.price",
                        "isVisible": true,
                        "isDeletable": true
                    },
                    {
                        "title": "Sku Name",
                        "propertyIdentifier": "_orderitem.sku.skuName",
                        "isVisible": true,
                        "isDeletable": true
                    },
                    {
                        "title": "Sku Price",
                        "propertyIdentifier": "_orderitem.skuPrice",
                        "isVisible": true,
                        "isDeletable": true
                    },
                    {
                        "title": "Sku ID",
                        "propertyIdentifier": "_orderitem.sku.skuID",
                        "isVisible": true,
                        "isDeletable": true
                    },
                    {
                        "title": "SKU Code",
                        "propertyIdentifier": "_orderitem.sku.skuCode",
                        "isVisible": true,
                        "isDeletable": true
                    },
                    {
                        "title": "Product Bundle Group",
                        "propertyIdentifier": "_orderitem.productBundleGroup.productBundleGroupID",
                        "isVisible": true,
                        "isDeletable": true
                    },
                    {
                        "title": "Product ID",
                        "propertyIdentifier": "_orderitem.sku.product.productID",
                        "isVisible": true,
                        "isDeletable": true
                    },
                    {
                        "title": "Product Name",
                        "propertyIdentifier": "_orderitem.sku.product.productName",
                        "isVisible": true,
                        "isDeletable": true
                    },
                    {
                        "title": "Product Type",
                        "propertyIdentifier": "_orderitem.sku.product.productType",
                        "isVisible": true,
                        "isDeletable": true
                    },
                    {
                        "title": "Product Description",
                        "propertyIdentifier": "_orderitem.sku.product.productDescription",
                        "isVisible": true,
                        "isDeletable": true
                    },
                    {
                        "propertyIdentifier": "_orderitem.sku.baseProductType",
                        "persistent": false
                    },
                    {
                        "title": "Event Start Date",
                        "propertyIdentifier": "_orderitem.sku.eventStartDateTime",
                        "isVisible": true,
                        "isDeletable": true
                    },
                    {
                        "title": "Product Description",
                        "propertyIdentifier": "_orderitem.sku.options",
                        "isVisible": true,
                        "isDeletable": true
                    },
                    {
                        "propertyIdentifier": "_orderitem.skuPrice",
                        "ormtype": "string"
                    },
                    {
                        "title": "Image File Name",
                        "propertyIdentifier": "_orderitem.sku.imageFile",
                        "isVisible": true,
                        "isDeletable": true
                    },
                    {
                        "title": "Qty.",
                        "propertyIdentifier": "_orderitem.quantity",
                        "isVisible": true,
                        "isDeletable": true
                    },
                    {
                        "title": "Order Return ID",
                        "propertyIdentifier": "_orderitem.orderReturn.orderReturnID",
                        "isVisible": true,
                        "isDeletable": true
                    },
                    {
                        "title": "Return Street Address",
                        "propertyIdentifier": "_orderitem.orderReturn.returnLocation.primaryAddress.address.streetAddress",
                        "isVisible": true,
                        "isDeletable": true
                    },
                    {
                        "title": "Return Street Address 2",
                        "propertyIdentifier": "_orderitem.orderReturn.returnLocation.primaryAddress.address.street2Address",
                        "isVisible": true,
                        "isDeletable": true
                    },
                    {
                        "title": "Return City",
                        "propertyIdentifier": "_orderitem.orderReturn.returnLocation.primaryAddress.address.city",
                        "isVisible": true,
                        "isDeletable": true
                    },
                    {
                        "title": "Return State",
                        "propertyIdentifier": "_orderitem.orderReturn.returnLocation.primaryAddress.address.stateCode",
                        "isVisible": true,
                        "isDeletable": true
                    },
                    {
                        "title": "Return Postal Code",
                        "propertyIdentifier": "_orderitem.orderReturn.returnLocation.primaryAddress.address.postalCode",
                        "isVisible": true,
                        "isDeletable": true
                    },
                    {
                        "title": "Fulfillment Method Name",
                        "propertyIdentifier": "_orderitem.orderFulfillment.fulfillmentMethod.fulfillmentMethodName",
                        "isVisible": true,
                        "isDeletable": true
                    },
                    {
                        "title": "Fulfillment ID",
                        "propertyIdentifier": "_orderitem.orderFulfillment.orderFulfillmentID",
                        "isVisible": true,
                        "isDeletable": true
                    },
                    {
                        "title": "Fulfillment Method Type",
                        "propertyIdentifier": "_orderitem.orderFulfillment.fulfillmentMethod.fulfillmentMethodType",
                        "isVisible": true,
                        "isDeletable": true
                    },
                    {
                        "propertyIdentifier": "_orderitem.orderFulfillment.pickupLocation.primaryAddress.address",
                        "isVisible": true,
                        "isDeletable": true
                    },
                    {
                        "title": "Street Address",
                        "propertyIdentifier": "_orderitem.orderFulfillment.shippingAddress.streetAddress",
                        "isVisible": true,
                        "isDeletable": true
                    },
                    {
                        "title": "Street Address 2",
                        "propertyIdentifier": "_orderitem.orderFulfillment.shippingAddress.street2Address",
                        "isVisible": true,
                        "isDeletable": true
                    },
                    {
                        "title": "Postal Code",
                        "propertyIdentifier": "_orderitem.orderFulfillment.shippingAddress.postalCode",
                        "isVisible": true,
                        "isDeletable": true
                    },
                    {
                        "title": "City",
                        "propertyIdentifier": "_orderitem.orderFulfillment.shippingAddress.city",
                        "isVisible": true,
                        "isDeletable": true
                    },
                    {
                        "title": "State",
                        "propertyIdentifier": "_orderitem.orderFulfillment.shippingAddress.stateCode",
                        "isVisible": true,
                        "isDeletable": true
                    },
                    {
                        "title": "Country",
                        "propertyIdentifier": "_orderitem.orderFulfillment.shippingAddress.countryCode",
                        "isVisible": true,
                        "isDeletable": true
                    },
                    {
                        "propertyIdentifier": "_orderitem.orderFulfillment.pickupLocation.primaryAddress.address",
                        "isVisible": true,
                        "isDeletable": true
                    },
                    {
                        "title": "Total",
                        "propertyIdentifier": "_orderitem.itemTotal",
                        "persistent": false
                    },
                    {
                        "title": "Discount Amount",
                        "propertyIdentifier": "_orderitem.discountAmount",
                        "persistent": false
                    },
                    {
                        "title": "Tax Amount",
                        "propertyIdentifier": "_orderitem.taxAmount",
                        "persistent": false
                    },
                    {
                        "propertyIdentifier": "_orderitem.extendedPrice",
                        "persistent": false
                    },
                    {
                        "propertyIdentifier": "_orderitem.productBundleGroup.amount",
                        "ormtype": "big_decimal"
                    },
                    {
                        "propertyIdentifier": "_orderitem.productBundleGroup.amountType",
                        "ormtype": "string"
                    },
                    {
                        "propertyIdentifier": "_orderitem.productBundleGroupPrice",
                        "persistent": false
                    },
                    {
                        "propertyIdentifier": "_orderitem.productBundlePrice",
                        "persistent": false
                    }
                ];
                //Add attributes to the column configuration
                angular.forEach(scope.attributes, function (attribute) {
                    var attributeColumn = {
                        propertyIdentifier: "_orderitem." + attribute.attributeCode,
                        attributeID: attribute.attributeID,
                        attributeSetObject: "orderItem"
                    };
                    columnsConfig.push(attributeColumn);
                });
                var filterGroupsConfig = [
                    {
                        "filterGroup": [
                            {
                                "propertyIdentifier": "_orderitem.parentOrderItem.orderItemID",
                                "comparisonOperator": "=",
                                "value": scope.orderItem.$$getID(),
                            }
                        ]
                    }
                ];
                var options = {
                    columnsConfig: angular.toJson(columnsConfig),
                    filterGroupsConfig: angular.toJson(filterGroupsConfig),
                    allRecords: true
                };
                //Create a list of order items.
                scope.childOrderItems = [];
                scope.orderItem.depth = 1;
                /**
                * Hide orderItem children on clicking the details link.
                */
                scope.hideChildren = function (orderItem) {
                    //Set all child order items to clicked = false.
                    angular.forEach(scope.childOrderItems, function (child) {
                        $log.debug("hideing");
                        child.hide = !child.hide;
                        scope.orderItem.clicked = !scope.orderItem.clicked;
                    });
                };
                //Delete orderItem
                scope.deleteEntity = function () {
                    $log.debug("Deleting");
                    $log.debug(scope.orderItem);
                    var deletePromise = scope.orderItem.$$delete();
                    deletePromise.then(function (result) {
                        if (!result.errors || !Object.keys(result.errors).length) {
                            delete scope.orderItem;
                            window.location.reload();
                        }
                        scope.paginator.getCollection();
                    });
                };
                /**
                * Gets a list of child order items if they exist.
                */
                scope.getChildOrderItems = function () {
                    if (!scope.orderItem.childItemsRetrieved) {
                        scope.orderItem.clicked = !scope.orderItem.clicked;
                        scope.orderItem.hide = !scope.orderItem.hide;
                        scope.orderItem.childItemsRetrieved = true;
                        if (scope.orderItem.sku.bundleFlag === 'Yes ' || scope.orderItem.sku.bundleFlag === 1) {
                            var skuBundleCollection = collectionConfigService.newCollectionConfig('SkuBundle');
                            skuBundleCollection.setDisplayProperties('bundledQuantity, bundledSku.skuCode, bundledSku.price, bundledSku.product.productName');
                            skuBundleCollection.addFilter('sku.skuID', scope.orderItem.sku.skuID);
                            var skuBundleCollectionPromise = skuBundleCollection.getEntity().then(function (data) {
                                if (data.pageRecords.length) {
                                    var childOrderItems = $hibachi.populateCollection(data.pageRecords, skuBundleCollection);
                                    angular.forEach(childOrderItems, function (childOrderItem) {
                                        childOrderItem.depth = scope.orderItem.depth + 1;
                                        scope.childOrderItems.push(childOrderItem);
                                        childOrderItem.data.productBundleGroupPercentage = 1;
                                        if (childOrderItem.data.productBundleGroup.data.amountType === 'skuPricePercentageIncrease') {
                                            childOrderItem.data.productBundleGroupPercentage = 1 + childOrderItem.data.productBundleGroup.data.amount / 100;
                                        }
                                        else if (childOrderItem.data.productBundleGroup.data.amountType === 'skuPricePercentageDecrease') {
                                            childOrderItem.data.productBundleGroupPercentage = 1 - childOrderItem.data.productBundleGroup.data.amount / 100;
                                        }
                                    });
                                }
                            });
                        }
                        else {
                            var orderItemsPromise = $hibachi.getEntity('orderItem', options);
                            orderItemsPromise.then(function (value) {
                                var collectionConfig = {};
                                collectionConfig.columns = columnsConfig;
                                collectionConfig.baseEntityName = 'SlatwallOrderItem';
                                collectionConfig.baseEntityAlias = '_orderitem';
                                var childOrderItems = $hibachi.populateCollection(value.records, collectionConfig);
                                angular.forEach(childOrderItems, function (childOrderItem) {
                                    childOrderItem.depth = scope.orderItem.depth + 1;
                                    scope.childOrderItems.push(childOrderItem);
                                    childOrderItem.data.productBundleGroupPercentage = 1;
                                    if (childOrderItem.data.productBundleGroup.data.amountType === 'skuPricePercentageIncrease') {
                                        childOrderItem.data.productBundleGroupPercentage = 1 + childOrderItem.data.productBundleGroup.data.amount / 100;
                                    }
                                    else if (childOrderItem.data.productBundleGroup.data.amountType === 'skuPricePercentageDecrease') {
                                        childOrderItem.data.productBundleGroupPercentage = 1 - childOrderItem.data.productBundleGroup.data.amount / 100;
                                    }
                                });
                            });
                        }
                    }
                    else {
                        //We already have the items so we just need to show them.
                        angular.forEach(scope.childOrderItems, function (child) {
                            child.hide = !child.hide;
                            scope.orderItem.clicked = !scope.orderItem.clicked;
                        });
                    }
                };
            }
        };
    }
    SWOrderItem.Factory = function () {
        var directive = function ($log, $compile, $http, $templateCache, $hibachi, $timeout, collectionConfigService, orderItemPartialsPath, slatwallPathBuilder) { return new SWOrderItem($log, $compile, $http, $templateCache, $hibachi, $timeout, collectionConfigService, orderItemPartialsPath, slatwallPathBuilder); };
        directive.$inject = [
            '$log',
            '$compile',
            '$http',
            '$templateCache',
            '$hibachi',
            '$timeout',
            'collectionConfigService',
            'orderItemPartialsPath',
            'slatwallPathBuilder'
        ];
        return directive;
    };
    return SWOrderItem;
}());
exports.SWOrderItem = SWOrderItem;


/***/ }),

/***/ "5s5V":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
exports.OrderItemGiftRecipientControl = void 0;
var OrderItemGiftRecipientControl = /** @class */ (function () {
    //@ngInject
    function OrderItemGiftRecipientControl($scope, $hibachi) {
        var _this = this;
        this.$scope = $scope;
        this.$hibachi = $hibachi;
        this.getUnassignedCountArray = function () {
            var unassignedCountArray = new Array();
            for (var i = 1; i <= _this.getUnassignedCount(); i++) {
                unassignedCountArray.push(i);
            }
            return unassignedCountArray;
        };
        this.getAssignedCount = function () {
            var assignedCount = 0;
            angular.forEach(_this.orderItemGiftRecipients, function (orderItemGiftRecipient) {
                assignedCount += orderItemGiftRecipient.quantity;
            });
            return assignedCount;
        };
        this.getUnassignedCount = function () {
            var unassignedCount = _this.quantity;
            angular.forEach(_this.orderItemGiftRecipients, function (orderItemGiftRecipient) {
                unassignedCount -= orderItemGiftRecipient.quantity;
            });
            return unassignedCount;
        };
        this.orderItemGiftRecipients = $scope.orderItemGiftRecipients = [];
        $scope.collection = {};
        this.adding = false;
        this.searchText = "";
        var count = 1;
    }
    OrderItemGiftRecipientControl.$inject = ["$scope", "$hibachi"];
    return OrderItemGiftRecipientControl;
}());
exports.OrderItemGiftRecipientControl = OrderItemGiftRecipientControl;


/***/ }),

/***/ "63UH":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

var __extends = (this && this.__extends) || (function () {
    var extendStatics = function (d, b) {
        extendStatics = Object.setPrototypeOf ||
            ({ __proto__: [] } instanceof Array && function (d, b) { d.__proto__ = b; }) ||
            function (d, b) { for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p]; };
        return extendStatics(d, b);
    };
    return function (d, b) {
        extendStatics(d, b);
        function __() { this.constructor = d; }
        d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
    };
})();
/// <reference path='../typings/slatwallTypescript.d.ts' />
/// <reference path='../typings/tsd.d.ts' />
/*jshint browser:true */
var basebootstrap_1 = __webpack_require__("oj0J");
var slatwalladmin_module_1 = __webpack_require__("//ZH");
//custom bootstrapper
var bootstrapper = /** @class */ (function (_super) {
    __extends(bootstrapper, _super);
    function bootstrapper() {
        var _this = this;
        var angular = _this = _super.call(this, slatwalladmin_module_1.slatwalladminmodule.name) || this;
        angular.bootstrap();
        return _this;
    }
    return bootstrapper;
}(basebootstrap_1.BaseBootStrapper));
module.exports = new bootstrapper();


/***/ }),

/***/ "6Aox":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
Object.defineProperty(exports, "__esModule", { value: true });
exports.SWContentBasic = void 0;
var SWContentBasic = /** @class */ (function () {
    function SWContentBasic($log, $routeParams, $hibachi, formService, contentPartialsPath, slatwallPathBuilder) {
        return {
            restrict: 'EA',
            templateUrl: slatwallPathBuilder.buildPartialsPath(contentPartialsPath) + "contentbasic.html",
            link: function (scope, element, attrs) {
                if (!scope.content.$$isPersisted()) {
                    if (angular.isDefined($routeParams.siteID)) {
                        var sitePromise;
                        var options = {
                            id: $routeParams.siteID
                        };
                        sitePromise = $hibachi.getSite(options);
                        sitePromise.promise.then(function () {
                            var site = sitePromise.value;
                            scope.content.$$setSite(site);
                        });
                    }
                    else {
                        var site = $hibachi.newSite();
                        scope.content.$$setSite(site);
                    }
                    var parentContent;
                    if (angular.isDefined($routeParams.parentContentID)) {
                        var parentContentPromise;
                        var options = {
                            id: $routeParams.parentContentID
                        };
                        parentContentPromise = $hibachi.getContent(options);
                        parentContentPromise.promise.then(function () {
                            var parentContent = parentContentPromise.value;
                            scope.content.$$setParentContent(parentContent);
                            $log.debug('contenttest');
                            $log.debug(scope.content);
                        });
                    }
                    else {
                        var parentContent = $hibachi.newContent();
                        scope.content.$$setParentContent(parentContent);
                    }
                    var contentTemplateType = $hibachi.newType();
                    scope.content.$$setContentTemplateType(contentTemplateType);
                }
                else {
                    scope.content.$$getSite();
                    scope.content.$$getParentContent();
                    scope.content.$$getContentTemplateType();
                }
            }
        };
    }
    SWContentBasic.Factory = function () {
        var directive = function ($log, $routeParams, $hibachi, formService, contentPartialsPath, slatwallPathBuilder) { return new SWContentBasic($log, $routeParams, $hibachi, formService, contentPartialsPath, slatwallPathBuilder); };
        directive.$inject = [
            '$log',
            '$routeParams',
            '$hibachi',
            'formService',
            'contentPartialsPath',
            'slatwallPathBuilder'
        ];
        return directive;
    };
    return SWContentBasic;
}());
exports.SWContentBasic = SWContentBasic;


/***/ }),

/***/ "6B9d":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
exports.SWChildOrderItem = void 0;
/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
var SWChildOrderItem = /** @class */ (function () {
    function SWChildOrderItem($log, $http, $compile, $templateCache, $hibachi, orderItemPartialsPath, slatwallPathBuilder) {
        return {
            restrict: "A",
            scope: {
                orderItem: "=",
                orderId: "@",
                childOrderItems: "=",
                attributes: "="
            },
            templateUrl: slatwallPathBuilder.buildPartialsPath(orderItemPartialsPath) + "childorderitem.html",
            link: function (scope, element, attr) {
                var columnsConfig = [
                    {
                        "isDeletable": false,
                        "isExportable": true,
                        "propertyIdentifier": "_orderitem.orderItemID",
                        "ormtype": "id",
                        "isVisible": true,
                        "isSearchable": true,
                        "title": "Order Item ID"
                    },
                    {
                        "title": "Order Item Type",
                        "propertyIdentifier": "_orderitem.orderItemType",
                        "isVisible": true,
                        "isDeletable": true
                    },
                    {
                        "title": "Order Item Price",
                        "propertyIdentifier": "_orderitem.price",
                        "isVisible": true,
                        "isDeletable": true
                    },
                    {
                        "title": "Sku Name",
                        "propertyIdentifier": "_orderitem.sku.skuName",
                        "isVisible": true,
                        "isDeletable": true
                    },
                    {
                        "title": "Sku Price",
                        "propertyIdentifier": "_orderitem.skuPrice",
                        "isVisible": true,
                        "isDeletable": true
                    },
                    {
                        "title": "Sku ID",
                        "propertyIdentifier": "_orderitem.sku.skuID",
                        "isVisible": true,
                        "isDeletable": true
                    },
                    {
                        "title": "SKU Code",
                        "propertyIdentifier": "_orderitem.sku.skuCode",
                        "isVisible": true,
                        "isDeletable": true
                    },
                    {
                        "title": "Product ID",
                        "propertyIdentifier": "_orderitem.sku.product.productID",
                        "isVisible": true,
                        "isDeletable": true
                    },
                    {
                        "title": "Product Name",
                        "propertyIdentifier": "_orderitem.sku.product.productName",
                        "isVisible": true,
                        "isDeletable": true
                    },
                    {
                        "title": "Product Description",
                        "propertyIdentifier": "_orderitem.sku.product.productDescription",
                        "isVisible": true,
                        "isDeletable": true
                    },
                    {
                        "title": "Image File Name",
                        "propertyIdentifier": "_orderitem.sku.imageFile",
                        "isVisible": true,
                        "isDeletable": true
                    },
                    {
                        "propertyIdentifier": "_orderitem.sku.skuPrice",
                        "ormtype": "string"
                    },
                    {
                        "title": "Product Type",
                        "propertyIdentifier": "_orderitem.sku.product.productType",
                        "isVisible": true,
                        "isDeletable": true
                    },
                    {
                        "propertyIdentifier": "_orderitem.sku.baseProductType",
                        "persistent": false
                    },
                    {
                        "title": "Qty.",
                        "propertyIdentifier": "_orderitem.quantity",
                        "isVisible": true,
                        "isDeletable": true
                    },
                    {
                        "title": "Fulfillment Method Name",
                        "propertyIdentifier": "_orderitem.orderFulfillment.fulfillmentMethod.fulfillmentMethodName",
                        "isVisible": true,
                        "isDeletable": true
                    },
                    {
                        "title": "Fulfillment ID",
                        "propertyIdentifier": "_orderitem.orderFulfillment.orderFulfillmentID",
                        "isVisible": true,
                        "isDeletable": true
                    },
                    {
                        "title": "Fulfillment Method Type",
                        "propertyIdentifier": "_orderitem.orderFulfillment.fulfillmentMethod.fulfillmentMethodType",
                        "isVisible": true,
                        "isDeletable": true
                    },
                    {
                        "propertyIdentifier": "_orderitem.orderFulfillment.pickupLocation.primaryAddress.address",
                        "isVisible": true,
                        "isDeletable": true
                    },
                    {
                        "title": "Street Address",
                        "propertyIdentifier": "_orderitem.orderFulfillment.shippingAddress.streetAddress",
                        "isVisible": true,
                        "isDeletable": true
                    },
                    {
                        "title": "Street Address 2",
                        "propertyIdentifier": "_orderitem.orderFulfillment.shippingAddress.street2Address",
                        "isVisible": true,
                        "isDeletable": true
                    },
                    {
                        "title": "Postal Code",
                        "propertyIdentifier": "_orderitem.orderFulfillment.shippingAddress.postalCode",
                        "isVisible": true,
                        "isDeletable": true
                    },
                    {
                        "title": "City",
                        "propertyIdentifier": "_orderitem.orderFulfillment.shippingAddress.city",
                        "isVisible": true,
                        "isDeletable": true
                    },
                    {
                        "title": "State",
                        "propertyIdentifier": "_orderitem.orderFulfillment.shippingAddress.stateCode",
                        "isVisible": true,
                        "isDeletable": true
                    },
                    {
                        "title": "Country",
                        "propertyIdentifier": "_orderitem.orderFulfillment.shippingAddress.countryCode",
                        "isVisible": true,
                        "isDeletable": true
                    },
                    {
                        "title": "Total",
                        "propertyIdentifier": "_orderitem.itemTotal",
                        "persistent": false
                    },
                    {
                        "title": "Discount Amount",
                        "propertyIdentifier": "_orderitem.discountAmount",
                        "persistent": false
                    },
                    {
                        "propertyIdentifier": "_orderitem.extendedPrice",
                        "persistent": false
                    },
                    {
                        "propertyIdentifier": "_orderitem.productBundleGroup.amount"
                    },
                    {
                        "title": "Product Bundle Group",
                        "propertyIdentifier": "_orderitem.productBundleGroup.productBundleGroupID",
                        "isVisible": true,
                        "isDeletable": true
                    },
                    {
                        "propertyIdentifier": "_orderitem.productBundleGroup.amountType"
                    },
                    {
                        "propertyIdentifier": "_orderitem.productBundleGroupPrice",
                        "persistent": false
                    },
                    {
                        "propertyIdentifier": "_orderitem.productBundlePrice",
                        "persistent": false
                    }
                ];
                //add attributes to the column config
                angular.forEach(scope.attributes, function (attribute) {
                    var attributeColumn = {
                        propertyIdentifier: "_orderitem." + attribute.attributeCode,
                        attributeID: attribute.attributeID,
                        attributeSetObject: "orderItem"
                    };
                    columnsConfig.push(attributeColumn);
                });
                var filterGroupsConfig = [
                    {
                        "filterGroup": [
                            {
                                "propertyIdentifier": "_orderitem.parentOrderItem.orderItemID",
                                "comparisonOperator": "=",
                                "value": scope.orderItem.$$getID(),
                            }
                        ]
                    }
                ];
                var options = {
                    columnsConfig: angular.toJson(columnsConfig),
                    filterGroupsConfig: angular.toJson(filterGroupsConfig),
                    allRecords: true
                };
                //hide the children on click
                scope.hideChildren = function (orderItem) {
                    //Set all child order items to clicked = false.
                    angular.forEach(scope.childOrderItems, function (child) {
                        console.dir(child);
                        child.hide = !child.hide;
                        scope.orderItem.clicked = !scope.orderItem.clicked;
                    });
                };
                /**
                * Returns a list of child order items.
                */
                scope.getChildOrderItems = function (orderItem) {
                    orderItem.clicked = true;
                    if (!scope.orderItem.childItemsRetrieved) {
                        scope.orderItem.childItemsRetrieved = true;
                        var orderItemsPromise = $hibachi.getEntity('orderItem', options);
                        orderItemsPromise.then(function (value) {
                            var collectionConfig = {};
                            collectionConfig.columns = columnsConfig;
                            collectionConfig.baseEntityName = 'SlatwallOrderItem';
                            collectionConfig.baseEntityAlias = '_orderitem';
                            var childOrderItems = $hibachi.populateCollection(value.records, collectionConfig);
                            angular.forEach(childOrderItems, function (childOrderItem) {
                                childOrderItem.hide = false;
                                childOrderItem.depth = orderItem.depth + 1;
                                childOrderItem.data.parentOrderItem = orderItem;
                                childOrderItem.data.parentOrderItemQuantity = scope.orderItem.data.quantity / scope.orderItem.data.parentOrderItemQuantity;
                                scope.childOrderItems.splice(scope.childOrderItems.indexOf(orderItem) + 1, 0, childOrderItem);
                                childOrderItem.data.productBundleGroupPercentage = 1;
                                if (childOrderItem.data.productBundleGroup.data.amountType === 'skuPricePercentageIncrease') {
                                    childOrderItem.data.productBundleGroupPercentage = 1 + childOrderItem.data.productBundleGroup.data.amount / 100;
                                }
                                else if (childOrderItem.data.productBundleGroup.data.amountType === 'skuPricePercentageDecrease') {
                                    childOrderItem.data.productBundleGroupPercentage = 1 - childOrderItem.data.productBundleGroup.data.amount / 100;
                                }
                            });
                        });
                    }
                };
            }
        };
    }
    SWChildOrderItem.Factory = function () {
        var directive = function ($log, $http, $compile, $templateCache, $hibachi, orderItemPartialsPath, slatwallPathBuilder) { return new SWChildOrderItem($log, $http, $compile, $templateCache, $hibachi, orderItemPartialsPath, slatwallPathBuilder); };
        directive.$inject = [
            '$log',
            '$http',
            '$compile',
            '$templateCache',
            '$hibachi',
            'orderItemPartialsPath',
            'slatwallPathBuilder'
        ];
        return directive;
    };
    return SWChildOrderItem;
}());
exports.SWChildOrderItem = SWChildOrderItem;


/***/ }),

/***/ "6X4p":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
exports.SWAddSkuPriceModalLauncherController = exports.SWAddSkuPriceModalLauncher = void 0;
var SWAddSkuPriceModalLauncherController = /** @class */ (function () {
    //@ngInject
    SWAddSkuPriceModalLauncherController.$inject = ["$hibachi", "entityService", "formService", "listingService", "observerService", "skuPriceService", "utilityService", "$timeout"];
    function SWAddSkuPriceModalLauncherController($hibachi, entityService, formService, listingService, observerService, skuPriceService, utilityService, $timeout) {
        var _this = this;
        this.$hibachi = $hibachi;
        this.entityService = entityService;
        this.formService = formService;
        this.listingService = listingService;
        this.observerService = observerService;
        this.skuPriceService = skuPriceService;
        this.utilityService = utilityService;
        this.$timeout = $timeout;
        this.baseName = "j-add-sku-item-";
        this.currencyCodeEditable = false;
        this.currencyCodeOptions = [];
        this.saveSuccess = true;
        this.updateCurrencyCodeSelector = function (args) {
            if (args != 'All') {
                _this.skuPrice.data.currencyCode = args;
                _this.currencyCodeEditable = false;
            }
            else {
                _this.currencyCodeEditable = true;
            }
            _this.observerService.notify("pullBindings");
        };
        this.initData = function () {
            //these are populated in the link function initially
            _this.skuPrice = _this.skuPriceService.newSkuPrice();
            _this.observerService.notify("pullBindings");
        };
        this.setSelectedPriceGroup = function (priceGroupData) {
            if (!angular.isDefined(priceGroupData.priceGroupID)) {
                _this.submittedPriceGroup = {};
                return;
            }
            _this.submittedPriceGroup = { priceGroupID: priceGroupData['priceGroupID'] };
        };
        this.setSelectedSku = function (skuData) {
            if (!angular.isDefined(skuData['skuID'])) {
                return;
            }
            _this.selectedSku = { skuCode: skuData['skuCode'], skuID: skuData['skuID'] };
            _this.sku = _this.$hibachi.populateEntity('Sku', skuData);
            _this.submittedSku = { skuID: skuData['skuID'] };
        };
        this.save = function () {
            _this.observerService.notify("updateBindings");
            var savePromise = _this.skuPrice.$$save();
            savePromise.then(function (response) {
                _this.saveSuccess = true;
                //hack, for whatever reason is not responding to getCollection event
                _this.observerService.notifyById('swPaginationAction', _this.listingID, { type: 'setCurrentPage', payload: 1 });
            }, function (reason) {
                //error callback
                _this.saveSuccess = false;
            }).finally(function () {
                if (_this.saveSuccess) {
                    for (var key in _this.skuPrice.data) {
                        if (key != 'sku' && key != 'currencyCode') {
                            _this.skuPrice.data[key] = null;
                        }
                    }
                    _this.formService.resetForm(_this.formName);
                    _this.listingService.notifyListingPageRecordsUpdate(_this.listingID);
                }
            });
            return savePromise;
        };
        this.uniqueName = this.baseName + this.utilityService.createID(16);
        this.formName = "addSkuPrice" + this.utilityService.createID(16);
        this.skuCollectionConfig = this.skuPriceService.getSkuCollectionConfig(this.productId);
        //hack for listing hardcodeing id
        this.listingID = 'pricingListing';
        this.skuPriceService.getSkuOptions(this.productId).then(function (response) {
            _this.skuOptions = [];
            for (var i = 0; i < response.records.length; i++) {
                _this.skuOptions.push({ skuCode: response.records[i]['skuCode'], skuID: response.records[i]['skuID'] });
            }
        }).finally(function () {
            if (angular.isDefined(_this.skuOptions) && _this.skuOptions.length) {
                _this.setSelectedSku(_this.skuOptions[0]);
            }
        });
        this.skuPriceService.getPriceGroupOptions().then(function (response) {
            _this.priceGroupOptions = response.records;
            _this.priceGroupOptions.unshift({ priceGroupName: "- Select Price Group -", priceGroupID: "" });
        }).finally(function () {
            if (angular.isDefined(_this.priceGroupOptions) && _this.priceGroupOptions.length) {
                _this.selectedPriceGroup = _this.priceGroupOptions[0];
            }
        });
        this.skuPriceService.getCurrencyOptions().then(function (response) {
            if (response.records.length) {
                for (var i = 0; i < response.records.length; i++) {
                    _this.currencyCodeOptions.push(response.records[i]['currencyCode']);
                }
                _this.currencyCodeOptions.unshift("- Select Currency Code -");
                _this.selectedCurrencyCode = _this.currencyCodeOptions[0];
            }
        });
        this.initData();
    }
    return SWAddSkuPriceModalLauncherController;
}());
exports.SWAddSkuPriceModalLauncherController = SWAddSkuPriceModalLauncherController;
var SWAddSkuPriceModalLauncher = /** @class */ (function () {
    function SWAddSkuPriceModalLauncher() {
        this.template = __webpack_require__("w4Le");
        this.restrict = 'EA';
        this.transclude = true;
        this.scope = {};
        this.bindToController = {
            sku: "=?",
            pageRecord: "=?",
            productId: "@?",
            minQuantity: "@?",
            maxQuantity: "@?",
            priceGroupId: "@?",
            currencyCode: "@?",
            eligibleCurrencyCodeList: "@?",
            defaultCurrencyOnly: "=?",
            disableAllFieldsButPrice: "=?"
        };
        this.controller = SWAddSkuPriceModalLauncherController;
        this.controllerAs = "swAddSkuPriceModalLauncher";
    }
    SWAddSkuPriceModalLauncher.Factory = function () {
        var _this = this;
        return function () { return new _this(); };
    };
    return SWAddSkuPriceModalLauncher;
}());
exports.SWAddSkuPriceModalLauncher = SWAddSkuPriceModalLauncher;


/***/ }),

/***/ "8xGm":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
exports.SWCustomerAccountCard = void 0;
/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
var SWCustomerAccountCardController = /** @class */ (function () {
    function SWCustomerAccountCardController($hibachi, rbkeyService) {
        this.$hibachi = $hibachi;
        this.rbkeyService = rbkeyService;
        this.title = "Customer Account";
        this.fullNameTitle = "Customer Account";
        this.emailTitle = "Customer Email";
        this.phoneTitle = "Customer Phone";
        this.baseEntityPropertiesToDisplay = [];
        this.baseEntityRbKeys = {};
        this.fullNameTitle = rbkeyService.rbKey('entity.account.calculatedFullName');
        this.emailTitle = rbkeyService.rbKey('entity.AccountEmailAddress.emailAddress');
        this.phoneTitle = rbkeyService.rbKey('entity.AccountPhoneNumber.phoneNumber');
        this.detailAccountLink = $hibachi.buildUrl('admin:entity.detailaccount', 'accountID=' + this.account.accountID);
        if (this.baseEntityPropertiesToDisplayList != null) {
            this.baseEntityPropertiesToDisplay = this.baseEntityPropertiesToDisplayList.replace('.', '_').split(',');
            for (var i = 0; i < this.baseEntityPropertiesToDisplay.length; i++) {
                this.baseEntityRbKeys[this.baseEntityPropertiesToDisplay[i]] = this.$hibachi.getRBKeyFromPropertyIdentifier(this.baseEntityName, this.baseEntityPropertiesToDisplay[i]);
            }
        }
    }
    return SWCustomerAccountCardController;
}());
var SWCustomerAccountCard = /** @class */ (function () {
    function SWCustomerAccountCard(accountPartialsPath, slatwallPathBuilder, $hibachi, rbkeyService) {
        this.accountPartialsPath = accountPartialsPath;
        this.slatwallPathBuilder = slatwallPathBuilder;
        this.$hibachi = $hibachi;
        this.rbkeyService = rbkeyService;
        this.scope = {};
        this.bindToController = {
            account: "<",
            baseEntityName: "@?",
            baseEntity: "<?",
            baseEntityPropertiesToDisplayList: "@?",
            title: "@?"
        };
        this.controller = SWCustomerAccountCardController;
        this.controllerAs = "swCustomerAccountCard";
        this.link = function (scope, element, attrs) {
        };
        this.templateUrl = slatwallPathBuilder.buildPartialsPath(accountPartialsPath) + "/customeraccountcard.html";
        this.restrict = "EA";
    }
    SWCustomerAccountCard.Factory = function () {
        var directive = function (accountPartialsPath, slatwallPathBuilder, $hibachi, rbkeyService) { return new SWCustomerAccountCard(accountPartialsPath, slatwallPathBuilder, $hibachi, rbkeyService); };
        directive.$inject = [
            'accountPartialsPath',
            'slatwallPathBuilder',
            '$hibachi',
            'rbkeyService'
        ];
        return directive;
    };
    return SWCustomerAccountCard;
}());
exports.SWCustomerAccountCard = SWCustomerAccountCard;


/***/ }),

/***/ "A3VN":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
Object.defineProperty(exports, "__esModule", { value: true });
exports.SWScheduledDeliveriesCard = exports.SWScheduledDeliveriesCardController = void 0;
var SWScheduledDeliveriesCardController = /** @class */ (function () {
    //@ngInject
    SWScheduledDeliveriesCardController.$inject = ["collectionConfigService", "observerService"];
    function SWScheduledDeliveriesCardController(collectionConfigService, observerService) {
        var _this = this;
        this.collectionConfigService = collectionConfigService;
        this.observerService = observerService;
        this.selectSubscriptionPeriod = function () {
            delete _this.subscriptionOrderDeliveryItemsCollectionList;
            var subscriptionOrderDeliveryItemsCollectionList = _this.collectionConfigService.newCollectionConfig('SubscriptionOrderDeliveryItem');
            subscriptionOrderDeliveryItemsCollectionList.addFilter('subscriptionOrderItem.subscriptionUsage.subscriptionUsageID', _this.subscriptionUsageId, '=', 'AND', true);
            subscriptionOrderDeliveryItemsCollectionList.setDisplayProperties('createdDateTime,quantity,subscriptionOrderItem.orderItem.calculatedExtendedPrice,earned');
            subscriptionOrderDeliveryItemsCollectionList.setAllRecords(true);
            if (_this.selectedSubscriptionPeriod == 'All Deliveries') {
                var subscriptionOrderItemCollectionList = _this.collectionConfigService.newCollectionConfig('SubscriptionOrderItem');
                subscriptionOrderItemCollectionList.addFilter('subscriptionUsage.subscriptionUsageID', _this.subscriptionUsageId, '=', 'AND', true);
                subscriptionOrderItemCollectionList.setDisplayProperties('subscriptionOrderItemID,subscriptionUsage.subscriptionTerm.itemsToDeliver,orderItem.calculatedExtendedPrice');
                subscriptionOrderItemCollectionList.addDisplayAggregate('subscriptionOrderDeliveryItems.quantity', 'SUM', 'subscriptionOrderDeliveryItemsQuantitySum');
                subscriptionOrderItemCollectionList.setOrderBy('createdDateTime|DESC');
                subscriptionOrderItemCollectionList.setAllRecords(true);
                subscriptionOrderItemCollectionList.getEntity().then(function (data) {
                    var itemsDelivered = 0;
                    var itemsToDeliver = 0;
                    var valueEarned = 0;
                    for (var i in data.records) {
                        var subscriptionOrderItemData = data.records[i];
                        itemsDelivered += subscriptionOrderItemData.subscriptionOrderDeliveryItemsQuantitySum;
                        itemsToDeliver += subscriptionOrderItemData.subscriptionUsage_subscriptionTerm_itemsToDeliver;
                        valueEarned += subscriptionOrderItemData.orderItem_calculatedExtendedPrice * subscriptionOrderItemData.subscriptionOrderDeliveryItemsQuantitySum;
                    }
                    _this.numerator = itemsDelivered;
                    _this.denominator = itemsToDeliver;
                    _this.earned = valueEarned;
                    _this.subscriptionOrderDeliveryItemsCollectionList = subscriptionOrderDeliveryItemsCollectionList;
                });
            }
            else if (_this.selectedSubscriptionPeriod == 'Current Term') {
                var subscriptionOrderItemCollectionList = _this.collectionConfigService.newCollectionConfig('SubscriptionOrderItem');
                subscriptionOrderItemCollectionList.addFilter('subscriptionUsage.subscriptionUsageID', _this.subscriptionUsageId, '=', 'AND', true);
                subscriptionOrderItemCollectionList.setDisplayProperties('subscriptionOrderItemID,subscriptionUsage.subscriptionTerm.itemsToDeliver,orderItem.calculatedExtendedPrice');
                subscriptionOrderItemCollectionList.addDisplayAggregate('subscriptionOrderDeliveryItems.quantity', 'SUM', 'subscriptionOrderDeliveryItemsQuantitySum');
                subscriptionOrderItemCollectionList.setOrderBy('createdDateTime|DESC');
                subscriptionOrderItemCollectionList.setPageShow(1);
                subscriptionOrderItemCollectionList.getEntity().then(function (data) {
                    _this.numerator = data.pageRecords[0].subscriptionOrderDeliveryItemsQuantitySum;
                    _this.denominator = data.pageRecords[0].subscriptionUsage_subscriptionTerm_itemsToDeliver;
                    _this.earned = data.pageRecords[0].orderItem_calculatedExtendedPrice * data.pageRecords[0].subscriptionOrderDeliveryItemsQuantitySum;
                    subscriptionOrderDeliveryItemsCollectionList.addFilter('subscriptionOrderItem.subscriptionOrderItemID', data.pageRecords[0].subscriptionOrderItemID, '=', 'AND', true);
                    _this.subscriptionOrderDeliveryItemsCollectionList = subscriptionOrderDeliveryItemsCollectionList;
                });
            }
        };
    }
    return SWScheduledDeliveriesCardController;
}());
exports.SWScheduledDeliveriesCardController = SWScheduledDeliveriesCardController;
var SWScheduledDeliveriesCard = /** @class */ (function () {
    //@ngInject
    SWScheduledDeliveriesCard.$inject = ["subscriptionUsagePartialsPath", "slatwallPathBuilder"];
    function SWScheduledDeliveriesCard(subscriptionUsagePartialsPath, slatwallPathBuilder) {
        this.subscriptionUsagePartialsPath = subscriptionUsagePartialsPath;
        this.slatwallPathBuilder = slatwallPathBuilder;
        this.restrict = "EA";
        this.scope = {};
        this.bindToController = {
            subscriptionUsageId: "@"
        };
        this.controller = SWScheduledDeliveriesCardController;
        this.controllerAs = "swScheduledDeliveriesCard";
        this.link = function (scope, element, attrs) {
        };
        this.templateUrl = slatwallPathBuilder.buildPartialsPath(subscriptionUsagePartialsPath) + "/scheduleddeliveriescard.html";
    }
    SWScheduledDeliveriesCard.Factory = function () {
        var directive = function (subscriptionUsagePartialsPath, slatwallPathBuilder) { return new SWScheduledDeliveriesCard(subscriptionUsagePartialsPath, slatwallPathBuilder); };
        directive.$inject = [
            'subscriptionUsagePartialsPath',
            'slatwallPathBuilder'
        ];
        return directive;
    };
    return SWScheduledDeliveriesCard;
}());
exports.SWScheduledDeliveriesCard = SWScheduledDeliveriesCard;


/***/ }),

/***/ "Boeu":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
exports.SWAddressFormPartial = void 0;
/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
var SWAddressFormPartialController = /** @class */ (function () {
    function SWAddressFormPartialController($hibachi, addressService, observerService, rbkeyService) {
        var _this = this;
        this.$hibachi = $hibachi;
        this.addressService = addressService;
        this.observerService = observerService;
        this.rbkeyService = rbkeyService;
        this.stateSelect = true;
        this.updateStateCodes = function () {
            var stateCodePromise = _this.addressService.getStateCodeOptionsByCountryCode(_this.address.countryCode.countryCode);
            stateCodePromise.then(function (response) {
                _this.stateSelect = response.records.length !== 0;
                if (_this.stateSelect) {
                    _this.stateCodeOptions = response.records;
                    _this.address.stateCode = _this.stateCodeOptions[0];
                }
                else {
                    delete _this.address.stateCode;
                }
            });
        };
        if (this.countryCodeOptions.length) {
            this.defaultCountry = this.countryCodeOptions[0];
        }
        for (var i = 0; i < this.countryCodeOptions.length; i++) {
            var country = this.countryCodeOptions[i];
            if (country['countryCode'] === this.defaultCountryCode) {
                this.address.countryCode = country;
                break;
            }
        }
        if (this.address.stateCode == null && this.stateCodeOptions.length) {
            this.address.stateCode = this.stateCodeOptions[0];
        }
    }
    return SWAddressFormPartialController;
}());
var SWAddressFormPartial = /** @class */ (function () {
    function SWAddressFormPartial(addressPartialsPath, slatwallPathBuilder, $hibachi, rbkeyService) {
        this.addressPartialsPath = addressPartialsPath;
        this.slatwallPathBuilder = slatwallPathBuilder;
        this.$hibachi = $hibachi;
        this.rbkeyService = rbkeyService;
        this.scope = {};
        this.bindToController = {
            address: "=",
            countryCodeOptions: "<",
            defaultCountryCode: "@?",
            stateCodeOptions: "<"
        };
        this.controller = SWAddressFormPartialController;
        this.controllerAs = "swAddressFormPartial";
        this.link = function (scope, element, attrs) {
        };
        this.templateUrl = slatwallPathBuilder.buildPartialsPath(addressPartialsPath) + "/addressformpartial.html";
        this.restrict = "EA";
    }
    SWAddressFormPartial.Factory = function () {
        var directive = function (addressPartialsPath, slatwallPathBuilder, $hibachi, rbkeyService) { return new SWAddressFormPartial(addressPartialsPath, slatwallPathBuilder, $hibachi, rbkeyService); };
        directive.$inject = [
            'addressPartialsPath',
            'slatwallPathBuilder',
            '$hibachi',
            'rbkeyService'
        ];
        return directive;
    };
    return SWAddressFormPartial;
}());
exports.SWAddressFormPartial = SWAddressFormPartial;


/***/ }),

/***/ "C5Xv":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
exports.SWGiftCardRecipientInfo = exports.SWGiftCardRecipientInfoController = void 0;
/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
var SWGiftCardRecipientInfoController = /** @class */ (function () {
    //@ngInject
    SWGiftCardRecipientInfoController.$inject = ["$hibachi"];
    function SWGiftCardRecipientInfoController($hibachi) {
        this.$hibachi = $hibachi;
        if (angular.isDefined(this.giftCard.ownerAccount_accountID)) {
            this.detailAccountLink = $hibachi.buildUrl('admin:entity.detailaccount', 'accountID=' + this.giftCard.ownerAccount_accountID);
        }
    }
    return SWGiftCardRecipientInfoController;
}());
exports.SWGiftCardRecipientInfoController = SWGiftCardRecipientInfoController;
var SWGiftCardRecipientInfo = /** @class */ (function () {
    function SWGiftCardRecipientInfo(giftCardPartialsPath, slatwallPathBuilder) {
        this.giftCardPartialsPath = giftCardPartialsPath;
        this.slatwallPathBuilder = slatwallPathBuilder;
        this.scope = {};
        this.bindToController = {
            giftCard: "=?"
        };
        this.controller = SWGiftCardRecipientInfoController;
        this.controllerAs = "swGiftCardRecipientInfo";
        this.templateUrl = slatwallPathBuilder.buildPartialsPath(giftCardPartialsPath) + "/recipientinfo.html";
        this.restrict = "EA";
    }
    SWGiftCardRecipientInfo.Factory = function () {
        var directive = function (giftCardPartialsPath, slatwallPathBuilder) { return new SWGiftCardRecipientInfo(giftCardPartialsPath, slatwallPathBuilder); };
        directive.$inject = [
            'giftCardPartialsPath',
            'slatwallPathBuilder'
        ];
        return directive;
    };
    return SWGiftCardRecipientInfo;
}());
exports.SWGiftCardRecipientInfo = SWGiftCardRecipientInfo;


/***/ }),

/***/ "Co5z":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
exports.SWAddOrderItemsBySkuController = exports.SWAddOrderItemsBySku = void 0;
/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
var SWAddOrderItemsBySkuController = /** @class */ (function () {
    function SWAddOrderItemsBySkuController($hibachi, collectionConfigService, observerService, orderTemplateService, rbkeyService, alertService) {
        var _this = this;
        this.$hibachi = $hibachi;
        this.collectionConfigService = collectionConfigService;
        this.observerService = observerService;
        this.orderTemplateService = orderTemplateService;
        this.rbkeyService = rbkeyService;
        this.alertService = alertService;
        this.$onInit = function () {
            _this.observerService.attach(_this.setEdit, 'swEntityActionBar');
            _this.initCollectionConfig();
            _this.skuColumns = angular.copy(_this.addSkuCollection.getCollectionConfig().columns);
            _this.skuColumns.push({
                'title': _this.rbkeyService.rbKey('define.quantity'),
                'propertyIdentifier': 'quantity',
                'type': 'number',
                'defaultValue': 1,
                'isCollectionColumn': false,
                'isEditable': true,
                'isVisible': true
            }, {
                'title': _this.rbkeyService.rbKey('define.price'),
                'propertyIdentifier': 'priceByCurrencyCode',
                'type': 'currency',
                'isCollectionColumn': true,
                'isEditable': true,
                'isVisible': true
            });
            //if this is an exchange order, add a dropdown...
            if (_this.exchangeOrderFlag) {
                _this.skuColumns.push({
                    'title': _this.rbkeyService.rbKey('define.orderItemType'),
                    'propertyIdentifier': 'orderItemTypeSystemCode',
                    'type': 'select',
                    'defaultValue': 1,
                    'options': [
                        { "name": "Sale Item", "value": "oitSale", "selected": "selected" },
                        { "name": "Return Item", "value": "oitReturn" }
                    ],
                    'isCollectionColumn': false,
                    'isEditable': true,
                    'isVisible': true
                });
            }
            //if we have an order fulfillment, then display the dropdown
            if (_this.orderFulfillmentId != 'new' && _this.orderFulfillmentId != '') {
                _this.skuColumns.push({
                    'title': _this.rbkeyService.rbKey('define.orderFulfillment'),
                    'propertyIdentifier': 'orderFulfillmentID',
                    'type': 'select',
                    'defaultValue': 1,
                    'options': [
                        { "name": _this.simpleRepresentation || "Order Fulfillment", "value": _this.orderFulfillmentId, "selected": "selected" },
                        { "name": "New", "value": "new" }
                    ],
                    'isCollectionColumn': false,
                    'isEditable': true,
                    'isVisible': true
                });
            }
            _this.observerService.attach(_this.addOrderItemListener, "addOrderItem");
        };
        this.addOrderItemListener = function (payload) {
            //figure out if we need to show this modal or not.
            _this.observerService.notify("addOrderItemStartLoading", {});
            if (isNaN(parseFloat(payload.priceByCurrencyCode))) {
                var alert = _this.alertService.newAlert();
                alert.msg = _this.rbkeyService.rbKey("validate.processOrder_addOrderitem.price.notIsDefined");
                alert.type = "error";
                alert.fade = true;
                _this.alertService.addAlert(alert);
                _this.observerService.notify("addOrderItemStopLoading", {});
                return;
            }
            //need to display a modal with the add order item preprocess method.
            var orderItemTypeSystemCode = payload.orderItemTypeSystemCode ? payload.orderItemTypeSystemCode.value : "oitSale";
            var orderFulfilmentID = (payload.orderFulfillmentID && payload.orderFulfillmentID.value) ? payload.orderFulfillmentID.value : (_this.orderFulfillmentId ? _this.orderFulfillmentId : "new");
            var url = "?slatAction=entity.processOrder&skuID=" + payload.skuID + "&price=" + payload.priceByCurrencyCode + "&quantity=" + payload.quantity + "&orderID=" + _this.order + "&orderItemTypeSystemCode=" + orderItemTypeSystemCode + "&orderFulfillmentID=" + orderFulfilmentID + "&processContext=addorderitem&ajaxRequest=1";
            if (orderFulfilmentID && orderFulfilmentID != "new") {
                url = url + "&preProcessDisplayedFlag=1";
            }
            _this.postData(url)
                .then(function (data) {
                //Item can't be purchased
                if (data.processObjectErrors && data.processObjectErrors.isPurchasableItemFlag) {
                    _this.observerService.notify("addOrderItemStopLoading", {});
                    //Display the modal	
                }
                else if (data.preProcessView) {
                    //populate a modal with the template data...
                    var parsedHtml = data.preProcessView;
                    $('#adminModal').modal();
                    // show modal
                    window.renderModal(parsedHtml);
                }
                else {
                    //notify the orderitem listing that it needs to refresh itself...
                    //get the new persisted values...
                    _this.observerService.notify("refreshOrderItemListing", {});
                    //now get the order values because we updated them and pass along to anything listening...
                    _this.$hibachi.getEntity("Order", _this.order).then(function (data) {
                        _this.observerService.notify("refreshOrder" + _this.order, data);
                        _this.observerService.notify("addOrderItemStopLoading", {});
                    });
                    _this.observerService.notify("addOrderItemStopLoading", {});
                    //(window as any).location.reload();
                }
            }) // JSON-string from `response.json()` call
                .catch(function (error) { return console.error(error); });
        };
        this.setEdit = function (payload) {
            _this.edit = payload.edit;
        };
        if (this.edit == null) {
            this.edit = false;
        }
    }
    SWAddOrderItemsBySkuController.prototype.initCollectionConfig = function () {
        var _a, _b;
        var skuDisplayProperties = "skuCode,calculatedSkuDefinition,product.productName";
        if (this.skuPropertiesToDisplay != null) {
            // join the two lists.
            skuDisplayProperties = skuDisplayProperties + "," + this.skuPropertiesToDisplay;
        }
        this.addSkuCollection = this.collectionConfigService.newCollectionConfig('Sku');
        this.addSkuCollection.setDisplayProperties(skuDisplayProperties, '', { isVisible: true, isSearchable: true, isDeletable: true, isEditable: false });
        this.addSkuCollection.addDisplayProperty('product.productType.productTypeName', 'Product Type', { isVisible: true, isSearchable: false, isDeletable: false, isEditable: false });
        this.addSkuCollection.addDisplayProperty('priceByCurrencyCode', '', { isVisible: true, isSearchable: false, isDeletable: false, isEditable: false, arguments: { accountID: this.accountId, currencyCode: this.currencyCode } });
        this.addSkuCollection.addDisplayProperty('skuID', '', { isVisible: false, isSearchable: false, isDeletable: false, isEditable: false });
        this.addSkuCollection.addDisplayProperty('imageFile', this.rbkeyService.rbKey('entity.sku.imageFile'), { isVisible: false, isSearchable: false, isDeletable: false });
        this.addSkuCollection.addDisplayProperty('qats', 'QATS', { isVisible: true, isSearchable: false, isDeletable: false, isEditable: false });
        if (this.skuPropertiesToDisplayWithConfig) {
            // this allows passing in display property information. skuPropertiesToDisplayWithConfig is an array of objects
            var skuPropertiesToDisplayWithConfig = this.skuPropertiesToDisplayWithConfig.replace(/'/g, '"');
            //now we can parse into a json array
            var skuPropertiesToDisplayWithConfigObject = JSON.parse(skuPropertiesToDisplayWithConfig);
            //now we can iterate and add the display properties defined on this attribute..
            for (var _i = 0, skuPropertiesToDisplayWithConfigObject_1 = skuPropertiesToDisplayWithConfigObject; _i < skuPropertiesToDisplayWithConfigObject_1.length; _i++) {
                var property = skuPropertiesToDisplayWithConfigObject_1[_i];
                this.addSkuCollection.addDisplayProperty(property.name, property.rbkey, property.config);
            }
        }
        this.addSkuCollection.addFilter('activeFlag', true, '=', undefined, true);
        this.addSkuCollection.addFilter('product.activeFlag', true, '=', undefined, true);
        if ((_a = this.siteId) === null || _a === void 0 ? void 0 : _a.trim()) {
            this.addSkuCollection.addFilter('product.sites.siteID', this.siteId, '=', undefined, true);
        }
        if ((_b = this.currencyCode) === null || _b === void 0 ? void 0 : _b.trim()) {
            this.addSkuCollection.addFilter('skuPrices.currencyCode', this.currencyCode, '=', undefined, true);
        }
    };
    SWAddOrderItemsBySkuController.prototype.postData = function (url, data) {
        if (url === void 0) { url = ''; }
        if (data === void 0) { data = {}; }
        var config = {
            'headers': { 'Content-Type': 'X-Hibachi-AJAX' }
        };
        return this.$hibachi.$http.post(url, data, config)
            .then(function (response) { return response.data; }); // parses JSON response into native JavaScript objects 
    };
    ;
    return SWAddOrderItemsBySkuController;
}());
exports.SWAddOrderItemsBySkuController = SWAddOrderItemsBySkuController;
var SWAddOrderItemsBySku = /** @class */ (function () {
    function SWAddOrderItemsBySku(orderPartialsPath, slatwallPathBuilder, $hibachi, rbkeyService, alertService) {
        this.orderPartialsPath = orderPartialsPath;
        this.slatwallPathBuilder = slatwallPathBuilder;
        this.$hibachi = $hibachi;
        this.rbkeyService = rbkeyService;
        this.alertService = alertService;
        this.restrict = "EA";
        this.scope = {};
        this.bindToController = {
            order: '<?',
            orderFulfillmentId: '<?',
            accountId: '<?',
            siteId: '<?',
            currencyCode: '<?',
            simpleRepresentation: '<?',
            returnOrderId: '<?',
            skuPropertiesToDisplay: '@?',
            skuPropertiesToDisplayWithConfig: '@?',
            edit: "=?",
            exchangeOrderFlag: "=?"
        };
        this.controller = SWAddOrderItemsBySkuController;
        this.controllerAs = "swAddOrderItemsBySku";
        this.link = function (scope, element, attrs) {
        };
        this.templateUrl = slatwallPathBuilder.buildPartialsPath(orderPartialsPath) + "/addorderitemsbysku.html";
    }
    SWAddOrderItemsBySku.Factory = function () {
        var directive = function (orderPartialsPath, slatwallPathBuilder, $hibachi, rbkeyService, alertService) { return new SWAddOrderItemsBySku(orderPartialsPath, slatwallPathBuilder, $hibachi, rbkeyService, alertService); };
        directive.$inject = [
            'orderPartialsPath',
            'slatwallPathBuilder',
            '$hibachi',
            'rbkeyService',
            'alertService'
        ];
        return directive;
    };
    return SWAddOrderItemsBySku;
}());
exports.SWAddOrderItemsBySku = SWAddOrderItemsBySku;


/***/ }),

/***/ "D4Ox":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
exports.SWAccountShippingMethodModal = void 0;
/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
var SWAccountShippingMethodModalController = /** @class */ (function () {
    function SWAccountShippingMethodModalController($timeout, $hibachi, entityService, observerService, orderTemplateService, rbkeyService, requestService) {
        var _this = this;
        this.$timeout = $timeout;
        this.$hibachi = $hibachi;
        this.entityService = entityService;
        this.observerService = observerService;
        this.orderTemplateService = orderTemplateService;
        this.rbkeyService = rbkeyService;
        this.requestService = requestService;
        this.processContext = 'updateShipping';
        this.uniqueName = 'shippingMethodModal';
        this.formName = 'shippingMethodModal';
        //rb key properties
        this.title = "Edit Shipping Information";
        this.shippingMethodTitle = "Shipping Method";
        this.modalButtonText = "Add Shipping Information";
        this.createShippingAddressTitle = 'Add new shipping address';
        this.shippingAccountAddressTitle = 'Shipping account address';
        //view state properties
        this.hideSelectAccountAddress = false;
        this.$onInit = function () {
            _this.showCreateShippingAddress = false;
            _this.baseEntityName = _this.swAccountShippingAddressCard.baseEntityName;
            _this.baseEntity = _this.swAccountShippingAddressCard.baseEntity;
            _this.baseEntityPrimaryID = _this.baseEntity[_this.$hibachi.getPrimaryIDPropertyNameByEntityName(_this.baseEntityName)];
            _this.defaultCountryCode = _this.swAccountShippingAddressCard.defaultCountryCode;
            _this.accountAddressOptions = _this.swAccountShippingAddressCard.accountAddressOptions;
            _this.countryCodeOptions = _this.swAccountShippingAddressCard.countryCodeOptions;
            _this.shippingMethodOptions = _this.swAccountShippingAddressCard.shippingMethodOptions;
            _this.stateCodeOptions = _this.swAccountShippingAddressCard.stateCodeOptions;
            _this.hideSelectAccountAddress = _this.accountAddressOptions.length === 0;
            _this.showCreateShippingAddress = _this.hideSelectAccountAddress;
            if (!_this.hideSelectAccountAddress && _this.swAccountShippingAddressCard.shippingAccountAddress == null) {
                _this.baseEntity.shippingAccountAddress = _this.accountAddressOptions[0];
            }
            else {
                for (var i = 0; i < _this.accountAddressOptions.length; i++) {
                    var option = _this.accountAddressOptions[i];
                    if (option['value'] === _this.swAccountShippingAddressCard.shippingAccountAddress.accountAddressID) {
                        _this.baseEntity.shippingAccountAddress = option;
                        break;
                    }
                }
            }
            _this.baseEntity.shippingMethod = _this.shippingMethodOptions[0];
            _this.newAccountAddress = {
                address: {}
            };
        };
        this.save = function () {
            var formDataToPost = {
                entityID: _this.baseEntityPrimaryID,
                entityName: _this.baseEntityName,
                context: _this.processContext,
                propertyIdentifiersList: 'shippingAccountAddress,shippingMethod,account.accountAddressOptions,' + _this.orderTemplateService.orderTemplatePropertyIdentifierList
            };
            if (_this.showCreateShippingAddress) {
                formDataToPost.newAccountAddress = _this.newAccountAddress;
                formDataToPost.newAccountAddress.address.stateCode = _this.newAccountAddress.address.stateCode.stateCode;
                formDataToPost.newAccountAddress.address.countryCode = _this.newAccountAddress.address.countryCode.countryCode;
            }
            else {
                formDataToPost.shippingAccountAddress = _this.baseEntity.shippingAccountAddress;
            }
            formDataToPost.shippingMethodID = _this.baseEntity.shippingMethod.value;
            var processUrl = _this.$hibachi.buildUrl('api:main.post');
            var adminRequest = _this.requestService.newAdminRequest(processUrl, formDataToPost);
            return adminRequest.promise;
        };
        this.observerService.attach(this.$onInit, 'OrderTemplateUpdateShippingSuccess');
        this.observerService.attach(this.$onInit, 'OrderTemplateUpdateBillingSuccess');
    }
    return SWAccountShippingMethodModalController;
}());
var SWAccountShippingMethodModal = /** @class */ (function () {
    function SWAccountShippingMethodModal(orderPartialsPath, slatwallPathBuilder, $hibachi, rbkeyService) {
        this.orderPartialsPath = orderPartialsPath;
        this.slatwallPathBuilder = slatwallPathBuilder;
        this.$hibachi = $hibachi;
        this.rbkeyService = rbkeyService;
        this.scope = {};
        this.bindToController = {
            modalButtonText: "@?"
        };
        this.require = {
            swAccountShippingAddressCard: "^^swAccountShippingAddressCard"
        };
        this.controller = SWAccountShippingMethodModalController;
        this.controllerAs = "swAccountShippingMethodModal";
        this.link = function (scope, element, attrs) {
        };
        this.templateUrl = slatwallPathBuilder.buildPartialsPath(orderPartialsPath) + "/accountshippingmethodmodal.html";
        this.restrict = "EA";
    }
    SWAccountShippingMethodModal.Factory = function () {
        var directive = function (orderPartialsPath, slatwallPathBuilder, $hibachi, rbkeyService) { return new SWAccountShippingMethodModal(orderPartialsPath, slatwallPathBuilder, $hibachi, rbkeyService); };
        directive.$inject = [
            'orderPartialsPath',
            'slatwallPathBuilder',
            '$hibachi',
            'rbkeyService'
        ];
        return directive;
    };
    return SWAccountShippingMethodModal;
}());
exports.SWAccountShippingMethodModal = SWAccountShippingMethodModal;


/***/ }),

/***/ "DhYn":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
Object.defineProperty(exports, "__esModule", { value: true });
exports.SWAssignedProducts = exports.SWAssignedProductsController = void 0;
var SWAssignedProductsController = /** @class */ (function () {
    //@ngInject
    SWAssignedProductsController.$inject = ["collectionConfigService", "utilityService"];
    function SWAssignedProductsController(collectionConfigService, utilityService) {
        this.collectionConfigService = collectionConfigService;
        this.utilityService = utilityService;
        this.collectionConfig = collectionConfigService.newCollectionConfig("Product");
        this.collectionConfig.addDisplayProperty("productID,productName,productCode,calculatedSalePrice,activeFlag,publishedFlag,productType.productTypeNamePath,productType.productTypeName,defaultSku.price");
        this.alreadySelectedProductsCollectionConfig = collectionConfigService.newCollectionConfig("ProductListingPage");
        this.alreadySelectedProductsCollectionConfig.addDisplayProperty("productListingPageID,sortOrder,product.productID,product.productName,product.productCode,product.calculatedSalePrice,product.activeFlag,product.publishedFlag");
        this.alreadySelectedProductsCollectionConfig.addFilter("content.contentID", this.contentId, "=");
        this.typeaheadDataKey = utilityService.createID(32);
    }
    return SWAssignedProductsController;
}());
exports.SWAssignedProductsController = SWAssignedProductsController;
var SWAssignedProducts = /** @class */ (function () {
    //@ngInject
    SWAssignedProducts.$inject = ["$http", "$hibachi", "paginationService", "contentPartialsPath", "slatwallPathBuilder"];
    function SWAssignedProducts($http, $hibachi, paginationService, contentPartialsPath, slatwallPathBuilder) {
        this.$http = $http;
        this.$hibachi = $hibachi;
        this.paginationService = paginationService;
        this.contentPartialsPath = contentPartialsPath;
        this.slatwallPathBuilder = slatwallPathBuilder;
        this.restrict = "EA";
        this.scope = {};
        this.bindToController = {
            contentId: "@?",
            edit: "=?",
            productSortProperty: "@?",
            productSortDefaultDirection: "@?"
        };
        this.controller = SWAssignedProductsController;
        this.controllerAs = "swAssignedProducts";
        this.link = function ($scope, element, attrs) {
        };
        this.templateUrl = slatwallPathBuilder.buildPartialsPath(contentPartialsPath) + "/assignedproducts.html";
    }
    SWAssignedProducts.Factory = function () {
        var directive = function ($http, $hibachi, paginationService, contentPartialsPath, slatwallPathBuilder) { return new SWAssignedProducts($http, $hibachi, paginationService, contentPartialsPath, slatwallPathBuilder); };
        directive.$inject = [
            '$http',
            '$hibachi',
            'paginationService',
            'contentPartialsPath',
            'slatwallPathBuilder'
        ];
        return directive;
    };
    return SWAssignedProducts;
}());
exports.SWAssignedProducts = SWAssignedProducts;


/***/ }),

/***/ "EMMr":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
Object.defineProperty(exports, "__esModule", { value: true });
exports.ProductCreateController = void 0;
var ProductCreateController = /** @class */ (function () {
    //@ngInject
    ProductCreateController.$inject = ["$q", "$scope", "$element", "$log", "$hibachi", "collectionConfigService", "selectionService", "rbkeyService"];
    function ProductCreateController($q, $scope, $element, $log, $hibachi, collectionConfigService, selectionService, rbkeyService) {
        var _this = this;
        this.$q = $q;
        this.$scope = $scope;
        this.$element = $element;
        this.$log = $log;
        this.$hibachi = $hibachi;
        this.collectionConfigService = collectionConfigService;
        this.selectionService = selectionService;
        this.rbkeyService = rbkeyService;
        //on select change get collection
        this.$scope.preprocessproduct_createCtrl.productTypeChanged = function (selectedOption) {
            _this.$scope.preprocessproduct_createCtrl.selectedOption = selectedOption;
            _this.$scope.preprocessproduct_createCtrl.getCollection();
            _this.selectionService.clearSelection('ListingDisplay');
        };
        this.$scope.productTypeIDPaths = {};
        this.$scope.preprocessproduct_createCtrl.getCollection = function () {
            var productTypeDeffered = _this.$q.defer();
            var productTypePromise = productTypeDeffered.promise;
            if (angular.isUndefined(_this.$scope.productTypeIDPaths[_this.$scope.preprocessproduct_createCtrl.selectedOption.value])) {
                var productTypeCollectionConfig = _this.collectionConfigService.newCollectionConfig('ProductType');
                productTypeCollectionConfig.addDisplayProperty('productTypeID, productTypeIDPath');
                productTypeCollectionConfig.addFilter('productTypeID', _this.$scope.preprocessproduct_createCtrl.selectedOption.value, "=");
                productTypeCollectionConfig.getEntity().then(function (result) {
                    if (angular.isDefined(result.pageRecords[0])) {
                        _this.$scope.productTypeIDPaths[result.pageRecords[0].productTypeID] = result.pageRecords[0].productTypeIDPath;
                    }
                    productTypeDeffered.resolve();
                }, function (reason) {
                    productTypeDeffered.reject();
                    throw ("ProductCreateController was unable to retrieve the product type ID Path.");
                });
            }
            else {
                productTypeDeffered.resolve();
            }
            productTypePromise.then(function () {
                if (_this.$scope.productTypeIDPaths[_this.$scope.preprocessproduct_createCtrl.selectedOption.value]) {
                    var collectionConfig = _this.collectionConfigService.newCollectionConfig('Option');
                    collectionConfig.setDisplayProperties('optionGroup.optionGroupName,optionName', undefined, { isVisible: true });
                    collectionConfig.setDisplayProperties('optionID', undefined, { isVisible: false });
                    //this.collectionConfig.addFilter('optionGroup.optionGroupID',$('input[name="currentOptionGroups"]').val(),'NOT IN')
                    collectionConfig.addFilter('optionGroup.globalFlag', 1, '=');
                    collectionConfig.addFilter('activeFlag', 1, '=');
                    var productTypeIDArray = _this.$scope.productTypeIDPaths[_this.$scope.preprocessproduct_createCtrl.selectedOption.value].split(",");
                    for (var j = 0; j < productTypeIDArray.length; j++) {
                        collectionConfig.addFilter('optionGroup.productTypes.productTypeID', productTypeIDArray[j], '=', 'OR');
                    }
                    collectionConfig.setOrderBy('optionGroup.sortOrder|ASC,sortOrder|ASC');
                    _this.$scope.preprocessproduct_createCtrl.collectionListingPromise = collectionConfig.getEntity();
                    _this.$scope.preprocessproduct_createCtrl.collectionListingPromise.then(function (data) {
                        _this.$scope.preprocessproduct_createCtrl.collection = data;
                        _this.$scope.preprocessproduct_createCtrl.collection.collectionConfig = collectionConfig;
                    });
                }
            }, function () {
                throw ("ProductCreateController was unable to resolve the product type.");
            });
        };
        var renewalMethodOptions = $("select[name='renewalMethod']")[0];
        this.$scope.preprocessproduct_createCtrl.renewalMethodOptions = [];
        angular.forEach(renewalMethodOptions, function (option) {
            var optionToAdd = {
                label: option.label,
                value: option.value
            };
            _this.$scope.preprocessproduct_createCtrl.renewalMethodOptions.push(optionToAdd);
        });
        this.$scope.preprocessproduct_createCtrl.renewalSkuChoice = this.$scope.preprocessproduct_createCtrl.renewalMethodOptions[1];
        var productTypeOptions = $("select[name='product.productType.productTypeID']")[0];
        this.$scope.preprocessproduct_createCtrl.options = [];
        angular.forEach(productTypeOptions, function (jQueryOption) {
            var option = {
                label: jQueryOption.label,
                value: jQueryOption.value
            };
            _this.$scope.preprocessproduct_createCtrl.options.push(option);
        });
        this.$scope.preprocessproduct_createCtrl.selectedOption = {};
        if (angular.isDefined(this.$scope.preprocessproduct_createCtrl.options[0]) && angular.isDefined(this.$scope.preprocessproduct_createCtrl.options[0].value)) {
            this.$scope.preprocessproduct_createCtrl.selectedOption.value = this.$scope.preprocessproduct_createCtrl.options[0].value;
            this.$scope.preprocessproduct_createCtrl.productTypeChanged(this.$scope.preprocessproduct_createCtrl.selectedOption);
        }
        else {
            this.$scope.preprocessproduct_createCtrl.selectedOption.value = "";
        }
        this.$scope.preprocessproduct_createCtrl.getCollection();
    }
    return ProductCreateController;
}());
exports.ProductCreateController = ProductCreateController;


/***/ }),

/***/ "FQTS":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
exports.formbuildermodule = void 0;
/// <reference path='../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../typings/tsd.d.ts' />
//modules
var core_module_1 = __webpack_require__("pwA0");
//controllers
//directives
var swformresponselisting_1 = __webpack_require__("IC7a");
//models
var formbuildermodule = angular.module('formbuilder', [core_module_1.coremodule.name])
    .config([function () {
    }]).run([function () {
    }])
    //constants
    .constant('formBuilderPartialsPath', 'formbuilder/components/')
    //controllers
    //directives
    .directive('swFormResponseListing', swformresponselisting_1.SWFormResponseListing.Factory());
exports.formbuildermodule = formbuildermodule;


/***/ }),

/***/ "FurE":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
exports.SWGiftCardOverview = exports.SWGiftCardOverviewController = void 0;
/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
var SWGiftCardOverviewController = /** @class */ (function () {
    function SWGiftCardOverviewController() {
    }
    return SWGiftCardOverviewController;
}());
exports.SWGiftCardOverviewController = SWGiftCardOverviewController;
var SWGiftCardOverview = /** @class */ (function () {
    function SWGiftCardOverview(giftCardPartialsPath, slatwallPathBuilder) {
        this.giftCardPartialsPath = giftCardPartialsPath;
        this.slatwallPathBuilder = slatwallPathBuilder;
        this.scope = {};
        this.bindToController = {
            giftCard: "=?"
        };
        this.controller = SWGiftCardOverviewController;
        this.controllerAs = "swGiftCardOverview";
        this.templateUrl = slatwallPathBuilder.buildPartialsPath(giftCardPartialsPath) + "/overview.html";
        this.restrict = "EA";
    }
    SWGiftCardOverview.Factory = function () {
        var directive = function (giftCardPartialsPath, slatwallPathBuilder) { return new SWGiftCardOverview(giftCardPartialsPath, slatwallPathBuilder); };
        directive.$inject = [
            'giftCardPartialsPath',
            'slatwallPathBuilder'
        ];
        return directive;
    };
    return SWGiftCardOverview;
}());
exports.SWGiftCardOverview = SWGiftCardOverview;


/***/ }),

/***/ "GNQN":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
Object.defineProperty(exports, "__esModule", { value: true });
exports.SWProductBundleGroup = void 0;
var CollectionFilterItem = /** @class */ (function () {
    function CollectionFilterItem(name, type, displayPropertyIdentifier, propertyIdentifier, displayValue, value, comparisonOperator, logicalOperator) {
        this.name = name;
        this.type = type;
        this.displayPropertyIdentifier = displayPropertyIdentifier;
        this.propertyIdentifier = propertyIdentifier;
        this.displayValue = displayValue;
        this.value = value;
        this.comparisonOperator = comparisonOperator;
        this.logicalOperator = logicalOperator;
    }
    return CollectionFilterItem;
}());
var SWProductBundleGroupController = /** @class */ (function () {
    //@ngInject
    SWProductBundleGroupController.$inject = ["$log", "$timeout", "collectionConfigService", "metadataService", "utilityService", "formService", "$hibachi", "productBundlePartialsPath"];
    function SWProductBundleGroupController($log, $timeout, collectionConfigService, metadataService, utilityService, formService, $hibachi, productBundlePartialsPath) {
        var _this = this;
        this.$log = $log;
        this.$timeout = $timeout;
        this.collectionConfigService = collectionConfigService;
        this.metadataService = metadataService;
        this.utilityService = utilityService;
        this.formService = formService;
        this.$hibachi = $hibachi;
        this.productBundlePartialsPath = productBundlePartialsPath;
        this.init = function () {
            _this.maxRecords = 10;
            _this.recordsCount = 0;
            _this.pageRecordsStart = 0;
            _this.pageRecordsEnd = 0;
            _this.recordsPerPage = 10;
            _this.showAll = false;
            _this.showAdvanced = false;
            _this.currentPage = 1;
            _this.pageShow = 10;
            _this.searchAllCollectionConfigs = [];
            if (angular.isUndefined(_this.filterPropertiesList)) {
                _this.filterPropertiesList = {};
                var filterPropertiesPromise = _this.$hibachi.getFilterPropertiesByBaseEntityName('_sku');
                filterPropertiesPromise.then(function (value) {
                    _this.metadataService.setPropertiesList(value, '_sku');
                    _this.filterPropertiesList['_sku'] = _this.metadataService.getPropertiesListByBaseEntityAlias('_sku');
                    _this.metadataService.formatPropertiesList(_this.filterPropertiesList['_sku'], '_sku');
                });
            }
            _this.searchOptions = {
                options: [
                    {
                        name: "All",
                        value: "All"
                    },
                    {
                        name: "Product Type",
                        value: "productType"
                    },
                    {
                        name: "Brand",
                        value: "brand"
                    },
                    {
                        name: "Products",
                        value: "product"
                    },
                    {
                        name: "Skus",
                        value: "sku"
                    }
                ],
                selected: {
                    name: "All",
                    value: "All"
                },
                setSelected: function (searchOption) {
                    _this.searchOptions.selected = searchOption;
                }
            };
            _this.navigation = {
                value: 'Basic',
                setValue: function (value) {
                    _this.value = value;
                }
            };
            _this.filterTemplatePath = _this.productBundlePartialsPath + "productbundlefilter.html";
            _this.productBundleGroupFilters = {};
            _this.productBundleGroupFilters.value = [];
            if (angular.isUndefined(_this.productBundleGroup.data.skuCollectionConfig) || _this.productBundleGroup.data.skuCollectionConfig === null) {
                _this.productBundleGroup.data.skuCollectionConfig = _this.collectionConfigService.newCollectionConfig("Sku").getCollectionConfig();
            }
            var options = {
                filterGroupsConfig: _this.productBundleGroup.data.skuCollectionConfig.filterGroups[0].filterGroup,
                columnsConfig: _this.productBundleGroup.data.skuCollectionConfig.columns,
            };
            _this.getCollection();
        };
        this.deleteEntity = function (type) {
            _this.removeProductBundleGroup({ index: _this.index });
            _this.productBundleGroup.data.skuCollectionConfig.filterGroups[0].filterGroup = [];
        };
        this.getCollection = function () {
            var options = {
                filterGroupsConfig: angular.toJson(_this.productBundleGroup.data.skuCollectionConfig.filterGroups),
                columnsConfig: angular.toJson(_this.productBundleGroup.data.skuCollectionConfig.columns),
                currentPage: 1,
                pageShow: 10
            };
            var collectionPromise = _this.$hibachi.getEntity('Sku', options);
            collectionPromise.then(function (response) {
                _this.collection = response;
            });
        };
        this.increaseCurrentCount = function () {
            if (angular.isDefined(_this.totalPages) && _this.totalPages != _this.currentPage) {
                _this.currentPage++;
            }
            else {
                _this.currentPage = 1;
            }
        };
        this.resetCurrentCount = function () {
            _this.currentPage = 1;
        };
        this.save = function () {
            var savePromise = _this.productBundleGroup.$$save();
            savePromise.then(function (response) {
                _this.productBundleGroup.data.$$toggleEdit();
                _this.refreshProductBundleGroup();
            }).catch(function (data) {
                //error handling handled by $$save
            });
        };
        this.saveAndAddBundleGroup = function () {
            var savePromise = _this.productBundleGroup.$$save();
            savePromise.then(function (response) {
                _this.productBundleGroup.data.$$toggleEdit();
                _this.addProductBundleGroup();
            }).catch(function (data) {
                //error handling handled by $$save
            });
        };
        this.init();
    }
    return SWProductBundleGroupController;
}());
var SWProductBundleGroup = /** @class */ (function () {
    // @ngInject
    SWProductBundleGroup.$inject = ["productBundlePartialsPath", "slatwallPathBuilder"];
    function SWProductBundleGroup(productBundlePartialsPath, slatwallPathBuilder) {
        this.productBundlePartialsPath = productBundlePartialsPath;
        this.restrict = "EA";
        this.scope = {};
        this.bindToController = {
            productBundleGroup: "=",
            productBundleGroups: "=",
            index: "=",
            addProductBundleGroup: "&",
            removeProductBundleGroup: "&",
            refreshProductBundleGroup: "&",
            formName: "@"
        };
        this.controller = SWProductBundleGroupController;
        this.controllerAs = "swProductBundleGroup";
        this.link = function ($scope, element, attrs, ctrl) {
        };
        this.templateUrl = slatwallPathBuilder.buildPartialsPath(productBundlePartialsPath) + "productbundlegroup.html";
    }
    SWProductBundleGroup.Factory = function () {
        var directive = function (productBundlePartialsPath, slatwallPathBuilder) { return new SWProductBundleGroup(productBundlePartialsPath, slatwallPathBuilder); };
        directive.$inject = [
            "productBundlePartialsPath",
            "slatwallPathBuilder"
        ];
        return directive;
    };
    return SWProductBundleGroup;
}());
exports.SWProductBundleGroup = SWProductBundleGroup;


/***/ }),

/***/ "GWu+":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
exports.fulfillmentbatchdetailmodule = void 0;
/// <reference path='../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../typings/tsd.d.ts' />
//modules
var core_module_1 = __webpack_require__("pwA0");
//services
var orderfulfillmentservice_1 = __webpack_require__("PDZZ");
//controllers
//directives
var swfulfillmentbatchdetail_1 = __webpack_require__("IS4T");
//models 
var fulfillmentbatchdetailmodule = angular.module('fulfillmentbatchdetail', [core_module_1.coremodule.name])
    .config([function () {
    }]).run([function () {
    }])
    //constants
    .constant('fulfillmentBatchDetailPartialsPath', 'fulfillmentbatch/components/')
    //services
    .service('orderFulfillmentService', orderfulfillmentservice_1.OrderFulfillmentService)
    //controllers
    //directives
    .directive('swFulfillmentBatchDetail', swfulfillmentbatchdetail_1.SWFulfillmentBatchDetail.Factory());
exports.fulfillmentbatchdetailmodule = fulfillmentbatchdetailmodule;


/***/ }),

/***/ "HEII":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
exports.accountmodule = void 0;
/// <reference path='../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../typings/tsd.d.ts' />
//modules
var core_module_1 = __webpack_require__("pwA0");
var swcustomeraccountcard_1 = __webpack_require__("8xGm");
var accountmodule = angular.module('account', [core_module_1.coremodule.name])
    .config([function () {
    }]).run([function () {
    }])
    //constants
    .constant('accountPartialsPath', 'account/components/')
    //controllers
    .directive('swCustomerAccountCard', swcustomeraccountcard_1.SWCustomerAccountCard.Factory());
exports.accountmodule = accountmodule;


/***/ }),

/***/ "I73d":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
exports.SWProductBundleGroupsController = exports.SWProductBundleGroups = void 0;
/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
var SWProductBundleGroupsController = /** @class */ (function () {
    //@ngInject
    SWProductBundleGroupsController.$inject = ["$scope", "$element", "$attrs", "$log", "productBundleService", "$hibachi"];
    function SWProductBundleGroupsController($scope, $element, $attrs, $log, productBundleService, $hibachi) {
        var _this = this;
        this.$scope = $scope;
        this.$element = $element;
        this.$attrs = $attrs;
        this.$log = $log;
        this.productBundleService = productBundleService;
        this.$hibachi = $hibachi;
        this.removeProductBundleGroup = function (index) {
            if (angular.isDefined(_this.productBundleGroups[index]) && _this.productBundleGroups[index].$$isPersisted()) {
                _this.productBundleGroups[index].$$delete().then(function (data) {
                    //no more logic to run
                });
            }
            _this.productBundleGroups.splice(index, 1);
        };
        this.addProductBundleGroup = function () {
            var productBundleGroup = _this.$hibachi.newProductBundleGroup();
            productBundleGroup.$$setProductBundleSku(_this.sku);
            productBundleGroup = _this.productBundleService.decorateProductBundleGroup(productBundleGroup);
        };
        this.refreshProductBundleGroup = function () {
            for (var pbg in _this.productBundleGroups) {
                if (_this.productBundleGroups[pbg]['forms'] != undefined || _this.productBundleGroups[pbg]['forms']["createProductBundle" + pbg] != undefined) {
                    //updates the min and max from the raw form values instead of making another http call.
                    if (_this.productBundleGroups[pbg]['forms']["form.createProductBundle" + pbg]['maximumQuantity'] != undefined && _this.productBundleGroups[pbg]['forms']["form.createProductBundle" + pbg]['maximumQuantity']['$modelValue'] != undefined) {
                        if (_this.productBundleGroups["" + pbg]['data']['maximumQuantity'] !== _this.productBundleGroups[pbg]['forms']["form.createProductBundle" + pbg]['maximumQuantity']['$modelValue']) {
                            _this.productBundleGroups["" + pbg]['data']['maximumQuantity'] = _this.productBundleGroups[pbg]['forms']["form.createProductBundle" + pbg]['maximumQuantity']['$modelValue'];
                        }
                    }
                    if (_this.productBundleGroups[pbg]['forms']["form.createProductBundle" + pbg]['minimumQuantity'] != undefined && _this.productBundleGroups[pbg]['forms']["form.createProductBundle" + pbg]['minimumQuantity']['$modelValue'] != undefined) {
                        if (_this.productBundleGroups["" + pbg]['data']['minimumQuantity'] !== _this.productBundleGroups[pbg]['forms']["form.createProductBundle" + pbg]['minimumQuantity']['$modelValue']) {
                            _this.productBundleGroups["" + pbg]['data']['minimumQuantity'] = _this.productBundleGroups[pbg]['forms']["form.createProductBundle" + pbg]['minimumQuantity']['$modelValue'];
                        }
                    }
                }
            }
        };
        $scope.editing = $scope.editing || true;
        angular.forEach(this.productBundleGroups, function (obj) {
            productBundleService.decorateProductBundleGroup(obj);
            obj.data.$$editing = false;
        });
    }
    return SWProductBundleGroupsController;
}());
exports.SWProductBundleGroupsController = SWProductBundleGroupsController;
var SWProductBundleGroups = /** @class */ (function () {
    //@ngInject
    SWProductBundleGroups.$inject = ["productBundlePartialsPath", "slatwallPathBuilder"];
    function SWProductBundleGroups(productBundlePartialsPath, slatwallPathBuilder) {
        this.restrict = 'EA';
        this.scope = {
            sku: "=",
            productBundleGroups: "="
        };
        this.bindToController = {
            sku: "=",
            productBundleGroups: "="
        };
        this.controller = SWProductBundleGroupsController;
        this.controllerAs = "swProductBundleGroups";
        this.templateUrl = slatwallPathBuilder.buildPartialsPath(productBundlePartialsPath) + "productbundlegroups.html";
    }
    SWProductBundleGroups.Factory = function () {
        var directive = function (productBundlePartialsPath, slatwallPathBuilder) { return new SWProductBundleGroups(productBundlePartialsPath, slatwallPathBuilder); };
        directive.$inject = [
            'productBundlePartialsPath',
            'slatwallPathBuilder'
        ];
        return directive;
    };
    return SWProductBundleGroups;
}());
exports.SWProductBundleGroups = SWProductBundleGroups;


/***/ }),

/***/ "IC7a":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
Object.defineProperty(exports, "__esModule", { value: true });
exports.SWFormResponseListing = exports.SWFormResponseListingController = void 0;
var SWFormResponseListingController = /** @class */ (function () {
    //@ngInject
    SWFormResponseListingController.$inject = ["$filter", "$http", "$hibachi", "paginationService", "requestService"];
    function SWFormResponseListingController($filter, $http, $hibachi, paginationService, requestService) {
        var _this = this;
        this.$filter = $filter;
        this.$http = $http;
        this.$hibachi = $hibachi;
        this.paginationService = paginationService;
        this.requestService = requestService;
        this.init = function () {
            if (angular.isUndefined(_this.formId)) {
                throw ("Form ID is required for swFormResponseListing");
            }
            _this.paginator = _this.paginationService.createPagination();
            _this.paginator.getCollection = _this.updateFormResponses;
            _this.updateFormResponses();
        };
        this.export = function () {
            var exportFormResponseRequest = _this.requestService.newAdminRequest(_this.$hibachi.getUrlWithActionPrefix() + 'api:main.exportformresponses&formID=' + _this.formId, {}, 'GET');
            exportFormResponseRequest.promise.then(function (response) {
                var anchor = angular.element('<a/>');
                anchor.attr({
                    href: 'data:attachment/csv;charset=utf-8,' + encodeURI(response),
                    target: '_blank',
                    download: 'formresponses' + _this.formId + '.csv'
                })[0].click();
            });
        };
        this.updateFormResponses = function () {
            var formResponsesRequestUrl = _this.$hibachi.getUrlWithActionPrefix() + "api:main.getformresponses&formID=" + _this.formId;
            var params = {};
            params.currentPage = _this.paginator.currentPage || 1;
            params.pageShow = _this.paginator.pageShow || 10;
            var formResponsesPromise = _this.$http({
                method: 'GET',
                url: formResponsesRequestUrl,
                params: params
            });
            formResponsesPromise.then(function (response) {
                _this.columns = response.data.columnRecords;
                _this.pageRecords = response.data.pageRecords;
                _this.paginator.recordsCount = response.data.recordsCount;
                _this.paginator.totalPages = response.data.totalPages;
                _this.paginator.pageStart = response.data.pageRecordsStart;
                _this.paginator.pageEnd = response.data.pageRecordsEnd;
                for (var i = 0; i < _this.pageRecords.length; i++) {
                    if (angular.isDefined(_this.pageRecords[i].createdDateTime)) {
                        _this.pageRecords[i].createdDateTime = _this.dateFilter(_this.pageRecords[i].createdDateTime, "MMM dd, yyyy - hh:mm a");
                    }
                }
            }, function (response) {
                throw ("There was a problem collecting the form responses");
            });
        };
        this.dateFilter = $filter("dateFilter");
        this.init();
    }
    return SWFormResponseListingController;
}());
exports.SWFormResponseListingController = SWFormResponseListingController;
var SWFormResponseListing = /** @class */ (function () {
    //@ngInject
    SWFormResponseListing.$inject = ["$http", "$hibachi", "paginationService", "formBuilderPartialsPath", "slatwallPathBuilder"];
    function SWFormResponseListing($http, $hibachi, paginationService, formBuilderPartialsPath, slatwallPathBuilder) {
        this.$http = $http;
        this.$hibachi = $hibachi;
        this.paginationService = paginationService;
        this.formBuilderPartialsPath = formBuilderPartialsPath;
        this.slatwallPathBuilder = slatwallPathBuilder;
        this.restrict = "EA";
        this.scope = {};
        this.bindToController = {
            "formId": "@"
        };
        this.controller = SWFormResponseListingController;
        this.controllerAs = "swFormResponseListing";
        this.link = function ($scope, element, attrs) {
        };
        this.templateUrl = slatwallPathBuilder.buildPartialsPath(formBuilderPartialsPath) + "/formresponselisting.html";
    }
    SWFormResponseListing.Factory = function () {
        var directive = function ($http, $hibachi, paginationService, formBuilderPartialsPath, slatwallPathBuilder) { return new SWFormResponseListing($http, $hibachi, paginationService, formBuilderPartialsPath, slatwallPathBuilder); };
        directive.$inject = [
            '$http',
            '$hibachi',
            'paginationService',
            'formBuilderPartialsPath',
            'slatwallPathBuilder'
        ];
        return directive;
    };
    return SWFormResponseListing;
}());
exports.SWFormResponseListing = SWFormResponseListing;


/***/ }),

/***/ "IJbb":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
exports.SWTermScheduleTable = void 0;
/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
var SWTermScheduleTableController = /** @class */ (function () {
    function SWTermScheduleTableController(termService) {
        this.termService = termService;
        this.scheduledDates = [];
        this.scheduledDates = termService.getTermScheduledDates(this.term, this.startDate);
    }
    return SWTermScheduleTableController;
}());
var SWTermScheduleTable = /** @class */ (function () {
    function SWTermScheduleTable(termPartialsPath, slatwallPathBuilder, $hibachi, rbkeyService) {
        this.termPartialsPath = termPartialsPath;
        this.slatwallPathBuilder = slatwallPathBuilder;
        this.$hibachi = $hibachi;
        this.rbkeyService = rbkeyService;
        this.scope = {};
        this.bindToController = {
            term: "<?",
            scheduledDates: "<?",
            startDate: "<?"
        };
        this.controller = SWTermScheduleTableController;
        this.controllerAs = "swTermScheduleTable";
        this.link = function (scope, element, attrs) {
        };
        this.templateUrl = slatwallPathBuilder.buildPartialsPath(termPartialsPath) + "/termscheduletable.html";
        this.restrict = "EA";
    }
    SWTermScheduleTable.Factory = function () {
        var directive = function (termPartialsPath, slatwallPathBuilder, $hibachi, rbkeyService) { return new SWTermScheduleTable(termPartialsPath, slatwallPathBuilder, $hibachi, rbkeyService); };
        directive.$inject = [
            'termPartialsPath',
            'slatwallPathBuilder',
            '$hibachi',
            'rbkeyService'
        ];
        return directive;
    };
    return SWTermScheduleTable;
}());
exports.SWTermScheduleTable = SWTermScheduleTable;


/***/ }),

/***/ "IS4T":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
Object.defineProperty(exports, "__esModule", { value: true });
exports.SWFulfillmentBatchDetail = exports.SWFulfillmentBatchDetailController = void 0;
var actions = __webpack_require__("wcsU");
/**
 * Fulfillment Batch Detail Controller
 */
var SWFulfillmentBatchDetailController = /** @class */ (function () {
    // @ngInject
    SWFulfillmentBatchDetailController.$inject = ["$hibachi", "$timeout", "collectionConfigService", "observerService", "utilityService", "$location", "$http", "$window", "typeaheadService", "listingService", "orderFulfillmentService", "rbkeyService"];
    function SWFulfillmentBatchDetailController($hibachi, $timeout, collectionConfigService, observerService, utilityService, $location, $http, $window, typeaheadService, listingService, orderFulfillmentService, rbkeyService) {
        var _this = this;
        this.$hibachi = $hibachi;
        this.$timeout = $timeout;
        this.collectionConfigService = collectionConfigService;
        this.observerService = observerService;
        this.utilityService = utilityService;
        this.$location = $location;
        this.$http = $http;
        this.$window = $window;
        this.typeaheadService = typeaheadService;
        this.listingService = listingService;
        this.orderFulfillmentService = orderFulfillmentService;
        this.rbkeyService = rbkeyService;
        this.userViewingFulfillmentBatchDetail = function (batchID) {
            _this.orderFulfillmentService.orderFulfillmentStore.dispatch({
                type: actions.SETUP_BATCHDETAIL,
                payload: { fulfillmentBatchId: batchID }
            });
        };
        this.userToggleFulfillmentBatchListing = function () {
            _this.orderFulfillmentService.orderFulfillmentStore.dispatch({
                type: actions.TOGGLE_BATCHLISTING,
                payload: {}
            });
        };
        //toggle_editcomment for action based
        this.userEditingComment = function (comment) {
            _this.orderFulfillmentService.orderFulfillmentStore.dispatch({
                type: actions.TOGGLE_EDITCOMMENT,
                payload: { comment: comment }
            });
        };
        //requested | failed | succeded
        this.userDeletingComment = function (comment) {
            //Only fire the event if the user agrees.
            _this.orderFulfillmentService.orderFulfillmentStore.dispatch({
                type: actions.DELETE_COMMENT_REQUESTED,
                payload: { comment: comment }
            });
        };
        //Try to delete the fulfillment batch item.
        this.deleteFulfillmentBatchItem = function () {
            //Only fire the event if the user agrees.
            _this.orderFulfillmentService.orderFulfillmentStore.dispatch({
                type: actions.DELETE_FULFILLMENTBATCHITEM_REQUESTED,
                payload: {}
            });
        };
        this.userSavingComment = function (comment, commentText) {
            _this.orderFulfillmentService.orderFulfillmentStore.dispatch({
                type: actions.SAVE_COMMENT_REQUESTED,
                payload: { comment: comment, commentText: commentText }
            });
        };
        this.userViewingOrderDeliveryAttributes = function () {
            _this.orderFulfillmentService.orderFulfillmentStore.dispatch({
                type: actions.SETUP_ORDERDELIVERYATTRIBUTES,
                payload: {}
            });
        };
        this.userCaptureAndFulfill = function () {
            //request the fulfillment process.
            _this.state.loading = true;
            _this.orderFulfillmentService.orderFulfillmentStore.dispatch({
                type: actions.CREATE_FULFILLMENT_REQUESTED,
                payload: { viewState: _this.state }
            });
        };
        this.userPrintPickingList = function () {
            _this.orderFulfillmentService.orderFulfillmentStore.dispatch({
                type: actions.PRINT_PICKINGLIST_REQUESTED,
                payload: {}
            });
        };
        this.userPrintPackingList = function () {
            _this.orderFulfillmentService.orderFulfillmentStore.dispatch({
                type: actions.PRINT_PACKINGLIST_REQUESTED,
                payload: {}
            });
        };
        /** Returns a list of print templates related to fulfillment batches. */
        this.userRequiresPrintList = function () {
            _this.orderFulfillmentService.orderFulfillmentStore.dispatch({
                type: actions.PRINT_LIST_REQUESTED,
                payload: {}
            });
        };
        /** Returns a list of all emails related to orderfulfillments */
        this.userRequiresEmailList = function () {
            _this.orderFulfillmentService.orderFulfillmentStore.dispatch({
                type: actions.EMAIL_LIST_REQUESTED,
                payload: {}
            });
        };
        /** Populates box dimensions with dimensions from container preset */
        this.userUpdatingBoxPreset = function (box) {
            _this.orderFulfillmentService.orderFulfillmentStore.dispatch({
                type: actions.UPDATE_BOX_DIMENSIONS,
                payload: { box: box }
            });
        };
        /** Adds an additional box to the shipment */
        this.userAddingNewBox = function () {
            _this.orderFulfillmentService.orderFulfillmentStore.dispatch({
                type: actions.ADD_BOX,
                payload: {}
            });
        };
        this.userRemovingBox = function (index) {
            _this.orderFulfillmentService.orderFulfillmentStore.dispatch({
                type: actions.REMOVE_BOX,
                payload: { index: index }
            });
        };
        /** Sets delivery quantities and gets delivery process object information */
        this.userSettingDeliveryQuantities = function () {
            _this.orderFulfillmentService.orderFulfillmentStore.dispatch({
                type: actions.SET_DELIVERY_QUANTITIES,
                payload: {}
            });
        };
        /**Updates quantity for a container item */
        this.userUpdatingContainerItemQuantity = function (containerItem, newValue) {
            _this.orderFulfillmentService.orderFulfillmentStore.dispatch({
                type: actions.UPDATE_CONTAINER_ITEM_QUANTITY,
                payload: {
                    containerItem: containerItem,
                    newValue: newValue
                }
            });
        };
        /**Sets container for unassigned item */
        this.userSettingUnassignedItemContainer = function (skuCode, container) {
            console.log('container', container);
            _this.orderFulfillmentService.orderFulfillmentStore.dispatch({
                type: actions.SET_UNASSIGNED_ITEM_CONTAINER,
                payload: {
                    skuCode: skuCode,
                    container: container
                }
            });
        };
        /** Todo - Thiswill be for the barcode search which is currently commented out. */
        this.userBarcodeSearch = function () {
            _this.orderFulfillmentService.orderFulfillmentStore.dispatch({
                type: "BAR_CODE_SEARCH_ACTION",
                payload: {}
            });
        };
        //setup a state change listener and send over the fulfillmentBatchID
        this.orderFulfillmentService.orderFulfillmentStore.store$.subscribe(function (stateChanges) {
            //Handle basic requests
            if ((stateChanges.action && stateChanges.action.type) && (stateChanges.action.type == actions.TOGGLE_EDITCOMMENT ||
                stateChanges.action.type == actions.SAVE_COMMENT_REQUESTED ||
                stateChanges.action.type == actions.DELETE_COMMENT_REQUESTED ||
                stateChanges.action.type == actions.CREATE_FULFILLMENT_REQUESTED ||
                stateChanges.action.type == actions.PRINT_LIST_REQUESTED ||
                stateChanges.action.type == actions.EMAIL_LIST_REQUESTED ||
                stateChanges.action.type == actions.UPDATE_BATCHDETAIL ||
                stateChanges.action.type == actions.SETUP_BATCHDETAIL ||
                stateChanges.action.type == actions.SETUP_ORDERDELIVERYATTRIBUTES ||
                stateChanges.action.type == actions.TOGGLE_LOADER ||
                stateChanges.action.type == actions.UPDATE_BOX_DIMENSIONS ||
                stateChanges.action.type == actions.ADD_BOX ||
                stateChanges.action.type == actions.REMOVE_BOX ||
                stateChanges.action.type == actions.SET_DELIVERY_QUANTITIES)) {
                //set the new state.
                _this.state = stateChanges;
            }
        });
        //Get the attributes to display in the custom section.
        this.userViewingOrderDeliveryAttributes();
        //Dispatch the fulfillmentBatchID and setup the state.
        this.userViewingFulfillmentBatchDetail(this.fulfillmentBatchId);
    }
    return SWFulfillmentBatchDetailController;
}());
exports.SWFulfillmentBatchDetailController = SWFulfillmentBatchDetailController;
/**
 * This is a view helper class that uses the collection helper class.
 */
var SWFulfillmentBatchDetail = /** @class */ (function () {
    // @ngInject
    SWFulfillmentBatchDetail.$inject = ["$hibachi", "$timeout", "collectionConfigService", "observerService", "fulfillmentBatchDetailPartialsPath", "slatwallPathBuilder"];
    function SWFulfillmentBatchDetail($hibachi, $timeout, collectionConfigService, observerService, fulfillmentBatchDetailPartialsPath, slatwallPathBuilder) {
        this.$hibachi = $hibachi;
        this.$timeout = $timeout;
        this.collectionConfigService = collectionConfigService;
        this.observerService = observerService;
        this.fulfillmentBatchDetailPartialsPath = fulfillmentBatchDetailPartialsPath;
        this.restrict = "EA";
        this.scope = {};
        this.bindToController = {
            fulfillmentBatchId: "@?"
        };
        this.controller = SWFulfillmentBatchDetailController;
        this.controllerAs = "swFulfillmentBatchDetailController";
        this.link = function ($scope, element, attrs) {
        };
        this.templateUrl = slatwallPathBuilder.buildPartialsPath(fulfillmentBatchDetailPartialsPath) + "fulfillmentbatchdetail.html";
    }
    SWFulfillmentBatchDetail.Factory = function () {
        var directive = function ($hibachi, $timeout, collectionConfigService, observerService, fulfillmentBatchDetailPartialsPath, slatwallPathBuilder) { return new SWFulfillmentBatchDetail($hibachi, $timeout, collectionConfigService, observerService, fulfillmentBatchDetailPartialsPath, slatwallPathBuilder); };
        directive.$inject = [
            '$hibachi',
            '$timeout',
            'collectionConfigService',
            'observerService',
            'fulfillmentBatchDetailPartialsPath',
            'slatwallPathBuilder'
        ];
        return directive;
    };
    return SWFulfillmentBatchDetail;
}());
exports.SWFulfillmentBatchDetail = SWFulfillmentBatchDetail;


/***/ }),

/***/ "ISbx":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
exports.SWPricingManagerController = exports.SWPricingManager = void 0;
var SWPricingManagerController = /** @class */ (function () {
    //@ngInject
    SWPricingManagerController.$inject = ["collectionConfigService"];
    function SWPricingManagerController(collectionConfigService) {
        var _this = this;
        this.collectionConfigService = collectionConfigService;
        this.productCollectionConfig = this.collectionConfigService.newCollectionConfig("Product");
        this.productCollectionConfig.addFilter("productID", this.productId, "=", 'AND', true);
        this.productCollectionConfig.addDisplayProperty("productID,defaultSku.currencyCode");
        this.productCollectionConfig.getEntity().then(function (response) {
            _this.product = response.pageRecords[0];
        }, function (reason) {
        });
        this.skuPriceCollectionConfig = this.collectionConfigService.newCollectionConfig("SkuPrice");
        this.skuPriceCollectionConfig.setDisplayProperties("sku.skuName,sku.skuCode,sku.calculatedSkuDefinition,activeFlag,priceGroup.priceGroupName,currencyCode");
        this.skuPriceCollectionConfig.addDisplayProperty("price", "", { isEditable: true });
        this.skuPriceCollectionConfig.addDisplayProperty("listPrice", "", { isEditable: true });
        this.skuPriceCollectionConfig.addDisplayProperty("minQuantity", "", { isEditable: true });
        this.skuPriceCollectionConfig.addDisplayProperty("maxQuantity", "", { isEditable: true });
        this.skuPriceCollectionConfig.addDisplayProperty("skuPriceID", "", { isVisible: false, isSearchable: false });
        this.skuPriceCollectionConfig.addDisplayProperty("sku.skuID", "", { isVisible: false, isSearchable: false });
        this.skuPriceCollectionConfig.addDisplayProperty("sku.imagePath", "", { isVisible: false, isSearchable: false });
        this.skuPriceCollectionConfig.addDisplayProperty("priceGroup.priceGroupID", "", { isVisible: false, isSearchable: false });
        this.skuPriceCollectionConfig.addFilter("sku.product.productID", this.productId, "=", "AND", true);
        this.skuPriceCollectionConfig.setOrderBy('sku.skuCode|ASC,minQuantity|ASC,priceGroup.priceGroupCode|ASC,currencyCode|ASC');
    }
    return SWPricingManagerController;
}());
exports.SWPricingManagerController = SWPricingManagerController;
var SWPricingManager = /** @class */ (function () {
    function SWPricingManager() {
        this.template = __webpack_require__("j7U+");
        this.restrict = 'EA';
        this.priority = 1000;
        this.scope = {};
        this.bindToController = {
            productId: "@",
            trackInventory: "=?"
        };
        this.controller = SWPricingManagerController;
        this.controllerAs = "swPricingManager";
    }
    SWPricingManager.Factory = function () {
        var _this = this;
        return function () { return new _this(); };
    };
    return SWPricingManager;
}());
exports.SWPricingManager = SWPricingManager;


/***/ }),

/***/ "IYLP":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
exports.SWOrderItems = void 0;
/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
var SWOrderItems = /** @class */ (function () {
    //@ngInject
    SWOrderItems.$inject = ["$log", "$timeout", "$location", "$hibachi", "collectionConfigService", "formService", "orderItemPartialsPath", "slatwallPathBuilder", "paginationService", "observerService"];
    function SWOrderItems($log, $timeout, $location, $hibachi, collectionConfigService, formService, orderItemPartialsPath, slatwallPathBuilder, paginationService, observerService) {
        return {
            restrict: 'E',
            scope: {
                orderId: "@"
            },
            templateUrl: slatwallPathBuilder.buildPartialsPath(orderItemPartialsPath) + "orderitems.html",
            link: function (scope, element, attrs) {
                var options = {};
                scope.keywords = "";
                scope.loadingCollection = false;
                scope.$watch('recordsCount', function (newValue, oldValue, scope) {
                    //Do anything with $scope.letters
                    if (oldValue != undefined && newValue != undefined && newValue.length > oldValue.length) {
                        //refresh so order totals refresh.
                        window.location.reload();
                    }
                });
                var searchPromise;
                scope.searchCollection = function () {
                    if (searchPromise) {
                        $timeout.cancel(searchPromise);
                    }
                    searchPromise = $timeout(function () {
                        $log.debug('search with keywords');
                        $log.debug(scope.keywords);
                        //Set current page here so that the pagination does not break when getting collection
                        scope.paginator.setCurrentPage(1);
                        scope.loadingCollection = true;
                        scope.getCollection();
                    }, 500);
                };
                $log.debug('Init Order Item');
                $log.debug(scope.orderId);
                //Setup the data needed for each order item object.
                scope.getCollection = function () {
                    if (scope.pageShow === 'Auto') {
                        scope.pageShow = 50;
                    }
                    var orderItemCollection = collectionConfigService.newCollectionConfig('OrderItem');
                    orderItemCollection.setDisplayProperties("orderItemID,currencyCode,sku.skuName\n                         ,price,skuPrice,sku.skuID,sku.skuCode,productBundleGroup.productBundleGroupID\n\t\t\t\t\t\t ,sku.product.productID\n \t\t\t\t\t\t ,sku.product.productName,sku.product.productDescription\n\t\t\t\t\t\t ,sku.eventStartDateTime\n \t\t\t\t\t\t ,quantity\n\t\t\t\t\t\t ,orderFulfillment.fulfillmentMethod.fulfillmentMethodName\n\t\t\t\t\t\t ,orderFulfillment.orderFulfillmentID\n \t\t\t\t\t\t ,orderFulfillment.shippingAddress.streetAddress\n     \t\t\t\t\t ,orderFulfillment.shippingAddress.street2Address\n\t\t\t\t\t\t ,orderFulfillment.shippingAddress.postalCode\n\t\t\t\t\t\t ,orderFulfillment.shippingAddress.city,orderFulfillment.shippingAddress.stateCode\n \t\t\t\t\t\t ,orderFulfillment.shippingAddress.countryCode\n                         ,orderItemType.systemCode\n\t\t\t\t\t\t ,orderFulfillment.fulfillmentMethod.fulfillmentMethodType\n                         ,orderFulfillment.pickupLocation.primaryAddress.address.streetAddress\n\t\t\t\t\t\t ,orderFulfillment.pickupLocation.primaryAddress.address.street2Address\n                         ,orderFulfillment.pickupLocation.primaryAddress.address.city\n\t\t\t\t\t\t ,orderFulfillment.pickupLocation.primaryAddress.address.stateCode\n                         ,orderFulfillment.pickupLocation.primaryAddress.address.postalCode\n\t\t\t\t\t\t ,orderReturn.orderReturnID\n \t\t\t\t\t\t ,orderReturn.returnLocation.primaryAddress.address.streetAddress\n\t\t\t\t\t\t ,orderReturn.returnLocation.primaryAddress.address.street2Address\n                         ,orderReturn.returnLocation.primaryAddress.address.city\n\t\t\t\t\t\t ,orderReturn.returnLocation.primaryAddress.address.stateCode\n                         ,orderReturn.returnLocation.primaryAddress.address.postalCode\n\t\t\t\t\t\t ,itemTotal,discountAmount,taxAmount,extendedPrice,productBundlePrice,sku.baseProductType\n                         ,sku.subscriptionBenefits\n\t\t\t\t\t\t ,sku.product.productType.systemCode\n\t\t\t\t\t\t ,sku.bundleFlag \n\t\t\t\t\t\t ,sku.options\n\t\t\t\t\t\t ,sku.locations\n \t\t\t\t\t\t ,sku.subscriptionTerm.subscriptionTermName\n \t\t\t\t\t\t ,sku.imageFile\n                         ,stock.location.locationName")
                        .addFilter('order.orderID', scope.orderId)
                        .addFilter('parentOrderItem', 'null', 'IS')
                        .setKeywords(scope.keywords)
                        .setPageShow(scope.paginator.getPageShow())
                        .setCurrentPage(scope.paginator.getCurrentPage());
                    //add attributes to the column config
                    angular.forEach(scope.attributes, function (attribute) {
                        var attributeColumn = {
                            propertyIdentifier: "_orderitem." + attribute.attributeCode,
                            attributeID: attribute.attributeID,
                            attributeSetObject: "orderItem"
                        };
                        orderItemCollection.columns.push(attributeColumn);
                    });
                    var orderItemsPromise = orderItemCollection.getEntity();
                    orderItemsPromise.then(function (value) {
                        scope.collection = value;
                        var collectionConfig = {};
                        scope.recordsCount = value.pageRecords;
                        scope.orderItems = $hibachi.populateCollection(value.pageRecords, orderItemCollection);
                        for (var orderItem in scope.orderItems) {
                            $log.debug("OrderItem Product Type");
                            $log.debug(scope.orderItems);
                            //orderItem.productType = orderItem.data.sku.data.product.data.productType.$$getParentProductType();
                        }
                        scope.paginator.setPageRecordsInfo(scope.collection);
                        scope.loadingCollection = false;
                    }, function (value) {
                        scope.orderItems = [];
                    });
                };
                var attributesCollection = collectionConfigService.newCollectionConfig('Attribute');
                attributesCollection.setDisplayProperties('attributeID,attributeCode,attributeName')
                    .addFilter('displayOnOrderDetailFlag', true)
                    .addFilter('activeFlag', true)
                    .setAllRecords(true);
                var attItemsPromise = attributesCollection.getEntity();
                attItemsPromise.then(function (value) {
                    scope.attributes = [];
                    angular.forEach(value.records, function (attributeItemData) {
                        //Use that custom attribute name to get the value.
                        scope.attributes.push(attributeItemData);
                    });
                    scope.getCollection();
                });
                //Add claim function and cancel function
                /*scope.appendToCollection = function(){
                    if(scope.pageShow === 'Auto'){
                        $log.debug('AppendToCollection');
                        if(scope.paginator.autoScrollPage < scope.collection.totalPages){
                            scope.paginator.autoScrollDisabled = true;
                            scope.paginator.autoScrollPage++;

                            var appendOptions:any = {};
                            angular.extend(appendOptions,options);
                            appendOptions.pageShow = 50;
                            appendOptions.currentPage = scope.paginator.autoScrollPage;

                            var collectionListingPromise = $hibachi.getEntity('orderItem', appendOptions);
                            collectionListingPromise.then(function(value){
                                scope.collection.pageRecords = scope.collection.pageRecords.concat(value.pageRecords);
                                scope.autoScrollDisabled = false;
                            },function(reason){
                                scope.collection.pageRecords = [];
                            });
                        }
                    }
                };*/
                scope.paginator = paginationService.createPagination();
                scope.paginator.notifyById = false;
                scope.paginator.collection = scope.collection;
                scope.paginator.getCollection = scope.getCollection;
                //set up custom event as temporary fix to update when new sku is adding via jquery ajax instead of angular scope
                $(document).on("listingDisplayUpdate", {}, function (event, arg1, arg2) {
                    scope.orderItems = undefined;
                    scope.getCollection();
                });
                observerService.attach(scope.getCollection, 'swPaginationAction');
            } //<--End link
        };
    }
    SWOrderItems.Factory = function () {
        var directive = function ($log, $timeout, $location, $hibachi, collectionConfigService, formService, orderItemPartialsPath, slatwallPathBuilder, paginationService, observerService) { return new SWOrderItems($log, $timeout, $location, $hibachi, collectionConfigService, formService, orderItemPartialsPath, slatwallPathBuilder, paginationService, observerService); };
        directive.$inject = [
            '$log',
            '$timeout',
            '$location',
            '$hibachi',
            'collectionConfigService',
            'formService',
            'orderItemPartialsPath',
            'slatwallPathBuilder',
            'paginationService',
            'observerService'
        ];
        return directive;
    };
    return SWOrderItems;
}());
exports.SWOrderItems = SWOrderItems;


/***/ }),

/***/ "IvXh":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
exports.SWOrderTemplateGiftCards = void 0;
/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
var SWOrderTemplateGiftCardsController = /** @class */ (function () {
    function SWOrderTemplateGiftCardsController($hibachi, collectionConfigService, observerService, orderTemplateService, rbkeyService) {
        var _this = this;
        this.$hibachi = $hibachi;
        this.collectionConfigService = collectionConfigService;
        this.observerService = observerService;
        this.orderTemplateService = orderTemplateService;
        this.rbkeyService = rbkeyService;
        this.edit = false;
        this.$onInit = function () {
            _this.giftCardCollection = _this.collectionConfigService.newCollectionConfig('OrderTemplateAppliedGiftCard');
            _this.giftCardCollection.addFilter('orderTemplate.orderTemplateID', _this.orderTemplate.orderTemplateID, '=', undefined, true);
            _this.giftCardCollection.setDisplayProperties('giftCard.giftCardCode,giftCard.calculatedBalanceAmount,amountToApply', '', { isVisible: true, isSearchable: true, isDeletable: true, isEditable: false });
            _this.giftCardCollection.addDisplayProperty('orderTemplateAppliedGiftCardID', '', { isVisible: false, isSearchable: false, isDeletable: true, isEditable: false });
        };
    }
    return SWOrderTemplateGiftCardsController;
}());
var SWOrderTemplateGiftCards = /** @class */ (function () {
    function SWOrderTemplateGiftCards(orderPartialsPath, slatwallPathBuilder, $hibachi, rbkeyService) {
        this.orderPartialsPath = orderPartialsPath;
        this.slatwallPathBuilder = slatwallPathBuilder;
        this.$hibachi = $hibachi;
        this.rbkeyService = rbkeyService;
        this.restrict = "EA";
        this.scope = {};
        this.bindToController = {
            orderTemplate: '<?',
            customerGiftCards: '<?'
        };
        this.controller = SWOrderTemplateGiftCardsController;
        this.controllerAs = "swOrderTemplateGiftCards";
        this.link = function (scope, element, attrs) {
        };
        this.templateUrl = slatwallPathBuilder.buildPartialsPath(orderPartialsPath) + "/ordertemplategiftcards.html";
    }
    SWOrderTemplateGiftCards.Factory = function () {
        var directive = function (orderPartialsPath, slatwallPathBuilder, $hibachi, rbkeyService) { return new SWOrderTemplateGiftCards(orderPartialsPath, slatwallPathBuilder, $hibachi, rbkeyService); };
        directive.$inject = [
            'orderPartialsPath',
            'slatwallPathBuilder',
            '$hibachi',
            'rbkeyService'
        ];
        return directive;
    };
    return SWOrderTemplateGiftCards;
}());
exports.SWOrderTemplateGiftCards = SWOrderTemplateGiftCards;


/***/ }),

/***/ "J78N":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
exports.TermService = void 0;
/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
var TermService = /** @class */ (function () {
    //@ngInject
    TermService.$inject = ["$hibachi"];
    function TermService($hibachi) {
        var _this = this;
        this.$hibachi = $hibachi;
        this.getTermScheduledDates = function (term, startDate, iterations) {
            if (iterations === void 0) { iterations = 6; }
            var currentDate = startDate;
            var scheduleDates = [];
            scheduleDates.push(currentDate);
            iterations--;
            for (var i = 0; i < iterations; i++) {
                currentDate = _this.getEndDate(term, currentDate);
                scheduleDates.push(currentDate);
            }
            return scheduleDates;
        };
        this.getEndDate = function (term, startDate) {
            var endDate = new Date(startDate.getTime());
            if (term.termHours != null) {
                endDate.setHours(startDate.getHours() + term.termHours);
            }
            if (term.termDays != null) {
                endDate.setDate(startDate.getDate() + term.termDays);
            }
            if (term.termWeeks != null) {
                endDate.setDate(startDate.getDate() + (term.termWeeks * 7));
            }
            if (term.termMonths != null) {
                endDate.setMonth(startDate.getMonth() + term.termMonths);
            }
            if (term.termYears != null) {
                endDate.setFullYear(startDate.getFullYear() + term.termYears);
            }
            return endDate;
        };
    }
    return TermService;
}());
exports.TermService = TermService;


/***/ }),

/***/ "K6E2":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
exports.termmodule = void 0;
/// <reference path='../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../typings/tsd.d.ts' />
//modules
var core_module_1 = __webpack_require__("pwA0");
var swtermscheduletable_1 = __webpack_require__("IJbb");
var termservice_1 = __webpack_require__("J78N");
var termmodule = angular.module('term', [core_module_1.coremodule.name])
    .config([function () {
    }]).run([function () {
    }])
    //constants
    .constant('termPartialsPath', 'term/components/')
    //controllers
    .directive('swTermScheduleTable', swtermscheduletable_1.SWTermScheduleTable.Factory())
    .service('termService', termservice_1.TermService);
exports.termmodule = termmodule;


/***/ }),

/***/ "KJW6":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
Object.defineProperty(exports, "__esModule", { value: true });
exports.SWSiteSelector = exports.SWSiteSelectorController = void 0;
var SWSiteSelectorController = /** @class */ (function () {
    //@ngInject
    SWSiteSelectorController.$inject = ["collectionConfigService", "listingService", "localStorageService", "typeaheadService", "utilityService"];
    function SWSiteSelectorController(collectionConfigService, listingService, localStorageService, typeaheadService, utilityService) {
        var _this = this;
        this.collectionConfigService = collectionConfigService;
        this.listingService = listingService;
        this.localStorageService = localStorageService;
        this.typeaheadService = typeaheadService;
        this.utilityService = utilityService;
        this.selectSite = function () {
            if (!_this.collectionConfigToFilter && _this.swListingDisplay) {
                _this.collectionConfigToFilter = _this.swListingDisplay.collectionConfig;
            }
            _this.collectionConfigToFilter.removeFilterByDisplayPropertyIdentifier(_this.simpleFilterPropertyIdentifier);
            console.log("selectSite", _this.selectedSite);
            switch (_this.selectedSite) {
                case "all":
                    //do nothing
                    console.log("donothing");
                    break;
                case "default":
                    _this.updateDefaultSiteID();
                    if (_this.defaultEstablished) {
                        console.log("adding filter", _this.defaultSiteID);
                        _this.collectionConfigToFilter.addFilter(_this.filterPropertyIdentifier, _this.defaultSiteID, "=");
                    }
                    break;
                case undefined:
                    //do nothing
                    break;
                default:
                    _this.localStorageService.setItem("defaultSiteID", _this.selectedSite);
                    _this.collectionConfigToFilter.addFilter(_this.filterPropertyIdentifier, _this.selectedSite, "=");
                    break;
            }
            if (_this.withTypeahead && _this.typeaheadDataKey != null) {
                _this.typeaheadService.getData(_this.typeaheadDataKey);
            }
            if (_this.inListingDisplay && _this.listingID != null) {
                _this.listingService.getCollection(_this.listingID);
            }
        };
        this.updateDefaultSiteID = function () {
            console.log("updating default established");
            if (_this.localStorageService.hasItem("defaultSiteID")) {
                _this.defaultEstablished = true;
                _this.defaultSiteID = _this.localStorageService.getItem("defaultSiteID");
            }
            else {
                console.log("default established false");
                _this.defaultEstablished = false;
            }
        };
        if (angular.isUndefined(this.disabled)) {
            this.disabled = false;
        }
        if (angular.isUndefined(this.simpleFilterPropertyIdentifier)) {
            this.simpleFilterPropertyIdentifier = "siteID";
        }
        this.sitesCollectionConfig = collectionConfigService.newCollectionConfig("Site");
        this.sitesCollectionConfig.addDisplayProperty("siteID, siteName, siteCode");
        this.sitesCollectionConfig.setAllRecords(true);
        this.sitesCollectionConfig.getEntity().then(function (data) {
            _this.sites = data.records;
            if (_this.sites[0]) {
                _this.selectedSite = _this.sites[0].siteID;
            }
        }, function (reason) {
            throw ("SWProductListingPages had trouble fetching sites because of " + reason);
        }).finally(function () {
            _this.selectSite();
        });
    }
    return SWSiteSelectorController;
}());
exports.SWSiteSelectorController = SWSiteSelectorController;
var SWSiteSelector = /** @class */ (function () {
    //@ngInject
    SWSiteSelector.$inject = ["$http", "$hibachi", "listingService", "contentPartialsPath", "slatwallPathBuilder"];
    function SWSiteSelector($http, $hibachi, listingService, contentPartialsPath, slatwallPathBuilder) {
        var _this = this;
        this.$http = $http;
        this.$hibachi = $hibachi;
        this.listingService = listingService;
        this.contentPartialsPath = contentPartialsPath;
        this.slatwallPathBuilder = slatwallPathBuilder;
        this.restrict = "EA";
        this.scope = {};
        this.require = { swListingDisplay: '?^swListingDisplay' };
        this.bindToController = {
            inListingDisplay: "=?",
            filterPropertyIdentifier: "@?",
            collectionConfigToFilter: "=?",
            withTypeahead: "=?",
            typeaheadDataKey: "@?",
            disabled: "=?"
        };
        this.controller = SWSiteSelectorController;
        this.controllerAs = "swSiteSelector";
        this.link = function ($scope, element, attrs) {
            if ($scope.swSiteSelector.withTypeahead == null) {
                $scope.swSiteSelector.withTypeahead = false;
            }
            if ($scope.swSiteSelector.inListingDisplay == null) {
                $scope.swSiteSelector.inListingDisplay = !$scope.swSiteSelector.withTypeahead;
            }
            if ($scope.swSiteSelector.inListingDisplay == true && $scope.swSiteSelector.swListingDisplay) {
                var listingDisplayScope = $scope.swSiteSelector.swListingDisplay;
                $scope.swSiteSelector.listingID = listingDisplayScope.tableID;
                if (listingDisplayScope.collectionConfig != null) {
                    $scope.swSiteSelector.collectionConfigToFilter = listingDisplayScope.collectionConfig;
                }
                _this.listingService.attachToListingInitiated($scope.swSiteSelector.listingID, $scope.swSiteSelector.selectSite);
            }
            else {
                $scope.swSiteSelector.selectSite();
            }
        };
        this.templateUrl = slatwallPathBuilder.buildPartialsPath(contentPartialsPath) + "/siteselector.html";
    }
    SWSiteSelector.Factory = function () {
        var directive = function ($http, $hibachi, listingService, contentPartialsPath, slatwallPathBuilder) { return new SWSiteSelector($http, $hibachi, listingService, contentPartialsPath, slatwallPathBuilder); };
        directive.$inject = [
            '$http',
            '$hibachi',
            'listingService',
            'contentPartialsPath',
            'slatwallPathBuilder'
        ];
        return directive;
    };
    return SWSiteSelector;
}());
exports.SWSiteSelector = SWSiteSelector;


/***/ }),

/***/ "KgMj":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
exports.SWAddOptionGroup = exports.SWAddOptionGroupController = exports.optionWithGroup = void 0;
/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
var md5 = __webpack_require__("ssIG");
var optionWithGroup = /** @class */ (function () {
    function optionWithGroup(optionID, optionGroupID, match) {
        var _this = this;
        this.optionID = optionID;
        this.optionGroupID = optionGroupID;
        this.match = match;
        this.toString = function () {
            return _this.optionID;
        };
    }
    return optionWithGroup;
}());
exports.optionWithGroup = optionWithGroup;
var SWAddOptionGroupController = /** @class */ (function () {
    // @ngInject
    SWAddOptionGroupController.$inject = ["$hibachi", "$timeout", "collectionConfigService", "observerService", "utilityService"];
    function SWAddOptionGroupController($hibachi, $timeout, collectionConfigService, observerService, utilityService) {
        var _this = this;
        this.$hibachi = $hibachi;
        this.$timeout = $timeout;
        this.collectionConfigService = collectionConfigService;
        this.observerService = observerService;
        this.utilityService = utilityService;
        this.getOptionList = function () {
            _this.selection.sort();
            return _this.utilityService.arrayToList(_this.selection);
        };
        this.validateOptions = function (args) {
            _this.addToSelection(args[0], args[1].optionGroupId);
            if (_this.hasCompleteSelection()) {
                _this.validateSelection();
            }
        };
        this.validateSelection = function () {
            var optionList = _this.getOptionList();
            var validateSkuCollectionConfig = _this.collectionConfigService.newCollectionConfig("Sku");
            if (_this.optionGroupIds.length > 1) {
                validateSkuCollectionConfig.addDisplayProperty("calculatedOptionsHash");
                validateSkuCollectionConfig.addFilter("product.productID", _this.productId);
                validateSkuCollectionConfig.addFilter("skuID", _this.skuId, "!=");
                validateSkuCollectionConfig.addFilter("calculatedOptionsHash", md5(optionList));
                validateSkuCollectionConfig.setAllRecords(true);
                validateSkuCollectionConfig.getEntity().then(function (response) {
                    if (response.records && response.records.length == 0) {
                        _this.selectedOptionList = _this.getOptionList();
                        _this.showValidFlag = true;
                        _this.showInvalidFlag = false;
                    }
                    else {
                        _this.showValidFlag = false;
                        _this.showInvalidFlag = true;
                    }
                });
            }
            else {
                validateSkuCollectionConfig.addFilter("product.productID", _this.productId);
                validateSkuCollectionConfig.addFilter("options.optionID", optionList);
                validateSkuCollectionConfig.setAllRecords(true);
                validateSkuCollectionConfig.getEntity().then(function (response) {
                    if (response.records && response.records.length == 0) {
                        _this.selectedOptionList = _this.getOptionList();
                        _this.showValidFlag = true;
                        _this.showInvalidFlag = false;
                    }
                    else {
                        _this.showValidFlag = false;
                        _this.showInvalidFlag = true;
                    }
                });
            }
        };
        this.hasCompleteSelection = function () {
            var answer = true;
            angular.forEach(_this.selection, function (pair) {
                if (pair.optionID.length === 0) {
                    answer = false;
                }
            });
            return answer;
        };
        this.addToSelection = function (optionId, optionGroupId) {
            angular.forEach(_this.selection, function (pair) {
                if (pair.optionGroupID === optionGroupId) {
                    pair.optionID = optionId;
                    return true;
                }
            });
            return false;
        };
        this.optionGroupIds = this.optionGroups.split(",");
        this.optionGroupIds.sort();
        this.selection = [];
        this.showValidFlag = false;
        this.showInvalidFlag = false;
        for (var i = 0; i < this.optionGroupIds.length; i++) {
            this.selection.push(new optionWithGroup("", this.optionGroupIds[i], false));
        }
        //get current selections
        this.optionCollectionConfig = collectionConfigService.newCollectionConfig("Option");
        this.optionCollectionConfig.setDisplayProperties('optionID,optionGroup.optionGroupID');
        this.optionCollectionConfig.addFilter('skus.skuID', this.skuId);
        this.optionCollectionConfig.setAllRecords(true);
        this.optionCollectionConfig.getEntity().then(function (response) {
            _this.savedOptions = {};
            if (response.records) {
                for (var kk in response.records) {
                    var record = response.records[kk];
                    _this.savedOptions[record['optionGroup_optionGroupID']] = record['optionID'];
                    _this.addToSelection(record['optionID'], record['optionGroup_optionGroupID']);
                }
            }
        });
        this.observerService.attach(this.validateOptions, "validateOptions");
    }
    return SWAddOptionGroupController;
}());
exports.SWAddOptionGroupController = SWAddOptionGroupController;
var SWAddOptionGroup = /** @class */ (function () {
    // @ngInject
    SWAddOptionGroup.$inject = ["$hibachi", "$timeout", "collectionConfigService", "observerService", "optionGroupPartialsPath", "slatwallPathBuilder"];
    function SWAddOptionGroup($hibachi, $timeout, collectionConfigService, observerService, optionGroupPartialsPath, slatwallPathBuilder) {
        var _this = this;
        this.$hibachi = $hibachi;
        this.$timeout = $timeout;
        this.collectionConfigService = collectionConfigService;
        this.observerService = observerService;
        this.optionGroupPartialsPath = optionGroupPartialsPath;
        this.restrict = "EA";
        this.scope = {};
        this.bindToController = {
            productId: "@",
            skuId: "@",
            optionGroups: "="
        };
        this.controller = SWAddOptionGroupController;
        this.controllerAs = "swAddOptionGroup";
        this.link = function (scope, element, attrs) {
            // element used for when jquery is deleting DOM instead of angular such as a jQuery('#adminModal').html(html);
            element.on('$destroy', function () {
                _this.observerService.detachByEvent('validateOptions');
            });
            scope.$on('$destroy', function () {
                _this.observerService.detachByEvent('validateOptions');
            });
        };
        this.templateUrl = slatwallPathBuilder.buildPartialsPath(optionGroupPartialsPath) + "addoptiongroup.html";
    }
    SWAddOptionGroup.Factory = function () {
        var directive = function ($hibachi, $timeout, collectionConfigService, observerService, optionGroupPartialsPath, slatwallPathBuilder) { return new SWAddOptionGroup($hibachi, $timeout, collectionConfigService, observerService, optionGroupPartialsPath, slatwallPathBuilder); };
        directive.$inject = [
            '$hibachi',
            '$timeout',
            'collectionConfigService',
            'observerService',
            'optionGroupPartialsPath',
            'slatwallPathBuilder'
        ];
        return directive;
    };
    return SWAddOptionGroup;
}());
exports.SWAddOptionGroup = SWAddOptionGroup;


/***/ }),

/***/ "LT6+":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
exports.SWEditSkuPriceModalLauncherController = exports.SWEditSkuPriceModalLauncher = void 0;
var SWEditSkuPriceModalLauncherController = /** @class */ (function () {
    //@ngInject
    SWEditSkuPriceModalLauncherController.$inject = ["$hibachi", "entityService", "formService", "listingService", "observerService", "skuPriceService", "utilityService", "scopeService", "$scope"];
    function SWEditSkuPriceModalLauncherController($hibachi, entityService, formService, listingService, observerService, skuPriceService, utilityService, scopeService, $scope) {
        var _this = this;
        this.$hibachi = $hibachi;
        this.entityService = entityService;
        this.formService = formService;
        this.listingService = listingService;
        this.observerService = observerService;
        this.skuPriceService = skuPriceService;
        this.utilityService = utilityService;
        this.scopeService = scopeService;
        this.$scope = $scope;
        this.baseName = "j-add-sku-item-";
        this.currencyCodeEditable = false;
        this.priceGroupEditable = false;
        this.currencyCodeOptions = [];
        this.saveSuccess = true;
        this.updateCurrencyCodeSelector = function (args) {
            if (args != 'All') {
                _this.skuPrice.data.currencyCode = args;
                _this.currencyCodeEditable = false;
            }
            else {
                _this.currencyCodeEditable = true;
            }
            _this.observerService.notify("pullBindings");
        };
        this.initData = function (pageRecord) {
            _this.pageRecord = pageRecord;
            if (angular.isDefined(pageRecord)) {
                var skuPriceData = {
                    skuPriceID: pageRecord.skuPriceID,
                    minQuantity: pageRecord.minQuantity,
                    maxQuantity: pageRecord.maxQuantity,
                    currencyCode: pageRecord.currencyCode,
                    price: pageRecord.price
                };
                var skuData = {
                    skuID: pageRecord["sku_skuID"],
                    skuCode: pageRecord["sku_skuCode"],
                    calculatedSkuDefinition: pageRecord["sku_calculatedSkuDefinition"]
                };
                var priceGroupData = {
                    priceGroupID: pageRecord["priceGroup_priceGroupID"],
                    priceGroupCode: pageRecord["priceGroup_priceGroupCode"]
                };
                //reference to form is being wiped
                if (_this.skuPrice) {
                    var skuPriceForms = _this.skuPrice.forms;
                }
                _this.skuPrice = _this.$hibachi.populateEntity('SkuPrice', skuPriceData);
                if (skuPriceForms) {
                    _this.skuPrice.forms = skuPriceForms;
                }
                if (_this.sku) {
                    var skuForms = _this.sku.forms;
                }
                _this.sku = _this.$hibachi.populateEntity('Sku', skuData);
                if (skuForms) {
                    _this.skuPrice.forms = skuForms;
                }
                if (_this.priceGroup) {
                    var priceGroupForms = _this.priceGroup.forms;
                }
                _this.priceGroup = _this.$hibachi.populateEntity('PriceGroup', priceGroupData);
                if (priceGroupForms) {
                    _this.priceGroup.forms = priceGroupForms;
                }
                _this.skuPriceService.getPriceGroupOptions().then(function (response) {
                    _this.priceGroupOptions = response.records;
                    _this.priceGroupOptions.unshift({ priceGroupName: "- Select Price Group -", priceGroupID: "" });
                }).finally(function () {
                    _this.selectedPriceGroup = _this.priceGroupOptions[0];
                    for (var i = 0; i < _this.priceGroupOptions.length; i++) {
                        if (_this.pageRecord['priceGroup_priceGroupID'] == _this.priceGroupOptions[i].priceGroupID) {
                            _this.selectedPriceGroup = _this.priceGroupOptions[i];
                        }
                    }
                    if (!_this.selectedPriceGroup['priceGroupID']) {
                        _this.priceGroupEditable = true;
                    }
                });
                _this.skuPriceService.getCurrencyOptions().then(function (response) {
                    if (response.records.length) {
                        _this.currencyCodeOptions = [];
                        for (var i = 0; i < response.records.length; i++) {
                            _this.currencyCodeOptions.push(response.records[i]['currencyCode']);
                        }
                        _this.currencyCodeOptions.unshift("- Select Currency Code -");
                        _this.selectedCurrencyCode = _this.currencyCodeOptions[0];
                        for (var i = 0; i < _this.currencyCodeOptions.length; i++) {
                            if (_this.pageRecord['currencyCode'] == _this.currencyCodeOptions[i]) {
                                _this.selectedCurrencyCode = _this.currencyCodeOptions[i];
                            }
                        }
                    }
                });
                _this.skuPrice.$$setPriceGroup(_this.priceGroup);
                _this.skuPrice.$$setSku(_this.sku);
            }
            else {
                return;
            }
            _this.observerService.notify("pullBindings");
        };
        this.setSelectedPriceGroup = function (priceGroupData) {
            if (!priceGroupData.priceGroupID) {
                _this.submittedPriceGroup = {};
                return;
            }
            _this.submittedPriceGroup = { priceGroupID: priceGroupData['priceGroupID'] };
        };
        this.$onDestroy = function () {
            console.log("$onDestroy called");
            _this.observerService.detachByEvent('EDIT_SKUPRICE');
        };
        this.save = function () {
            _this.observerService.notify("updateBindings");
            var firstSkuPriceForSku = !_this.skuPriceService.hasSkuPrices(_this.sku.data.skuID);
            if (_this.submittedPriceGroup) {
                _this.priceGroup.priceGroupID = _this.submittedPriceGroup.priceGroupID;
                _this.priceGroup.priceGroupCode = _this.submittedPriceGroup.priceGroupCode;
            }
            var savePromise = _this.skuPrice.$$save();
            savePromise.then(function (response) {
                _this.saveSuccess = true;
                _this.observerService.notify('skuPricesUpdate', { skuID: _this.sku.data.skuID, refresh: true });
                //hack, for whatever reason is not responding to getCollection event
                _this.observerService.notifyById('swPaginationAction', _this.listingID, { type: 'setCurrentPage', payload: 1 });
                var form = _this.formService.getForm(_this.formName);
                _this.formService.resetForm(form);
            }, function (reason) {
                //error callback
                console.log("validation failed because: ", reason);
                _this.saveSuccess = false;
            }).finally(function () {
                if (_this.saveSuccess) {
                    for (var key in _this.skuPrice.data) {
                        if (key != 'sku' && key != 'currencyCode') {
                            _this.skuPrice.data[key] = null;
                        }
                    }
                    _this.formService.resetForm(_this.formService.getForm(_this.formName));
                    _this.listingService.getCollection(_this.listingID);
                    _this.listingService.notifyListingPageRecordsUpdate(_this.listingID);
                }
            });
            return savePromise;
        };
        this.uniqueName = this.baseName + this.utilityService.createID(16);
        this.formName = "editSkuPrice" + this.utilityService.createID(16);
        //hack for listing hardcodeing id
        this.listingID = 'pricingListing';
        this.observerService.attach(this.initData, "EDIT_SKUPRICE");
    }
    return SWEditSkuPriceModalLauncherController;
}());
exports.SWEditSkuPriceModalLauncherController = SWEditSkuPriceModalLauncherController;
var SWEditSkuPriceModalLauncher = /** @class */ (function () {
    function SWEditSkuPriceModalLauncher() {
        this.template = __webpack_require__("hzQV");
        this.restrict = 'EA';
        this.transclude = true;
        this.scope = {};
        this.bindToController = {
            sku: "=?",
            pageRecord: "=?",
            minQuantity: "@?",
            maxQuantity: "@?",
            priceGroupId: "@?",
            currencyCode: "@?",
            eligibleCurrencyCodeList: "@?",
            defaultCurrencyOnly: "=?",
            disableAllFieldsButPrice: "=?"
        };
        this.controller = SWEditSkuPriceModalLauncherController;
        this.controllerAs = "swEditSkuPriceModalLauncher";
    }
    ;
    SWEditSkuPriceModalLauncher.Factory = function () {
        var _this = this;
        return function () { return new _this(); };
    };
    return SWEditSkuPriceModalLauncher;
}());
exports.SWEditSkuPriceModalLauncher = SWEditSkuPriceModalLauncher;


/***/ }),

/***/ "Mtva":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
exports.SWOrderItemGiftRecipientRow = exports.SWOrderItemGiftRecipientRowController = void 0;
/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
var SWOrderItemGiftRecipientRowController = /** @class */ (function () {
    function SWOrderItemGiftRecipientRowController() {
        var _this = this;
        this.edit = function (recipient) {
            angular.forEach(_this.recipients, function (recipient) {
                recipient.editing = false;
            });
            if (!recipient.editing) {
                recipient.editing = true;
            }
        };
        this.delete = function (recipient) {
            _this.recipients.splice(_this.recipients.indexOf(recipient), 1);
        };
        this.saveGiftRecipient = function (recipient) {
            if (_this.tableForm.$valid) {
                _this.showInvalidRecipientMessage = false;
                recipient.editing = false;
            }
            else {
                _this.showInvalidRecipientMessage = true;
            }
        };
        this.getQuantity = function () {
            if (isNaN(_this.quantity)) {
                return 0;
            }
            else {
                return _this.quantity;
            }
        };
        this.getUnassignedCount = function () {
            var unassignedCount = _this.getQuantity();
            angular.forEach(_this.recipients, function (recipient) {
                unassignedCount -= recipient.quantity;
            });
            return unassignedCount;
        };
        this.getMessageCharactersLeft = function () {
            if (angular.isDefined(_this.recipient.giftMessage) && _this.recipient.giftMessage != null) {
                return 250 - _this.recipient.giftMessage.length;
            }
            else {
                return 250;
            }
        };
        this.getUnassignedCountArray = function () {
            var unassignedCountArray = new Array();
            for (var i = 1; i <= _this.recipient.quantity + _this.getUnassignedCount(); i++) {
                unassignedCountArray.push(i);
            }
            return unassignedCountArray;
        };
    }
    return SWOrderItemGiftRecipientRowController;
}());
exports.SWOrderItemGiftRecipientRowController = SWOrderItemGiftRecipientRowController;
var SWOrderItemGiftRecipientRow = /** @class */ (function () {
    function SWOrderItemGiftRecipientRow(giftCardPartialsPath, slatwallPathBuilder) {
        var _this = this;
        this.giftCardPartialsPath = giftCardPartialsPath;
        this.slatwallPathBuilder = slatwallPathBuilder;
        this.restrict = 'AE';
        this.scope = {
            recipient: "=",
            recipients: "=",
            quantity: "=",
            showInvalidRecipientMessage: "=",
            tableForm: "=?",
            index: "="
        };
        this.bindToController = {
            recipient: "=",
            recipients: "=",
            quantity: "=",
            showInvalidRecipientMessage: "=",
            tableForm: "=?",
            index: "="
        };
        this.controller = SWOrderItemGiftRecipientRowController;
        this.controllerAs = "giftRecipientRowControl";
        this.init = function () {
            _this.templateUrl = _this.slatwallPathBuilder.buildPartialsPath(_this.giftCardPartialsPath) + "/orderitemgiftrecipientrow.html";
        };
        this.init();
    }
    SWOrderItemGiftRecipientRow.Factory = function () {
        var directive = function (giftCardPartialsPath, slatwallPathBuilder) { return new SWOrderItemGiftRecipientRow(giftCardPartialsPath, slatwallPathBuilder); };
        directive.$inject = [
            'giftCardPartialsPath',
            'slatwallPathBuilder'
        ];
        return directive;
    };
    return SWOrderItemGiftRecipientRow;
}());
exports.SWOrderItemGiftRecipientRow = SWOrderItemGiftRecipientRow;


/***/ }),

/***/ "NsNA":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
exports.addressmodule = void 0;
/// <reference path='../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../typings/tsd.d.ts' />
//modules
var core_module_1 = __webpack_require__("pwA0");
var swaddressformpartial_1 = __webpack_require__("Boeu");
var addressservice_1 = __webpack_require__("j8SH");
var addressmodule = angular.module('address', [core_module_1.coremodule.name])
    .config([function () {
    }]).run([function () {
    }])
    //constants
    .constant('addressPartialsPath', 'address/components/')
    //components
    .directive('swAddressFormPartial', swaddressformpartial_1.SWAddressFormPartial.Factory())
    //services
    .service('addressService', addressservice_1.AddressService);
exports.addressmodule = addressmodule;


/***/ }),

/***/ "NtNG":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
exports.SWAccountPaymentMethodModal = void 0;
/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
var SWAccountPaymentMethodModalController = /** @class */ (function () {
    function SWAccountPaymentMethodModalController($timeout, $hibachi, entityService, observerService, orderTemplateService, rbkeyService, requestService) {
        var _this = this;
        this.$timeout = $timeout;
        this.$hibachi = $hibachi;
        this.entityService = entityService;
        this.observerService = observerService;
        this.orderTemplateService = orderTemplateService;
        this.rbkeyService = rbkeyService;
        this.requestService = requestService;
        this.defaultCountryCode = 'US';
        this.title = "Edit Billing Information";
        this.modalButtonText = "Add Billing Information";
        this.uniqueName = 'accountPaymentMethodModal';
        this.formName = 'accountPaymentMethodModal';
        this.billingAccountAddressTitle = 'Select Billing Address';
        this.accountPaymentMethodTitle = 'Select Account Payment Method';
        this.processContext = 'updateBilling';
        this.hideSelectAccountAddress = false;
        this.hideSelectAccountPaymentMethod = false;
        this.showCreateBillingAddress = false;
        this.showCreateAccountPaymentMethod = false;
        this.createBillingAddressTitle = 'Add a new address';
        this.createAccountPaymentMethodTitle = 'Add a new payment method';
        this.$onInit = function () {
            _this.baseEntityName = _this.swCustomerAccountPaymentMethodCard.baseEntityName;
            _this.baseEntity = _this.swCustomerAccountPaymentMethodCard.baseEntity;
            _this.baseEntityPrimaryID = _this.baseEntity[_this.$hibachi.getPrimaryIDPropertyNameByEntityName(_this.baseEntityName)];
            _this.accountPaymentMethodTitle = _this.rbkeyService.rbKey('entity.' + _this.baseEntityName + '.accountPaymentMethod');
            _this.accountAddressOptions = _this.swCustomerAccountPaymentMethodCard.accountAddressOptions;
            _this.accountPaymentMethodOptions = _this.swCustomerAccountPaymentMethodCard.accountPaymentMethodOptions;
            _this.countryCodeOptions = _this.swCustomerAccountPaymentMethodCard.countryCodeOptions;
            _this.expirationMonthOptions = _this.swCustomerAccountPaymentMethodCard.expirationMonthOptions;
            _this.expirationYearOptions = _this.swCustomerAccountPaymentMethodCard.expirationYearOptions;
            _this.stateCodeOptions = _this.swCustomerAccountPaymentMethodCard.stateCodeOptions;
            _this.hideSelectAccountAddress = _this.accountAddressOptions.length === 0;
            _this.showCreateBillingAddress = _this.hideSelectAccountAddress;
            _this.hideSelectAccountPaymentMethod = _this.accountPaymentMethodOptions.length === 0;
            _this.showCreateAccountPaymentMethod = _this.hideSelectAccountPaymentMethod;
            if (!_this.hideSelectAccountAddress && _this.swCustomerAccountPaymentMethodCard.billingAccountAddress == null) {
                _this.baseEntity.billingAccountAddress = _this.accountAddressOptions[0];
            }
            else if (_this.swCustomerAccountPaymentMethodCard.billingAccountAddress != null) {
                _this.setBillingAccountAddress(_this.swCustomerAccountPaymentMethodCard.billingAccountAddress.accountAddressID);
            }
            if (!_this.hideSelectAccountPaymentMethod && _this.swCustomerAccountPaymentMethodCard.accountPaymentMethod == null) {
                _this.baseEntity.accountPaymentMethod = _this.accountPaymentMethodOptions[0];
            }
            else {
                for (var i = 0; i < _this.accountPaymentMethodOptions.length; i++) {
                    var option = _this.accountPaymentMethodOptions[i];
                    if (option['value'] === _this.swCustomerAccountPaymentMethodCard.accountPaymentMethod.accountPaymentMethodID) {
                        _this.baseEntity.accountPaymentMethod = option;
                        break;
                    }
                }
            }
            if (_this.swCustomerAccountPaymentMethodCard.accountPaymentMethod != null) {
                _this.accountPaymentMethod = _this.swCustomerAccountPaymentMethodCard.accountPaymentMethod;
            }
            _this.newAccountPaymentMethod = {
                expirationMonth: _this.expirationMonthOptions[0],
                expirationYear: _this.expirationYearOptions[0]
            };
            _this.newAccountAddress = {
                address: {}
            };
        };
        this.setBillingAccountAddress = function (billingAccountAddressID) {
            for (var i = 0; i < _this.accountAddressOptions.length; i++) {
                var option = _this.accountAddressOptions[i];
                if (option['value'] === billingAccountAddressID) {
                    _this.baseEntity.billingAccountAddress = option;
                    break;
                }
            }
        };
        this.updateAccountPaymentMethod = function () {
            _this.setBillingAccountAddress(_this.baseEntity.accountPaymentMethod.billingAccountAddress_accountAddressID);
        };
        this.save = function () {
            var formDataToPost = {
                entityID: _this.baseEntityPrimaryID,
                entityName: _this.baseEntityName,
                context: _this.processContext,
                propertyIdentifiersList: 'billingAccountAddress,accountPaymentMethod,account.accountAddressOptions,account.accountPaymentMethodOptions,' + _this.orderTemplateService.orderTemplatePropertyIdentifierList
            };
            if (_this.showCreateBillingAddress) {
                formDataToPost.newAccountAddress = _this.newAccountAddress;
                formDataToPost.newAccountAddress.address.stateCode = _this.newAccountAddress.address.stateCode.stateCode;
                formDataToPost.newAccountAddress.address.countryCode = _this.newAccountAddress.address.countryCode.countryCode;
            }
            else {
                formDataToPost.billingAccountAddress = _this.baseEntity.billingAccountAddress;
            }
            if (_this.showCreateAccountPaymentMethod) {
                formDataToPost.newAccountPaymentMethod = _this.newAccountPaymentMethod;
                formDataToPost.newAccountPaymentMethod.expirationYear = _this.newAccountPaymentMethod.expirationYear.VALUE;
            }
            else {
                formDataToPost.accountPaymentMethod = _this.baseEntity.accountPaymentMethod;
            }
            var processUrl = _this.$hibachi.buildUrl('api:main.post');
            var adminRequest = _this.requestService.newAdminRequest(processUrl, formDataToPost);
            return adminRequest.promise;
        };
        this.observerService.attach(this.$onInit, 'OrderTemplateUpdateBillingSuccess');
        this.observerService.attach(this.$onInit, 'OrderTemplateUpdateShippingSuccess');
    }
    return SWAccountPaymentMethodModalController;
}());
var SWAccountPaymentMethodModal = /** @class */ (function () {
    function SWAccountPaymentMethodModal(orderPartialsPath, slatwallPathBuilder, $hibachi, rbkeyService) {
        this.orderPartialsPath = orderPartialsPath;
        this.slatwallPathBuilder = slatwallPathBuilder;
        this.$hibachi = $hibachi;
        this.rbkeyService = rbkeyService;
        this.scope = {};
        this.bindToController = {
            accountPaymentMethod: "<?",
            accountPaymentMethodOptions: "<?",
            accountAddressOptions: "<?",
            baseEntityName: "@?",
            baseEntity: "<?",
            processContext: "@?",
            title: "@?",
            modalButtonText: "@?",
            createBillingAddressTitle: "@?",
            createAccountPaymentMethodTitle: "@?",
            accountAddressNameTitle: "@?",
            streetAddressTitle: "@?",
            street2AddressTitle: "@?",
            cityTitle: "@?",
            stateCodeTitle: "@?",
            accountPaymentMethodNameTitle: "@?",
            creditCardNumberTitle: "@?",
            nameOnCreditCardTitle: "@?",
            expirationMonthTitle: "@?",
            expirationYearTitle: "@?"
        };
        this.require = {
            swCustomerAccountPaymentMethodCard: "^^swCustomerAccountPaymentMethodCard"
        };
        this.controller = SWAccountPaymentMethodModalController;
        this.controllerAs = "swAccountPaymentMethodModal";
        this.link = function (scope, element, attrs) {
        };
        this.templateUrl = slatwallPathBuilder.buildPartialsPath(orderPartialsPath) + "/accountpaymentmethodmodal.html";
        this.restrict = "EA";
    }
    SWAccountPaymentMethodModal.Factory = function () {
        var directive = function (orderPartialsPath, slatwallPathBuilder, $hibachi, rbkeyService) { return new SWAccountPaymentMethodModal(orderPartialsPath, slatwallPathBuilder, $hibachi, rbkeyService); };
        directive.$inject = [
            'orderPartialsPath',
            'slatwallPathBuilder',
            '$hibachi',
            'rbkeyService'
        ];
        return directive;
    };
    return SWAccountPaymentMethodModal;
}());
exports.SWAccountPaymentMethodModal = SWAccountPaymentMethodModal;


/***/ }),

/***/ "OnuJ":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
exports.SWGiftCardOrderInfo = exports.SWGiftCardOrderInfoController = void 0;
/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
var SWGiftCardOrderInfoController = /** @class */ (function () {
    function SWGiftCardOrderInfoController(collectionConfigService) {
        var _this = this;
        this.collectionConfigService = collectionConfigService;
        this.init = function () {
            var orderConfig = _this.collectionConfigService.newCollectionConfig('Order');
            orderConfig.setDisplayProperties("orderID, orderNumber, orderOpenDateTime, orderOrigin.orderOriginName, account.firstName, account.lastName");
            orderConfig.addFilter('orderID', _this.giftCard.order_orderID);
            orderConfig.setAllRecords(true);
            orderConfig.getEntity().then(function (response) {
                _this.order = response.records[0];
            });
        };
        this.init();
    }
    SWGiftCardOrderInfoController.$inject = ["collectionConfigService"];
    return SWGiftCardOrderInfoController;
}());
exports.SWGiftCardOrderInfoController = SWGiftCardOrderInfoController;
var SWGiftCardOrderInfo = /** @class */ (function () {
    function SWGiftCardOrderInfo(collectionConfigService, giftCardPartialsPath, slatwallPathBuilder) {
        this.collectionConfigService = collectionConfigService;
        this.giftCardPartialsPath = giftCardPartialsPath;
        this.slatwallPathBuilder = slatwallPathBuilder;
        this.scope = {};
        this.bindToController = {
            giftCard: "=?",
            order: "=?"
        };
        this.controller = SWGiftCardOrderInfoController;
        this.controllerAs = "swGiftCardOrderInfo";
        this.link = function (scope, element, attrs) {
        };
        this.templateUrl = slatwallPathBuilder.buildPartialsPath(giftCardPartialsPath) + "/orderinfo.html";
        this.restrict = "EA";
    }
    SWGiftCardOrderInfo.Factory = function () {
        var directive = function (collectionConfigService, giftCardPartialsPath, slatwallPathBuilder) { return new SWGiftCardOrderInfo(collectionConfigService, giftCardPartialsPath, slatwallPathBuilder); };
        directive.$inject = [
            'collectionConfigService',
            'giftCardPartialsPath',
            'slatwallPathBuilder'
        ];
        return directive;
    };
    SWGiftCardOrderInfo.$inject = ["collectionConfigService", "partialsPath"];
    return SWGiftCardOrderInfo;
}());
exports.SWGiftCardOrderInfo = SWGiftCardOrderInfo;


/***/ }),

/***/ "Ot3G":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
exports.SWImageDetailModalLauncherController = exports.SWImageDetailModalLauncher = void 0;
/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
var SWImageDetailModalLauncherController = /** @class */ (function () {
    //@ngInject
    SWImageDetailModalLauncherController.$inject = ["observerService", "formService", "fileService", "collectionConfigService", "utilityService", "$hibachi", "$http", "$element"];
    function SWImageDetailModalLauncherController(observerService, formService, fileService, collectionConfigService, utilityService, $hibachi, $http, $element) {
        var _this = this;
        this.observerService = observerService;
        this.formService = formService;
        this.fileService = fileService;
        this.collectionConfigService = collectionConfigService;
        this.utilityService = utilityService;
        this.$hibachi = $hibachi;
        this.$http = $http;
        this.$element = $element;
        this.baseName = "j-image-detail";
        this.imageOptions = [];
        this.numberOfSkusWithImageFile = 0;
        this.fetchImageOptionData = function () {
            _this.imageOptionsAttachedToSku = _this.collectionConfigService.newCollectionConfig("Option");
            _this.imageOptionsAttachedToSku.addDisplayProperty('optionGroup.optionGroupName,optionName,optionCode,optionID');
            _this.imageOptionsAttachedToSku.addFilter('skus.skuID', _this.skuId, "=");
            _this.imageOptionsAttachedToSku.addFilter('optionGroup.imageGroupFlag', true, "=");
            _this.imageOptionsAttachedToSku.setAllRecords(true);
            _this.imageOptionsAttachedToSku.getEntity().then(function (data) {
                angular.forEach(data.records, function (value, key) {
                    _this.imageOptions.push(_this.$hibachi.populateEntity("Option", value));
                });
            }, function (reason) {
                throw ("Could not calculate affected skus in SWImageDetailModalLauncher because of: " + reason);
            });
            _this.otherSkusWithSameImageCollectionConfig = _this.collectionConfigService.newCollectionConfig("Sku");
            _this.otherSkusWithSameImageCollectionConfig.addFilter("imageFile", _this.imageFile, "=");
            _this.otherSkusWithSameImageCollectionConfig.setAllRecords(true);
            _this.otherSkusWithSameImageCollectionConfig.getEntity().then(function (data) {
                _this.skusAffectedCount = data.records.length;
            }, function (reason) {
                throw ("Could not calculate affected skus in SWImageDetailModalLauncher because of: " + reason);
            });
        };
        this.updateImage = function (rawImage) {
            console.log('update');
        };
        this.saveAction = function () {
            var data = new FormData();
            data.append('slatAction', "admin:entity.processProduct");
            data.append('processContext', "uploadDefaultImage");
            data.append('sRedirectAction', "admin:entity.detailProduct");
            data.append('preprocessDisplayedFlag', "1");
            data.append('ajaxRequest', "1");
            data.append('productID', _this.swPricingManager.productId);
            if (_this.sku.data.imageFile) {
                data.append('imageFile', _this.sku.data.imageFile);
            }
            else if (_this.imageFileName) {
                data.append('imageFile', _this.imageFileName);
            }
            var inputs = $('input[type=file]');
            for (var _i = 0, _a = inputs; _i < _a.length; _i++) {
                var input = _a[_i];
                var classes = $(input).attr('class').split(' ');
                if (input.files[0] && classes.indexOf(_this.skuCode) > -1) {
                    data.append('uploadFile', input.files[0]);
                    break;
                }
            }
            var savePromise = _this.$http.post("/?s=1", data, {
                transformRequest: angular.identity,
                headers: { 'Content-Type': undefined }
            }).then(function () {
                _this.sku.data.imagePath = _this.imageFileName.split('?')[0] + "?version=" + Math.random().toString(36).replace(/[^a-z]+/g, '').substr(0, 5);
                _this.observerService.notifyById('swPaginationAction', _this.swListingDisplay.tableID, { type: 'setCurrentPage', payload: _this.swListingDisplay.collectionConfig.currentPage });
            });
            return savePromise;
        };
        this.cancelAction = function () {
            _this.observerService.notify(_this.imageFileUpdateEvent, _this.imagePath);
        };
        this.$element = $element;
        this.name = this.baseName + this.utilityService.createID(18);
        this.imagePath;
        fileService.imageExists(this.imagePath).then(function () {
            _this.imagePathToUse = _this.imagePath + "?version=" + Math.random().toString(36).replace(/[^a-z]+/g, '').substr(0, 5);
        }, function () {
            _this.imagePathToUse = 'assets/images/image-placeholder.jpg';
        }).finally(function () {
            var skuData = {
                skuID: _this.skuId,
                skuCode: _this.skuCode,
                imageFileName: _this.imageFileName,
                imagePath: _this.imagePathToUse,
                imageFile: _this.imageFile
            };
            _this.sku = _this.$hibachi.populateEntity("Sku", skuData);
            _this.imageFileUpdateEvent = "file:" + _this.imagePath;
            _this.observerService.attach(_this.updateImage, _this.imageFileUpdateEvent, _this.skuId);
            _this.fetchImageOptionData();
        });
    }
    return SWImageDetailModalLauncherController;
}());
exports.SWImageDetailModalLauncherController = SWImageDetailModalLauncherController;
var SWImageDetailModalLauncher = /** @class */ (function () {
    function SWImageDetailModalLauncher(skuPartialsPath, slatwallPathBuilder) {
        this.restrict = 'EA';
        this.scope = {};
        this.require = { swPricingManager: '?^swPricingManager', swListingDisplay: "?^swListingDisplay" };
        this.bindToController = {
            skuId: "@",
            skuCode: "@",
            imagePath: "@",
            imageFile: "@",
            imageFileName: "@"
        };
        this.controller = SWImageDetailModalLauncherController;
        this.controllerAs = "swImageDetailModalLauncher";
        this.templateUrl = slatwallPathBuilder.buildPartialsPath(skuPartialsPath) + "imagedetailmodallauncher.html";
    }
    SWImageDetailModalLauncher.Factory = function () {
        var directive = function (skuPartialsPath, slatwallPathBuilder) { return new SWImageDetailModalLauncher(skuPartialsPath, slatwallPathBuilder); };
        directive.$inject = [
            'skuPartialsPath',
            'slatwallPathBuilder'
        ];
        return directive;
    };
    return SWImageDetailModalLauncher;
}());
exports.SWImageDetailModalLauncher = SWImageDetailModalLauncher;


/***/ }),

/***/ "PDZZ":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

/// <reference path="../../../../../node_modules/typescript/lib/lib.es6.d.ts" />
/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
var __assign = (this && this.__assign) || function () {
    __assign = Object.assign || function(t) {
        for (var s, i = 1, n = arguments.length; i < n; i++) {
            s = arguments[i];
            for (var p in s) if (Object.prototype.hasOwnProperty.call(s, p))
                t[p] = s[p];
        }
        return t;
    };
    return __assign.apply(this, arguments);
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.OrderFulfillmentService = void 0;
var FluxStore = __webpack_require__("Jw3Q");
var actions = __webpack_require__("wcsU");
/**
 * Fulfillment List Controller
 */
var OrderFulfillmentService = /** @class */ (function () {
    //@ngInject
    OrderFulfillmentService.$inject = ["$timeout", "observerService", "$hibachi", "collectionConfigService", "listingService", "$rootScope", "selectionService"];
    function OrderFulfillmentService($timeout, observerService, $hibachi, collectionConfigService, listingService, $rootScope, selectionService) {
        var _this = this;
        this.$timeout = $timeout;
        this.observerService = observerService;
        this.$hibachi = $hibachi;
        this.collectionConfigService = collectionConfigService;
        this.listingService = listingService;
        this.$rootScope = $rootScope;
        this.selectionService = selectionService;
        //This is the single object that contains all state for the component.
        this.state = {
            //boolean
            showFulfillmentListing: true,
            expandedFulfillmentBatchListing: true,
            editComment: false,
            useShippingIntegrationForTrackingNumber: true,
            //objects
            commentBeingEdited: undefined,
            emailTemplates: undefined,
            imagePath: undefined,
            //strings
            currentSelectedFulfillmentBatchItemID: "",
            fulfillmentBatchId: undefined,
            //empty collections
            smFulfillmentBatchItemCollection: undefined,
            lgFulfillmentBatchItemCollection: undefined,
            currentRecordOrderDetail: undefined,
            commentsCollection: undefined,
            orderFulfillmentItemsCollection: undefined,
            emailCollection: undefined,
            printCollection: undefined,
            //arrays
            accountNames: [],
            orderDeliveryAttributes: [],
            unassignedContainerItems: {},
            orderItem: {},
            loading: false,
            tableSelections: {
                table1: [],
                table2: []
            },
            boxes: [{}]
        };
        this.updateLock = false;
        this.selectedValue = "";
        // Middleware - Logger - add this into the store declaration to log all calls to the reducer.
        this.loggerEpic = function () {
            var args = [];
            for (var _i = 0; _i < arguments.length; _i++) {
                args[_i] = arguments[_i];
            }
            return args;
        };
        /**
         * The reducer is responsible for modifying the state of the state object into a new state.
         */
        this.orderFulfillmentStateReducer = function (state, action) {
            switch (action.type) {
                case actions.TOGGLE_FULFILLMENT_LISTING:
                    _this.state.showFulfillmentListing = !_this.state.showFulfillmentListing;
                    return __assign(__assign({}, _this.state), { action: action });
                case actions.ADD_BATCH:
                    return __assign(__assign({}, state), { action: action });
                case actions.SETUP_BATCHDETAIL:
                    //Setup the detail
                    if (action.payload.fulfillmentBatchId != undefined) {
                        _this.state.fulfillmentBatchId = action.payload.fulfillmentBatchId;
                    }
                    _this.setupFulfillmentBatchDetail();
                    return __assign(__assign({}, _this.state), { action: action });
                case actions.UPDATE_BATCHDETAIL:
                    return __assign(__assign({}, _this.state), { action: action });
                case actions.TOGGLE_BATCHLISTING:
                    //Toggle the listing from expanded to half size.
                    _this.state.expandedFulfillmentBatchListing = !_this.state.expandedFulfillmentBatchListing;
                    return __assign(__assign({}, _this.state), { action: action });
                case actions.TOGGLE_EDITCOMMENT:
                    //Update the comment.
                    _this.state.editComment = !_this.state.editComment;
                    if (_this.state.editComment == true) {
                        _this.state.commentBeingEdited = action.payload.comment;
                    }
                    else {
                        _this.state.commentBeingEdited = undefined;
                    }
                    return __assign(__assign({}, _this.state), { action: action });
                case actions.SAVE_COMMENT_REQUESTED:
                    if (action.payload.comment && action.payload.commentText) {
                        //saving
                        _this.saveComment(action.payload.comment, action.payload.commentText);
                    }
                    else {
                        //editing
                        _this.saveComment({}, action.payload.commentText);
                    }
                    //toggle edit mode. so we are no longer editing.
                    _this.state.editComment = false;
                    _this.state.commentBeingEdited = undefined;
                    return __assign(__assign({}, _this.state), { action: action });
                case actions.DELETE_COMMENT_REQUESTED:
                    _this.deleteComment(action.payload.comment);
                    _this.state.editComment = false;
                    _this.state.commentBeingEdited = undefined;
                    return __assign(__assign({}, _this.state), { action: action });
                case actions.CREATE_FULFILLMENT_REQUESTED:
                    //create all the data
                    _this.fulfillItems(action.payload.viewState, false);
                    return __assign(__assign({}, _this.state), { action: action });
                case actions.SETUP_ORDERDELIVERYATTRIBUTES:
                    _this.createOrderDeliveryAttributeCollection();
                    return __assign(__assign({}, _this.state), { action: action });
                case actions.DELETE_FULFILLMENTBATCHITEM_REQUESTED:
                    _this.deleteFulfillmentBatchItem();
                    return __assign(__assign({}, _this.state), { action: action });
                case actions.PRINT_LIST_REQUESTED:
                    _this.getPrintList();
                    return __assign(__assign({}, _this.state), { action: action });
                case actions.EMAIL_LIST_REQUESTED:
                    _this.getEmailList();
                    return __assign(__assign({}, _this.state), { action: action });
                case actions.UPDATE_BOX_DIMENSIONS:
                    _this.updateBoxDimensions(action.payload.box);
                    return __assign(__assign({}, _this.state), { action: action });
                case actions.ADD_BOX:
                    _this.addNewBox();
                    return __assign(__assign({}, _this.state), { action: action });
                case actions.REMOVE_BOX:
                    _this.removeBox(action.payload.index);
                    return __assign(__assign({}, _this.state), { action: action });
                case actions.SET_DELIVERY_QUANTITIES:
                    _this.setDeliveryQuantities();
                    return __assign(__assign({}, _this.state), { action: action });
                case actions.UPDATE_CONTAINER_ITEM_QUANTITY:
                    _this.updateContainerItemQuantity(action.payload.containerItem, action.payload.newValue);
                    return __assign(__assign({}, _this.state), { action: action });
                case actions.SET_UNASSIGNED_ITEM_CONTAINER:
                    _this.setUnassignedItemContainer(action.payload.skuCode, action.payload.container);
                    return __assign(__assign({}, _this.state), { action: action });
                case actions.TOGGLE_LOADER:
                    _this.state.loading = !_this.state.loading;
                    return __assign(__assign({}, _this.state), { action: action });
                default:
                    return _this.state;
            }
        };
        /** When a row is selected, remove the other selections.  */
        this.swSelectionToggleSelectionfulfillmentBatchItemTable2 = function (args) {
            if (args.selectionid != "fulfillmentBatchItemTable2") {
                return;
            }
            if (args.action === "uncheck") {
                if (_this.selectedValue == args.selection) {
                    _this.selectedValue = undefined;
                }
                return;
            }
            //Are any previously checked?
            if (args.action === "check"
                && args.selection != undefined
                && args.selection != _this.selectedValue
                && args.selectionid == "fulfillmentBatchItemTable2") {
                //set the selection.
                //save the selected value
                var current = "";
                if (_this.selectedValue != undefined && _this.selectedValue.length) {
                    current = _this.selectedValue;
                    _this.selectedValue = args.selection;
                    //remove that old value
                    _this.selectionService.removeSelection("fulfillmentBatchItemTable2", current);
                    _this.state.currentSelectedFulfillmentBatchItemID = _this.selectedValue;
                    _this.state.useShippingIntegrationForTrackingNumber = true;
                    _this.state.orderItem = {};
                    _this.state.boxes = [{}];
                    _this.state.smFulfillmentBatchItemCollection.getEntity().then(function (results) {
                        for (var result in results.records) {
                            var currentRecord = results['records'][result];
                            if (currentRecord['fulfillmentBatchItemID'] == _this.state.currentSelectedFulfillmentBatchItemID) {
                                //Matched - Save some items from the currentRecord to display.
                                //Get the orderItems for this fulfillment
                                _this.createOrderFulfillmentItemCollection(currentRecord['orderFulfillment_orderFulfillmentID']);
                                _this.createCurrentRecordDetailCollection(currentRecord);
                                _this.createShippingIntegrationOptions(currentRecord);
                                _this.emitUpdateToClient();
                            }
                        }
                    });
                }
                else {
                    _this.selectedValue = args.selection;
                }
            }
        };
        /** Sets up the batch detail page including responding to listing changes. */
        this.setupFulfillmentBatchDetail = function () {
            //Create the fulfillmentBatchItemCollection
            _this.createLgOrderFulfillmentBatchItemCollection();
            _this.createSmOrderFulfillmentBatchItemCollection();
            _this.getOrderFulfillmentEmailTemplates();
            _this.getContainerPresetList();
            //Select the initial table row
            //get the listingDisplay store and listen for changes to the listing display state.
            _this.listingService.listingDisplayStore.store$.subscribe(function (update) {
                if (update.action && update.action.type && update.action.type == actions.CURRENT_PAGE_RECORDS_SELECTED) {
                    /*  Check for the tables we care about fulfillmentBatchItemTable1, fulfillmentBatchItemTable2
                        Outer table, will need to toggle and set the floating cards to this data.
                        on the first one being selected, go to the shrink view and set the selection on there as well.*/
                    if (angular.isDefined(update.action.payload)) {
                        if (angular.isDefined(update.action.payload.listingID) && update.action.payload.listingID == "fulfillmentBatchItemTable1") {
                            //If there is only one item selected, show that detail.
                            if (angular.isDefined(update.action.payload.values) && update.action.payload.values.length == 1) {
                                if (_this.state.expandedFulfillmentBatchListing) {
                                    _this.state.expandedFulfillmentBatchListing = !_this.state.expandedFulfillmentBatchListing;
                                }
                                _this.state.currentSelectedFulfillmentBatchItemID = update.action.payload.values[0];
                                //set the selection.
                                if (update.action.payload.values.length && _this.state.currentSelectedFulfillmentBatchItemID) {
                                    var selectedRowIndex = _this.listingService.getSelectedBy("fulfillmentBatchItemTable1", "fulfillmentBatchItemID", _this.state.currentSelectedFulfillmentBatchItemID);
                                    if (selectedRowIndex != -1) {
                                        _this.listingService
                                            .getListing("fulfillmentBatchItemTable2").selectionService
                                            .addSelection(_this.listingService.getListing("fulfillmentBatchItemTable2").tableID, _this.listingService.getListingPageRecords("fulfillmentBatchItemTable2")[selectedRowIndex][_this.listingService.getListingBaseEntityPrimaryIDPropertyName("fulfillmentBatchItemTable2")]);
                                    }
                                }
                                //use this id to get the record and set it to currentRecordOrderDetail.
                                //*****Need to iterate over the collection and find the ID to match against and get the orderfulfillment collection that matches this record.
                                _this.state.smFulfillmentBatchItemCollection.getEntity().then(function (results) {
                                    for (var result in results.records) {
                                        var currentRecord = results['records'][result];
                                        if (currentRecord['fulfillmentBatchItemID'] == _this.state.currentSelectedFulfillmentBatchItemID) {
                                            //Matched - Save some items from the currentRecord to display.
                                            //Get the orderItems for this fulfillment
                                            _this.createOrderFulfillmentItemCollection(currentRecord['orderFulfillment_orderFulfillmentID']);
                                            _this.createCurrentRecordDetailCollection(currentRecord);
                                            _this.createShippingIntegrationOptions(currentRecord);
                                            _this.emitUpdateToClient();
                                        }
                                    }
                                });
                            }
                        }
                        if (angular.isDefined(update.action.payload.listingID) && update.action.payload.listingID == "fulfillmentBatchItemTable2") {
                            //if nothing is selected, go back to the outer view.
                            if (!angular.isDefined(update.action.payload.values) || update.action.payload.values.length == 0) {
                                if (_this.state.expandedFulfillmentBatchListing == false) {
                                    _this.state.expandedFulfillmentBatchListing = !_this.state.expandedFulfillmentBatchListing;
                                    //Clear all selections.
                                    _this.listingService.clearAllSelections("fulfillmentBatchItemTable2");
                                    _this.listingService.clearAllSelections("fulfillmentBatchItemTable1");
                                    _this.emitUpdateToClient();
                                }
                            }
                        }
                    }
                }
            });
        };
        /** During key times when data changes, we would like to alert the client to those changes. This allows us to do that. */
        this.emitUpdateToClient = function () {
            _this.orderFulfillmentStore.dispatch({
                type: actions.UPDATE_BATCHDETAIL,
                payload: { noop: angular.noop() }
            });
        };
        /**
         * Creates a batch. This should use api:main.post with a context of process and an entityName instead of doAction.
         * The process object should have orderItemIdList or orderFulfillmentIDList defined and should have
         * optionally an accountID, and or locationID (or locationIDList).
         */
        this.addBatch = function (processObject) {
            if (processObject) {
                processObject.data.entityName = "FulfillmentBatch";
                processObject.data['fulfillmentBatch'] = {};
                processObject.data['fulfillmentBatch']['fulfillmentBatchID'] = "";
                //If only 1, add that to the list.
                if (processObject.data.locationID) {
                    processObject.data.locationIDList = processObject.data.locationID;
                }
                return _this.$hibachi.saveEntity("fulfillmentBatch", '', processObject.data, "create");
            }
        };
        /** Creates the orderDelivery - fulfilling the items quantity of items specified, capturing as needed. */
        this.fulfillItems = function (state, ignoreCapture) {
            if (state === void 0) { state = {}; }
            if (ignoreCapture === void 0) { ignoreCapture = false; }
            _this.state.loading = true;
            if (state.useShippingIntegrationForTrackingNumber == 1 && (state.shippingIntegrationID == "" || state.shippingIntegrationID == null)) {
                _this.state.loading = false;
                alert(_this.$rootScope.rbKey('define.invalidShippingIntegration'));
                _this.emitUpdateToClient();
                return;
            }
            var data = {};
            //Add the order information
            data.order = {};
            data.order['orderID'] = _this.state.currentRecordOrderDetail['order_orderID'];
            //Add the orderFulfillment.
            data['orderDeliveryID'] = ""; //this indicates the the orderDelivery is being created.
            data['orderFulfillment'] = {};
            data['orderFulfillment']['orderFulfillmentID'] = _this.state.currentRecordOrderDetail['fulfillmentBatchItem']['orderFulfillment_orderFulfillmentID'];
            data['trackingNumber'] = state.trackingCode || "";
            data['containers'] = state.boxes || [];
            if (data['trackingNumber'] == undefined || !data['trackingNumber'].length) {
                data['useShippingIntegrationForTrackingNumber'] = state.useShippingIntegrationForTrackingNumber || "false";
            }
            //console.log("Batch Information: ", this.state.currentRecordOrderDetail['fulfillmentBatchItem']);
            //Add the orderDelivertyItems as an array with the quantity set to the quantity.
            //Make sure all of the deliveryitems have a quantity set by the user.
            var idx = 1; //coldfusion indexes at 1
            data['orderDeliveryItems'] = [];
            for (var orderDeliveryItem in state.orderItem) {
                if (state.orderItem[orderDeliveryItem] != undefined) {
                    if (state.orderItem[orderDeliveryItem] && state.orderItem[orderDeliveryItem] > 0) {
                        data['orderDeliveryItems'].push({ orderItem: { orderItemID: orderDeliveryItem }, quantity: state.orderItem[orderDeliveryItem] });
                    }
                }
                idx++;
            }
            //Add the payment information
            if (_this.state.currentRecordOrderDetail['order_paymentAmountDue'] > 0 && !ignoreCapture) {
                data.captureAuthorizedPaymentsFlag = true;
                data.capturableAmount = _this.state.currentRecordOrderDetail['order_paymentAmountDue'];
            }
            //If the user input a captuable amount, use that instead.
            if (state.capturableAmount != undefined) {
                data['capturableAmount'] = state.capturableAmount;
                data['captureAuthorizedPaymentsFlag'] = false;
                //hidden fields
                data['order'] = {};
                data['order']['orderID'] = _this.state.currentRecordOrderDetail['order_orderID'] || "";
                //shippingMethod.shippingMethodID
                data['shippingMethod'] = {};
                data['shippingMethod']['shippingMethodID'] = _this.state.currentRecordOrderDetail['shippingMethod_shippingMethodID'];
                //shippingAddress.addressID
                data['shippingAddress'] = {};
                data['shippingAddress']['addressID'] = _this.state.currentRecordOrderDetail['shippingAddress_addressID'];
                if (data['useShippingIntegrationForTrackingNumber']) {
                    data['shippingIntegration'] = { integrationID: state.shippingIntegrationID };
                }
            }
            //Create the process object.
            var processObject = _this.$hibachi.newOrderDelivery_Create();
            processObject.data = data;
            processObject.data.entityName = "OrderDelivery";
            //Basic Information
            processObject.data['location'] = { 'locationID': _this.$rootScope.slatwall.defaultLocation || "5cacb1d00b20aa339bc5585e13549dda" }; //sets a random location for now until batch issue with location is resolved.
            //Shipping information.
            processObject.data['containerLabel'] = data.containerLabel || "";
            processObject.data['orderFulfillment']['shippingIntegration'] = data.shippingIntegration || "";
            processObject.data['shippingAddress'] = data.shippingAddress || "";
            processObject.data['containers'] = data.containers;
            processObject.data['useShippingIntegrationForTrackingNumber'] = data.useShippingIntegrationForTrackingNumber || false;
            if (state.orderDeliveryAttributes) {
                for (var i = 0; i < state.orderDeliveryAttributes.length; i++) {
                    var attribute = state.orderDeliveryAttributes[i];
                    processObject.data[attribute.code] = state[attribute.code];
                }
            }
            _this.$hibachi.saveEntity("OrderDelivery", '', processObject.data, "create").then(function (result) {
                if (result.data.errors) {
                    _this.state.loading = false;
                    return result;
                }
                _this.state.loading = false;
                if (result.orderDeliveryID != undefined && result.orderDeliveryID != '') {
                    return result;
                }
                //Sets the next selected value.
                var selectedRowIndex = _this.listingService.getSelectedBy("fulfillmentBatchItemTable1", "fulfillmentBatchItemID", _this.state.currentSelectedFulfillmentBatchItemID);
                //clear first
                _this.listingService.clearAllSelections("fulfillmentBatchItemTable1");
                _this.listingService.clearAllSelections("fulfillmentBatchItemTable2");
                //then select the next.
                if (selectedRowIndex != -1) {
                    //Set the next one.
                    selectedRowIndex = selectedRowIndex + 1;
                    _this.listingService
                        .getListing("fulfillmentBatchItemTable1").selectionService
                        .addSelection(_this.listingService.getListing("fulfillmentBatchItemTable1").tableID, _this.listingService.getListingPageRecords("fulfillmentBatchItemTable1")[selectedRowIndex][_this.listingService.getListingBaseEntityPrimaryIDPropertyName("fulfillmentBatchItemTable1")]);
                    var args = {
                        selection: _this.listingService.getListingPageRecords("fulfillmentBatchItemTable2")[selectedRowIndex][_this.listingService.getListingBaseEntityPrimaryIDPropertyName("fulfillmentBatchItemTable2")],
                        selectionid: "fulfillmentBatchItemTable2",
                        action: "check"
                    };
                    _this.swSelectionToggleSelectionfulfillmentBatchItemTable2(args);
                }
                //refresh.
                //Scroll to the quantity div.
                //scrollTo(orderItemQuantity_402828ee57e7a75b0157fc89b45b05c4)
            }, function (error) {
                _this.state.loading = false;
            });
        };
        /** Saves a comment. */
        this.saveComment = function (comment, newCommentText) {
            //Editing
            if (angular.isDefined(comment) && angular.isDefined(comment.comment) && angular.isDefined(comment.commentID)) {
                comment.comment = newCommentText;
                return _this.$hibachi.saveEntity("comment", comment.commentID, comment, "save");
                //New
            }
            else {
                //this is a new comment.
                var commentObject = {
                    comment: "",
                    fulfillmentBatchItem: {
                        fulfillmentBatchItemID: ""
                    },
                    fulfillmentBatchItemID: "",
                    createdByAccountID: ""
                };
                commentObject.comment = newCommentText;
                commentObject.fulfillmentBatchItem.fulfillmentBatchItemID = _this.state.currentSelectedFulfillmentBatchItemID;
                commentObject.createdByAccountID = _this.$rootScope.slatwall.account.accountID || "";
                _this.$hibachi.saveEntity("comment", '', commentObject, "save").then(function (result) {
                    //now regrab all comments so they are redisplayed.
                    return _this.createCommentsCollectionForFulfillmentBatchItem(_this.state.currentSelectedFulfillmentBatchItemID);
                });
            }
        };
        /** Deletes a comment. */
        this.deleteComment = function (comment) {
            if (comment != undefined) {
                _this.$hibachi.saveEntity("comment", comment.commentID, comment, "delete").then(function (result) {
                    return _this.createCommentsCollectionForFulfillmentBatchItem(_this.state.currentSelectedFulfillmentBatchItemID);
                });
            }
        };
        /** Deletes a fulfillment batch item. */
        this.deleteFulfillmentBatchItem = function () {
            if (_this.state.currentSelectedFulfillmentBatchItemID) {
                var fulfillmentBatchItem = { "fulfillmentBatchItemID": _this.state.currentSelectedFulfillmentBatchItemID }; //get current fulfillmentBatchItem;
                if (fulfillmentBatchItem.fulfillmentBatchItemID != undefined) {
                    _this.$hibachi.saveEntity("fulfillmentBatchItem", fulfillmentBatchItem.fulfillmentBatchItemID, fulfillmentBatchItem, "delete").then(function (result) {
                        window.location.reload(false);
                    });
                }
            }
        };
        this.createShippingIntegrationOptions = function (currentRecord) {
            _this.$hibachi.getPropertyDisplayOptions("OrderFulfillment", { property: "ShippingIntegration", entityID: currentRecord['orderFulfillment_orderFulfillmentID'] }).then(function (response) {
                _this.state.shippingIntegrationOptions = response.data;
                if (currentRecord['orderFulfillment_shippingIntegration_integrationID'].trim() != "" && currentRecord['orderFulfillment_shippingIntegration_integrationID'] != null) {
                    _this.state.shippingIntegrationID = currentRecord['orderFulfillment_shippingIntegration_integrationID'];
                }
                else {
                    _this.state.shippingIntegrationID = _this.state.shippingIntegrationOptions[0]['VALUE'];
                }
            });
        };
        /**
         * Returns the comments for the selectedFulfillmentBatchItem
         */
        this.createCommentsCollectionForFulfillmentBatchItem = function (fulfillmentBatchItemID) {
            _this.state.commentsCollection = _this.collectionConfigService.newCollectionConfig("Comment");
            _this.state.commentsCollection.addDisplayProperty("createdDateTime");
            _this.state.commentsCollection.addDisplayProperty("createdByAccountID");
            _this.state.commentsCollection.addDisplayProperty("commentID");
            _this.state.commentsCollection.addDisplayProperty("comment");
            _this.state.commentsCollection.addFilter("fulfillmentBatchItem.fulfillmentBatchItemID", fulfillmentBatchItemID, "=");
            _this.state.commentsCollection.getEntity().then(function (comments) {
                if (comments && comments.pageRecords.length) {
                    _this.state.commentsCollection = comments['pageRecords'];
                    for (var account in _this.state.commentsCollection) {
                        if (angular.isDefined(_this.state.commentsCollection[account]['createdByAccountID'])) {
                            //sets the account name to the account names object indexed by the account id.
                            _this.getAccountNameByAccountID(_this.state.commentsCollection[account]['createdByAccountID']);
                        }
                    }
                }
                else {
                    _this.state.commentsCollection = comments.pageRecords;
                    _this.emitUpdateToClient();
                }
            });
        };
        /**
         * Returns the comments for the selectedFulfillmentBatchItem
         */
        this.createCurrentRecordDetailCollection = function (currentRecord) {
            //Get a new collection using the orderFulfillment.
            _this.state.currentRecordOrderDetail = _this.collectionConfigService.newCollectionConfig("OrderFulfillment");
            _this.state.currentRecordOrderDetail.addFilter("orderFulfillmentID", currentRecord['orderFulfillment_orderFulfillmentID'], "=");
            //For the order
            _this.state.currentRecordOrderDetail.addDisplayProperty("order.orderOpenDateTime", "Open Date"); //date placed
            _this.state.currentRecordOrderDetail.addDisplayProperty("order.orderCloseDateTime", "Close Date");
            _this.state.currentRecordOrderDetail.addDisplayProperty("order.orderNumber", "Order Number");
            _this.state.currentRecordOrderDetail.addDisplayProperty("order.orderID", "OrderID");
            _this.state.currentRecordOrderDetail.addDisplayProperty("order.calculatedTotal", "Total");
            _this.state.currentRecordOrderDetail.addDisplayProperty("order.paymentAmountDue", "Amount Due", { persistent: false });
            _this.state.currentRecordOrderDetail.addDisplayProperty("order.paymentAmountAuthorizedTotal", "Authorized", { persistent: false });
            _this.state.currentRecordOrderDetail.addDisplayProperty("order.paymentAmountCapturedTotal", "Captured", { persistent: false });
            //For the account portion of the tab.
            _this.state.currentRecordOrderDetail.addDisplayProperty("order.account.accountID", "Account Number");
            _this.state.currentRecordOrderDetail.addDisplayProperty("order.account.firstName", "First Name");
            _this.state.currentRecordOrderDetail.addDisplayProperty("order.account.lastName", "Last Name");
            _this.state.currentRecordOrderDetail.addDisplayProperty("order.account.company", "Company");
            //For the shipping portion of the tab.
            _this.state.currentRecordOrderDetail.addDisplayProperty("shippingMethod.shippingMethodID");
            _this.state.currentRecordOrderDetail.addDisplayProperty("shippingMethod.shippingMethodName");
            _this.state.currentRecordOrderDetail.addDisplayProperty("shippingAddress.addressID");
            _this.state.currentRecordOrderDetail.addDisplayProperty("shippingAddress.city");
            _this.state.currentRecordOrderDetail.addDisplayProperty("shippingAddress.stateCode");
            _this.state.currentRecordOrderDetail.addDisplayProperty("orderFulfillmentStatusType.typeName");
            _this.state.currentRecordOrderDetail.addDisplayProperty("calculatedShippingIntegrationName");
            _this.state.currentRecordOrderDetail.getEntity().then(function (entityResults) {
                if (entityResults['pageRecords'].length) {
                    _this.state.currentRecordOrderDetail = entityResults['pageRecords'][0];
                    //set the capturable amount to the amount that still needs to be paid on this order.
                    if (_this.state.currentRecordOrderDetail) {
                        _this.state.capturableAmount = _this.state.currentRecordOrderDetail['order_paymentAmountDue'];
                    }
                    _this.state.currentRecordOrderDetail['fulfillmentBatchItem'] = currentRecord;
                    _this.state.currentRecordOrderDetail['comments'] = _this.createCommentsCollectionForFulfillmentBatchItem(_this.state.currentSelectedFulfillmentBatchItemID);
                    _this.emitUpdateToClient();
                }
            });
        };
        /**
         * Returns account information given an accountID
         */
        this.getAccountNameByAccountID = function (accountID) {
            var accountCollection = _this.collectionConfigService.newCollectionConfig("Account");
            accountCollection.addFilter("accountID", accountID, "=");
            accountCollection.getEntity().then(function (account) {
                if (account['pageRecords'].length) {
                    _this.state.accountNames[accountID] = account['pageRecords'][0]['firstName'] + ' ' + account['pageRecords'][0]['lastName'];
                    _this.emitUpdateToClient();
                }
            });
        };
        /**
        * Setup the initial orderFulfillment Collection.
        */
        this.createLgOrderFulfillmentBatchItemCollection = function () {
            _this.state.lgFulfillmentBatchItemCollection = _this.collectionConfigService.newCollectionConfig("FulfillmentBatchItem");
            _this.state.lgFulfillmentBatchItemCollection.addDisplayProperty("orderFulfillment.order.orderOpenDateTime", "Date");
            _this.state.lgFulfillmentBatchItemCollection.addDisplayProperty("orderFulfillment.shippingMethod.shippingMethodName");
            _this.state.lgFulfillmentBatchItemCollection.addDisplayProperty("orderFulfillment.shippingAddress.stateCode");
            _this.state.lgFulfillmentBatchItemCollection.addDisplayProperty("orderFulfillment.orderFulfillmentStatusType.typeName");
            _this.state.lgFulfillmentBatchItemCollection.addDisplayProperty("fulfillmentBatchItemID");
            _this.state.lgFulfillmentBatchItemCollection.addDisplayProperty("orderFulfillment.orderFulfillmentID");
            _this.state.lgFulfillmentBatchItemCollection.addDisplayProperty("orderFulfillment.shippingIntegration.integrationID");
            _this.state.lgFulfillmentBatchItemCollection.addDisplayProperty("orderFulfillment.lastMessage");
            _this.state.lgFulfillmentBatchItemCollection.addDisplayProperty("orderFulfillment.lastStatusCode");
            _this.state.lgFulfillmentBatchItemCollection.addFilter("fulfillmentBatch.fulfillmentBatchID", _this.state.fulfillmentBatchId, "=");
            _this.state.lgFulfillmentBatchItemCollection.setAllRecords(true);
        };
        /**
        * Get a collection of orderFulfillment email templates.
        */
        this.getOrderFulfillmentEmailTemplates = function () {
            var emailTemplates = _this.collectionConfigService.newCollectionConfig("EmailTemplate");
            emailTemplates.addFilter("emailTemplateObject", "orderFulfillment", "=");
            emailTemplates.getEntity().then(function (emails) {
                if (emails['pageRecords'].length) {
                    _this.state.emailTemplates = emails['pageRecords'];
                    _this.emitUpdateToClient();
                }
            });
        };
        /**
        * Setup the initial orderFulfillment Collection.
        */
        this.createSmOrderFulfillmentBatchItemCollection = function () {
            _this.state.smFulfillmentBatchItemCollection = _this.collectionConfigService.newCollectionConfig("FulfillmentBatchItem");
            _this.state.smFulfillmentBatchItemCollection.addDisplayProperty("orderFulfillment.order.orderOpenDateTime");
            _this.state.smFulfillmentBatchItemCollection.addDisplayProperty("orderFulfillment.shippingMethod.shippingMethodName");
            _this.state.smFulfillmentBatchItemCollection.addDisplayProperty("fulfillmentBatchItemID");
            _this.state.smFulfillmentBatchItemCollection.addDisplayProperty("orderFulfillment.orderFulfillmentID");
            _this.state.smFulfillmentBatchItemCollection.addDisplayProperty("orderFulfillment.shippingIntegration.integrationID");
            _this.state.smFulfillmentBatchItemCollection.addFilter("fulfillmentBatch.fulfillmentBatchID", _this.state.fulfillmentBatchId, "=");
            _this.state.smFulfillmentBatchItemCollection.setAllRecords(true);
        };
        /**
        * Setup the initial orderFulfillment Collection.
        */
        this.createLocationCollection = function () {
            _this.state.locationCollection = _this.collectionConfigService.newCollectionConfig("FulfillmentBatchLocation");
            _this.state.locationCollection.addDisplayProperty("locationID");
            _this.state.locationCollection.addDisplayProperty("fulfillmentBatchID");
            _this.state.locationCollection.addFilter("fulfillmentBatchID", _this.state.fulfillmentBatchId, "=");
            return _this.state.locationCollection.getEntity().then(function (result) { return (result.pageRecords.length) ? result.pageRecords : []; });
        };
        /**
         * Setup the initial print template -> orderFulfillment Collection.
         */
        this.getPrintList = function () {
            _this.state.printCollection = _this.collectionConfigService.newCollectionConfig("PrintTemplate");
            _this.state.printCollection.addDisplayProperty("printTemplateID");
            _this.state.printCollection.addDisplayProperty("printTemplateName");
            _this.state.printCollection.addDisplayProperty("printTemplateObject");
            _this.state.printCollection.addFilter("printTemplateObject", 'OrderFulfillment', "=");
            _this.state.printCollection.getEntity().then(function (result) {
                _this.state.printCollection = result.pageRecords || [];
            });
        };
        /**
         * Setup the initial email template -> orderFulfillment Collection.
         */
        this.getEmailList = function () {
            _this.state.emailCollection = _this.collectionConfigService.newCollectionConfig("EmailTemplate");
            _this.state.emailCollection.addDisplayProperty("emailTemplateID");
            _this.state.emailCollection.addDisplayProperty("emailTemplateName");
            _this.state.emailCollection.addDisplayProperty("emailTemplateObject");
            _this.state.emailCollection.addFilter("emailTemplateObject", 'OrderFulfillment', "=");
            _this.state.emailCollection.getEntity().then(function (result) {
                _this.state.emailCollection = result.pageRecords || [];
            });
        };
        /**
        * Get Container Preset collection
        */
        this.getContainerPresetList = function () {
            _this.state.containerPresetCollection = _this.collectionConfigService.newCollectionConfig("ContainerPreset");
            _this.state.containerPresetCollection.addDisplayProperty("containerPresetID");
            _this.state.containerPresetCollection.addDisplayProperty("containerName");
            _this.state.containerPresetCollection.addDisplayProperty("height");
            _this.state.containerPresetCollection.addDisplayProperty("width");
            _this.state.containerPresetCollection.addDisplayProperty("depth");
            _this.state.containerPresetCollection.getEntity().then(function (result) {
                _this.state.containerPresetCollection = result.pageRecords || [];
            });
        };
        /**
        * Update the dimensions of a box on the shipment
        */
        this.updateBoxDimensions = function (box) {
            if (!box.containerPreset) {
                return;
            }
            box.containerName = box.containerPreset.containerName;
            box.height = box.containerPreset.height;
            box.width = box.containerPreset.width;
            box.depth = box.containerPreset.depth;
        };
        /**
        * Add a box to the shipment
        */
        this.addNewBox = function () {
            _this.state.boxes.push({ containerItems: [] });
        };
        /**
        * Remove a box from the shipment
        */
        this.removeBox = function (index) {
            _this.state.boxes.splice(index, 1);
        };
        /**
         * Returns  orderFulfillmentItem Collection given an orderFulfillmentID.
         */
        this.createOrderFulfillmentItemCollection = function (orderFulfillmentID) {
            var collection = _this.collectionConfigService.newCollectionConfig("OrderItem");
            collection.addDisplayProperty("orderFulfillment.orderFulfillmentID");
            collection.addDisplayProperty("sku.skuCode");
            collection.addDisplayProperty("sku.skuID");
            collection.addDisplayProperty("sku.product.productName");
            collection.addDisplayProperty("sku.skuName");
            // collection.addDisplayProperty("sku.imagePath", "Path", {persistent: false});
            // collection.addDisplayProperty("sku.imageFileName", "File Name", {persistent: false});
            collection.addDisplayAggregate("sku.stocks.calculatedQOH", "SUM", "QOH");
            collection.addDisplayProperty("quantity");
            collection.addDisplayAggregate("orderDeliveryItems.quantity", "SUM", "quantityDelivered");
            collection.addDisplayProperty("orderItemID");
            collection.addFilter("orderFulfillment.orderFulfillmentID", orderFulfillmentID, "=");
            collection.addFilter("sku.stocks.location.locationID", _this.$rootScope.slatwall.defaultLocation, "=");
            collection.setPageShow(100);
            collection.getEntity().then(function (orderItems) {
                if (orderItems && orderItems.pageRecords && orderItems.pageRecords.length) {
                    _this.state.orderFulfillmentItemsCollection = orderItems['pageRecords'];
                }
                else if (orderItems && orderItems.records && orderItems.records.length) {
                    _this.state.orderFulfillmentItemsCollection = orderItems['records'];
                }
                else {
                    _this.state.orderFulfillmentItemsCollection = [];
                }
                var skuIDs = [];
                for (var i = 0; i < _this.state.orderFulfillmentItemsCollection.length; i++) {
                    skuIDs[i] = _this.state.orderFulfillmentItemsCollection[i]['sku_skuID'];
                }
                try {
                    _this.$rootScope.slatwall.getResizedImageByProfileName('small', skuIDs.join(',')).then(function (result) {
                        if (!angular.isDefined(_this.$rootScope.slatwall.imagePath)) {
                            _this.$rootScope.slatwall.imagePath = {};
                        }
                        _this.state.imagePath = _this.$rootScope.slatwall.imagePath;
                    });
                }
                catch (e) {
                    console.warn("Error while trying to retrieve the image for an item", e);
                }
                _this.emitUpdateToClient();
            });
        };
        /**
         * Submits delivery item quantity information
         */
        this.setDeliveryQuantities = function () {
            var orderDeliveryItems = [];
            for (var key in _this.state.orderItem) {
                orderDeliveryItems.push({
                    orderItem: {
                        orderItemID: key
                    },
                    quantity: _this.state.orderItem[key]
                });
            }
            var urlString = _this.$hibachi.getUrlWithActionPrefix() + 'api:main.post';
            var params = {
                entityName: 'OrderDelivery',
                context: 'getContainerDetails',
                orderDeliveryItems: orderDeliveryItems,
                apiFormat: true
            };
            var request = _this.$hibachi.requestService.newAdminRequest(urlString, params);
            request.promise.then(function (result) {
                if (!result.containerStruct) {
                    _this.state.boxes = [{ containerItems: [] }];
                    return;
                }
                _this.state.unassignedContainerItems = {};
                var boxes = [];
                for (var key in result.containerStruct) {
                    if (Array.isArray(result.containerStruct[key])) {
                        var containerArray = result.containerStruct[key];
                        for (var i = 0; i < containerArray.length; i++) {
                            var container = containerArray[i];
                            //Do this for UI tracking
                            container.containerPreset = {
                                //Don't judge me
                                containerPresetID: container.containerPresetID
                            };
                            boxes.push(container);
                        }
                    }
                }
                _this.state.boxes = boxes;
                _this.emitUpdateToClient();
            });
        };
        /**
         * Updates the quantity of a container item.
         */
        this.updateContainerItemQuantity = function (containerItem, newQuantity) {
            newQuantity = +newQuantity;
            if (newQuantity == undefined || isNaN(newQuantity)) {
                return;
            }
            if (newQuantity < 0) {
                newQuantity = 0;
            }
            if (newQuantity > containerItem.packagedQuantity) {
                var quantityDifference = newQuantity - containerItem.packagedQuantity;
                if (!_this.state.unassignedContainerItems[containerItem.sku.skuCode]) {
                    containerItem.newQuantity = containerItem.packagedQuantity;
                    return;
                }
                else if (_this.state.unassignedContainerItems[containerItem.sku.skuCode].quantity <= quantityDifference) {
                    newQuantity = containerItem.packagedQuantity + _this.state.unassignedContainerItems[containerItem.sku.skuCode].quantity;
                    quantityDifference = newQuantity - containerItem.packagedQuantity;
                    containerItem.newQuantity = newQuantity;
                    containerItem.packagedQuantity = newQuantity;
                    _this.state.unassignedContainerItems[containerItem.sku.skuCode].quantity -= quantityDifference;
                }
            }
            else if (newQuantity < containerItem.packagedQuantity) {
                if (!_this.state.unassignedContainerItems[containerItem.sku.skuCode]) {
                    _this.state.unassignedContainerItems[containerItem.sku.skuCode] = {
                        sku: containerItem.sku,
                        item: containerItem.item,
                        quantity: 0
                    };
                }
                _this.state.unassignedContainerItems[containerItem.sku.skuCode].quantity += containerItem.packagedQuantity - newQuantity;
                containerItem.packagedQuantity = newQuantity;
                containerItem.newQuantity = newQuantity;
            }
            if (_this.state.unassignedContainerItems[containerItem.sku.skuCode].quantity == 0) {
                delete _this.state.unassignedContainerItems[containerItem.sku.skuCode];
            }
            _this.cleanUpContainerItems();
            _this.emitUpdateToClient();
        };
        this.setUnassignedItemContainer = function (skuCode, container) {
            var containerItem = container.containerItems.find(function (item) {
                return item.sku.skuCode == skuCode;
            });
            if (!containerItem) {
                containerItem = {
                    item: _this.state.unassignedContainerItems[skuCode].item,
                    sku: _this.state.unassignedContainerItems[skuCode].sku,
                    packagedQuantity: 0
                };
                container.containerItems.push(containerItem);
            }
            containerItem.packagedQuantity += _this.state.unassignedContainerItems[skuCode].quantity;
            delete _this.state.unassignedContainerItems[skuCode];
            _this.cleanUpContainerItems();
            _this.emitUpdateToClient();
        };
        /**
         * Removes any container items from their container if the packaged quantity is zero
         */
        this.cleanUpContainerItems = function () {
            for (var i = 0; i < _this.state.boxes.length; i++) {
                var box = _this.state.boxes[i];
                for (var j = box.containerItems.length - 1; j >= 0; j--) {
                    var containerItem = box.containerItems[j];
                    if (containerItem.packagedQuantity == 0) {
                        box.containerItems.splice(j, 1);
                    }
                    else {
                        containerItem.newQuantity = containerItem.packagedQuantity;
                    }
                }
            }
        };
        /**
        * Returns  orderFulfillmentItem Collection given an orderFulfillmentID.
        */
        this.createOrderDeliveryAttributeCollection = function () {
            var orderDeliveryAttributes = [];
            //Get all the attributes from those sets where the set object is orderDelivery.
            var attributeCollection = _this.collectionConfigService.newCollectionConfig("Attribute");
            attributeCollection.addFilter("attributeSet.attributeSetObject", "OrderDelivery", "=");
            attributeCollection.getEntity().then(function (attributes) {
                if (attributes && attributes.pageRecords) {
                    attributes.pageRecords.forEach(function (attribute) {
                        var newAttribute = {
                            name: attribute.attributeName,
                            code: attribute.attributeCode,
                            description: attribute.attributeDescription,
                            hint: attribute.attributeHint,
                            type: attribute.attributeInputType,
                            default: attribute.defaultValue,
                            isRequired: attribute.requiredFlag,
                            isActive: attributes.activeFlag
                        };
                        orderDeliveryAttributes.push(newAttribute);
                    });
                }
            });
            //For each attribute set, get all the attributes.
            _this.state.orderDeliveryAttributes = orderDeliveryAttributes;
            _this.emitUpdateToClient(); //alert the client that we have new data to give.
        };
        //To create a store, we instantiate it using the object that holds the state variables,
        //and the reducer. We can also add a middleware to the end if you need.
        this.orderFulfillmentStore = new FluxStore.IStore(this.state, this.orderFulfillmentStateReducer);
        this.observerService.attach(this.swSelectionToggleSelectionfulfillmentBatchItemTable2, "swSelectionToggleSelectionfulfillmentBatchItemTable2", "swSelectionToggleSelectionfulfillmentBatchItemTableListener");
    }
    return OrderFulfillmentService;
}());
exports.OrderFulfillmentService = OrderFulfillmentService;


/***/ }),

/***/ "PieJ":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
exports.SWOptionsForOptionGroup = exports.SWOptionsForOptionGroupController = void 0;
/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
var SWOptionsForOptionGroupController = /** @class */ (function () {
    // @ngInject
    SWOptionsForOptionGroupController.$inject = ["$hibachi", "$timeout", "collectionConfigService", "observerService"];
    function SWOptionsForOptionGroupController($hibachi, $timeout, collectionConfigService, observerService) {
        var _this = this;
        this.$hibachi = $hibachi;
        this.$timeout = $timeout;
        this.collectionConfigService = collectionConfigService;
        this.observerService = observerService;
        this.validateChoice = function () {
            _this.observerService.notify("validateOptions", [_this.selectedOption, _this.optionGroup]);
        };
        this.optionCollectionConfig = collectionConfigService.newCollectionConfig("Option");
        this.optionCollectionConfig.setDisplayProperties("optionID, optionName, optionGroup.optionGroupID,optionGroup.optionGroupName");
        this.optionCollectionConfig.addFilter("optionGroup.optionGroupID", this.optionGroupId);
        this.optionCollectionConfig.setOrderBy('sortOrder|ASC');
        this.optionCollectionConfig.addFilter('activeFlag', 1, '=');
        this.optionCollectionConfig.setAllRecords(true);
        this.optionCollectionConfig.getEntity().then(function (response) {
            _this.options = response.records;
            if (_this.options.length) {
                _this.optionGroup = {
                    optionGroupId: _this.options[0]['optionGroup_optionGroupID'],
                    optionGroupName: _this.options[0]['optionGroup_optionGroupName']
                };
                _this.selectedOption = _this.savedOptions[_this.optionGroup.optionGroupId];
            }
        });
    }
    return SWOptionsForOptionGroupController;
}());
exports.SWOptionsForOptionGroupController = SWOptionsForOptionGroupController;
var SWOptionsForOptionGroup = /** @class */ (function () {
    // @ngInject
    SWOptionsForOptionGroup.$inject = ["$hibachi", "$timeout", "collectionConfigService", "observerService", "optionGroupPartialsPath", "slatwallPathBuilder"];
    function SWOptionsForOptionGroup($hibachi, $timeout, collectionConfigService, observerService, optionGroupPartialsPath, slatwallPathBuilder) {
        this.$hibachi = $hibachi;
        this.$timeout = $timeout;
        this.collectionConfigService = collectionConfigService;
        this.observerService = observerService;
        this.optionGroupPartialsPath = optionGroupPartialsPath;
        this.restrict = "EA";
        this.scope = {};
        this.bindToController = {
            optionGroupId: "@",
            savedOptions: "="
        };
        this.controller = SWOptionsForOptionGroupController;
        this.controllerAs = "swOptionsForOptionGroup";
        this.link = function ($scope, element, attrs) {
        };
        this.templateUrl = slatwallPathBuilder.buildPartialsPath(optionGroupPartialsPath) + "optionsforoptiongroup.html";
    }
    SWOptionsForOptionGroup.Factory = function () {
        var directive = function ($hibachi, $timeout, collectionConfigService, observerService, optionGroupPartialsPath, slatwallPathBuilder) { return new SWOptionsForOptionGroup($hibachi, $timeout, collectionConfigService, observerService, optionGroupPartialsPath, slatwallPathBuilder); };
        directive.$inject = [
            '$hibachi',
            '$timeout',
            'collectionConfigService',
            'observerService',
            'optionGroupPartialsPath',
            'slatwallPathBuilder'
        ];
        return directive;
    };
    return SWOptionsForOptionGroup;
}());
exports.SWOptionsForOptionGroup = SWOptionsForOptionGroup;


/***/ }),

/***/ "PwPv":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
exports.DefaultSkuService = void 0;
/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
var DefaultSkuService = /** @class */ (function () {
    //@ngInject
    DefaultSkuService.$inject = ["$hibachi", "observerService"];
    function DefaultSkuService($hibachi, observerService) {
        var _this = this;
        this.$hibachi = $hibachi;
        this.observerService = observerService;
        this.observerKeys = {};
        this.defaultSkuSelections = {};
        this.attachObserver = function (selectionID, productID) {
            if (angular.isUndefined(_this.observerKeys[selectionID])) {
                _this.observerKeys[selectionID] = { attached: true, productID: productID, hasBeenCalled: false };
                _this.observerService.attach(_this.decideToSaveSku, 'swSelectionToggleSelection' + selectionID);
            } //otherwise the event has been attached
        };
        this.decideToSaveSku = function (args) {
            if (_this.defaultSkuSelections[args.selectionid] == null) {
                _this.defaultSkuSelections[args.selectionid] = args.selection;
            }
            else if (_this.defaultSkuSelections[args.selectionid] != args.selection) {
                _this.defaultSkuSelections[args.selectionid] = args.selection;
                _this.saveDefaultSku(args);
            }
        };
        this.saveDefaultSku = function (args) {
            //we only want to call save on the second and subsequent times the event fires, because it will fire when it is initialized
            _this.$hibachi.getEntity("Product", _this.observerKeys[args.selectionid].productID).then(function (product) {
                var product = _this.$hibachi.populateEntity("Product", product);
                product.$$setDefaultSku(_this.$hibachi.populateEntity("Sku", { skuID: args.selection }));
                product.$$save().then(function () {
                    //there was success
                }, function () {
                    //there was a problem
                });
            }, function (reason) {
            });
        };
    }
    DefaultSkuService.prototype.setDefaultSkuSelection = function (selectionID, skuID) {
        this.defaultSkuSelections[selectionID] = skuID;
    };
    return DefaultSkuService;
}());
exports.DefaultSkuService = DefaultSkuService;


/***/ }),

/***/ "QEq2":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
exports.SWSkuImageController = exports.SWSkuImage = void 0;
/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
var SWSkuImageController = /** @class */ (function () {
    //@ngInject
    SWSkuImageController.$inject = ["fileService", "$hibachi", "$http", "appConfig"];
    function SWSkuImageController(fileService, $hibachi, $http, appConfig) {
        var _this = this;
        this.fileService = fileService;
        this.$hibachi = $hibachi;
        this.$http = $http;
        this.appConfig = appConfig;
        if (this.imageFile == null) {
            this.imagePath = this.appConfig.baseImageURL + '/image-placeholder.jpg';
            return;
        }
        if (this.imagePath == null) {
            this.imagePath = this.appConfig.baseImageURL + '/' + this.imageFile;
        }
        fileService.imageExists(this.imagePath).then(function () {
            //Do nothing
        }, function () {
            _this.imagePath = _this.appConfig.missingImageURL;
        }).finally(function () {
            if (angular.isDefined(_this.imagePath)) {
                _this.image = _this.imagePath;
            }
        });
    }
    return SWSkuImageController;
}());
exports.SWSkuImageController = SWSkuImageController;
var SWSkuImage = /** @class */ (function () {
    function SWSkuImage(skuPartialsPath, slatwallPathBuilder) {
        this.restrict = 'EA';
        this.scope = {};
        this.bindToController = {
            imageFile: "@?",
            imagePath: "@?"
        };
        this.controller = SWSkuImageController;
        this.controllerAs = "swSkuImage";
        this.templateUrl = slatwallPathBuilder.buildPartialsPath(skuPartialsPath) + "skuimage.html";
    }
    SWSkuImage.Factory = function () {
        var directive = function (skuPartialsPath, slatwallPathBuilder) { return new SWSkuImage(skuPartialsPath, slatwallPathBuilder); };
        directive.$inject = [
            'skuPartialsPath',
            'slatwallPathBuilder'
        ];
        return directive;
    };
    return SWSkuImage;
}());
exports.SWSkuImage = SWSkuImage;


/***/ }),

/***/ "Qfls":
/***/ (function(module, exports) {

module.exports = "<sw-modal-launcher data-launch-event-name=\"EDIT_SKUPRICE\"\n                   data-modal-name=\"{{swSkuPriceModal.uniqueName}}\" \n                   data-title=\"Add Sku Price Detail\" \n                   data-save-action=\"swSkuPriceModal.save\">\n    \n    <sw-modal-button>\n        <ng-transclude></ng-transclude>\n    </sw-modal-button>\n    \n    <sw-modal-content> \n        \n        <sw-form ng-if=\"swSkuPriceModal.skuPrice\"\n                 name=\"{{swSkuPriceModal.formName}}\" \n                 data-object=\"swSkuPriceModal.skuPrice\"    \n                 data-context=\"save\"\n                 >\n            <div ng-show=\"!swSkuPriceModal.saveSuccess\" class=\"alert alert-error\" role=\"alert\" sw-rbkey=\"'admin.entity.addskuprice.invalid'\"></div>\n            <div class=\"row\">\n                    <div class=\"col-sm-4\">\n                        <sw-sku-thumbnail ng-if=\"swSkuPriceModal.sku.data\" data-sku-data=\"swSkuPriceModal.sku.data\">\n                        </sw-sku-thumbnail>\n                    </div>\n                    <div class=\"col-sm-8\">\n                        <div class=\"row\">\n                            <div class=\"col-sm-4\">\n                                <label  class=\"control-label\"\n                                        sw-rbKey=\"'entity.SkuPrice.price'\">\n                                </label>\n                                <input  class=\"form-control\" \n                                        type=\"text\" \n                                        name=\"price\" \n                                        ng-model=\"swSkuPriceModal.skuPrice.price\"\n                                />\n                            </div> \n                            <div class=\"col-sm-4\">\n                                <label  class=\"control-label\"\n                                        sw-rbKey=\"'entity.SkuPrice.listPrice'\">\n                                </label>\n                                <input  class=\"form-control\" \n                                        type=\"text\" \n                                        name=\"listPrice\" \n                                        ng-model=\"swSkuPriceModal.skuPrice.listPrice\"\n                                />\n                            </div> \n                            <div class=\"col-sm-4\">\n                                <div class=\"form-group\">\n                                    <label for=\"\" class=\"control-label\">Currency Code</label>\n                                    <select class=\"form-control\" \n                                            name=\"currencyCode\"\n                                            ng-model=\"swSkuPriceModal.selectedCurrencyCode\"\n                                            ng-options=\"item as item for item in swSkuPriceModal.currencyCodeOptions track by item\"\n                                            ng-disabled=\"swSkuPriceModal.isDefaultSkuPrice()\"\n                                            >\n                                    </select>\n                                </div>\n                            </div>\n                        </div>\n                        \n                        <div class=\"row\">\n                            <div class=\"col-sm-6\">\n                                <label  class=\"control-label\"\n                                        sw-rbKey=\"'entity.SkuPrice.minQuantity'\">\n                                </label>\n                                <input  class=\"form-control\" \n                                        type=\"text\" \n                                        name=\"minQuantity\" \n                                        ng-model=\"swSkuPriceModal.skuPrice.minQuantity\"\n                                        ng-disabled=\"swSkuPriceModal.isDefaultSkuPrice()\"\n                                />\n                            </div>\n                            <div class=\"col-sm-6\">\n                                <label  class=\"control-label\"\n                                        sw-rbKey=\"'entity.SkuPrice.maxQuantity'\">\n                                </label>\n                                <input  class=\"form-control\" \n                                        type=\"text\" \n                                        name=\"maxQuantity\" \n                                        ng-model=\"swSkuPriceModal.skuPrice.maxQuantity\"\n                                        ng-disabled=\"swSkuPriceModal.isDefaultSkuPrice()\"\n                                />\n                            </div>\n                        </div>\n                        <div class=\"row\">\n                            <div class=\"col-sm-6\">\n                                <label  class=\"control-label\"\n                                        sw-rbKey=\"'entity.Sku'\">\n                                        \n                                </label>\n                                <sw-typeahead-search    data-collection-config=\"swSkuPriceModal.skuCollectionConfig\"\n                                                        data-disabled=\"swSkuPriceModal.isDefaultSkuPrice()\"\n                                                        data-placeholder-text=\"Select Sku\"\n                                                        data-search-text=\"swSkuPriceModal.selectedSku['skuCode']\"\n                                                        data-add-function=\"swSkuPriceModal.setSelectedSku\"\n                                                        data-property-to-show=\"skuCode\">\n                                    <span sw-typeahead-search-line-item data-property-identifier=\"skuCode\" ng-bind=\"item.skuCode\"></span>\n                                </sw-typeahead-search>\n                                <input type=\"hidden\" readonly style=\"display:none\" name=\"sku\" ng-model=\"swSkuPriceModal.submittedSku\" />\n                            </div>\n                            <div class=\"col-sm-6\">\n                                \n                                <label  class=\"control-label\"\n                                        sw-rbKey=\"'entity.PriceGroup'\">\n                                        \n                                </label>\n                                <select class=\"form-control\" \n                                        ng-model=\"swSkuPriceModal.selectedPriceGroup\"\n                                        ng-options=\"item as item.priceGroupName for item in swSkuPriceModal.priceGroupOptions track by item.priceGroupID\"\n                                        ng-change=\"swSkuPriceModal.setSelectedPriceGroup(swSkuPriceModal.selectedPriceGroup)\"\n                                        ng-disabled=\"swSkuPriceModal.isDefaultSkuPrice() || swSkuPriceModal.priceGroupEditable == false\"\n                                        >\n                                </select>\n                                <input type=\"hidden\" readonly style=\"display:none\" name=\"priceGroup\" ng-model=\"swSkuPriceModal.submittedPriceGroup\" />\n                            </div>\n                        </div>\n                        <!-- BEGIN HIDDEN FIELDS -->\n                        \n                        <!-- END HIDDEN FIELDS -->\n                    </div>\n                </div>\n            </sw-form>\n    </sw-modal-content> \n</sw-modal-launcher>";

/***/ }),

/***/ "Qg35":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
exports.SWAddPromotionOrderItemsBySku = void 0;
/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
var SWAddPromotionOrderItemsBySkuController = /** @class */ (function () {
    function SWAddPromotionOrderItemsBySkuController($hibachi, collectionConfigService, observerService, orderTemplateService, rbkeyService) {
        var _this = this;
        this.$hibachi = $hibachi;
        this.collectionConfigService = collectionConfigService;
        this.observerService = observerService;
        this.orderTemplateService = orderTemplateService;
        this.rbkeyService = rbkeyService;
        this.$onInit = function () {
            _this.observerService.attach(_this.setEdit, 'swEntityActionBar');
            var skuDisplayProperties = "skuCode,calculatedSkuDefinition,product.productName";
            if (_this.skuPropertiesToDisplay != null) {
                // join the two lists.
                skuDisplayProperties = skuDisplayProperties + "," + _this.skuPropertiesToDisplay;
            }
            _this.addSkuCollection = _this.collectionConfigService.newCollectionConfig('Sku');
            _this.addSkuCollection.setDisplayProperties(skuDisplayProperties, '', { isVisible: true, isSearchable: true, isDeletable: true, isEditable: false });
            _this.addSkuCollection.addDisplayProperty('product.productType.productTypeName', 'Product Type', { isVisible: true, isSearchable: false, isDeletable: false, isEditable: false });
            _this.addSkuCollection.addDisplayProperty('price', '', { isVisible: true, isSearchable: false, isDeletable: false, isEditable: false });
            _this.addSkuCollection.addDisplayProperty('skuID', '', { isVisible: false, isSearchable: false, isDeletable: false, isEditable: false });
            _this.addSkuCollection.addDisplayProperty('imageFile', _this.rbkeyService.rbKey('entity.sku.imageFile'), { isVisible: false, isSearchable: false, isDeletable: false });
            _this.addSkuCollection.addDisplayProperty('qats', 'QATS', { isVisible: true, isSearchable: false, isDeletable: false, isEditable: false });
            if (_this.skuPropertiesToDisplayWithConfig) {
                // this allows passing in display property information. skuPropertiesToDisplayWithConfig is an array of objects
                var skuPropertiesToDisplayWithConfig = _this.skuPropertiesToDisplayWithConfig.replace(/'/g, '"');
                //now we can parse into a json array
                var skuPropertiesToDisplayWithConfigObject = JSON.parse(skuPropertiesToDisplayWithConfig);
                //now we can iterate and add the display properties defined on this attribute..
                for (var _i = 0, skuPropertiesToDisplayWithConfigObject_1 = skuPropertiesToDisplayWithConfigObject; _i < skuPropertiesToDisplayWithConfigObject_1.length; _i++) {
                    var property = skuPropertiesToDisplayWithConfigObject_1[_i];
                    _this.addSkuCollection.addDisplayProperty(property.name, property.rbkey, property.config);
                }
            }
            _this.addSkuCollection.addFilter('activeFlag', true, '=', undefined, true);
            _this.addSkuCollection.addFilter('publishedFlag', true, '=', undefined, true);
            //filter the sku listing on just the promotion skus.
            if (_this.promotionSkus) {
                _this.addSkuCollection.addFilter('skuID', _this.promotionSkus, 'in', undefined, true);
            }
            _this.skuColumns = angular.copy(_this.addSkuCollection.getCollectionConfig().columns);
            _this.skuColumns.push({
                'title': _this.rbkeyService.rbKey('define.quantity'),
                'propertyIdentifier': 'quantity',
                'type': 'number',
                'defaultValue': 1,
                'isCollectionColumn': false,
                'isEditable': true,
                'isVisible': true
            }, {
                'title': _this.rbkeyService.rbKey('define.price'),
                'propertyIdentifier': 'price',
                'type': 'number',
                'isCollectionColumn': true,
                'isEditable': true,
                'isVisible': true
            });
            //if this is an exchange order, add a dropdown...
            if (_this.exchangeOrderFlag) {
                _this.skuColumns.push({
                    'title': _this.rbkeyService.rbKey('define.orderItemType'),
                    'propertyIdentifier': 'orderItemTypeSystemCode',
                    'type': 'select',
                    'defaultValue': 1,
                    'options': [
                        { "name": "Sale Item", "value": "oitSale", "selected": "selected" },
                        { "name": "Return Item", "value": "oitReturn" }
                    ],
                    'isCollectionColumn': false,
                    'isEditable': true,
                    'isVisible': true
                });
            }
            //if we have an order fulfillment, then display the dropdown
            if (_this.orderFulfillmentId != 'new' && _this.orderFulfillmentId != '') {
                _this.skuColumns.push({
                    'title': _this.rbkeyService.rbKey('define.orderFulfillment'),
                    'propertyIdentifier': 'orderFulfillmentID',
                    'type': 'select',
                    'defaultValue': 1,
                    'options': [
                        { "name": _this.simpleRepresentation || "Order Fulfillment", "value": _this.orderFulfillmentId, "selected": "selected" },
                        { "name": "New", "value": "new" }
                    ],
                    'isCollectionColumn': false,
                    'isEditable': true,
                    'isVisible': true
                });
            }
            _this.observerService.attach(_this.addOrderItemListener, "addPromotionOrderItem");
        };
        this.addOrderItemListener = function (payload) {
            //figure out if we need to show this modal or not.
            //need to display a modal with the add order item preprocess method.
            var orderItemTypeSystemCode = payload.orderItemTypeSystemCode ? payload.orderItemTypeSystemCode.value : "oitSale";
            var orderFulfilmentID = (payload.orderFulfillmentID && payload.orderFulfillmentID.value) ? payload.orderFulfillmentID.value : (_this.orderFulfillmentId ? _this.orderFulfillmentId : "new");
            var url = "?slatAction=entity.processOrder&skuID=" + payload.skuID + "&price=" + payload.price + "&quantity=" + payload.quantity + "&orderID=" + _this.order + "&orderItemTypeSystemCode=" + orderItemTypeSystemCode + "&orderFulfillmentID=" + orderFulfilmentID + "&processContext=addorderitem&ajaxRequest=1";
            if (orderFulfilmentID && orderFulfilmentID != "new") {
                url = url + "&preProcessDisplayedFlag=1";
            }
            var data = { orderFulfillmentID: orderFulfilmentID, quantity: payload.quantity, price: payload.price };
            _this.observerService.notify("addPromotionOrderItemStartLoading", {});
            _this.postData(url, data)
                .then(function (data) {
                if (data.preProcessView) {
                    //populate a modal with the template data...
                    var parsedHtml = data.preProcessView;
                    $('#adminModal').modal();
                    // show modal
                    window.renderModal(parsedHtml);
                }
                else {
                    //notify the orderitem listing that it needs to refresh itself...
                    //get the new persisted values...
                    _this.observerService.notify("refreshOrderItemListing", {});
                    //now get the order values because we updated them and pass along to anything listening...
                    _this.$hibachi.getEntity("Order", _this.order).then(function (data) {
                        _this.observerService.notify("refreshOrder" + _this.order, data);
                        _this.observerService.notify("addPromotionOrderItemStopLoading", {});
                    });
                    _this.observerService.notify("addPromotionOrderItemStopLoading", {});
                    //(window as any).location.reload();
                }
            }) // JSON-string from `response.json()` call
                .catch(function (error) { return console.error(error); });
        };
        this.setEdit = function (payload) {
            _this.edit = payload.edit;
        };
        if (this.edit == null) {
            this.edit = false;
        }
    }
    SWAddPromotionOrderItemsBySkuController.prototype.postData = function (url, data) {
        if (url === void 0) { url = ''; }
        if (data === void 0) { data = {}; }
        var config = {
            'headers': { 'Content-Type': 'X-Hibachi-AJAX' }
        };
        return this.$hibachi.$http.post(url, data, config)
            .then(function (response) { return response.data; }); // parses JSON response into native JavaScript objects 
    };
    ;
    return SWAddPromotionOrderItemsBySkuController;
}());
var SWAddPromotionOrderItemsBySku = /** @class */ (function () {
    function SWAddPromotionOrderItemsBySku(orderPartialsPath, slatwallPathBuilder, $hibachi, rbkeyService) {
        this.orderPartialsPath = orderPartialsPath;
        this.slatwallPathBuilder = slatwallPathBuilder;
        this.$hibachi = $hibachi;
        this.rbkeyService = rbkeyService;
        this.restrict = "EA";
        this.scope = {};
        this.bindToController = {
            order: '<?',
            orderFulfillmentId: '<?',
            accountId: '<?',
            currencyCode: '<?',
            simpleRepresentation: '<?',
            returnOrderId: '<?',
            skuPropertiesToDisplay: '@?',
            promotionSkus: '@?',
            skuPropertiesToDisplayWithConfig: '@?',
            edit: "=?",
            exchangeOrderFlag: "=?"
        };
        this.controller = SWAddPromotionOrderItemsBySkuController;
        this.controllerAs = "swAddPromotionOrderItemsBySku";
        this.link = function (scope, element, attrs) {
        };
        this.templateUrl = slatwallPathBuilder.buildPartialsPath(orderPartialsPath) + "/addpromotionorderitemsbysku.html";
    }
    SWAddPromotionOrderItemsBySku.Factory = function () {
        var directive = function (orderPartialsPath, slatwallPathBuilder, $hibachi, rbkeyService) { return new SWAddPromotionOrderItemsBySku(orderPartialsPath, slatwallPathBuilder, $hibachi, rbkeyService); };
        directive.$inject = [
            'orderPartialsPath',
            'slatwallPathBuilder',
            '$hibachi',
            'rbkeyService'
        ];
        return directive;
    };
    return SWAddPromotionOrderItemsBySku;
}());
exports.SWAddPromotionOrderItemsBySku = SWAddPromotionOrderItemsBySku;


/***/ }),

/***/ "SBrW":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
exports.SkuPriceService = void 0;
/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
var SkuPriceService = /** @class */ (function () {
    //@ngInject
    SkuPriceService.$inject = ["$http", "$q", "$hibachi", "entityService", "cacheService", "collectionConfigService", "observerService", "utilityService"];
    function SkuPriceService($http, $q, $hibachi, entityService, cacheService, collectionConfigService, observerService, utilityService) {
        var _this = this;
        this.$http = $http;
        this.$q = $q;
        this.$hibachi = $hibachi;
        this.entityService = entityService;
        this.cacheService = cacheService;
        this.collectionConfigService = collectionConfigService;
        this.observerService = observerService;
        this.utilityService = utilityService;
        this.skuPrices = {};
        this.skuPriceCollectionConfigs = {};
        this.skuPriceGetEntityPromises = {};
        this.skuDictionary = {};
        this.skuPriceHasEntityDeferred = {};
        this.skuPriceHasEntityPromises = {};
        this.newSkuPrice = function () {
            return _this.entityService.newEntity('SkuPrice');
        };
        this.getRelatedSkuPriceCollectionConfig = function (skuID, currencyCode, minQuantity, maxQuantity) {
            var relatedSkuPriceCollectionConfig = _this.collectionConfigService.newCollectionConfig("SkuPrice");
            relatedSkuPriceCollectionConfig.addDisplayProperty("skuPriceID,sku.skuID,minQuantity,maxQuantity,currencyCode,price,priceGroup.priceGroupID");
            relatedSkuPriceCollectionConfig.addFilter("minQuantity", minQuantity, "=");
            relatedSkuPriceCollectionConfig.addFilter("maxQuantity", maxQuantity, "=");
            relatedSkuPriceCollectionConfig.addFilter("currencyCode", currencyCode, "!=");
            relatedSkuPriceCollectionConfig.addFilter("sku.skuID", skuID, "=");
            relatedSkuPriceCollectionConfig.addOrderBy("currencyCode|asc");
            relatedSkuPriceCollectionConfig.setAllRecords(true);
            return relatedSkuPriceCollectionConfig;
        };
        //wrapper function to split up args
        this.updateSkuPrices = function (args) {
            _this.loadSkuPricesForSku(args.skuID, args.refresh);
        };
        this.loadSkuPricesForSku = function (skuID, refresh) {
            _this.skuPriceHasEntityDeferred[skuID] = _this.$q.defer();
            _this.skuPriceHasEntityPromises[skuID] = _this.skuPriceHasEntityDeferred[skuID].promise;
            if (angular.isUndefined(_this.skuPriceCollectionConfigs[skuID])) {
                _this.skuPriceCollectionConfigs[skuID] = _this.collectionConfigService.newCollectionConfig("SkuPrice");
                //get info to compare for line items
                _this.skuPriceCollectionConfigs[skuID].addDisplayProperty("skuPriceID,minQuantity,maxQuantity,currencyCode,price,sku.skuID,priceGroup.priceGroupID,priceGroup.priceGroupCode");
                _this.skuPriceCollectionConfigs[skuID].addFilter("sku.skuID", skuID, "=");
                _this.skuPriceCollectionConfigs[skuID].addOrderBy("currencyCode|asc");
                _this.skuPriceCollectionConfigs[skuID].setAllRecords(true);
            }
            if (angular.isUndefined(_this.skuPriceGetEntityPromises[skuID]) || refresh) {
                _this.skuPriceGetEntityPromises[skuID] = _this.skuPriceCollectionConfigs[skuID].getEntity();
                refresh = true;
            }
            if (refresh) {
                _this.skuPriceGetEntityPromises[skuID].then(function (response) {
                    angular.forEach(response.records, function (value, key) {
                        var skuPrice = _this.$hibachi.populateEntity("SkuPrice", value);
                        var priceGroup = _this.$hibachi.populateEntity('PriceGroup', { priceGroupID: value.priceGroup_priceGroupID, priceGroupCode: value.priceGroup_priceGroupCode });
                        skuPrice.$$setPriceGroup(priceGroup);
                        var skuPrices = [skuPrice];
                        _this.setSkuPrices(skuID, skuPrices);
                    });
                }, function (reason) {
                    _this.skuPriceHasEntityPromises[skuID].reject();
                    throw ("skupriceservice failed to get sku prices" + reason);
                }).finally(function () {
                    _this.skuPriceHasEntityPromises[skuID].resolve();
                });
            }
            return _this.skuPriceGetEntityPromises[skuID];
        };
        this.setSkuPrices = function (skuID, skuPrices) {
            if (angular.isDefined(_this.skuPrices[skuID])) {
                for (var i = 0; i < skuPrices.length; i++) {
                    if (_this.getKeyOfSkuPriceMatch(skuID, skuPrices[i]) != -1) {
                        _this.getSkuPrices(skuID)[_this.getKeyOfSkuPriceMatch(skuID, skuPrices[i])].data.price = skuPrices[i].data.price;
                        skuPrices.splice(i, 1);
                        i--;
                    }
                }
                _this.skuPrices[skuID] = _this.skuPrices[skuID].concat(skuPrices);
            }
            else {
                _this.skuPrices[skuID] = skuPrices;
            }
        };
        this.hasSkuPrices = function (skuID) {
            if (angular.isDefined(_this.skuPrices[skuID])) {
                return true;
            }
            return false;
        };
        this.getSkuPrices = function (skuID) {
            if (angular.isDefined(_this.skuPrices[skuID])) {
                return _this.skuPrices[skuID];
            }
        };
        this.loadCurrencies = function () {
            var loadCurrenciesDeferred = _this.$q.defer();
            var loadCurrenciesPromise = loadCurrenciesDeferred.promise;
            if (angular.isDefined(_this.currencies)) {
                loadCurrenciesDeferred.resolve(_this.currencies);
            }
            else {
                var currencyRatePromise = _this.$http({
                    method: "POST",
                    url: _this.$hibachi.getUrlWithActionPrefix() + "api:main.getcurrencyrates"
                });
                currencyRatePromise.then(function (response) {
                    _this.currencies = response.data;
                    loadCurrenciesDeferred.resolve(_this.currencies);
                }, function (reason) {
                    loadCurrenciesDeferred.reject(reason);
                });
            }
            return loadCurrenciesPromise;
        };
        //logic for inferred currency prices
        this.getInferredSkuPrice = function (sku, basePrice, currencyCode) {
            if (angular.isDefined(_this.currencies[currencyCode]) && sku.data.currencyCode != currencyCode) {
                var currencyData = _this.currencies[currencyCode];
                if (currencyData.CONVERTFROM == sku.data.currencyCode) {
                    return basePrice * (currencyData.CONVERSIONRATE);
                }
                else if (currencyData.CONVERTFROM == "EUR" && _this.currencies[sku.data.currencyCode].CONVERTFROM == "EUR") {
                    //Convert using euro
                    var tempPrice = basePrice * (currencyData.CONVERSIONRATE);
                    return tempPrice * (_this.currencies[sku.data.currencyCode].CONVERSIONRATE);
                }
                else {
                    return "N/A"; //will become NaN
                }
            }
            else if (sku.data.currencyCode == currencyCode) {
                return basePrice;
            }
            return "N/A"; //will become NaN
        };
        this.getPriceGroupOptions = function () {
            var priceGroupOptions;
            var priceGroupCollectionConfig = _this.collectionConfigService.newCollectionConfig("PriceGroup");
            priceGroupCollectionConfig.setDisplayProperties("priceGroupID,priceGroupCode,priceGroupName");
            priceGroupCollectionConfig.addFilter("activeFlag", true, "=");
            priceGroupCollectionConfig.setAllRecords(true);
            return priceGroupCollectionConfig.getEntity();
        };
        this.getSkuOptions = function (productID) {
            var skuOptions;
            var skuColectionConfig = _this.collectionConfigService.newCollectionConfig("Sku");
            skuColectionConfig.setDisplayProperties("skuID,skuName,skuCode,imagePath");
            skuColectionConfig.addFilter("product.productID", productID, "=");
            skuColectionConfig.setAllRecords(true);
            return skuColectionConfig.getEntity();
        };
        this.getCurrencyOptions = function () {
            var currenyOptions;
            var currencyCollectionConfig = _this.collectionConfigService.newCollectionConfig("Currency");
            currencyCollectionConfig.setDisplayProperties("currencyCode");
            currencyCollectionConfig.addFilter("activeFlag", true, "=");
            currencyCollectionConfig.setAllRecords(true);
            return currencyCollectionConfig.getEntity();
        };
        this.getSkuCollectionConfig = function (productID) {
            var config = _this.collectionConfigService.newCollectionConfig("Sku");
            config.setDisplayProperties("skuID,skuName,skuCode");
            config.addDisplayProperty("imagePath", "", { 'isSearchable': false });
            config.addFilter("product.productID", productID, "=");
            return config;
        };
        this.createInferredSkuPriceForCurrency = function (sku, skuPrice, currencyCode) {
            var nonPersistedSkuPrice = _this.entityService.newEntity('SkuPrice');
            nonPersistedSkuPrice.$$setSku(sku);
            nonPersistedSkuPrice.data.currencyCode = currencyCode;
            //if for some reason the price that came back was preformatted althought this really shouldn't be needed
            if (angular.isString(sku.data.price) && isNaN(parseFloat(sku.data.price.substr(0, 1)))) {
                //strip currency symbol
                sku.data.price = parseFloat(sku.data.price.substr(1, sku.data.price.length));
            }
            var basePrice = 0;
            if (angular.isDefined(skuPrice)) {
                basePrice = skuPrice.data.price;
            }
            else {
                basePrice = sku.data.price;
            }
            nonPersistedSkuPrice.data.price = _this.getInferredSkuPrice(sku, basePrice, currencyCode);
            if (angular.isDefined(skuPrice) && angular.isDefined(skuPrice.data.minQuantity) && !isNaN(skuPrice.data.minQuantity)) {
                nonPersistedSkuPrice.data.minQuantity = skuPrice.data.minQuantity;
            }
            if (angular.isDefined(skuPrice) && angular.isDefined(skuPrice.data.maxQuantity) && !isNaN(skuPrice.data.maxQuantity)) {
                nonPersistedSkuPrice.data.maxQuantity = skuPrice.data.maxQuantity;
            }
            nonPersistedSkuPrice.data.inferred = true;
            return nonPersistedSkuPrice;
        };
        this.skuPriceSetHasCurrencyCode = function (skuPriceSet, currencyCode) {
            for (var k = 0; k < skuPriceSet.length; k++) {
                if (currencyCode == skuPriceSet[k].data.currencyCode) {
                    return true;
                }
            }
            return false;
        };
        this.defaultCurrencySkuPriceForSet = function (skuPriceSet) {
            for (var i = 0; i < skuPriceSet.length; i++) {
                //temporarily hard coded
                if (skuPriceSet[i].data.currencyCode == "USD") {
                    return skuPriceSet[i];
                }
            }
        };
        this.getSku = function (skuID) {
            var deferred = _this.$q.defer();
            var promise = deferred.promise;
            if (skuID in _this.skuDictionary) {
                var sku = _this.skuDictionary[skuID];
                deferred.resolve(sku);
            }
            else {
                _this.$hibachi.getEntity("Sku", skuID).then(function (response) {
                    _this.skuDictionary[skuID] = _this.$hibachi.populateEntity("Sku", response);
                    deferred.resolve(_this.skuDictionary[skuID]);
                }, function (reason) {
                    deferred.reject(reason);
                });
            }
            return promise;
        };
        this.loadInferredSkuPricesForSkuPriceSet = function (skuID, skuPriceSet, eligibleCurrencyCodes) {
            var deferred = _this.$q.defer();
            var promise = deferred.promise;
            _this.loadCurrencies().then(function () {
                _this.getSku(skuID).then(function (sku) {
                    for (var j = 0; j < eligibleCurrencyCodes.length; j++) {
                        if ((sku.data.currencyCode != eligibleCurrencyCodes[j]) &&
                            (skuPriceSet.length > 0 && !_this.skuPriceSetHasCurrencyCode(skuPriceSet, eligibleCurrencyCodes[j])) ||
                            ((sku.data.currencyCode != eligibleCurrencyCodes[j]) && skuPriceSet.length == 0)) {
                            skuPriceSet.push(_this.createInferredSkuPriceForCurrency(sku, _this.defaultCurrencySkuPriceForSet(skuPriceSet), eligibleCurrencyCodes[j]));
                        }
                    }
                    skuPriceSet = _this.sortSkuPrices(skuPriceSet);
                }, function (reason) {
                }).finally(function () {
                    deferred.resolve(skuPriceSet);
                });
            });
            return promise;
        };
        this.getBaseSkuPricesForSku = function (skuID, eligibleCurrencyCodes) {
            var deferred = _this.$q.defer();
            var promise = deferred.promise;
            var skuPriceSet = [];
            if (angular.isDefined(_this.skuPriceHasEntityPromises[skuID])) {
                _this.skuPriceGetEntityPromises[skuID].then(function () {
                    var skuPrices = _this.getSkuPrices(skuID) || [];
                    for (var i = 0; i < skuPrices.length; i++) {
                        var skuPrice = skuPrices[i];
                        if (_this.isBaseSkuPrice(skuPrice.data)) {
                            skuPriceSet.push(skuPrice);
                        }
                    }
                }).finally(function () {
                    if (angular.isDefined(eligibleCurrencyCodes)) {
                        _this.loadInferredSkuPricesForSkuPriceSet(skuID, skuPriceSet, eligibleCurrencyCodes).then(function (data) {
                            deferred.resolve(_this.sortSkuPrices(data));
                        });
                    }
                    else {
                        deferred.resolve(_this.sortSkuPrices(skuPriceSet));
                    }
                });
            }
            return promise;
        };
        this.getSkuPricesForQuantityRange = function (skuID, minQuantity, maxQuantity, eligibleCurrencyCodes, priceGroupID) {
            var deferred = _this.$q.defer();
            var promise = deferred.promise;
            var skuPriceSet = [];
            if (angular.isDefined(_this.skuPriceHasEntityPromises[skuID])) {
                _this.skuPriceGetEntityPromises[skuID].then(function () {
                    var skuPrices = _this.getSkuPrices(skuID);
                    for (var i = 0; i < skuPrices.length; i++) {
                        var skuPrice = skuPrices[i];
                        if (_this.isQuantityRangeSkuPrice(skuPrice.data, minQuantity, maxQuantity, priceGroupID)) {
                            skuPriceSet.push(skuPrice);
                        }
                    }
                }).finally(function () {
                    if (angular.isDefined(eligibleCurrencyCodes)) {
                        _this.loadInferredSkuPricesForSkuPriceSet(skuID, skuPriceSet, eligibleCurrencyCodes).then(function (data) {
                            deferred.resolve(_this.sortSkuPrices(data));
                        });
                    }
                    else {
                        deferred.resolve(_this.sortSkuPrices(skuPriceSet));
                    }
                });
            }
            return promise;
        };
        this.getKeyOfSkuPriceMatch = function (skuID, skuPrice) {
            if (_this.hasSkuPrices(skuID)) {
                for (var i = 0; i < _this.getSkuPrices(skuID).length; i++) {
                    var savedSkuPriceData = _this.getSkuPrices(skuID)[i].data;
                    var priceGroupID = undefined;
                    if (skuPrice.data.priceGroup) {
                        priceGroupID = skuPrice.data.priceGroup.$$getID() || skuPrice.data.priceGroup_priceGroupID;
                    }
                    if (savedSkuPriceData.currencyCode == skuPrice.data.currencyCode &&
                        ((_this.isBaseSkuPrice(savedSkuPriceData) &&
                            _this.isBaseSkuPrice(savedSkuPriceData) == _this.isBaseSkuPrice(skuPrice.data)) || _this.isQuantityRangeSkuPrice(savedSkuPriceData, skuPrice.data.minQuantity, skuPrice.data.maxQuantity, priceGroupID))) {
                        return i;
                    }
                }
            }
            return -1;
        };
        this.isBaseSkuPrice = function (skuPriceData) {
            return isNaN(parseInt(skuPriceData.minQuantity)) && isNaN(parseInt(skuPriceData.maxQuantity)) && !(skuPriceData.priceGroup && skuPriceData.priceGroup.$$getID().trim().length);
        };
        this.isQuantityRangeSkuPrice = function (skuPriceData, minQuantity, maxQuantity, priceGroupID) {
            var minQuantityMatch = (parseInt(skuPriceData.minQuantity) == parseInt(minQuantity))
                || (isNaN(parseInt(skuPriceData.minQuantity))
                    && isNaN(parseInt(minQuantity)));
            var maxQuantityMatch = (parseInt(skuPriceData.maxQuantity) == parseInt(maxQuantity)) || (isNaN(parseInt(skuPriceData.maxQuantity))
                && isNaN(parseInt(maxQuantity)));
            var priceGroupMatch = false;
            if (typeof priceGroupID !== 'undefined' && typeof skuPriceData.priceGroup_priceGroupID !== 'undefined') {
                if (skuPriceData.priceGroup_priceGroupID.length) {
                    priceGroupMatch = skuPriceData.priceGroup_priceGroupID == priceGroupID;
                }
                else {
                    skuPriceData.priceGroup_priceGroupID == priceGroupID;
                }
            }
            else {
                if (typeof priceGroupID == 'undefined'
                    && typeof skuPriceData.priceGroup_priceGroupID == 'undefined') {
                    priceGroupMatch = true;
                }
                else {
                    priceGroupMatch = false;
                }
            }
            return minQuantityMatch && maxQuantityMatch && priceGroupMatch;
        };
        this.sortSkuPrices = function (skuPriceSet) {
            function compareSkuPrices(a, b) {
                //temporarily hardcoded to usd needs to be default sku value
                if (a.data.currencyCode == "USD")
                    return -1;
                if (a.data.currencyCode < b.data.currencyCode)
                    return -1;
                if (a.data.currencyCode > b.data.currencyCode)
                    return 1;
                return 0;
            }
            return skuPriceSet.sort(compareSkuPrices);
        };
        this.observerService.attach(this.updateSkuPrices, 'skuPricesUpdate');
    }
    return SkuPriceService;
}());
exports.SkuPriceService = SkuPriceService;


/***/ }),

/***/ "SDCo":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
exports.optiongroupmodule = void 0;
/// <reference path='../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../typings/tsd.d.ts' />
//modules
var core_module_1 = __webpack_require__("pwA0");
//controllers
//directives
var swaddoptiongroup_1 = __webpack_require__("KgMj");
var swoptionsforoptiongroup_1 = __webpack_require__("PieJ");
var optiongroupmodule = angular.module('optiongroup', [core_module_1.coremodule.name])
    .config([function () {
    }]).run([function () {
    }])
    //constants
    .constant('optionGroupPartialsPath', 'optiongroup/components/')
    //controllers
    //directives
    .directive('swAddOptionGroup', swaddoptiongroup_1.SWAddOptionGroup.Factory())
    .directive('swOptionsForOptionGroup', swoptionsforoptiongroup_1.SWOptionsForOptionGroup.Factory());
exports.optiongroupmodule = optiongroupmodule;


/***/ }),

/***/ "SaOQ":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
exports.SWSkuCurrencySelectorController = exports.SWSkuCurrencySelector = void 0;
/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
var SWSkuCurrencySelectorController = /** @class */ (function () {
    //@ngInject
    SWSkuCurrencySelectorController.$inject = ["collectionConfigService", "observerService", "$hibachi"];
    function SWSkuCurrencySelectorController(collectionConfigService, observerService, $hibachi) {
        var _this = this;
        this.collectionConfigService = collectionConfigService;
        this.observerService = observerService;
        this.$hibachi = $hibachi;
        this.currencyCodes = [];
        this.baseEntityName = "Product";
        this.select = function (currencyCode) {
            _this.selectedCurrencyCode = currencyCode;
            _this.observerService.notifyAndRecord(_this.selectCurrencyCodeEventName, currencyCode);
        };
        //this should be an rbkey
        this.currencyCodes.push("All");
        if (angular.isDefined(this.baseEntityId)) {
            this.selectCurrencyCodeEventName = "currencyCodeSelect" + this.baseEntityId;
        }
        this.selectedCurrencyCode = "USD";
        this.observerService.notifyAndRecord(this.selectCurrencyCodeEventName, this.selectedCurrencyCode);
        if (angular.isDefined(this.baseEntityName) && angular.isDefined(this.baseEntityId)) {
            this.baseEntityCollectionConfig = this.collectionConfigService.newCollectionConfig(this.baseEntityName);
            this.baseEntityCollectionConfig.addDisplayProperty("eligibleCurrencyCodeList");
            this.baseEntityCollectionConfig.addFilter("productID", this.baseEntityId, "=", 'AND', true);
            this.baseEntityCollectionConfig.getEntity().then(function (response) {
                _this.product = _this.$hibachi.populateEntity(_this.baseEntityName, response.pageRecords[0]);
                var tempCurrencyCodeArray = _this.product.data.eligibleCurrencyCodeList.split(",");
                for (var key in tempCurrencyCodeArray) {
                    _this.currencyCodes.push(tempCurrencyCodeArray[key]);
                }
            }, function (reason) {
                //error callback
            });
        }
    }
    return SWSkuCurrencySelectorController;
}());
exports.SWSkuCurrencySelectorController = SWSkuCurrencySelectorController;
var SWSkuCurrencySelector = /** @class */ (function () {
    function SWSkuCurrencySelector(scopeService, skuPartialsPath, slatwallPathBuilder) {
        this.scopeService = scopeService;
        this.restrict = 'EA';
        this.scope = {};
        this.bindToController = {
            baseEntityName: "@?",
            baseEntityId: "@?"
        };
        this.controller = SWSkuCurrencySelectorController;
        this.controllerAs = "swSkuCurrencySelector";
        this.link = function (scope, element, attrs, formController, transcludeFn) {
        };
        this.templateUrl = slatwallPathBuilder.buildPartialsPath(skuPartialsPath) + "skucurrencyselector.html";
    }
    SWSkuCurrencySelector.Factory = function () {
        var directive = function (scopeService, skuPartialsPath, slatwallPathBuilder) { return new SWSkuCurrencySelector(scopeService, skuPartialsPath, slatwallPathBuilder); };
        directive.$inject = [
            'scopeService',
            'skuPartialsPath',
            'slatwallPathBuilder'
        ];
        return directive;
    };
    return SWSkuCurrencySelector;
}());
exports.SWSkuCurrencySelector = SWSkuCurrencySelector;


/***/ }),

/***/ "TEp3":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
exports.SWDefaultSkuRadioController = exports.SWDefaultSkuRadio = void 0;
/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
var SWDefaultSkuRadioController = /** @class */ (function () {
    //@ngInject
    SWDefaultSkuRadioController.$inject = ["$hibachi", "defaultSkuService"];
    function SWDefaultSkuRadioController($hibachi, defaultSkuService) {
        this.$hibachi = $hibachi;
        this.defaultSkuService = defaultSkuService;
        if (angular.isDefined(this.listingDisplayId) && angular.isDefined(this.columnId)) {
            this.selectionId = this.listingDisplayId + this.columnId;
        }
        else if (angular.isDefined(this.listingDisplayId)) {
            this.selectionId = this.listingDisplayId;
        }
        else {
            throw ("You must provide the listingDisplayId to SWDefaultSkuRadioController");
        }
        if (angular.isUndefined(this.skuId) && angular.isUndefined(this.sku)) {
            throw ("You must provide a skuID to SWDefaultSkuRadioController");
        }
        this.isDefaultSku = (this.skuId == this.productDefaultSkuSkuId);
        if (this.isDefaultSku) {
            defaultSkuService.setDefaultSkuSelection(this.selectionId, this.skuId);
        }
        defaultSkuService.attachObserver(this.selectionId, this.productProductId);
        if (angular.isUndefined(this.selectionFieldName)) {
            this.selectionFieldName = this.selectionId + 'selection';
        }
        if (angular.isUndefined(this.sku)) {
            var skuData = {
                skuID: this.skuId
            };
            this.sku = this.$hibachi.populateEntity('Sku', skuData);
        }
    }
    return SWDefaultSkuRadioController;
}());
exports.SWDefaultSkuRadioController = SWDefaultSkuRadioController;
var SWDefaultSkuRadio = /** @class */ (function () {
    function SWDefaultSkuRadio(skuPartialsPath, slatwallPathBuilder) {
        this.restrict = 'EA';
        this.scope = {};
        this.bindToController = {
            skuId: "@",
            sku: "=?",
            productProductId: "@?",
            productDefaultSkuSkuId: "@?",
            productId: "@?",
            listingDisplayId: "@?",
            columnId: "@?"
        };
        this.controller = SWDefaultSkuRadioController;
        this.controllerAs = "swDefaultSkuRadio";
        this.compile = function (element, attrs) {
            return {
                pre: function ($scope, element, attrs) {
                },
                post: function ($scope, element, attrs) {
                }
            };
        };
        this.templateUrl = slatwallPathBuilder.buildPartialsPath(skuPartialsPath) + "defaultskuradio.html";
    }
    SWDefaultSkuRadio.Factory = function () {
        var directive = function (skuPartialsPath, slatwallPathBuilder) { return new SWDefaultSkuRadio(skuPartialsPath, slatwallPathBuilder); };
        directive.$inject = [
            'skuPartialsPath',
            'slatwallPathBuilder'
        ];
        return directive;
    };
    return SWDefaultSkuRadio;
}());
exports.SWDefaultSkuRadio = SWDefaultSkuRadio;


/***/ }),

/***/ "TkS2":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
exports.SWOrderTemplatePromotions = void 0;
/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
var SWOrderTemplatePromotionsController = /** @class */ (function () {
    function SWOrderTemplatePromotionsController($hibachi, collectionConfigService, observerService, orderTemplateService, rbkeyService) {
        var _this = this;
        this.$hibachi = $hibachi;
        this.collectionConfigService = collectionConfigService;
        this.observerService = observerService;
        this.orderTemplateService = orderTemplateService;
        this.rbkeyService = rbkeyService;
        this.edit = false;
        this.$onInit = function () {
            _this.promotionCodeCollection = _this.collectionConfigService.newCollectionConfig('PromotionCode');
            _this.promotionCodeCollection.addFilter('orderTemplates.orderTemplateID', _this.orderTemplate.orderTemplateID, '=', undefined, true);
        };
    }
    return SWOrderTemplatePromotionsController;
}());
var SWOrderTemplatePromotions = /** @class */ (function () {
    function SWOrderTemplatePromotions(orderPartialsPath, slatwallPathBuilder, $hibachi, rbkeyService) {
        this.orderPartialsPath = orderPartialsPath;
        this.slatwallPathBuilder = slatwallPathBuilder;
        this.$hibachi = $hibachi;
        this.rbkeyService = rbkeyService;
        this.restrict = "EA";
        this.scope = {};
        this.bindToController = {
            orderTemplate: '<?'
        };
        this.controller = SWOrderTemplatePromotionsController;
        this.controllerAs = "swOrderTemplatePromotions";
        this.link = function (scope, element, attrs) {
        };
        this.templateUrl = slatwallPathBuilder.buildPartialsPath(orderPartialsPath) + "/ordertemplatepromotions.html";
    }
    SWOrderTemplatePromotions.Factory = function () {
        var directive = function (orderPartialsPath, slatwallPathBuilder, $hibachi, rbkeyService) { return new SWOrderTemplatePromotions(orderPartialsPath, slatwallPathBuilder, $hibachi, rbkeyService); };
        directive.$inject = [
            'orderPartialsPath',
            'slatwallPathBuilder',
            '$hibachi',
            'rbkeyService'
        ];
        return directive;
    };
    return SWOrderTemplatePromotions;
}());
exports.SWOrderTemplatePromotions = SWOrderTemplatePromotions;


/***/ }),

/***/ "U0MA":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
Object.defineProperty(exports, "__esModule", { value: true });
exports.ProductBundleService = void 0;
var ProductBundleService = /** @class */ (function () {
    //@ngInject
    ProductBundleService.$inject = ["$log", "$hibachi", "utilityService"];
    function ProductBundleService($log, $hibachi, utilityService) {
        var _this = this;
        this.$log = $log;
        this.$hibachi = $hibachi;
        this.utilityService = utilityService;
        this.decorateProductBundleGroup = function (productBundleGroup) {
            productBundleGroup.data.$$editing = true;
            var prototype = {
                $$setMinimumQuantity: function (quantity) {
                    if (quantity < 0 || quantity === null) {
                        this.minimumQuantity = 0;
                    }
                    if (quantity > this.maximumQuantity) {
                        this.maximumQuantity = quantity;
                    }
                },
                $$setMaximumQuantity: function (quantity) {
                    if (quantity < 1 || quantity === null) {
                        this.maximumQuantity = 1;
                    }
                    if (this.maximumQuantity < this.minimumQuantity) {
                        this.minimumQuantity = this.maximumQuantity;
                    }
                },
                $$setActive: function (value) {
                    this.active = value;
                },
                $$toggleEdit: function () {
                    if (angular.isUndefined(this.$$editing) || this.$$editing === false) {
                        this.$$editing = true;
                    }
                    else {
                        this.$$editing = false;
                    }
                }
            };
            angular.extend(productBundleGroup.data, prototype);
        };
        this.formatProductBundleGroupFilters = function (productBundleGroupFilters, filterTerm) {
            _this.$log.debug('FORMATTING PRODUCT BUNDLE FILTERs');
            _this.$log.debug(productBundleGroupFilters);
            _this.$log.debug(filterTerm);
            if (filterTerm.value === 'sku') {
                for (var i in productBundleGroupFilters) {
                    productBundleGroupFilters[i].name = productBundleGroupFilters[i][filterTerm.value + 'Code'];
                    productBundleGroupFilters[i].type = filterTerm.name;
                    productBundleGroupFilters[i].entityType = filterTerm.value;
                    productBundleGroupFilters[i].propertyIdentifier = '_sku.skuID';
                }
            }
            else {
                for (var i in productBundleGroupFilters) {
                    productBundleGroupFilters[i].name = productBundleGroupFilters[i][filterTerm.value + 'Name'];
                    productBundleGroupFilters[i].type = filterTerm.name;
                    productBundleGroupFilters[i].entityType = filterTerm.value;
                    if (filterTerm.value === 'brand' || filterTerm.value === 'productType') {
                        productBundleGroupFilters[i].propertyIdentifier = '_sku.product.' + filterTerm.value + '.' + filterTerm.value + 'ID';
                    }
                    else {
                        productBundleGroupFilters[i].propertyIdentifier = '_sku.' + filterTerm.value + '.' + filterTerm.value + 'ID';
                    }
                }
            }
            _this.$log.debug(productBundleGroupFilters);
            return productBundleGroupFilters;
        };
        this.$log = $log;
        this.$hibachi = $hibachi;
        this.utilityService = utilityService;
    }
    return ProductBundleService;
}());
exports.ProductBundleService = ProductBundleService;


/***/ }),

/***/ "UX9i":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
exports.subscriptionusagemodule = void 0;
/// <reference path='../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../typings/tsd.d.ts' />
//modules
var core_module_1 = __webpack_require__("pwA0");
//services
//controllers
//filters
//directives
var swscheduleddeliveriescard_1 = __webpack_require__("A3VN");
var subscriptionusagemodule = angular.module('hibachi.subscriptionusage', [core_module_1.coremodule.name]).config(function () {
})
    .constant('subscriptionUsagePartialsPath', 'subscriptionusage/components/')
    //services
    //controllers
    //filters
    //directives
    .directive('swScheduledDeliveriesCard', swscheduleddeliveriescard_1.SWScheduledDeliveriesCard.Factory());
exports.subscriptionusagemodule = subscriptionusagemodule;


/***/ }),

/***/ "V3r6":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
exports.SWOrderTemplateAddGiftCardModal = void 0;
/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
var SWOrderTemplateAddGiftCardModalController = /** @class */ (function () {
    function SWOrderTemplateAddGiftCardModalController($hibachi, collectionConfigService, observerService, orderTemplateService, requestService, rbkeyService, $filter) {
        var _this = this;
        this.$hibachi = $hibachi;
        this.collectionConfigService = collectionConfigService;
        this.observerService = observerService;
        this.orderTemplateService = orderTemplateService;
        this.requestService = requestService;
        this.rbkeyService = rbkeyService;
        this.$filter = $filter;
        this.processContext = 'applyGiftCard';
        this.title = 'Apply Gift Card';
        this.modalButtonText = 'Apply Gift Card';
        this.amountToApply = 0;
        this.maxAmount = 0;
        this.$onInit = function () {
            if (_this.orderTemplate != null) {
                _this.baseEntityPrimaryID = _this.orderTemplate.orderTemplateID;
                _this.baseEntityName = 'OrderTemplate';
            }
            if (_this.swOrderTemplateGiftCards != null && _this.swOrderTemplateGiftCards.customerGiftCards != null) {
                _this.customerGiftCards = _this.swOrderTemplateGiftCards.customerGiftCards;
                _this.giftCard = _this.customerGiftCards[0];
            }
        };
        this.prefillGiftCardAmount = function () {
            if (_this.orderTemplate.total < _this.giftCard.calculatedBalanceAmount) {
                _this.amountToApply = _this.orderTemplate.total;
            }
            else {
                _this.amountToApply = _this.giftCard.calculatedBalanceAmount;
            }
            _this.maxAmount = Number(_this.amountToApply);
            _this.amountToApply = Number(_this.amountToApply);
        };
        this.save = function () {
            var formDataToPost = {
                entityID: _this.baseEntityPrimaryID,
                entityName: _this.baseEntityName,
                context: _this.processContext,
                propertyIdentifiersList: ''
            };
            formDataToPost.giftCardID = _this.giftCard.value;
            formDataToPost.amountToApply = _this.amountToApply;
            var processUrl = _this.$hibachi.buildUrl('api:main.post');
            var adminRequest = _this.requestService.newAdminRequest(processUrl, formDataToPost);
            return adminRequest.promise;
        };
        this.currencyFilter = this.$filter('swcurrency');
        this.observerService.attach(this.$onInit, 'OrderTemplateApplyGiftCardSuccess');
    }
    return SWOrderTemplateAddGiftCardModalController;
}());
var SWOrderTemplateAddGiftCardModal = /** @class */ (function () {
    function SWOrderTemplateAddGiftCardModal(orderPartialsPath, slatwallPathBuilder, $hibachi, rbkeyService) {
        this.orderPartialsPath = orderPartialsPath;
        this.slatwallPathBuilder = slatwallPathBuilder;
        this.$hibachi = $hibachi;
        this.rbkeyService = rbkeyService;
        this.restrict = "EA";
        this.scope = {};
        this.bindToController = {
            orderTemplate: '<?'
        };
        this.require = {
            swOrderTemplateGiftCards: "^^swOrderTemplateGiftCards"
        };
        this.controller = SWOrderTemplateAddGiftCardModalController;
        this.controllerAs = "swOrderTemplateAddGiftCard";
        this.link = function (scope, element, attrs) {
        };
        this.templateUrl = slatwallPathBuilder.buildPartialsPath(orderPartialsPath) + "/ordertemplateaddgiftcardmodal.html";
    }
    SWOrderTemplateAddGiftCardModal.Factory = function () {
        var directive = function (orderPartialsPath, slatwallPathBuilder, $hibachi, rbkeyService) { return new SWOrderTemplateAddGiftCardModal(orderPartialsPath, slatwallPathBuilder, $hibachi, rbkeyService); };
        directive.$inject = [
            'orderPartialsPath',
            'slatwallPathBuilder',
            '$hibachi',
            'rbkeyService'
        ];
        return directive;
    };
    return SWOrderTemplateAddGiftCardModal;
}());
exports.SWOrderTemplateAddGiftCardModal = SWOrderTemplateAddGiftCardModal;


/***/ }),

/***/ "WM9m":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
exports.SWContentEditor = void 0;
/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
var SWContentEditor = /** @class */ (function () {
    function SWContentEditor($log, $location, $http, $hibachi, formService, contentPartialsPath, slatwallPathBuilder) {
        return {
            restrict: 'EA',
            scope: {
                content: "="
            },
            templateUrl: slatwallPathBuilder.buildPartialsPath(contentPartialsPath) + "contenteditor.html",
            link: function (scope, element, attrs) {
                scope.editorOptions = CKEDITOR.editorConfig;
                scope.onContentChange = function () {
                    var form = formService.getForm('contentEditor');
                    form.contentBody.$setDirty();
                };
                //                scope.saveContent = function(){
                //                   var urlString = _config.baseURL+'/index.cfm/?slatAction=api:main.post';
                //                   var params = {
                //                        entityID:scope.content.contentID,
                //                        templateHTML:scope.content.templateHTML,
                //                        context:'saveTemplateHTML',
                //                        entityName:'content'
                //                   }
                //                   $http.post(urlString,
                //                        {
                //                            params:params
                //                        }
                //                    )
                //                    .success(function(data){
                //                    }).error(function(reason){
                //                    });
                //                }
            }
        };
    }
    SWContentEditor.Factory = function () {
        var directive = function ($log, $location, $http, $hibachi, formService, contentPartialsPath, slatwallPathBuilder) { return new SWContentEditor($log, $location, $http, $hibachi, formService, contentPartialsPath, slatwallPathBuilder); };
        directive.$inject = [
            '$log',
            '$location',
            '$http',
            '$hibachi',
            'formService',
            'contentPartialsPath',
            'slatwallPathBuilder'
        ];
        return directive;
    };
    return SWContentEditor;
}());
exports.SWContentEditor = SWContentEditor;


/***/ }),

/***/ "XMpE":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
exports.GiftRecipient = void 0;
/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
var GiftRecipient = /** @class */ (function () {
    function GiftRecipient(firstName, lastName, emailAddress, giftMessage, quantity, account, editing) {
        var _this = this;
        this.reset = function () {
            _this.firstName = null;
            _this.lastName = null;
            _this.emailAddress = null;
            _this.account = null;
            _this.editing = false;
            _this.quantity = 1;
        };
        this.quantity = 1;
        this.editing = false;
        this.account = false;
    }
    return GiftRecipient;
}());
exports.GiftRecipient = GiftRecipient;


/***/ }),

/***/ "Y5Z6":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
exports.SWOrderItemDetailStamp = void 0;
/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
/**
 * Displays a shipping label in the order items row.
 * @module slatwalladmin
 * @class swOrderItemsShippingLabelStamp
 */
var SWOrderItemDetailStamp = /** @class */ (function () {
    function SWOrderItemDetailStamp($log, $hibachi, collectionConfigService, orderItemPartialsPath, slatwallPathBuilder) {
        return {
            restrict: 'A',
            scope: {
                systemCode: "=",
                orderItemId: "=",
                skuId: "=",
                orderItem: "="
            },
            templateUrl: slatwallPathBuilder.buildPartialsPath(orderItemPartialsPath) + "orderitem-detaillabel.html",
            link: function (scope, element, attrs) {
                scope.details = [];
                scope.orderItem.detailsName = [];
                var results;
                $log.debug("Detail stamp");
                $log.debug(scope.systemCode);
                $log.debug(scope.orderItemId);
                $log.debug(scope.skuId);
                $log.debug(scope.orderItem);
                /**
                 * For each type of orderItem, get the appropriate detail information.
                 *
                 * Merchandise: Option Group Name and Option
                 * Event: Event Date, Event Location
                 * Subscription: Subscription Term, Subscription Benefits
                 */
                var getMerchandiseDetails = function (orderItem) {
                    //Get option and option groups
                    for (var i = 0; i <= orderItem.data.sku.data.options.length - 1; i++) {
                        var optionGroupCollectionConfig = collectionConfigService.newCollectionConfig("Option");
                        optionGroupCollectionConfig.addDisplayProperty("optionID,optionName, optionGroup.optionGroupName");
                        optionGroupCollectionConfig.addFilter("optionID", orderItem.data.sku.data.options[i].optionID, "=");
                        optionGroupCollectionConfig.getEntity().then(function (results) {
                            if (angular.isDefined(results.pageRecords[0])) {
                                orderItem.detailsName.push(results.pageRecords[0].optionGroup_optionGroupName);
                                orderItem.details.push(results.pageRecords[0].optionName);
                            }
                        }, function (reason) {
                            throw ("SWOrderItemDetailStamp had trouble retrieving the option group for option");
                        });
                    }
                };
                var getSubscriptionDetails = function (orderItem) {
                    //get Subscription Term and Subscription Benefits
                    var name = orderItem.data.sku.data.subscriptionTerm.data.subscriptionTermName || "";
                    orderItem.detailsName.push("Subscription Term:");
                    orderItem.details.push(name);
                    //Maybe multiple benefits so show them all.
                    for (var i = 0; i <= orderItem.data.sku.data.subscriptionBenefits.length - 1; i++) {
                        var benefitName = orderItem.data.sku.data.subscriptionBenefits[i].subscriptionBenefitName || "";
                        orderItem.detailsName.push("Subscription Benefit:");
                        orderItem.details.push(benefitName);
                    }
                };
                var getEventDetails = function (orderItem) {
                    //get event date, and event location
                    orderItem.detailsName.push("Event Date: ");
                    orderItem.details.push(orderItem.data.sku.data.eventStartDateTime);
                    //Need to iterate this.
                    for (var i = 0; i <= orderItem.data.sku.data.locations.length - 1; i++) {
                        orderItem.detailsName.push("Location: ");
                        orderItem.details.push(orderItem.data.sku.data.locations[i].locationName);
                    }
                };
                if (angular.isUndefined(scope.orderItem.details)) {
                    scope.orderItem.details = [];
                }
                if (angular.isDefined(scope.orderItem.details)) {
                    switch (scope.systemCode) {
                        case "merchandise":
                            getMerchandiseDetails(scope.orderItem);
                            break;
                        case "subscription":
                            getSubscriptionDetails(scope.orderItem);
                            break;
                        case "event":
                            getEventDetails(scope.orderItem);
                            break;
                    }
                }
            }
        };
    }
    SWOrderItemDetailStamp.Factory = function () {
        var directive = function ($log, $hibachi, collectionConfigService, orderItemPartialsPath, slatwallPathBuilder) { return new SWOrderItemDetailStamp($log, $hibachi, collectionConfigService, orderItemPartialsPath, slatwallPathBuilder); };
        directive.$inject = [
            '$log',
            '$hibachi',
            'collectionConfigService',
            'orderItemPartialsPath',
            'slatwallPathBuilder'
        ];
        return directive;
    };
    return SWOrderItemDetailStamp;
}());
exports.SWOrderItemDetailStamp = SWOrderItemDetailStamp;


/***/ }),

/***/ "ZLvg":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
Object.defineProperty(exports, "__esModule", { value: true });
exports.SWContentNode = void 0;
var SWContentNode = /** @class */ (function () {
    function SWContentNode($log, $compile, $hibachi, contentPartialsPath, slatwallPathBuilder) {
        return {
            restrict: 'A',
            scope: {
                contentData: '=',
                loadChildren: "="
            },
            templateUrl: slatwallPathBuilder.buildPartialsPath(contentPartialsPath) + 'contentnode.html',
            link: function (scope, element, attr) {
                if (angular.isUndefined(scope.depth)) {
                    scope.depth = 0;
                }
                if (angular.isDefined(scope.$parent.depth)) {
                    scope.depth = scope.$parent.depth + 1;
                }
                var childContentColumnsConfig = [{
                        propertyIdentifier: '_content.contentID',
                        isVisible: false,
                        isSearchable: false
                    },
                    {
                        propertyIdentifier: '_content.title',
                        isVisible: true,
                        isSearchable: true
                    },
                    {
                        propertyIdentifier: '_content.urlTitlePath',
                        isVisible: true,
                        isSearchable: true
                    },
                    {
                        propertyIdentifier: '_content.site.siteID',
                        isVisible: false,
                        isSearchable: false
                    },
                    {
                        propertyIdentifier: '_content.site.siteName',
                        isVisible: true,
                        isSearchable: true
                    },
                    {
                        propertyIdentifier: '_content.site.domainNames',
                        isVisible: true,
                        isSearchable: true
                    },
                    //                            {
                    //                                propertyIdentifier: '_content.contentTemplateFile',
                    //                                persistent: false,
                    //                                setting: true,
                    //                                isVisible: true
                    //                            },
                    //need to get template via settings
                    {
                        propertyIdentifier: '_content.allowPurchaseFlag',
                        isVisible: true,
                        isSearchable: true
                    }, {
                        propertyIdentifier: '_content.productListingPageFlag',
                        isVisible: true,
                        isSearchable: true
                    }, {
                        propertyIdentifier: '_content.activeFlag',
                        isVisible: true,
                        isSearchable: true
                    }
                ];
                var childContentOrderBy = [
                    {
                        "propertyIdentifier": "_content.sortOrder",
                        "direction": "DESC"
                    }
                ];
                scope.toggleChildContent = function (parentContentRecord) {
                    if (angular.isUndefined(scope.childOpen) || scope.childOpen === false) {
                        scope.childOpen = true;
                        if (!scope.childrenLoaded) {
                            scope.getChildContent(parentContentRecord);
                        }
                    }
                    else {
                        scope.childOpen = false;
                    }
                };
                scope.getChildContent = function (parentContentRecord) {
                    var childContentfilterGroupsConfig = [{
                            "filterGroup": [{
                                    "propertyIdentifier": "_content.parentContent.contentID",
                                    "comparisonOperator": "=",
                                    "value": parentContentRecord.contentID
                                }]
                        }];
                    var collectionListingPromise = $hibachi.getEntity('Content', {
                        columnsConfig: angular.toJson(childContentColumnsConfig),
                        filterGroupsConfig: angular.toJson(childContentfilterGroupsConfig),
                        orderByConfig: angular.toJson(childContentOrderBy),
                        allRecords: true
                    });
                    collectionListingPromise.then(function (value) {
                        parentContentRecord.children = value.records;
                        var index = 0;
                        angular.forEach(parentContentRecord.children, function (child) {
                            child.site_domainNames = child.site_domainNames.split(",")[0];
                            scope['child' + index] = child;
                            element.after($compile('<tr class="childNode" style="margin-left:{{depth*15||0}}px" ng-if="childOpen"  sw-content-node data-content-data="child' + index + '"></tr>')(scope));
                            index++;
                        });
                        scope.childrenLoaded = true;
                    });
                };
                scope.childrenLoaded = false;
                //if the children have never been loaded and we are not in search mode based on the title received
                if (angular.isDefined(scope.loadChildren) && scope.loadChildren === true && !(scope.contentData.titlePath && scope.contentData.titlePath.trim().length)) {
                    scope.toggleChildContent(scope.contentData);
                }
            }
        };
    }
    SWContentNode.Factory = function () {
        var directive = function ($log, $compile, $hibachi, contentPartialsPath, slatwallPathBuilder) { return new SWContentNode($log, $compile, $hibachi, contentPartialsPath, slatwallPathBuilder); };
        directive.$inject = [
            '$log',
            '$compile',
            '$hibachi',
            'contentPartialsPath',
            'slatwallPathBuilder'
        ];
        return directive;
    };
    return SWContentNode;
}());
exports.SWContentNode = SWContentNode;


/***/ }),

/***/ "aPIn":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
exports.orderitemmodule = void 0;
/// <reference path="../../typings/tsd.d.ts" />
/// <reference path="../../typings/slatwallTypescript.d.ts" />
var core_module_1 = __webpack_require__("pwA0");
//directives
var swchildorderitem_1 = __webpack_require__("6B9d");
var sworderitem_1 = __webpack_require__("50Jh");
var swoishippinglabelstamp_1 = __webpack_require__("laNr");
var sworderitemdetailstamp_1 = __webpack_require__("Y5Z6");
var sworderitems_1 = __webpack_require__("IYLP");
var swresizedimage_1 = __webpack_require__("0BnN");
var orderitemmodule = angular.module('hibachi.orderitem', [core_module_1.coremodule.name])
    // .config(['$provide','baseURL',($provide,baseURL)=>{
    // 	$provide.constant('paginationPartials', baseURL+basePartialsPath+'pagination/components/');
    // }])
    .run([function () {
    }])
    //directives
    .directive('swChildOrderItem', swchildorderitem_1.SWChildOrderItem.Factory())
    .directive('swOrderItem', sworderitem_1.SWOrderItem.Factory())
    .directive('swoishippinglabelstamp', swoishippinglabelstamp_1.SWOiShippingLabelStamp.Factory())
    .directive('swOrderItemDetailStamp', sworderitemdetailstamp_1.SWOrderItemDetailStamp.Factory())
    .directive('swOrderItems', sworderitems_1.SWOrderItems.Factory())
    .directive('swresizedimage', swresizedimage_1.SWResizedImage.Factory())
    //constants
    .constant('orderItemPartialsPath', 'orderitem/components/');
exports.orderitemmodule = orderitemmodule;


/***/ }),

/***/ "aVY8":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
exports.contentmodule = void 0;
/// <reference path='../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../typings/tsd.d.ts' />
//modules
var core_module_1 = __webpack_require__("pwA0");
//services
//filters
//directives
var swcontentbasic_1 = __webpack_require__("6Aox");
var swcontenteditor_1 = __webpack_require__("WM9m");
var swcontentlist_1 = __webpack_require__("icpf");
var swcontentnode_1 = __webpack_require__("ZLvg");
var swassignedproducts_1 = __webpack_require__("DhYn");
var swsiteselector_1 = __webpack_require__("KJW6");
var contentmodule = angular.module('hibachi.content', [core_module_1.coremodule.name]).config(function () {
})
    .constant('contentPartialsPath', 'content/components/')
    //services
    //filters
    //directives
    .directive('swContentBasic', swcontentbasic_1.SWContentBasic.Factory())
    .directive('swContentEditor', swcontenteditor_1.SWContentEditor.Factory())
    .directive('swContentList', swcontentlist_1.SWContentList.Factory())
    .directive('swContentNode', swcontentnode_1.SWContentNode.Factory())
    .directive('swAssignedProducts', swassignedproducts_1.SWAssignedProducts.Factory())
    .directive('swSiteSelector', swsiteselector_1.SWSiteSelector.Factory());
exports.contentmodule = contentmodule;


/***/ }),

/***/ "auR5":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
exports.SWOrderTemplatePromotionItems = void 0;
/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
var SWOrderTemplatePromotionItemsController = /** @class */ (function () {
    function SWOrderTemplatePromotionItemsController($hibachi, collectionConfigService, observerService, orderTemplateService, rbkeyService) {
        var _this = this;
        this.$hibachi = $hibachi;
        this.collectionConfigService = collectionConfigService;
        this.observerService = observerService;
        this.orderTemplateService = orderTemplateService;
        this.rbkeyService = rbkeyService;
        this.edit = false;
        this.defaultColumnConfig = {
            isVisible: true,
            isSearchable: false,
            isDeletable: true,
            isEditable: false
        };
        this.editColumnConfig = {
            isVisible: true,
            isSearchable: false,
            isDeletable: true,
            isEditable: true
        };
        this.searchableColumnConfig = {
            isVisible: true,
            isSearchable: false,
            isDeletable: true,
            isEditable: false
        };
        this.nonVisibleColumnConfig = {
            isVisible: false,
            isSearchable: false,
            isDeletable: false,
            isEditable: false
        };
        this.priceColumnConfig = {
            isVisible: true,
            isSearchable: false,
            isDeletable: false,
            isEditable: false
        };
        this.$onInit = function () {
            if (_this.showPrice == null) {
                _this.showPrice = true;
            }
            _this.addSkuCollection = _this.collectionConfigService.newCollectionConfig('Sku');
            _this.skuCollectionConfig['columns'] = []; //don't care about columns just filters
            _this.addSkuCollection.loadJson(_this.skuCollectionConfig);
            _this.addSkuCollection = _this.orderTemplateService.getAddSkuCollection(_this.addSkuCollection, _this.showPrice);
            _this.skuColumns = angular.copy(_this.addSkuCollection.getCollectionConfig().columns);
            _this.skuColumns.push({
                'title': _this.rbkeyService.rbKey('define.quantity'),
                'propertyIdentifier': 'quantity',
                'type': 'number',
                'defaultValue': 1,
                'isCollectionColumn': false,
                'isEditable': true,
                'isVisible': true
            });
        };
    }
    return SWOrderTemplatePromotionItemsController;
}());
var SWOrderTemplatePromotionItems = /** @class */ (function () {
    function SWOrderTemplatePromotionItems(orderPartialsPath, slatwallPathBuilder, $hibachi, rbkeyService) {
        this.orderPartialsPath = orderPartialsPath;
        this.slatwallPathBuilder = slatwallPathBuilder;
        this.$hibachi = $hibachi;
        this.rbkeyService = rbkeyService;
        this.restrict = "EA";
        this.scope = {};
        this.bindToController = {
            orderTemplate: '<?',
            skuCollectionConfig: '<?',
            skuPropertiesToDisplay: '@?',
            skuPropertyColumnConfigs: '<?',
            edit: "=?",
            showPrice: "=?"
        };
        this.controller = SWOrderTemplatePromotionItemsController;
        this.controllerAs = "swOrderTemplatePromotionItems";
        this.link = function (scope, element, attrs) {
        };
        this.templateUrl = slatwallPathBuilder.buildPartialsPath(orderPartialsPath) + "/ordertemplatepromotionitems.html";
    }
    SWOrderTemplatePromotionItems.Factory = function () {
        var directive = function (orderPartialsPath, slatwallPathBuilder, $hibachi, rbkeyService) { return new SWOrderTemplatePromotionItems(orderPartialsPath, slatwallPathBuilder, $hibachi, rbkeyService); };
        directive.$inject = [
            'orderPartialsPath',
            'slatwallPathBuilder',
            '$hibachi',
            'rbkeyService'
        ];
        return directive;
    };
    return SWOrderTemplatePromotionItems;
}());
exports.SWOrderTemplatePromotionItems = SWOrderTemplatePromotionItems;


/***/ }),

/***/ "d6tF":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
exports.SWGiftCardDetail = exports.SWGiftCardDetailController = void 0;
/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
var SWGiftCardDetailController = /** @class */ (function () {
    function SWGiftCardDetailController(collectionConfigService) {
        var _this = this;
        this.collectionConfigService = collectionConfigService;
        this.init = function () {
            var giftCardConfig = _this.collectionConfigService.newCollectionConfig('GiftCard');
            giftCardConfig.setDisplayProperties("giftCardID, giftCardCode, currencyCode, giftCardPin, expirationDate, ownerFirstName, ownerLastName, ownerEmailAddress, activeFlag, calculatedBalanceAmount,  originalOrderItem.sku.product.productName, originalOrderItem.sku.product.productID, originalOrderItem.order.orderID,order.orderID, originalOrderItem.orderItemID, orderItemGiftRecipient.firstName, orderItemGiftRecipient.lastName, orderItemGiftRecipient.emailAddress, orderItemGiftRecipient.giftMessage, ownerAccount.accountID, ownerAccount.firstName, ownerAccount.lastName");
            giftCardConfig.addFilter('giftCardID', _this.giftCardId);
            giftCardConfig.setAllRecords(true);
            giftCardConfig.getEntity().then(function (response) {
                _this.giftCard = response.records[0];
            });
        };
        this.init();
    }
    SWGiftCardDetailController.$inject = ["collectionConfigService"];
    return SWGiftCardDetailController;
}());
exports.SWGiftCardDetailController = SWGiftCardDetailController;
var SWGiftCardDetail = /** @class */ (function () {
    function SWGiftCardDetail(collectionConfigService, giftCardPartialsPath, slatwallPathBuilder) {
        this.collectionConfigService = collectionConfigService;
        this.giftCardPartialsPath = giftCardPartialsPath;
        this.slatwallPathBuilder = slatwallPathBuilder;
        this.scope = {};
        this.bindToController = {
            giftCardId: "@",
            giftCard: "=?"
        };
        this.controller = SWGiftCardDetailController;
        this.controllerAs = "swGiftCardDetail";
        this.link = function (scope, element, attrs) {
        };
        this.templateUrl = slatwallPathBuilder.buildPartialsPath(giftCardPartialsPath) + "/basic.html";
        this.restrict = "E";
    }
    SWGiftCardDetail.Factory = function () {
        var directive = function (collectionConfigService, giftCardPartialsPath, slatwallPathBuilder) { return new SWGiftCardDetail(collectionConfigService, giftCardPartialsPath, slatwallPathBuilder); };
        directive.$inject = [
            'collectionConfigService',
            'giftCardPartialsPath',
            'slatwallPathBuilder'
        ];
        return directive;
    };
    return SWGiftCardDetail;
}());
exports.SWGiftCardDetail = SWGiftCardDetail;


/***/ }),

/***/ "gQgA":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
Object.defineProperty(exports, "__esModule", { value: true });
exports.SWRelatedProducts = exports.SWRelatedProductsController = void 0;
var SWRelatedProductsController = /** @class */ (function () {
    //@ngInject
    SWRelatedProductsController.$inject = ["collectionConfigService", "utilityService"];
    function SWRelatedProductsController(collectionConfigService, utilityService) {
        this.collectionConfigService = collectionConfigService;
        this.utilityService = utilityService;
        this.collectionConfig = collectionConfigService.newCollectionConfig("Product");
        this.collectionConfig.addDisplayProperty("productID,productName,productCode,calculatedSalePrice,activeFlag,publishedFlag,productType.productTypeNamePath,productType.productTypeName,defaultSku.price");
        this.alreadySelectedProductsCollectionConfig = collectionConfigService.newCollectionConfig("ProductRelationship");
        this.alreadySelectedProductsCollectionConfig.addDisplayProperty("productRelationshipID,sortOrder,relatedProduct.productID,relatedProduct.productName,relatedProduct.productCode,relatedProduct.calculatedSalePrice,relatedProduct.activeFlag,relatedProduct.publishedFlag");
        this.alreadySelectedProductsCollectionConfig.addFilter("product.productID", this.productId, "=");
        this.typeaheadDataKey = utilityService.createID(32);
    }
    return SWRelatedProductsController;
}());
exports.SWRelatedProductsController = SWRelatedProductsController;
var SWRelatedProducts = /** @class */ (function () {
    //@ngInject
    SWRelatedProducts.$inject = ["$http", "$hibachi", "paginationService", "productPartialsPath", "slatwallPathBuilder"];
    function SWRelatedProducts($http, $hibachi, paginationService, productPartialsPath, slatwallPathBuilder) {
        this.$http = $http;
        this.$hibachi = $hibachi;
        this.paginationService = paginationService;
        this.productPartialsPath = productPartialsPath;
        this.slatwallPathBuilder = slatwallPathBuilder;
        this.restrict = "EA";
        this.scope = {};
        this.bindToController = {
            productId: "@?",
            edit: "=?",
            productSortProperty: "@?",
            productSortDefaultDirection: "@?",
            selectedRelatedProductIds: "@?"
        };
        this.controller = SWRelatedProductsController;
        this.controllerAs = "swRelatedProducts";
        this.link = function ($scope, element, attrs) {
        };
        this.templateUrl = slatwallPathBuilder.buildPartialsPath(productPartialsPath) + "/relatedproducts.html";
    }
    SWRelatedProducts.Factory = function () {
        var directive = function ($http, $hibachi, paginationService, productPartialsPath, slatwallPathBuilder) { return new SWRelatedProducts($http, $hibachi, paginationService, productPartialsPath, slatwallPathBuilder); };
        directive.$inject = [
            '$http',
            '$hibachi',
            'paginationService',
            'productPartialsPath',
            'slatwallPathBuilder'
        ];
        return directive;
    };
    return SWRelatedProducts;
}());
exports.SWRelatedProducts = SWRelatedProducts;


/***/ }),

/***/ "gTsk":
/***/ (function(module, exports, __webpack_require__) {

var map = {
	"./en-SG": "LF2p",
	"./en-SG.js": "LF2p",
	"./en-au": "4ztU",
	"./en-au.js": "4ztU",
	"./en-ca": "Vj0R",
	"./en-ca.js": "Vj0R",
	"./en-gb": "blmW",
	"./en-gb.js": "blmW",
	"./en-ie": "oC32",
	"./en-ie.js": "oC32",
	"./en-il": "LdJM",
	"./en-il.js": "LdJM",
	"./en-nz": "LhZT",
	"./en-nz.js": "LhZT"
};


function webpackContext(req) {
	var id = webpackContextResolve(req);
	return __webpack_require__(id);
}
function webpackContextResolve(req) {
	if(!__webpack_require__.o(map, req)) {
		var e = new Error("Cannot find module '" + req + "'");
		e.code = 'MODULE_NOT_FOUND';
		throw e;
	}
	return map[req];
}
webpackContext.keys = function webpackContextKeys() {
	return Object.keys(map);
};
webpackContext.resolve = webpackContextResolve;
module.exports = webpackContext;
webpackContext.id = "gTsk";

/***/ }),

/***/ "hAMq":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
exports.SWSkuCodeEditController = exports.SWSkuCodeEdit = void 0;
/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
var SWSkuCodeEditController = /** @class */ (function () {
    //@ngInject
    SWSkuCodeEditController.$inject = ["historyService", "listingService", "observerService", "skuPriceService", "utilityService", "$hibachi", "$filter", "$timeout"];
    function SWSkuCodeEditController(historyService, listingService, observerService, skuPriceService, utilityService, $hibachi, $filter, $timeout) {
        this.historyService = historyService;
        this.listingService = listingService;
        this.observerService = observerService;
        this.skuPriceService = skuPriceService;
        this.utilityService = utilityService;
        this.$hibachi = $hibachi;
        this.$filter = $filter;
        this.$timeout = $timeout;
        this.showSave = true;
        this.baseEntityName = "Product";
        if (angular.isDefined(this.pageRecord)) {
            this.pageRecord.edited = false;
        }
        this.formName = this.utilityService.createID(32);
        if (angular.isUndefined(this.skuId) && angular.isDefined(this.bundledSkuSkuId)) {
            this.skuId = this.bundledSkuSkuId;
        }
        if (angular.isUndefined(this.price) && angular.isDefined(this.bundledSkuPrice)) {
            this.price = this.bundledSkuPrice;
        }
        if (angular.isDefined(this.sku)) {
            this.sku.data.price = this.currencyFilter(this.sku.data.price, this.currencyCode, 2, false);
        }
        if (angular.isDefined(this.skuPrice)) {
            this.skuPrice.data.price = this.currencyFilter(this.skuPrice.data.price, this.currencyCode, 2, false);
        }
        if (angular.isDefined(this.bundledSkuSkuCode)) {
            this.skuCode = this.bundledSkuSkuCode;
        }
        if (angular.isDefined(this.skuId) && angular.isUndefined(this.sku)) {
            var skuData = {
                skuID: this.skuId,
                skuCode: this.skuCode
            };
            this.sku = this.$hibachi.populateEntity("Sku", skuData);
        }
    }
    return SWSkuCodeEditController;
}());
exports.SWSkuCodeEditController = SWSkuCodeEditController;
var SWSkuCodeEdit = /** @class */ (function () {
    function SWSkuCodeEdit(observerService, historyService, scopeService, skuPartialsPath, slatwallPathBuilder) {
        var _this = this;
        this.observerService = observerService;
        this.historyService = historyService;
        this.scopeService = scopeService;
        this.restrict = 'EA';
        this.scope = {};
        this.bindToController = {
            skuId: "@?",
            skuPriceId: "@?",
            skuCode: "@?",
            price: "@?",
            baseEntityId: "@?",
            baseEntityName: "@?",
            bundledSkuSkuId: "@?",
            bundledSkuSkuCode: "@?",
            bundledSkuCurrencyCode: "@?",
            bundledSkuPrice: "@?",
            eligibleCurrencyCodeList: "@?",
            listingDisplayId: "@?",
            currencyCode: "@?",
            masterPriceObject: "=?",
            revertToValue: "=?",
            sku: "=?",
            skuPrice: "=?"
        };
        this.controller = SWSkuCodeEditController;
        this.controllerAs = "swSkuCodeEdit";
        this.link = function (scope, element, attrs, formController, transcludeFn) {
            var currentScope = _this.scopeService.getRootParentScope(scope, "pageRecord");
            if (angular.isDefined(currentScope["pageRecord"])) {
                scope.swSkuCodeEdit.pageRecord = currentScope["pageRecord"];
            }
            var currentScope = _this.scopeService.getRootParentScope(scope, "pageRecordKey");
            if (angular.isDefined(currentScope["pageRecordKey"])) {
                scope.swSkuCodeEdit.pageRecordIndex = currentScope["pageRecordKey"];
            }
        };
        this.templateUrl = slatwallPathBuilder.buildPartialsPath(skuPartialsPath) + "skucodeedit.html";
    }
    SWSkuCodeEdit.Factory = function () {
        var directive = function (observerService, historyService, scopeService, skuPartialsPath, slatwallPathBuilder) { return new SWSkuCodeEdit(observerService, historyService, scopeService, skuPartialsPath, slatwallPathBuilder); };
        directive.$inject = [
            'observerService',
            'historyService',
            'scopeService',
            'skuPartialsPath',
            'slatwallPathBuilder'
        ];
        return directive;
    };
    return SWSkuCodeEdit;
}());
exports.SWSkuCodeEdit = SWSkuCodeEdit;


/***/ }),

/***/ "hCO+":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
exports.SWSkuThumbnailController = exports.SWSkuThumbnail = void 0;
/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
var SWSkuThumbnailController = /** @class */ (function () {
    //@ngInject
    SWSkuThumbnailController.$inject = ["fileService", "$hibachi", "$http", "appConfig"];
    function SWSkuThumbnailController(fileService, $hibachi, $http, appConfig) {
        var _this = this;
        this.fileService = fileService;
        this.$hibachi = $hibachi;
        this.$http = $http;
        this.appConfig = appConfig;
        if (!angular.isDefined(this.skuData)) {
            throw ("You must provide a sku to the SWSkuThumbnailController");
        }
        fileService.imageExists(this.skuData.imagePath).then(function () {
            //Do nothing
        }, function () {
            _this.skuData.imagePath = _this.appConfig.baseURL + 'assets/images/image-placeholder.jpg';
        }).finally(function () {
            if (angular.isDefined(_this.skuData.imagePath)) {
                _this.image = _this.appConfig.baseURL + _this.skuData.imagePath;
            }
        });
    }
    return SWSkuThumbnailController;
}());
exports.SWSkuThumbnailController = SWSkuThumbnailController;
var SWSkuThumbnail = /** @class */ (function () {
    function SWSkuThumbnail(skuPartialsPath, slatwallPathBuilder) {
        this.restrict = 'EA';
        this.scope = {};
        this.bindToController = {
            skuData: "=",
            imageOnly: "=?",
            imagePath: "@?"
        };
        this.controller = SWSkuThumbnailController;
        this.controllerAs = "swSkuThumbnail";
        this.templateUrl = slatwallPathBuilder.buildPartialsPath(skuPartialsPath) + "skuthumbnail.html";
    }
    SWSkuThumbnail.Factory = function () {
        var directive = function (skuPartialsPath, slatwallPathBuilder) { return new SWSkuThumbnail(skuPartialsPath, slatwallPathBuilder); };
        directive.$inject = [
            'skuPartialsPath',
            'slatwallPathBuilder'
        ];
        return directive;
    };
    return SWSkuThumbnail;
}());
exports.SWSkuThumbnail = SWSkuThumbnail;


/***/ }),

/***/ "hOsJ":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
Object.defineProperty(exports, "__esModule", { value: true });
exports.SWProductBundleGroupType = void 0;
var SWProductBundleGroupType = /** @class */ (function () {
    //@ngInject
    SWProductBundleGroupType.$inject = ["$http", "$log", "$hibachi", "formService", "collectionConfigService", "productBundlePartialsPath", "slatwallPathBuilder"];
    function SWProductBundleGroupType($http, $log, $hibachi, formService, collectionConfigService, productBundlePartialsPath, slatwallPathBuilder) {
        return {
            restrict: 'A',
            templateUrl: slatwallPathBuilder.buildPartialsPath(productBundlePartialsPath) + "productbundlegrouptype.html",
            scope: {
                productBundleGroup: "="
            },
            controller: ['$scope', '$element', '$attrs', function ($scope, $element, $attrs) {
                    $log.debug('productBundleGrouptype');
                    $log.debug($scope.productBundleGroup);
                    $scope.productBundleGroupTypes = {};
                    $scope.$$id = "productBundleGroupType";
                    $scope.productBundleGroupTypes.value = [];
                    $scope.productBundleGroupTypes.$$adding = false;
                    $scope.productBundleGroupTypeSaving = false;
                    $scope.productBundleGroupType = {};
                    $scope.productBundleGroupTypeCollection = collectionConfigService.newCollectionConfig(("Type"));
                    $scope.productBundleGroupTypeCollection.setAllRecords(true);
                    $scope.productBundleGroupTypeCollection.addFilter("parentType.systemCode", "productBundleGroupType", "=");
                    if (angular.isUndefined($scope.productBundleGroup.data.productBundleGroupType)) {
                        var productBundleGroupType = $hibachi.newType();
                        var parentType = $hibachi.newType();
                        parentType.data.typeID = '154dcdd2f3fd4b5ab5498e93470957b8';
                        productBundleGroupType.$$setParentType(parentType);
                        $scope.productBundleGroup.$$setProductBundleGroupType(productBundleGroupType);
                    }
                    /**
                     * Sets the state to adding and sets the initial data.
                     */
                    $scope.productBundleGroupTypes.setAdding = function () {
                        $scope.productBundleGroupTypes.$$adding = !$scope.productBundleGroupTypes.$$adding;
                        if (!$scope.productBundleGroupTypes.$$adding) {
                            var productBundleGroupType = $hibachi.newType();
                            var parentType = $hibachi.newType();
                            parentType.data.typeID = '154dcdd2f3fd4b5ab5498e93470957b8';
                            productBundleGroupType.$$setParentType(parentType);
                            $scope.productBundleGroup.data.productBundleGroupType.data.typeName = "";
                            productBundleGroupType.data.typeName = $scope.productBundleGroup.data.productBundleGroupType.data.typeName;
                            productBundleGroupType.data.typeDescription = '';
                            productBundleGroupType.data.typeNameCode = '';
                            angular.extend($scope.productBundleGroup.data.productBundleGroupType, productBundleGroupType);
                            //formService.getForm('form.addProductBundleGroupType').$setDirty();
                        }
                    };
                    $scope.showAddProductBundleGroupTypeBtn = false;
                    /**
                     * Handles looking up the keyword and populating the dropdown as a user types.
                     */
                    $scope.productBundleGroupTypes.getTypesByKeyword = function (keyword) {
                        $log.debug('getTypesByKeyword');
                        var filterGroupsConfig = '[' +
                            ' {  ' +
                            '"filterGroup":[  ' +
                            ' {  ' +
                            ' "propertyIdentifier":"_type.parentType.systemCode",' +
                            ' "comparisonOperator":"=",' +
                            ' "value":"productBundleGroupType",' +
                            ' "ormtype":"string",' +
                            ' "conditionDisplay":"Equals"' +
                            '},' +
                            '{' +
                            '"logicalOperator":"AND",' +
                            ' "propertyIdentifier":"_type.typeName",' +
                            ' "comparisonOperator":"like",' +
                            ' "ormtype":"string",' +
                            ' "value":"%' + keyword + '%"' +
                            '  }' +
                            ' ]' +
                            ' }' +
                            ']';
                        return $hibachi.getEntity('type', { filterGroupsConfig: filterGroupsConfig.trim() })
                            .then(function (value) {
                            $log.debug('typesByKeyword');
                            $log.debug(value);
                            $scope.productBundleGroupTypes.value = value.pageRecords;
                            var myLength = keyword.length;
                            if (myLength > 0) {
                                $scope.showAddProductBundleGroupTypeBtn = true;
                            }
                            else {
                                $scope.showAddProductBundleGroupTypeBtn = false;
                            }
                            return $scope.productBundleGroupTypes.value;
                        });
                    };
                    /**
                     * Handles user selection of the dropdown.
                     */
                    $scope.selectProductBundleGroupType = function (item) {
                        angular.extend($scope.productBundleGroup.data.productBundleGroupType.data, item);
                        var parentType = $hibachi.newType();
                        parentType.data.typeID = '154dcdd2f3fd4b5ab5498e93470957b8';
                        $scope.productBundleGroup.data.productBundleGroupType.$$setParentType(parentType);
                        $scope.showAddProductBundleGroupTypeBtn = false;
                    };
                    /**
                     * Closes the add screen
                     */
                    $scope.closeAddScreen = function () {
                        $scope.productBundleGroupTypes.$$adding = false;
                        $scope.showAddProductBundleGroupTypeBtn = false;
                    };
                    /**
                     * Clears the type name
                     */
                    $scope.clearTypeName = function () {
                        if (angular.isDefined($scope.productBundleGroup.data.productBundleGroupType)) {
                            $scope.productBundleGroup.data.productBundleGroupType.data.typeName = '';
                        }
                    };
                    /**
                     * Saves product bundle group type
                     */
                    $scope.saveProductBundleGroupType = function () {
                        $scope.productBundleGroupTypeSaving = true;
                        //Gets the promise from save                    
                        var promise = $scope.productBundleGroup.data.productBundleGroupType.$$save();
                        promise.then(function (response) {
                            //Calls close function
                            if (promise.$$state.status) {
                                $scope.productBundleGroupTypeSaving = false;
                                $scope.closeAddScreen();
                            }
                        }, function () {
                            $scope.productBundleGroupTypeSaving = false;
                        });
                    };
                    //Sets up clickOutside Directive call back arguments
                    $scope.clickOutsideArgs = {
                        callBackActions: [$scope.closeAddScreen]
                    };
                    /**
                     * Works with swclickoutside directive to close dialog
                     */
                    $scope.closeThis = function (clickOutsideArgs) {
                        //Check against the object state
                        if (!$scope.productBundleGroup.data.productBundleGroupType.$$isPersisted()) {
                            //Perform all callback actions
                            for (var callBackAction in clickOutsideArgs.callBackActions) {
                                clickOutsideArgs.callBackActions[callBackAction]();
                            }
                        }
                    };
                }]
        };
    }
    SWProductBundleGroupType.Factory = function () {
        var directive = function ($http, $log, $hibachi, formService, collectionConfigService, productBundlePartialsPath, slatwallPathBuilder) { return new SWProductBundleGroupType($http, $log, $hibachi, formService, collectionConfigService, productBundlePartialsPath, slatwallPathBuilder); };
        directive.$inject = [
            '$http',
            '$log',
            '$hibachi',
            'formService',
            'collectionConfigService',
            'productBundlePartialsPath',
            'slatwallPathBuilder'
        ];
        return directive;
    };
    return SWProductBundleGroupType;
}());
exports.SWProductBundleGroupType = SWProductBundleGroupType;


/***/ }),

/***/ "hbCw":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
exports.SWOrderTemplateUpdateScheduleModal = void 0;
/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
var SWOrderTemplateUpdateScheduleModalController = /** @class */ (function () {
    function SWOrderTemplateUpdateScheduleModalController($timeout, $hibachi, observerService, orderTemplateService, rbkeyService, requestService) {
        var _this = this;
        this.$timeout = $timeout;
        this.$hibachi = $hibachi;
        this.observerService = observerService;
        this.orderTemplateService = orderTemplateService;
        this.rbkeyService = rbkeyService;
        this.requestService = requestService;
        this.processContext = 'updateSchedule';
        this.uniqueName = 'updateScheduleModal';
        this.formName = 'updateScheduleModal';
        //rb key properties
        this.title = "Update Schedule";
        this.$onInit = function () {
            if (_this.scheduleOrderNextPlaceDateTimeString != null) {
                var date = Date.parse(_this.scheduleOrderNextPlaceDateTimeString);
                _this.scheduleOrderNextPlaceDateTime = (date.getMonth() + 1) + '/' + date.getDate() + '/' + date.getFullYear();
            }
            if (_this.endDateString != null) {
                _this.endDate = Date.parse(_this.endDateString);
            }
        };
        this.save = function () {
            var formDataToPost = {
                entityID: _this.orderTemplate.orderTemplateID,
                entityName: 'OrderTemplate',
                context: _this.processContext,
                scheduleOrderNextPlaceDateTime: _this.scheduleOrderNextPlaceDateTime,
                propertyIdentifiersList: 'orderTemplateID,scheduleOrderNextPlaceDateTime'
            };
            formDataToPost.orderTemplateScheduleDateChangeReasonTypeID = _this.orderTemplateScheduleDateChangeReasonType.value;
            formDataToPost.orderTemplateID = _this.orderTemplate.orderTemplateID;
            if (_this.orderTemplateScheduleDateChangeReasonType.value === '2c9280846a023949016a029455f0000c' &&
                _this.otherScheduleDateChangeReasonNotes.length) {
                formDataToPost.otherScheduleDateChangeReasonNotes = _this.otherScheduleDateChangeReasonNotes;
            }
            var processUrl = _this.$hibachi.buildUrl('api:main.post');
            var adminRequest = _this.requestService.newAdminRequest(processUrl, formDataToPost);
            return adminRequest.promise;
        };
    }
    return SWOrderTemplateUpdateScheduleModalController;
}());
var SWOrderTemplateUpdateScheduleModal = /** @class */ (function () {
    function SWOrderTemplateUpdateScheduleModal(orderPartialsPath, slatwallPathBuilder, $hibachi, rbkeyService) {
        this.orderPartialsPath = orderPartialsPath;
        this.slatwallPathBuilder = slatwallPathBuilder;
        this.$hibachi = $hibachi;
        this.rbkeyService = rbkeyService;
        this.scope = {};
        this.bindToController = {
            modalButtonText: "@?",
            orderTemplate: "<?",
            orderTemplateScheduleDateChangeReasonTypeOptions: "<?",
            scheduleOrderNextPlaceDateTimeString: "@?",
            scheduleOrderNextPlaceDateTime: "=?",
            endDayOfTheMonth: '<?',
            endDateString: '@?',
            endDate: '=?'
        };
        this.controller = SWOrderTemplateUpdateScheduleModalController;
        this.controllerAs = "swOrderTemplateUpdateScheduleModal";
        this.link = function (scope, element, attrs) { };
        this.templateUrl = slatwallPathBuilder.buildPartialsPath(orderPartialsPath) + "/ordertemplateupdateschedulemodal.html";
        this.restrict = "EA";
    }
    SWOrderTemplateUpdateScheduleModal.Factory = function () {
        var directive = function (orderPartialsPath, slatwallPathBuilder, $hibachi, rbkeyService) { return new SWOrderTemplateUpdateScheduleModal(orderPartialsPath, slatwallPathBuilder, $hibachi, rbkeyService); };
        directive.$inject = [
            'orderPartialsPath',
            'slatwallPathBuilder',
            '$hibachi',
            'rbkeyService'
        ];
        return directive;
    };
    return SWOrderTemplateUpdateScheduleModal;
}());
exports.SWOrderTemplateUpdateScheduleModal = SWOrderTemplateUpdateScheduleModal;


/***/ }),

/***/ "hzQV":
/***/ (function(module, exports) {

module.exports = "<sw-modal-launcher data-launch-event-name=\"EDIT_SKUPRICE\"\n                   data-modal-name=\"{{swEditSkuPriceModalLauncher.uniqueName}}\" \n                   data-title=\"Edit Sku Price Detail\" \n                   data-save-action=\"swEditSkuPriceModalLauncher.save\">\n    \n    <sw-modal-content> \n        \n        <sw-form ng-if=\"swEditSkuPriceModalLauncher.skuPrice\"\n                 name=\"{{swEditSkuPriceModalLauncher.formName}}\" \n                 data-object=\"swEditSkuPriceModalLauncher.skuPrice\"    \n                 data-context=\"save\"\n                 \n                 >\n            <div ng-show=\"!swEditSkuPriceModalLauncher.saveSuccess\" class=\"alert alert-error\" role=\"alert\" sw-rbkey=\"'admin.entity.addskuprice.invalid'\"></div>\n            <div class=\"row\">\n                    <div class=\"col-sm-4\">\n                        <sw-sku-thumbnail data-sku-data=\"swEditSkuPriceModalLauncher.sku.data\">\n                        </sw-sku-thumbnail>\n                    </div>\n                    <div class=\"col-sm-8\">\n                        <div class=\"row\">\n                            <div class=\"col-sm-6\">\n                                <label  class=\"control-label\"\n                                        sw-rbKey=\"'entity.SkuPrice.price'\">\n                                </label>\n                                <input  class=\"form-control\" \n                                        type=\"text\" \n                                        name=\"price\" \n                                        ng-model=\"swEditSkuPriceModalLauncher.skuPrice.price\"\n                                />\n                            </div> \n                            <div class=\"col-sm-6\">\n                                <div class=\"form-group\">\n                                    <label  class=\"control-label\"\n                                            sw-rbKey=\"'entity.SkuPrice.currencyCode'\">\n                                        \n                                    </label>\n                                    <select class=\"form-control\" \n                                            name=\"currencyCode\"\n                                            ng-model=\"swEditSkuPriceModalLauncher.selectedCurrencyCode\"\n                                            ng-options=\"item as item for item in swEditSkuPriceModalLauncher.currencyCodeOptions track by item\"\n                                            ng-disabled=\"(swEditSkuPriceModalLauncher.disableAllFieldsButPrice || swEditSkuPriceModalLauncher.defaultCurrencyOnly) && !swEditSkuPriceModalLauncher.currencyCodeEditable\"\n                                            >\n                                    </select>\n                                </div>\n                            </div>\n                        </div>\n                        \n                        <div class=\"row\">\n                            <div class=\"col-sm-6\">\n                                <label  class=\"control-label\"\n                                        sw-rbKey=\"'entity.SkuPrice.minQuantity'\">\n                                </label>\n                                <input  class=\"form-control\" \n                                        type=\"text\" \n                                        name=\"minQuantity\" \n                                        ng-model=\"swEditSkuPriceModalLauncher.skuPrice.minQuantity\"\n                                />\n                            </div>\n                            <div class=\"col-sm-6\">\n                                <label  class=\"control-label\"\n                                        sw-rbKey=\"'entity.SkuPrice.maxQuantity'\">\n                                </label>\n                                <input  class=\"form-control\" \n                                        type=\"text\" \n                                        name=\"maxQuantity\" \n                                        ng-model=\"swEditSkuPriceModalLauncher.skuPrice.maxQuantity\"\n                                />\n                            </div>\n                        </div>\n                        <div class=\"row\">\n                            <div class=\"col-sm-12\">\n                                <label  class=\"control-label\"\n                                        sw-rbKey=\"'entity.PriceGroup'\">\n                                        \n                                </label>\n                                <select class=\"form-control\" \n                                        ng-model=\"swEditSkuPriceModalLauncher.selectedPriceGroup\"\n                                        ng-options=\"item as item.priceGroupName for item in swEditSkuPriceModalLauncher.priceGroupOptions track by item.priceGroupID\"\n                                        ng-change=\"swEditSkuPriceModalLauncher.setSelectedPriceGroup(swEditSkuPriceModalLauncher.selectedPriceGroup)\"\n                                        ng-disabled=\"swEditSkuPriceModalLauncher.priceGroupEditable == false\"\n                                        >\n                                </select>\n                                <input type=\"text\" readonly name=\"priceGroup\" ng-if=\"swEditSkuPriceModalLauncher.submittedPriceGroup\" ng-model=\"swEditSkuPriceModalLauncher.submittedPriceGroup\" />\n                            </div>\n                        </div>\n                        <!-- BEGIN HIDDEN FIELDS -->\n                        \n                        <!-- END HIDDEN FIELDS -->\n                    </div>\n                </div>\n            </sw-form>\n    </sw-modal-content> \n</sw-modal-launcher>";

/***/ }),

/***/ "iC/t":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
exports.productmodule = void 0;
/// <reference path='../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../typings/tsd.d.ts' />
//modules
var core_module_1 = __webpack_require__("pwA0");
//services
//controllers
var preprocessproduct_create_1 = __webpack_require__("EMMr");
//filters
//directives
var swproductlistingpages_1 = __webpack_require__("piNt");
var swrelatedproducts_1 = __webpack_require__("gQgA");
var swproductdeliveryscheduledates_1 = __webpack_require__("4ARy");
var productmodule = angular.module('hibachi.product', [core_module_1.coremodule.name]).config(function () {
})
    .constant('productPartialsPath', 'product/components/')
    //services
    //controllers
    .controller('preprocessproduct_create', preprocessproduct_create_1.ProductCreateController)
    //filters
    //directives
    .directive('swProductListingPages', swproductlistingpages_1.SWProductListingPages.Factory())
    .directive('swProductDeliveryScheduleDates', swproductdeliveryscheduledates_1.SWProductDeliveryScheduleDates.Factory())
    .directive('swRelatedProducts', swrelatedproducts_1.SWRelatedProducts.Factory());
exports.productmodule = productmodule;


/***/ }),

/***/ "icpf":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
exports.SWContentList = void 0;
/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
var SWContentListController = /** @class */ (function () {
    //@ngInject
    SWContentListController.$inject = ["$scope", "$log", "$timeout", "$hibachi", "paginationService", "observerService", "collectionConfigService", "localStorageService"];
    function SWContentListController($scope, $log, $timeout, $hibachi, paginationService, observerService, collectionConfigService, localStorageService) {
        var _this = this;
        this.$scope = $scope;
        this.$log = $log;
        this.$timeout = $timeout;
        this.$hibachi = $hibachi;
        this.paginationService = paginationService;
        this.observerService = observerService;
        this.collectionConfigService = collectionConfigService;
        this.localStorageService = localStorageService;
        this.openRoot = true;
        this.$log.debug('slatwallcontentList init');
        var pageShow = 50;
        if (this.pageShow !== 'Auto') {
            pageShow = this.pageShow;
        }
        this.pageShowOptions = [
            { display: 10, value: 10 },
            { display: 20, value: 20 },
            { display: 50, value: 50 },
            { display: 250, value: 250 }
        ];
        this.loadingCollection = false;
        if (this.localStorageService.hasItem('selectedSiteOption')) {
            this.selectedSite = this.localStorageService.getItem('selectedSiteOption');
        }
        this.orderBy;
        var orderByConfig;
        this.getCollection = function (isSearching) {
            _this.collectionConfig = collectionConfigService.newCollectionConfig('Content');
            var columnsConfig = [
                //{"propertyIdentifier":"_content_childContents","title":"","isVisible":true,"isDeletable":true,"isSearchable":true,"isExportable":true,"ormtype":"string","aggregate":{"aggregateFunction":"COUNT","aggregateAlias":"childContentsCount"}},
                {
                    propertyIdentifier: '_content.contentID',
                    isVisible: false,
                    ormtype: 'id',
                    isSearchable: true
                },
                {
                    propertyIdentifier: '_content.urlTitlePath',
                    isVisible: false,
                    isSearchable: true
                },
                //need to get template via settings
                {
                    propertyIdentifier: '_content.allowPurchaseFlag',
                    isVisible: true,
                    ormtype: 'boolean',
                    isSearchable: false
                },
                {
                    propertyIdentifier: '_content.productListingPageFlag',
                    isVisible: true,
                    ormtype: 'boolean',
                    isSearchable: false
                },
                {
                    propertyIdentifier: '_content.sortOrder',
                    isVisible: true,
                    ormtype: 'integer',
                    isSearchable: true
                },
                {
                    propertyIdentifier: '_content.activeFlag',
                    isVisible: true,
                    ormtype: 'boolean',
                    isSearchable: false
                }
            ];
            var options = {
                currentPage: '1',
                pageShow: '1',
                keywords: _this.keywords
            };
            var column = {};
            if (!isSearching || _this.keywords === '') {
                _this.isSearching = false;
                var filterGroupsConfig = [
                    {
                        "filterGroup": [
                            {
                                "propertyIdentifier": "parentContent",
                                "comparisonOperator": "is",
                                "value": 'null'
                            }
                        ]
                    }
                ];
                column = {
                    propertyIdentifier: '_content.title',
                    isVisible: true,
                    ormtype: 'string',
                    isSearchable: true,
                    tdclass: 'primary'
                };
                columnsConfig.unshift(column);
            }
            else {
                _this.collectionConfig.setKeywords(_this.keywords);
                _this.isSearching = true;
                var filterGroupsConfig = [
                    {
                        "filterGroup": [
                            {
                                "propertyIdentifier": "excludeFromSearch",
                                "comparisonOperator": "!=",
                                "value": true
                            }
                        ]
                    }
                ];
                column = {
                    propertyIdentifier: '_content.title',
                    isVisible: false,
                    ormtype: 'string',
                    isSearchable: true
                };
                columnsConfig.unshift(column);
                var titlePathColumn = {
                    propertyIdentifier: '_content.titlePath',
                    isVisible: true,
                    ormtype: 'string',
                    isSearchable: false
                };
                columnsConfig.unshift(titlePathColumn);
            }
            //if we have a selected Site add the filter
            if (_this.selectedSite && _this.selectedSite.siteID) {
                var selectedSiteFilter = {
                    logicalOperator: "AND",
                    propertyIdentifier: "site.siteID",
                    comparisonOperator: "=",
                    value: _this.selectedSite.siteID
                };
                filterGroupsConfig[0].filterGroup.push(selectedSiteFilter);
            }
            if (angular.isDefined(_this.orderBy)) {
                var orderByConfig = [];
                orderByConfig.push(_this.orderBy);
                options.orderByConfig = angular.toJson(orderByConfig);
            }
            angular.forEach(columnsConfig, function (column) {
                _this.collectionConfig.addColumn(column.propertyIdentifier, column.title, column);
            });
            _this.collectionConfig.addDisplayAggregate('childContents', 'COUNT', 'childContentsCount', { isVisible: false, isSearchable: false, title: 'test' });
            _this.collectionConfig.addDisplayProperty('site.siteID', undefined, {
                isVisible: false,
                ormtype: 'id',
                isSearchable: false
            });
            _this.collectionConfig.addDisplayProperty('site.domainNames', undefined, {
                isVisible: false,
                isSearchable: true
            });
            angular.forEach(filterGroupsConfig[0].filterGroup, function (filter) {
                _this.collectionConfig.addFilter(filter.propertyIdentifier, filter.value, filter.comparisonOperator, filter.logicalOperator);
            });
            _this.collectionConfig.setOrderBy("sortOrder|ASC");
            _this.collectionListingPromise = _this.collectionConfig.getEntity();
            _this.collectionListingPromise.then(function (value) {
                _this.$timeout(function () {
                    _this.collection = value;
                    _this.collection.collectionConfig = _this.collectionConfig;
                    _this.firstLoad = true;
                    _this.loadingCollection = false;
                });
            });
            return _this.collectionListingPromise;
        };
        //this.getCollection(false);
        this.loadingCollection = false;
        this.searchCollection = function () {
            $log.debug('search with keywords');
            $log.debug(_this.keywords);
            $('.childNode').remove();
            //Set current page here so that the pagination does not break when getting collection
            _this.loadingCollection = true;
            var promise = _this.getCollection(true);
            promise.then(function () {
                _this.collection.collectionConfig = _this.collectionConfig;
                _this.loadingCollection = false;
            });
        };
        var siteChanged = function (selectedSiteOption) {
            _this.localStorageService.setItem('selectedSiteOption', selectedSiteOption);
            _this.selectedSite = _this.localStorageService.getItem('selectedSiteOption');
            _this.openRoot = true;
            _this.getCollection();
        };
        this.observerService.attach(siteChanged, 'optionsChanged', 'siteOptions');
        var sortChanged = function (orderBy) {
            _this.orderBy = orderBy;
            _this.getCollection();
        };
        this.observerService.attach(sortChanged, 'sortByColumn', 'siteSorting');
        var optionsLoaded = function () {
            var option;
            if (_this.selectedSite) {
                option = _this.selectedSite;
            }
            _this.observerService.notify('selectOption', option);
        };
        this.observerService.attach(optionsLoaded, 'optionsLoaded', 'siteOptionsLoaded');
    }
    return SWContentListController;
}());
var SWContentList = /** @class */ (function () {
    //@ngInject
    SWContentList.$inject = ["contentPartialsPath", "observerService", "slatwallPathBuilder"];
    function SWContentList(contentPartialsPath, observerService, slatwallPathBuilder) {
        var _this = this;
        this.restrict = 'E';
        //public bindToController=true;
        this.controller = SWContentListController;
        this.controllerAs = "swContentList";
        this.link = function (scope, element, attrs, controller, transclude) {
            scope.$on('$destroy', function () {
                _this.observerService.detachByEvent('optionsChanged');
                _this.observerService.detachByEvent('sortByColumn');
            });
        };
        this.observerService = observerService;
        this.templateUrl = slatwallPathBuilder.buildPartialsPath(contentPartialsPath) + 'contentlist.html';
    }
    SWContentList.Factory = function () {
        var directive = function (contentPartialsPath, observerService, slatwallPathBuilder) { return new SWContentList(contentPartialsPath, observerService, slatwallPathBuilder); };
        directive.$inject = [
            'contentPartialsPath',
            'observerService',
            'slatwallPathBuilder'
        ];
        return directive;
    };
    return SWContentList;
}());
exports.SWContentList = SWContentList;


/***/ }),

/***/ "ir1N":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
exports.SWSkuPriceEditController = exports.SWSkuPriceEdit = void 0;
/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
var SWSkuPriceEditController = /** @class */ (function () {
    //@ngInject
    SWSkuPriceEditController.$inject = ["historyService", "listingService", "observerService", "skuPriceService", "utilityService", "$hibachi", "$filter", "$timeout"];
    function SWSkuPriceEditController(historyService, listingService, observerService, skuPriceService, utilityService, $hibachi, $filter, $timeout) {
        var _this = this;
        this.historyService = historyService;
        this.listingService = listingService;
        this.observerService = observerService;
        this.skuPriceService = skuPriceService;
        this.utilityService = utilityService;
        this.$hibachi = $hibachi;
        this.$filter = $filter;
        this.$timeout = $timeout;
        this.showSave = true;
        this.baseEntityName = "Product";
        this.updateDisplay = function (currencyCode) {
            if (angular.isDefined(currencyCode) && angular.isDefined(_this.currencyCode)) {
                _this.filterOnCurrencyCode = currencyCode;
                if (_this.currencyCode == _this.filterOnCurrencyCode || _this.filterOnCurrencyCode == "All") {
                    _this.showPriceEdit = true;
                }
                else {
                    _this.showPriceEdit = false;
                }
            }
        };
        this.switchTabContext = function () {
            _this.observerService.notify(_this.switchTabContextEventName, _this.tabToSwitchTo);
        };
        if (angular.isDefined(this.pageRecord)) {
            this.pageRecord.edited = false;
        }
        this.currencyFilter = this.$filter('swcurrency');
        this.formName = this.utilityService.createID(32);
        if (angular.isUndefined(this.showPriceEdit)) {
            this.showPriceEdit = true;
        }
        if (angular.isUndefined(this.skuId) && angular.isDefined(this.bundledSkuSkuId)) {
            this.skuId = this.bundledSkuSkuId;
        }
        if (angular.isDefined(this.bundledSkuCurrencyCode)) {
            this.currencyCode = this.bundledSkuCurrencyCode;
        }
        if (angular.isUndefined(this.currencyCode) && angular.isDefined(this.sku)) {
            this.currencyCode = this.sku.data.currencyCode;
        }
        if (angular.isUndefined(this.currencyCode) && angular.isDefined(this.skuPrice)) {
            this.currencyCode = this.skuPrice.data.currencyCode;
        }
        if (angular.isUndefined(this.price) && angular.isDefined(this.bundledSkuPrice)) {
            this.price = this.bundledSkuPrice;
        }
        if (angular.isDefined(this.sku)) {
            this.sku.data.price = this.currencyFilter(this.sku.data.price, this.currencyCode, 2, false);
        }
        if (angular.isDefined(this.skuPrice)) {
            this.skuPrice.data.price = this.currencyFilter(this.skuPrice.data.price, this.currencyCode, 2, false);
        }
        if (angular.isUndefined(this.skuId)
            && angular.isUndefined(this.sku)
            && angular.isUndefined(this.skuPriceId)
            && angular.isUndefined(this.skuPrice)) {
            throw ("You must provide either a skuID or a skuPriceID or a sku or a skuPrice to SWSkuPriceSingleEditController");
        }
        else {
            if (angular.isDefined(this.skuId) && angular.isUndefined(this.sku)) {
                var skuData = {
                    skuID: this.skuId,
                    skuCode: this.skuCode,
                    currencyCode: this.currencyCode,
                    price: this.currencyFilter(this.price, this.currencyCode, 2, false)
                };
                this.sku = this.$hibachi.populateEntity("Sku", skuData);
            }
            if (angular.isDefined(this.skuPriceId) && angular.isUndefined(this.skuPrice)) {
                var skuPriceData = {
                    skuPriceId: this.skuPriceId,
                    currencyCode: this.currencyCode,
                    minQuantity: this.minQuantity,
                    maxQuantity: this.maxQuantity,
                    price: this.currencyFilter(this.price, this.currencyCode, 2, false)
                };
                this.skuPrice = this.$hibachi.populateEntity("SkuPrice", skuPriceData);
                this.priceGroup = this.$hibachi.populateEntity('PriceGroup', { priceGroupID: this.priceGroupId });
                this.skuPrice.$$setPriceGroup(this.priceGroup);
            }
        }
        if (angular.isDefined(this.masterPriceObject)) {
            if (angular.isDefined(this.masterPriceObject.data.sku)) {
                var sku = this.masterPriceObject.data.sku;
            }
            else {
                var sku = this.masterPriceObject;
            }
            this.revertToValue = this.currencyFilter(this.skuPriceService.getInferredSkuPrice(sku, this.masterPriceObject.data.price, this.currencyCode), this.currencyCode, 2, false);
        }
    }
    return SWSkuPriceEditController;
}());
exports.SWSkuPriceEditController = SWSkuPriceEditController;
var SWSkuPriceEdit = /** @class */ (function () {
    function SWSkuPriceEdit(observerService, historyService, scopeService, skuPartialsPath, slatwallPathBuilder) {
        var _this = this;
        this.observerService = observerService;
        this.historyService = historyService;
        this.scopeService = scopeService;
        this.restrict = 'EA';
        this.scope = {};
        this.bindToController = {
            skuId: "@?",
            skuPriceId: "@?",
            skuCode: "@?",
            price: "@?",
            priceGroupId: "@?",
            baseEntityId: "@?",
            baseEntityName: "@?",
            bundledSkuSkuId: "@?",
            bundledSkuCurrencyCode: "@?",
            bundledSkuPrice: "@?",
            eligibleCurrencyCodeList: "@?",
            listingDisplayId: "@?",
            currencyCode: "@?",
            masterPriceObject: "=?",
            revertToValue: "=?",
            sku: "=?",
            skuPrice: "=?"
        };
        this.controller = SWSkuPriceEditController;
        this.controllerAs = "swSkuPriceEdit";
        this.link = function (scope, element, attrs, formController, transcludeFn) {
            var currentScope = _this.scopeService.getRootParentScope(scope, "pageRecord");
            if (angular.isDefined(currentScope["pageRecord"])) {
                scope.swSkuPriceEdit.pageRecord = currentScope["pageRecord"];
            }
            var currentScope = _this.scopeService.getRootParentScope(scope, "pageRecordKey");
            if (angular.isDefined(currentScope["pageRecordKey"])) {
                scope.swSkuPriceEdit.pageRecordIndex = currentScope["pageRecordKey"];
            }
            var skuPricesEditScope = _this.scopeService.getRootParentScope(scope, "swSkuPricesEdit");
            if (skuPricesEditScope != null) {
                scope.swSkuPriceEdit.baseEntityId = skuPricesEditScope["swSkuPricesEdit"].baseEntityId;
                scope.swSkuPriceEdit.baseEntityName = skuPricesEditScope["swSkuPricesEdit"].baseEntityName;
            }
            if (angular.isDefined(scope.swSkuPriceEdit.baseEntityId) && angular.isUndefined(scope.swSkuPriceEdit.skuId)) {
                scope.swSkuPriceEdit.selectCurrencyCodeEventName = "currencyCodeSelect" + scope.swSkuPriceEdit.baseEntityId;
                _this.observerService.attach(scope.swSkuPriceEdit.updateDisplay, scope.swSkuPriceEdit.selectCurrencyCodeEventName, scope.swSkuPriceEdit.formName);
                if (_this.historyService.hasHistory(scope.swSkuPriceEdit.selectCurrencyCodeEventName)) {
                    scope.swSkuPriceEdit.updateDisplay(_this.historyService.getHistory(scope.swSkuPriceEdit.selectCurrencyCodeEventName));
                }
            }
            var tabGroupScope = _this.scopeService.getRootParentScope(scope, "swTabGroup");
            var tabContentScope = _this.scopeService.getRootParentScope(scope, "swTabContent");
            if (tabContentScope != null) {
                if (angular.isDefined(tabGroupScope) && tabContentScope["swTabContent"].name == "Basic") {
                    scope.swSkuPriceEdit.switchTabContextEventName = tabGroupScope["swTabGroup"].switchTabEventName;
                    scope.swSkuPriceEdit.tabToSwitchTo = tabGroupScope["swTabGroup"].getTabByName("Pricing");
                    scope.swSkuPriceEdit.showSwitchTabContextButton = true;
                }
                else {
                    scope.swSkuPriceEdit.showSwitchTabContextButton = false;
                }
            }
        };
        this.templateUrl = slatwallPathBuilder.buildPartialsPath(skuPartialsPath) + "skupriceedit.html";
    }
    SWSkuPriceEdit.Factory = function () {
        var directive = function (observerService, historyService, scopeService, skuPartialsPath, slatwallPathBuilder) { return new SWSkuPriceEdit(observerService, historyService, scopeService, skuPartialsPath, slatwallPathBuilder); };
        directive.$inject = [
            'observerService',
            'historyService',
            'scopeService',
            'skuPartialsPath',
            'slatwallPathBuilder'
        ];
        return directive;
    };
    return SWSkuPriceEdit;
}());
exports.SWSkuPriceEdit = SWSkuPriceEdit;


/***/ }),

/***/ "j7U+":
/***/ (function(module, exports) {

module.exports = "<div class=\"s-detail-content-wrapper\">\n    <div id=\"collapse2\" class=\"panel-collapse collapse in\">\n       <sw-tab-group>\n           <!-- RB support here -->\n           <sw-tab-content data-name=\"Basic\">               \n                <!-- Attempting to incorporate needs into existing listing -->\n                <sw-listing-display\n                        data-multi-slot=\"true\"\n                        data-edit=\"true\"\n                        data-has-search=\"true\"\n                        data-is-angular-route=\"false\"\n                        data-angular-links=\"false\"\n                        data-has-action-bar=\"false\"\n                        data-child-property-name=\"bundledSkus\"\n                        data-record-detail-action=\"admin:entity.detailsku\"\n\t\t\t\t\t\tdata-show-print-options=\"true\"\n                        data-base-entity-name=\"Sku\"\n                        data-show-toggle-display-options=\"false\"\n                        data-show-report=\"false\"\n                        >\n\n                        <sw-listing-columns>\n                            <sw-listing-column \n                                data-property-identifier=\"skuCode\" \n                                data-fallback-property-identifiers=\"skuCode,bundledSku_skuCode\" \n                                data-cell-view=\"swSkuCodeEdit\"\n                                tdclass=\"primary\">\n                            </sw-listing-column>\n                            <sw-listing-column \n                                data-property-identifier=\"calculatedSkuDefinition\" \n                                data-fallback-property-identifiers=\"calculatedSkuDefinition,bundledSku_calculatedSkuDefinition\">\n                            </sw-listing-column>\n                            <sw-listing-column \n                                data-property-identifier=\"price\"\n                                data-is-visible=\"true\"\n                                data-cell-view=\"swSkuPriceEdit\">\n                            </sw-listing-column>\n                            <sw-listing-column \n                                data-property-identifier=\"calculatedQATS\">\n                            </sw-listing-column>\n                            <sw-listing-column\n                                data-property-identifier=\"calculatedQOH\"\n                                data-is-visible=\"swPricingManager.trackInventory\">\n                                <!-- \n                                TODO: \n                                this thrown angular[numfmt] error\n                                    <sw-listing-column\n                                        data-property-identifier=\"calculatedQOH\"\n                                        data-is-visible=\"swPricingManager.trackInventory\"\n                                        data-cell-view=\"swSkuStockAdjustmentModalLauncher\">\n                                -->\n                            </sw-listing-column>\n                            <sw-listing-column\n                                data-property-identifier=\"imageFile\"\n                                data-title=\"Image\"\n                                data-cell-view=\"swImageDetailModalLauncher\"\n                                data-tdclass=\"s-image\"\n                                data-is-visible=\"true\">\n                            </sw-listing-column>\n                            <sw-listing-column\n                                data-property-identifier=\"defaultSku\"\n                                data-title=\"Default\"\n                                data-is-visible=\"true\"\n                                data-cell-view=\"swDefaultSkuRadio\"\n                                tdclass=\"s-table-select\"\n                                >\n                            </sw-listing-column>   \n                        </sw-listing-columns>\n                        \n                        <sw-collection-configs>\n                            <sw-collection-config \n                                data-entity-name=\"Sku\"\n                                data-parent-directive-controller-as-name=\"swListingDisplay\"\n                                data-parent-deferred-property=\"singleCollectionDeferred\"\n                                data-collection-config-property=\"collectionConfig\">\n                                <sw-collection-columns>\n                                    <sw-collection-column data-property-identifier=\"skuID\"></sw-collection-column>\n                                    <sw-collection-column data-property-identifier=\"bundleFlag\" data-is-searchable=\"true\"></sw-collection-column>\n                                    <sw-collection-column data-property-identifier=\"skuCode\" data-is-searchable=\"true\"></sw-collection-column>\n                                    <sw-collection-column data-property-identifier=\"calculatedSkuDefinition\" data-is-searchable=\"true\"></sw-collection-column>\n                                    <sw-collection-column data-property-identifier=\"calculatedQATS\" data-is-searchable=\"false\"></sw-collection-column>\n                                    <sw-collection-column data-property-identifier=\"calculatedQOH\" data-is-searchable=\"false\"></sw-collection-column>\n                                    <sw-collection-column data-property-identifier=\"price\" data-is-searchable=\"false\"></sw-collection-column>\n                                    <sw-collection-column data-property-identifier=\"product.productID\"></sw-collection-column>\n                                    <sw-collection-column data-property-identifier=\"product.defaultSku.skuID\"></sw-collection-column>\n                                    <sw-collection-column data-property-identifier=\"imageFileName\" data-is-searchable=\"false\"></sw-collection-column>\n                                    <sw-collection-column data-property-identifier=\"imageFile\" data-is-searchable=\"false\"></sw-collection-column>\n                                    <sw-collection-column data-property-identifier=\"imagePath\" data-is-searchable=\"false\"></sw-collection-column>\n                                    <sw-collection-column data-property-identifier=\"currencyCode\" data-is-searchable=\"false\"></sw-collection-column>\n                                    <sw-collection-column data-property-identifier=\"bundledSkusCount\" data-is-searchable=\"false\"></sw-collection-column>\n                                </sw-collection-columns>\n                                <sw-collection-filters>\n                                    <sw-collection-filter data-property-identifier=\"product.productID\" data-comparison-operator=\"=\" data-comparison-value=\"{{swPricingManager.productId}}\" data-hidden=\"true\"></sw-collection-filter>\n                                </sw-collection-filters>\n                            </sw-collection-config>\n                        </sw-collection-configs>\n                        \n                        <sw-expandable-row-rules>\n                            <sw-listing-expandable-rule data-filter-property-identifier=\"bundleFlag\" \n                                                        data-filter-comparison-operator=\"=\" \n                                                        data-filter-comparison-value=\"Yes\"> \n                                <sw-config>\n                                    <sw-collection-config \n                                        data-entity-name=\"SkuBundle\"\n                                        data-parent-directive-controller-as-name=\"swListingExpandableRule\"\n                                        data-parent-deferred-property=\"hasChildrenCollectionConfigDeferred\"\n                                        data-collection-config-property=\"childrenCollectionConfig\"\n                                        data-all-records=\"true\">\n                                        <sw-collection-columns>\n                                            <sw-collection-column data-property-identifier=\"skuBundleID\"></sw-collection-column>\n                                            <sw-collection-column data-property-identifier=\"bundledSku.skuID\"></sw-collection-column>\n                                            <sw-collection-column data-property-identifier=\"bundledSku.skuCode\"></sw-collection-column>\n                                            <sw-collection-column data-property-identifier=\"bundledSku.calculatedSkuDefinition\"></sw-collection-column>\n                                            <sw-collection-column data-property-identifier=\"bundledSku.price\"></sw-collection-column>\n                                            <sw-collection-column data-property-identifier=\"bundledSku.currencyCode\"></sw-collection-column>\n                                        </sw-collection-columns>\n                                        <sw-collection-filters>\n                                            <sw-collection-filter data-property-identifier=\"sku.skuID\" data-comparison-operator=\"=\" data-comparison-value=\"${skuID}\"></sw-collection-filter>\n                                        </sw-collection-filters>\n                                    </sw-collection-config>\n                                </sw-config>\n                            </sw-listing-expandable-rule>\n                        </sw-expandable-row-rules>\n                        <sw-disabled-row-rules>\n                            <sw-listing-disable-rule  data-filter-property-identifier=\"skuBundleID\" \n                                                      data-filter-comparison-operator=\"is not\" \n                                                      data-filter-comparison-value=\"null\">\n                            </sw-listing-disable-rule>\n                        </sw-disabled-row-rules> \n                        <sw-listing-save-action>\n                            <sw-listing-row-save>\n                            </sw-listing-row-save>\n                        </sw-listing-save-action>\n                </sw-listing-display>\n           </sw-tab-content>\n           <sw-tab-content data-name=\"Pricing\">\n                <!--hack forcing listing id to pricing listing-->\n                <div>\n                    <div class=\"pull-right\">\n                        <sw-action-caller\n                                data-event=\"EDIT_SKUPRICE\"\n                                data-payload=\"undefined\"\n                                data-class=\"btn btn-primary btn-md\"\n                                data-icon=\"plus\"\n                                data-text=\"Add Sku Price\"\n                                data-iconOnly=\"false\">\n                            \n                        </sw-action-caller>\n                    </div>\n                    <div>\n                        <sw-listing-display\n                                data-has-search=\"true\"\n                                data-is-angular-route=\"false\"\n                                data-angular-links=\"false\"\n                                data-has-action-bar=\"false\"\n                                data-base-entity-name=\"SkuPrice\"\n                                data-actions=\"[{\n                                    'event' : 'SAVE_SKUPRICE',\n                                    'icon' : 'floppy-disk',\n                                    'iconOnly' : true,\n                                    'display' : false,\n                                    'eventListeners' : {\n                                        'cellModified' : 'setDisplayTrue',\n                                        'rowSaved' : 'setDisplayFalse'\n                                    },\n                                    'useEventListenerId' : true\n                                }]\"\n                                data-record-edit-event=\"EDIT_SKUPRICE\"\n                                data-record-delete-event=\"DELETE_SKUPRICE\"\n                                data-collection-config=\"swPricingManager.skuPriceCollectionConfig\"\n                                data-name=\"pricingListing\"\n                                data-using-personal-collection=\"true\"\n                                data-show-report=\"false\"\n                        >\n                                \n                        </sw-listing-display>\n                    </div>\n                </div>\n                \n                <sw-sku-price-modal data-product-id=\"{{swPricingManager.productId}}\"></sw-sku-price-modal>\n           </sw-tab-content>\n       </sw-tab-group>\n    </div>\n</div>";

/***/ }),

/***/ "j8SH":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
exports.AddressService = void 0;
/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
var AddressService = /** @class */ (function () {
    //@ngInject
    AddressService.$inject = ["$hibachi", "requestService"];
    function AddressService($hibachi, requestService) {
        var _this = this;
        this.$hibachi = $hibachi;
        this.requestService = requestService;
        this.getStateCodeOptionsByCountryCode = function (countryCode) {
            var queryString = 'entityName=State&f:countryCode=' +
                countryCode +
                '&allRecords=true&propertyIdentifiers=stateCode,stateName';
            var processUrl = _this.$hibachi.buildUrl('api:main.get', queryString);
            var adminRequest = _this.requestService.newAdminRequest(processUrl);
            return adminRequest.promise;
        };
    }
    return AddressService;
}());
exports.AddressService = AddressService;


/***/ }),

/***/ "jAYt":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
exports.SWSkuPricesEditController = exports.SWSkuPricesEdit = void 0;
/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
var SWSkuPricesEditController = /** @class */ (function () {
    //@ngInject
    SWSkuPricesEditController.$inject = ["observerService", "collectionConfigService", "utilityService", "skuPriceService", "$hibachi"];
    function SWSkuPricesEditController(observerService, collectionConfigService, utilityService, skuPriceService, $hibachi) {
        var _this = this;
        this.observerService = observerService;
        this.collectionConfigService = collectionConfigService;
        this.utilityService = utilityService;
        this.skuPriceService = skuPriceService;
        this.$hibachi = $hibachi;
        this.baseEntityName = "Product";
        this.refreshSkuPrices = function () {
            _this.skuPriceService.loadSkuPricesForSku(_this.skuId).finally(function () {
                _this.getSkuPrices();
            });
        };
        this.hasSkuPrices = function () {
            return _this.skuPriceService.hasSkuPrices(_this.skuId);
        };
        this.getSkuPrices = function () {
            if (angular.isDefined(_this.skuSkuId)) {
                _this.loadingPromise = _this.skuPriceService.getSkuPricesForQuantityRange(_this.skuId, _this.minQuantity, _this.maxQuantity, _this.eligibleCurrencyCodes, _this.priceGroupPriceGroupId);
            }
            else if (angular.isDefined(_this.skuId)) {
                _this.loadingPromise = _this.skuPriceService.getBaseSkuPricesForSku(_this.skuId, _this.eligibleCurrencyCodes);
            }
            _this.loadingPromise.then(function (data) {
                _this.skuPrices = data;
            }, function (reason) {
                throw ("swSkuPrices was unable to fetch skuPrices because: " + reason);
            });
            return _this.loadingPromise;
        };
        this.Id = this.utilityService.createID(32);
        if (angular.isDefined(this.skuEligibleCurrencyCodeList)) {
            this.eligibleCurrencyCodeList = this.skuEligibleCurrencyCodeList;
        }
        if (angular.isDefined(this.eligibleCurrencyCodeList)) {
            this.eligibleCurrencyCodes = this.eligibleCurrencyCodeList.split(",");
        }
        if (angular.isUndefined(this.skuPrices)) {
            this.skuPrices = [];
        }
        if (angular.isDefined(this.skuSkuId)) {
            this.skuId = this.skuSkuId;
        }
        else {
            //inflate the sku
            this.sku = this.$hibachi.populateEntity("Sku", { skuID: this.skuId, price: this.price });
        }
        if (angular.isDefined(this.skuPriceId)) {
            var skuPriceData = {
                skuPriceID: this.skuPriceId,
                minQuantity: this.minQuantity,
                maxQuantity: this.maxQuantity,
                currencyCode: this.currencyCode,
                price: this.price,
                priceGroup_priceGroupID: this.priceGroupPriceGroupId
            };
            this.skuPrice = this.$hibachi.populateEntity("SkuPrice", skuPriceData);
        }
        if (angular.isDefined(this.skuSkuId) && angular.isDefined(this.skuPrice)) {
            this.masterPriceObject = this.skuPrice;
        }
        else if (angular.isDefined(this.sku)) {
            this.masterPriceObject = this.sku;
        }
        this.refreshSkuPrices();
        this.observerService.attach(this.refreshSkuPrices, "skuPricesUpdate");
    }
    return SWSkuPricesEditController;
}());
exports.SWSkuPricesEditController = SWSkuPricesEditController;
var SWSkuPricesEdit = /** @class */ (function () {
    function SWSkuPricesEdit(scopeService, skuPartialsPath, slatwallPathBuilder) {
        this.scopeService = scopeService;
        this.skuPartialsPath = skuPartialsPath;
        this.slatwallPathBuilder = slatwallPathBuilder;
        this.restrict = 'EA';
        this.scope = {};
        this.bindToController = {
            skuId: "@",
            skuSkuId: "@",
            skuPriceId: "@",
            minQuantity: "@",
            maxQuantity: "@",
            currencyCode: "@",
            price: "@",
            bundledSkuSkuId: "@",
            baseEntityName: "@?",
            baseEntityId: "@?",
            listingDisplayId: "@?",
            eligibleCurrencyCodeList: "@?",
            skuEligibleCurrencyCodeList: "@?",
            sku: "=?",
            priceGroupPriceGroupId: "@?"
        };
        this.controller = SWSkuPricesEditController;
        this.controllerAs = "swSkuPricesEdit";
        this.compile = function (element, attrs) {
            return {
                pre: function ($scope, element, attrs) {
                },
                post: function ($scope, element, attrs) {
                }
            };
        };
        this.templateUrl = slatwallPathBuilder.buildPartialsPath(skuPartialsPath) + "skupricesedit.html";
    }
    SWSkuPricesEdit.Factory = function () {
        var directive = function (scopeService, skuPartialsPath, slatwallPathBuilder) { return new SWSkuPricesEdit(scopeService, skuPartialsPath, slatwallPathBuilder); };
        directive.$inject = [
            'scopeService',
            'skuPartialsPath',
            'slatwallPathBuilder'
        ];
        return directive;
    };
    return SWSkuPricesEdit;
}());
exports.SWSkuPricesEdit = SWSkuPricesEdit;


/***/ }),

/***/ "jDc/":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
exports.ordermodule = void 0;
/// <reference path='../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../typings/tsd.d.ts' />
//modules
var core_module_1 = __webpack_require__("pwA0");
//services
var ordertemplateservice_1 = __webpack_require__("1uds");
//components
var swaccountpaymentmethodmodal_1 = __webpack_require__("NtNG");
var swaccountshippingaddresscard_1 = __webpack_require__("uqOV");
var swaccountshippingmethodmodal_1 = __webpack_require__("D4Ox");
var swcustomeraccountpaymentmethodcard_1 = __webpack_require__("o54M");
var swordertemplateaddpromotionmodal_1 = __webpack_require__("sE5k");
var swordertemplateaddgiftcardmodal_1 = __webpack_require__("V3r6");
var swordertemplatefrequencycard_1 = __webpack_require__("p/l7");
var swordertemplatefrequencymodal_1 = __webpack_require__("o9Wo");
var swordertemplategiftcards_1 = __webpack_require__("IvXh");
var swordertemplateitems_1 = __webpack_require__("omOO");
var swordertemplatepromotions_1 = __webpack_require__("TkS2");
var swordertemplatepromotionitems_1 = __webpack_require__("auR5");
var swordertemplateupcomingorderscard_1 = __webpack_require__("npj8");
var swordertemplateupdateschedulemodal_1 = __webpack_require__("hbCw");
var swaddorderitemsbysku_1 = __webpack_require__("Co5z");
var swaddpromotionorderitemsbysku_1 = __webpack_require__("Qg35");
var ordermodule = angular.module('order', [core_module_1.coremodule.name])
    .config([function () {
    }]).run([function () {
    }])
    //constants
    .constant('orderPartialsPath', 'order/components/')
    //services
    .service('orderTemplateService', ordertemplateservice_1.OrderTemplateService)
    //controllers
    .directive('swAccountPaymentMethodModal', swaccountpaymentmethodmodal_1.SWAccountPaymentMethodModal.Factory())
    .directive('swAccountShippingAddressCard', swaccountshippingaddresscard_1.SWAccountShippingAddressCard.Factory())
    .directive('swAccountShippingMethodModal', swaccountshippingmethodmodal_1.SWAccountShippingMethodModal.Factory())
    .directive('swCustomerAccountPaymentMethodCard', swcustomeraccountpaymentmethodcard_1.SWCustomerAccountPaymentMethodCard.Factory())
    .directive('swOrderTemplateAddPromotionModal', swordertemplateaddpromotionmodal_1.SWOrderTemplateAddPromotionModal.Factory())
    .directive('swOrderTemplateAddGiftCardModal', swordertemplateaddgiftcardmodal_1.SWOrderTemplateAddGiftCardModal.Factory())
    .directive('swOrderTemplateFrequencyCard', swordertemplatefrequencycard_1.SWOrderTemplateFrequencyCard.Factory())
    .directive('swOrderTemplateFrequencyModal', swordertemplatefrequencymodal_1.SWOrderTemplateFrequencyModal.Factory())
    .directive('swOrderTemplateGiftCards', swordertemplategiftcards_1.SWOrderTemplateGiftCards.Factory())
    .directive('swOrderTemplateItems', swordertemplateitems_1.SWOrderTemplateItems.Factory())
    .directive('swOrderTemplatePromotions', swordertemplatepromotions_1.SWOrderTemplatePromotions.Factory())
    .directive('swOrderTemplatePromotionItems', swordertemplatepromotionitems_1.SWOrderTemplatePromotionItems.Factory())
    .directive('swOrderTemplateUpcomingOrdersCard', swordertemplateupcomingorderscard_1.SWOrderTemplateUpcomingOrdersCard.Factory())
    .directive('swOrderTemplateUpdateScheduleModal', swordertemplateupdateschedulemodal_1.SWOrderTemplateUpdateScheduleModal.Factory())
    .directive('swAddOrderItemsBySku', swaddorderitemsbysku_1.SWAddOrderItemsBySku.Factory())
    .directive('swAddPromotionOrderItemsBySku', swaddpromotionorderitemsbysku_1.SWAddPromotionOrderItemsBySku.Factory());
exports.ordermodule = ordermodule;


/***/ }),

/***/ "kGCo":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
exports.SWGiftCardHistory = exports.SWGiftCardHistoryController = void 0;
/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
var SWGiftCardHistoryController = /** @class */ (function () {
    //@ngInject
    SWGiftCardHistoryController.$inject = ["collectionConfigService", "$hibachi"];
    function SWGiftCardHistoryController(collectionConfigService, $hibachi) {
        var _this = this;
        this.collectionConfigService = collectionConfigService;
        this.$hibachi = $hibachi;
        var initialBalance = 0;
        var totalDebit = 0;
        var transactionConfig = this.collectionConfigService.newCollectionConfig('GiftCardTransaction');
        transactionConfig.setDisplayProperties("giftCardTransactionID, creditAmount, debitAmount, createdDateTime, giftCard.giftCardID, orderPayment.order.orderID, orderPayment.order.orderNumber, orderPayment.order.orderOpenDateTime,reasonForAdjustment,adjustedByAccount.calculatedFullName", "id,credit,debit,created,giftcardID,ordernumber,orderdatetime,reasonForAdjustment,adjustedBy");
        transactionConfig.addFilter('giftCard.giftCardID', this.giftCard.giftCardID);
        transactionConfig.setAllRecords(true);
        transactionConfig.setOrderBy("createdDateTime|DESC");
        var emailBounceConfig = this.collectionConfigService.newCollectionConfig('EmailBounce');
        emailBounceConfig.setDisplayProperties("emailBounceID, rejectedEmailTo, rejectedEmailSendTime, relatedObject, relatedObjectID");
        emailBounceConfig.addFilter('relatedObjectID', this.giftCard.giftCardID);
        emailBounceConfig.setAllRecords(true);
        emailBounceConfig.setOrderBy("rejectedEmailSendTime|DESC");
        var emailConfig = this.collectionConfigService.newCollectionConfig('Email');
        emailConfig.setDisplayProperties('emailID, emailTo, relatedObject, relatedObjectID, createdDateTime');
        emailConfig.addFilter('relatedObjectID', this.giftCard.giftCardID);
        emailConfig.setAllRecords(true);
        emailConfig.setOrderBy("createdDateTime|DESC");
        emailConfig.getEntity().then(function (response) {
            _this.emails = response.records;
            emailBounceConfig.getEntity().then(function (response) {
                _this.bouncedEmails = response.records;
                transactionConfig.getEntity().then(function (response) {
                    _this.transactions = response.records;
                    var initialCreditIndex = _this.transactions.length - 1;
                    var initialBalance = _this.transactions[initialCreditIndex].creditAmount;
                    var currentBalance = initialBalance;
                    for (var i = initialCreditIndex; i >= 0; i--) {
                        var transaction = _this.transactions[i];
                        if (typeof transaction.debitAmount !== "string") {
                            transaction.debit = true;
                            totalDebit += transaction.debitAmount;
                        }
                        else if (typeof transaction.creditAmount !== "string") {
                            if (i != initialCreditIndex) {
                                currentBalance += transaction.creditAmount;
                            }
                            transaction.debit = false;
                        }
                        transaction.detailOrderLink = $hibachi.buildUrl('admin:entity.detailOrder', 'orderID=' + transaction.orderPayment_order_orderID);
                        var tempCurrentBalance = currentBalance - totalDebit;
                        transaction.balance = tempCurrentBalance;
                        if (i == initialCreditIndex) {
                            var activeCard = {
                                activated: true,
                                debit: false,
                                activeAt: transaction.orderPayment_order_orderOpenDateTime,
                                balance: initialBalance
                            };
                            _this.transactions.splice(i, 0, activeCard);
                            if (angular.isDefined(_this.bouncedEmails)) {
                                angular.forEach(_this.bouncedEmails, function (email, bouncedEmailIndex) {
                                    email.bouncedEmail = true;
                                    email.balance = initialBalance;
                                    _this.transactions.splice(i, 0, email);
                                });
                            }
                            if (angular.isDefined(_this.emails)) {
                                angular.forEach(_this.emails, function (email) {
                                    email.emailSent = true;
                                    email.debit = false;
                                    email.sentAt = email.createdDateTime;
                                    email.balance = initialBalance;
                                    _this.transactions.splice(i, 0, email);
                                });
                            }
                        }
                    }
                });
            });
        });
        var orderConfig = this.collectionConfigService.newCollectionConfig('Order');
        orderConfig.setDisplayProperties("orderID,orderNumber,orderOpenDateTime,account.firstName,account.lastName,account.accountID,account.primaryEmailAddress.emailAddress");
        orderConfig.addFilter('orderID', this.giftCard.originalOrderItem_order_orderID);
        orderConfig.setAllRecords(true);
        orderConfig.getEntity().then(function (response) {
            _this.order = response.records[0];
        });
    }
    return SWGiftCardHistoryController;
}());
exports.SWGiftCardHistoryController = SWGiftCardHistoryController;
var SWGiftCardHistory = /** @class */ (function () {
    //@ngInject
    SWGiftCardHistory.$inject = ["collectionConfigService", "giftCardPartialsPath", "slatwallPathBuilder"];
    function SWGiftCardHistory(collectionConfigService, giftCardPartialsPath, slatwallPathBuilder) {
        this.collectionConfigService = collectionConfigService;
        this.giftCardPartialsPath = giftCardPartialsPath;
        this.slatwallPathBuilder = slatwallPathBuilder;
        this.scope = {};
        this.bindToController = {
            giftCard: "=?",
            transactions: "=?",
            bouncedEmails: "=?",
            order: "=?"
        };
        this.controller = SWGiftCardHistoryController;
        this.controllerAs = "swGiftCardHistory";
        this.link = function (scope, element, attrs) {
        };
        this.templateUrl = slatwallPathBuilder.buildPartialsPath(giftCardPartialsPath) + "/history.html";
        this.restrict = "EA";
    }
    SWGiftCardHistory.Factory = function () {
        var directive = function (collectionConfigService, giftCardPartialsPath, slatwallPathBuilder) { return new SWGiftCardHistory(collectionConfigService, giftCardPartialsPath, slatwallPathBuilder); };
        directive.$inject = [
            'collectionConfigService',
            'giftCardPartialsPath',
            'slatwallPathBuilder'
        ];
        return directive;
    };
    return SWGiftCardHistory;
}());
exports.SWGiftCardHistory = SWGiftCardHistory;


/***/ }),

/***/ "kZ4t":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
Object.defineProperty(exports, "__esModule", { value: true });
exports.SWOrderFulfillmentList = exports.SWOrderFulfillmentListController = void 0;
var FulfillmentsList;
(function (FulfillmentsList) {
    var Views;
    (function (Views) {
        Views[Views["Fulfillments"] = 0] = "Fulfillments";
        Views[Views["Items"] = 1] = "Items";
    })(Views = FulfillmentsList.Views || (FulfillmentsList.Views = {}));
    var ofisStatusType;
    (function (ofisStatusType) {
        ofisStatusType[ofisStatusType["unavailable"] = 0] = "unavailable";
        ofisStatusType[ofisStatusType["partial"] = 1] = "partial";
        ofisStatusType[ofisStatusType["available"] = 2] = "available";
    })(ofisStatusType = FulfillmentsList.ofisStatusType || (FulfillmentsList.ofisStatusType = {}));
})(FulfillmentsList || (FulfillmentsList = {}));
/**
 * Fulfillment List Controller
 */
var SWOrderFulfillmentListController = /** @class */ (function () {
    // @ngInject
    SWOrderFulfillmentListController.$inject = ["$hibachi", "$timeout", "collectionConfigService", "observerService", "utilityService", "$location", "$http", "$window", "typeaheadService", "orderFulfillmentService", "listingService"];
    function SWOrderFulfillmentListController($hibachi, $timeout, collectionConfigService, observerService, utilityService, $location, $http, $window, typeaheadService, orderFulfillmentService, listingService) {
        var _this = this;
        this.$hibachi = $hibachi;
        this.$timeout = $timeout;
        this.collectionConfigService = collectionConfigService;
        this.observerService = observerService;
        this.utilityService = utilityService;
        this.$location = $location;
        this.$http = $http;
        this.$window = $window;
        this.typeaheadService = typeaheadService;
        this.orderFulfillmentService = orderFulfillmentService;
        this.listingService = listingService;
        this.usingRefresh = false;
        this.addingBatch = false;
        this.FulfillmentsList = FulfillmentsList;
        this.getBaseCollection = function (entity) {
            console.log(entity);
            var collection = _this.collectionConfigService.newCollectionConfig(entity);
            switch (entity) {
                case "OrderFulfillment":
                    if (_this.customOrderFulfillmentCollectionConfig) {
                        collection.loadJson(_this.customOrderFulfillmentCollectionConfig);
                    }
                    break;
                case "OrderItem":
                    if (_this.customOrderItemCollectionConfig) {
                        collection.loadJson(_this.customOrderItemCollectionConfig);
                    }
                    break;
                default:
                    break;
            }
            return collection;
        };
        /**
         * Implements a listener for the orderFulfillment selections
         */
        this.swSelectionToggleSelectionorderFulfillmentCollectionTableListener = function (callBackData) {
            var processObject = _this.getProcessObject();
            if (_this.isSelected(callBackData.action)) {
                processObject['data']['orderFulfillmentIDList'] = _this.listAppend(processObject.data['orderFulfillmentIDList'], callBackData.selection);
            }
            else {
                processObject['data']['orderFulfillmentIDList'] = _this.listRemove(processObject.data['orderFulfillmentIDList'], callBackData.selection);
            }
            _this.setProcessObject(processObject);
        };
        this.collectionConfigUpdatedListener = function (callBackData) {
            if (_this.usingRefresh == true) {
                _this.refreshFlag = true;
            }
        };
        this.orderFulfillmentCollectionTablepageRecordsUpdatedListener = function (callBackData) {
            if (callBackData) {
                _this.updateCollectionsInView();
                _this.refreshCollectionTotal(_this.getCollectionByView(_this.getView()));
            }
        };
        /**
         * Implements a listener for the orderItem selections
         */
        this.swSelectionToggleSelectionorderItemCollectionTableListener = function (callBackData) {
            var processObject = _this.getProcessObject();
            if (_this.isSelected(callBackData.action)) {
                processObject['data']['orderItemIDList'] = _this.listAppend(processObject['data']['orderItemIDList'], callBackData.selection);
            }
            else {
                processObject['data']['orderItemIDList'] = _this.listRemove(processObject['data']['orderItemIDList'], callBackData.selection);
            }
        };
        /**
         * returns true if the action is selected
         */
        this.isSelected = function (test) {
            if (test == "check") {
                return true;
            }
            else {
                return false;
            }
            ;
        };
        /**
         * Each collection has a view. The view is maintained by the enum. This Returns
         * the collection for that view.
         */
        this.getCollectionByView = function (view) {
            if (view == undefined || _this.collections == undefined) {
                return;
            }
            return _this.collections[view];
        };
        this.updateCollectionsInView = function () {
            _this.collections = [];
            _this.collections.push(_this.orderFulfillmentCollection);
            _this.collections.push(_this.orderItemCollection);
        };
        /**
         * Setup the initial orderFulfillment Collection.
         */
        this.createOrderFulfillmentCollection = function () {
            _this.orderFulfillmentCollection = _this.getBaseCollection("OrderFulfillment");
            _this.orderFulfillmentCollection.addDisplayProperty("orderFulfillmentID", "ID");
            _this.orderFulfillmentCollection.addDisplayProperty("order.orderType.systemCode", "Order Type");
            _this.orderFulfillmentCollection.addDisplayProperty("fulfillmentMethod.fulfillmentMethodType", "Fulfillment Method Type");
            _this.orderFulfillmentCollection.addDisplayProperty("order.orderNumber", "Order Number");
            _this.orderFulfillmentCollection.addDisplayProperty("order.account.calculatedFullName", "Full Name");
            _this.orderFulfillmentCollection.addDisplayProperty("order.orderOpenDateTime", "Date Started");
            _this.orderFulfillmentCollection.addDisplayProperty("shippingMethod.shippingMethodName", "Shipping Method");
            _this.orderFulfillmentCollection.addDisplayProperty("shippingAddress.stateCode", "State");
            _this.orderFulfillmentCollection.addDisplayProperty("orderFulfillmentStatusType.typeName", "Status");
            _this.orderFulfillmentCollection.addDisplayProperty("estimatedShippingDate");
            //this.orderFulfillmentCollection.addDisplayProperty("orderFulfillmentItems.stock.location.locationID", "Stock Location");
            //this.orderFulfillmentCollection.addFilter("orderFulfillmentInvStatType.systemCode", "ofisAvailable", "=");
            _this.orderFulfillmentCollection.addFilter("orderFulfillmentStatusType.systemCode", "ofstUnfulfilled", "=");
            _this.orderFulfillmentCollection.addFilter("order.orderStatusType.systemCode", "ostNew", "=");
            _this.orderFulfillmentCollection.addFilter("order.orderNumber", "", "!=");
            _this.orderFulfillmentCollection.addFilter("fulfillmentMethod.fulfillmentMethodType", "shipping", "=");
        };
        this.createOrderFulfillmentCollectionWithStatus = function (status) {
            status = status.trim();
            _this.orderFulfillmentCollection = _this.getBaseCollection("OrderFulfillment");
            _this.orderFulfillmentCollection.addDisplayProperty("orderFulfillmentID", "ID");
            _this.orderFulfillmentCollection.addDisplayProperty("order.orderNumber", "Order Number");
            _this.orderFulfillmentCollection.addDisplayProperty("order.orderOpenDateTime", "Date Started");
            _this.orderFulfillmentCollection.addDisplayProperty("shippingMethod.shippingMethodName", "Shipping Method");
            _this.orderFulfillmentCollection.addDisplayProperty("shippingAddress.stateCode", "State");
            _this.orderFulfillmentCollection.addDisplayProperty("orderFulfillmentStatusType.typeName", "Status");
            //this.orderFulfillmentCollection.addDisplayProperty("orderFulfillmentInvStatType.systemCode", "Availability");
            //this.orderFulfillmentCollection.addDisplayProperty("orderFulfillmentItems.stock.location.locationID", "Stock Location");
            _this.orderFulfillmentCollection.addFilter("orderFulfillmentStatusType.systemCode", "ofstUnfulfilled", "!=");
            _this.orderFulfillmentCollection.addFilter("fulfillmentMethod.fulfillmentMethodType", "shipping", "=");
            //Shipping
            _this.orderFulfillmentCollection.addFilter("order.orderStatusType.systemCode", "ostNew", "=");
            _this.orderFulfillmentCollection.addFilter("order.orderNumber", "", "!=");
            if (status) {
                console.log("S", status, status == "available");
                if (status == "unavailable") {
                    _this.orderFulfillmentCollection.addFilter("orderFulfillmentItems.sku.calculatedQOH", "0", "<=");
                }
                else if (status == "available") {
                    console.log("Made it.");
                    _this.orderFulfillmentCollection.addFilter("orderFulfillmentItems.sku.calculatedQOH", "0", ">");
                }
                else if (status == "paid") {
                    _this.orderFulfillmentCollection.addFilter("order.calculatedPaymentAmountReceivedTotal", "0", ">");
                }
            }
            _this.orderFulfillmentCollection.getEntity().then(function (result) {
                //refreshes the page.
                _this.collections[0] = _this.orderFulfillmentCollection;
                _this.view = _this.views.Fulfillments;
                _this.refreshFlag = false;
            });
        };
        this.createOrderItemCollectionWithStatus = function (status) {
            delete _this.orderItemCollection;
            _this.view = undefined;
            _this.orderItemCollection = _this.getBaseCollection("OrderItem");
            _this.orderItemCollection.addDisplayProperty("orderItemID", "ID");
            _this.orderItemCollection.addDisplayProperty("order.orderNumber", "Order Number");
            _this.orderItemCollection.addDisplayProperty("order.orderOpenDateTime", "Date Started");
            _this.orderItemCollection.addDisplayProperty("shippingMethod.shippingMethodName", "Shipping Method");
            _this.orderItemCollection.addDisplayProperty("shippingAddress.stateCode", "State");
            _this.orderItemCollection.addDisplayProperty("orderFulfillmentStatusType.typeName", "Status");
            _this.orderItemCollection.addFilter("orderFulfillmentStatusType.systemCode", "ofstUnfulfilled", "==");
            _this.orderItemCollection.addFilter("fulfillmentMethod.fulfillmentMethodName", "Shipping", "=");
            //Shipping
            _this.orderItemCollection.addFilter("order.orderStatusType.systemCode", "ostNew", "=");
            _this.orderItemCollection.addFilter("order.orderNumber", "", "!=");
            //"order.paymentAmountDue", "0", ">", {persistent: false}
            if (status) {
                if (status == "partial") {
                    _this.orderFulfillmentCollection.addFilter("sku.calculatedQOH", "0", ">", "AND");
                }
                else if (status == "unavailable") {
                    _this.orderFulfillmentCollection.addFilter("sku.calculatedQOH", "0", "<=", "AND");
                }
                else if (status == "available") {
                    _this.orderFulfillmentCollection.addFilter("sku.calculatedQOH", "0", ">", "AND");
                }
                else if (status == "paid") {
                    _this.orderFulfillmentCollection.addFilter("order.calculatedPaymentAmountReceivedTotal", "0", ">", "AND");
                }
            }
            _this.orderItemCollection.getEntity().then(function (result) {
                //refreshes the page.
                _this.collections[0] = _this.orderItemCollection;
                _this.view = _this.views.Fulfillments;
            });
        };
        this.createOrderFulfillmentCollectionWithFilterMap = function (filterMap) {
            delete _this.orderFulfillmentCollection;
            _this.view = undefined;
            _this.orderFulfillmentCollection = _this.getBaseCollection("OrderFulfillment");
            _this.orderFulfillmentCollection.addDisplayProperty("orderFulfillmentID", "ID");
            _this.orderFulfillmentCollection.addDisplayProperty("order.orderNumber", "Order Number");
            _this.orderFulfillmentCollection.addDisplayProperty("order.orderOpenDateTime", "Date Started");
            _this.orderFulfillmentCollection.addDisplayProperty("shippingMethod.shippingMethodName", "Shipping Method");
            _this.orderFulfillmentCollection.addDisplayProperty("shippingAddress.stateCode", "State");
            _this.orderFulfillmentCollection.addDisplayProperty("orderFulfillmentStatusType.typeName", "Status");
            _this.orderFulfillmentCollection.addFilter("orderFulfillmentStatusType.systemCode", "ofstUnfulfilled", "=");
            _this.orderFulfillmentCollection.addFilter("fulfillmentMethod.fulfillmentMethodType", "shipping", "=");
            //Shipping
            _this.orderFulfillmentCollection.addFilter("order.orderStatusType.systemCode", "ostNew", "=");
            _this.orderFulfillmentCollection.addFilter("order.orderNumber", "", "!=");
            //this.orderFulfillmentCollection.addDisplayProperty("orderFulfillmentInvStatType.systemCode", "Availability");
            //this.orderFulfillmentCollection.addDisplayProperty("orderFulfillmentItems.stock.location.locationID", "Stock Location");
            //Build the collection using just the correct filters.
            //Check the filters for multiple true
            var hasMultipleEnabled = false;
            var filterCount = 0;
            filterMap.forEach(function (v, k) {
                if (filterMap.get(k) === true) {
                    filterCount++;
                }
            });
            if (filterCount > 1) {
                hasMultipleEnabled = true;
            }
            //Add the filters.
            filterMap.forEach(function (v, k) {
                var systemCode = k;
                //handle truth
                if (filterMap.get(k) === true) {
                    if (k) {
                        if (k == "unavailable") {
                            _this.orderFulfillmentCollection.addFilter("sku.calculatedQOH", "0", "=", "AND");
                        }
                        else if (k == "available") {
                            _this.orderFulfillmentCollection.addFilter("sku.calculatedQOH", "0", ">", "AND");
                        }
                        else if (k == "paid") {
                            console.log("Apply Paid Filter");
                            _this.orderFulfillmentCollection.addFilter("order.calculatedPaymentAmountReceivedTotal", "0", ">", "AND");
                        }
                    }
                }
                //handle false
                if (filterMap.get(k) === false && filterMap.get(k) != undefined) {
                    if (systemCode.length) {
                        //this.orderFulfillmentCollection.addFilter("orderFulfillmentItems.sku.calculatedQATS", systemCode, "!=", 'AND');
                        //this.orderFulfillmentCollection.addFilter("orderFulfillmentStatusType.systemCode", "ofstFulfilled", "!=", "AND");
                        //this.orderFulfillmentCollection.addFilter("order.orderNumber", "", "!=", "AND");
                    }
                }
            });
            if (_this.getCollectionByView(_this.getView())) {
                _this.refreshCollectionTotal(_this.getCollectionByView(_this.getView()));
            }
        };
        /**
         * Setup the initial orderItem Collection.
         */
        this.createOrderItemCollection = function () {
            _this.orderItemCollection = _this.getBaseCollection("OrderItem");
            _this.orderItemCollection.addDisplayProperty("orderItemID");
            _this.orderItemCollection.addDisplayProperty("sku.skuCode");
            _this.orderItemCollection.addDisplayProperty("sku.calculatedSkuDefinition");
            _this.orderItemCollection.addDisplayProperty("sku.calculatedQOH");
            _this.orderItemCollection.addDisplayProperty("stock.location.locationName");
            _this.orderItemCollection.addDisplayProperty("orderFulfillment.fulfillmentMethod.fulfillmentMethodType", "Fulfillment Method Type");
            _this.orderItemCollection.addDisplayProperty("quantity");
            _this.orderItemCollection.addDisplayProperty("order.orderNumber");
            _this.orderItemCollection.addDisplayProperty("order.orderOpenDateTime");
            _this.orderItemCollection.addDisplayProperty("orderFulfillment.orderFulfillmentStatusType.typeName");
            _this.orderItemCollection.addDisplayProperty("sku.product.productName");
            _this.orderItemCollection.addFilter("orderFulfillment.orderFulfillmentStatusType.systemCode", "ofstUnfulfilled", "=");
            _this.orderItemCollection.addFilter("orderFulfillment.fulfillmentMethod.fulfillmentMethodType", "shipping", "=");
            _this.orderItemCollection.addFilter("order.orderNumber", "", "!=");
        };
        /**
         * Toggle the Status Type filters on and off.
         */
        this.toggleFilter = function (filterName) {
            _this.filters[filterName] = !_this.filters[filterName];
            if (_this.filters[filterName]) {
                _this.addFilter(filterName, true);
                return;
            }
            _this.removeFilter(filterName, false);
        };
        /**
         * Toggle between views. We refresh the collection everytime we set the view.
         */
        this.setView = function (view) {
            _this.view = view;
            if (_this.getCollectionByView(_this.getView())) {
                _this.refreshCollectionTotal(_this.getCollectionByView(_this.getView()));
            }
        };
        //ACTION CREATOR: This will toggle the listing between its 2 states (orderfulfillments and orderitems)
        this.toggleOrderFulfillmentListing = function () {
            _this.orderFulfillmentService.orderFulfillmentStore.dispatch({ type: "TOGGLE_FULFILLMENT_LISTING", payload: {} });
            //reset the selections because you can't mix and match.
            _this.getProcessObject().data.orderFulfillmentIDList = "";
            _this.getProcessObject().data.orderItemIDList = "";
            try {
                _this.orderFulfillmentService.listingService.clearAllSelections("orderFulfillmentCollectionTable");
                _this.orderFulfillmentService.listingService.clearAllSelections("orderItemCollectionTable");
            }
            catch (e) {
                //no need to say anything.
            }
            _this.refreshCollectionTotal(_this.getCollectionByView(_this.getView()));
        };
        /**
         * Returns the current view.
         */
        this.getView = function () {
            return _this.view;
        };
        /**
         * Refreshes the view
         */
        this.refreshPage = function () {
            if (_this.utilityService.isMultiPageMode()) {
                window.location.reload();
            }
        };
        /**
         * Initialized the collection so that the listingDisplay can you it to display its data.
         */
        this.refreshCollectionTotal = function (collection) {
            if (collection) {
                collection.getEntity().then(function (response) {
                    _this.total = response.recordsCount;
                    _this.refreshFlag = false;
                });
                return collection;
            }
        };
        this.getRecordsCount = function (collection) {
            _this.total = collection.recordsCount;
            _this.refreshFlag = false;
        };
        /**
         * Adds one of the status type filters into the collectionConfigService
         * @param key: FulfillmentsList.CollectionFilterValues {'partial' | 'available' | 'unavailable' | 'location'}
         * @param Vvalue: boolean: {true|false}
         */
        this.addFilter = function (key, value) {
            _this.$timeout(function () {
                _this.refreshFlag = true;
            }, 1);
            //Always keep the orderNumber filter.
            //If there is only one filter group add a second. otherwise add to the second.
            var filterGroup = [];
            var filter = {};
            if (_this.getCollectionByView(_this.getView()) && _this.getCollectionByView(_this.getView()).baseEntityName == "OrderFulfillment") {
                if (value == true) {
                    if (key == "partial") {
                        _this.createOrderFulfillmentCollectionWithStatus("partial");
                    }
                    if (key == "available") {
                        _this.createOrderFulfillmentCollectionWithStatus("available");
                    }
                    if (key == "unavailable") {
                        _this.createOrderFulfillmentCollectionWithStatus("unavailable");
                    }
                    if (key == "location" && value != undefined) {
                        filter = _this.getCollectionByView(_this.getView()).createFilter("orderFulfillmentItems.stock.location.locationName", value, "=", "OR", false);
                    }
                    if (key == "paid" && value != undefined) {
                        console.log("Applied Paid Filter");
                        _this.getCollectionByView(_this.getView()).addFilter("order.calculatedPaymentAmountReceivedTotal", "0", ">");
                    }
                }
                if (value = false) {
                    _this.createOrderFulfillmentCollection();
                }
            }
            else {
                if (value == true) {
                    if (key == "partial") {
                        _this.createOrderItemCollectionWithStatus("partial");
                    }
                    if (key == "available") {
                        _this.createOrderItemCollectionWithStatus("available");
                    }
                    if (key == "unavailable") {
                        _this.createOrderItemCollectionWithStatus("unavailable");
                    }
                    if (key == "location" && value != undefined) {
                        filter = _this.getCollectionByView(_this.getView()).createFilter("stock.location.locationName", value, "=", "OR", false);
                    }
                    if (key == "paid" && value != undefined) {
                        console.log("Applied Paid Filter");
                        _this.getCollectionByView(_this.getView()).addFilter("order.calculatedPaymentAmountReceivedTotal", "0", ">");
                    }
                }
                if (value = false) {
                    _this.createOrderItemCollection();
                }
            }
            _this.refreshCollectionTotal(_this.getCollectionByView(_this.getView()));
        };
        /**
         * Adds one of the status type filters into the collectionConfigService
         * @param key: FulfillmentsList.CollectionFilterValues {'partial' | 'available' | 'unavailable' | 'location'}
         * @param Vvalue: boolean: {true|false}
         */
        this.removeFilter = function (key, value) {
            _this.refreshFlag = true;
            //Always keep the orderNumber filter.
            if (_this.getCollectionByView(_this.getView()) && _this.getCollectionByView(_this.getView()).baseEntityName == "OrderFulfillment") {
                var filterMap = new Map();
                filterMap.set("partial", _this.filters['partial']);
                filterMap.set("available", _this.filters['available']);
                filterMap.set("unavailable", _this.filters['unavailable']);
                filterMap.set("location", _this.filters['location']);
                filterMap.set("paid", _this.filters['paid']);
                _this.createOrderFulfillmentCollectionWithFilterMap(filterMap);
            }
            else if (_this.getCollectionByView(_this.getView()).baseEntityName == "OrderItem") {
                console.warn("Adding orderItem Filters", _this.getCollectionByView(_this.getView()));
            }
            //Calls to auto refresh the collection since a filter was added.
            _this.createOrderFulfillmentCollection();
            _this.createOrderItemCollection();
            //some view setup.
            _this.views = FulfillmentsList.Views;
            _this.setView(_this.views.Fulfillments);
            //add both collections into the collection object. Removed 0 elements (insert only).
            _this.collections.push(_this.orderFulfillmentCollection);
            _this.collections.push(_this.orderItemCollection);
            _this.refreshCollectionTotal(_this.getCollectionByView(_this.getView()));
        };
        /**
         * This applies or removes a location filter from the collection.
         */
        this.addLocationFilter = function (locationID) {
            var currentCollection = _this.getCollectionByView(_this.getView());
            if (currentCollection && currentCollection.baseEntityName == "OrderFulfillment") {
                //If this is the fulfillment collection, the location is against, orderItems.stock.location
                currentCollection.addFilter("orderFulfillmentItems.stock.location.locationID", locationID, "=");
            }
            if (currentCollection && currentCollection.baseEntityName == "OrderItem") {
                //If this is the fulfillment collection, the location is against, stock.location
                currentCollection.addFilter("stock.location.locationID", locationID, "=");
            }
            //this.toggleOrderFulfillmentListing();
            //this.toggleOrderFulfillmentListing();
            _this.refreshCollectionTotal(_this.getCollectionByView(_this.getView()));
        };
        /**
         * Saved the batch using the data stored in the processObject. This delegates to the service method.
         */
        this.addBatch = function () {
            _this.addingBatch = true;
            if (_this.getProcessObject()) {
                _this.orderFulfillmentService.addBatch(_this.getProcessObject()).then(_this.processCreateSuccess, _this.processCreateError);
            }
        };
        /**
         * Handles a successful post of the processObject
         */
        this.processCreateSuccess = function (result) {
            //Redirect to the created fulfillmentBatch.
            _this.addingBatch = false;
            if (result.data && result.data['fulfillmentBatchID']) {
                //if url contains /Slatwall use that
                var slatwall = "";
                slatwall = _this.$hibachi.appConfig.baseURL;
                if (slatwall == "")
                    slatwall = "/";
                _this.$window.location.href = slatwall + "?slataction=entity.detailfulfillmentbatch&fulfillmentBatchID=" + result.data['fulfillmentBatchID'];
            }
        };
        /**
         * Handles a successful post of the processObject
         */
        this.processCreateError = function (data) {
            console.warn("Process Errors", data);
        };
        /**
         * Returns the processObject
         */
        this.getProcessObject = function () {
            return _this.processObject;
        };
        /**
         * Sets the processObject
         */
        this.setProcessObject = function (processObject) {
            _this.processObject = processObject;
        };
        /**
         * This will recieve all the notifications from all typeaheads on the page.
         * When I revieve a notification, it will be an object that has a name and data.
         * The name is the name of the form and the data is the selected id. The three types,
         * that I'm currently looking for are:
         * "locationIDfilter", "locationID", or "accountID" These are the same as the names of the forms.
         */
        this.recieveNotification = function (message) {
            switch (message.payload.name) {
                case "locationIDfilter":
                    //If this is called, then the filter needs to be updated based on this id.
                    _this.addLocationFilter(message.payload.data);
                    break;
                case "locationID":
                    //If this is called, then a location for the batch has been selected.
                    _this.getProcessObject().data['locationID'] = message.payload.data || "";
                    break;
                case "accountID":
                    //If this is called, then an account to assign to the batch has been selected.
                    _this.getProcessObject().data['assignedAccountID'] = message.payload.data || "";
                    break;
                default:
                    console.log("Warning: A default case was hit with the data: ", message);
            }
        };
        /**
         * Returns the number of selected fulfillments
         */
        this.getTotalFulfillmentsSelected = function () {
            var total = 0;
            if (_this.getProcessObject() && _this.getProcessObject().data) {
                try {
                    if (_this.getProcessObject().data.orderFulfillmentIDList && _this.getProcessObject().data.orderFulfillmentIDList.split(",").length > 0 && _this.getProcessObject().data.orderItemIDList && _this.getProcessObject().data.orderItemIDList.split(",").length > 0) {
                        return _this.getProcessObject().data.orderFulfillmentIDList.split(",").length + _this.getProcessObject().data.orderItemIDList.split(",").length;
                    }
                    else if (_this.getProcessObject().data.orderFulfillmentIDList && _this.getProcessObject().data.orderFulfillmentIDList.split(",").length > 0) {
                        return _this.getProcessObject().data.orderFulfillmentIDList.split(",").length;
                    }
                    else if (_this.getProcessObject().data.orderItemIDList && _this.getProcessObject().data.orderItemIDList.split(",").length > 0) {
                        return _this.getProcessObject().data.orderItemIDList.split(",").length;
                    }
                    else {
                        return 0;
                    }
                }
                catch (error) {
                    return 0; //default
                }
            }
        };
        //Set the initial state for the filters.
        this.filters = { "unavailable": false, "partial": false, "available": false, "paid": false };
        this.collections = [];
        //Some setup for the fulfillments collection.
        this.createOrderFulfillmentCollection();
        this.createOrderItemCollection();
        //some view setup.
        this.views = FulfillmentsList.Views;
        this.setView(this.views.Fulfillments);
        //add both collections into the collection object. Removed 0 elements (insert only).
        this.collections.push(this.orderFulfillmentCollection);
        this.collections.push(this.orderItemCollection);
        //Setup the processObject
        this.setProcessObject(this.$hibachi.newFulfillmentBatch_Create());
        //adds the two default filters to start.
        //this.addFilter('available', true);
        //this.addFilter('partial', true);
        var collection = this.refreshCollectionTotal(this.getCollectionByView(this.getView()));
        if (collection.entityName = "OrderFulfillment") {
            this.orderFulfillmentCollection = collection;
        }
        else {
            this.orderItemCollection = collection;
        }
        //Attach our listeners for selections on both listing displays.
        this.observerService.attach(this.swSelectionToggleSelectionorderFulfillmentCollectionTableListener, "swSelectionToggleSelectionorderFulfillmentCollectionTable", "swSelectionToggleSelectionorderFulfillmentCollectionTableListener");
        this.observerService.attach(this.swSelectionToggleSelectionorderItemCollectionTableListener, "swSelectionToggleSelectionorderItemCollectionTable", "swSelectionToggleSelectionorderItemCollectionTableListener");
        this.observerService.attach(this.collectionConfigUpdatedListener, "collectionConfigUpdated", "collectionConfigUpdatedListener");
        //Subscribe to state changes in orderFulfillmentService
        this.orderFulfillmentService.orderFulfillmentStore.store$.subscribe(function (state) {
            _this.state = state;
            if (state && state.showFulfillmentListing == true) {
                //set the view.
                _this.setView(_this.views.Fulfillments);
            }
            else {
                _this.setView(_this.views.Items);
            }
            _this.getCollectionByView(_this.getView());
        });
        //Subscribe for state changes to the typeahead.
        this.typeaheadService.typeaheadStore.store$.subscribe(function (update) {
            if (update.action && update.action.payload) {
                _this.recieveNotification(update.action);
            }
        });
    }
    /**
     * Adds a string to a list.
     */
    SWOrderFulfillmentListController.prototype.listAppend = function (str, subStr) {
        return this.utilityService.listAppend(str, subStr, ",");
    };
    /**
     * Removes a substring from a string.
     * str: The original string.
     * subStr: The string to remove.
     */
    SWOrderFulfillmentListController.prototype.listRemove = function (str, subStr) {
        return this.utilityService.listRemove(str, subStr);
    };
    return SWOrderFulfillmentListController;
}());
exports.SWOrderFulfillmentListController = SWOrderFulfillmentListController;
/**
 * This is a view helper class that uses the collection helper class.
 */
var SWOrderFulfillmentList = /** @class */ (function () {
    // @ngInject
    SWOrderFulfillmentList.$inject = ["slatwallPathBuilder", "orderFulfillmentPartialsPath"];
    function SWOrderFulfillmentList(slatwallPathBuilder, orderFulfillmentPartialsPath) {
        this.restrict = "EA";
        this.scope = {};
        this.bindToController = {
            customOrderFulfillmentCollectionConfig: '=?',
            customOrderItemCollectionConfig: '=?'
        };
        this.controller = SWOrderFulfillmentListController;
        this.controllerAs = "swOrderFulfillmentListController";
        this.link = function ($scope, element, attrs) {
        };
        this.templateUrl = slatwallPathBuilder.buildPartialsPath(orderFulfillmentPartialsPath) + "orderfulfillmentlist.html";
    }
    SWOrderFulfillmentList.Factory = function () {
        var directive = function (slatwallPathBuilder, orderFulfillmentPartialsPath) { return new SWOrderFulfillmentList(slatwallPathBuilder, orderFulfillmentPartialsPath); };
        directive.$inject = [
            'slatwallPathBuilder',
            'orderFulfillmentPartialsPath'
        ];
        return directive;
    };
    return SWOrderFulfillmentList;
}());
exports.SWOrderFulfillmentList = SWOrderFulfillmentList;


/***/ }),

/***/ "lEbT":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

/// <reference path='../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../typings/tsd.d.ts' />
Object.defineProperty(exports, "__esModule", { value: true });
exports.productbundlemodule = void 0;
//modules
var core_module_1 = __webpack_require__("pwA0");
//services
var productbundleservice_1 = __webpack_require__("U0MA");
//controllers
var create_bundle_controller_1 = __webpack_require__("4fWv");
//directives
var swproductbundlegrouptype_1 = __webpack_require__("hOsJ");
var swproductbundlegroups_1 = __webpack_require__("I73d");
var swproductbundlegroup_1 = __webpack_require__("GNQN");
var swproductbundlecollectionfilteritemtypeahead_1 = __webpack_require__("sjkZ");
//filters
var productbundlemodule = angular.module('hibachi.productbundle', [core_module_1.coremodule.name]).config(function () {
})
    //constants
    .constant('productBundlePartialsPath', 'productbundle/components/')
    //services
    .service('productBundleService', productbundleservice_1.ProductBundleService)
    //controllers
    .controller('create-bundle-controller', create_bundle_controller_1.CreateBundleController)
    //directives
    .directive('swProductBundleGroupType', swproductbundlegrouptype_1.SWProductBundleGroupType.Factory())
    .directive('swProductBundleGroups', swproductbundlegroups_1.SWProductBundleGroups.Factory())
    .directive('swProductBundleGroup', swproductbundlegroup_1.SWProductBundleGroup.Factory())
    .directive('swProductBundleCollectionFilterItemTypeahead', swproductbundlecollectionfilteritemtypeahead_1.SWProductBundleCollectionFilterItemTypeahead.Factory());
exports.productbundlemodule = productbundlemodule;


/***/ }),

/***/ "lZA8":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
Object.defineProperty(exports, "__esModule", { value: true });
exports.SWOrderDeliveryDetail = exports.SWOrderDeliveryDetailController = void 0;
/**
 * Fulfillment Batch Detail Controller
 */
var SWOrderDeliveryDetailController = /** @class */ (function () {
    // @ngInject
    SWOrderDeliveryDetailController.$inject = ["$hibachi", "$timeout", "collectionConfigService", "observerService", "utilityService", "$location", "$http", "$window", "typeaheadService", "listingService", "orderFulfillmentService", "rbkeyService"];
    function SWOrderDeliveryDetailController($hibachi, $timeout, collectionConfigService, observerService, utilityService, $location, $http, $window, typeaheadService, listingService, orderFulfillmentService, rbkeyService) {
        var _this = this;
        this.$hibachi = $hibachi;
        this.$timeout = $timeout;
        this.collectionConfigService = collectionConfigService;
        this.observerService = observerService;
        this.utilityService = utilityService;
        this.$location = $location;
        this.$http = $http;
        this.$window = $window;
        this.typeaheadService = typeaheadService;
        this.listingService = listingService;
        this.orderFulfillmentService = orderFulfillmentService;
        this.rbkeyService = rbkeyService;
        /**
         * Setup the container preset list
         */
        this.getContainerPresetList = function () {
            _this.containerPresetCollection = _this.collectionConfigService.newCollectionConfig("ContainerPreset");
            _this.containerPresetCollection.addDisplayProperty("containerPresetID");
            _this.containerPresetCollection.addDisplayProperty("containerName");
            _this.containerPresetCollection.addDisplayProperty("height");
            _this.containerPresetCollection.addDisplayProperty("width");
            _this.containerPresetCollection.addDisplayProperty("depth");
            _this.containerPresetCollection.getEntity().then(function (result) {
                _this.containerPresetCollection = result.pageRecords || [];
            });
        };
        /** Populates box dimensions with dimensions from container preset */
        this.userAddingNewBox = function () {
            _this.boxes.push({ containerItems: [] });
        };
        this.userRemovingBox = function (index) {
            _this.boxes.splice(index, 1);
        };
        /**
         * Updates the quantity of a container item.
        */
        this.updateContainerItemQuantity = function (containerItem, newQuantity) {
            newQuantity = +newQuantity;
            if (newQuantity == undefined || isNaN(newQuantity)) {
                return;
            }
            if (newQuantity < 0) {
                newQuantity = 0;
            }
            if (newQuantity > containerItem.packagedQuantity) {
                var quantityDifference = newQuantity - containerItem.packagedQuantity;
                if (!_this.unassignedContainerItems[containerItem.sku.skuCode]) {
                    containerItem.newQuantity = containerItem.packagedQuantity;
                    return;
                }
                else if (_this.unassignedContainerItems[containerItem.sku.skuCode].quantity <= quantityDifference) {
                    newQuantity = containerItem.packagedQuantity + _this.unassignedContainerItems[containerItem.sku.skuCode].quantity;
                    quantityDifference = newQuantity - containerItem.packagedQuantity;
                    containerItem.newQuantity = newQuantity;
                    containerItem.packagedQuantity = newQuantity;
                    _this.unassignedContainerItems[containerItem.sku.skuCode].quantity -= quantityDifference;
                }
            }
            else if (newQuantity < containerItem.packagedQuantity) {
                if (!_this.unassignedContainerItems[containerItem.sku.skuCode]) {
                    _this.unassignedContainerItems[containerItem.sku.skuCode] = {
                        sku: containerItem.sku,
                        item: containerItem.item,
                        quantity: 0
                    };
                }
                _this.unassignedContainerItems[containerItem.sku.skuCode].quantity += containerItem.packagedQuantity - newQuantity;
                containerItem.packagedQuantity = newQuantity;
                containerItem.newQuantity = newQuantity;
            }
            if (_this.unassignedContainerItems[containerItem.sku.skuCode].quantity == 0) {
                delete _this.unassignedContainerItems[containerItem.sku.skuCode];
            }
            _this.cleanUpContainerItems();
            //this.emitUpdateToClient();
        };
        /**Sets container for unassigned item */
        this.userSettingUnassignedItemContainer = function (skuCode, container) {
            var containerItem = container.containerItems.find(function (item) {
                return item.sku.skuCode == skuCode;
            });
            if (!containerItem) {
                containerItem = {
                    item: _this.unassignedContainerItems[skuCode].item,
                    sku: _this.unassignedContainerItems[skuCode].sku,
                    packagedQuantity: 0
                };
                container.containerItems.push(containerItem);
            }
            containerItem.packagedQuantity += _this.unassignedContainerItems[skuCode].quantity;
            delete _this.unassignedContainerItems[skuCode];
            _this.cleanUpContainerItems();
            //this.emitUpdateToClient();
        };
        /**
        * Removes any container items from their container if the packaged quantity is zero
        */
        this.cleanUpContainerItems = function () {
            for (var i = 0; i < _this.boxes.length; i++) {
                var box = _this.boxes[i];
                for (var j = box.containerItems.length - 1; j >= 0; j--) {
                    var containerItem = box.containerItems[j];
                    if (containerItem.packagedQuantity == 0) {
                        box.containerItems.splice(j, 1);
                    }
                    else {
                        containerItem.newQuantity = containerItem.packagedQuantity;
                    }
                }
            }
        };
        /** Populates box dimensions with dimensions from container preset */
        this.userUpdatingBoxPreset = function (box) {
            if (!box.containerPreset) {
                return;
            }
            box.height = box.containerPreset.height;
            box.width = box.containerPreset.width;
            box.depth = box.containerPreset.depth;
            box.containerName = box.containerPreset.containerName;
            box.containerPresetID = box.containerPreset.containerPresetID;
        };
        this.defaultContainersStruct = this.defaultContainerJson;
        this.packageCount = this.defaultContainersStruct['packageCount'];
        delete this.defaultContainersStruct['packageCount'];
        if (this.hasIntegration) {
            this.useShippingIntegrationForTrackingNumber = true;
        }
        else {
            this.useShippingIntegrationForTrackingNumber = false;
        }
        this.boxes = [];
        this.unassignedContainerItems = {};
        for (var key in this.defaultContainersStruct) {
            for (var index in this.defaultContainersStruct[key]) {
                var container = this.defaultContainersStruct[key][index];
                var box = {};
                box['containerName'] = container.containerName;
                box['containerPresetID'] = container.containerPresetID;
                box['depth'] = container.depth || 1;
                box['height'] = container.height || 1;
                box['itemcount'] = container.itemcount;
                box['maxQuantity'] = container.maxQuantity;
                box['value'] = container.value;
                box['weight'] = container.weight;
                box['width'] = container.width || 1;
                box['containerItems'] = container.containerItems;
                //Do this for UI tracking
                box['containerPreset'] = {
                    //Don't judge me
                    containerPresetID: container.containerPresetID
                };
                this.boxes.push(box);
            }
        }
        this.getContainerPresetList();
    }
    return SWOrderDeliveryDetailController;
}());
exports.SWOrderDeliveryDetailController = SWOrderDeliveryDetailController;
/**
 * This is a view helper class that uses the collection helper class.
 */
var SWOrderDeliveryDetail = /** @class */ (function () {
    // @ngInject
    SWOrderDeliveryDetail.$inject = ["$hibachi", "$timeout", "collectionConfigService", "observerService", "orderDeliveryDetailPartialsPath", "slatwallPathBuilder"];
    function SWOrderDeliveryDetail($hibachi, $timeout, collectionConfigService, observerService, orderDeliveryDetailPartialsPath, slatwallPathBuilder) {
        this.$hibachi = $hibachi;
        this.$timeout = $timeout;
        this.collectionConfigService = collectionConfigService;
        this.observerService = observerService;
        this.orderDeliveryDetailPartialsPath = orderDeliveryDetailPartialsPath;
        this.restrict = "EA";
        this.scope = {};
        this.bindToController = {
            orderFulfillmentId: "@?",
            defaultContainerJson: "=",
            hasIntegration: '='
        };
        this.controller = SWOrderDeliveryDetailController;
        this.controllerAs = "swOrderDeliveryDetailController";
        this.link = function ($scope, element, attrs) {
        };
        this.templateUrl = slatwallPathBuilder.buildPartialsPath(orderDeliveryDetailPartialsPath) + "/orderdeliverydetail.html";
    }
    SWOrderDeliveryDetail.Factory = function () {
        var directive = function ($hibachi, $timeout, collectionConfigService, observerService, orderDeliveryDetailPartialsPath, slatwallPathBuilder) { return new SWOrderDeliveryDetail($hibachi, $timeout, collectionConfigService, observerService, orderDeliveryDetailPartialsPath, slatwallPathBuilder); };
        directive.$inject = [
            '$hibachi',
            '$timeout',
            'collectionConfigService',
            'observerService',
            'orderDeliveryDetailPartialsPath',
            'slatwallPathBuilder'
        ];
        return directive;
    };
    return SWOrderDeliveryDetail;
}());
exports.SWOrderDeliveryDetail = SWOrderDeliveryDetail;


/***/ }),

/***/ "laNr":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
exports.SWOiShippingLabelStamp = void 0;
/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
/**
 * Displays a shipping label in the order items row.
 * @module slatwalladmin
 * @class swOrderItemsShippingLabelStamp
 */
var SWOiShippingLabelStamp = /** @class */ (function () {
    function SWOiShippingLabelStamp($log, orderItemPartialsPath, slatwallPathBuilder) {
        return {
            restrict: 'E',
            scope: {
                orderFulfillment: "="
            },
            templateUrl: slatwallPathBuilder.buildPartialsPath(orderItemPartialsPath) + "orderfulfillment-shippinglabel.html",
            link: function (scope, element, attrs) {
                //Get the template.
                $log.debug("\n\n<---ORDER FULFILLMENT STAMP--->\n\n");
                $log.debug(scope.orderFulfillment);
                $log.debug(scope.orderFulfillment.data.fulfillmentMethodType);
            }
        };
    }
    SWOiShippingLabelStamp.Factory = function () {
        var directive = function ($log, orderItemPartialsPath, slatwallPathBuilder) { return new SWOiShippingLabelStamp($log, orderItemPartialsPath, slatwallPathBuilder); };
        directive.$inject = [
            '$log',
            'orderItemPartialsPath',
            'slatwallPathBuilder'
        ];
        return directive;
    };
    return SWOiShippingLabelStamp;
}());
exports.SWOiShippingLabelStamp = SWOiShippingLabelStamp;


/***/ }),

/***/ "nf8Q":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
exports.SWSkuPriceModalController = exports.SWSkuPriceModal = void 0;
var SWSkuPriceModalController = /** @class */ (function () {
    //@ngInject
    SWSkuPriceModalController.$inject = ["$hibachi", "entityService", "formService", "listingService", "observerService", "skuPriceService", "utilityService", "collectionConfigService", "scopeService", "$scope", "$timeout", "requestService"];
    function SWSkuPriceModalController($hibachi, entityService, formService, listingService, observerService, skuPriceService, utilityService, collectionConfigService, scopeService, $scope, $timeout, requestService) {
        var _this = this;
        this.$hibachi = $hibachi;
        this.entityService = entityService;
        this.formService = formService;
        this.listingService = listingService;
        this.observerService = observerService;
        this.skuPriceService = skuPriceService;
        this.utilityService = utilityService;
        this.collectionConfigService = collectionConfigService;
        this.scopeService = scopeService;
        this.$scope = $scope;
        this.$timeout = $timeout;
        this.requestService = requestService;
        this.baseName = "j-add-sku-item-";
        this.currencyCodeEditable = false;
        this.priceGroupEditable = false;
        this.currencyCodeOptions = [];
        this.saveSuccess = true;
        this.updateCurrencyCodeSelector = function (args) {
            if (args != 'All') {
                _this.skuPrice.data.currencyCode = args;
                _this.currencyCodeEditable = false;
            }
            else {
                _this.currencyCodeEditable = true;
            }
            _this.observerService.notify("pullBindings");
        };
        this.inlineSave = function (pageRecord) {
            _this.initData(pageRecord);
            var formDataToPost = {
                entityName: 'SkuPrice',
                entityID: pageRecord['skuPriceID'],
                context: 'save',
                propertyIdentifiersList: ''
            };
            for (var key in pageRecord) {
                if (key.indexOf("$") > -1 || key.indexOf("skuPriceID") > -1) {
                    continue;
                }
                else if (key.indexOf("_") > -1) {
                    if (key.indexOf("ID") == -1) {
                        continue;
                    }
                    var property = key.split("_");
                    formDataToPost[property[0]] = {};
                    formDataToPost[property[0]][property[1]] = pageRecord[key];
                }
                else {
                    formDataToPost[key] = pageRecord[key];
                }
            }
            var processUrl = _this.$hibachi.buildUrl('api:main.post');
            var adminRequest = _this.requestService.newAdminRequest(processUrl, formDataToPost);
            return adminRequest.promise.then(function (response) {
                _this.listingService.notifyListingPageRecordsUpdate(_this.listingID);
                _this.observerService.notifyById("rowSaved", _this.pageRecord.$$hashKey, _this.pageRecord);
            });
        };
        this.setSelectedPriceGroup = function (priceGroupData) {
            if (!priceGroupData.priceGroupID) {
                _this.submittedPriceGroup = {};
                return;
            }
            _this.submittedPriceGroup = { priceGroupID: priceGroupData['priceGroupID'] };
        };
        this.setSelectedSku = function (skuData) {
            if (!angular.isDefined(skuData['skuID'])) {
                return;
            }
            _this.selectedSku = { skuName: skuData['skuName'], skuCode: skuData['skuCode'], skuID: skuData['skuID'] };
            _this.sku = _this.$hibachi.populateEntity('Sku', skuData);
            _this.submittedSku = { skuID: skuData['skuID'] };
            _this.setCoumpoundSkuName(skuData);
        };
        this.setCoumpoundSkuName = function (skuData) {
            _this.compoundSkuName = "";
            if (skuData['skuName']) {
                _this.compoundSkuName += skuData['skuName'];
            }
            if (_this.compoundSkuName.length) {
                _this.compoundSkuName += " - ";
            }
            if (skuData['skuCode']) {
                _this.compoundSkuName += skuData['skuCode'];
            }
        };
        this.isDefaultSkuPrice = function () {
            if (_this.pageRecord) {
                if ((_this.skuPrice.sku.currencyCode == _this.skuPrice.currencyCode) &&
                    !_this.skuPrice.minQuantity.trim() &&
                    !_this.skuPrice.maxQuantity.trim() &&
                    (!_this.skuPrice.priceGroup.priceGroupID || !_this.skuPrice.priceGroup.priceGroupID.trim()) &&
                    _this.skuPrice.price) {
                    return true;
                }
            }
            return false;
        };
        this.$onDestroy = function () {
            _this.observerService.detachByEvent('EDIT_SKUPRICE');
            _this.observerService.detachByEvent('SAVE_SKUPRICE');
        };
        this.deleteSkuPrice = function (pageRecord) {
            var skuPriceData = {
                skuPriceID: pageRecord.skuPriceID,
                minQuantity: pageRecord.minQuantity,
                maxQuantity: pageRecord.maxQuantity,
                currencyCode: pageRecord.currencyCode,
                price: pageRecord.price
            };
            var skuPrice = _this.$hibachi.populateEntity('SkuPrice', skuPriceData);
            var deletePromise = skuPrice.$$delete();
            deletePromise.then(function (resolve) {
                //hack, for whatever reason is not responding to getCollection event
                _this.observerService.notifyById('swPaginationAction', _this.listingID, { type: 'setCurrentPage', payload: 1 });
            }, function (reason) {
                console.log("Could not delete Sku Price Because: ", reason);
            });
            return deletePromise;
        };
        this.save = function () {
            _this.observerService.notify("updateBindings");
            if (_this.pageRecord && _this.submittedPriceGroup) {
                _this.priceGroup.priceGroupID = _this.submittedPriceGroup.priceGroupID;
                _this.priceGroup.priceGroupCode = _this.submittedPriceGroup.priceGroupCode;
            }
            var form = _this.formService.getForm(_this.formName);
            var savePromise = _this.skuPrice.$$save();
            savePromise.then(function (response) {
                _this.saveSuccess = true;
                _this.observerService.notify('skuPricesUpdate', { skuID: _this.sku.data.skuID, refresh: true });
                //hack, for whatever reason is not responding to getCollection event
                _this.observerService.notifyById('swPaginationAction', _this.listingID, { type: 'setCurrentPage', payload: 1 });
                _this.formService.resetForm(form);
            }, function (reason) {
                //error callback
                console.log("validation failed because: ", reason);
                _this.saveSuccess = false;
            }).finally(function () {
                if (_this.saveSuccess) {
                    for (var key in _this.skuPrice.data) {
                        if (key != 'sku' && key != 'currencyCode') {
                            _this.skuPrice.data[key] = null;
                        }
                    }
                    _this.selectedSku = {};
                    _this.submittedSku = {};
                    _this.formService.resetForm(form);
                    _this.listingService.getCollection(_this.listingID);
                    _this.listingService.notifyListingPageRecordsUpdate(_this.listingID);
                }
            });
            return savePromise;
        };
        this.uniqueName = this.baseName + this.utilityService.createID(16);
        this.formName = "skuPriceForm" + this.utilityService.createID(16);
        if (angular.isDefined(this.productId)) {
            this.skuCollectionConfig = this.skuPriceService.getSkuCollectionConfig(this.productId);
        }
        else if (angular.isDefined(this.promotionRewardId)) {
            var collectionConfigStruct = angular.fromJson(this.skuCollectionConfig);
            $timeout(function () {
                _this.skuCollectionConfig = _this.collectionConfigService.newCollectionConfig().loadJson(collectionConfigStruct);
            });
        }
        //hack for listing hardcodeing id
        this.listingID = 'pricingListing';
        this.observerService.attach(this.initData, "EDIT_SKUPRICE");
        this.observerService.attach(this.inlineSave, "SAVE_SKUPRICE");
        this.observerService.attach(this.deleteSkuPrice, "DELETE_SKUPRICE");
    }
    SWSkuPriceModalController.prototype.initData = function (pageRecord) {
        var _this = this;
        this.pageRecord = pageRecord;
        if (pageRecord) {
            var skuPriceData = {
                skuPriceID: pageRecord.skuPriceID,
                minQuantity: pageRecord.minQuantity,
                maxQuantity: pageRecord.maxQuantity,
                currencyCode: pageRecord.currencyCode,
                price: pageRecord.price,
                listPrice: pageRecord.listPrice
            };
            var skuData = {
                skuID: pageRecord["sku_skuID"],
                skuCode: pageRecord["sku_skuCode"],
                calculatedSkuDefinition: pageRecord["sku_calculatedSkuDefinition"],
                skuName: pageRecord["sku_skuName"],
                imagePath: pageRecord["sku_imagePath"]
            };
            var promotionRewardData = {
                promotionRewardID: pageRecord['promotionRewardID']
            };
            var priceGroupData = {
                priceGroupID: pageRecord["priceGroup_priceGroupID"],
                priceGroupCode: pageRecord["priceGroup_priceGroupCode"]
            };
            //reference to form is being wiped
            if (this.skuPrice) {
                var skuPriceForms = this.skuPrice.forms;
            }
            this.skuPrice = this.$hibachi.populateEntity('SkuPrice', skuPriceData);
            if (skuPriceForms) {
                this.skuPrice.forms = skuPriceForms;
            }
            if (this.sku) {
                var skuForms = this.sku.forms;
            }
            this.sku = this.$hibachi.populateEntity('Sku', skuData);
            if (skuForms) {
                this.skuPrice.forms = skuForms;
            }
            this.setCoumpoundSkuName(skuData);
            if (this.promotionReward) {
                var promotionRewardForms = this.promotionReward.forms;
            }
            this.promotionReward = this.$hibachi.populateEntity('PromotionReward', promotionRewardData);
            if (promotionRewardForms) {
                this.promotionReward.forms = promotionRewardForms;
            }
            if (this.priceGroup) {
                var priceGroupForms = this.priceGroup.forms;
            }
            this.priceGroup = this.$hibachi.populateEntity('PriceGroup', priceGroupData);
            if (priceGroupForms) {
                this.priceGroup.forms = priceGroupForms;
            }
            this.skuPriceService.getPriceGroupOptions().then(function (response) {
                _this.priceGroupOptions = response.records;
                _this.priceGroupOptions.unshift({ priceGroupName: "- Select Price Group -", priceGroupID: "" });
            }).finally(function () {
                _this.selectedPriceGroup = _this.priceGroupOptions[0];
                for (var i = 0; i < _this.priceGroupOptions.length; i++) {
                    if (_this.pageRecord['priceGroup_priceGroupID'] == _this.priceGroupOptions[i].priceGroupID) {
                        _this.selectedPriceGroup = _this.priceGroupOptions[i];
                        console.log(_this.selectedPriceGroup);
                    }
                }
                _this.priceGroupEditable = false;
                if (!_this.selectedPriceGroup['priceGroupID']) {
                    _this.priceGroupEditable = true;
                }
            });
            this.skuPriceService.getCurrencyOptions().then(function (response) {
                if (response.records.length) {
                    _this.currencyCodeOptions = [];
                    for (var i = 0; i < response.records.length; i++) {
                        _this.currencyCodeOptions.push(response.records[i]['currencyCode']);
                    }
                    _this.currencyCodeOptions.unshift("- Select Currency Code -");
                    _this.selectedCurrencyCode = _this.currencyCodeOptions[0];
                    for (var i = 0; i < _this.currencyCodeOptions.length; i++) {
                        if (_this.pageRecord['currencyCode'] == _this.currencyCodeOptions[i]) {
                            _this.selectedCurrencyCode = _this.currencyCodeOptions[i];
                        }
                    }
                }
            });
            this.skuPrice.$$setPriceGroup(this.priceGroup);
            this.skuPrice.$$setSku(this.sku);
            this.skuPrice.$$setPromotionReward(this.promotionReward);
        }
        else {
            //reference to form is being wiped
            if (this.skuPrice) {
                var skuPriceForms = this.skuPrice.forms;
            }
            this.skuPrice = this.skuPriceService.newSkuPrice();
            if (skuPriceForms) {
                this.skuPrice.forms = skuPriceForms;
            }
            if (this.promotionRewardId) {
                if (this.promotionReward) {
                    var promotionRewardForms = this.promotionReward.forms;
                }
                this.promotionReward = this.$hibachi.populateEntity('PromotionReward', { promotionRewardID: this.promotionRewardId });
                if (promotionRewardForms) {
                    this.promotionReward.forms = promotionRewardForms;
                }
                this.skuPrice.$$setPromotionReward(this.promotionReward);
            }
            this.skuPriceService.getSkuOptions(this.productId).then(function (response) {
                _this.skuOptions = [];
                console.log("response", response);
                for (var i = 0; i < response.records.length; i++) {
                    _this.skuOptions.push({ skuName: response.records[i]['skuName'], skuCode: response.records[i]['skuCode'], skuID: response.records[i]['skuID'] });
                }
            }).finally(function () {
                if (angular.isDefined(_this.skuOptions) && _this.skuOptions.length == 1) {
                    _this.setSelectedSku(_this.skuOptions[0]);
                }
                else {
                    _this.setCoumpoundSkuName("");
                }
            });
            this.skuPriceService.getPriceGroupOptions().then(function (response) {
                _this.priceGroupOptions = response.records;
                _this.priceGroupOptions.unshift({ priceGroupName: "- Select Price Group -", priceGroupID: "" });
            }).finally(function () {
                if (angular.isDefined(_this.priceGroupOptions) && _this.priceGroupOptions.length) {
                    _this.selectedPriceGroup = _this.priceGroupOptions[0];
                    _this.priceGroupEditable = true;
                }
            });
            this.skuPriceService.getCurrencyOptions().then(function (response) {
                if (response.records.length) {
                    _this.currencyCodeOptions = [];
                    for (var i = 0; i < response.records.length; i++) {
                        _this.currencyCodeOptions.push(response.records[i]['currencyCode']);
                    }
                    _this.currencyCodeOptions.unshift("- Select Currency Code -");
                    _this.selectedCurrencyCode = _this.currencyCodeOptions[0];
                }
            });
        }
    };
    return SWSkuPriceModalController;
}());
exports.SWSkuPriceModalController = SWSkuPriceModalController;
var SWSkuPriceModal = /** @class */ (function () {
    function SWSkuPriceModal() {
        this.template = __webpack_require__("Qfls");
        this.transclude = true;
        this.restrict = 'EA';
        this.require = {
            ngForm: '?ngForm'
        };
        this.scope = {};
        this.bindToController = {
            sku: "=?",
            pageRecord: "=?",
            productId: "@?",
            promotionRewardId: "@?",
            minQuantity: "@?",
            maxQuantity: "@?",
            priceGroupId: "@?",
            currencyCode: "@?",
            eligibleCurrencyCodeList: "@?",
            defaultCurrencyOnly: "=?",
            skuCollectionConfig: "@?",
            disableAllFieldsButPrice: "=?"
        };
        this.controller = SWSkuPriceModalController;
        this.controllerAs = "swSkuPriceModal";
    }
    ;
    SWSkuPriceModal.Factory = function () {
        var _this = this;
        return function () { return new _this(); };
    };
    return SWSkuPriceModal;
}());
exports.SWSkuPriceModal = SWSkuPriceModal;


/***/ }),

/***/ "npj8":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
exports.SWOrderTemplateUpcomingOrdersCard = void 0;
/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
var SWOrderTemplateUpcomingOrdersCardController = /** @class */ (function () {
    function SWOrderTemplateUpcomingOrdersCardController($timeout, $hibachi, observerService, orderTemplateService, rbkeyService) {
        var _this = this;
        this.$timeout = $timeout;
        this.$hibachi = $hibachi;
        this.observerService = observerService;
        this.orderTemplateService = orderTemplateService;
        this.rbkeyService = rbkeyService;
        this.includeModal = true;
        this.updateSchedule = function (data) {
            if (data == null)
                return;
            if (data.frequencyTerm != null) {
                _this.frequencyTerm = null;
                _this.$timeout(function () {
                    _this.frequencyTerm = data.frequencyTerm;
                });
            }
            if (data.scheduleOrderNextPlaceDateTime != null) {
                _this.startDate = null;
                _this.$timeout(function () {
                    _this.setStartDate(Date.parse(data.scheduleOrderNextPlaceDateTime));
                });
            }
        };
        this.observerService.attach(this.updateSchedule, 'OrderTemplateUpdateScheduleSuccess');
        this.observerService.attach(this.updateSchedule, 'OrderTemplateUpdateFrequencySuccess');
        if (this.title == null) {
            this.title = this.rbkeyService.rbKey('entity.orderTemplate.scheduledOrderDates');
        }
        if (this.startDate == null &&
            this.scheduledOrderDates != null &&
            this.scheduledOrderDates.length) {
            var firstDate = this.scheduledOrderDates.split(',')[0];
            this.setStartDate(Date.parse(firstDate));
        }
        if (this.orderTemplate['orderTemplateStatusType_systemCode'] === 'otstCancelled') {
            this.includeModal = false;
        }
    }
    SWOrderTemplateUpcomingOrdersCardController.prototype.setStartDate = function (date) {
        this.startDate = date;
        this.startDateFormatted = (this.startDate.getMonth() + 1) + '/' +
            this.startDate.getDate() + '/' +
            this.startDate.getFullYear();
    };
    return SWOrderTemplateUpcomingOrdersCardController;
}());
var SWOrderTemplateUpcomingOrdersCard = /** @class */ (function () {
    function SWOrderTemplateUpcomingOrdersCard(orderPartialsPath, slatwallPathBuilder, $hibachi, rbkeyService) {
        this.orderPartialsPath = orderPartialsPath;
        this.slatwallPathBuilder = slatwallPathBuilder;
        this.$hibachi = $hibachi;
        this.rbkeyService = rbkeyService;
        this.scope = {};
        this.bindToController = {
            orderTemplate: '<?',
            scheduledOrderDates: '@',
            frequencyTerm: '<?',
            title: "@?"
        };
        this.controller = SWOrderTemplateUpcomingOrdersCardController;
        this.controllerAs = "swOrderTemplateUpcomingOrdersCard";
        this.link = function (scope, element, attrs) {
        };
        this.templateUrl = slatwallPathBuilder.buildPartialsPath(orderPartialsPath) + "/ordertemplateupcomingorderscard.html";
        this.restrict = "EA";
    }
    SWOrderTemplateUpcomingOrdersCard.Factory = function () {
        var directive = function (orderPartialsPath, slatwallPathBuilder, $hibachi, rbkeyService) { return new SWOrderTemplateUpcomingOrdersCard(orderPartialsPath, slatwallPathBuilder, $hibachi, rbkeyService); };
        directive.$inject = [
            'orderPartialsPath',
            'slatwallPathBuilder',
            '$hibachi',
            'rbkeyService'
        ];
        return directive;
    };
    return SWOrderTemplateUpcomingOrdersCard;
}());
exports.SWOrderTemplateUpcomingOrdersCard = SWOrderTemplateUpcomingOrdersCard;


/***/ }),

/***/ "o54M":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
exports.SWCustomerAccountPaymentMethodCard = void 0;
/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
var SWCustomerAccountPaymentMethodCardController = /** @class */ (function () {
    function SWCustomerAccountPaymentMethodCardController($hibachi, observerService, orderTemplateService, rbkeyService, ModalService) {
        var _this = this;
        this.$hibachi = $hibachi;
        this.observerService = observerService;
        this.orderTemplateService = orderTemplateService;
        this.rbkeyService = rbkeyService;
        this.ModalService = ModalService;
        this.billingAddressTitle = "Billing Address";
        this.paymentTitle = "Payment";
        this.includeModal = true;
        this.updateBillingInfo = function (data) {
            if (data == null)
                return;
            if (data['account.accountAddressOptions'] != null) {
                _this.accountAddressOptions = data['account.accountAddressOptions'];
            }
            if (data['account.accountPaymentMethodOptions'] != null &&
                data.billingAccountAddress != null &&
                data.accountPaymentMethod != null) {
                _this.accountPaymentMethodOptions = data['account.accountPaymentMethodOptions'];
                _this.billingAccountAddress = data.billingAccountAddress;
                _this.accountPaymentMethod = data.accountPaymentMethod;
                _this.modalButtonText = _this.rbkeyService.rbKey('define.update') + ' ' + _this.title;
            }
            for (var i = 0; i < _this.propertiesToDisplay.length; i++) {
                var propertyIdentifier = _this.propertiesToDisplay[i];
                if (data[propertyIdentifier] != null) {
                    _this.baseEntity[propertyIdentifier] = data[propertyIdentifier];
                }
                if (data['orderTemplate.' + propertyIdentifier] != null) {
                    _this.baseEntity[propertyIdentifier] = data['orderTemplate.' + propertyIdentifier];
                }
            }
            if (data.addressID) {
                for (var key in data) {
                    _this.billingAccountAddress["address_" + key] = data[key];
                }
            }
        };
        this.addressVerificationCheck = function (_a) {
            var billingAccountAddress = _a.billingAccountAddress;
            if (!billingAccountAddress) {
                return;
            }
            try {
                var addressVerification = JSON.parse(billingAccountAddress.address_verificationJson);
                if (addressVerification && addressVerification.hasOwnProperty('success') && !addressVerification.success && addressVerification.hasOwnProperty('suggestedAddress')) {
                    _this.launchAddressModal([addressVerification.address, addressVerification.suggestedAddress]);
                }
            }
            catch (e) {
                console.log(e);
            }
        };
        this.observerService.attach(this.updateBillingInfo, 'OrderTemplateUpdateShippingSuccess');
        this.observerService.attach(this.updateBillingInfo, 'OrderTemplateUpdateBillingSuccess');
        this.observerService.attach(this.updateBillingInfo, 'OrderTemplateAddOrderTemplateItemSuccess');
        this.observerService.attach(this.updateBillingInfo, 'OrderTemplateRemoveOrderTemplateItemSuccess');
        this.observerService.attach(this.updateBillingInfo, 'OrderTemplateItemSaveSuccess');
        this.observerService.attach(this.addressVerificationCheck, 'OrderTemplateUpdateBillingSuccess');
        this.title = this.rbkeyService.rbKey('define.billing');
        if (this.propertiesToDisplayList == null) {
            this.propertiesToDisplayList = 'calculatedFulfillmentTotal,calculatedFulfillmentDiscount,calculatedSubTotal,calculatedTotal';
        }
        else {
            this.orderTemplateService.setOrderTemplatePropertyIdentifierList(this.propertiesToDisplayList);
        }
        this.propertiesToDisplay = this.propertiesToDisplayList.split(',');
        if (this.billingAccountAddress != null && this.accountPaymentMethod != null) {
            this.modalButtonText = this.rbkeyService.rbKey('define.update') + ' ' + this.title;
        }
        else {
            this.modalButtonText = this.rbkeyService.rbKey('define.add') + ' ' + this.title;
        }
        if (this.baseEntityName === 'OrderTemplate' && this.baseEntity['orderTemplateStatusType_systemCode'] === 'otstCancelled') {
            this.includeModal = false;
        }
    }
    SWCustomerAccountPaymentMethodCardController.prototype.launchAddressModal = function (addresses) {
        var _this = this;
        this.ModalService.showModal({
            component: 'swAddressVerification',
            bodyClass: 'angular-modal-service-active',
            bindings: {
                suggestedAddresses: addresses,
                sAction: this.updateBillingInfo,
                propertyIdentifiersList: 'addressID,firstName,lastName,streetAddress,street2Address,city,stateCode,postalCode,countryCode'
            },
            preClose: function (modal) {
                modal.element.modal('hide');
                _this.ModalService.closeModals();
            },
        })
            .then(function (modal) {
            //it's a bootstrap element, use 'modal' to show it
            modal.element.modal();
            modal.close.then(function (result) { });
        })
            .catch(function (error) {
            console.error('unable to open model :', error);
        });
    };
    return SWCustomerAccountPaymentMethodCardController;
}());
var SWCustomerAccountPaymentMethodCard = /** @class */ (function () {
    function SWCustomerAccountPaymentMethodCard(orderPartialsPath, slatwallPathBuilder, $hibachi, rbkeyService) {
        this.orderPartialsPath = orderPartialsPath;
        this.slatwallPathBuilder = slatwallPathBuilder;
        this.$hibachi = $hibachi;
        this.rbkeyService = rbkeyService;
        this.restrict = "EA";
        this.scope = {};
        this.bindToController = {
            accountAddressOptions: "<",
            accountPaymentMethod: "<",
            accountPaymentMethodOptions: "<",
            billingAccountAddress: "<?",
            baseEntityName: "@?",
            baseEntity: "<",
            countryCodeOptions: "<",
            defaultCountryCode: "@?",
            expirationMonthOptions: "<",
            expirationYearOptions: "<",
            stateCodeOptions: "<",
            propertiesToDisplayList: "@?",
            title: "@?"
        };
        this.controller = SWCustomerAccountPaymentMethodCardController;
        this.controllerAs = "swCustomerAccountPaymentMethodCard";
        this.link = function (scope, element, attrs) {
        };
        this.templateUrl = slatwallPathBuilder.buildPartialsPath(orderPartialsPath) + "/customeraccountpaymentmethodcard.html";
    }
    SWCustomerAccountPaymentMethodCard.Factory = function () {
        var directive = function (orderPartialsPath, slatwallPathBuilder, $hibachi, rbkeyService) { return new SWCustomerAccountPaymentMethodCard(orderPartialsPath, slatwallPathBuilder, $hibachi, rbkeyService); };
        directive.$inject = [
            'orderPartialsPath',
            'slatwallPathBuilder',
            '$hibachi',
            'rbkeyService'
        ];
        return directive;
    };
    return SWCustomerAccountPaymentMethodCard;
}());
exports.SWCustomerAccountPaymentMethodCard = SWCustomerAccountPaymentMethodCard;


/***/ }),

/***/ "o9Wo":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
exports.SWOrderTemplateFrequencyModal = void 0;
/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
var SWOrderTemplateFrequencyModalController = /** @class */ (function () {
    function SWOrderTemplateFrequencyModalController($timeout, $hibachi, entityService, observerService, orderTemplateService, rbkeyService, requestService) {
        var _this = this;
        this.$timeout = $timeout;
        this.$hibachi = $hibachi;
        this.entityService = entityService;
        this.observerService = observerService;
        this.orderTemplateService = orderTemplateService;
        this.rbkeyService = rbkeyService;
        this.requestService = requestService;
        this.processContext = 'updateFrequency';
        this.uniqueName = 'frequencyModal';
        this.formName = 'frequencyModal';
        //rb key properties
        this.title = "Update Frequency";
        this.$onInit = function () {
            _this.orderTemplate = _this.swOrderTemplateFrequencyCard.orderTemplate;
            _this.frequencyTermOptions = _this.swOrderTemplateFrequencyCard.frequencyTermOptions;
            if (_this.swOrderTemplateFrequencyCard.frequencyTerm != null) {
                for (var i = 0; i < _this.frequencyTermOptions.length; i++) {
                    if (_this.swOrderTemplateFrequencyCard.frequencyTerm.termID === _this.frequencyTermOptions[i].value) {
                        _this.orderTemplate.frequencyTerm = _this.frequencyTermOptions[i];
                        break;
                    }
                }
            }
            else {
                _this.orderTemplate.frequencyTerm = _this.frequencyTermOptions[0];
            }
        };
        this.save = function () {
            var formDataToPost = {
                entityID: _this.orderTemplate.orderTemplateID,
                entityName: 'OrderTemplate',
                context: _this.processContext,
                propertyIdentifiersList: 'frequencyTerm'
            };
            formDataToPost.frequencyTerm = _this.orderTemplate.frequencyTerm;
            var processUrl = _this.$hibachi.buildUrl('api:main.post');
            var adminRequest = _this.requestService.newAdminRequest(processUrl, formDataToPost);
            return adminRequest.promise;
        };
    }
    return SWOrderTemplateFrequencyModalController;
}());
var SWOrderTemplateFrequencyModal = /** @class */ (function () {
    function SWOrderTemplateFrequencyModal(orderPartialsPath, slatwallPathBuilder, $hibachi, rbkeyService) {
        this.orderPartialsPath = orderPartialsPath;
        this.slatwallPathBuilder = slatwallPathBuilder;
        this.$hibachi = $hibachi;
        this.rbkeyService = rbkeyService;
        this.scope = {};
        this.bindToController = {
            modalButtonText: "@?"
        };
        this.require = {
            swOrderTemplateFrequencyCard: "^^swOrderTemplateFrequencyCard"
        };
        this.controller = SWOrderTemplateFrequencyModalController;
        this.controllerAs = "swOrderTemplateFrequencyModal";
        this.link = function (scope, element, attrs) {
        };
        this.templateUrl = slatwallPathBuilder.buildPartialsPath(orderPartialsPath) + "/ordertemplatefrequencymodal.html";
        this.restrict = "EA";
    }
    SWOrderTemplateFrequencyModal.Factory = function () {
        var directive = function (orderPartialsPath, slatwallPathBuilder, $hibachi, rbkeyService) { return new SWOrderTemplateFrequencyModal(orderPartialsPath, slatwallPathBuilder, $hibachi, rbkeyService); };
        directive.$inject = [
            'orderPartialsPath',
            'slatwallPathBuilder',
            '$hibachi',
            'rbkeyService'
        ];
        return directive;
    };
    return SWOrderTemplateFrequencyModal;
}());
exports.SWOrderTemplateFrequencyModal = SWOrderTemplateFrequencyModal;


/***/ }),

/***/ "omOO":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
exports.SWOrderTemplateItems = void 0;
/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
var SWOrderTemplateItemsController = /** @class */ (function () {
    function SWOrderTemplateItemsController($hibachi, collectionConfigService, observerService, orderTemplateService, rbkeyService) {
        var _this = this;
        this.$hibachi = $hibachi;
        this.collectionConfigService = collectionConfigService;
        this.observerService = observerService;
        this.orderTemplateService = orderTemplateService;
        this.rbkeyService = rbkeyService;
        this.$onInit = function () {
            _this.observerService.attach(_this.setEdit, 'swEntityActionBar');
            _this.orderTemplateService.setOrderTemplate(_this.orderTemplate);
            if (_this.skuPropertiesToDisplay != null) {
                _this.orderTemplateService.setAdditionalSkuPropertiesToDisplay(_this.skuPropertiesToDisplay);
            }
            _this.orderTemplateService.setSkuPropertyColumnConfigs(_this.skuPropertyColumnConfigs);
            if (_this.additionalOrderTemplateItemPropertiesToDisplay != null) {
                _this.orderTemplateService.setAdditionalOrderTemplateItemPropertiesToDisplay(_this.additionalOrderTemplateItemPropertiesToDisplay);
            }
            _this.viewOrderTemplateItemsCollection = _this.orderTemplateService.getViewOrderTemplateItemCollection();
            _this.editOrderTemplateItemsCollection = _this.orderTemplateService.getEditOrderTemplateItemCollection();
            _this.addSkuCollection = _this.orderTemplateService.getAddSkuCollection();
            if (angular.isDefined(_this.siteId)) {
                _this.addSkuCollection.addFilter('product.sites.siteID', _this.siteId, '=', undefined, true);
            }
            if (angular.isDefined(_this.additionalFilters)) {
                for (var _i = 0, _a = _this.additionalFilters; _i < _a.length; _i++) {
                    var filter = _a[_i];
                    _this.addSkuCollection.addFilter(filter.propertyIdentifier, filter.value, filter.comparisonOperator);
                }
            }
            _this.skuColumns = angular.copy(_this.addSkuCollection.getCollectionConfig().columns);
            _this.editOrderTemplateColumns = angular.copy(_this.viewOrderTemplateItemsCollection.getCollectionConfig().columns);
            _this.viewOrderTemplateColumns = angular.copy(_this.editOrderTemplateItemsCollection.getCollectionConfig().columns);
            _this.skuColumns.push({
                'title': _this.rbkeyService.rbKey('define.quantity'),
                'propertyIdentifier': 'quantity',
                'type': 'number',
                'defaultValue': 1,
                'isCollectionColumn': false,
                'isEditable': true,
                'isVisible': true
            });
        };
        this.setEdit = function (payload) {
            _this.edit = payload.edit;
        };
        if (this.edit == null) {
            this.edit = false;
        }
    }
    return SWOrderTemplateItemsController;
}());
var SWOrderTemplateItems = /** @class */ (function () {
    function SWOrderTemplateItems(orderPartialsPath, slatwallPathBuilder, $hibachi, rbkeyService) {
        this.orderPartialsPath = orderPartialsPath;
        this.slatwallPathBuilder = slatwallPathBuilder;
        this.$hibachi = $hibachi;
        this.rbkeyService = rbkeyService;
        this.restrict = "EA";
        this.scope = {};
        this.bindToController = {
            additionalOrderTemplateItemPropertiesToDisplay: '@?',
            additionalFilters: '<?',
            currencyCode: '@?',
            edit: "=?",
            orderTemplate: '<?',
            siteId: '@?',
            skuPropertiesToDisplay: '@?',
            skuPropertyColumnConfigs: '<?' //array of column configs
        };
        this.controller = SWOrderTemplateItemsController;
        this.controllerAs = "swOrderTemplateItems";
        this.link = function (scope, element, attrs) {
        };
        this.templateUrl = slatwallPathBuilder.buildPartialsPath(orderPartialsPath) + "/ordertemplateitems.html";
    }
    SWOrderTemplateItems.Factory = function () {
        var directive = function (orderPartialsPath, slatwallPathBuilder, $hibachi, rbkeyService) { return new SWOrderTemplateItems(orderPartialsPath, slatwallPathBuilder, $hibachi, rbkeyService); };
        directive.$inject = [
            'orderPartialsPath',
            'slatwallPathBuilder',
            '$hibachi',
            'rbkeyService'
        ];
        return directive;
    };
    return SWOrderTemplateItems;
}());
exports.SWOrderTemplateItems = SWOrderTemplateItems;


/***/ }),

/***/ "p/l7":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
exports.SWOrderTemplateFrequencyCard = void 0;
/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
var SWOrderTemplateFrequencyCardController = /** @class */ (function () {
    function SWOrderTemplateFrequencyCardController($hibachi, observerService, orderTemplateService, rbkeyService) {
        var _this = this;
        this.$hibachi = $hibachi;
        this.observerService = observerService;
        this.orderTemplateService = orderTemplateService;
        this.rbkeyService = rbkeyService;
        this.includeModal = true;
        this.refreshFrequencyTerm = function (data) {
            _this.frequencyTerm = data.frequencyTerm;
        };
        this.observerService.attach(this.refreshFrequencyTerm, 'OrderTemplateUpdateFrequencySuccess');
        if (this.orderTemplate['orderTemplateStatusType_systemCode'] === 'otstCancelled') {
            this.includeModal = false;
        }
    }
    return SWOrderTemplateFrequencyCardController;
}());
var SWOrderTemplateFrequencyCard = /** @class */ (function () {
    function SWOrderTemplateFrequencyCard(orderPartialsPath, slatwallPathBuilder, $hibachi, rbkeyService) {
        this.orderPartialsPath = orderPartialsPath;
        this.slatwallPathBuilder = slatwallPathBuilder;
        this.$hibachi = $hibachi;
        this.rbkeyService = rbkeyService;
        this.scope = {};
        this.bindToController = {
            orderTemplate: '<',
            frequencyTerm: '<?',
            frequencyTermOptions: '<'
        };
        this.controller = SWOrderTemplateFrequencyCardController;
        this.controllerAs = "swOrderTemplateFrequencyCard";
        this.link = function (scope, element, attrs) {
        };
        this.templateUrl = slatwallPathBuilder.buildPartialsPath(orderPartialsPath) + "/ordertemplatefrequencycard.html";
        this.restrict = "EA";
    }
    SWOrderTemplateFrequencyCard.Factory = function () {
        var directive = function (orderPartialsPath, slatwallPathBuilder, $hibachi, rbkeyService) { return new SWOrderTemplateFrequencyCard(orderPartialsPath, slatwallPathBuilder, $hibachi, rbkeyService); };
        directive.$inject = [
            'orderPartialsPath',
            'slatwallPathBuilder',
            '$hibachi',
            'rbkeyService'
        ];
        return directive;
    };
    return SWOrderTemplateFrequencyCard;
}());
exports.SWOrderTemplateFrequencyCard = SWOrderTemplateFrequencyCard;


/***/ }),

/***/ "piNt":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
Object.defineProperty(exports, "__esModule", { value: true });
exports.SWProductListingPages = exports.SWProductListingPagesController = void 0;
var SWProductListingPagesController = /** @class */ (function () {
    //@ngInject
    SWProductListingPagesController.$inject = ["collectionConfigService", "listingService", "utilityService"];
    function SWProductListingPagesController(collectionConfigService, listingService, utilityService) {
        this.collectionConfigService = collectionConfigService;
        this.listingService = listingService;
        this.utilityService = utilityService;
        this.collectionConfig = collectionConfigService.newCollectionConfig("Content");
        this.collectionConfig.addDisplayProperty("contentID, title, activeFlag, site.siteName, titlePath");
        this.typeaheadDataKey = utilityService.createID(32);
        this.alreadySelectedContentCollectionConfig = collectionConfigService.newCollectionConfig("ProductListingPage");
        this.alreadySelectedContentCollectionConfig.addDisplayProperty("productListingPageID, product.productID, content.contentID, content.title, content.site.siteName, content.activeFlag");
        this.alreadySelectedContentCollectionConfig.addFilter("product.productID", this.productId, "=");
    }
    return SWProductListingPagesController;
}());
exports.SWProductListingPagesController = SWProductListingPagesController;
var SWProductListingPages = /** @class */ (function () {
    //@ngInject
    SWProductListingPages.$inject = ["$http", "$hibachi", "paginationService", "productPartialsPath", "slatwallPathBuilder"];
    function SWProductListingPages($http, $hibachi, paginationService, productPartialsPath, slatwallPathBuilder) {
        this.$http = $http;
        this.$hibachi = $hibachi;
        this.paginationService = paginationService;
        this.productPartialsPath = productPartialsPath;
        this.slatwallPathBuilder = slatwallPathBuilder;
        this.restrict = "EA";
        this.scope = {};
        this.bindToController = {
            edit: "=?",
            selectedListingPageIdPaths: "@?",
            productId: "@?"
        };
        this.controller = SWProductListingPagesController;
        this.controllerAs = "swProductListingPages";
        this.link = function ($scope, element, attrs) {
        };
        this.templateUrl = slatwallPathBuilder.buildPartialsPath(productPartialsPath) + "/productlistingpages.html";
    }
    SWProductListingPages.Factory = function () {
        var directive = function ($http, $hibachi, paginationService, productPartialsPath, slatwallPathBuilder) { return new SWProductListingPages($http, $hibachi, paginationService, productPartialsPath, slatwallPathBuilder); };
        directive.$inject = [
            '$http',
            '$hibachi',
            'paginationService',
            'productPartialsPath',
            'slatwallPathBuilder'
        ];
        return directive;
    };
    return SWProductListingPages;
}());
exports.SWProductListingPages = SWProductListingPages;


/***/ }),

/***/ "sE5k":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
exports.SWOrderTemplateAddPromotionModal = void 0;
/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
var SWOrderTemplateAddPromotionModalController = /** @class */ (function () {
    function SWOrderTemplateAddPromotionModalController($hibachi, collectionConfigService, observerService, orderTemplateService, requestService, rbkeyService) {
        var _this = this;
        this.$hibachi = $hibachi;
        this.collectionConfigService = collectionConfigService;
        this.observerService = observerService;
        this.orderTemplateService = orderTemplateService;
        this.requestService = requestService;
        this.rbkeyService = rbkeyService;
        this.processContext = 'addPromotionCode';
        this.title = 'Add Promotion';
        this.modalButtonText = 'Add Promotion';
        this.$onInit = function () {
            _this.promotionCode = '';
            if (_this.orderTemplate != null) {
                _this.baseEntityPrimaryID = _this.orderTemplate.orderTemplateID;
                _this.baseEntityName = 'OrderTemplate';
            }
        };
        this.save = function () {
            var formDataToPost = {
                entityID: _this.baseEntityPrimaryID,
                entityName: _this.baseEntityName,
                context: _this.processContext,
                propertyIdentifiersList: ''
            };
            formDataToPost.promotionCode = _this.promotionCode;
            var processUrl = _this.$hibachi.buildUrl('api:main.post');
            var adminRequest = _this.requestService.newAdminRequest(processUrl, formDataToPost);
            return adminRequest.promise;
        };
        this.observerService.attach(this.$onInit, 'OrderTemplateAddPromotionCodeSuccess');
    }
    return SWOrderTemplateAddPromotionModalController;
}());
var SWOrderTemplateAddPromotionModal = /** @class */ (function () {
    function SWOrderTemplateAddPromotionModal(orderPartialsPath, slatwallPathBuilder, $hibachi, rbkeyService) {
        this.orderPartialsPath = orderPartialsPath;
        this.slatwallPathBuilder = slatwallPathBuilder;
        this.$hibachi = $hibachi;
        this.rbkeyService = rbkeyService;
        this.restrict = "EA";
        this.scope = {};
        this.bindToController = {
            orderTemplate: '<?'
        };
        this.controller = SWOrderTemplateAddPromotionModalController;
        this.controllerAs = "swOrderTemplatePromotions";
        this.link = function (scope, element, attrs) {
        };
        this.templateUrl = slatwallPathBuilder.buildPartialsPath(orderPartialsPath) + "/ordertemplateaddpromotionmodal.html";
    }
    SWOrderTemplateAddPromotionModal.Factory = function () {
        var directive = function (orderPartialsPath, slatwallPathBuilder, $hibachi, rbkeyService) { return new SWOrderTemplateAddPromotionModal(orderPartialsPath, slatwallPathBuilder, $hibachi, rbkeyService); };
        directive.$inject = [
            'orderPartialsPath',
            'slatwallPathBuilder',
            '$hibachi',
            'rbkeyService'
        ];
        return directive;
    };
    return SWOrderTemplateAddPromotionModal;
}());
exports.SWOrderTemplateAddPromotionModal = SWOrderTemplateAddPromotionModal;


/***/ }),

/***/ "sjkZ":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
Object.defineProperty(exports, "__esModule", { value: true });
exports.SWProductBundleCollectionFilterItemTypeahead = exports.SWProductBundleCollectionFilterItemTypeaheadController = void 0;
var CollectionFilterItem = /** @class */ (function () {
    function CollectionFilterItem(name, type, displayPropertyIdentifier, propertyIdentifier, displayValue, value, comparisonOperator, logicalOperator) {
        this.name = name;
        this.type = type;
        this.displayPropertyIdentifier = displayPropertyIdentifier;
        this.propertyIdentifier = propertyIdentifier;
        this.displayValue = displayValue;
        this.value = value;
        this.comparisonOperator = comparisonOperator;
        this.logicalOperator = logicalOperator;
    }
    return CollectionFilterItem;
}());
var SWProductBundleCollectionFilterItemTypeaheadController = /** @class */ (function () {
    // @ngInject
    SWProductBundleCollectionFilterItemTypeaheadController.$inject = ["$log", "$timeout", "collectionConfigService", "productBundleService", "metadataService", "utilityService", "formService", "$hibachi", "productBundlePartialsPath"];
    function SWProductBundleCollectionFilterItemTypeaheadController($log, $timeout, collectionConfigService, productBundleService, metadataService, utilityService, formService, $hibachi, productBundlePartialsPath) {
        var _this = this;
        this.$log = $log;
        this.$timeout = $timeout;
        this.collectionConfigService = collectionConfigService;
        this.productBundleService = productBundleService;
        this.metadataService = metadataService;
        this.utilityService = utilityService;
        this.formService = formService;
        this.$hibachi = $hibachi;
        this.productBundlePartialsPath = productBundlePartialsPath;
        this.init = function () {
            _this.maxRecords = 10;
            _this.recordsCount = 0;
            _this.pageRecordsStart = 0;
            _this.pageRecordsEnd = 0;
            _this.recordsPerPage = 10;
            _this.showAll = false;
            _this.showAdvanced = false;
            _this.currentPage = 1;
            _this.pageShow = 10;
            _this.searchAllCollectionConfigs = [];
            if (angular.isUndefined(_this.filterPropertiesList)) {
                _this.filterPropertiesList = {};
                var filterPropertiesPromise = _this.$hibachi.getFilterPropertiesByBaseEntityName('_sku');
                filterPropertiesPromise.then(function (value) {
                    _this.metadataService.setPropertiesList(value, '_sku');
                    _this.filterPropertiesList['_sku'] = _this.metadataService.getPropertiesListByBaseEntityAlias('_sku');
                    _this.metadataService.formatPropertiesList(_this.filterPropertiesList['_sku'], '_sku');
                });
            }
            _this.skuCollectionConfig = {
                baseEntityName: "Sku",
                baseEntityAlias: "_sku",
                collectionConfig: _this.productBundleGroup.data.skuCollectionConfig,
                collectionObject: 'Sku'
            };
            _this.searchOptions = {
                options: [
                    {
                        name: "All",
                        value: "All"
                    },
                    {
                        name: "Product Type",
                        value: "productType"
                    },
                    {
                        name: "Brand",
                        value: "brand"
                    },
                    {
                        name: "Products",
                        value: "product"
                    },
                    {
                        name: "Skus",
                        value: "sku"
                    }
                ],
                selected: {
                    name: "All",
                    value: "All"
                },
                setSelected: function (searchOption) {
                    _this.searchOptions.selected = searchOption;
                    _this.getFiltersByTerm(_this.productBundleGroupFilters.keyword, searchOption);
                }
            };
            _this.navigation = {
                value: 'Basic',
                setValue: function (value) {
                    _this.value = value;
                }
            };
            _this.filterTemplatePath = _this.productBundlePartialsPath + "productbundlefilter.html";
            _this.productBundleGroupFilters = {};
            _this.productBundleGroupFilters.value = [];
            if (angular.isUndefined(_this.productBundleGroup.data.skuCollectionConfig)) {
                _this.productBundleGroup.data.skuCollectionConfig = {};
                _this.productBundleGroup.data.skuCollectionConfig.filterGroups = [];
            }
            if (!angular.isDefined(_this.productBundleGroup.data.skuCollectionConfig.filterGroups[0])) {
                _this.productBundleGroup.data.skuCollectionConfig.filterGroups[0] = {};
                _this.productBundleGroup.data.skuCollectionConfig.filterGroups[0].filterGroup = [];
            }
            var options = {
                filterGroupsConfig: _this.productBundleGroup.data.skuCollectionConfig.filterGroups[0].filterGroup,
                columnsConfig: _this.productBundleGroup.data.skuCollectionConfig.columns,
            };
            _this.getCollection();
        };
        this.openCloseAndRefresh = function () {
            _this.showAdvanced = !_this.showAdvanced;
            if (_this.productBundleGroup.data.skuCollectionConfig.filterGroups[0].filterGroup.length) {
                _this.getCollection();
            }
        };
        this.deleteEntity = function (type) {
            if (angular.isNumber(type)) {
                _this.removeProductBundleGroupFilter(type);
            }
            else {
                _this.removeProductBundleGroup({ index: _this.index });
                _this.productBundleGroup.data.skuCollectionConfig.filterGroups[0].filterGroup = [];
            }
        };
        this.getCollection = function () {
            var options = {
                filterGroupsConfig: angular.toJson(_this.productBundleGroup.data.skuCollectionConfig.filterGroups),
                columnsConfig: angular.toJson(_this.productBundleGroup.data.skuCollectionConfig.columns),
                currentPage: 1,
                pageShow: 10
            };
            var collectionPromise = _this.$hibachi.getEntity('Sku', options);
            collectionPromise.then(function (response) {
                _this.collection = response;
            });
        };
        this.increaseCurrentCount = function () {
            if (angular.isDefined(_this.totalPages) && _this.totalPages != _this.currentPage) {
                _this.currentPage++;
            }
            else {
                _this.currentPage = 1;
            }
        };
        this.resetCurrentCount = function () {
            _this.currentPage = 1;
        };
        this.getFiltersByTerm = function (keyword, filterTerm) {
            //save search
            _this.keyword = keyword;
            _this.filterTerm = filterTerm;
            _this.loading = true;
            _this.showAll = true;
            var _loadingCount;
            if (_this.timeoutPromise) {
                _this.$timeout.cancel(_this.timeoutPromise);
            }
            _this.timeoutPromise = _this.$timeout(function () {
                if (filterTerm.value === 'All') {
                    _this.showAll = true;
                    _this.productBundleGroupFilters.value = [];
                    _loadingCount = _this.searchOptions.options.length - 1;
                    for (var i = 0; i < _this.searchOptions.options.length; i++) {
                        if (i > 0) {
                            var option = _this.searchOptions.options[i];
                            (function (keyword, option) {
                                if (_this.searchAllCollectionConfigs.length <= 4) {
                                    _this.searchAllCollectionConfigs.push(_this.collectionConfigService.newCollectionConfig(_this.searchOptions.options[i].value));
                                }
                                _this.searchAllCollectionConfigs[i - 1].setKeywords(keyword);
                                _this.searchAllCollectionConfigs[i - 1].setCurrentPage(_this.currentPage);
                                _this.searchAllCollectionConfigs[i - 1].setPageShow(_this.pageShow);
                                //searchAllCollectionConfig.setAllRecords(true);
                                _this.searchAllCollectionConfigs[i - 1].getEntity().then(function (value) {
                                    _this.recordsCount = value.recordsCount;
                                    _this.pageRecordsStart = value.pageRecordsStart;
                                    _this.pageRecordsEnd = value.pageRecordsEnd;
                                    _this.totalPages = value.totalPages;
                                    var formattedProductBundleGroupFilters = _this.productBundleService.formatProductBundleGroupFilters(value.pageRecords, option, _this.productBundleGroup.data.skuCollectionConfig.filterGroups[0].filterGroup);
                                    for (var j in formattedProductBundleGroupFilters) {
                                        if (_this.productBundleGroup.data.skuCollectionConfig.filterGroups[0].filterGroup.indexOf(formattedProductBundleGroupFilters[j]) == -1) {
                                            _this.productBundleGroupFilters.value.push(formattedProductBundleGroupFilters[j]);
                                            _this.$log.debug(formattedProductBundleGroupFilters[j]);
                                        }
                                    }
                                    // Increment Down The Loading Count
                                    _loadingCount--;
                                    // If the loadingCount drops to 0, then we can update scope
                                    if (_loadingCount == 0) {
                                        //This sorts the array of objects by the objects' "type" property alphabetically
                                        _this.productBundleGroupFilters.value = _this.utilityService.arraySorter(_this.productBundleGroupFilters.value, ["type", "name"]);
                                        _this.$log.debug(_this.productBundleGroupFilters.value);
                                        if (_this.productBundleGroupFilters.value.length == 0) {
                                            _this.currentPage = 0;
                                        }
                                    }
                                    _this.loading = false;
                                });
                            })(keyword, option);
                        }
                    }
                }
                else {
                    _this.showAll = false;
                    if (angular.isUndefined(_this.searchCollectionConfig) || filterTerm.value != _this.searchCollectionConfig.baseEntityName) {
                        _this.searchCollectionConfig = _this.collectionConfigService.newCollectionConfig(filterTerm.value);
                    }
                    _this.searchCollectionConfig.setKeywords(keyword);
                    _this.searchCollectionConfig.setCurrentPage(_this.currentPage);
                    _this.searchCollectionConfig.setPageShow(_this.pageShow);
                    _this.searchCollectionConfig.getEntity().then(function (value) {
                        _this.recordsCount = value.recordsCount;
                        _this.pageRecordsStart = value.pageRecordsStart;
                        _this.pageRecordsEnd = value.pageRecordsEnd;
                        _this.totalPages = value.totalPages;
                        _this.productBundleGroupFilters.value = _this.productBundleService.formatProductBundleGroupFilters(value.pageRecords, filterTerm, _this.productBundleGroup.data.skuCollectionConfig.filterGroups[0].filterGroup) || [];
                        _this.loading = false;
                    });
                }
            }, 500);
        };
        this.addFilterToProductBundle = function (filterItem, include, index) {
            var collectionFilterItem = new CollectionFilterItem(filterItem.name, filterItem.type, filterItem.type, filterItem.propertyIdentifier, filterItem[filterItem.entityType.charAt(0).toLowerCase() + filterItem.entityType.slice(1) + 'ID'], filterItem[filterItem.entityType.charAt(0).toLowerCase() + filterItem.entityType.slice(1) + 'ID']);
            if (include === false) {
                collectionFilterItem.comparisonOperator = '!=';
            }
            else {
                collectionFilterItem.comparisonOperator = '=';
            }
            if (_this.productBundleGroup.data.skuCollectionConfig.filterGroups[0].filterGroup.length > 0) {
                collectionFilterItem.logicalOperator = 'OR';
            }
            if (angular.isDefined(_this.searchCollectionConfig)) {
                _this.searchCollectionConfig.addFilter(_this.searchCollectionConfig.baseEntityName + "ID", collectionFilterItem.value, "!=");
            }
            if (_this.showAll) {
                switch (collectionFilterItem.type) {
                    case 'Product Type':
                        _this.searchAllCollectionConfigs[0].addFilter("productTypeID", collectionFilterItem.value, "!=");
                        break;
                    case 'Brand':
                        _this.searchAllCollectionConfigs[1].addFilter("brandID", collectionFilterItem.value, "!=");
                        break;
                    case 'Products':
                        _this.searchAllCollectionConfigs[2].addFilter("productID", collectionFilterItem.value, "!=");
                        break;
                    case 'Skus':
                        _this.searchAllCollectionConfigs[3].addFilter("skuID", collectionFilterItem.value, "!=");
                        break;
                }
            }
            _this.productBundleGroup.data.skuCollectionConfig.filterGroups[0].filterGroup.push(collectionFilterItem);
            _this.productBundleGroup.forms[_this.formName].skuCollectionConfig.$setDirty();
            //reload the list to correct pagination show all takes too long for this to be graceful
            if (!_this.showAll) {
                _this.getFiltersByTerm(_this.keyword, _this.filterTerm);
            }
            else {
                //Removes the filter item from the left hand search result
                _this.productBundleGroupFilters.value.splice(index, 1);
            }
        };
        this.removeProductBundleGroupFilter = function (index) {
            //Pushes item back into array
            _this.productBundleGroupFilters.value.push(_this.productBundleGroup.data.skuCollectionConfig.filterGroups[0].filterGroup[index]);
            //Sorts Array
            _this.productBundleGroupFilters.value = _this.utilityService.arraySorter(_this.productBundleGroupFilters.value, ["type", "name"]);
            //Removes the filter item from the filtergroup
            var collectionFilterItem = _this.productBundleGroup.data.skuCollectionConfig.filterGroups[0].filterGroup.splice(index, 1)[0];
            if (angular.isDefined(_this.searchCollectionConfig)) {
                _this.searchCollectionConfig.removeFilter(_this.searchCollectionConfig.baseEntityAlias + '.' + _this.searchCollectionConfig.baseEntityName + "ID", collectionFilterItem.value, "!=");
            }
            if (_this.showAll) {
                switch (collectionFilterItem.type) {
                    case 'Product Type':
                        _this.searchAllCollectionConfigs[0].removeFilter("_productType.productTypeID", collectionFilterItem.value, "!=");
                        break;
                    case 'Brand':
                        _this.searchAllCollectionConfigs[1].removeFilter("_brand.brandID", collectionFilterItem.value, "!=");
                        break;
                    case 'Products':
                        _this.searchAllCollectionConfigs[2].removeFilter("_product.productID", collectionFilterItem.value, "!=");
                        break;
                    case 'Skus':
                        _this.searchAllCollectionConfigs[3].removeFilter("_sku.skuID", collectionFilterItem.value, "!=");
                        break;
                }
            }
            if (!_this.showAll) {
                _this.getFiltersByTerm(_this.keyword, _this.filterTerm);
            }
            else {
                _this.productBundleGroupFilters.value.splice(index, 0, collectionFilterItem);
            }
        };
        this.init();
    }
    return SWProductBundleCollectionFilterItemTypeaheadController;
}());
exports.SWProductBundleCollectionFilterItemTypeaheadController = SWProductBundleCollectionFilterItemTypeaheadController;
var SWProductBundleCollectionFilterItemTypeahead = /** @class */ (function () {
    // @ngInject
    SWProductBundleCollectionFilterItemTypeahead.$inject = ["$log", "$timeout", "collectionConfigService", "productBundleService", "metadataService", "utilityService", "formService", "$hibachi", "productBundlePartialsPath", "slatwallPathBuilder"];
    function SWProductBundleCollectionFilterItemTypeahead($log, $timeout, collectionConfigService, productBundleService, metadataService, utilityService, formService, $hibachi, productBundlePartialsPath, slatwallPathBuilder) {
        this.$log = $log;
        this.$timeout = $timeout;
        this.collectionConfigService = collectionConfigService;
        this.productBundleService = productBundleService;
        this.metadataService = metadataService;
        this.utilityService = utilityService;
        this.formService = formService;
        this.$hibachi = $hibachi;
        this.productBundlePartialsPath = productBundlePartialsPath;
        this.restrict = "EA";
        this.scope = {};
        this.bindToController = {
            productBundleGroup: "=",
            index: "=",
            formName: "@"
        };
        this.controller = SWProductBundleCollectionFilterItemTypeaheadController;
        this.controllerAs = "swProductBundleCollectionFilteritemTypeahead";
        this.link = function ($scope, element, attrs, ctrl) {
        };
        this.templateUrl = slatwallPathBuilder.buildPartialsPath(productBundlePartialsPath) + "productbundlecollectionfilteritemtypeahead.html";
    }
    SWProductBundleCollectionFilterItemTypeahead.Factory = function () {
        var directive = function ($log, $timeout, collectionConfigService, productBundleService, metadataService, utilityService, formService, $hibachi, productBundlePartialsPath, slatwallPathBuilder) { return new SWProductBundleCollectionFilterItemTypeahead($log, $timeout, collectionConfigService, productBundleService, metadataService, utilityService, formService, $hibachi, productBundlePartialsPath, slatwallPathBuilder); };
        directive.$inject = [
            "$log", "$timeout", "collectionConfigService", "productBundleService", "metadataService", "utilityService", "formService", "$hibachi", "productBundlePartialsPath",
            "slatwallPathBuilder"
        ];
        return directive;
    };
    return SWProductBundleCollectionFilterItemTypeahead;
}());
exports.SWProductBundleCollectionFilterItemTypeahead = SWProductBundleCollectionFilterItemTypeahead;


/***/ }),

/***/ "t8vH":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
exports.SlatwallPathBuilder = void 0;
/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
/*services return promises which can be handled uniquely based on success or failure by the controller*/
var SlatwallPathBuilder = /** @class */ (function () {
    //@ngInject
    function SlatwallPathBuilder() {
        var _this = this;
        this.setBaseURL = function (baseURL) {
            _this.baseURL = baseURL;
        };
        this.setBasePartialsPath = function (basePartialsPath) {
            _this.basePartialsPath = basePartialsPath;
        };
        this.buildPartialsPath = function (componentsPath) {
            if (angular.isDefined(_this.baseURL) && angular.isDefined(_this.basePartialsPath)) {
                return _this.baseURL + _this.basePartialsPath + componentsPath;
            }
            else {
                throw ('need to define baseURL and basePartialsPath in hibachiPathBuilder. Inject hibachiPathBuilder into module and configure it there');
            }
        };
    }
    return SlatwallPathBuilder;
}());
exports.SlatwallPathBuilder = SlatwallPathBuilder;


/***/ }),

/***/ "uiTr":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
exports.orderdeliverydetailmodule = void 0;
/// <reference path='../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../typings/tsd.d.ts' />
//modules
var core_module_1 = __webpack_require__("pwA0");
//services
//import {OrderFulfillmentService} from "../orderfulfillment/services/orderfulfillmentservice";
//controllers
//directives
var sworderdeliverydetail_1 = __webpack_require__("lZA8");
var orderdeliverydetailmodule = angular.module('orderdeliverydetail', [core_module_1.coremodule.name])
    .config([function () {
    }]).run([function () {
    }])
    //constants
    .constant('orderDeliveryDetailPartialsPath', 'orderdelivery/components/')
    //services
    //controllers
    //directives
    .directive('swOrderDeliveryDetail', sworderdeliverydetail_1.SWOrderDeliveryDetail.Factory());
exports.orderdeliverydetailmodule = orderdeliverydetailmodule;


/***/ }),

/***/ "uqOV":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
exports.SWAccountShippingAddressCard = void 0;
/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
var SWAccountShippingAddressCardController = /** @class */ (function () {
    function SWAccountShippingAddressCardController($hibachi, observerService, rbkeyService, ModalService) {
        var _this = this;
        this.$hibachi = $hibachi;
        this.observerService = observerService;
        this.rbkeyService = rbkeyService;
        this.ModalService = ModalService;
        this.title = "Shipping";
        this.shippingAddressTitle = 'Shipping Address';
        this.shippingMethodTitle = 'Shipping Method';
        this.includeModal = true;
        this.addressVerificationCheck = function (_a) {
            var shippingAccountAddress = _a.shippingAccountAddress;
            if (!shippingAccountAddress) {
                return;
            }
            try {
                var addressVerification = JSON.parse(shippingAccountAddress.address_verificationJson);
                if (addressVerification && addressVerification.hasOwnProperty('success') && !addressVerification.success && addressVerification.hasOwnProperty('suggestedAddress')) {
                    _this.launchAddressModal([addressVerification.address, addressVerification.suggestedAddress]);
                }
            }
            catch (e) {
                console.log(e);
            }
        };
        this.updateShippingInfo = function (data) {
            if (data['account.accountAddressOptions'] != null) {
                _this.accountAddressOptions = data['account.accountAddressOptions'];
            }
            if (data.shippingAccountAddress != null && data.shippingMethod != null) {
                _this.shippingAccountAddress = data.shippingAccountAddress;
                _this.shippingMethod = data.shippingMethod;
                _this.modalButtonText = _this.rbkeyService.rbKey('define.update') + ' ' + _this.title;
            }
            if (data.addressID) {
                for (var key in data) {
                    _this.shippingAccountAddress["address_" + key] = data[key];
                }
            }
        };
        this.observerService.attach(this.updateShippingInfo, 'OrderTemplateUpdateShippingSuccess');
        this.observerService.attach(this.addressVerificationCheck, 'OrderTemplateUpdateShippingSuccess');
        this.observerService.attach(this.updateShippingInfo, 'OrderTemplateUpdateBillingSuccess');
        if (this.shippingAccountAddress != null && this.shippingMethod != null) {
            this.modalButtonText = this.rbkeyService.rbKey('define.update') + ' ' + this.title;
        }
        else {
            this.modalButtonText = this.rbkeyService.rbKey('define.add') + ' ' + this.title;
        }
        if (this.baseEntityName === 'OrderTemplate' && this.baseEntity['orderTemplateStatusType_systemCode'] === 'otstCancelled') {
            this.includeModal = false;
        }
    }
    SWAccountShippingAddressCardController.prototype.launchAddressModal = function (addresses) {
        var _this = this;
        this.ModalService.showModal({
            component: 'swAddressVerification',
            bodyClass: 'angular-modal-service-active',
            bindings: {
                suggestedAddresses: addresses,
                sAction: this.updateShippingInfo,
                propertyIdentifiersList: 'addressID,firstName,lastName,streetAddress,street2Address,city,stateCode,postalCode,countryCode'
            },
            preClose: function (modal) {
                modal.element.modal('hide');
                _this.ModalService.closeModals();
            },
        })
            .then(function (modal) {
            //it's a bootstrap element, use 'modal' to show it
            modal.element.modal();
            modal.close.then(function (result) { });
        })
            .catch(function (error) {
            console.error('unable to open model :', error);
        });
    };
    return SWAccountShippingAddressCardController;
}());
var SWAccountShippingAddressCard = /** @class */ (function () {
    function SWAccountShippingAddressCard(orderPartialsPath, slatwallPathBuilder, $hibachi, rbkeyService) {
        this.orderPartialsPath = orderPartialsPath;
        this.slatwallPathBuilder = slatwallPathBuilder;
        this.$hibachi = $hibachi;
        this.rbkeyService = rbkeyService;
        this.scope = {};
        this.bindToController = {
            accountAddressOptions: "<",
            shippingAccountAddress: "<",
            baseEntityName: "@?",
            baseEntity: "<",
            countryCodeOptions: "<",
            defaultCountryCode: "@?",
            shippingMethod: "<",
            shippingMethodOptions: "<",
            stateCodeOptions: "<",
            title: "@?"
        };
        this.controller = SWAccountShippingAddressCardController;
        this.controllerAs = "swAccountShippingAddressCard";
        this.link = function (scope, element, attrs) {
        };
        this.templateUrl = slatwallPathBuilder.buildPartialsPath(orderPartialsPath) + "/accountshippingaddresscard.html";
        this.restrict = "EA";
    }
    SWAccountShippingAddressCard.Factory = function () {
        var directive = function (orderPartialsPath, slatwallPathBuilder, $hibachi, rbkeyService) { return new SWAccountShippingAddressCard(orderPartialsPath, slatwallPathBuilder, $hibachi, rbkeyService); };
        directive.$inject = [
            'orderPartialsPath',
            'slatwallPathBuilder',
            '$hibachi',
            'rbkeyService'
        ];
        return directive;
    };
    return SWAccountShippingAddressCard;
}());
exports.SWAccountShippingAddressCard = SWAccountShippingAddressCard;


/***/ }),

/***/ "uvpt":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
exports.SWSkuStockAdjustmentModalLauncherController = exports.SWSkuStockAdjustmentModalLauncher = void 0;
/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
var SWSkuStockAdjustmentModalLauncherController = /** @class */ (function () {
    //@ngInject
    SWSkuStockAdjustmentModalLauncherController.$inject = ["$http", "$q", "$hibachi", "observerService", "utilityService", "collectionConfigService"];
    function SWSkuStockAdjustmentModalLauncherController($http, $q, $hibachi, observerService, utilityService, collectionConfigService) {
        var _this = this;
        this.$http = $http;
        this.$q = $q;
        this.$hibachi = $hibachi;
        this.observerService = observerService;
        this.utilityService = utilityService;
        this.collectionConfigService = collectionConfigService;
        this.initData = function () {
            _this.selectedLocation = undefined;
            _this.stockAdjustmentType = undefined;
            var skudata = {
                skuID: _this.skuId,
                skuCode: _this.skuCode,
                skuDescription: _this.skuDescription,
                imagePath: _this.imagePath,
                calculatedQATS: _this.calculatedQats || 0,
                calculatedQOH: _this.calculatedQoh || 0,
            };
            _this.sku = _this.$hibachi.populateEntity("Sku", skudata);
            _this.sku.setNewQOH(_this.calculatedQoh || 0);
            _this.stockAdjustmentID = "";
            _this.stock = _this.$hibachi.newStock();
            _this.stockAdjustment = _this.$hibachi.newStockAdjustment();
            _this.stockAdjustmentItem = _this.$hibachi.newStockAdjustmentItem();
            _this.selectedLocation = _this.$hibachi.newLocation();
            _this.stockAdjustment.$$addStockAdjustmentItem(_this.stockAdjustmentItem);
            _this.stock.$$setSku(_this.sku);
            _this.stockAdjustmentStatusType = _this.$hibachi.populateEntity("Type", { typeID: "444df2e2f66ddfaf9c60caf5c76349a6" }); //new status type for stock adjusment
            _this.stockAdjustment.$$setStockAdjustmentStatusType(_this.stockAdjustmentStatusType);
            _this.stockAdjustmentItem.$$setSku(_this.sku);
            _this.newQuantity = _this.calculatedQoh || 0;
            _this.observerService.notify(_this.selectedLocationTypeaheadDataKey + 'clearSearch');
        };
        this.save = function () {
            if (_this.stockAdjustmentItem.data.quantity > 0) {
                _this.stockAdjustment.$$setStockAdjustmentType(_this.$hibachi.populateEntity("Type", { typeID: "444df2e60db81c12589c9b39346009f2" })); //manual in stock adjustment type
                _this.stockAdjustment.$$setToLocation(_this.selectedLocation);
                _this.stockAdjustmentItem.$$setToStock(_this.stock);
            }
            else {
                _this.stockAdjustment.$$setStockAdjustmentType(_this.$hibachi.populateEntity("Type", { typeID: "444df2e7dba550b7a24a03acbb37e717" })); //manual out stock adjustment type
                _this.stockAdjustment.$$setFromLocation(_this.selectedLocation);
                _this.stockAdjustmentItem.data.quantity = _this.stockAdjustmentItem.data.quantity * -1;
                _this.stockAdjustmentItem.$$setFromStock(_this.stock);
            }
            return _this.$q.all([_this.observerService.notify('updateBindings'), _this.stock.$$save()]).then().finally(function () {
                var stockAdjustmentSavePromise = _this.stockAdjustment.$$save();
                stockAdjustmentSavePromise.then(function (response) {
                    _this.sku.newQOH = _this.newQuantity;
                    _this.sku.data.newQOH = _this.newQuantity;
                    _this.sku.data.calculatedQOH = _this.newQuantity;
                    _this.stockAdjustmentID = response.stockAdjustmentID;
                    _this.observerService.notify('updateBindings');
                }).finally(function () {
                    _this.observerService.notify('updateBindings');
                    _this.$http({
                        method: "POST",
                        url: _this.$hibachi.getUrlWithActionPrefix() + "entity.processStockAdjustment&processContext=processAdjustment&stockAdjustmentID=" + _this.stockAdjustmentID
                    }).then(function (response) {
                        //don't need to do anything here
                        _this.swListingDisplay.getCollection();
                    });
                });
            });
        };
        this.addSelectedLocation = function (item) {
            if (angular.isDefined(item)) {
                _this.selectedLocation = _this.$hibachi.populateEntity('Location', item);
                _this.stock.$$setLocation(_this.selectedLocation);
                //get existing stockID if one exists
                _this.stockCollectionConfig = _this.collectionConfigService.newCollectionConfig('Stock');
                _this.stockCollectionConfig.addFilter('sku.skuID', _this.stock.sku.skuID);
                _this.stockCollectionConfig.addFilter('location.locationID', _this.selectedLocation.locationID);
                _this.stockCollectionConfig.setDistinct(true);
                _this.stockCollectionConfig.getEntity().then(function (res) {
                    if (res.pageRecords.length > 0) {
                        _this.stock.stockID = res.pageRecords[0].stockID;
                    }
                });
            }
            else {
                _this.selectedLocation = undefined;
            }
        };
        this.updateNewQuantity = function (args) {
            if (!isNaN(args.swInput.value)) {
                _this.newQuantity = args.swInput.value;
            }
            else {
                _this.sku.data.newQOH = 0;
            }
            _this.updateStockAdjustmentQuantity();
        };
        this.updateStockAdjustmentQuantity = function () {
            if (!isNaN(_this.newQuantity)) {
                _this.stockAdjustmentItem.data.quantity = _this.newQuantity - _this.sku.data.calculatedQOH;
            }
            else {
                _this.newQuantity = 0;
            }
        };
        this.selectedLocationTypeaheadDataKey = this.utilityService.createID(32);
        if (angular.isDefined(this.skuId)) {
            this.name = "skuStockAdjustment" + this.utilityService.createID(32);
        }
        else {
            throw ("SWSkuStockAdjustmentModalLauncherController was not provided with a sku id");
        }
        if (angular.isDefined(this.calculatedQats)) {
            this.calculatedQats = parseInt(this.calculatedQats);
        }
        if (angular.isDefined(this.calculatedQoh)) {
            this.calculatedQoh = parseInt(this.calculatedQoh);
        }
        this.initData();
        this.observerService.attach(this.updateNewQuantity, this.name + 'newQuantitychange');
    }
    return SWSkuStockAdjustmentModalLauncherController;
}());
exports.SWSkuStockAdjustmentModalLauncherController = SWSkuStockAdjustmentModalLauncherController;
var SWSkuStockAdjustmentModalLauncher = /** @class */ (function () {
    function SWSkuStockAdjustmentModalLauncher(skuPartialsPath, slatwallPathBuilder) {
        this.restrict = 'EA';
        this.scope = {};
        this.require = { swListingDisplay: '?^swListingDisplay' };
        this.bindToController = {
            skuId: "@",
            skuCode: "@",
            skuDescription: "@",
            imagePath: "@",
            calculatedQats: "=?",
            calculatedQoh: "=?"
        };
        this.controller = SWSkuStockAdjustmentModalLauncherController;
        this.controllerAs = "swSkuStockAdjustmentModalLauncher";
        this.link = function (scope, element, attrs) {
            scope.$watch('swStockAdjustmentModalLauncherController.calculatedQoh', function (newValue) {
                scope.swSkuStockAdjustmentModalLauncher.newQuantity = newValue;
            });
        };
        this.templateUrl = slatwallPathBuilder.buildPartialsPath(skuPartialsPath) + "skustockadjustmentmodallauncher.html";
    }
    SWSkuStockAdjustmentModalLauncher.Factory = function () {
        var directive = function (skuPartialsPath, slatwallPathBuilder) { return new SWSkuStockAdjustmentModalLauncher(skuPartialsPath, slatwallPathBuilder); };
        directive.$inject = [
            'skuPartialsPath',
            'slatwallPathBuilder'
        ];
        return directive;
    };
    return SWSkuStockAdjustmentModalLauncher;
}());
exports.SWSkuStockAdjustmentModalLauncher = SWSkuStockAdjustmentModalLauncher;


/***/ }),

/***/ "w4Le":
/***/ (function(module, exports) {

module.exports = "<sw-modal-launcher data-modal-name=\"{{swAddSkuPriceModalLauncher.uniqueName}}\" \n                   data-title=\"Add Sku Price Detail\" \n                   data-save-action=\"swAddSkuPriceModalLauncher.save\">\n    <sw-modal-content> \n        \n        <sw-form ng-if=\"swAddSkuPriceModalLauncher.skuPrice\"\n                 name=\"{{swAddSkuPriceModalLauncher.formName}}\" \n                 data-object=\"swAddSkuPriceModalLauncher.skuPrice\"    \n                 data-context=\"save\"\n                 >\n            <div ng-show=\"!swAddSkuPriceModalLauncher.saveSuccess\" class=\"alert alert-error\" role=\"alert\" sw-rbkey=\"'admin.entity.addskuprice.invalid'\"></div>\n            <div class=\"row\">\n                    <div class=\"col-sm-4\">\n                        <sw-sku-thumbnail ng-if=\"swAddSkuPriceModalLauncher.sku.data\" data-sku-data=\"swAddSkuPriceModalLauncher.sku.data\">\n                        </sw-sku-thumbnail>\n                    </div>\n                    <div class=\"col-sm-8\">\n                        <div class=\"row\">\n                            <div class=\"col-sm-6\">\n                                <label  class=\"control-label\"\n                                        sw-rbKey=\"'entity.SkuPrice.price'\">\n                                </label>\n                                <input  class=\"form-control\" \n                                        type=\"text\" \n                                        name=\"price\" \n                                        ng-model=\"swAddSkuPriceModalLauncher.skuPrice.price\"\n                                />\n                            </div> \n                            <div class=\"col-sm-6\">\n                                <div class=\"form-group\">\n                                    <label for=\"\" class=\"control-label\">Currency Code</label>\n                                    <select class=\"form-control\" \n                                            name=\"currencyCode\"\n                                            ng-model=\"swAddSkuPriceModalLauncher.selectedCurrencyCode\"\n                                            ng-options=\"item as item for item in swAddSkuPriceModalLauncher.currencyCodeOptions track by item\"\n                                            ng-disabled=\"(swAddSkuPriceModalLauncher.disableAllFieldsButPrice || swAddSkuPriceModalLauncher.defaultCurrencyOnly) && !swAddSkuPriceModalLauncher.currencyCodeEditable\"\n                                            >\n                                    </select>\n                                </div>\n                            </div>\n                        </div>\n                        \n                        <div class=\"row\">\n                            <div class=\"col-sm-6\">\n                                <label  class=\"control-label\"\n                                        sw-rbKey=\"'entity.SkuPrice.minQuantity'\">\n                                </label>\n                                <input  class=\"form-control\" \n                                        type=\"text\" \n                                        name=\"minQuantity\" \n                                        ng-model=\"swAddSkuPriceModalLauncher.skuPrice.minQuantity\"\n                                />\n                            </div>\n                            <div class=\"col-sm-6\">\n                                <label  class=\"control-label\"\n                                        sw-rbKey=\"'entity.SkuPrice.maxQuantity'\">\n                                </label>\n                                <input  class=\"form-control\" \n                                        type=\"text\" \n                                        name=\"maxQuantity\" \n                                        ng-model=\"swAddSkuPriceModalLauncher.skuPrice.maxQuantity\"\n                                />\n                            </div>\n                        </div>\n                        <div class=\"row\">\n                            <div class=\"col-sm-6\">\n                                <label  class=\"control-label\"\n                                        sw-rbKey=\"'entity.Sku'\">\n                                        \n                                </label>\n                                <sw-typeahead-search    data-collection-config=\"swAddSkuPriceModalLauncher.skuCollectionConfig\"\n                                                        data-placeholder-text=\"Select Sku\"\n                                                        data-search-text=\"swAddSkuPriceModalLauncher.selectedSku['skuCode']\"\n                                                        data-add-function=\"swAddSkuPriceModalLauncher.setSelectedSku\"\n                                                        data-property-to-show=\"skuCode\">\n                                    <span sw-typeahead-search-line-item data-property-identifier=\"skuCode\" ng-bind=\"item.skuCode\"></span>\n                                </sw-typeahead-search>\n                                <input type=\"hidden\" readonly style=\"display:none\" name=\"sku\" ng-model=\"swAddSkuPriceModalLauncher.submittedSku\" />\n                            </div>\n                            <div class=\"col-sm-6\">\n                                \n                                <label  class=\"control-label\"\n                                        sw-rbKey=\"'entity.PriceGroup'\">\n                                        \n                                </label>\n                                <select class=\"form-control\" \n                                        ng-model=\"swAddSkuPriceModalLauncher.selectedPriceGroup\"\n                                        ng-options=\"item as item.priceGroupName for item in swAddSkuPriceModalLauncher.priceGroupOptions track by item.priceGroupID\"\n                                        ng-change=\"swAddSkuPriceModalLauncher.setSelectedPriceGroup(swAddSkuPriceModalLauncher.selectedPriceGroup)\"\n                                        >\n                                </select>\n                                <input type=\"hidden\" readonly style=\"display:none\" name=\"priceGroup\" ng-model=\"swAddSkuPriceModalLauncher.submittedPriceGroup\" />\n                            </div>\n                        </div>\n                        <!-- BEGIN HIDDEN FIELDS -->\n                        \n                        <!-- END HIDDEN FIELDS -->\n                    </div>\n                </div>\n            </sw-form>\n    </sw-modal-content> \n</sw-modal-launcher>";

/***/ }),

/***/ "wEhO":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

/// <reference path='../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../typings/tsd.d.ts' />
Object.defineProperty(exports, "__esModule", { value: true });
exports.skumodule = void 0;
//modules
var core_module_1 = __webpack_require__("pwA0");
//services
var defaultskuservice_1 = __webpack_require__("PwPv");
var skupriceservice_1 = __webpack_require__("SBrW");
//controllers
//directives
var swpricingmanager_1 = __webpack_require__("ISbx");
var swimagedetailmodallauncher_1 = __webpack_require__("Ot3G");
var swaddskupricemodallauncher_1 = __webpack_require__("6X4p");
var swdeleteskupricemodallauncher_1 = __webpack_require__("yk+o");
var sweditskupricemodallauncher_1 = __webpack_require__("LT6+");
var swskupricemodal_1 = __webpack_require__("nf8Q");
var swskustockadjustmentmodallauncher_1 = __webpack_require__("uvpt");
var swdefaultskuradio_1 = __webpack_require__("TEp3");
var swskuimage_1 = __webpack_require__("QEq2");
var swskucurrencyselector_1 = __webpack_require__("SaOQ");
var swskupriceedit_1 = __webpack_require__("ir1N");
var swskucodeedit_1 = __webpack_require__("hAMq");
var swskupricesedit_1 = __webpack_require__("jAYt");
var swskupricequantityedit_1 = __webpack_require__("2DFJ");
var swskuthumbnail_1 = __webpack_require__("hCO+");
//filters
var skumodule = angular.module('hibachi.sku', [core_module_1.coremodule.name]).config(function () {
})
    //constants
    .constant('skuPartialsPath', 'sku/components/')
    //services
    .service('defaultSkuService', defaultskuservice_1.DefaultSkuService)
    .service('skuPriceService', skupriceservice_1.SkuPriceService)
    //controllers
    //directives
    .directive('swPricingManager', swpricingmanager_1.SWPricingManager.Factory())
    .directive('swImageDetailModalLauncher', swimagedetailmodallauncher_1.SWImageDetailModalLauncher.Factory())
    .directive('swAddSkuPriceModalLauncher', swaddskupricemodallauncher_1.SWAddSkuPriceModalLauncher.Factory())
    .directive('swDeleteSkuPriceModalLauncher', swdeleteskupricemodallauncher_1.SWDeleteSkuPriceModalLauncher.Factory())
    .directive('swEditSkuPriceModalLauncher', sweditskupricemodallauncher_1.SWEditSkuPriceModalLauncher.Factory())
    .directive('swSkuPriceModal', swskupricemodal_1.SWSkuPriceModal.Factory())
    .directive('swSkuStockAdjustmentModalLauncher', swskustockadjustmentmodallauncher_1.SWSkuStockAdjustmentModalLauncher.Factory())
    .directive('swDefaultSkuRadio', swdefaultskuradio_1.SWDefaultSkuRadio.Factory())
    .directive('swSkuCurrencySelector', swskucurrencyselector_1.SWSkuCurrencySelector.Factory())
    .directive('swSkuPriceEdit', swskupriceedit_1.SWSkuPriceEdit.Factory())
    .directive('swSkuCodeEdit', swskucodeedit_1.SWSkuCodeEdit.Factory())
    .directive('swSkuImage', swskuimage_1.SWSkuImage.Factory())
    .directive('swSkuPricesEdit', swskupricesedit_1.SWSkuPricesEdit.Factory())
    .directive('swSkuPriceQuantityEdit', swskupricequantityedit_1.SWSkuPriceQuantityEdit.Factory())
    .directive('swSkuThumbnail', swskuthumbnail_1.SWSkuThumbnail.Factory());
exports.skumodule = skumodule;


/***/ }),

/***/ "wXpQ":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
exports.giftcardmodule = void 0;
/// <reference path='../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../typings/tsd.d.ts' />
//modules
var core_module_1 = __webpack_require__("pwA0");
//controllers
var preprocessorderitem_addorderitemgiftrecipient_1 = __webpack_require__("5s5V");
//directives
var swaddorderitemgiftrecipient_1 = __webpack_require__("0JmH");
var swgiftcardbalance_1 = __webpack_require__("4tEo");
var swgiftcarddetail_1 = __webpack_require__("d6tF");
var swgiftcardhistory_1 = __webpack_require__("kGCo");
var swgiftcardoverview_1 = __webpack_require__("FurE");
var swgiftcardorderinfo_1 = __webpack_require__("OnuJ");
var swgiftcardrecipientinfo_1 = __webpack_require__("C5Xv");
var sworderitemgiftrecipientrow_1 = __webpack_require__("Mtva");
var giftcardmodule = angular.module('giftcard', [core_module_1.coremodule.name])
    .config([function () {
    }]).run([function () {
    }])
    //constants
    .constant('giftCardPartialsPath', 'giftcard/components/')
    //controllers
    .controller('preprocessorderitem_addorderitemgiftrecipient', preprocessorderitem_addorderitemgiftrecipient_1.OrderItemGiftRecipientControl)
    //directives
    .directive('swAddOrderItemGiftRecipient', swaddorderitemgiftrecipient_1.SWAddOrderItemGiftRecipient.Factory())
    .directive('swGiftCardBalance', swgiftcardbalance_1.SWGiftCardBalance.Factory())
    .directive('swGiftCardOverview', swgiftcardoverview_1.SWGiftCardOverview.Factory())
    .directive('swGiftCardDetail', swgiftcarddetail_1.SWGiftCardDetail.Factory())
    .directive('swGiftCardHistory', swgiftcardhistory_1.SWGiftCardHistory.Factory())
    .directive('swGiftCardRecipientInfo', swgiftcardrecipientinfo_1.SWGiftCardRecipientInfo.Factory())
    .directive('swGiftCardOrderInfo', swgiftcardorderinfo_1.SWGiftCardOrderInfo.Factory())
    .directive('swOrderItemGiftRecipientRow', sworderitemgiftrecipientrow_1.SWOrderItemGiftRecipientRow.Factory());
exports.giftcardmodule = giftcardmodule;


/***/ }),

/***/ "wbyE":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

/// <reference path='../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../typings/tsd.d.ts' />
Object.defineProperty(exports, "__esModule", { value: true });
exports.sitemodule = void 0;
//modules
var core_module_1 = __webpack_require__("pwA0");
//services
//controllers
//directives
var swsiteandcurrencyselect_1 = __webpack_require__("xhXT");
//filters
var sitemodule = angular.module('hibachi.site', [core_module_1.coremodule.name]).config(function () {
})
    //constants
    .constant('sitePartialsPath', 'site/components/')
    //services
    //controllers
    //directives
    .directive('swSiteAndCurrencySelect', swsiteandcurrencyselect_1.SWSiteAndCurrencySelect.Factory());
exports.sitemodule = sitemodule;


/***/ }),

/***/ "wcsU":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

/**
 * ------------------------
 * Importing these Actions:
 *
 * Action constants are used in both the controller (to dispatch to the correct reducer)
 * as well as the service (where the reducer lives).
 * These can be imported using * and then aliased (such as action) such that
 * they can be referenced from multiple places as action.TOGGLE_EDITCOMMENT.
 * The naming convention is slightly different for UI actions and server actions.
 * ---
 * Server Based Actions:
 *
 * A server action example would be any object CRUD like SAVE_COMMENT, DELETE_PRODUCT, ETC.
 * A server action also has a third part added: Requested | Success | Fail so the action may be
 * dispatched as SAVE_COMMENT_REQUESTED but would be returned as SAVE_COMMENT_SUCCESS or SAVE_COMMENT_FAILED.
 * ---
 * UI Based Actions:
 *
 * UI actions do not include the REQUESTED|SUCCESS|FAILED part because they are simple enough that
 * they should not do anything other than success.
 *
 */
Object.defineProperty(exports, "__esModule", { value: true });
exports.EMAIL_LIST_FAILURE = exports.EMAIL_LIST_SUCCESS = exports.EMAIL_LIST_REQUESTED = exports.PRINT_LIST_FAILURE = exports.PRINT_LIST_SUCCESS = exports.PRINT_LIST_REQUESTED = exports.PRINT_PACKINGLIST_FAILURE = exports.PRINT_PACKINGLIST_SUCCESS = exports.PRINT_PACKINGLIST_REQUESTED = exports.PRINT_PICKINGLIST_FAILURE = exports.PRINT_PICKINGLIST_SUCCESS = exports.PRINT_PICKINGLIST_REQUESTED = exports.CREATE_FULFILLMENT_FAILURE = exports.CREATE_FULFILLMENT_SUCCESS = exports.CREATE_FULFILLMENT_REQUESTED = exports.SAVE_COMMENT_FAILURE = exports.SAVE_COMMENT_SUCCESS = exports.SAVE_COMMENT_REQUESTED = exports.DELETE_FULFILLMENTBATCHITEM_FAILURE = exports.DELETE_FULFILLMENTBATCHITEM_SUCCESS = exports.DELETE_FULFILLMENTBATCHITEM_REQUESTED = exports.DELETE_COMMENT_FAILURE = exports.DELETE_COMMENT_SUCCESS = exports.DELETE_COMMENT_REQUESTED = exports.SETUP_ORDERDELIVERYATTRIBUTES = exports.CURRENT_PAGE_RECORDS_SELECTED = exports.SET_UNASSIGNED_ITEM_CONTAINER = exports.UPDATE_CONTAINER_ITEM_QUANTITY = exports.SET_DELIVERY_QUANTITIES = exports.UPDATE_BOX_DIMENSIONS = exports.REMOVE_BOX = exports.ADD_BOX = exports.ADD_BATCH = exports.REFRESH_BATCHDETAIL = exports.UPDATE_BATCHDETAIL = exports.SETUP_BATCHDETAIL = exports.TOGGLE_FULFILLMENT_LISTING = exports.TOGGLE_BATCHLISTING = exports.TOGGLE_LOADER = exports.TOGGLE_EDITCOMMENT = void 0;
/**
 * This action will toggle the comment edit and allow a user to start editing or stop editing a comment.
 */
exports.TOGGLE_EDITCOMMENT = "TOGGLE_EDITCOMMENT";
/**
 * This action will toggle the page loader.
 */
exports.TOGGLE_LOADER = "TOGGLE_LOADER";
/**
 * This will toggle the batch listing to its full or half size view.
 */
exports.TOGGLE_BATCHLISTING = "TOGGLE_BATCHLISTING";
/**
 * This will toggle the fulfillment listing between fulfillment and order items on the order fulfillments list screen
 */
exports.TOGGLE_FULFILLMENT_LISTING = "TOGGLE_FULFILLMENT_LISTING";
/**
 * This sets up all the state data on page start and should only be called once in a constructor.
 */
exports.SETUP_BATCHDETAIL = "SETUP_BATCHDETAIL";
/**
 * This updates all of the state for the batch detail page.
 */
exports.UPDATE_BATCHDETAIL = "UPDATE_BATCHDETAIL";
/**
 * This will refresh all of the batch detail state.
 */
exports.REFRESH_BATCHDETAIL = "REFRESH_BATCHDETAIL";
/**
 * This will create a new batch by passing all batch data.
 */
exports.ADD_BATCH = "ADD_BATCH";
/**
 * This will add a box to a shipment.
 */
exports.ADD_BOX = "ADD_BOX";
/**
 * This will remove a box from a shipment.
 */
exports.REMOVE_BOX = "REMOVE_BOX";
/**
 * This will update the dimensions of a box on a shipment.
 */
exports.UPDATE_BOX_DIMENSIONS = "UPDATE_BOX_DIMENSIONS";
/**
 * This will set delivery quantities on a shipment.
 */
exports.SET_DELIVERY_QUANTITIES = "SET_DELIVERY_QUANTITIES";
/**
 * This will update the quantity on a container item.
 */
exports.UPDATE_CONTAINER_ITEM_QUANTITY = "UPDATE_CONTAINER_ITEM_QUANTITIES";
/**
 * This will set the container for an unassigned container item.
 */
exports.SET_UNASSIGNED_ITEM_CONTAINER = "SET_UNASSIGNED_ITEM_CONTAINER";
/**
 * This will fire when the current page records selected on a table are updated.
 */
exports.CURRENT_PAGE_RECORDS_SELECTED = "CURRENT_PAGE_RECORDS_SELECTED";
/**
 * This setups the page that displays the order delivery custom attributes and should only be called once.
 */
exports.SETUP_ORDERDELIVERYATTRIBUTES = "SETUP_ORDERDELIVERYATTRIBUTES";
/**
 * This will delete a comment permenently.
 */
exports.DELETE_COMMENT_REQUESTED = "DELETE_COMMENT_REQUESTED";
/** This action coming back from the reducer indicated that the action was a success. */
exports.DELETE_COMMENT_SUCCESS = "DELETE_COMMENT_SUCCESS";
/** This action coming back from the reducer indicated that the action was a failure. */
exports.DELETE_COMMENT_FAILURE = "DELETE_COMMENT_FAILURE";
/**
 * This will delete a fulfillment batch item permenently and from the fulfillment batch.
 */
exports.DELETE_FULFILLMENTBATCHITEM_REQUESTED = "DELETE_FULFILLMENTBATCHITEM_REQUESTED";
/** This action coming back from the reducer indicated that the action was a success. */
exports.DELETE_FULFILLMENTBATCHITEM_SUCCESS = "DELETE_FULFILLMENTBATCHITEM_SUCCESS";
/** This action coming back from the reducer indicated that the action was a failure. */
exports.DELETE_FULFILLMENTBATCHITEM_FAILURE = "DELETE_FULFILLMENTBATCHITEM_FAILURE";
/**
 * This will save a comment.
 */
exports.SAVE_COMMENT_REQUESTED = "SAVE_COMMENT_REQUESTED";
/** This action coming back from the reducer indicated that the action was a success. */
exports.SAVE_COMMENT_SUCCESS = "SAVE_COMMENT_SUCCESS";
/** This action coming back from the reducer indicated that the action was a failure. */
exports.SAVE_COMMENT_FAILURE = "SAVE_COMMENT_FAILURE";
/**
 * This will fulfill the batch item if it has all needed information.
 */
exports.CREATE_FULFILLMENT_REQUESTED = "CREATE_FULFILLMENT_REQUESTED";
/** This action coming back from the reducer indicated that the action was a success. */
exports.CREATE_FULFILLMENT_SUCCESS = "CREATE_FULFILLMENT_SUCCESS";
/** This action coming back from the reducer indicated that the action was a failure. */
exports.CREATE_FULFILLMENT_FAILURE = "CREATE_FULFILLMENT_FAILURE";
/**
 * This will print the picking list that the user has defined.
 */
exports.PRINT_PICKINGLIST_REQUESTED = "PRINT_PICKINGLIST_REQUESTED";
/** This action coming back from the reducer indicated that the action was a success. */
exports.PRINT_PICKINGLIST_SUCCESS = "PRINT_PICKINGLIST_SUCCESS";
/** This action coming back from the reducer indicated that the action was a failure. */
exports.PRINT_PICKINGLIST_FAILURE = "PRINT_PICKINGLIST_FAILURE";
/**
 * This will print the packing list that the user has defined.
 */
exports.PRINT_PACKINGLIST_REQUESTED = "PRINT_PACKINGLIST_REQUESTED";
/** This action coming back from the reducer indicated that the action was a success. */
exports.PRINT_PACKINGLIST_SUCCESS = "PRINT_PACKINGLIST_SUCCESS";
/** This action coming back from the reducer indicated that the action was a failure. */
exports.PRINT_PACKINGLIST_FAILURE = "PRINT_PACKINGLIST_FAILURE";
/**
 * This will return a list of print templates that are defined for fulfillment batches.
 */
exports.PRINT_LIST_REQUESTED = "PRINT_LIST_REQUESTED";
/** This action coming back from the reducer indicated that the action was a success. */
exports.PRINT_LIST_SUCCESS = "PRINT_LIST_SUCCESS";
/** This action coming back from the reducer indicated that the action was a failure. */
exports.PRINT_LIST_FAILURE = "PRINT_LIST_FAILURE";
/**
 * This will return a list of emails that are defined for orderFulfillments
 */
exports.EMAIL_LIST_REQUESTED = "EMAIL_LIST_REQUESTED";
/** This action coming back from the reducer indicated that the action was a success. */
exports.EMAIL_LIST_SUCCESS = "EMAIL_LIST_SUCCESS";
/** This action coming back from the reducer indicated that the action was a failure. */
exports.EMAIL_LIST_FAILURE = "EMAIL_LIST_FAILURE";


/***/ }),

/***/ "xhXT":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
exports.SWSiteAndCurrencySelect = void 0;
/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
var SWSiteAndCurrencySelectController = /** @class */ (function () {
    //@ngInject
    SWSiteAndCurrencySelectController.$inject = ["$hibachi", "observerService"];
    function SWSiteAndCurrencySelectController($hibachi, observerService) {
        var _this = this;
        this.$hibachi = $hibachi;
        this.observerService = observerService;
        this.currencyCodeOptions = [];
        this.disabled = false;
        this.$onInit = function () {
            if (_this.accountTypeaheadId != null) {
                _this.observerService.attach(_this.updateSite, 'typeahead_add_item', _this.accountTypeaheadId);
            }
        };
        this.updateSite = function (data) {
            if (data != null && data.accountCreatedSite_siteID != null) {
                for (var i = 0; i < _this.siteAndCurrencyOptions.length; i++) {
                    if (_this.siteAndCurrencyOptions[i].value === data.accountCreatedSite_siteID) {
                        _this.site = _this.siteAndCurrencyOptions[i];
                        _this.disabled = true;
                        break;
                    }
                }
            }
            if (_this.site != null) {
                _this.currencyCodeOptions = _this.site.eligibleCurrencyCodes.split(',');
                if (_this.currencyCodeOptions.length === 1) {
                    _this.currencyCode = _this.currencyCodeOptions[0];
                }
            }
        };
        this.site = this.siteAndCurrencyOptions[0];
    }
    return SWSiteAndCurrencySelectController;
}());
var SWSiteAndCurrencySelect = /** @class */ (function () {
    function SWSiteAndCurrencySelect(skuPartialsPath, slatwallPathBuilder) {
        this.restrict = 'EA';
        this.scope = {};
        this.bindToController = {
            accountTypeaheadId: '@?',
            siteAndCurrencyOptions: '<?'
        };
        this.controller = SWSiteAndCurrencySelectController;
        this.controllerAs = "swSiteAndCurrencySelect";
        this.compile = function (element, attrs) {
            return {
                pre: function ($scope, element, attrs) {
                },
                post: function ($scope, element, attrs) {
                }
            };
        };
        this.templateUrl = slatwallPathBuilder.buildPartialsPath(skuPartialsPath) + "siteandcurrencyselect.html";
    }
    SWSiteAndCurrencySelect.Factory = function () {
        var directive = function (sitePartialsPath, slatwallPathBuilder) { return new SWSiteAndCurrencySelect(sitePartialsPath, slatwallPathBuilder); };
        directive.$inject = [
            'sitePartialsPath',
            'slatwallPathBuilder'
        ];
        return directive;
    };
    return SWSiteAndCurrencySelect;
}());
exports.SWSiteAndCurrencySelect = SWSiteAndCurrencySelect;


/***/ }),

/***/ "yk+o":
/***/ (function(module, exports, __webpack_require__) {

"use strict";

Object.defineProperty(exports, "__esModule", { value: true });
exports.SWDeleteSkuPriceModalLauncherController = exports.SWDeleteSkuPriceModalLauncher = void 0;
/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
var SWDeleteSkuPriceModalLauncherController = /** @class */ (function () {
    //@ngInject
    SWDeleteSkuPriceModalLauncherController.$inject = ["$q", "$hibachi", "listingService", "skuPriceService", "utilityService", "observerService"];
    function SWDeleteSkuPriceModalLauncherController($q, $hibachi, listingService, skuPriceService, utilityService, observerService) {
        var _this = this;
        this.$q = $q;
        this.$hibachi = $hibachi;
        this.listingService = listingService;
        this.skuPriceService = skuPriceService;
        this.utilityService = utilityService;
        this.observerService = observerService;
        this.baseName = "j-delete-sku-item-";
        this.init = function (pageRecord) {
            _this.pageRecord = pageRecord;
            var skuPriceData = {
                skuPriceID: pageRecord.skuPriceID,
                minQuantity: pageRecord.minQuantity,
                maxQuantity: pageRecord.maxQuantity,
                currencyCode: pageRecord.currencyCode,
                price: pageRecord.price
            };
            _this.skuPrice = _this.$hibachi.populateEntity('SkuPrice', skuPriceData);
        };
        this.deleteSkuPrice = function () {
            var deletePromise = _this.skuPrice.$$delete();
            deletePromise.then(function (resolve) {
                //hack, for whatever reason is not responding to getCollection event
                _this.observerService.notifyById('swPaginationAction', _this.listingID, { type: 'setCurrentPage', payload: 1 });
            }, function (reason) {
                console.log("Could not delete Sku Price Because: ", reason);
            });
            return deletePromise;
        };
        this.uniqueName = this.baseName + this.utilityService.createID(16);
        this.observerService.attach(this.init, "DELETE_SKUPRICE");
        //hack for listing hardcodeing id
        this.listingID = 'pricingListing';
    }
    return SWDeleteSkuPriceModalLauncherController;
}());
exports.SWDeleteSkuPriceModalLauncherController = SWDeleteSkuPriceModalLauncherController;
var SWDeleteSkuPriceModalLauncher = /** @class */ (function () {
    function SWDeleteSkuPriceModalLauncher($hibachi, scopeService, skuPartialsPath, slatwallPathBuilder) {
        this.$hibachi = $hibachi;
        this.scopeService = scopeService;
        this.skuPartialsPath = skuPartialsPath;
        this.slatwallPathBuilder = slatwallPathBuilder;
        this.restrict = 'EA';
        this.scope = {};
        this.bindToController = {
            pageRecord: "=?"
        };
        this.controller = SWDeleteSkuPriceModalLauncherController;
        this.controllerAs = "swDeleteSkuPriceModalLauncher";
        this.compile = function (element, attrs) {
            return {
                pre: function ($scope, element, attrs) {
                },
                post: function ($scope, element, attrs) {
                }
            };
        };
        this.templateUrl = slatwallPathBuilder.buildPartialsPath(skuPartialsPath) + "deleteskupricemodallauncher.html";
    }
    SWDeleteSkuPriceModalLauncher.Factory = function () {
        var directive = function ($hibachi, scopeService, skuPartialsPath, slatwallPathBuilder) { return new SWDeleteSkuPriceModalLauncher($hibachi, scopeService, skuPartialsPath, slatwallPathBuilder); };
        directive.$inject = [
            '$hibachi',
            'scopeService',
            'skuPartialsPath',
            'slatwallPathBuilder'
        ];
        return directive;
    };
    return SWDeleteSkuPriceModalLauncher;
}());
exports.SWDeleteSkuPriceModalLauncher = SWDeleteSkuPriceModalLauncher;


/***/ })

/******/ });
//# sourceMappingURL=slatwallAdmin.18af3aec37b99e88ac3b.bundle.js.map