/// <reference path='../../../../../client/typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../../client/typings/tsd.d.ts' />
var slatwalladmin;
(function (slatwalladmin) {
    'use strict';
    var SWLoginController = (function () {
        function SWLoginController($route, $log, $window, partialsPath, $slatwall, dialogService) {
            var _this = this;
            this.$route = $route;
            this.$log = $log;
            this.$window = $window;
            this.partialsPath = partialsPath;
            this.$slatwall = $slatwall;
            this.dialogService = dialogService;
            this.login = function () {
                var loginPromise = _this.$slatwall.login(_this.account_login.data.emailAddress, _this.account_login.data.password);
                loginPromise.then(function (loginResponse) {
                    if (loginResponse && loginResponse.data && loginResponse.data.token) {
                        _this.$window.localStorage.setItem('token', loginResponse.data.token);
                        _this.$route.reload();
                        _this.dialogService.removeCurrentDialog();
                    }
                });
            };
            this.$slatwall = $slatwall;
            this.$window = $window;
            this.$route = $route;
            this.account_login = $slatwall.newEntity('Account_Login');
        }
        return SWLoginController;
    })();
    slatwalladmin.SWLoginController = SWLoginController;
    var SWLogin = (function () {
        function SWLogin($route, $log, $window, partialsPath, $slatwall, dialogService) {
            this.$route = $route;
            this.$log = $log;
            this.$window = $window;
            this.partialsPath = partialsPath;
            this.$slatwall = $slatwall;
            this.dialogService = dialogService;
            this.restrict = 'E';
            this.scope = {};
            this.bindToController = {};
            this.controller = SWLoginController;
            this.controllerAs = "SwLogin";
            this.link = function (scope, element, attrs) {
            };
            this.templateUrl = this.partialsPath + '/login.html';
        }
        return SWLogin;
    })();
    slatwalladmin.SWLogin = SWLogin;
    angular.module('slatwalladmin').directive('swLogin', ['$route', '$log', '$window', 'partialsPath', '$slatwall', function ($route, $log, $window, partialsPath, $slatwall, dialogService) { return new SWLogin($route, $log, $window, partialsPath, $slatwall, dialogService); }]);
})(slatwalladmin || (slatwalladmin = {}));

//# sourceMappingURL=../../directives/common/swlogin.js.map