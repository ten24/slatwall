var slatwalladmin;
(function (slatwalladmin) {
    var SlatwallInterceptor = (function () {
        function SlatwallInterceptor($q, $log, alertService) {
            var _this = this;
            this.$q = $q;
            this.$log = $log;
            this.alertService = alertService;
            this.request = function (config) {
                _this.$log.debug('request');
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
            this.requestError = function (rejection) {
                _this.$log.debug('requestError');
                return _this.$q.reject(rejection);
            };
            this.response = function (response) {
                _this.$log.debug('response');
                var messages = response.data.messages;
                var alerts = _this.alertService.formatMessagesToAlerts(messages);
                _this.alertService.addAlerts(alerts);
                return response;
            };
            this.responseError = function (rejection) {
                _this.$log.debug('responseReject');
                if (angular.isDefined(rejection.status) && rejection.status !== 404) {
                    if (angular.isDefined(rejection.data) && angular.isDefined(rejection.data.messages)) {
                        var messages = rejection.data.messages;
                        var alerts = _this.alertService.formatMessagesToAlerts(messages);
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
                _this.$q.reject(rejection);
                return rejection;
            };
            this.$q = $q;
            this.$log = $log;
            this.alertService = alertService;
        }
        SlatwallInterceptor.Factory = function ($q, $log, alertService) {
            return new SlatwallInterceptor($q, $log, alertService);
        };
        SlatwallInterceptor.$inject = ['$q', '$log', 'alertService'];
        return SlatwallInterceptor;
    })();
    slatwalladmin.SlatwallInterceptor = SlatwallInterceptor;
    angular.module('slatwalladmin').service('slatwallInterceptor', SlatwallInterceptor);
})(slatwalladmin || (slatwalladmin = {}));

//# sourceMappingURL=../services/slatwallInterceptor.js.map