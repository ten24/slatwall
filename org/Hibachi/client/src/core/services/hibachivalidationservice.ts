/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />


class HibachiValidationService{
    //@ngInject
    constructor(
		public $log
    ){
		this.$log = $log;

    }
    public getObjectSaveLevel = (entityInstance)=>{
		var objectLevel:any = entityInstance;

		var entityID = entityInstance.$$getID();

		angular.forEach(entityInstance.parents,(parentObject)=>{
			if(angular.isDefined(entityInstance.data[parentObject.name]) && entityInstance.data[parentObject.name].$$getID() === '' && (angular.isUndefined(entityID) || !entityID.trim().length)){


				var parentEntityInstance = entityInstance.data[parentObject.name];
				var parentEntityID = parentEntityInstance.$$getID();
				if(parentEntityID === '' && parentEntityInstance.forms){
					objectLevel = this.getObjectSaveLevel(parentEntityInstance);
				}
			}
		});

		return objectLevel;
	};

    public getModifiedDataByInstance = (entityInstance)=>{
		var modifiedData:any = {};

		var objectSaveLevel = this.getObjectSaveLevel(entityInstance);
		this.$log.debug('objectSaveLevel : ' + objectSaveLevel );
		var valueStruct = this.validateObject(objectSaveLevel);
		this.$log.debug('validateObject data');
		this.$log.debug(valueStruct.value);

		modifiedData = {
			objectLevel:objectSaveLevel,
			value:valueStruct.value,
			valid:valueStruct.valid
		};
		return modifiedData;
	}

    public getValidationByPropertyAndContext = (entityInstance,property,context)=>{
        var validations = this.getValidationsByProperty(entityInstance,property);
        for(var i in validations){

            var contexts = validations[i].contexts.split(',');
            for(var j in contexts){
                if(contexts[j] === context){
                    return validations[i];
                }
            }

        }
    }

    public getValidationsByProperty = (entityInstance,property)=>{
        return entityInstance.validations.properties[property];
    };

