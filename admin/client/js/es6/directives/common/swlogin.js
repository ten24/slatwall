/// <reference path='../../../../../client/typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../../client/typings/tsd.d.ts' />
var slatwalladmin;
(function (slatwalladmin) {
    'use strict';
    class SWLoginController {
        constructor($route, $log, $window, partialsPath, $slatwall, dialogService) {
            this.$route = $route;
            this.$log = $log;
            this.$window = $window;
            this.partialsPath = partialsPath;
            this.$slatwall = $slatwall;
            this.dialogService = dialogService;
            this.login = () => {
                var loginPromise = this.$slatwall.login(this.account_login.data.emailAddress, this.account_login.data.password);
                loginPromise.then((loginResponse) => {
                    if (loginResponse && loginResponse.data && loginResponse.data.token) {
                        this.$window.localStorage.token = loginResponse.data.token.token;
                        this.$route.reload();
                        this.dialogService.removeCurrentDialog();
                    }
                });
            };
            this.$slatwall = $slatwall;
            this.$window = $window;
            this.$route = $route;
            this.account_login = $slatwall.newEntity('Account_Login');
        }
    }
    slatwalladmin.SWLoginController = SWLoginController;
    class SWLogin {
        constructor($route, $log, $window, partialsPath, $slatwall, dialogService) {
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
            this.link = (scope, element, attrs) => {
            };
            this.templateUrl = this.partialsPath + '/login.html';
        }
    }
    slatwalladmin.SWLogin = SWLogin;
    angular.module('slatwalladmin').directive('swLogin', ['$route', '$log', '$window', 'partialsPath', '$slatwall', ($route, $log, $window, partialsPath, $slatwall, dialogService) => new SWLogin($route, $log, $window, partialsPath, $slatwall, dialogService)]);
})(slatwalladmin || (slatwalladmin = {}));

//# sourceMappingURL=../../directives/common/swlogin.js.map