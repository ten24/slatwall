/// <reference path='../../../../client/typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../client/typings/tsd.d.ts' />
var slatwalladmin;
(function (slatwalladmin) {
    class SlatwallInterceptor {
        constructor($q, $log, $injector, $rootScope, alertService) {
            this.$q = $q;
            this.$log = $log;
            this.$injector = $injector;
            this.$rootScope = $rootScope;
            this.alertService = alertService;
            this.request = (config) => {
                this.$log.debug('request');
                if (config.method == 'GET' && (config.url.indexOf('.html') == -1) && config.url.indexOf('.json') == -1) {
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
                var messages = response.data.messages;
                var alerts = this.alertService.formatMessagesToAlerts(messages);
                this.alertService.addAlerts(alerts);
                return response;
            };
            this.responseError = (rejection) => {
                this.$log.debug('responseReject');
                if (angular.isDefined(rejection.status) && rejection.status !== 404) {
                    if (angular.isDefined(rejection.data) && angular.isDefined(rejection.data.messages)) {
                        var messages = rejection.data.messages;
                        var alerts = this.alertService.formatMessagesToAlerts(messages);
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
                else if (angular.isDefined(rejection.status) && rejection.status !== 401) {
                    var deferred = this.$q.defer();
                    // defer until we can re-request a new token 
                    // Get a new token... (cannot inject $http directly as will cause a circular ref) 
                    this.$injector.get("$http").jsonp('/some/endpoint/that/reissues/tokens?cb=JSON_CALLBACK').then((loginResponse) => {
                        if (loginResponse.data) {
                            this.$rootScope.oauth = loginResponse.data.oauth;
                            // we have a new oauth token - set at $rootScope 
                            // now let's retry the original request - transformRequest in .run() below will add the new OAuth token 
                            this.$injector.get("$http")(response.config).then((response) => {
                                // we have a successful response - resolve it using deferred 
                                deferred.resolve(response);
                            }, (response) => {
                                deferred.reject();
                                // something went wrong 
                            });
                        }
                        else {
                            deferred.reject();
                        }
                    }, function (response) {
                        deferred.reject();
                        // token retry failed, redirect so user can login again 
                        this.$location.path('/user/sign/in');
                        return;
                    });
                    return deferred.promise;
                }
                return this.$q.reject(rejection);
            };
            this.$q = $q;
            this.$log = $log;
            this.alertService = alertService;
            this.$injector = $injector;
            this.$rootScope = $rootScope;
        }
        static Factory($q, $log, $injector, $rootScope, alertService) {
            return new SlatwallInterceptor($q, $log, $injector, $rootScope, alertService);
        }
    }
    SlatwallInterceptor.$inject = ['$q', '$log', '$injector', '$rootScope', 'alertService'];
    slatwalladmin.SlatwallInterceptor = SlatwallInterceptor;
    angular.module('slatwalladmin').service('slatwallInterceptor', SlatwallInterceptor);
})(slatwalladmin || (slatwalladmin = {}));

//# sourceMappingURL=../services/slatwallInterceptor.js.map