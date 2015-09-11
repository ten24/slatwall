/// <reference path='../../../../client/typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../client/typings/tsd.d.ts' />

module slatwalladmin{
    //service
    
    export class AuthenticationService{
        public static $inject = [
            '$window',
            '$http'
        ];
        
        public constructor(
            private $window:ng.IWindowService,
            private $http:ng.IHttpService
        ) {
            this.$window = $window;
            this.$http = $http;
        }
        
        public authorize = (access)=> {
          if (access === AccessLevels.user) {
            return this.isAuthenticated();
          } else {
            return true;
          }
        }
        public isAuthenticated = () {
          return this.$window.sessionStorage.token;
        }
        public login = (credentials) =>{
          var login = this.$http.post('/api/auth/login', credentials);
          
          login.success(function(result) {
            this.$window.sessionStorage.setItem('token',JSON.stringify(result.token));
          });
          return login;
        }
        public logout = () =>{
          // The backend doesn't care about logouts, delete the token and you're good to go.
          this.$window.sessionStorage.removeItem('token');
        }
        public register = (formData) =>{
          this.$window.sessionStorage.removeItem('auth_token');
          var register = this.$http.post('/api/auth/register', formData);
          register.success(function(result) {
            this.$window.sessionStorage.setItem('token',JSON.stringify(result.token));
          });
          return register;
        }
        
        
       
        
    }  
    angular.module('slatwalladmin')
    .service('authenticationService',AuthenticationService); 
}
    
