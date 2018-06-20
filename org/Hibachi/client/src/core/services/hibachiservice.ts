/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

declare var escape;
import {AdminRequest} from "../model/transient/adminrequest";
import { Injectable,Inject } from "@angular/core";
import { RequestService } from "./requestservice";
import { UtilityService } from "./utilityservice";
import { FormService } from "./formservice";
import { RbKeyService } from "./rbkeyservice";
import { ObserverService } from "./observerservice";
import { HibachiValidationService } from "./hibachivalidationservice";

// interface ISlatwallRootScopeService extends ng.IRootScopeService{
//     loadedResourceBundle:boolean;
// 	loadingResourceBundle:boolean;
// } 

export class HibachiService{

	public _deferred = {};
    public _resourceBundle = {};
    public usePublicRoutes:boolean = false;
	//@ngInject
	constructor(
		private $window:ng.IWindowService,
		private $q:ng.IQService,
		private $http:ng.IHttpService,
		private $timeout:ng.ITimeoutService,
		private $log:ng.ILogService,
		private $rootScope:ng.IRootScopeService,
		private $location:ng.ILocationService,
		private $anchorScroll:ng.IAnchorScrollService,
		private requestService,
		private utilityService,
		private formService,
        private rbkeyService,

        private appConfig,
		public _config?:any,
		public _jsEntities?:any,
		public _jsEntityInstances?:any
	){
        this.$window = $window;
        this.$q = $q;
        this.$http = $http;
        this.$timeout = $timeout;
        this.$log = $log;
        this.$rootScope = $rootScope;
        this.$location = $location;
        this.$anchorScroll = $anchorScroll;
		this.requestService = requestService;
        this.utilityService = utilityService;
        this.formService = formService;
        this.rbkeyService = rbkeyService;

        this.appConfig = appConfig;
        this._config = appConfig;
        this._jsEntities = _jsEntities;
        this._jsEntityInstances = _jsEntityInstances;
	}


	public buildUrl = (action:string,queryString:string):string =>{
		//actionName example: slatAction. defined in FW1 and populated to config
		var actionName = this.appConfig.action;
		var baseUrl = this.appConfig.baseURL;
		queryString = queryString || '';
		if(angular.isDefined(queryString) && queryString.length){
			if(queryString.indexOf('&') !== 0){
				queryString = '&'+ queryString;
			}
		}
		return baseUrl + '?' + actionName + '=' + action + queryString;
	};

    public getUrlWithActionPrefix = () => {
        return this.appConfig.baseURL+'/index.cfm/?'+this.appConfig.action+"=";
    }

	getJsEntities= () =>{
		return this._jsEntities;
	};

	setJsEntities= (jsEntities) =>{
		this._jsEntities = jsEntities;
	};

	getJsEntityInstances= () =>{
		return this._jsEntityInstances;
	};

	setJsEntityInstances= (jsEntityInstances) =>{
		this._jsEntityInstances = jsEntityInstances;
	};

	getEntityExample = (entityName)=>{
		return this._jsEntityInstances[entityName];
	};

	getEntityMetaData = (entityName)=>{
		return this._jsEntityInstances[entityName].metaData;
	};

	getPropertyByEntityNameAndPropertyName = (entityName,propertyName)=>{
		return this.getEntityMetaData(entityName)[propertyName];
	};

	getPrimaryIDPropertyNameByEntityName = (entityName)=>{
		return this.getEntityExample(entityName).$$getIDName();
	};

	getEntityHasPropertyByEntityName = (entityName,propertyName):boolean=>{
		return angular.isDefined(this.getEntityMetaData(entityName)[propertyName]);
	};

	getBaseEntityAliasFromName = (entityName)=>{
		return '_' + entityName;
	}

	getPropertyIsObjectByEntityNameAndPropertyIdentifier = (entityName:string,propertyIdentifier:string):boolean=>{
		var lastEntity = this.getLastEntityNameInPropertyIdentifier(entityName,propertyIdentifier);
		var entityMetaData = this.getEntityMetaData(lastEntity);
		return angular.isDefined(entityMetaData[this.utilityService.listLast(propertyIdentifier,'.')].cfc);
	};

