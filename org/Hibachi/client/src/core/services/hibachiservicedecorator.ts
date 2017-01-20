/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

import {HibachiValidationService} from "../services/hibachivalidationservice";
import {HibachiService} from "../services/hibachiservice";
class HibachiServiceDecorator{
    //@ngInject
    constructor(
        $delegate:HibachiService,
        $http,
        $timeout,
        $log,
        $rootScope,
        $location,
        $anchorScroll,
        $q,
        utilityService,
        formService,
        rbkeyService,
        appConfig,
        observerService,
        hibachiValidationService:HibachiValidationService,
        attributeMetaData
    ){
            var _deferred = {};
            var _config = appConfig;

            var _jsEntities = {};
            var _jsEntityInstances = {};
            var entities = appConfig.modelConfig.entities,
                validations = appConfig.modelConfig.validations,
                defaultValues = appConfig.modelConfig.defaultValues;

            angular.forEach(entities,function(entity){
                if(attributeMetaData[entity.className]){
                    var relatedAttributes = attributeMetaData[entity.className];
                    for(var attributeSetCode in relatedAttributes){
                        var attributeSet = relatedAttributes[attributeSetCode];
                        for(var attributeCode in attributeSet.attributes){
                            var attribute = attributeSet.attributes[attributeCode];
                            attribute.attributeSet = attributeSet;
                            attribute.isAttribute = true;
                            entity[attributeCode] = attribute;
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

                        return entityService['new'+entity.className]();
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
                        return rbkeyService.rbKey(rbKey,replaceStringData);
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
                            if(angular.isDefined(defaultValues[entity.className][property.name])){
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
                                    if(this.data[attribute.attributeCode] == null){
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

export{
	HibachiServiceDecorator
}