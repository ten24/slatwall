'use strict';
angular.module('slatwalladmin').factory('slatwallInterceptor', [
    '$q',
    '$log',
    'alertService',
    function ($q, $log, alertService) {
        var interceptor = {
            'request': function (config) {
                $log.debug('request');
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
                return config;
            },
            'response': function (response) {
                $log.debug('response');
                var messages = response.data.messages;
                var alerts = alertService.formatMessagesToAlerts(messages);
                alertService.addAlerts(alerts);
                return response;
            },
            'requestError': function (rejection) {
                $log.debug('requestError');
                return $q.reject(rejection);
            },
            'responseError': function (rejection) {
                $log.debug('responseReject');
                if (angular.isDefined(rejection.status) && rejection.status !== 404) {
                    if (angular.isDefined(rejection.data) && angular.isDefined(rejection.data.messages)) {
                        var messages = rejection.data.messages;
                        var alerts = alertService.formatMessagesToAlerts(messages);
                        alertService.addAlerts(alerts);
                    }
                    else {
                        var message = {
                            msg: 'there was error retrieving data',
                            type: 'error'
                        };
                        alertService.addAlert(message);
                    }
                }
                return $q.reject(rejection);
            }
        };
        return interceptor;
    }
]);

//# sourceMappingURL=../services/slatwallInterceptor.js.map