/// <reference path="../../../../client/typings/tsd.d.ts" />
/// <reference path="../../../../client/typings/slatwallTypeScript.d.ts" />
(function () {
    var ngSlatwall = angular.module('ngSlatwall', []);
})();
var ngSlatwall;
(function (ngSlatwall) {
    var SlatwallService = (function () {
        function SlatwallService($q, $http, $timeout, $log, $rootScope, $location, $anchorScroll, utilityService, formService, _config, _jsEntities) {
            var _this = this;
            this.$q = $q;
            this.$http = $http;
            this.$timeout = $timeout;
            this.$log = $log;
            this.$rootScope = $rootScope;
            this.$location = $location;
            this.$anchorScroll = $anchorScroll;
            this.utilityService = utilityService;
            this.formService = formService;
            this._config = _config;
            this._jsEntities = _jsEntities;
            this._resourceBundle = {};
            this._loadingResourceBundle = false;
            this._loadedResourceBundle = false;
            this._deferred = {};
            this.getJsEntities = function () {
                return _this._jsEntities;
            };
            this.setJsEntities = function (jsEntities) {
                _this._jsEntities = jsEntities;
            };
            //service method used to transform collection data to collection objects based on a collectionconfig
            this.populateCollection = function (collectionData, collectionConfig) {
                //create array to hold objects
                var entities = [];
                //loop over all collection data to create objects
                var slatwallService = _this;
                angular.forEach(collectionData, function (collectionItemData, key) {
                    //create base Entity
                    var entity = slatwallService['new' + collectionConfig.baseEntityName.replace('Slatwall', '')]();
                    //populate entity with data based on the collectionConfig
                    angular.forEach(collectionConfig.columns, function (column, key) {
                        //get objects base properties
                        var propertyIdentifier = column.propertyIdentifier.replace(collectionConfig.baseEntityAlias.toLowerCase() + '.', '');
                        var propertyIdentifierArray = propertyIdentifier.split('.');
                        var propertyIdentifierKey = propertyIdentifier.replace(/\./g, '_');
                        var currentEntity = entity;
                        angular.forEach(propertyIdentifierArray, function (property, key) {
                            if (key === propertyIdentifierArray.length - 1) {
                                //if we are on the last item in the array
                                if (angular.isObject(collectionItemData[propertyIdentifierKey]) && currentEntity.metaData[property].fieldtype === 'many-to-one') {
                                    var relatedEntity = slatwallService['new' + currentEntity.metaData[property].cfc]();
                                    relatedEntity.$$init(collectionItemData[propertyIdentifierKey][0]);
                                    currentEntity['$$set' + currentEntity.metaData[property].name.charAt(0).toUpperCase() + currentEntity.metaData[property].name.slice(1)](relatedEntity);
                                }
                                else if (angular.isArray(collectionItemData[propertyIdentifierKey]) && (currentEntity.metaData[property].fieldtype === 'one-to-many')) {
                                    angular.forEach(collectionItemData[propertyIdentifierKey], function (arrayItem, key) {
                                        var relatedEntity = slatwallService['new' + currentEntity.metaData[property].cfc]();
                                        relatedEntity.$$init(arrayItem);
                                        currentEntity['$$add' + currentEntity.metaData[property].singularname.charAt(0).toUpperCase() + currentEntity.metaData[property].singularname.slice(1)](relatedEntity);
                                    });
                                }
                                else {
                                    currentEntity.data[property] = collectionItemData[propertyIdentifierKey];
                                }
                            }
                            else {
                                var propertyMetaData = currentEntity.metaData[property];
                                if (angular.isUndefined(currentEntity.data[property])) {
                                    if (propertyMetaData.fieldtype === 'one-to-many') {
                                        relatedEntity = [];
                                    }
                                    else {
                                        relatedEntity = slatwallService['new' + propertyMetaData.cfc]();
                                    }
                                }
                                else {
                                    relatedEntity = currentEntity.data[property];
                                }
                                currentEntity['$$set' + propertyMetaData.name.charAt(0).toUpperCase() + propertyMetaData.name.slice(1)](relatedEntity);
                                currentEntity = relatedEntity;
                            }
                        });
                    });
                    entities.push(entity);
                });
                return entities;
            };
            /*basic entity getter where id is optional, returns a promise*/
            this.getDefer = function (deferKey) {
                return _this._deferred[deferKey];
            };
            this.cancelPromise = function (deferKey) {
                var deferred = _this.getDefer(deferKey);
                if (angular.isDefined(deferred)) {
                    deferred.resolve({ messages: [{ messageType: 'error', message: 'User Cancelled' }] });
                }
            };
            this.newEntity = function (entityName) {
                return new _this._jsEntities[entityName];
            };
            /*basic entity getter where id is optional, returns a promise*/
            this.getEntity = function (entityName, options) {
                /*
                 *
                 * getEntity('Product', '12345-12345-12345-12345');
                 * getEntity('Product', {keywords='Hello'});
                 *
                 */
                if (angular.isDefined(options.deferKey)) {
                    _this.cancelPromise(options.deferKey);
                }
                var params = {};
                if (typeof options === 'string') {
                    var urlString = _this.getConfig().baseURL + '/index.cfm/?slatAction=api:main.get&entityName=' + entityName + '&entityID=' + options;
                }
                else {
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
                    var urlString = _this.getConfig().baseURL + '/index.cfm/?slatAction=api:main.get&entityName=' + entityName;
                }
                var deferred = _this.$q.defer();
                if (angular.isDefined(options.id)) {
                    urlString += '&entityId=' + options.id;
                }
                /*var transformRequest = (data) => {
                    console.log(data);
                                            
                    return data;
                };
                //check if we are using a service to transform the request
                if(angular.isDefined(options.transformRequest)) => {
                    transformRequest=options.trasformRequest;
                }*/
                var transformResponse = function (data) {
                    if (angular.isString(data)) {
                        data = JSON.parse(data);
                    }
                    return data;
                };
                //check if we are using a service to transform the response
                if (angular.isDefined(options.transformResponse)) {
                    transformResponse = function (data) {
                        var data = JSON.parse(data);
                        if (angular.isDefined(data.records)) {
                            data = options.transformResponse(data.records);
                        }
                        return data;
                    };
                }
                $http.get(urlString, {
                    params: params,
                    timeout: deferred.promise,
                    //transformRequest:transformRequest,
                    transformResponse: transformResponse
                })
                    .success(function (data) {
                    deferred.resolve(data);
                }).error(function (reason) {
                    deferred.reject(reason);
                });
                if (options.deferKey) {
                    _this._deferred[options.deferKey] = deferred;
                }
                return deferred.promise;
            };
            this.getResizedImageByProfileName = function (profileName, skuIDs) {
                var deferred = _this.$q.defer();
                return $http.get(_this.getConfig().baseURL + '/index.cfm/?slatAction=api:main.getResizedImageByProfileName&profileName=' + profileName + '&skuIDs=' + skuIDs)
                    .success(function (data) {
                    deferred.resolve(data);
                }).error(function (reason) {
                    deferred.reject(reason);
                });
            };
            this.getEventOptions = function (entityName) {
                var deferred = _this.$q.defer();
                var urlString = _this.getConfig().baseURL + '/index.cfm/?slatAction=api:main.getEventOptionsByEntityName&entityName=' + entityName;
                $http.get(urlString)
                    .success(function (data) {
                    deferred.resolve(data);
                }).error(function (reason) {
                    deferred.reject(reason);
                });
                return deferred.promise;
            };
            this.checkUniqueOrNullValue = function (object, property, value) {
                return $http.get(_this.getConfig().baseURL + '/index.cfm/?slatAction=api:main.getValidationPropertyStatus&object=' + object + '&propertyidentifier=' + property +
                    '&value=' + escape(value)).then(function (results) {
                    return results.data.uniqueStatus;
                });
            };
            this.checkUniqueValue = function (object, property, value) {
                return $http.get(_this.getConfig().baseURL + '/index.cfm/?slatAction=api:main.getValidationPropertyStatus&object=' + object + '&propertyidentifier=' + property +
                    '&value=' + escape(value)).then(function (results) {
                    return results.data.uniqueStatus;
                });
            };
            this.getPropertyDisplayData = function (entityName, options) {
                var deferred = _this.$q.defer();
                var urlString = _this.getConfig().baseURL + '/index.cfm/?slatAction=api:main.getPropertyDisplayData&entityName=' + entityName;
                var params = {};
                params.propertyIdentifiersList = options.propertyIdentifiersList || '';
                $http.get(urlString, { params: params })
                    .success(function (data) {
                    deferred.resolve(data);
                }).error(function (reason) {
                    deferred.reject(reason);
                });
                return deferred.promise;
            };
            this.getPropertyDisplayOptions = function (entityName, options) {
                var deferred = _this.$q.defer();
                var urlString = _this.getConfig().baseURL + '/index.cfm/?slatAction=api:main.getPropertyDisplayOptions&entityName=' + entityName;
                var params = {};
                params.property = options.property || '';
                if (angular.isDefined(options.argument1)) {
                    params.argument1 = options.argument1;
                }
                $http.get(urlString, { params: params })
                    .success(function (data) {
                    deferred.resolve(data);
                }).error(function (reason) {
                    deferred.reject(reason);
                });
                return deferred.promise;
            };
            this.saveEntity = function (entityName, id, params, context) {
                //$log.debug('save'+ entityName);
                var deferred = _this.$q.defer();
                var urlString = _this.getConfig().baseURL + '/index.cfm/?slatAction=api:main.post';
                if (angular.isDefined(entityName)) {
                    params.entityName = entityName;
                }
                if (angular.isDefined(id)) {
                    params.entityID = id;
                }
                if (angular.isDefined(context)) {
                    params.context = context;
                }
                $http({
                    url: urlString,
                    method: 'POST',
                    data: $.param(params),
                    headers: { 'Content-Type': 'application/x-www-form-urlencoded' }
                })
                    .success(function (data) {
                    deferred.resolve(data);
                }).error(function (reason) {
                    deferred.reject(reason);
                });
                return deferred.promise;
            };
            this.getExistingCollectionsByBaseEntity = function (entityName) {
                var deferred = _this.$q.defer();
                var urlString = _this.getConfig().baseURL + '/index.cfm/?slatAction=api:main.getExistingCollectionsByBaseEntity&entityName=' + entityName;
                $http.get(urlString)
                    .success(function (data) {
                    deferred.resolve(data);
                }).error(function (reason) {
                    deferred.reject(reason);
                });
                return deferred.promise;
            };
            this.getFilterPropertiesByBaseEntityName = function (entityName) {
                var deferred = _this.$q.defer();
                var urlString = _this.getConfig().baseURL + '/index.cfm/?slatAction=api:main.getFilterPropertiesByBaseEntityName&EntityName=' + entityName;
                $http.get(urlString)
                    .success(function (data) {
                    deferred.resolve(data);
                }).error(function (reason) {
                    deferred.reject(reason);
                });
                return deferred.promise;
            };
            this.getRBLoaded = function () {
                return _this._loadedResourceBundle;
            };
            this.hasResourceBundle = function () {
                ////$log.debug('hasResourceBundle');
                ////$log.debug(this._loadedResourceBundle);
                if (!_this._loadingResourceBundle && !_this._loadedResourceBundle) {
                    _this._loadingResourceBundle = true;
                    //$log.debug(this.getConfigValue('rbLocale').split('_'));
                    var localeListArray = _this.getConfigValue('rbLocale').split('_');
                    var rbPromise;
                    var rbPromises = [];
                    rbPromise = _this.getResourceBundle(_this.getConfigValue('rbLocale'));
                    rbPromises.push(rbPromise);
                    if (localeListArray.length === 2) {
                        //$log.debug('has two');
                        rbPromise = _this.getResourceBundle(localeListArray[0]);
                        rbPromises.push(rbPromise);
                    }
                    if (localeListArray[0] !== 'en') {
                        //$log.debug('get english');
                        _this.getResourceBundle('en_us');
                        _this.getResourceBundle('en');
                    }
                    _this.$q.all(rbPromises).then(function (data) {
                        _this.$rootScope.loadedResourceBundle = true;
                        _this._loadingResourceBundle = false;
                        _this._loadedResourceBundle = true;
                    }, function (error) {
                        _this.$rootScope.loadedResourceBundle = true;
                        _this._loadingResourceBundle = false;
                        _this._loadedResourceBundle = true;
                    });
                }
                return _this._loadedResourceBundle;
            };
            this.getResourceBundle = function (locale) {
                var deferred = _this.$q.defer();
                var locale = locale || _this.getConfig().rbLocale;
                if (_this._resourceBundle[locale]) {
                    return _this._resourceBundle[locale];
                }
                var urlString = _this.getConfig().baseURL + '/index.cfm/?slatAction=api:main.getResourceBundle&instantiationKey=' + _this.getConfig().instantiationKey;
                //var urlString = this.getConfig().baseURL+'/config/resourceBundles/'+locale+'.json?instantiationKey='+this.getConfig().instantiationKey;
                var params = {
                    locale: locale
                };
                return $http.get(urlString, { params: params }).success(function (response) {
                    _this._resourceBundle[locale] = response.data;
                    //deferred.resolve(response);
                }).error(function (response) {
                    _this._resourceBundle[locale] = {};
                    //deferred.reject(response);
                });
            };
            this.rbKey = function (key, replaceStringData) {
                ////$log.debug('rbkey');
                ////$log.debug(key);
                ////$log.debug(this.getConfig().rbLocale);
                var keyValue = _this.getRBKey(key, _this.getConfig().rbLocale);
                ////$log.debug(keyValue);
                return keyValue;
            };
            this.getRBKey = function (key, locale, checkedKeys, originalKey) {
                ////$log.debug('getRBKey');
                ////$log.debug('loading:'+this._loadingResourceBundle);
                ////$log.debug('loaded'+this._loadedResourceBundle);
                if (!_this._loadingResourceBundle && _this._loadedResourceBundle) {
                    key = key.toLowerCase();
                    checkedKeys = checkedKeys || "";
                    locale = locale || 'en_us';
                    ////$log.debug('locale');
                    ////$log.debug(locale);
                    var keyListArray = key.split(',');
                    ////$log.debug('keylistAray');
                    ////$log.debug(keyListArray);
                    if (keyListArray.length > 1) {
                        var keyValue = "";
                        for (var i = 0; i < keyListArray.length; i++) {
                            var keyValue = _this.getRBKey(keyListArray[i], locale, keyValue);
                            ////$log.debug('keyvalue:'+keyValue);
                            if (keyValue.slice(-8) != "_missing") {
                                break;
                            }
                        }
                        return keyValue;
                    }
                    var bundle = _this.getResourceBundle(locale);
                    //$log.debug('bundle');
                    //$log.debug(bundle);
                    if (!bundle.then) {
                        if (angular.isDefined(bundle[key])) {
                            //$log.debug('rbkeyfound:'+bundle[key]);
                            return bundle[key];
                        }
                        var checkedKeysListArray = checkedKeys.split(',');
                        checkedKeysListArray.push(key + '_' + locale + '_missing');
                        checkedKeys = checkedKeysListArray.join(",");
                        if (angular.isUndefined(originalKey)) {
                            originalKey = key;
                        }
                        //$log.debug('originalKey:'+key);
                        //$log.debug(checkedKeysListArray);
                        var localeListArray = locale.split('_');
                        //$log.debug(localeListArray);
                        if (localeListArray.length === 2) {
                            bundle = _this.getResourceBundle(localeListArray[0]);
                            if (angular.isDefined(bundle[key])) {
                                //$log.debug('rbkey found:'+bundle[key]);
                                return bundle[key];
                            }
                            checkedKeysListArray.push(key + '_' + localeListArray[0] + '_missing');
                            checkedKeys = checkedKeysListArray.join(",");
                        }
                        var keyDotListArray = key.split('.');
                        if (keyDotListArray.length >= 3
                            && keyDotListArray[keyDotListArray.length - 2] === 'define') {
                            var newKey = key.replace(keyDotListArray[keyDotListArray.length - 3] + '.define', 'define');
                            //$log.debug('newkey1:'+newKey);
                            return _this.getRBKey(newKey, locale, checkedKeys, originalKey);
                        }
                        else if (keyDotListArray.length >= 2 && keyDotListArray[keyDotListArray.length - 2] !== 'define') {
                            var newKey = key.replace(keyDotListArray[keyDotListArray.length - 2] + '.', 'define.');
                            //$log.debug('newkey:'+newKey);
                            return _this.getRBKey(newKey, locale, checkedKeys, originalKey);
                        }
                        //$log.debug(localeListArray);
                        if (localeListArray[0] !== "en") {
                            return _this.getRBKey(originalKey, 'en', checkedKeys);
                        }
                        return checkedKeys;
                    }
                }
                return '';
            };
            this.getConfig = function () {
                return _this._config;
            };
            this.getConfigValue = function (key) {
                return _this._config[key];
            };
            this.setConfigValue = function (key, value) {
                _this._config[key] = value;
            };
            this.setConfig = function (config) {
                _this._config = config;
            };
            this.$q = $q;
            this.$http = $http;
            this.$timeout = $timeout;
            this.$log = $log;
            this.$rootScope = $rootScope;
            this.$location = $location;
            this.$anchorScroll = $anchorScroll;
            this.utilityService = utilityService;
            this.formService = formService;
            this._config = _config;
            this._jsEntities = _jsEntities;
        }
        SlatwallService.$inject = ['$q', '$http', '$timeout', '$log', '$rootScope', '$location', '$anchorScroll', 'utilityService', 'formService'];
        return SlatwallService;
    })();
    ngSlatwall.SlatwallService = SlatwallService;
    var $Slatwall = (function () {
        function $Slatwall() {
            var _this = this;
            this._config = {};
            this.angular = angular;
            this.setJsEntities = function (jsEntities) {
                _this._jsEntities = jsEntities;
            };
            this.getConfig = function () {
                return _this._config;
            };
            this.getConfigValue = function (key) {
                return _this._config[key];
            };
            this.setConfigValue = function (key, value) {
                _this._config[key] = value;
            };
            this.setConfig = function (config) {
                _this._config = config;
            };
            this._config = {
                dateFormat: 'MM/DD/YYYY',
                timeFormat: 'HH:MM',
                rbLocale: '',
                baseURL: '',
                applicationKey: 'Slatwall',
                debugFlag: true,
                instantiationKey: '84552B2D-A049-4460-55F23F30FE7B26AD'
            };
            console.log('config');
            console.log(this._config);
            if (slatwallAngular.slatwallConfig) {
                angular.extend(this._config, slatwallAngular.slatwallConfig);
            }
            this.$get.$inject = [
                '$q',
                '$http',
                '$timeout',
                '$log',
                '$rootScope',
                '$location',
                '$anchorScroll',
                'utilityService',
                'formService'
            ];
        }
        $Slatwall.prototype.$get = function ($q, $http, $timeout, $log, $rootScope, $location, $anchorScroll, utilityService, formService) {
            return new SlatwallService($q, $http, $timeout, $log, $rootScope, $location, $anchorScroll, utilityService, formService, this.getConfig(), this._jsEntities);
        };
        return $Slatwall;
    })();
    ngSlatwall.$Slatwall = $Slatwall;
    angular.module('ngSlatwall').provider('$slatwall', $Slatwall);
})(ngSlatwall || (ngSlatwall = {}));

//# sourceMappingURL=../modules/ngslatwall.js.map