	getLastEntityNameInPropertyIdentifier = (entityName,propertyIdentifier)=>{
		if(!entityName){
			throw('No entity name was supplied to getLastEntityNameInPropertyIdentifier in hibachi service.');
		}
		//strip alias if it exists and convert everything to be periods
		if(propertyIdentifier.charAt(0) === '_'){
			propertyIdentifier = this.utilityService.listRest(propertyIdentifier.replace(/_/g,'.'),'.'); 
		}
		
		var propertyIdentifierArray = propertyIdentifier.split('.');
		
		if(propertyIdentifierArray[0] === entityName.toLowerCase()){
			propertyIdentifierArray.shift();
		}

		if(propertyIdentifierArray.length > 1){
			var propertiesStruct = this.getEntityMetaData(entityName);
			var currentProperty = propertyIdentifierArray.shift(); 
			if(
				!propertiesStruct[currentProperty] ||
				!propertiesStruct[currentProperty].cfc
			){
				throw("The Property Identifier "+propertyIdentifier+" is invalid for the entity "+entityName);
			}
			var currentEntityName = propertiesStruct[currentProperty].cfc;
			var currentPropertyIdentifier = propertyIdentifierArray.join('.');
			return this.getLastEntityNameInPropertyIdentifier(currentEntityName,currentPropertyIdentifier);
		}
		return entityName;

	};
	//helper method to inflate a new entity with data
	populateEntity = (entityName, data)=>{
		var newEntity = this.newEntity(entityName);
		angular.extend(newEntity.data,data);
		return newEntity;
	}
	//service method used to transform collection data to collection objects based on a collectionconfig
	populateCollection = (collectionData,collectionConfig) =>{
		//create array to hold objects
		var entities = [];
		//loop over all collection data to create objects
		var hibachiService = this;
		angular.forEach(collectionData, (collectionItemData, key)=>{
			//create base Entity
			var entity = hibachiService['new'+collectionConfig.baseEntityName.replace(this.appConfig.applicationKey,'')]();
			//populate entity with data based on the collectionConfig
			angular.forEach(collectionConfig.columns, (column, key)=>{
				//get objects base properties
				var propertyIdentifier = column.propertyIdentifier.replace(collectionConfig.baseEntityAlias.toLowerCase(),'');
                propertyIdentifier = this.utilityService.replaceAll(propertyIdentifier,'_','.');
                if(propertyIdentifier.charAt(0)==='.'){
                    propertyIdentifier = propertyIdentifier.slice(1);
                }
				var propertyIdentifierArray = propertyIdentifier.split('.');
				var propertyIdentifierKey = propertyIdentifier.replace(/\./g,'_');
				var currentEntity = entity;
				angular.forEach(propertyIdentifierArray,(property,key)=>{
					if(key === propertyIdentifierArray.length-1){
						//if we are on the last item in the array
						if(angular.isObject(collectionItemData[propertyIdentifierKey]) && currentEntity.metaData[property].fieldtype === 'many-to-one'){
							var relatedEntity = hibachiService['new'+currentEntity.metaData[property].cfc]();
							relatedEntity.$$init(collectionItemData[propertyIdentifierKey][0]);
							currentEntity['$$set'+currentEntity.metaData[property].name.charAt(0).toUpperCase()+currentEntity.metaData[property].name.slice(1)](relatedEntity);
						}else if(angular.isArray(collectionItemData[propertyIdentifierKey]) && (currentEntity.metaData[property].fieldtype === 'one-to-many')){
							angular.forEach(collectionItemData[propertyIdentifierKey],function(arrayItem,key){
								var relatedEntity = hibachiService['new'+currentEntity.metaData[property].cfc]();
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
								relatedEntity = hibachiService['new'+propertyMetaData.cfc]();
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
	};
	/*basic entity getter where id is optional, returns a promise*/
	getDefer =(deferKey) =>{
		return this._deferred[deferKey];
	};
	cancelPromise= (deferKey) =>{
		var deferred = this.getDefer(deferKey);
		if(angular.isDefined(deferred)){
			deferred.resolve({messages:[{messageType:'error',message:'User Cancelled'}]});
		}
	};
	newEntity= (entityName) =>{

		if (entityName != undefined){
			var entityServiceName = entityName.charAt(0).toLowerCase()+entityName.slice(1)+'Service';
			if(angular.element(document.body).injector().has(entityServiceName)){
				var entityService = angular.element(document.body).injector().get(entityServiceName);
				let functionObj = entityService['new'+entityName];
				if (entityService['new'+entityName] != undefined && !!(functionObj && functionObj.constructor && functionObj.call && functionObj.apply)){
					return entityService['new'+entityName]();
				}
			}
			return new this._jsEntities[entityName];	
 
		}
	
	};
	getEntityDefinition= (entityName) =>{
		return this._jsEntities[entityName];
	};
	/*basic entity getter where id is optional, returns a promise*/
	getEntity= (entityName:string, options:any) => {
		/*
		*
		* getEntity('Product', '12345-12345-12345-12345');
		* getEntity('Product', {keywords='Hello'});
		*
		*/
		var apiSubsystemName = this.appConfig.apiSubsystemName || "api";

		if(angular.isUndefined(options)){
			options = {};
		}


		if(angular.isDefined(options.deferKey)) {
			this.cancelPromise(options.deferKey);
		}

		var params:any= {};
		if(typeof options === 'string') {

			var urlString = this.getUrlWithActionPrefix() + apiSubsystemName + ':' + 'main.get&entityName='+entityName+'&entityID='+options;
		} else {
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
			params.allRecords = options.allRecords || false;
			params.defaultColumns = options.defaultColumns || true;
			params.processContext = options.processContext || '';
			var urlString = this.getUrlWithActionPrefix()+ apiSubsystemName + ':' +'main.get&entityName='+entityName;
		}

		if(angular.isDefined(options.id)) {
			urlString += '&entityId='+options.id;
		}

		var transformResponse = (data) => {
			if(angular.isString(data)){
				data = JSON.parse(data);
			}

			return data;
		};

		//check if we are using a service to transform the response
		if(angular.isDefined(options.transformResponse)) {
			transformResponse=(data) => {

				var data = JSON.parse(data);
				if(angular.isDefined(data.records))  {
					data = options.transformResponse(data.records);
				}

				return data;
			};
		}

		let request = this.requestService.newAdminRequest(urlString,params)

		if(options.deferKey)  {
			this._deferred[options.deferKey] = request;
		}
		return request.promise;

	};
	getResizedImageByProfileName = (profileName, skuIDs) => {
		var urlString = this.getUrlWithActionPrefix()+'api:main.getResizedImageByProfileName&context=getResizedImageByProfileName&profileName=' + profileName + '&skuIDs=' + skuIDs;
		let request = this.requestService.newPublicRequest(urlString);

		return request.promise;
	}
	getEventOptions= (entityName) => {
		var urlString = this.getUrlWithActionPrefix()+'api:main.getEventOptionsByEntityName&entityName='+entityName;
		let request = this.requestService.newAdminRequest(urlString);

		return request.promise;
	};
    getProcessOptions= (entityName) => {

        var urlString = this.getUrlWithActionPrefix()+'api:main.getProcessMethodOptionsByEntityName&entityName='+entityName;
		let request = this.requestService.newAdminRequest(urlString)

        return request.promise;
    };
	checkUniqueOrNullValue = (object, property, value) => {
		var objectName = object.metaData.className;
		var objectID = object.$$getID();
		return this.$http.get(this.getUrlWithActionPrefix()+'api:main.getValidationPropertyStatus&object=' + objectName + '&objectID=' + objectID + '&propertyidentifier=' + property +
		'&value=' + escape(value)).then(
	 (results:any):ng.IPromise<any> =>{
		return results.data.uniqueStatus;
		})
	};
	checkUniqueValue = (object, property, value) => {
		var objectName = object.metaData.className;
		var objectID = object.$$getID();
		return this.$http.get(this.getUrlWithActionPrefix()+'api:main.getValidationPropertyStatus&object=' + objectName + '&objectID=' + objectID + '&propertyidentifier=' + property +
			'&value=' + escape(value)).then(
			 (results:any):ng.IPromise<any> =>{
				return results.data.uniqueStatus;
		});
	};
	getPropertyDisplayData = (entityName,options) => {

		var urlString = this.getUrlWithActionPrefix()+'api:main.getPropertyDisplayData&entityName='+entityName;
		var params:any = {};
		params.propertyIdentifiersList = options.propertyIdentifiersList || '';
		let request = this.requestService.newAdminRequest(urlString,params);

		return request.promise;
	};
	getPropertyDisplayOptions = (entityName,options) => {
		var urlString = this.getUrlWithActionPrefix()+'api:main.getPropertyDisplayOptions&entityName='+entityName;
		var params:any = {};
		params.property = options.property || options.propertyIdentifier || '';
		if(angular.isDefined(options.argument1))  {
			params.argument1 = options.argument1;
		}

		let request = this.requestService.newAdminRequest(urlString,params);

		return request.promise;
	};

	public getPropertyTitle=(propertyName,metaData)=>{
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

	saveEntity= (entityName,id,params,context) => {

		var urlString = this.getUrlWithActionPrefix()+'api:main.post';

		if(angular.isDefined(entityName))  {
			params.entityName = entityName;
		}
		if(angular.isDefined(id))  {
			params.entityID = id;
		}

		if(angular.isDefined(context))  {
			params.context = context;
		}
		let request = this.requestService.newAdminRequest(urlString,params);

		return request.promise;
	};

	getExistingCollectionsByBaseEntity= (entityName) => {

		var urlString = this.getUrlWithActionPrefix()+'api:main.getExistingCollectionsByBaseEntity&entityName='+entityName;
		let request = this.requestService.newAdminRequest(urlString);

		return request.promise;

	};
	getFilterPropertiesByBaseEntityName= (entityName,includeNonPersistent = false) => {
		var urlString = this.getUrlWithActionPrefix()+'api:main.getFilterPropertiesByBaseEntityName&EntityName='+entityName+'&includeNonPersistent='+includeNonPersistent;
		let request = this.requestService.newAdminRequest(urlString);

		return request.promise;
	};

	login = (emailAddress,password) => {

		var urlString = this.appConfig.baseURL+'/index.cfm/api/auth/login';
		var params:any= {
			emailAddress:emailAddress,
			password:password
		};

		let request = this.requestService.newAdminRequest(urlString,params);
		return request.promise;

	};

	getResourceBundle= (locale?) => {

		var locale = locale || this.appConfig.rbLocale;

		if(this._resourceBundle[locale]) {
			return this._resourceBundle[locale];
		}

		var urlString = this.getUrlWithActionPrefix()+'api:main.getResourceBundle&instantiationKey='+this.appConfig.instantiationKey+'&locale='+locale;

		let request = this.requestService.newAdminRequest(urlString);
		return request.promise
	};

	getCurrencies = () =>{
		var urlString = this.getUrlWithActionPrefix()+'api:main.getCurrencies&instantiationKey='+this.appConfig.instantiationKey;
		let request = this.requestService.newAdminRequest(urlString);

		return request.promise;
	};

    getConfig= () => {
		return this._config;
	};
	getConfigValue= (key) => {
		return this._config[key];
	};
	setConfigValue= (key,value) => {
		this._config[key] = value;
	};
	setConfig= (config) => {
		this._config = config;
	};
}

@Injectable()
export class $Hibachi extends HibachiService {
    
	constructor(@Inject("$window") $window:any,
                @Inject("$q") $q:any,
                @Inject("$http") $http:any,
                @Inject("$timeout") $timeout:any,
                @Inject("$log") $log:any,
                @Inject("$rootScope") $rootScope:any,
                @Inject("$location") $location:any,
                @Inject("$anchorScroll") $anchorScroll:any,
                requestService : RequestService,
                utilityService : UtilityService,
                formService : FormService,
                rbKeyService : RbKeyService,
                
                observerService : ObserverService,
                hibachiValidationService:HibachiValidationService,
                
                @Inject("appConfig") appConfig:any,
                @Inject("attributeMetaData") attributeMetaData:any
                 ){

        super(          
            $window,
            $q,
            $http,
            $timeout,
            $log,
            $rootScope,
            $location,
            $anchorScroll,
            requestService,
            utilityService,
            formService,
            rbKeyService,

            appConfig);
		this._config = appConfig;
        
        ///////////////////////////////////////////////////// hibachiservicedecorator
        
            var $delegate = this;
            var _deferred = {};
            var _config = appConfig;

            var _jsEntities = {};
            var _jsEntityInstances = {};
            var entities = appConfig.modelConfig.entities,
                validations = appConfig.modelConfig.validations,
                defaultValues = appConfig.modelConfig.defaultValues;

            angular.forEach(entities,function(entity){
                if(attributeMetaData && attributeMetaData[entity.className]){
                    var relatedAttributes = attributeMetaData[entity.className];
                    for(var attributeSetCode in relatedAttributes){
                        var attributeSet = relatedAttributes[attributeSetCode];
                        for(var attributeCode in attributeSet.attributes){
                            var attribute = attributeSet.attributes[attributeCode];
                            attribute.attributeSet = attributeSet;
                            attribute.isAttribute = true;
                            $.extend(entity[attributeCode],attribute);
                        }
                    }
                }


                $delegate['get'+entity.className] = function(options){
                    var entityInstance = $delegate.newEntity(entity.className);
                    var entityDataPromise = $delegate.getEntity(entity.className,options);
                    entityDataPromise.then(function(response){

                        if(angular.isDefined(response.processData)){
                            entityInstance.$$init(response.data);
                            var processObjectInstance = $delegate['new'+entity.className+'_'+options.processContext.charAt(0).toUpperCase()+options.processContext.slice(1)]();
                            processObjectInstance.$$init(response.processData);
                            processObjectInstance.data[entity.className.charAt(0).toLowerCase()+entity.className.slice(1)] = entityInstance;
                            entityInstance.processObject = processObjectInstance;
                        }else{
                            if(entityInstance.populate){

                                entityInstance.populate(response);

                            }else{
                                entityInstance.$$init(response);
                            }
                        }

                    });
                    return {
                        promise:entityDataPromise,
                        value:entityInstance
                    }
                };

                $delegate['new'+entity.className] = function(){
                    //if we have the service then get the new instance from that

                    var entityName = entity.className;
                    var serviceName = entityName.charAt(0).toLowerCase()+entityName.slice(1)+'Service';

                    if(angular.element(document.body).injector().has(serviceName)){
                        var entityService = angular.element(document.body).injector().get(serviceName);
                        
                        if(entityService['new'+entity.className]){
                            return entityService['new'+entity.className]();
                        }
                    }

                    return $delegate.newEntity(entity.className);
                };

                entity.isProcessObject = entity.className.indexOf('_') >= 0;

                _jsEntities[ entity.className ]=function() {

                    this.validations = validations[entity.className];

                    this.metaData = entity;
                    this.metaData.className = entity.className;
                    if(relatedAttributes){
                        this.attributeMetaData = relatedAttributes;
                    }

                    if(entity.hb_parentPropertyName){
                        this.metaData.hb_parentPropertyName = entity.hb_parentPropertyName;
                    }
                    if(entity.hb_childPropertyName){
                        this.metaData.hb_childPropertyName = entity.hb_childPropertyName;
                    }

                    this.metaData.$$getRBKey = function(rbKey,replaceStringData){
                        return rbKeyService.rbKey(rbKey,replaceStringData);
                    };

                    this.metaData.$$getPropertyTitle = function(propertyName){
                        return _getPropertyTitle(propertyName,this);
                    };

                    this.metaData.$$getPropertyHint = function(propertyName){
                        return _getPropertyHint(propertyName,this);
                    };

                    this.metaData.$$getManyToManyName = function(singularname){
                        var metaData = this;
                        for(var i in metaData){
                            if(metaData[i].singularname === singularname){
                                return metaData[i].name;
                            }
                        }
                    };



                    this.metaData.$$getPropertyFieldType = function(propertyName){
                        return _getPropertyFieldType(propertyName,this);
                    };

                    this.metaData.$$getPropertyFormatType = function(propertyName){

                        if(this[propertyName])
                        return _getPropertyFormatType(propertyName,this);
                    };

                    this.metaData.$$getDetailTabs = function(){
                        var deferred = $q.defer();
                        var urlString = _config.baseURL+'/index.cfm/?'+appConfig.action+'=api:main.getDetailTabs&entityName='+this.className;
                        var detailTabs = [];
                        $http.get(urlString)
                        .success(function(data){
                            deferred.resolve(data);
                        }).error(function(reason){
                            deferred.reject(reason);
                        });

                        return deferred.promise;
                    };

                    this.$$getFormattedValue = function(propertyName,formatType){
                        return _getFormattedValue(propertyName,formatType,this);
                    };

                    this.data = {};
                    this.modifiedData = {};

                    var jsEntity = this;
                    if(entity.isProcessObject){
                        (function(entity){_jsEntities[ entity.className ].prototype = {
                            $$getID:function(){

                                return '';
                            }
                            ,$$getIDName:function(){
                                var IDNameString = '';
                                return IDNameString;
                            }
                        }})(entity);
                    }

                    angular.forEach(entity,function(property){
                        if(angular.isObject(property) && angular.isDefined(property.name)){
                            if(defaultValues && defaultValues[entity.className] && defaultValues[entity.className][property.name] != null){
                                jsEntity.data[property.name] = angular.copy(defaultValues[entity.className][property.name]);
                            }else{
                                jsEntity.data[property.name] = undefined;
                            }
                        }
                    });

                };
                _jsEntities[ entity.className ].prototype = {
                    $$getPropertyByName:function(propertyName){
                        return this['$$get'+propertyName.charAt(0).toUpperCase() + propertyName.slice(1)]();
                    },
                    $$isPersisted:function(){
                        return this.$$getID() !== '';
                    },
                    $$init:function( data ) {

                        _init(this,data);
                    },
                    $$save:function(){
                        return _save(this);
                    },
                    $$delete:function(){
                        return _delete(this);
                    },

                    $$getValidationsByProperty:function(property){
                        return _getValidationsByProperty(this,property);
                    },
                    $$getValidationByPropertyAndContext:function(property,context){
                        return _getValidationByPropertyAndContext(this,property,context);
                    },
                    $$getTitleByPropertyIdentifier(propertyIdentifier){
                        if(propertyIdentifier.split('.').length > 1){
                            var listFirst = utilityService.listFirst(propertyIdentifier,'.');
                            var relatedEntityName = this.metaData[listFirst].cfc;
                            var exampleEntity = $delegate.newEntity(relatedEntityName);
                            return exampleEntity.$$getTitleByPropertyIdentifier(propertyIdentifier.replace(listFirst,''));
                        }
                        return this.metaData.$$getPropertyTitle(propertyIdentifier);
                    },

                    $$getMetaData:function( propertyName ) {
                        if(propertyName === undefined) {
                            return this.metaData
                        }else{
                            if(angular.isDefined(this.metaData[propertyName].name) && angular.isUndefined(this.metaData[propertyName].nameCapitalCase)){
                                this.metaData[propertyName].nameCapitalCase = this.metaData[propertyName].name.charAt(0).toUpperCase() + this.metaData[propertyName].name.slice(1);
                            }
                            if(angular.isDefined(this.metaData[propertyName].cfc) && angular.isUndefined(this.metaData[propertyName].cfcProperCase)){
                                this.metaData[propertyName].cfcProperCase = this.metaData[propertyName].cfc.charAt(0).toLowerCase()+this.metaData[propertyName].cfc.slice(1);
                            }
                            return this.metaData[ propertyName ];
                        }
                    }
                };

                angular.forEach(relatedAttributes,function(attributeSet){
                    angular.forEach(attributeSet.attributes,function(attribute){
                        if(attribute && attribute.attributeCode){
                        Object.defineProperty(_jsEntities[ entity.className ].prototype, attribute.attributeCode, {
                            configurable:true,
                            enumerable:false,
                            get: function() {
                                if(attribute != null && this.data[attribute.attributeCode] == null){
                                    return undefined;
                                }
                                return this.data[attribute.attributeCode];
                            },
                            set: function(value) {
                                this.data[attribute.attributeCode]=value;
                            }
                        });
                        }
                    });
                });

                angular.forEach(entity,function(property){
                    if(angular.isObject(property) && angular.isDefined(property.name)){
                        //if(angular.isUndefined(property.persistent)){
                            if(angular.isDefined(property.fieldtype)){
                                if(['many-to-one'].indexOf(property.fieldtype) >= 0){

                                    _jsEntities[ entity.className ].prototype['$$get'+property.name.charAt(0).toUpperCase()+property.name.slice(1)]=function() {

                                        var thisEntityInstance = this;

                                        if(angular.isDefined(this['$$get'+this.$$getIDName().charAt(0).toUpperCase()+this.$$getIDName().slice(1)]())){
                                            var options = {
                                                columnsConfig:angular.toJson([
                                                    {
                                                        "propertyIdentifier":"_"+this.metaData.className.toLowerCase()+"_"+property.name
                                                    }
                                                ]),
                                                joinsConfig:angular.toJson([
                                                    {
                                                        "associationName":property.name,
                                                        "alias":"_"+this.metaData.className.toLowerCase()+"_"+property.name
                                                    }
                                                ]),
                                                filterGroupsConfig:angular.toJson([{
                                                    "filterGroup":[
                                                        {
                                                            "propertyIdentifier":"_"+this.metaData.className.toLowerCase()+"."+this.$$getIDName(),
                                                            "comparisonOperator":"=",
                                                            "value":this.$$getID()
                                                        }
                                                    ]
                                                }]),
                                                allRecords:true
                                            };

                                            var collectionPromise = $delegate.getEntity(entity.className,options);
                                            collectionPromise.then(function(response){
                                                for(var i in response.records){
                                                    var entityInstance = $delegate.newEntity(thisEntityInstance.metaData[property.name].cfc);
                                                    //Removed the array index here at the end of local.property.name.
                                                    if(angular.isArray(response.records[i][property.name])){
                                                        entityInstance.$$init(response.records[i][property.name][0]);
                                                    }else{
                                                        entityInstance.$$init(response.records[i][property.name]);//Shouldn't have the array index'
                                                    }
                                                    thisEntityInstance['$$set'+property.name.charAt(0).toUpperCase()+property.name.slice(1)](entityInstance);
                                                }
                                            });
                                            return collectionPromise;

                                        }

                                        return null;
                                    };
                                    _jsEntities[ entity.className ].prototype['$$set'+property.name.charAt(0).toUpperCase()+property.name.slice(1)]=function(entityInstance?) {

                                        var thisEntityInstance = this;
                                        var metaData = this.metaData;
                                        var manyToManyName = '';

                                        //if entityInstance is not passed in, clear related object
                                        if(angular.isUndefined(entityInstance)){
                                            if(angular.isDefined(thisEntityInstance.data[property.name])){
                                                delete thisEntityInstance.data[property.name];
                                            }

                                            if(!thisEntityInstance.parents){
                                                return;
                                            }
                                            for(var i = 0; i <= thisEntityInstance.parents.length; i++){
                                                if(angular.isDefined(thisEntityInstance.parents[i]) &&  thisEntityInstance.parents[i].name == property.name.charAt(0).toLowerCase() + property.name.slice(1)){
                                                    thisEntityInstance.parents.splice(i,1);
                                                }
                                            }
                                            return;
                                        }

                                        if(property.name === 'parent'+this.metaData.className){
                                            var childName = 'child'+this.metaData.className;
                                            manyToManyName = entityInstance.metaData.$$getManyToManyName(childName);

                                        }else if(entityInstance.metaData){

                                            manyToManyName = entityInstance.metaData.$$getManyToManyName(metaData.className.charAt(0).toLowerCase() + metaData.className.slice(1));

                                        }
                                        // else{
                                        //     manyToManyName = entityInstance.metaData.$$getManyToManyName(metaData.className.charAt(0).toLowerCase() + metaData.className.slice(1));
                                        // }

                                        if(angular.isUndefined(thisEntityInstance.parents)){
                                            thisEntityInstance.parents = [];
                                        }

                                        thisEntityInstance.parents.push(thisEntityInstance.metaData[property.name]);


                                        if(angular.isDefined(manyToManyName) && manyToManyName.length){
                                            if(angular.isUndefined(entityInstance.children)){
                                                entityInstance.children = [];
                                            }

                                            var child = entityInstance.metaData[manyToManyName];

                                            if(entityInstance.children.indexOf(child) === -1){
                                                entityInstance.children.push(child);
                                            }

                                            if(angular.isUndefined(entityInstance.data[manyToManyName])){
                                                entityInstance.data[manyToManyName] = [];
                                            }
                                            entityInstance.data[manyToManyName].push(thisEntityInstance);
                                        }

                                        thisEntityInstance.data[property.name] = entityInstance;
                                    };
                                    if(property.name !== 'data' && property.name !== 'validations'){

                                        Object.defineProperty(_jsEntities[ entity.className ].prototype, property.name, {
                                            configurable:true,
                                            enumerable:false,

                                            get: function() {
                                                if(this.data[property.name] == null){
                                                    return undefined;
                                                }

                                                return this.data[property.name];
                                            },
                                            set: function(value) {

                                                this['$$set'+property.name.charAt(0).toUpperCase()+property.name.slice(1)](value);

                                            }
                                        });
                                    }

                                }else if(['one-to-many','many-to-many'].indexOf(property.fieldtype) >= 0){

                                    if(!property.singularname){
                                        throw('need to define a singularname for ' +property.fieldtype);
                                    }
                                    _jsEntities[ entity.className ].prototype['$$add'+property.singularname.charAt(0).toUpperCase()+property.singularname.slice(1)]=function(entityInstance?){

                                        if(angular.isUndefined(entityInstance)){
                                            var entityInstance = $delegate.newEntity(this.metaData[property.name].cfc);
                                        }
                                        var metaData = this.metaData;

                                        if(metaData[property.name].fieldtype === 'one-to-many'){
                                            entityInstance.data[metaData[property.name].fkcolumn.slice(0,-2)] = this;

                                        }else if(metaData[property.name].fieldtype === 'many-to-many'){

                                            var manyToManyName = entityInstance.metaData.$$getManyToManyName(metaData.className.charAt(0).toLowerCase() + this.metaData.className.slice(1));
                                            if(angular.isUndefined(entityInstance.data[manyToManyName])){
                                                entityInstance.data[manyToManyName] = [];
                                            }
                                            entityInstance.data[manyToManyName].push(this);
                                        }

                                        if(angular.isDefined(metaData[property.name])){
                                            if(angular.isDefined(entityInstance.metaData[metaData[property.name].fkcolumn.slice(0,-2)])){

                                                if(angular.isUndefined(entityInstance.parents)){
                                                    entityInstance.parents = [];
                                                }

                                                entityInstance.parents.push(entityInstance.metaData[metaData[property.name].fkcolumn.slice(0,-2)]);
                                            }

                                            if(angular.isUndefined(this.children)){
                                                this.children = [];
                                            }

                                            var child = metaData[property.name];

                                            if(this.children.indexOf(child) === -1){
                                                this.children.push(child);
                                            }
                                        }
                                        if(angular.isUndefined(this.data[property.name])){
                                            this.data[property.name] = [];
                                        }

                                        this.data[property.name].push(entityInstance);
                                        return entityInstance;
                                    };



                                    _jsEntities[ entity.className ].prototype['$$get'+property.name.charAt(0).toUpperCase()+property.name.slice(1)]=function() {

                                        var thisEntityInstance = this;
                                        if(angular.isDefined(this['$$get'+this.$$getIDName().charAt(0).toUpperCase()+this.$$getIDName().slice(1)])){
                                            var options = {
                                                filterGroupsConfig:angular.toJson([{
                                                    "filterGroup":[
                                                        {
                                                            "propertyIdentifier":"_"+property.cfc.toLowerCase()+"."+property.fkcolumn.replace('ID','')+"."+this.$$getIDName(),
                                                            "comparisonOperator":"=",
                                                            "value":this.$$getID()
                                                        }
                                                    ]
                                                }]),
                                                allRecords:true
                                            };

                                            var collectionPromise = $delegate.getEntity(property.cfc,options);
                                            collectionPromise.then(function(response){
                                                var entityInstances = [];
                                                for(var i in response.records){

                                                    var entityInstance = thisEntityInstance['$$add'+property.singularname.charAt(0).toUpperCase()+property.singularname.slice(1)]();
                                                    entityInstance.$$init(response.records[i]);
                                                    if(angular.isUndefined(thisEntityInstance[property.name])){
                                                        thisEntityInstance[property.name] = [];
                                                    }
                                                    entityInstances.push(entityInstance);
                                                }
                                                thisEntityInstance.data[property.name] = entityInstances;
                                            });
                                            return collectionPromise;
                                        }
                                    };

                                    Object.defineProperty(_jsEntities[ entity.className ].prototype, property.name, {
                                        configurable:true,
                                        enumerable:false,

                                        get: function() {
                                            if(this.data[property.name] == null){
                                                return undefined;
                                            }
                                            return this.data[property.name];
                                        },
                                        set: function(value) {
                                            this.data[property.name]= [];
                                            if(angular.isArray(value)){
                                                for(var i =0;i < value.length;i++){
                                                    var item = value[i];
                                                    let entityInstance = $delegate.newEntity(this.metaData[property.name].cfc);
                                                    entityInstance.$$init(item);
                                                    this['$$add'+property.singularname.charAt(0).toUpperCase()+property.singularname.slice(1)](entityInstance);
                                                }
                                            }else{


                                                let entityInstance = $delegate.newEntity(this.metaData[property.name].cfc);
                                                    entityInstance.$$init(value);
                                                    this['$$add'+property.singularname.charAt(0).toUpperCase()+property.singularname.slice(1)](entityInstance);
                                            }
                                        }
                                    });

                                }else{

                                    if(['id'].indexOf(property.fieldtype)>= 0){
                                        _jsEntities[ entity.className ].prototype['$$getID']=function(){
                                            //this should retreive id from the metadata
                                            return this.data[this.$$getIDName()];
                                        };

                                        _jsEntities[ entity.className ].prototype['$$getIDName']=function(){
                                            var IDNameString = property.name;
                                            return IDNameString;
                                        };
                                    }


                                    if(property.name !== 'data' && property.name !== 'validations'){
                                        Object.defineProperty(_jsEntities[ entity.className ].prototype, property.name, {
                                            configurable:true,
                                            enumerable:false,

                                            get: function() {
                                                if(this.data[property.name] == null){
                                                    return undefined;
                                                }
                                                return this.data[property.name];
                                            },
                                            set: function(value) {

                                                this.data[property.name]=value;

                                            }
                                        });
                                    }


                                    _jsEntities[ entity.className ].prototype['$$get'+property.name.charAt(0).toUpperCase()+property.name.slice(1)]=function(){
                                        return this.data[property.name];
                                    };
                                }
                            }else{

                                if(property.name !== 'data' && property.name !== 'validations'){
                                    Object.defineProperty(_jsEntities[ entity.className ].prototype, property.name, {
                                        configurable:true,
                                        enumerable:false,

                                        get: function() {
                                            if(this.data[property.name] == null){
                                                return undefined;
                                            }
                                            return this.data[property.name];
                                        },
                                        set: function(value) {

                                            this.data[property.name]=value;

                                        }
                                    });

                                }
                                _jsEntities[ entity.className ].prototype['$$get'+property.name.charAt(0).toUpperCase()+property.name.slice(1)]=function() {
                                    return this.data[property.name];
                                };
                            }
                        //}
                    }
                });

            });
            $delegate.setJsEntities(_jsEntities);

            angular.forEach(_jsEntities,function(jsEntity:any){
                var jsEntityInstance = new jsEntity;
                _jsEntityInstances[jsEntityInstance.metaData.className] = jsEntityInstance;

            });

            $delegate.setJsEntityInstances(_jsEntityInstances);

            var _init = function(entityInstance,data){

                hibachiValidationService.init(entityInstance,data);
            }

            var _getPropertyTitle = function(propertyName,metaData){

                return $delegate.getPropertyTitle(propertyName,metaData);
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
            };



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
                if(!propertyName || !metaData){
                    return 'none';
                }

                var propertyMetaData = metaData[propertyName];


                if(propertyMetaData['hb_formattype']){
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

                return !!(angular.isString(value) || angular.isNumber(value)
                || angular.isDate(value) || value === false || value === true);
            };


            var _getFormattedValue = function(propertyName,formatType,entityInstance){
                var value = entityInstance.$$getPropertyByName(propertyName);

                if(angular.isUndefined(formatType)){
                    formatType = entityInstance.metaData.$$getPropertyFormatType(propertyName);
                }

                if(formatType === "custom"){
                    //to be implemented
                    //return entityInstance['$$get'+propertyName+Formatted]();
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
                    var formatDetails:any = {};
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
                return $delegate.saveEntity(entityName, entityID, {}, context);
            };

            var _setValueByPropertyPath = function (obj,path, value) {
                var a = path.split('.');
                var context = obj;
                var selector;
                var myregexp:any = /([a-zA-Z]+)(\[(\d)\])+/; // matches:  item[0]
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


            };

            var _getValueByPropertyPath = function(obj,path) {
                var paths = path.split('.'),
                    current = obj,
                    i;

                for (i = 0; i < paths.length; ++i) {
                    if (current[paths[i]] == undefined) {
                        return undefined;
                    } else {
                        current = current[paths[i]];
                    }
                }
                return current;
            };

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
                            _addReturnedIDs(returnedIDs[key][k],entityInstance.data[key][k]);
                        }
                    }else{
                        entityInstance.data[key] = returnedIDs[key];
                    }
                }
            };


            var _save = function(entityInstance){
                var deferred = $q.defer();
                $timeout(function(){
                    //$log.debug('save begin');
                    //$log.debug(entityInstance);

                    var entityID = entityInstance.$$getID();

                    var modifiedData:any = _getModifiedData(entityInstance);
                    //$log.debug('modifiedData complete');
                    //$log.debug(modifiedData);
                    //timeoutPromise.valid = modifiedData.valid;
                    if(modifiedData.valid){
                        var params:any = {};

                        params.serializedJsonData = utilityService.toJson(modifiedData.value);
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
                        var savePromise = $delegate.saveEntity(entityName,entityID,params,context);
                        savePromise.then(function(response){
                            var returnedIDs = response.data;
                            if(
                                (angular.isDefined(response.SUCCESS) && response.SUCCESS === true)
                                || (angular.isDefined(response.success) && response.success === true)
                            ){

                                if($location.url() == '/entity/'+entityName+'/create' && response.data[modifiedData.objectLevel.$$getIDName()]){
                                    $location.path('/entity/'+entityName+'/'+response.data[modifiedData.objectLevel.$$getIDName()], false);
                                }
                                _addReturnedIDs(returnedIDs,modifiedData.objectLevel);

                                deferred.resolve(returnedIDs);
                                observerService.notify('saveSuccess',returnedIDs);
                                observerService.notify('saveSuccess'+entityName,returnedIDs);
                            }else{
                                deferred.reject(angular.isDefined(response.messages) ? response.messages : response);
                                observerService.notify('saveFailed',response);
                                observerService.notify('saveFailed'+entityName,response);
                            }
                        }, function(reason){
                            deferred.reject(reason);
                            observerService.notify('saveFailed',reason);
                            observerService.notify('saveFailed'+entityName,reason);
                        });
                    }else{

                        //select first, visible, and enabled input with a class of ng-invalid

                        var target = $('input.ng-invalid:first:visible:enabled');
                        if(angular.isDefined(target)){
                            target.focus();
                            var targetID = target.attr('id');
                            $anchorScroll();
                        }
                        deferred.reject('Input is invalid.');
                        observerService.notify('validationFailed');
                        observerService.notify('validationFailed'+entityName);
                    }
                });
                //return timeoutPromise;
                return deferred.promise;
                /*

                */
            };

            var _getModifiedData = function(entityInstance){
                var modifiedData:any = {};
                modifiedData = getModifiedDataByInstance(entityInstance);
                return modifiedData;
            };

            var getObjectSaveLevel = function(entityInstance){
                return hibachiValidationService.getObjectSaveLevel(entityInstance);
            };

            var validateObject = function(entityInstance){
                return hibachiValidationService.validateObject;
            }

            var validateChildren = function(entityInstance){
                return hibachiValidationService.validateChildren(entityInstance);
            }

            var processChild = function(entityInstance,entityInstanceParent){
                return hibachiValidationService.processChild(entityInstance,entityInstanceParent);
            }

            var processParent = function(entityInstance){
                return hibachiValidationService.processParent(entityInstance);
            }

            var processForm = function(form,entityInstance){
                return hibachiValidationService.processForm(form,entityInstance);
            }

            var getDataFromParents = function(entityInstance,entityInstanceParents){
                return hibachiValidationService.getDataFromParents(entityInstance,entityInstanceParents);
            }

            var getDataFromChildren = function(entityInstance){
                return hibachiValidationService.getDataFromChildren(entityInstance);
            }

            var getModifiedDataByInstance = function(entityInstance){
                return hibachiValidationService.getModifiedDataByInstance(entityInstance);
            };

            var _getValidationsByProperty = function(entityInstance,property){
                return hibachiValidationService.getValidationsByProperty(entityInstance,property);
            };

            var _getValidationByPropertyAndContext = function(entityInstance,property,context){
                return hibachiValidationService.getValidationByPropertyAndContext(entityInstance,property,context);
            }

            return $delegate;

        

	}

}

