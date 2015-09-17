/// <reference path='../../../../client/typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../client/typings/tsd.d.ts' />
var slatwalladmin;
(function (slatwalladmin) {
    class SlatwallInterceptor {
        constructor($window, $q, $log, $injector, alertService, baseURL, dialogService) {
            this.$window = $window;
            this.$q = $q;
            this.$log = $log;
            this.$injector = $injector;
            this.alertService = alertService;
            this.baseURL = baseURL;
            this.dialogService = dialogService;
            this.urlParam = null;
            this.authHeader = 'Authorization';
            this.authPrefix = 'Bearer ';
            this.request = (config) => {
                this.$log.debug('request');
                if (config.method == 'GET' && (config.url.indexOf('.html') == -1) && config.url.indexOf('.json') == -1) {
                    config.headers = config.headers || {};
                    if (this.$window.localStorage.getItem('token') && this.$window.localStorage.getItem('token') !== "undefined") {
                        config.headers.Authorization = 'Bearer ' + this.$window.localStorage.getItem('token');
                    }
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
            this.requestError = (rejection) => {
                this.$log.debug('requestError');
                return this.$q.reject(rejection);
            };
            this.response = (response) => {
                this.$log.debug('response');
                if (response.data.messages) {
                    var alerts = this.alertService.formatMessagesToAlerts(response.data.messages);
                    this.alertService.addAlerts(alerts);
                }
                return response;
            };
            this.responseError = (rejection) => {
                this.$log.debug('responseReject');
                if (angular.isDefined(rejection.status) && rejection.status !== 404) {
                    if (rejection.data && rejection.data.messages) {
                        var alerts = this.alertService.formatMessagesToAlerts(rejection.data.messages);
                        this.alertService.addAlerts(alerts);
                    }
                    else {
                        var message = {
                            msg: 'there was error retrieving data',
                            type: 'error'
                        };
                        this.alertService.addAlert(message);
                    }
                }
                if (rejection.status === 401) {
                    // handle the case where the user is not authenticated
                    if (rejection.data && rejection.data.messages) {
                        //var deferred = $q.defer(); 
                        var $http = this.$injector.get('$http');
                        if (rejection.data.messages[0].message === 'timeout') {
                            //open dialog
                            this.dialogService.addPageDialog('preprocesslogin', {}, deferred);
                        }
                        else if (rejection.data.messages[0].message === 'invalid_token') {
                            return $http.get(baseURL + '/index.cfm/api/auth/login').then((loginResponse) => {
                                console.log('test');
                                console.log(loginResponse);
                                this.$window.localStorage.setItem('token', loginResponse.data.token);
                                console.log(rejection);
                                rejection.config.headers = rejection.config.headers || {};
                                rejection.config.headers.Authorization = 'Bearer ' + this.$window.localStorage.getItem('token');
                                return $http(rejection.config).then(function (response) {
                                    console.log('repsonse');
                                    console.log(response);
                                });
                            }, function () {
                                // this.$q.reject(rejection);
                                console.log('token failure');
                            });
                        }
                    }
                }
                return rejection;
            };
            this.$window = $window;
            this.$q = $q;
            this.$log = $log;
            this.$injector = $injector;
            this.alertService = alertService;
            this.baseURL = baseURL;
            this.dialogService = dialogService;
        }
        static Factory($window, $q, $log, $injector, alertService, baseURL, dialogService) {
            return new SlatwallInterceptor($window, $q, $log, $injector, alertService, baseURL, dialogService);
        }
    }
    SlatwallInterceptor.$inject = ['$window', '$q', '$log', '$injector', 'alertService', 'baseURL', 'dialogService'];
    slatwalladmin.SlatwallInterceptor = SlatwallInterceptor;
    angular.module('slatwalladmin').service('slatwallInterceptor', SlatwallInterceptor);
})(slatwalladmin || (slatwalladmin = {}));

//# sourceMappingURL=../services/slatwallInterceptor.js.map