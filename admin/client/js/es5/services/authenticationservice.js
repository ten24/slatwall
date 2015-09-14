/// <reference path='../../../../client/typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../client/typings/tsd.d.ts' />
var slatwalladmin;
(function (slatwalladmin) {
    //service
    var AuthenticationService = (function () {
        function AuthenticationService($window, $http) {
            var _this = this;
            this.$window = $window;
            this.$http = $http;
            this.authorize = function (access) {
                if (access === AccessLevels.user) {
                    return _this.isAuthenticated();
                }
                else {
                    return true;
                }
            };
            this.isAuthenticated = function () {
                return _this.$window.sessionStorage.token;
            };
            this.login = function (credentials) {
                var login = _this.$http.post('/api/auth/login', credentials);
                login.success(function (result) {
                    this.$window.sessionStorage.setItem('token', JSON.stringify(result.token));
                });
                return login;
            };
            this.logout = function () {
                // The backend doesn't care about logouts, delete the token and you're good to go.
                _this.$window.sessionStorage.removeItem('token');
            };
            this.register = function (formData) {
                _this.$window.sessionStorage.removeItem('auth_token');
                var register = _this.$http.post('/api/auth/register', formData);
                register.success(function (result) {
                    this.$window.sessionStorage.setItem('token', JSON.stringify(result.token));
                });
                return register;
            };
            this.$window = $window;
            this.$http = $http;
        }
        AuthenticationService.$inject = [
            '$window',
            '$http'
        ];
        return AuthenticationService;
    })();
    slatwalladmin.AuthenticationService = AuthenticationService;
    angular.module('slatwalladmin')
        .service('authenticationService', AuthenticationService);
})(slatwalladmin || (slatwalladmin = {}));

//# sourceMappingURL=../services/authenticationservice.js.map