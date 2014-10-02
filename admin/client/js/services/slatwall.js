//services return promises which can be handled uniquely based on success or failure by the controller
angular.module('slatwalladmin.services',[])
.provider('$slatwall',
function(){
	var _baseUrl;
	return {
	    $get:['$q','$http','$log', function ($q,$http,$log)
	    {
	      return {
	    		//basic entity getter where id is optional, returns a promise
		  		getEntity:function(entityName,id,currentPage,pageShow,keywords){
		  			if(angular.isUndefined(currentPage)){
		  				currentPage = 1;
		  			}
		  			if(angular.isUndefined(pageShow)){
		  				pageShow = 10;
		  			}
		  			if(angular.isUndefined(keywords)){
		  				keywords = "";
		  			}
		  			
		  			var deferred = $q.defer();
		  			var urlString = _baseUrl+'index.cfm/?slatAction=api:main.get&entityName='+entityName+'&P:Current='+currentPage+'&P:Show='+pageShow+'&keywords='+keywords;
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
		  		getValidation:function(validationFileName){
		  			var deferred = $q.defer();
		  			var urlString = _baseUrl+'model/validation/'+validationFileName+'.json';
		  			$http.get(urlString)
		  			.success(function(data){
		  				deferred.resolve(data);
		  			}).error(function(reason){
		  				deferred.reject(reason);
		  			});
		  			
		  			return deferred.promise;
		  		},
		  		getProcessObject:function(entityName,id,context,propertyIdentifiers){
		  			var deferred = $q.defer();
		  			var urlString = _baseUrl+'index.cfm/?slatAction=api:main.getProcessObject&entityName='+entityName+'&context='+context+'&propertyIdentifiers='+propertyIdentifiers;
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
		  		saveEntity:function(entityName,id,params,context){
		  			$log.debug('save'+ entityName);
		  			var deferred = $q.defer();
		  			var urlString = _baseUrl+'index.cfm/?slatAction=api:main.post&entityName='+entityName+'&entityId='+id;	
		  			if(angular.isDefined(context)){
		  				params.context = context;
		  			}
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
		  		getExistingCollectionsByBaseEntity:function(entityName){
		  			var deferred = $q.defer();
		  			var urlString = _baseUrl+'index.cfm/?slatAction=api:main.getExistingCollectionsByBaseEntity&entityName=Slatwall'+entityName;
		  			
		  			$http.get(urlString)
		  			.success(function(data){
		  				deferred.resolve(data);
		  			}).error(function(reason){
		  				deferred.reject(reason);
		  			});
		  			return deferred.promise;
		  			
		  		},
		  		getFilterPropertiesByBaseEntityName:function(entityName){
		  			var deferred = $q.defer();
		  			var urlString = _baseUrl+'index.cfm/?slatAction=api:main.getFilterPropertiesByBaseEntityName&EntityName='+entityName;
		  			
		  			$http.get(urlString)
		  			.success(function(data){
		  				deferred.resolve(data);
		  			}).error(function(reason){
		  				deferred.reject(reason);
		  			});
		  			return deferred.promise;
		  		}
		  	};
	    }],
	    setBaseUrl: function(baseUrl){
	    	_baseUrl=baseUrl;
	    }
	};
}).config(function ($slatwallProvider) {
	$slatwallProvider.setBaseUrl($.slatwall.getConfig().baseURL);
});

