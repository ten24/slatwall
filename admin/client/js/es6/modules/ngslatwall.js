/// <reference path="../../../../client/typings/tsd.d.ts" />
/// <reference path="../../../../client/typings/slatwallTypeScript.d.ts" />
(() => {
    var ngSlatwall = angular.module('ngSlatwall', ['hibachi']);
})();
var ngSlatwall;
(function (ngSlatwall) {
    class SlatwallService {
        constructor($window, $q, $http, $timeout, $log, $rootScope, $location, $anchorScroll, utilityService, formService, _config, _jsEntities, _jsEntityInstances) {
            this.$window = $window;
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
            this._jsEntityInstances = _jsEntityInstances;
            this._resourceBundle = {};
            this._resourceBundleLastModified = '';
            this._loadingResourceBundle = false;
            this._loadedResourceBundle = false;
            this._deferred = {};
            this.buildUrl = (action, queryString) => {
                //actionName example: slatAction. defined in FW1 and populated to config
                var actionName = this.getConfigValue('action');
                var baseUrl = this.getConfigValue('baseURL');
                queryString = queryString || '';
                if (angular.isDefined(queryString) && queryString.length) {
                    if (queryString.indexOf('&') !== 0) {
                        queryString = '&' + queryString;
                    }
                }
                return baseUrl + '?' + actionName + '=' + action + queryString;
            };
            this.getJsEntities = () => {
                return this._jsEntities;
            };
            this.setJsEntities = (jsEntities) => {
                this._jsEntities = jsEntities;
            };
            this.getJsEntityInstances = () => {
                return this._jsEntityInstances;
            };
            this.setJsEntityInstances = (jsEntityInstances) => {
                this._jsEntityInstances = jsEntityInstances;
            };
            this.getEntityExample = (entityName) => {
                return this._jsEntityInstances[entityName];
            };
            this.getEntityMetaData = (entityName) => {
                return this._jsEntityInstances[entityName].metaData;
            };
            this.getPropertyByEntityNameAndPropertyName = (entityName, propertyName) => {
                return this.getEntityMetaData(entityName)[propertyName];
            };
            this.getPrimaryIDPropertyNameByEntityName = (entityName) => {
                return this.getEntityMetaData(entityName).$$getIDName();
            };
            this.getEntityHasPropertyByEntityName = (entityName, propertyName) => {
                return angular.isDefined(this.getEntityMetaData(entityName)[propertyName]);
            };
            this.getPropertyIsObjectByEntityNameAndPropertyIdentifier = (entityName, propertyIdentifier) => {
                var lastEntity = this.getLastEntityNameInPropertyIdentifier(entityName, propertyIdentifier);
                var entityMetaData = this.getEntityMetaData(lastEntity);
                return angular.isDefined(entityMetaData[this.utilityService.listLast(propertyIdentifier, '.')].cfc);
            };
            this.getLastEntityNameInPropertyIdentifier = (entityName, propertyIdentifier) => {
                if (propertyIdentifier.split('.').length > 1) {
                    var propertiesStruct = this.getEntityMetaData(entityName);
                    if (!propertiesStruct[this.utilityService.listFirst(propertyIdentifier, '.')]
                        || !propertiesStruct[this.utilityService.listFirst(propertyIdentifier, '.')].cfc) {
                        throw ("The Property Identifier " + propertyIdentifier + " is invalid for the entity " + entityName);
                    }
                    var currentEntityName = this.utilityService.listLast(propertiesStruct[this.utilityService.listFirst(propertyIdentifier, '.')].cfc, '.');
                    var currentPropertyIdentifier = this.utilityService.right(propertyIdentifier, propertyIdentifier.length - (this.utilityService.listFirst(propertyIdentifier, '._').length));
                    return this.getLastEntityNameInPropertyIdentifier(currentEntityName, currentPropertyIdentifier);
                }
                return entityName;
            };
            //service method used to transform collection data to collection objects based on a collectionconfig
            this.populateCollection = (collectionData, collectionConfig) => {
                //create array to hold objects
                var entities = [];
                //loop over all collection data to create objects
                var slatwallService = this;
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
            this.getDefer = (deferKey) => {
                return this._deferred[deferKey];
            };
            this.cancelPromise = (deferKey) => {
                var deferred = this.getDefer(deferKey);
                if (angular.isDefined(deferred)) {
                    deferred.resolve({ messages: [{ messageType: 'error', message: 'User Cancelled' }] });
                }
            };
            this.newEntity = (entityName) => {
                return new this._jsEntities[entityName];
            };
            /*basic entity getter where id is optional, returns a promise*/
            this.getEntity = (entityName, options) => {
                /*
                 *
                 * getEntity('Product', '12345-12345-12345-12345');
                 * getEntity('Product', {keywords='Hello'});
                 *
                 */
                if (angular.isUndefined(options)) {
                    options = {};
                }
                if (angular.isDefined(options.deferKey)) {
                    this.cancelPromise(options.deferKey);
                }
                var params = {};
                if (typeof options === 'string') {
                    var urlString = this.getConfig().baseURL + '/index.cfm/?slatAction=api:main.get&entityName=' + entityName + '&entityID=' + options;
                }
                else {
                    params['P:Current'] = options.currentPage || 1;
                    params['P:Show'] = options.pageShow || 10;
                    params.keywords = options.keywords || '';
                    params.columnsConfig = options.columnsConfig || '';
                    params.filterGroupsConfig = options.filterGroupsConfig || '';
                    params.joinsConfig = options.joinsConfig || '';
                    params.orderByConfig = options.orderByConfig || '';
                    params.groupBysConfig = options.groupBysConfig || '';
                    params.isDistinct = options.isDistinct || false;
                    params.propertyIdentifiersList = options.propertyIdentifiersList || '';
                    params.allRecords = options.allRecords || '';
                    params.defaultColumns = options.defaultColumns || true;
                    params.processContext = options.processContext || '';
                    var urlString = this.getConfig().baseURL + '/index.cfm/?slatAction=api:main.get&entityName=' + entityName;
                }
                var deferred = this.$q.defer();
                if (angular.isDefined(options.id)) {
                    urlString += '&entityId=' + options.id;
                }
                /*var transformRequest = (data) => {
                                            
                    return data;
                };
                //check if we are using a service to transform the request
                if(angular.isDefined(options.transformRequest)) => {
                    transformRequest=options.trasformRequest;
                }*/
                var transformResponse = (data) => {
                    if (angular.isString(data)) {
                        data = JSON.parse(data);
                    }
                    return data;
                };
                //check if we are using a service to transform the response
                if (angular.isDefined(options.transformResponse)) {
                    transformResponse = (data) => {
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
                    .success((data) => {
                    deferred.resolve(data);
                }).error((reason) => {
                    deferred.reject(reason);
                });
                if (options.deferKey) {
                    this._deferred[options.deferKey] = deferred;
                }
                return deferred.promise;
            };
            this.getResizedImageByProfileName = (profileName, skuIDs) => {
                var deferred = this.$q.defer();
                return $http.get(this.getConfig().baseURL + '/index.cfm/?slatAction=api:main.getResizedImageByProfileName&profileName=' + profileName + '&skuIDs=' + skuIDs)
                    .success((data) => {
                    deferred.resolve(data);
                }).error((reason) => {
                    deferred.reject(reason);
                });
            };
            this.getEventOptions = (entityName) => {
                var deferred = this.$q.defer();
                var urlString = this.getConfig().baseURL + '/index.cfm/?slatAction=api:main.getEventOptionsByEntityName&entityName=' + entityName;
                $http.get(urlString)
                    .success((data) => {
                    deferred.resolve(data);
                }).error((reason) => {
                    deferred.reject(reason);
                });
                return deferred.promise;
            };
            this.checkUniqueOrNullValue = (object, property, value) => {
                return $http.get(this.getConfig().baseURL + '/index.cfm/?slatAction=api:main.getValidationPropertyStatus&object=' + object + '&propertyidentifier=' + property +
                    '&value=' + escape(value)).then(function (results) {
                    return results.data.uniqueStatus;
                });
            };
            this.checkUniqueValue = (object, property, value) => {
                return $http.get(this.getConfig().baseURL + '/index.cfm/?slatAction=api:main.getValidationPropertyStatus&object=' + object + '&propertyidentifier=' + property +
                    '&value=' + escape(value)).then(function (results) {
                    return results.data.uniqueStatus;
                });
            };
            this.getPropertyDisplayData = (entityName, options) => {
                var deferred = this.$q.defer();
                var urlString = this.getConfig().baseURL + '/index.cfm/?slatAction=api:main.getPropertyDisplayData&entityName=' + entityName;
                var params = {};
                params.propertyIdentifiersList = options.propertyIdentifiersList || '';
                $http.get(urlString, { params: params })
                    .success((data) => {
                    deferred.resolve(data);
                }).error((reason) => {
                    deferred.reject(reason);
                });
                return deferred.promise;
            };
            this.getPropertyDisplayOptions = (entityName, options) => {
                var deferred = this.$q.defer();
                var urlString = this.getConfig().baseURL + '/index.cfm/?slatAction=api:main.getPropertyDisplayOptions&entityName=' + entityName;
                var params = {};
                params.property = options.property || '';
                if (angular.isDefined(options.argument1)) {
                    params.argument1 = options.argument1;
                }
                $http.get(urlString, { params: params })
                    .success((data) => {
                    deferred.resolve(data);
                }).error((reason) => {
                    deferred.reject(reason);
                });
                return deferred.promise;
            };
            this.saveEntity = (entityName, id, params, context) => {
                //$log.debug('save'+ entityName);
                var deferred = this.$q.defer();
                var urlString = this.getConfig().baseURL + '/index.cfm/?slatAction=api:main.post';
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
                    .success((data) => {
                    deferred.resolve(data);
                }).error((reason) => {
                    deferred.reject(reason);
                });
                return deferred.promise;
            };
            this.getExistingCollectionsByBaseEntity = (entityName) => {
                var deferred = this.$q.defer();
                var urlString = this.getConfig().baseURL + '/index.cfm/?slatAction=api:main.getExistingCollectionsByBaseEntity&entityName=' + entityName;
                $http.get(urlString)
                    .success((data) => {
                    deferred.resolve(data);
                }).error((reason) => {
                    deferred.reject(reason);
                });
                return deferred.promise;
            };
            this.getFilterPropertiesByBaseEntityName = (entityName) => {
                var deferred = this.$q.defer();
                var urlString = this.getConfig().baseURL + '/index.cfm/?slatAction=api:main.getFilterPropertiesByBaseEntityName&EntityName=' + entityName;
                $http.get(urlString)
                    .success((data) => {
                    deferred.resolve(data);
                }).error((reason) => {
                    deferred.reject(reason);
                });
                return deferred.promise;
            };
            this.getRBLoaded = () => {
                return this._loadedResourceBundle;
            };
            this.hasResourceBundle = () => {
                ////$log.debug('hasResourceBundle');
                ////$log.debug(this._loadedResourceBundle);
                if (!this._loadingResourceBundle && !this._loadedResourceBundle) {
                    this._loadingResourceBundle = true;
                    //$log.debug(this.getConfigValue('rbLocale').split('_'));
                    var localeListArray = this.getConfigValue('rbLocale').split('_');
                    var rbPromise;
                    var rbPromises = [];
                    rbPromise = this.getResourceBundle(this.getConfigValue('rbLocale'));
                    rbPromises.push(rbPromise);
                    if (localeListArray.length === 2) {
                        //$log.debug('has two');
                        rbPromise = this.getResourceBundle(localeListArray[0]);
                        rbPromises.push(rbPromise);
                    }
                    if (localeListArray[0] !== 'en') {
                        //$log.debug('get english');
                        this.getResourceBundle('en_us');
                        this.getResourceBundle('en');
                    }
                    this.$q.all(rbPromises).then((data) => {
                        this.$rootScope.loadedResourceBundle = true;
                        this._loadingResourceBundle = false;
                        this._loadedResourceBundle = true;
                    }, (error) => {
                        this.$rootScope.loadedResourceBundle = true;
                        this._loadingResourceBundle = false;
                        this._loadedResourceBundle = true;
                    });
                }
                return this._loadedResourceBundle;
            };
            this.login = (emailAddress, password) => {
                var deferred = this.$q.defer();
                var urlString = this.getConfig().baseURL + '/index.cfm/api/auth/login';
                var params = {
                    emailAddress: emailAddress,
                    password: password
                };
                return $http.get(urlString, { params: params }).success((response) => {
                    deferred.resolve(response);
                }).error((response) => {
                    deferred.reject(response);
                });
            };
            this.getResourceBundle = (locale) => {
                var deferred = this.$q.defer();
                var locale = locale || this.getConfig().rbLocale;
                if (this._resourceBundle[locale]) {
                    return this._resourceBundle[locale];
                }
                var urlString = this.getConfig().baseURL + '/index.cfm/?slatAction=api:main.getResourceBundle&instantiationKey=' + this.getConfig().instantiationKey + '&locale=' + locale;
                $http({
                    url: urlString,
                    method: "GET"
                }).success((response, status, headersGetter) => {
                    this._resourceBundle[locale] = response.data;
                    deferred.resolve(response);
                }).error((response) => {
                    this._resourceBundle[locale] = {};
                    deferred.reject(response);
                });
                return deferred.promise;
            };
            this.getCurrencies = () => {
                var deferred = this.$q.defer();
                var urlString = this.getConfig().baseURL + '/index.cfm/?slatAction=api:main.getCurrencies&instantiationKey=' + this.getConfig().instantiationKey;
                $http.get(urlString).success((response) => {
                    deferred.resolve(response);
                }).error((response) => {
                    deferred.reject(response);
                });
                return deferred.promise;
            };
            this.rbKey = (key, replaceStringData) => {
                ////$log.debug('rbkey');
                ////$log.debug(key);
                ////$log.debug(this.getConfig().rbLocale);
                var keyValue = this.getRBKey(key, this.getConfig().rbLocale);
                ////$log.debug(keyValue);
                return keyValue;
            };
            this.getRBKey = (key, locale, checkedKeys, originalKey) => {
                ////$log.debug('getRBKey');
                ////$log.debug('loading:'+this._loadingResourceBundle);
                ////$log.debug('loaded'+this._loadedResourceBundle);
                if (!this._loadingResourceBundle && this._loadedResourceBundle) {
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
                            var keyValue = this.getRBKey(keyListArray[i], locale, keyValue);
                            //$log.debug('keyvalue:'+keyValue);
                            if (keyValue.slice(-8) != "_missing") {
                                break;
                            }
                        }
                        return keyValue;
                    }
                    var bundle = this.getResourceBundle(locale);
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
                            bundle = this.getResourceBundle(localeListArray[0]);
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
                            return this.getRBKey(newKey, locale, checkedKeys, originalKey);
                        }
                        else if (keyDotListArray.length >= 2 && keyDotListArray[keyDotListArray.length - 2] !== 'define') {
                            var newKey = key.replace(keyDotListArray[keyDotListArray.length - 2] + '.', 'define.');
                            //$log.debug('newkey:'+newKey);
                            return this.getRBKey(newKey, locale, checkedKeys, originalKey);
                        }
                        //$log.debug(localeListArray);
                        if (localeListArray[0] !== "en") {
                            return this.getRBKey(originalKey, 'en', checkedKeys);
                        }
                        return checkedKeys;
                    }
                }
                return '';
            };
            this.getConfig = () => {
                return this._config;
            };
            this.getConfigValue = (key) => {
                return this._config[key];
            };
            this.setConfigValue = (key, value) => {
                this._config[key] = value;
            };
            this.setConfig = (config) => {
                this._config = config;
            };
            this.$window = $window;
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
            this._jsEntityInstances = _jsEntityInstances;
        }
    }
    SlatwallService.$inject = ['$window', '$q', '$http', '$timeout', '$log', '$rootScope', '$location', '$anchorScroll', 'utilityService', 'formService'];
    ngSlatwall.SlatwallService = SlatwallService;
    class $Slatwall {
        constructor() {
            this._config = {};
            this.angular = angular;
            this.setJsEntities = (jsEntities) => {
                this._jsEntities = jsEntities;
            };
            this.getConfig = () => {
                return this._config;
            };
            this.getConfigValue = (key) => {
                return this._config[key];
            };
            this.setConfigValue = (key, value) => {
                this._config[key] = value;
            };
            this.setConfig = (config) => {
                this._config = config;
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
            if (slatwallAngular.slatwallConfig) {
                angular.extend(this._config, slatwallAngular.slatwallConfig);
            }
            this.$get.$inject = [
                '$window',
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
        $get($window, $q, $http, $timeout, $log, $rootScope, $location, $anchorScroll, utilityService, formService) {
            return new SlatwallService($window, $q, $http, $timeout, $log, $rootScope, $location, $anchorScroll, utilityService, formService, this.getConfig(), this._jsEntities);
        }
    }
    ngSlatwall.$Slatwall = $Slatwall;
    angular.module('ngSlatwall').provider('$slatwall', $Slatwall);
})(ngSlatwall || (ngSlatwall = {}));

//# sourceMappingURL=../modules/ngslatwall.js.map