//services return promises which can be handled uniquely based on success or failure by the controller
angular.module('slatwalladmin.services',[])
.provider('$slatwall',[
function(){
	var _baseUrl;
	return {
	    $get:['$q','$http','$log', function ($q,$http,$log)
	    {
	      return {
	    		//basic entity getter where id is optional, returns a promise
		  		getEntity:function(entityName, options){
		  			/*
		  			 *
		  			 * getEntity('Product', '12345-12345-12345-12345');
		  			 * getEntity('Product', {keywords='Hello'});
		  			 * 
		  			 */
		  			var params = {};
		  			if(typeof options === 'String') {
		  				var urlString = _baseUrl+'/index.cfm/?slatAction=api:main.get&entityName='+entityName+'&entityID='+options.id;
		  			} else {
		  				params['P:Current'] = options.currentPage || 1;
		  				params['P:Show'] = options.pageShow || 10;
		  				params.keywords = options.keywords || '';
		  				params.columnsConfig = options.columnsConfig || '';
		  				params.filterGroupsConfig = options.filterGroupsConfig || '';
		  				params.joinsConfig = options.joinsConfig || '';
		  				params.isDistinct = options.isDistinct || false;
		  				params.propertyIdentifiersList = options.propertyIdentifiersList || '';
		  				var urlString = _baseUrl+'/index.cfm/?slatAction=api:main.get&entityName='+entityName;
		  			}
		  			
		  			var deferred = $q.defer();
		  			if(angular.isDefined(options.id)) {
		  				urlString += '&entityId='+options.id;	
		  			}
		  			
		  			$http.get(urlString,{params:params})
		  			.success(function(data){
		  				deferred.resolve(data);
		  			}).error(function(reason){
		  				deferred.reject(reason);
		  			});
		  			return deferred.promise;
		  			
		  		},
		  		getEventOptions:function(entityName){
		  			var deferred = $q.defer();
		  			var urlString = _baseUrl+'/index.cfm/?slatAction=api:main.getEventOptionsByEntityName&entityName='+entityName;
		  			
		  			$http.get(urlString)
		  			.success(function(data){
		  				deferred.resolve(data);
		  			}).error(function(reason){
		  				deferred.reject(reason);
		  			});
		  			
		  			return deferred.promise;
		  		},
		  		getValidation:function(entityName){
		  			var deferred = $q.defer();
		  			var urlString = _baseUrl+'/index.cfm/?slatAction=api:main.getValidation&entityName='+entityName;
		  			
		  			$http.get(urlString)
		  			.success(function(data){
		  				deferred.resolve(data);
		  			}).error(function(reason){
		  				deferred.reject(reason);
		  			});
		  			
		  			return deferred.promise;
		  		},
		  		getPropertyDisplayData:function(entityName,options){
		  			var deferred = $q.defer();
		  			var urlString = _baseUrl+'/index.cfm/?slatAction=api:main.getPropertyDisplayData&entityName='+entityName;
		  			var params = {};
		  			params.propertyIdentifiersList = options.propertyIdentifiersList || '';
		  			$http.get(urlString,{params:params})
		  			.success(function(data){
		  				deferred.resolve(data);
		  			}).error(function(reason){
		  				deferred.reject(reason);
		  			});
		  			
		  			return deferred.promise;
		  		},
		  		getPropertyDisplayOptions:function(entityName,options){
		  			var deferred = $q.defer();
		  			var urlString = _baseUrl+'/index.cfm/?slatAction=api:main.getPropertyDisplayOptions&entityName='+entityName;
		  			var params = {};
		  			params.property = options.property || '';
		  			if(angular.isDefined(options.argument1)){
		  				params.argument1 = options.argument1;
		  			}
		  			
		  			$http.get(urlString,{params:params})
		  			.success(function(data){
		  				deferred.resolve(data);
		  			}).error(function(reason){
		  				deferred.reject(reason);
		  			});
		  			
		  			return deferred.promise;
		  		},
		  		/*
	  			 *
	  			 * getProcessObject(entityName, options);
	  			 * options = {
	  			 * 				id:id,
	  			 * 				context:context,
	  			 * 				propertyIdentifiers
	  			 * 			}
	  			 * 
	  			 */
		  		getProcessObject:function(entityName,options){
		  			var deferred = $q.defer();
		  			var urlString = _baseUrl+'/index.cfm/?slatAction=api:main.getProcessObject&entityName='+entityName;
		  			
		  			if(angular.isDefined(options.id)) {
		  				urlString += '&entityId='+options.id;	
		  			}
		  			var params = {
		  				context:options.context,
		  				propertyIdentifiersList:options.propertyIdentifiersList
		  			};
		  			$http.get(urlString,{params:params})
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

		  			var urlString = _baseUrl+'/index.cfm/?slatAction=api:main.post';	
		  			
		  			if(angular.isDefined(entityName)){
		  				params.entityName = entityName;
		  			}
		  			if(angular.isDefined(id)){
		  				params.entityID = id;
		  			}

		  			if(angular.isDefined(context)){
		  				params.context = context;
		  			}
		  			
		  			
		  			$http({
		  				url:urlString,
		  				method:'POST',
		  				data: $.param(params),
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
		  			var urlString = _baseUrl+'/index.cfm/?slatAction=api:main.getExistingCollectionsByBaseEntity&entityName=Slatwall'+entityName;
		  			
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
		  			var urlString = _baseUrl+'/index.cfm/?slatAction=api:main.getFilterPropertiesByBaseEntityName&EntityName='+entityName;
		  			
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
}]).config(function ($slatwallProvider) {
	$slatwallProvider.setBaseUrl($.slatwall.getConfig().baseURL);
});



var entityScript = document.createElement('script');
entityScript.type = 'text/javascript';
entityScript.async = true;
entityScript.src = '?slatAction=api:meta.jsobjects';

var scripts = document.getElementsByTagName('script')[0];
scripts.parentNode.insertBefore(entityScript, scripts);