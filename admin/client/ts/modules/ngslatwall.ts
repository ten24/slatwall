
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
            
            var _init = function(entityInstance,data){
                for(var key in data) {
                    if(key.charAt(0) !== '$' && angular.isDefined(entityInstance.metaData[key])){
                        var propertyMetaData = entityInstance.metaData[key];
                        
                        if(angular.isDefined(propertyMetaData) && angular.isDefined(propertyMetaData.hb_formfieldtype) && propertyMetaData.hb_formfieldtype === 'json'){
                            if(data[key].trim() !== ''){
                                entityInstance.data[key] = angular.fromJson(data[key]);
                            }
                            
                        }else{
                        entityInstance.data[key] = data[key];   
                    }
                }
            }
            }
            
            var _getPropertyTitle = function(propertyName,metaData){
                var propertyMetaData = metaData[propertyName];
                if(angular.isDefined(propertyMetaData['hb_rbkey'])){
                    return metaData.$$getRBKey(propertyMetaData['hb_rbkey']);
                }else if (angular.isUndefined(propertyMetaData['persistent'])){
                    if(angular.isDefined(propertyMetaData['fieldtype']) 
                    && angular.isDefined(propertyMetaData['cfc'])
                    && ["one-to-many","many-to-many"].indexOf(propertyMetaData.fieldtype) > -1){
                        
                        return metaData.$$getRBKey("entity."+metaData.className.toLowerCase()+"."+propertyName+',entity.'+propertyMetaData.cfc+'_plural');
                    }else if(angular.isDefined(propertyMetaData.fieldtype)
                    && angular.isDefined(propertyMetaData.cfc)
                    && ["many-to-one"].indexOf(propertyMetaData.fieldtype) > -1){
                        return metaData.$$getRBKey("entity."+metaData.className.toLowerCase()+'.'+propertyName.toLowerCase()+',entity.'+propertyMetaData.cfc);
                    }
                    return metaData.$$getRBKey('entity.'+metaData.className.toLowerCase()+'.'+propertyName.toLowerCase());
                }else if(metaData.isProcessObject){
                    if(angular.isDefined(propertyMetaData.fieldtype) 
                        && angular.isDefined(propertyMetaData.cfc) 
                        && ["one-to-many","many-to-many"].indexOf(propertyMetaData.fieldtype) > -1
                    ){
                        return metaData.$$getRBKey('processObject.'+metaData.className.toLowerCase()+'.'+propertyName.toLowerCase()+',entity.'+propertyMetaData.cfc.toLowerCase()+'_plural');
                    }else if(angular.isDefined(propertyMetaData.fieldtype) 
                        && angular.isDefined(propertyMetaData.cfc) 
                    ){
                        return metaData.$$getRBKey('processObject.'+metaData.className.toLowerCase()+'.'+propertyName.toLowerCase()+',entity.'+propertyMetaData.cfc.toLowerCase());
                    }
                    return metaData.$$getRBKey('processObject.'+metaData.className.toLowerCase()+'.'+propertyName.toLowerCase());
                    
                }
                return metaData.$$getRBKey('object.'+metaData.className.toLowerCase()+'.'+propertyName.toLowerCase());
            }
            
            var _getPropertyHint = function(propertyName,metaData){
                var propertyMetaData = metaData[propertyName];
                var keyValue = '';
                if(angular.isDefined(propertyMetaData['hb_rbkey'])){
                    keyValue = metaData.$$getRBKey(propertyMetaData['hb_rbkey']+'_hint');
                }else if (angular.isUndefined(propertyMetaData['persistent']) || (angular.isDefined(propertyMetaData['persistent']) && propertyMetaData['persistent'] === true)){
                    keyValue = metaData.$$getRBKey('entity.'+metaData.className.toLowerCase()+'.'+propertyName.toLowerCase()+'_hint');
                }else{
                    keyValue = metaData.$$getRBKey('object.'+metaData.className.toLowerCase()+'.'+propertyName.toLowerCase());
                }
                if(keyValue.slice(-8) !== '_missing'){
                    return keyValue;
                }
                return '';
            }
            
            
            
            var _getPropertyFieldType = function(propertyName,metaData){
                var propertyMetaData = metaData[propertyName];
                if(angular.isDefined(propertyMetaData['hb_formfieldtype'])){
                    return propertyMetaData['hb_formfieldtype'];
                }
                
                if(angular.isUndefined(propertyMetaData.fieldtype) || propertyMetaData.fieldtype === 'column'){
                    var dataType = "";
                    
                    if(angular.isDefined(propertyMetaData.ormtype)){
                        dataType = propertyMetaData.ormtype;
                    }else if (angular.isDefined(propertyMetaData.type)){
                        dataType = propertyMetaData.type;
                    }
                    if(["boolean","yes_no","true_false"].indexOf(dataType) > -1){
                        return "yesno";
                    }else if (["date","timestamp"].indexOf(dataType) > -1){
                        return "dateTime";
                    }else if ("array" === dataType){
                        return "select";
                    }else if ("struct" === dataType){
                        return "checkboxgroup";
                    }else if(propertyName.indexOf('password') > -1){
                        return "password";
                    }
                    
                }else if(angular.isDefined(propertyMetaData.fieldtype) && propertyMetaData.fieldtype === 'many-to-one'){
                    return 'select';
                }else if(angular.isDefined(propertyMetaData.fieldtype) && propertyMetaData.fieldtype === 'one-to-many'){
                    return 'There is no property field type for one-to-many relationship properties, which means that you cannot get a fieldtype for '+propertyName;
                }else if(angular.isDefined(propertyMetaData.fieldtype) && propertyMetaData.fieldtype === 'many-to-many'){
                    return "listingMultiselect";
                }
            
                return "text";
            }
            
            var _getPropertyFormatType = function(propertyName,metaData){
                var propertyMetaData = metaData[propertyName];
                
                if(angular.isDefined(propertyMetaData['hb_formattype'])){
                    return propertyMetaData['hb_formattype'];
                }else if(angular.isUndefined(propertyMetaData.fieldtype) || propertyMetaData.fieldtype === 'column'){
                    var dataType = "";
                    
                    if(angular.isDefined(propertyMetaData.ormtype)){
                        dataType = propertyMetaData.ormtype;
                    }else if (angular.isDefined(propertyMetaData.type)){
                        dataType = propertyMetaData.type;
                    }
                    
                    if(["boolean","yes_no","true_false"].indexOf(dataType) > -1){
                        return "yesno";
                    }else if (["date","timestamp"].indexOf(dataType) > -1){
                        return "dateTime";
                    }else if (["big_decimal"].indexOf(dataType) > -1 && propertyName.slice(-6) === 'weight'){
                        return "weight";
                    }else if (["big_decimal"].indexOf(dataType) > -1){
                        return "currency";
                    }
                }
                return 'none';
            }
            
            var _isSimpleValue = function(value){
                
                if( 
                    angular.isString(value) || angular.isNumber(value) 
                    || angular.isDate(value) || value === false || value === true
                ){
                    return true;
                }else{
                    return false;
                }
            }
            
            var utilityService = {
                formatValue:function(value,formatType,formatDetails,entityInstance){
                    if(angular.isUndefined(formatDetails)){
                        formatDetails = {};
                    }
                    var typeList = ["currency","date","datetime","pixels","percentage","second","time","truefalse","url","weight","yesno"];
                    
                    if(typeList.indexOf(formatType)){
                        utilityService['format_'+formatType](value,formatDetails,entityInstance);
                    }
                    return value;
                },
                format_currency:function(value,formatDetails,entityInstance){
                    if(angular.isUndefined){
                        formatDetails = {};
                    }
                },
                format_date:function(value,formatDetails,entityInstance){
                    if(angular.isUndefined){
                        formatDetails = {};
                    }
                },
                format_datetime:function(value,formatDetails,entityInstance){
                    if(angular.isUndefined){
                        formatDetails = {};
                    }
                },
                format_pixels:function(value,formatDetails,entityInstance){
                    if(angular.isUndefined){
                        formatDetails = {};
                    }
                },
                format_yesno:function(value,formatDetails,entityInstance){
                    if(angular.isUndefined){
                        formatDetails = {};
                    }
                    if(Boolean(value) === true ){
                        return entityInstance.metaData.$$getRBKey("define.yes");
                    }else if(value === false || value.trim() === 'No' || value.trim === 'NO' || value.trim() === '0'){
                        return entityInstance.metaData.$$getRBKey("define.no");
                    }
                }
            }
            
            var _getFormattedValue = function(propertyName,formatType,entityInstance){
                var value = entityInstance.$$getPropertyByName(propertyName);
                
                if(angular.isUndefined(formatType)){
                    formatType = entityInstance.metaData.$$getPropertyFormatType(propertyName);
                }
                
                if(formatType === "custom"){
                    return entityInstance['$$get'+propertyName+Formatted]();
                }else if(formatType === "rbkey"){
                    if(angular.isDefined(value)){
                        return entityInstance.$$getRBKey('entity.'+entityInstance.metaData.className.toLowerCase()+'.'+propertyName.toLowerCase()+'.'+value);
                    }else{
                        return '';
                    }
                }
                if(angular.isUndefined(value)){
                    var propertyMeta = entityInstance.metaData[propertyName];
                    if(angular.isDefined(propertyMeta['hb_nullRBKey'])){
                        return entityInstance.$$getRbKey(propertyMeta['hb_nullRBKey']);
                    }
                    
                    return "";
                }else if (_isSimpleValue(value)){
                    var formatDetails = {};
                    if(angular.isDefined(entityInstance.data['currencyCode'])){
                        formatDetails.currencyCode = entityInstance.$$getCurrencyCode();
                    }
                    
                    
                    return utilityService.formatValue(value,formatType,formatDetails,entityInstance);
                }
            }
            
            var _delete = function(entityInstance){
                var entityName = entityInstance.metaData.className;
                var entityID = entityInstance.$$getID();
                var context = 'delete';
                var deletePromise = slatwallService.saveEntity(entityName,entityID,{},context);
                return deletePromise;
            }
            
            var _setValueByPropertyPath = function (obj,path, value) {
                var a = path.split('.');
                var context = obj;
                var selector;
                var myregexp = /([a-zA-Z]+)(\[(\d)\])+/; // matches:  item[0]
                var match = null;

                for (var i = 0; i < a.length - 1; i += 1) {
                    match = myregexp.exec(a[i]);
                    if (match !== null) context = context[match[1]][match[3]];
                    else context = context[a[i]];

                }

                // check for ending item[xx] syntax
                match = myregexp.exec([a[a.length - 1]]);

                if (match !== null) context[match[1]][match[3]] = value;
                else context[a[a.length - 1]] = value;

                
            }
            
            var _getValueByPropertyPath = function(obj,path) {
                  var paths = path.split('.')
                    , current = obj
                    , i;

                  for (i = 0; i < paths.length; ++i) {
                    if (current[paths[i]] == undefined) {
                      return undefined;
                    } else {
                      current = current[paths[i]];
                    }
                  }
                  return current;
            }
            
            var _addReturnedIDs = function(returnedIDs,entityInstance){
                
                for(var key in returnedIDs){
                    if(angular.isArray(returnedIDs[key])){
                        var arrayItems = returnedIDs[key];
                        var entityInstanceArray = entityInstance.data[key];
                        for(var i in arrayItems){
                            var arrayItem = arrayItems[i];
                            var entityInstanceArrayItem = entityInstance.data[key][i];
                            _addReturnedIDs(arrayItem,entityInstanceArrayItem)
                        }
                    }else if(angular.isObject(returnedIDs[key])){
                        for(var k in returnedIDs[key]){
                            addReturnedIDs(returnedIDs[key][k],entityInstance.data[key][k]);
                        }
                    }else{
                        entityInstance.data[key] = returnedIDs[key];
                    }
                }
            }
            
            

            var _save = function(entityInstance){
                 var timeoutPromise = $timeout(function(){
                    //$log.debug('save begin');
                    //$log.debug(entityInstance);
                    
                    var entityID = entityInstance.$$getID();
                    
                    var modifiedData = _getModifiedData(entityInstance);
                    //$log.debug('modifiedData complete');
                    //$log.debug(modifiedData);
                    timeoutPromise.valid = modifiedData.valid;
                    if(modifiedData.valid){
                        var params = {};
                        params.serializedJsonData = angular.toJson(modifiedData.value);
                        //if we have a process object then the context is different from the standard save
                        var entityName = '';
                        var context = 'save';
                        if(entityInstance.metaData.isProcessObject === 1){
                            var processStruct = modifiedData.objectLevel.metaData.className.split('_');
                            entityName = processStruct[0];
                            context = processStruct[1];
                        }else{
                            entityName = modifiedData.objectLevel.metaData.className;
                        }
                        
                        var savePromise = slatwallService.saveEntity(entityName,entityInstance.$$getID(),params,context);
                        savePromise.then(function(response){
                            var returnedIDs = response.data;
                            
                            
                            _addReturnedIDs(returnedIDs,modifiedData.objectLevel);
                        });
                    }else{
                        
                        //select first, visible, and enabled input with a class of ng-invalid
                    
                        var target = $('input.ng-invalid:first:visible:enabled');
                        //$log.debug('input is invalid');
                        //$log.debug(target);
                        target.focus();
                    var targetID = target.attr('id');
                        $anchorScroll();
                        
                    }
                });
                return timeoutPromise;
                /*
                
                
                
                
                */
            }
            
            var _getModifiedData = function(entityInstance){
                var modifiedData = {};
                modifiedData = getModifiedDataByInstance(entityInstance);
                return modifiedData;
            }
            
            var getObjectSaveLevel = function(entityInstance){
                var objectLevel = entityInstance;
                
                var entityID = entityInstance.$$getID();    
                
                angular.forEach(entityInstance.parents,function(parentObject){
                    if(angular.isDefined(entityInstance.data[parentObject.name]) && entityInstance.data[parentObject.name].$$getID() === '' && (angular.isUndefined(entityID) || !entityID.trim().length)){
                        
                        
                        var parentEntityInstance = entityInstance.data[parentObject.name]; 
                        var parentEntityID = parentEntityInstance.$$getID();
                        if(parentEntityID === '' && parentEntityInstance.forms){
                            objectLevel = getObjectSaveLevel(parentEntityInstance);
                        }
                    }
                });
                
                return objectLevel;
            }

            var validateObject = function(entityInstance){
                
                var modifiedData = {};
                var valid = true;
                
                var forms = entityInstance.forms;
                //$log.debug('process base level data');
                for(var f in forms){
                    
                    var form = forms[f];
                    form.$setSubmitted();   //Sets the form to submitted for the validation errors to pop up.
                    if(form.$dirty && form.$valid){
                        for(var key in form){
                            //$log.debug('key:'+key);
                            if(key.charAt(0) !== '$'){
                                var inputField = form[key];
                                if(angular.isDefined(inputField.$valid) && inputField.$valid === true && inputField.$dirty === true){
                                    
                                    
                                    if(angular.isDefined(entityInstance.metaData[key]) 
                                    && angular.isDefined(entityInstance.metaData[key].hb_formfieldtype) 
                                    && entityInstance.metaData[key].hb_formfieldtype === 'json'){
                                        modifiedData[key] = angular.toJson(form[key].$modelValue);      
                                    }else{
                                        modifiedData[key] = form[key].$modelValue;
                                    }
                                }
                            }
                        }
                    }else{
                        if(!form.$valid){
                            valid = false;
                        }
                        
                    }
                }
                modifiedData[entityInstance.$$getIDName()] = entityInstance.$$getID();
                //$log.debug(modifiedData); 


                
                //$log.debug('process parent data');
                if(angular.isDefined(entityInstance.parents)){
                    for(var p in entityInstance.parents){
                        var parentObject = entityInstance.parents[p];
                        var parentInstance = entityInstance.data[parentObject.name];
                        if(angular.isUndefined(modifiedData[parentObject.name])){
                            modifiedData[parentObject.name] = {};
                        }
                        var forms = parentInstance.forms;
                        for(var f in forms){
                            var form = forms[f];
                            form.$setSubmitted();
                            if(form.$dirty && form.$valid){
                            for(var key in form){
                                if(key.charAt(0) !== '$'){
                                    var inputField = form[key];
                                    if(angular.isDefined(inputField) && angular.isDefined(inputField.$valid) && inputField.$valid === true && inputField.$dirty === true){
                                        
                                        if(angular.isDefined(parentInstance.metaData[key]) 
                                        && angular.isDefined(parentInstance.metaData[key].hb_formfieldtype) 
                                        && parentInstance.metaData[key].hb_formfieldtype === 'json'){
                                            modifiedData[parentObject.name][key] = angular.toJson(form[key].$modelValue);       
                                        }else{
                                            modifiedData[parentObject.name][key] = form[key].$modelValue;
                                        }
                                    }
                                }
                            }
                            }else{
                                if(!form.$valid){
                                    valid = false;
                                }
                                
                            }
                        }
                        modifiedData[parentObject.name][parentInstance.$$getIDName()] = parentInstance.$$getID();
                    }
                }
                //$log.debug(modifiedData);

                
                //$log.debug('begin child data');
                var childrenData = validateChildren(entityInstance);
                //$log.debug('child Data');
                //$log.debug(childrenData);
                angular.extend(modifiedData,childrenData);
                return {
                    valid:valid,
                    value:modifiedData
                };
                
            }

            
            var validateChildren = function(entityInstance){
                var data = {}
                
                if(angular.isDefined(entityInstance.children) && entityInstance.children.length){
                    
                    data = getDataFromChildren(entityInstance);
                }
                return data;
            }
            
            var processChild = function(entityInstance,entityInstanceParent){
     
                var data = {};
                var forms = entityInstance.forms;
                
                for(var f in forms){
                    
                    var form = forms[f];
                    
                    angular.extend(data,processForm(form,entityInstance));
                }
                
                if(angular.isDefined(entityInstance.children) && entityInstance.children.length){
                    
                    var childData = getDataFromChildren(entityInstance);
                    angular.extend(data,childData);
                }
                if(angular.isDefined(entityInstance.parents) && entityInstance.parents.length){
                    
                    var parentData = getDataFromParents(entityInstance,entityInstanceParent);
                    angular.extend(data,parentData);
                }
                
                return data;
            }

            var processParent = function(entityInstance){
                var data = {};
                if(entityInstance.$$getID() !== ''){
                    data[entityInstance.$$getIDName()] = entityInstance.$$getID();
                }
                
                //$log.debug('processParent');
                //$log.debug(entityInstance);
                var forms = entityInstance.forms;
                    
                for(var f in forms){
                    var form = forms[f];
                    
                    data = angular.extend(data,processForm(form,entityInstance));
                }
                
                return data;
            }

            var processForm = function(form,entityInstance){
                //$log.debug('begin process form');
                var data = {};
                form.$setSubmitted();   
                for(var key in form){
                    if(key.charAt(0) !== '$'){
                        var inputField = form[key];
                        if(angular.isDefined(inputField) && angular.isDefined(inputField) && inputField.$valid === true && inputField.$dirty === true){ 
                            
                            if(angular.isDefined(entityInstance.metaData[key]) && angular.isDefined(entityInstance.metaData[key].hb_formfieldtype) && entityInstance.metaData[key].hb_formfieldtype === 'json'){
                                data[key] = angular.toJson(form[key].$modelValue);      
                            }else{
                                data[key] = form[key].$modelValue;      
                            }
                                        
                        }
                    }
                }
                data[entityInstance.$$getIDName()] = entityInstance.$$getID();
                //$log.debug('process form data');
                //$log.debug(data);
                return data;
            }

            var getDataFromParents = function(entityInstance,entityInstanceParent){
                var data = {};
                
                for(var c in entityInstance.parents){
                    var parentMetaData = entityInstance.parents[c];
                    if(angular.isDefined(parentMetaData)){
                        var parent = entityInstance.data[parentMetaData.name];
                        if(angular.isObject(parent) && entityInstanceParent !== parent && parent.$$getID() !== '') {
                            if(angular.isUndefined(data[parentMetaData.name])){
                                data[parentMetaData.name] = {};
                            }
                            var parentData = processParent(parent);
                            //$log.debug('parentData:'+parentMetaData.name);
                            //$log.debug(parentData);
                            angular.extend(data[parentMetaData.name],parentData);
                        }else{
                            
                        }
                    }
                    
                };
                
                return data;
            }

            var getDataFromChildren = function(entityInstance){
                var data = {};
                
                //$log.debug('childrenFound');
                //$log.debug(entityInstance.children);
                for(var c in entityInstance.children){
                    var childMetaData = entityInstance.children[c];
                    var children = entityInstance.data[childMetaData.name];
                    //$log.debug(childMetaData);
                    //$log.debug(children);
                    if(angular.isArray(entityInstance.data[childMetaData.name])){
                        if(angular.isUndefined(data[childMetaData.name])){
                            data[childMetaData.name] = [];
                        }
                        angular.forEach(entityInstance.data[childMetaData.name],function(child,key){
                            //$log.debug('process child array item')
                            var childData = processChild(child,entityInstance);
                            //$log.debug('process child return');
                            //$log.debug(childData);
                            data[childMetaData.name].push(childData);
                        });
                    }else{
                        if(angular.isUndefined(data[childMetaData.name])){
                            data[childMetaData.name] = {};
                        }
                        var child = entityInstance.data[childMetaData.name];
                        //$log.debug('begin process child');
                        var childData = processChild(child,entityInstance);
                        //$log.debug('process child return');
                        //$log.debug(childData);
                        angular.extend(data,childData);
                    }
                     
                }
                //$log.debug('returning child data');
                //$log.debug(data);

                return data;
            }
            
            var getModifiedDataByInstance = function(entityInstance){
                var modifiedData = {};
                
                
                
                
                
                var objectSaveLevel = getObjectSaveLevel(entityInstance);
                //$log.debug('objectSaveLevel : ' + objectSaveLevel );
                var valueStruct = validateObject(objectSaveLevel);
                //$log.debug('validateObject data');
                //$log.debug(valueStruct.value);
                
                modifiedData = {
                    objectLevel:objectSaveLevel,
                    value:valueStruct.value,
                    valid:valueStruct.valid
                }
                return modifiedData;
            }
            
            var _getValidationsByProperty = function(entityInstance,property){
                return entityInstance.validations.properties[property];
            }
            
            var _getValidationByPropertyAndContext = function(entityInstance,property,context){
                var validations = _getValidationsByProperty(entityInstance,property);
                for(var i in validations){
                    
                    var contexts = validations[i].contexts.split(',');
                    for(var j in contexts){
                        if(contexts[j] === context){
                            return validations[i];
                        }
                    }
                    
                }
            }
            
            
        
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
        