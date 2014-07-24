'use strict';
angular.module('slatwall', [])
/*.config(function($httpProvider){
	//Build our interceptor here 
	var interceptor = function($q,$rootScoope, Auth){
		return {
			
			'request': function(req) {
				req.params = req.params || {};
				if (Session.isAuthenticated() && !req.params.token) {
        			req.params.token = Auth.getToken();
					return req; 
				}
			},
			'requestError': function(reqErr) { 
				return reqErr;
			},
			'response':function(response){
				if(response.config.url == '/api/login'){
					//assumes that our api responds with auth token
					Auth.setToken(response.data.token);
				}
				return response;
			},
			'responseError':function(response){
				//Handle errors
				switch(response.status){
					case 401:
						if (rejection.config.url!=='api/login')
			              // If we're not on the login page
			              $rootScope
		                .$broadcast('auth:loginRequired');
						break;
					case 403: $rootScope
						.$broadcast('auth:forbidden'); 
						break;
					case 404: $rootScope
						.$broadcast('page:notFound'); 
						break;
					case 500: $rootScope
						.$broadcast('server:error'); 
						break;
				}
				return $q.reject(rejection);
			}
		}
	}
	
	$httpProvider.interceptors.push(interceptor);
}).run(function($rootScope,$location,Auth){
  // Set a watch on the $routeChangeStart
	$rootScope.$on('$routeChangeStart', function(evt, next, curr) {
		if (!Auth.isAuthorized(next.$$route.access_level)) { 
			if (Auth.isLoggedIn()) {
				// The user is logged in, but does not // have permissions to view the view $location.path('/');
			} else { 
				$location.path('/login');
			} 
		}
	})
});*/

