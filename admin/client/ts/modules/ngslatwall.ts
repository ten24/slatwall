
angular.module('ngSlatwall',[])
.provider('$slatwall',[ 
function(){
    var _deferred = {};
    var _config = {
        dateFormat : 'MM/DD/YYYY',
        timeFormat : 'HH:MM',
        rbLocale : '',
        baseURL : '/',
        applicationKey : 'Slatwall',
        debugFlag : true,
        instantiationKey : '84552B2D-A049-4460-55F23F30FE7B26AD'
    };
    
    if(slatwallAngular.slatwallConfig){
        angular.extend(_config, slatwallAngular.slatwallConfig);
    }
    
    return {
        
        $get:['$q',
            '$http',
            '$timeout',
            '$log',
            '$rootScope',
            '$location',
            '$anchorScroll',
            'utilityService', 
            'formService', 
            function (
                $q,
                $http,
                $timeout,
                $log,
                $rootScope,
                $location,
                $anchorScroll,
                utilityService,
                formService
            )
        {
            var slatwallService = {
                setJsEntities: function(jsEntities){
                    _jsEntities=jsEntities;
                },
                getJsEntities: function(){
                    return _jsEntities;
                },
                //service method used to transform collection data to collection objects based on a collectionconfig
                populateCollection:function(collectionData,collectionConfig){
                    //create array to hold objects
                    var entities = [];
                    //loop over all collection data to create objects
                    angular.forEach(collectionData, function(collectionItemData, key){
                        //create base Entity
                        var entity = slatwallService['new'+collectionConfig.baseEntityName.replace('Slatwall','')]();
                        //populate entity with data based on the collectionConfig
                        angular.forEach(collectionConfig.columns, function(column, key){
                            //get objects base properties
                            var propertyIdentifier = column.propertyIdentifier.replace(collectionConfig.baseEntityAlias.toLowerCase()+'.','');
                            var propertyIdentifierArray = propertyIdentifier.split('.');
                            var propertyIdentifierKey = propertyIdentifier.replace(/\./g,'_');
                            var currentEntity = entity;
                            angular.forEach(propertyIdentifierArray,function(property,key){
                                if(key === propertyIdentifierArray.length-1){
                                    //if we are on the last item in the array
                                    if(angular.isObject(collectionItemData[propertyIdentifierKey]) && currentEntity.metaData[property].fieldtype === 'many-to-one'){
                                        var relatedEntity = slatwallService['new'+currentEntity.metaData[property].cfc]();
                                        relatedEntity.$$init(collectionItemData[propertyIdentifierKey][0]);
                                        currentEntity['$$set'+currentEntity.metaData[property].name.charAt(0).toUpperCase()+currentEntity.metaData[property].name.slice(1)](relatedEntity);
                                    }else if(angular.isArray(collectionItemData[propertyIdentifierKey]) && (currentEntity.metaData[property].fieldtype === 'one-to-many')){
                                        angular.forEach(collectionItemData[propertyIdentifierKey],function(arrayItem,key){
                                            var relatedEntity = slatwallService['new'+currentEntity.metaData[property].cfc]();
                                            relatedEntity.$$init(arrayItem);
                                            currentEntity['$$add'+currentEntity.metaData[property].singularname.charAt(0).toUpperCase()+currentEntity.metaData[property].singularname.slice(1)](relatedEntity);
                                        });
                                    }else{
                                        currentEntity.data[property] = collectionItemData[propertyIdentifierKey];
                                    }
                                }else{
                                    var propertyMetaData = currentEntity.metaData[property];
                                    if(angular.isUndefined(currentEntity.data[property])){
                                        if(propertyMetaData.fieldtype === 'one-to-many'){
                                            relatedEntity = [];
                                        }else{
                                            relatedEntity = slatwallService['new'+propertyMetaData.cfc]();
                                        }
                                    }else{
                                        relatedEntity = currentEntity.data[property];
                                    }
                                    currentEntity['$$set'+propertyMetaData.name.charAt(0).toUpperCase()+propertyMetaData.name.slice(1)](relatedEntity);
                                    currentEntity = relatedEntity;
                                }
                            });
                        });
                        entities.push(entity);
                    });
                    return entities;
                },
                /*basic entity getter where id is optional, returns a promise*/
                getDefer:function(deferKey){
                    return _deferred[deferKey];
                },
                cancelPromise:function(deferKey){
                    var deferred = this.getDefer(deferKey);
                    if(angular.isDefined(deferred)){
                        deferred.resolve({messages:[{messageType:'error',message:'User Cancelled'}]});
                    }
                },
                newEntity:function(entityName){
                    return new _jsEntities[entityName];
                },
                /*basic entity getter where id is optional, returns a promise*/
                getEntity:function(entityName, options){
                    /*
                     *
                     * getEntity('Product', '12345-12345-12345-12345');
                     * getEntity('Product', {keywords='Hello'});
                     * 
                     */
                    if(angular.isDefined(options.deferKey)){
                        this.cancelPromise(options.deferKey);
                    }
                    
                    var params = {};
                    if(typeof options === 'String') {
                        var urlString = _config.baseURL+'/index.cfm/?slatAction=api:main.get&entityName='+entityName+'&entityID='+options.id;
                    } else {
                        params['P:Current'] = options.currentPage || 1;
                        params['P:Show'] = options.pageShow || 10;
                        params.keywords = options.keywords || '';
                        params.columnsConfig = options.columnsConfig || '';
                        params.filterGroupsConfig = options.filterGroupsConfig || '';
                        params.joinsConfig = options.joinsConfig || '';
                        params.orderByConfig = options.orderByConfig || '';
                        params.isDistinct = options.isDistinct || false;
                        params.propertyIdentifiersList = options.propertyIdentifiersList || '';
                        params.allRecords = options.allRecords || '';
                        params.defaultColumns = options.defaultColumns || true;
                        params.processContext = options.processContext || '';
                        var urlString = _config.baseURL+'/index.cfm/?slatAction=api:main.get&entityName='+entityName;
                    }
                    
                    var deferred = $q.defer();
                    if(angular.isDefined(options.id)) {
                        urlString += '&entityId='+options.id;   
                    }

                    /*var transformRequest = function(data){    
                        console.log(data);
                                                
                        return data;
                    };
                    //check if we are using a service to transform the request
                    if(angular.isDefined(options.transformRequest)){
                        transformRequest=options.trasformRequest;
                    }*/
                    var transformResponse = function(data){
                            
                        var data = JSON.parse(data);
                        
                        return data;
                    };
                    //check if we are using a service to transform the response
                    if(angular.isDefined(options.transformResponse)){
                        transformResponse=function(data){
                            
                            var data = JSON.parse(data);
                            if(angular.isDefined(data.records)){
                                data = options.transformResponse(data.records);
                            }
                            
                            return data;
                        };
                    }
                    
                    $http.get(urlString,
                        {
                            params:params,
                            timeout:deferred.promise,
                            //transformRequest:transformRequest,
                            transformResponse:transformResponse
                        }
                    )
                    .success(function(data){
                        deferred.resolve(data);
                    }).error(function(reason){
                        deferred.reject(reason);
                    });
                    
                    if(options.deferKey){
                        _deferred[options.deferKey] = deferred;
                    }
                    return deferred.promise;
                    
                },
                getResizedImageByProfileName:function (profileName, skuIDs) {
                    var deferred = $q.defer();
                    return $http.get(_config.baseURL + '/index.cfm/?slatAction=api:main.getResizedImageByProfileName&profileName=' + profileName + '&skuIDs=' + skuIDs)
                    .success(function(data){
                        deferred.resolve(data);
                    }).error(function(reason){
                        deferred.reject(reason);
                    });
                },
                getEventOptions:function(entityName){
                    var deferred = $q.defer();
                    var urlString = _config.baseURL+'/index.cfm/?slatAction=api:main.getEventOptionsByEntityName&entityName='+entityName;
                    
                    $http.get(urlString)
                    .success(function(data){
                        deferred.resolve(data);
                    }).error(function(reason){
                        deferred.reject(reason);
                    });
                    
                    return deferred.promise;
                },
                checkUniqueOrNullValue:function (object, property, value) {
                    return $http.get(_config.baseURL + '/index.cfm/?slatAction=api:main.getValidationPropertyStatus&object=' + object + '&propertyidentifier=' + property + 
                 '&value=' + escape(value)).then(
                function (results) {
                   return results.data.uniqueStatus;
                 })
                },
                checkUniqueValue:function (object, property, value) {
                    return $http.get(_config.baseURL + '/index.cfm/?slatAction=api:main.getValidationPropertyStatus&object=' + object + '&propertyidentifier=' + property + 
                      '&value=' + escape(value)).then(
                        function (results) {
                            return results.data.uniqueStatus;
                    });
                },
                getPropertyDisplayData:function(entityName,options){
                    var deferred = $q.defer();
                    var urlString = _config.baseURL+'/index.cfm/?slatAction=api:main.getPropertyDisplayData&entityName='+entityName;
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
                    var urlString = _config.baseURL+'/index.cfm/?slatAction=api:main.getPropertyDisplayOptions&entityName='+entityName;
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
                saveEntity:function(entityName,id,params,context){
                    
                    //$log.debug('save'+ entityName);
                    var deferred = $q.defer();
    
                    var urlString = _config.baseURL+'/index.cfm/?slatAction=api:main.post'; 
                    
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
                    var urlString = _config.baseURL+'/index.cfm/?slatAction=api:main.getExistingCollectionsByBaseEntity&entityName='+entityName;
                    
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
                    var urlString = _config.baseURL+'/index.cfm/?slatAction=api:main.getFilterPropertiesByBaseEntityName&EntityName='+entityName;
                    
                    $http.get(urlString)
                    .success(function(data){
                        deferred.resolve(data);
                    }).error(function(reason){
                        deferred.reject(reason);
                    });
                    return deferred.promise;
                },
                getRBLoaded:function(){
                    return _loadedResourceBundle;
                },
                hasResourceBundle:function(){
                    ////$log.debug('hasResourceBundle');
                    ////$log.debug(_loadedResourceBundle);
                    if(!_loadingResourceBundle && !_loadedResourceBundle){
                        _loadingResourceBundle = true;
                        //$log.debug(slatwallService.getConfigValue('rbLocale').split('_'));
                        var localeListArray = slatwallService.getConfigValue('rbLocale').split('_');
                        var rbPromise;
                        var rbPromises = [];
                        rbPromise = slatwallService.getResourceBundle(slatwallService.getConfigValue('rbLocale'));
                        rbPromises.push(rbPromise);
                        if(localeListArray.length === 2){
                            //$log.debug('has two');
                            rbPromise = slatwallService.getResourceBundle(localeListArray[0]);
                            rbPromises.push(rbPromise);
                        }
                        if(localeListArray[0] !== 'en'){
                            //$log.debug('get english');
                            slatwallService.getResourceBundle('en_us');
                            slatwallService.getResourceBundle('en');
                        }   
                        $q.all(rbPromises).then(function(data){
                            $rootScope.loadedResourceBundle = true;
                            _loadingResourceBundle = false;
                            _loadedResourceBundle = true;
                            
                        },function(error){
                            $rootScope.loadedResourceBundle = true;
                            _loadingResourceBundle = false;
                            _loadedResourceBundle = true
                        });
                    }
                    return _loadedResourceBundle;
                    
                },
                getResourceBundle:function(locale){
                    var deferred = $q.defer();
                    var locale = locale || _config.rbLocale;
                    
                    if(_resourceBundle[locale]){
                        return _resourceBundle[locale];
                    }
                    
                    var urlString = _config.baseURL+'/index.cfm/?slatAction=api:main.getResourceBundle&instantiationKey='+_config.instantiationKey;
                    //var urlString = _config.baseURL+'/config/resourceBundles/'+locale+'.json?instantiationKey='+_config.instantiationKey;
                    var params = {
                        locale:locale
                    };
                    return $http.get(urlString,{params:params}).success(function(response){
                        _resourceBundle[locale] = response.data;
                        //deferred.resolve(response);
                    }).error(function(response){
                        _resourceBundle[locale] = {};
                        //deferred.reject(response);
                    });
                },
                
                
                rbKey:function(key,replaceStringData){
                    ////$log.debug('rbkey');
                    ////$log.debug(key);
                    ////$log.debug(_config.rbLocale);
                
                    var keyValue = this.getRBKey(key,_config.rbLocale);
                    ////$log.debug(keyValue);
                    
                    return keyValue;
                },
                getRBKey:function(key,locale,checkedKeys,originalKey){
                    ////$log.debug('getRBKey');
                    ////$log.debug('loading:'+_loadingResourceBundle);
                    ////$log.debug('loaded'+_loadedResourceBundle);
                    if(!_loadingResourceBundle && _loadedResourceBundle){
                        key = key.toLowerCase();
                        checkedKeys = checkedKeys || "";
                        locale = locale || 'en_us';
                        ////$log.debug('locale');
                        ////$log.debug(locale);
                        
                        var keyListArray = key.split(',');
                        ////$log.debug('keylistAray');
                        ////$log.debug(keyListArray);
                        if(keyListArray.length > 1) {
                            
                            
                            var keyValue = "";
                            
                            
                            for(var i=0; i<keyListArray.length; i++) {
                                
                                
                                var keyValue = this.getRBKey(keyListArray[i], locale, keyValue);
                                ////$log.debug('keyvalue:'+keyValue);
                                
                                if(keyValue.slice(-8) != "_missing") {
                                    break;
                                }
                            }
                            
                            return keyValue;
                        }
                        
                        
                        var bundle = slatwallService.getResourceBundle(locale);
                        //$log.debug('bundle');
                        //$log.debug(bundle);
                        if(!angular.isFunction(bundle.then)){
                            if(angular.isDefined(bundle[key])) {
                                //$log.debug('rbkeyfound:'+bundle[key]);
                                return bundle[key];
                            }
                            
                            
                            var checkedKeysListArray = checkedKeys.split(',');
                            checkedKeysListArray.push(key+'_'+locale+'_missing');
                            
                            checkedKeys = checkedKeysListArray.join(",");
                            if(angular.isUndefined(originalKey)){
                                originalKey = key;
                            }
                            //$log.debug('originalKey:'+key);
                            //$log.debug(checkedKeysListArray);
                            
                            var localeListArray = locale.split('_');
                            //$log.debug(localeListArray);
                            if(localeListArray.length === 2){
                                bundle = slatwallService.getResourceBundle(localeListArray[0]);
                                if(angular.isDefined(bundle[key])){
                                    //$log.debug('rbkey found:'+bundle[key]);
                                    return bundle[key];
                                }
                                
                                checkedKeysListArray.push(key+'_'+localeListArray[0]+'_missing');
                                checkedKeys = checkedKeysListArray.join(",");
                            }
                            
                            var keyDotListArray = key.split('.');
                            if( keyDotListArray.length >= 3
                                && keyDotListArray[keyDotListArray.length - 2] === 'define'
                            ){
                                var newKey = key.replace(keyDotListArray[keyDotListArray.length - 3]+'.define','define');
                                //$log.debug('newkey1:'+newKey);
                                return this.getRBKey(newKey,locale,checkedKeys,originalKey);
                            }else if( keyDotListArray.length >= 2 && keyDotListArray[keyDotListArray.length - 2] !== 'define'){
                                var newKey = key.replace(keyDotListArray[keyDotListArray.length -2]+'.','define.');
                                //$log.debug('newkey:'+newKey);
                                return this.getRBKey(newKey,locale,checkedKeys,originalKey);
                            }
                            //$log.debug(localeListArray);
                            
                            if(localeListArray[0] !== "en"){
                                return this.getRBKey(originalKey,'en',checkedKeys);
                            }
                            return checkedKeys;
                        }
                    }
                    return '';
                },
                 getConfig:function(){
                    return _config;
                },
                getConfigValue:function(key){
                    return _config[key];
                },
                setConfigValue:function(key,value){
                    _config[key] = value;
                },
                setConfig:function(config){
                    _config = config;
                }
              };
                     
            var _resourceBundle = {};
            var _loadingResourceBundle = false;
            var _loadedResourceBundle = false;
            var _jsEntities = {};
            
            
            
            
        
      return slatwallService;
   }],
    getConfig:function(){
        return _config;
    },
    getConfigValue:function(key){
        return _config[key];
    },
    setConfigValue:function(key,value){
        _config[key] = value;
    },
    setConfig:function(config){
        _config = config;
    }
};
}]).config(function ($slatwallProvider) {
    /* $slatwallProvider.setConfigValue($.slatwall.getConfig().baseURL); */
}).run(function($slatwall){
    
});
        