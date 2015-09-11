var slatwalladmin;
(function (slatwalladmin) {
    class SlatwallInterceptor {
        constructor($q, $log, alertService) {
            this.$q = $q;
            this.$log = $log;
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
                return this.$q.reject(rejection);
            };
            this.$q = $q;
            this.$log = $log;
            this.alertService = alertService;
        }
        static Factory($q, $log, alertService) {
            return new SlatwallInterceptor($q, $log, alertService);
        }
    }
    SlatwallInterceptor.$inject = ['$q', '$log', 'alertService'];
    slatwalladmin.SlatwallInterceptor = SlatwallInterceptor;
    angular.module('slatwalladmin').service('slatwallInterceptor', SlatwallInterceptor);
})(slatwalladmin || (slatwalladmin = {}));

//# sourceMappingURL=../services/slatwallInterceptor.js.map