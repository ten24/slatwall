/// <reference path="../../../../client/typings/tsd.d.ts" />
/// <reference path="../../../../client/typings/slatwallTypeScript.d.ts" />
(function () {
    var app = angular.module('slatwalladmin', ['ngSlatwall', 'ngSlatwallModel', 'ui.bootstrap', 'ngAnimate', 'ngRoute', 'ngSanitize', 'ngCkeditor']);
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
        }]).run(['$rootScope', '$filter', '$anchorScroll', '$slatwall', 'dialogService', function ($rootScope, $filter, $anchorScroll, $slatwall, dialogService) {
            $anchorScroll.yOffset = 100;
            $rootScope.openPageDialog = function (partial) {
                dialogService.addPageDialog(partial);
            };
            $rootScope.closePageDialog = function (index) {
                dialogService.removePageDialog(index);
            };
            $rootScope.loadedResourceBundle = false;
            $rootScope.loadedResourceBundle = $slatwall.hasResourceBundle();
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
        }]).filter('swcurrency', ['$slatwall', '$sce', function ($slatwall, $sce) {
            var data = null, serviceInvoked = false;
            function realFilter(value) {
                // REAL FILTER LOGIC, DISREGARDING PROMISES
                return data + value;
            }
            filterStub.$stateful = true;
            function filterStub(value, currencyCode) {
                if (data === null) {
                    if (!serviceInvoked) {
                        console.log("SIMULATION OF ASYNC CALL");
                        serviceInvoked = true;
                        $slatwall.getCurrencies().then(function (currencies) {
                            console.log('test');
                            console.log(currencies);
                            var result = currencies.data;
                            data = result[currencyCode];
                        });
                    }
                    return "-";
                }
                else
                    return realFilter(value);
            }
            return filterStub;
            //        var data = null, serviceInvoked = false;
            //        function realFilter(value) {
            //            // REAL FILTER LOGIC, DISREGARDING PROMISES
            //            return data[currencyCode] + value;
            //        }
            //        
            //        return function(value) {
            //            if( data === null ) {
            //                if( !serviceInvoked ) {
            //                    console.log("SIMULATION OF ASYNC CALL");
            //                    serviceInvoked = true;
            //                    $slatwall.getCurrencies().then((result)=> {
            //                        data = result;
            //                        $timeout(function(){});
            //                        
            //                        
            //                    });
            //                    return "-";
            //                }
            //                
            //            }
            //            else return realFilter(value);
            //        }  
            //        return (text,currencyCode)=>{
            //               console.log('filterrus');
            //               console.log(text);
            //               console.log(currencyCode);
            //               console.log($rootScope.currencies[currencyCode]);
            //                if(angular.isDefined(text) && angular.isString(text)){
            //                    text = $rootScope.currencies[currencyCode] + text;
            //                    return text;
            //                }
            //            }; 
        }]);
})();

//# sourceMappingURL=../modules/slatwalladmin.js.map