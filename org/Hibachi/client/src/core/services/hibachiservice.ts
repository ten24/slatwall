/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

declare var escape;

// interface ISlatwallRootScopeService extends ng.IRootScopeService{
//     loadedResourceBundle:boolean;
// 	loadingResourceBundle:boolean;
// }

class HibachiService{

	public _deferred = {};
    public _resourceBundle = {};
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
		private utilityService,
		private formService,
        private rbkeyService,
        private appConfig,
		private _config:any,
		public _jsEntities:any,
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
        this.utilityService = utilityService;
        this.formService = formService;
        this.rbkeyService = rbkeyService;
        this.appConfig = appConfig;
        this._config = _config;
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
		return this.getEntityMetaData(entityName).$$getIDName();
	};

	getEntityHasPropertyByEntityName = (entityName,propertyName):boolean=>{
		return angular.isDefined(this.getEntityMetaData(entityName)[propertyName]);
	};

	getPropertyIsObjectByEntityNameAndPropertyIdentifier = (entityName:string,propertyIdentifier:string):boolean=>{
		var lastEntity = this.getLastEntityNameInPropertyIdentifier(entityName,propertyIdentifier);
		var entityMetaData = this.getEntityMetaData(lastEntity);
		return angular.isDefined(entityMetaData[this.utilityService.listLast(propertyIdentifier,'.')].cfc);
	};

	getLastEntityNameInPropertyIdentifier = (entityName,propertyIdentifier)=>{
		if(!entityName){
			throw('No entity name was supplied to getLastEntityNameInPropertyIdentifier in hibachi service.');
		}
		//strip alias if it exists
		if(propertyIdentifier.charAt(0) === '_'){
			propertyIdentifier = this.utilityService.listRest(propertyIdentifier,'.');
		}
		if(propertyIdentifier.split('.').length > 1){
			var propertiesStruct = this.getEntityMetaData(entityName);
			if(
				!propertiesStruct[this.utilityService.listFirst(propertyIdentifier,'.')]
				|| !propertiesStruct[this.utilityService.listFirst(propertyIdentifier,'.')].cfc
			){
				throw("The Property Identifier "+propertyIdentifier+" is invalid for the entity "+entityName);
			}
			var currentEntityName = this.utilityService.listLast(propertiesStruct[this.utilityService.listFirst(propertyIdentifier,'.')].cfc,'.');
			var currentPropertyIdentifier = this.utilityService.right(propertyIdentifier,propertyIdentifier.length-(this.utilityService.listFirst(propertyIdentifier,'.').length+1));
			return this.getLastEntityNameInPropertyIdentifier(currentEntityName,currentPropertyIdentifier);
		}
		return entityName;

	};

	//service method used to transform collection data to collection objects based on a collectionconfig
	populateCollection = (collectionData,collectionConfig) =>{
		//create array to hold objects
		var entities = [];
		//loop over all collection data to create objects
		var hibachiService = this;
		angular.forEach(collectionData, function(collectionItemData, key){
			//create base Entity
			var entity = hibachiService['new'+collectionConfig.baseEntityName.replace('Slatwall','')]();
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
		return new this._jsEntities[entityName];
	};
	/*basic entity getter where id is optional, returns a promise*/
	getEntity= (entityName:string, options:any) => {
		/*
			*
			* getEntity('Product', '12345-12345-12345-12345');
			* getEntity('Product', {keywords='Hello'});
			*
			*/
		if(angular.isUndefined(options)){
			options = {};
		}

		if(angular.isDefined(options.deferKey)) {
			this.cancelPromise(options.deferKey);
		}

		var params:any= {};
		if(typeof options === 'string') {

			var urlString = this.getUrlWithActionPrefix()+'api:main.get&entityName='+entityName+'&entityID='+options;
		} else {
			params['P:Current'] = options.currentPage || 1;
			params['P:Show'] = options.pageShow || 10;
			params.keywords = options.keywords || '';
			params.columnsConfig = options.columnsConfig || '';
			params.filterGroupsConfig = options.filterGroupsConfig || '';
			params.joinsConfig = options.joinsConfig || '';
			params.orderByConfig = options.orderByConfig || '';
			params.groupBysConfig = options.groupBysConfig || '';
			params.isDistinct = (options.isDistinct == undefined) ? false : options.isDistinct;
			params.propertyIdentifiersList = options.propertyIdentifiersList || '';
			params.allRecords = options.allRecords || '';
			params.defaultColumns = (options.defaultColumns == undefined) ? true : options.defaultColumns;
			params.processContext = options.processContext || '';
			var urlString = this.getUrlWithActionPrefix()+'api:main.get&entityName='+entityName;
		}

		var deferred = this.$q.defer();
		if(angular.isDefined(options.id)) {
			urlString += '&entityId='+options.id;
		}

		/*var transformRequest = (data) => {

			return data;
		};
		//check if we are using a service to transform the request
		if(angular.isDefined(options.transformRequest)) => {
			transformRequest=options.transformRequest;
		}*/
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

		this.$http.get(urlString,
			{
				params:params,
				timeout:deferred.promise,
				//transformRequest:transformRequest,
				transformResponse:transformResponse
			}
		)
		.success((data) => {
			deferred.resolve(data);
		}).error((reason) => {
			deferred.reject(reason);
		});

		if(options.deferKey)  {
			this._deferred[options.deferKey] = deferred;
		}
		return deferred.promise;

	};
	getResizedImageByProfileName = (profileName, skuIDs) => {
		var deferred = this.$q.defer();
		return this.$http.get(this.getUrlWithActionPrefix()+'api:main.getResizedImageByProfileName&profileName=' + profileName + '&skuIDs=' + skuIDs)
		.success((data) => {
			deferred.resolve(data);
		}).error((reason) => {
			deferred.reject(reason);
		});
	}
	getEventOptions= (entityName) => {
		var deferred = this.$q.defer();
		var urlString = this.getUrlWithActionPrefix()+'api:main.getEventOptionsByEntityName&entityName='+entityName;

		this.$http.get(urlString)
		.success((data) => {
			deferred.resolve(data);
		}).error((reason) => {
			deferred.reject(reason);
		});

		return deferred.promise;
	};
    getProcessOptions= (entityName) => {
        var deferred = this.$q.defer();
        var urlString = this.getUrlWithActionPrefix()+'api:main.getProcessMethodOptionsByEntityName&entityName='+entityName;

        this.$http.get(urlString)
            .success((data) => {
                deferred.resolve(data);
            }).error((reason) => {
                deferred.reject(reason);
            });

        return deferred.promise;
    };
	checkUniqueOrNullValue = (object, property, value) => {
		return this.$http.get(this.getUrlWithActionPrefix()+'api:main.getValidationPropertyStatus&object=' + object + '&propertyidentifier=' + property +
		'&value=' + escape(value)).then(
	 (results:any):ng.IPromise<any> =>{
		return results.data.uniqueStatus;
		})
	};
	checkUniqueValue = (object, property, value) => {
		return this.$http.get(this.getUrlWithActionPrefix()+'api:main.getValidationPropertyStatus&object=' + object + '&propertyidentifier=' + property +
			'&value=' + escape(value)).then(
			 (results:any):ng.IPromise<any> =>{
				return results.data.uniqueStatus;
		});
	};
	getPropertyDisplayData = (entityName,options) => {
		var deferred = this.$q.defer();
		var urlString = this.getUrlWithActionPrefix()+'api:main.getPropertyDisplayData&entityName='+entityName;
		var params:any = {};
		params.propertyIdentifiersList = options.propertyIdentifiersList || '';
		this.$http.get(urlString,{params:params})
		.success((data) => {
			deferred.resolve(data);
		}).error((reason) => {
			deferred.reject(reason);
		});

		return deferred.promise;
	};
	getPropertyDisplayOptions = (entityName,options) => {
		var deferred = this.$q.defer();
		var urlString = this.getUrlWithActionPrefix()+'api:main.getPropertyDisplayOptions&entityName='+entityName;
		var params:any = {};
		params.property = options.property || '';
		if(angular.isDefined(options.argument1))  {
			params.argument1 = options.argument1;
		}

		this.$http.get(urlString,{params:params})
		.success((data) => {
			deferred.resolve(data);
		}).error((reason) => {
			deferred.reject(reason);
		});

		return deferred.promise;
	};
	saveEntity= (entityName,id,params,context) => {

		//$log.debug('save'+ entityName);
		var deferred = this.$q.defer();

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

		this.$http({
			url:urlString,
			method:'POST',
			data: $.param(params),
			headers: {'Content-Type': 'application/x-www-form-urlencoded'}
		})
		.success((data) => {
			deferred.resolve(data);

		}).error((reason) => {
			deferred.reject(reason);
		});
		return deferred.promise;
	};
	getExistingCollectionsByBaseEntity= (entityName) => {
		var deferred = this.$q.defer();
		var urlString = this.getUrlWithActionPrefix()+'api:main.getExistingCollectionsByBaseEntity&entityName='+entityName;

		this.$http.get(urlString)
		.success((data) => {
			deferred.resolve(data);
		}).error((reason) => {
			deferred.reject(reason);
		});
		return deferred.promise;

	};
	getFilterPropertiesByBaseEntityName= (entityName) => {
		var deferred = this.$q.defer();
		var urlString = this.getUrlWithActionPrefix()+'api:main.getFilterPropertiesByBaseEntityName&EntityName='+entityName;

		this.$http.get(urlString)
		.success((data) => {
			deferred.resolve(data);
		}).error((reason) => {
			deferred.reject(reason);
		});
		return deferred.promise;
	};

	login = (emailAddress,password) => {
		var deferred = this.$q.defer();
		var urlString = this.appConfig.baseURL+'/index.cfm/api/auth/login';
		var params:any= {
			emailAddress:emailAddress,
			password:password
		};
		return this.$http.get(urlString,{params:params}).success((response) => {
			deferred.resolve(response);
		}).error((response) => {
			deferred.reject(response);
		});
	};

	getResourceBundle= (locale) => {
		var deferred = this.$q.defer();
		var locale = locale || this.appConfig.rbLocale;

		if(this._resourceBundle[locale]) {
			return this._resourceBundle[locale];
		}

		var urlString = this.getUrlWithActionPrefix()+'api:main.getResourceBundle&instantiationKey='+this.appConfig.instantiationKey+'&locale='+locale;

		this.$http(
			{
				url:urlString,
				method:"GET"
			}
		).success((response:any,status,headersGetter) => {
			this._resourceBundle[locale] = response.data;
			deferred.resolve(response);
		}).error((response:any) => {
			this._resourceBundle[locale] = {};
			deferred.reject(response);
		});
		return deferred.promise
	};

	getCurrencies = () =>{
		var deferred = this.$q.defer();

		var urlString = this.getUrlWithActionPrefix()+'api:main.getCurrencies&instantiationKey='+this.appConfig.instantiationKey;
		this.$http.get(urlString).success((response) => {
			deferred.resolve(response);
		}).error((response) => {
			deferred.reject(response);
		});
		return deferred.promise;
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

class $Hibachi implements ng.IServiceProvider{

	public _config = {};
	private angular:ng.IAngularStatic = angular;
	public _jsEntities;
	public _jsEntityInstances;
	public setJsEntities = (jsEntities):void =>{
		this._jsEntities = jsEntities;
	};
    //@ngInject
	constructor(appConfig){

		this._config = appConfig;

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
			'formService',
            'rbkeyService',
            'appConfig'
		];
	}


	public $get(
		$window:ng.IWindowService,
		$q:ng.IQService,
		$http:ng.IHttpService,
		$timeout:ng.ITimeoutService,
		$log:ng.ILogService,
		$rootScope:ng.IRootScopeService,
		$location:ng.ILocationService,
		$anchorScroll:ng.IAnchorScrollService,
		utilityService,
		formService,
        rbkeyService,
        appConfig
	) {
		return new HibachiService(
			$window,
			$q,
			$http,
			$timeout,
			$log,
			$rootScope,
			$location,
			$anchorScroll,
			utilityService,
			formService,
            rbkeyService,
            appConfig,
			this._config,
			this._jsEntities,
			this._jsEntityInstances
		);

	}
	public getConfig = () =>{
		return this._config;
	};
	public getConfigValue = (key) =>{
		return this._config[key];
	};
	public setConfigValue = (key,value) =>{
		this._config[key] = value;
	};
	public setConfig = (config) =>{
		this._config = config;
	};
}

export{
	HibachiService,
	$Hibachi
}