    public validateObject = (entityInstance)=>{
        var modifiedData:any = {};
        var valid = true;

        var forms = entityInstance.forms;
        this.$log.debug('process base level data');
        for(var f in forms){
            var form = forms[f];
            form.$setSubmitted();   //Sets the form to submitted for the validation errors to pop up.
            if(form.$dirty && form.$valid){
                for(var key in form){
                    this.$log.debug('key:'+key);
                    if(key.charAt(0) !== '$' && angular.isObject(form[key])){
                        var inputField = form[key];
                        if(typeof inputField.$modelValue != 'undefined' && inputField.$modelValue !== ''){
                            inputField.$dirty = true;
                        }

                        if(angular.isDefined(inputField.$valid) && inputField.$valid === true && (inputField.$dirty === true || (form.autoDirty && form.autoDirty == true))){

                            if(angular.isDefined(entityInstance.metaData[key])
                            && angular.isDefined(entityInstance.metaData[key].hb_formfieldtype)
                            && entityInstance.metaData[key].hb_formfieldtype === 'json'){
                                modifiedData[key] = angular.toJson(inputField.$modelValue);
                            }else{
                                modifiedData[key] = inputField.$modelValue;
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
        this.$log.debug(modifiedData);



        this.$log.debug('process parent data');
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
                            if(typeof inputField.$modelValue != 'undefined' && inputField.$modelValue !== ''){
                                inputField.$dirty = true;
                            }
                            if(angular.isDefined(inputField) && angular.isDefined(inputField.$valid) && inputField.$valid === true && (inputField.$dirty === true || (form.autoDirty && form.autoDirty == true))){

                                if(angular.isDefined(parentInstance.metaData[key])
                                && angular.isDefined(parentInstance.metaData[key].hb_formfieldtype)
                                && parentInstance.metaData[key].hb_formfieldtype === 'json'){
                                    modifiedData[parentObject.name][key] = angular.toJson(inputField.$modelValue);
                                }else{
                                    modifiedData[parentObject.name][key] = inputField.$modelValue;
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
        this.$log.debug(modifiedData);


        this.$log.debug('begin child data');
        var childrenData = this.validateChildren(entityInstance);
        this.$log.debug('child Data');
        this.$log.debug(childrenData);
        angular.extend(modifiedData,childrenData);
        return {
            valid:valid,
            value:modifiedData
        };
    }

    public validateChildren = (entityInstance)=>{

        var data = {}

        if(angular.isDefined(entityInstance.children) && entityInstance.children.length){

            data = this.getDataFromChildren(entityInstance);
        }
        return data;
    }
    public init=(entityInstance,data):void=>{
		for(var key in data) {
			if(key.charAt(0) !== '$' && angular.isDefined(entityInstance.metaData[key])){

				var propertyMetaData = entityInstance.metaData[key];
				if(angular.isDefined(propertyMetaData) && angular.isDefined(propertyMetaData.hb_formfieldtype) && propertyMetaData.hb_formfieldtype === 'json'){
					if(data[key].trim() !== ''){
						entityInstance.data[key] =angular.fromJson(data[key]);
					}

				}else{
					entityInstance.data[key] = data[key];
				}
			}
		}
	}

	public processForm = (form,entityInstance)=>{
		this.$log.debug('begin process form');
		var data = {};
		form.$setSubmitted();
		for(var key in form){
			if(key.charAt(0) !== '$' && angular.isObject(form[key])){
				var inputField = form[key];
				if(inputField.$modelValue){
					inputField.$dirty = true;
				}
				if(angular.isDefined(inputField) && angular.isDefined(inputField) && inputField.$valid === true && (inputField.$dirty === true || (form.autoDirty && form.autoDirty == true))){

					if(angular.isDefined(entityInstance.metaData[key]) && angular.isDefined(entityInstance.metaData[key].hb_formfieldtype) && entityInstance.metaData[key].hb_formfieldtype === 'json'){
						data[key] = angular.toJson(inputField.$modelValue);
					}else{
						data[key] = inputField.$modelValue;
					}

				}
			}
		}
		data[entityInstance.$$getIDName()] = entityInstance.$$getID();
		this.$log.debug('process form data');
		this.$log.debug(data);
		return data;
	}

	public processParent = (entityInstance)=>{
		var data = {};
		if(entityInstance.$$getID() !== ''){
			data[entityInstance.$$getIDName()] = entityInstance.$$getID();
		}

		this.$log.debug('processParent');
		this.$log.debug(entityInstance);
		var forms = entityInstance.forms;

		for(var f in forms){
			var form = forms[f];

			data = angular.extend(data,this.processForm(form,entityInstance));
		}

		return data;
	}

	public processChild = (entityInstance,entityInstanceParent)=>{

		var data = {};
		var forms = entityInstance.forms;

		for(var f in forms){

			var form = forms[f];

			angular.extend(data,this.processForm(form,entityInstance));
		}

		if(angular.isDefined(entityInstance.children) && entityInstance.children.length){

			var childData = this.getDataFromChildren(entityInstance);
			angular.extend(data,childData);
		}
		if(angular.isDefined(entityInstance.parents) && entityInstance.parents.length){

			var parentData = this.getDataFromParents(entityInstance,entityInstanceParent);
			angular.extend(data,parentData);
		}

		return data;
	}

	public getDataFromParents = (entityInstance,entityInstanceParent)=>{
		var data = {};

		for(var c in entityInstance.parents){
			var parentMetaData = entityInstance.parents[c];
			if(angular.isDefined(parentMetaData)){
				var parent = entityInstance.data[parentMetaData.name];
				if(angular.isObject(parent) && entityInstanceParent !== parent && parent.$$getID() !== '') {
					if(angular.isUndefined(data[parentMetaData.name])){
						data[parentMetaData.name] = {};
					}
					var parentData = this.processParent(parent);
					this.$log.debug('parentData:'+parentMetaData.name);
					this.$log.debug(parentData);
					angular.extend(data[parentMetaData.name],parentData);
				}else{

				}
			}

		};

		return data;
	}

	public getDataFromChildren = (entityInstance)=>{
		var data = {};

		this.$log.debug('childrenFound');
		this.$log.debug(entityInstance.children);
		for(var c in entityInstance.children){
			var childMetaData = entityInstance.children[c];
			var children = entityInstance.data[childMetaData.name];
			this.$log.debug(childMetaData);
			this.$log.debug(children);
			if(angular.isArray(entityInstance.data[childMetaData.name])){
				if(angular.isUndefined(data[childMetaData.name])){
					data[childMetaData.name] = [];
				}
				angular.forEach(entityInstance.data[childMetaData.name],(child,key)=>{
					this.$log.debug('process child array item')
					var childData = this.processChild(child,entityInstance);
					this.$log.debug('process child return');
					this.$log.debug(childData);
					data[childMetaData.name].push(childData);
				});
			}else{
				if(angular.isUndefined(data[childMetaData.name])){
					data[childMetaData.name] = {};
				}
				var child = entityInstance.data[childMetaData.name];
				this.$log.debug('begin process child');
				var childData = this.processChild(child,entityInstance);
				this.$log.debug('process child return');
				this.$log.debug(childData);
				angular.extend(data,childData);
			}

		}
		this.$log.debug('returning child data');
		this.$log.debug(data);

		return data;
	}

}

export{
	HibachiValidationService
}