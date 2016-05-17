/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

class HibachiServiceDecorator{
    //@ngInject
    constructor(
        $delegate,
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
        appConfig
    ){
        var _deferred = {};
        var _config = appConfig;

        var _jsEntities = {};
        var _jsEntityInstances = {};
        var entities = appConfig.modelConfig.entities,
            validations = appConfig.modelConfig.validations,
            defaultValues = appConfig.modelConfig.defaultValues;

        angular.forEach(entities,function(entity){

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
                        entityInstance.$$init(response);
                    }
                });
                return {
                    promise:entityDataPromise,
                    value:entityInstance
                }
            }


            $delegate['get'+entity.className] = function(options){
                var entityInstance = $delegate.newEntity(entity.className);
                var entityDataPromise = $delegate.getEntity(entity.className,options);
                entityDataPromise.then(function(response){

                    if(angular.isDefined(response.processData)){
                        entityInstance.$$init(response.data);
                        var processObjectInstance = $delegate['new'+entity.className+options.processContext.charAt(0).toUpperCase()+options.processContext.slice(1)]();
                        processObjectInstance.$$init(response.processData);
                        processObjectInstance.data[entity.className.charAt(0).toLowerCase()+entity.className.slice(1)] = entityInstance;
                        entityInstance.processObject = processObjectInstance;
                    }else{
                        entityInstance.$$init(response);
                    }
                });
                return {
                    promise:entityDataPromise,
                    value:entityInstance
                }
            }

            $delegate['new'+entity.className] = function(){
                return $delegate.newEntity(entity.className);
            }

            entity.isProcessObject = entity.className.indexOf('_') >= 0;

                _jsEntities[ entity.className ]=function() {

                this.validations = validations[entity.className];

                this.metaData = entity;
                this.metaData.className = entity.className;
                if(entity.hb_parentPropertyName){
                    this.metaData.hb_parentPropertyName = entity.hb_parentPropertyName;
                }
                if(entity.hb_childPropertyName){
                    this.metaData.hb_childPropertyName = entity.hb_childPropertyName;
                }

                this.metaData.$$getRBKey = function(rbKey,replaceStringData){
                    return $delegate.rbKey(rbKey,replaceStringData);
                };


                this.metaData.$$getPropertyTitle = function(propertyName){
                    return _getPropertyTitle(propertyName,this);
                }

                this.metaData.$$getPropertyHint = function(propertyName){
                    return _getPropertyHint(propertyName,this);
                }

                this.metaData.$$getManyToManyName = function(singularname){
                    var metaData = this;
                    for(var i in metaData){
                        if(metaData[i].singularname === singularname){
                            return metaData[i].name;
                        }
                    }
                }



                this.metaData.$$getPropertyFieldType = function(propertyName){
                    return _getPropertyFieldType(propertyName,this);
                }

                this.metaData.$$getPropertyFormatType = function(propertyName){
                    return _getPropertyFormatType(propertyName,this);
                }

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
                }

                this.$$getFormattedValue = function(propertyName,formatType){
                    return _getFormattedValue(propertyName,formatType,this);
                }

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
                            jsEntity.data[property.name] = defaultValues[entity.className][property.name];
                        }
                    }
                });

            };
                _jsEntities[ entity.className ].prototype = {
                $$getPropertyByName:function(propertyName){
                    return this['$$get'+propertyName.charAt(0).toUpperCase() + propertyName.slice(1)]();
                },
                $$isPersisted:function(){
                    if(this.$$getID() === ''){
                        return false;
                    }else{
                        return true;
                    }
                },
                $$init:function( data ) {

                    _init(this,data);
                },
                $$save:function(){
                    return _save(this);
                },
                $$delete:function(){
                    var deletePromise =_delete(this)
                    return deletePromise;
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
                        return exampleEntity = exampleEntity.$$getTitleByPropertyIdentifier(propertyIdentifier.replace(listFirst,''));
                    }
                    return this.metaData.$$getPropertyTitle(propertyIdentifier);
                }

                ,$$getMetaData:function( propertyName ) {
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
            angular.forEach(entity,function(property){
                if(angular.isObject(property) && angular.isDefined(property.name)){
                    if(angular.isUndefined(property.persistent)){
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
                                _jsEntities[ entity.className ].prototype['$$set'+property.name.charAt(0).toUpperCase()+property.name.slice(1)]=function(entityInstance) {


                                    var thisEntityInstance = this;
                                    var metaData = this.metaData;
                                    var manyToManyName = '';
                                    if(property.name === 'parent'+this.metaData.className){
                                        var childName = 'child'+this.metaData.className;
                                        manyToManyName = entityInstance.metaData.$$getManyToManyName(childName);

                                    }else{
                                        manyToManyName = entityInstance.metaData.$$getManyToManyName(metaData.className.charAt(0).toLowerCase() + this.metaData.className.slice(1));
                                    }

                                    if(angular.isUndefined(thisEntityInstance.parents)){
                                        thisEntityInstance.parents = [];
                                    }

                                    thisEntityInstance.parents.push(thisEntityInstance.metaData[property.name]);


                                    if(angular.isDefined(manyToManyName)){
                                        if(angular.isUndefined(entityInstance.children)){
                                            entityInstance.children = [];
                                        }

                                        var child = entityInstance.metaData[manyToManyName];;

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

                            }else if(['one-to-many','many-to-many'].indexOf(property.fieldtype) >= 0){

                                _jsEntities[ entity.className ].prototype['$$add'+property.singularname.charAt(0).toUpperCase()+property.singularname.slice(1)]=function(){


                                    var entityInstance = $delegate.newEntity(this.metaData[property.name].cfc);
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

                                        for(var i in response.records){

                                            var entityInstance = thisEntityInstance['$$add'+thisEntityInstance.metaData[property.name].singularname.charAt(0).toUpperCase()+thisEntityInstance.metaData[property.name].singularname.slice(1)]();
                                            entityInstance.$$init(response.records[i]);
                                            if(angular.isUndefined(thisEntityInstance[property.name])){
                                                thisEntityInstance[property.name] = [];
                                            }
                                            thisEntityInstance[property.name].push(entityInstance);
                                        }
                                    });
                                    return collectionPromise;
                                }
                            };
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

                                _jsEntities[ entity.className ].prototype['$$get'+property.name.charAt(0).toUpperCase()+property.name.slice(1)]=function(){
                                return this.data[property.name];
                            };
                        }
                    }else{
                        _jsEntities[ entity.className ].prototype['$$get'+property.name.charAt(0).toUpperCase()+property.name.slice(1)]=function() {
                            return this.data[property.name];
                        };
                    }
                }
                }
            });

        });
        $delegate.setJsEntities(_jsEntities);

        angular.forEach(_jsEntities,(jsEntity)=>{
            var jsEntityInstance = new jsEntity;
            _jsEntityInstances[jsEntityInstance.metaData.className] = jsEntityInstance;
        });

        $delegate.setJsEntityInstances(_jsEntityInstances);

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
                } else if("big_decimal" === dataType){
                    return "text";
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
            var deletePromise = $delegate.saveEntity(entityName,entityID,{},context);
            return deletePromise;
        }

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
                        _addReturnedIDs(returnedIDs[key][k],entityInstance.data[key][k]);
                    }
                }else{
                    entityInstance.data[key] = returnedIDs[key];
                }
            }
        }


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
                    var savePromise = $delegate.saveEntity(entityName,entityInstance.$$getID(),params,context);
                    savePromise.then(function(response){
                        var returnedIDs = response.data;
                        if(angular.isDefined(response.SUCCESS) && response.SUCCESS === true){
                            _addReturnedIDs(returnedIDs,modifiedData.objectLevel);
                            deferred.resolve(returnedIDs);
                        }else{
                            deferred.reject(angular.isDefined(response.messages) ? response.messages : response);
                        }
                    }, function(reason){
                        deferred.reject(reason);
                    });
                }else{

                    //select first, visible, and enabled input with a class of ng-invalid

                    var target = $('input.ng-invalid:first:visible:enabled');
                    //$log.debug('input is invalid');
                    //$log.debug(target);
                    target.focus();
                    var targetID = target.attr('id');
                    $anchorScroll();
                    deferred.reject('Input is invalid.');
                }
            });
            //return timeoutPromise;
            return deferred.promise;
            /*




            */
        }

        var _getModifiedData = function(entityInstance){
            var modifiedData:any = {};
            modifiedData = getModifiedDataByInstance(entityInstance);
            return modifiedData;
        }

        var getObjectSaveLevel = function(entityInstance){
            var objectLevel:any = entityInstance;

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

            var modifiedData:any = {};
            var valid = true;

            var forms = entityInstance.forms;
            //$log.debug('process base level data');
            for(var f in forms){
                var form = forms[f];
                form.$setSubmitted();   //Sets the form to submitted for the validation errors to pop up.
                if(form.$dirty && form.$valid){
                    for(var key in form){
                        //$log.debug('key:'+key);
                        if(key.charAt(0) !== '$' && angular.isObject(form[key])){
                            var inputField = form[key];
                            if(angular.isDefined(inputField.$valid) && inputField.$valid === true && (inputField.$dirty === true || (form.autoDirty && form.autoDirty == true))){


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
                            if(key.charAt(0) !== '$' && angular.isObject(form[key])){
                                var inputField = form[key];
                                if(angular.isDefined(inputField) && angular.isDefined(inputField.$valid) && inputField.$valid === true && (inputField.$dirty === true || (form.autoDirty && form.autoDirty == true))){

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
                if(key.charAt(0) !== '$' && angular.isObject(form[key])){
                    var inputField = form[key];
                    if(angular.isDefined(inputField) && angular.isDefined(inputField) && inputField.$valid === true && (inputField.$dirty === true || (form.autoDirty && form.autoDirty == true))){

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
                    var modifiedData:any = {};





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

        return $delegate;
    }

}

export{
	HibachiServiceDecorator
}