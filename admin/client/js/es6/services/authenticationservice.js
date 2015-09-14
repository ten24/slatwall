/// <reference path='../../../../client/typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../client/typings/tsd.d.ts' />
var slatwalladmin;
(function (slatwalladmin) {
    //service
    class AuthenticationService {
        constructor($window, $http) {
            this.$window = $window;
            this.$http = $http;
            this.authorize = (access) => {
                if (access === AccessLevels.user) {
                    return this.isAuthenticated();
                }
                else {
                    return true;
                }
            };
            this.isAuthenticated = () => {
                return this.$window.sessionStorage.token;
            };
            this.login = (credentials) => {
                var login = this.$http.post('/api/auth/login', credentials);
                login.success(function (result) {
                    this.$window.sessionStorage.setItem('token', JSON.stringify(result.token));
                });
                return login;
            };
            this.logout = () => {
                // The backend doesn't care about logouts, delete the token and you're good to go.
                this.$window.sessionStorage.removeItem('token');
            };
            this.register = (formData) => {
                this.$window.sessionStorage.removeItem('auth_token');
                var register = this.$http.post('/api/auth/register', formData);
                register.success(function (result) {
                    this.$window.sessionStorage.setItem('token', JSON.stringify(result.token));
                });
                return register;
            };
            this.$window = $window;
            this.$http = $http;
        }
    }
    AuthenticationService.$inject = [
        '$window',
        '$http'
    ];
    slatwalladmin.AuthenticationService = AuthenticationService;
    angular.module('slatwalladmin')
        .service('authenticationService', AuthenticationService);
})(slatwalladmin || (slatwalladmin = {}));

//# sourceMappingURL=../services/authenticationservice.js.map