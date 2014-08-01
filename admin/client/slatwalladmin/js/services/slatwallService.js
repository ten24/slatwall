//services return promises which can be handled uniquely based on success or failure by the controller

angular.module('slatwalladmin.services',[]).config(["$provide", function ($provide) {
    $provide.constant("baseURL", 'http://cf10.localhost/');
}])
.factory('slatwallService',['$http','$q','baseURL',
function($http,$q,baseURL){
	var factory = {};
	//basic entity getter where id is optional, returns a promise
	factory.getEntity = function(entityName,id){
		
		var deferred = $q.defer();
		var urlString = baseURL+'index.cfm/?slatAction=api:main.get&entityName='+entityName;
		if(typeof id !== "undefined") {
			urlString += '&entityId='+id;	
		}
			
		$http.get(urlString)
		.success(function(data){
			deferred.resolve(data);
		}).error(function(reason){
			deferred.resolve(reason);
		});
		return deferred.promise;
		
	},
	factory.saveEntity = function(entityName,id,params){
		var deferred = $q.defer();
		var urlString = baseURL+'index.cfm/?slatAction=api:main.post&entityName='+entityName+'&entityId='+id;	
			
		$http({
			method:'POST',
			url:urlString,
			params: params,
			headers: {'Content-Type': 'application/x-www-form-urlencoded'}
		})
		.success(function(data){
			deferred.resolve(data);
		}).error(function(reason){
			deferred.resolve(reason);
		});
		return deferred.promise;
	},
	factory.getExistingCollectionsByBaseEntity = function(){
		var deferred = $q.defer();
		var urlString = baseURL+'index.cfm/?slatAction=api:main.getExistingCollections';
		
		$http.get(urlString)
		.success(function(data){
			deferred.resolve(data);
		}).error(function(reason){
			deferred.resolve(reason);
		});
		return deferred.promise;
		
	},
	factory.getFilterPropertiesByBaseEntityName = function(entityName){
		var deferred = $q.defer();
		var urlString = baseURL+'index.cfm/?slatAction=api:main.getFilterPropertiesByBaseEntityName&EntityName='+entityName;
		
		$http.get(urlString)
		.success(function(data){
			deferred.resolve(data);
		}).error(function(reason){
			deferred.resolve(reason);
		});
		return deferred.promise;
	}
	/*,
	factory.formatFilterProperties = function(filterProperties){
		for(var i in filterProperties.DATA){
			var filterProperty = filterProperties.DATA[i];
			if(typeof id !== "undefined") {
			console.log(filterProperty);
		}
		return filterProperties;
	}
	*/
	
	
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
