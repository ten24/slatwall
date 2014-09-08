//services return promises which can be handled uniquely based on success or failure by the controller
angular.module('slatwalladmin.services',[]).config(["$provide", function ($provide) {
    $provide.constant("baseURL", '/');
}])
.factory('slatwallService',['$http','$q','baseURL','$log',
function($http,$q,baseURL,$log){
	var factory = {};
	
	//basic entity getter where id is optional, returns a promise
	factory.getEntity = function(entityName,id){
		
		var deferred = $q.defer();
		var urlString = baseURL+'index.cfm/?slatAction=api:main.get&entityName='+entityName;
		if(angular.isDefined(id)) {
			urlString += '&entityId='+id;	
		}
			
		$http.get(urlString)
		.success(function(data){
			deferred.resolve(data);
		}).error(function(reason){
			deferred.reject(reason);
		});
		return deferred.promise;
		
	},
	factory.saveEntity = function(entityName,id,params){
		$log.debug('save'+ entityName);
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
			deferred.reject(reason);
		});
		return deferred.promise;
	},
	factory.getExistingCollectionsByBaseEntity = function(entityName){
		var deferred = $q.defer();
		var urlString = baseURL+'index.cfm/?slatAction=api:main.getExistingCollectionsByBaseEntity&entityName=Slatwall'+entityName;
		
		$http.get(urlString)
		.success(function(data){
			deferred.resolve(data);
		}).error(function(reason){
			deferred.reject(reason);
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
			deferred.reject(reason);
		});
		return deferred.promise;
	};
	
	
	return factory;
}]);

