angular.module('slatwalladmin.services',['ngResource','ngCookies']).config(["$provide", function ($provide) {
    $provide.constant("baseURL", 'http://cf10.localhost/');
}])
.factory('slatwallService',['$http','$q','baseURL',
function($http,$q,baseURL){
	var factory = {};
	//basic entity getter where id is optional, returns a promise
	factory.getEntity = function(entityName,id){
		if(typeof id === "undefined") {
			id = '';	
		}
		
		var deferred = $q.defer();		
		$http.get(baseURL+'index.cfm/api/'+entityName+'/'+id)
		.success(function(data){
			deferred.resolve(data);
		}).error(function(){
			deferred.resolve(data);
		});
		return deferred.promise;
		
	}
	return factory;
}]);

/*.factory('Auth',function($cookieStore, ACCESS_LEVELS){
	var _user = $cookieStore.get('user');
	
	var setUser = function(user) {
		if (!user.role || user.role < 0) {
		      user.role = ACCESS_LEVELS.pub;
	    }
		_user = user;
	    $cookieStore.put('user', _user);
	}
	
	return {
		isAuthorized: function(lvl) {
			return _user.role >= lvl; 
		},
		setUser: setUser, isLoggedIn: function() {
			return _user ? true : false; 
		},
		getUser: function() { 
			return _user;
		},
		getId: function() {
			return _user ? _user._id : null; 
		},
		getToken: function() {
			return _user ? _user.token : '';
		},
		logout: function() {
		    $cookieStore.remove('user');
			_user = null; 
		}
	}	
});

*/
