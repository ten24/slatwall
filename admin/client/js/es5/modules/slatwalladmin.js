/// <reference path="../../../../client/typings/tsd.d.ts" />
/// <reference path="../../../../client/typings/slatwallTypeScript.d.ts" />
(function () {
    var app = angular.module('slatwalladmin', ['hibachi', 'ngSlatwall', 'ngSlatwallModel', 'ui.bootstrap', 'ngAnimate', 'ngRoute', 'ngCkeditor']);
    app.config(["$provide", '$logProvider', '$filterProvider', '$httpProvider', '$routeProvider', '$injector', '$locationProvider', 'datepickerConfig', 'datepickerPopupConfig',
        function ($provide, $logProvider, $filterProvider, $httpProvider, $routeProvider, $injector, $locationProvider, datepickerConfig, datepickerPopupConfig) {
            datepickerConfig.showWeeks = false;
            datepickerConfig.format = 'MMM dd, yyyy hh:mm a';
            datepickerPopupConfig.toggleWeeksText = null;
            if (slatwallAngular.hashbang) {
                $locationProvider.html5Mode(false).hashPrefix('!');
            }
            //
            $provide.constant("baseURL", $.slatwall.getConfig().baseURL);
            var _partialsPath = $.slatwall.getConfig().baseURL + '/admin/client/partials/';
            $provide.constant("partialsPath", _partialsPath);
            $provide.constant("productBundlePartialsPath", _partialsPath + 'productbundle/');
            angular.forEach(slatwallAngular.constantPaths, function (constantPath, key) {
                var constantKey = constantPath.charAt(0).toLowerCase() + constantPath.slice(1) + 'PartialsPath';
                var constantPartialsPath = _partialsPath + constantPath.toLowerCase() + '/';
                $provide.constant(constantKey, constantPartialsPath);
            });
            $logProvider.debugEnabled($.slatwall.getConfig().debugFlag);
            $filterProvider.register('likeFilter', function () {
                return function (text) {
                    if (angular.isDefined(text) && angular.isString(text)) {
                        return text.replace(new RegExp('%', 'g'), '');
                    }
                };
            });
            $filterProvider.register('truncate', function () {
                return function (input, chars, breakOnWord) {
                    if (isNaN(chars))
                        return input;
                    if (chars <= 0)
                        return '';
                    if (input && input.length > chars) {
                        input = input.substring(0, chars);
                        if (!breakOnWord) {
                            var lastspace = input.lastIndexOf(' ');
                            //get last space
                            if (lastspace !== -1) {
                                input = input.substr(0, lastspace);
                            }
                        }
                        else {
                            while (input.charAt(input.length - 1) === ' ') {
                                input = input.substr(0, input.length - 1);
                            }
                        }
                        return input + '...';
                    }
                    return input;
                };
            });
            $httpProvider.interceptors.push('slatwallInterceptor');
            // route provider configuration
            $routeProvider.when('/entity/:entityName/', {
                template: function (params) {
                    var entityDirectiveExists = $injector.has('sw' + params.entityName + 'ListDirective');
                    if (entityDirectiveExists) {
                        return '<sw-' + params.entityName.toLowerCase() + '-list>';
                    }
                    else {
                        return '<sw-list></sw-list>';
                    }
                },
                controller: 'routerController'
            }).when('/entity/:entityName/:entityID', {
                template: function (params) {
                    var entityDirectiveExists = $injector.has('sw' + params.entityName + 'DetailDirective');
                    if (entityDirectiveExists) {
                        return '<sw-' + params.entityName.toLowerCase() + '-detail>';
                    }
                    else {
                        return '<sw-detail></sw-detail>';
                    }
                },
                controller: 'routerController',
            }).otherwise({
                //controller:'otherwiseController'        
                templateUrl: $.slatwall.getConfig().baseURL + '/admin/client/js/partials/otherwise.html',
            });
        }]).run(['$rootScope', '$filter', '$anchorScroll', '$slatwall', 'dialogService', 'observerService', 'utilityService', function ($rootScope, $filter, $anchorScroll, $slatwall, dialogService, observerService, utilityService) {
            $anchorScroll.yOffset = 100;
            $rootScope.openPageDialog = function (partial) {
                dialogService.addPageDialog(partial);
            };
            $rootScope.closePageDialog = function (index) {
                dialogService.removePageDialog(index);
            };
            $rootScope.loadedResourceBundle = false;
            $rootScope.loadedResourceBundle = $slatwall.hasResourceBundle();
            $rootScope.buildUrl = $slatwall.buildUrl;
            $rootScope.createID = utilityService.createID;
            var rbListener = $rootScope.$watch('loadedResourceBundle', function (newValue, oldValue) {
                if (newValue !== oldValue) {
                    $rootScope.$broadcast('hasResourceBundle');
                    rbListener();
                }
            });
        }]).filter('entityRBKey', ['$slatwall', function ($slatwall) {
            return function (text) {
                if (angular.isDefined(text) && angular.isString(text)) {
                    text = text.replace('_', '').toLowerCase();
                    text = $slatwall.getRBKey('entity.' + text);
                    return text;
                }
            };
        }]).filter('swcurrency', ['$slatwall', '$sce', '$log', function ($slatwall, $sce, $log) {
            var data = null, serviceInvoked = false;
            function realFilter(value, decimalPlace) {
                // REAL FILTER LOGIC, DISREGARDING PROMISES
                if (!angular.isDefined(data)) {
                    $log.debug("Please provide a valid currencyCode, swcurrency defaults to $");
                    data = "$";
                }
                if (angular.isDefined(value)) {
                    if (angular.isDefined(decimalPlace)) {
                        value = parseFloat(value.toString()).toFixed(decimalPlace);
                    }
                    else {
                        value = parseFloat(value.toString()).toFixed(2);
                    }
                }
                return data + value;
            }
            filterStub.$stateful = true;
            function filterStub(value, currencyCode, decimalPlace) {
                if (data === null) {
                    if (!serviceInvoked) {
                        serviceInvoked = true;
                        $slatwall.getCurrencies().then(function (currencies) {
                            var result = currencies.data;
                            data = result[currencyCode];
                        });
                    }
                    return "-";
                }
                else
                    return realFilter(value, decimalPlace);
            }
            return filterStub;
        }]);
})();

//# sourceMappingURL=../modules/slatwalladmin.js.map