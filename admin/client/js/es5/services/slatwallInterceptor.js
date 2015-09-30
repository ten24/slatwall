/// <reference path='../../../../client/typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../client/typings/tsd.d.ts' />
var slatwalladmin;
(function (slatwalladmin) {
    var SlatwallInterceptor = (function () {
        function SlatwallInterceptor($location, $window, $q, $log, $injector, alertService, baseURL, dialogService, utilityService) {
            var _this = this;
            this.$location = $location;
            this.$window = $window;
            this.$q = $q;
            this.$log = $log;
            this.$injector = $injector;
            this.alertService = alertService;
            this.baseURL = baseURL;
            this.dialogService = dialogService;
            this.utilityService = utilityService;
            this.urlParam = null;
            this.authHeader = 'Authorization';
            this.authPrefix = 'Bearer ';
            this.request = function (config) {
                _this.$log.debug('request');
                config.headers = config.headers || {};
                if (_this.$window.localStorage.getItem('token') && _this.$window.localStorage.getItem('token') !== "undefined") {
                    config.headers.Authorization = 'Bearer ' + _this.$window.localStorage.getItem('token');
                }
                var queryParams = _this.utilityService.getQueryParamsFromUrl(config.url);
                console.log(queryParams);
                if (config.method == 'GET' && (queryParams.slatAction && queryParams.slatAction === 'api:main.get')) {
                    config.method = 'POST';
                    config.data = {};
                    var data = {};
                    if (angular.isDefined(config.params)) {
                        data = config.params;
                    }
                    var params = {};
                    params.serializedJsonData = angular.toJson(data);
                    params.context = "GET";
                    config.data = $.param(params);
                    delete config.params;
                    config.headers['Content-Type'] = 'application/x-www-form-urlencoded';
                }
                else if (config.method == 'GET' && config.url.indexOf('.html') > 0 && config.url.indexOf('admin/client/partials') > 0) {
                    //all partials are bound to instantiation key
                    config.url = config.url + '?instantiationKey=' + $.slatwall.getConfig().instantiationKey;
                }
                return config;
            };
            this.requestError = function (rejection) {
                _this.$log.debug('requestError');
                return _this.$q.reject(rejection);
            };
            this.response = function (response) {
                _this.$log.debug('response');
                if (response.data.messages) {
                    var alerts = _this.alertService.formatMessagesToAlerts(response.data.messages);
                    _this.alertService.addAlerts(alerts);
                }
                return response;
            };
            this.responseError = function (rejection) {
                _this.$log.debug('responseReject');
                if (angular.isDefined(rejection.status) && rejection.status !== 404 && rejection.status !== 403 && rejection.status !== 401) {
                    if (rejection.data && rejection.data.messages) {
                        var alerts = _this.alertService.formatMessagesToAlerts(rejection.data.messages);
                        _this.alertService.addAlerts(alerts);
                    }
                    else {
                        var message = {
                            msg: 'there was error retrieving data',
                            type: 'error'
                        };
                        _this.alertService.addAlert(message);
                    }
                }
                if (rejection.status === 401) {
                    // handle the case where the user is not authenticated
                    if (rejection.data && rejection.data.messages) {
                        //var deferred = $q.defer(); 
                        var $http = _this.$injector.get('$http');
                        if (rejection.data.messages[0].message === 'timeout') {
                            //open dialog
                            _this.dialogService.addPageDialog('preprocesslogin', {});
                        }
                        else if (rejection.data.messages[0].message === 'invalid_token') {
                            return $http.get(baseURL + '/index.cfm/api/auth/login').then(function (loginResponse) {
                                _this.$window.localStorage.setItem('token', loginResponse.data.token);
                                rejection.config.headers = rejection.config.headers || {};
                                rejection.config.headers.Authorization = 'Bearer ' + _this.$window.localStorage.getItem('token');
                                return $http(rejection.config).then(function (response) {
                                    return response;
                                });
                            }, function (rejection) {
                                return rejection;
                            });
                        }
                    }
                }
                return rejection;
            };
            this.$location = $location;
            this.$window = $window;
            this.$q = $q;
            this.$log = $log;
            this.$injector = $injector;
            this.alertService = alertService;
            this.baseURL = baseURL;
            this.dialogService = dialogService;
            this.utilityService = utilityService;
        }
        SlatwallInterceptor.Factory = function ($location, $window, $q, $log, $injector, alertService, baseURL, dialogService, utilityService) {
            return new SlatwallInterceptor($location, $window, $q, $log, $injector, alertService, baseURL, dialogService, utilityService);
        };
        SlatwallInterceptor.$inject = ['$location', '$window', '$q', '$log', '$injector', 'alertService', 'baseURL', 'dialogService', 'utilityService'];
        return SlatwallInterceptor;
    })();
    slatwalladmin.SlatwallInterceptor = SlatwallInterceptor;
    angular.module('slatwalladmin').service('slatwallInterceptor', SlatwallInterceptor);
})(slatwalladmin || (slatwalladmin = {}));

//# sourceMappingURL=../services/slatwallInterceptor.js.map