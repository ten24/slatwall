/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

import {SWPropertyDisplayController} from "./swpropertydisplay";
import {SWFPropertyDisplayController} from "./swfpropertydisplay";
import {SWFormController} from "./swform";
class SWFormFieldController {
	public swPropertyDisplay:SWPropertyDisplayController;
	public swfPropertyDisplay:SWFPropertyDisplayController;
	public swForm:SWFormController;
	public inputAttributes:string;

	public propertyIdentifier;
	public name;
	public class;
	public errorClass;
	public type;
	public option;
	public valueObject;
	public object;
	public label;
	public labelText;
	public labelClass;
	public optionValues;
	public edit;
	public title;
	public value;
	public errorText;
	public fieldType;
	public property;
	public editing:boolean;
	public selectedRadioFormName;
	public form:ng.IFormController;
	public options:any;
	public selected:any;
	public isDirty:boolean;
	public selectType:string;
	public eagerLoadOptions:boolean;
	public optionsArguments:any;
	public valueOptions:any;

	//@ngInject
	constructor(
		public $injector,
		public $scope,
		public $timeout,
		public $log,
		public $hibachi,
		public observerService,
		public utilityService
	){
		this.$injector = $injector;
		this.$scope= $scope;
		this.$timeout = $timeout;
		this.$log = $log;
		this.$hibachi = $hibachi;
		this.observerService = observerService;
		this.utilityService = utilityService;
	}

	public formFieldChanged = (option)=>{
        
		if(this.fieldType === 'yesno'){
			this.object.data[this.property] = option.value;

			this.form[this.property].$dirty = true;
			this.form['selected'+this.object.metaData.className+this.property+this.selectedRadioFormName].$dirty = false;
		}else if(this.fieldType === 'select'){
			this.$log.debug('formfieldchanged');
			this.$log.debug(option);
			if(this.selectType === 'object' && typeof this.object.data[this.property].$$getIDName == "function" ){
				this.object.data[this.property]['data'][this.object.data[this.property].$$getIDName()] = option.value;
				if(angular.isDefined(this.form[this.object.data[this.property].$$getIDName()])){
					this.form[this.object.data[this.property].$$getIDName()].$dirty = true;
				}
			}else if(this.selectType === 'string' && option && option.value != null){

				this.object.data[this.property] = option.value;
				this.form[this.property].$dirty = true;
			}

			this.observerService.notify(this.object.metaData.className+this.property.charAt(0).toUpperCase()+this.property.slice(1)+'OnChange', option);
		}else{
			this.object.data[this.property] = option.value;

			this.form[this.property].$dirty = true;
			this.form['selected'+this.object.metaData.className+this.property+this.selectedRadioFormName].$dirty = false;
		}

	};

	public $onInit = ()=>{
		var bindToControllerProps = this.$injector.get('swFormFieldDirective')[0].bindToController;
		for(var i in bindToControllerProps){
			if(!this[i]){
				if(!this[i] && this.swPropertyDisplay && this.swPropertyDisplay[i]){
					this[i] = this.swPropertyDisplay[i]
				}else if(!this[i] && this.swfPropertyDisplay && this.swfPropertyDisplay[i]){
					this[i] = this.swfPropertyDisplay[i]
				}else if(!this[i] && this.swForm && this.swForm[i]){
					this[i] = this.swForm[i];
				}
			}
		}

		this.property = this.property || this.propertyIdentifier;
        this.propertyIdentifier = this.propertyIdentifier || this.property;

        this.type = this.type || this.fieldType;
        this.fieldType = this.fieldType || this.type;

        this.edit = this.edit || this.editing;
        this.editing = this.editing || this.edit;

		this.editing = this.editing || true;
		this.fieldType = this.fieldType || "text";



		if(this.fieldType === 'yesno'){
			this.yesnoStrategy();
		}

		if(this.fieldType === 'select'){

			this.selectStrategy();
		}

	}

	public selectStrategy = ()=>{
		//this is specific to the admin because it implies loading of options via api

        if(angular.isDefined(this.object.metaData[this.property].fieldtype)){
            this.selectType = 'object';
            this.$log.debug('selectType:object');
        }else{
            this.selectType = 'string';
            this.$log.debug('selectType:string');
        }
		this.getOptions();
	}

	public getOptions = ()=>{


		if(angular.isUndefined(this.options)){
			if(!this.optionsArguments || !this.optionsArguments.hasOwnProperty('property')){
				this.optionsArguments={
					'property':this.propertyIdentifier || this.property
				};
			}

			var optionsPromise = this.$hibachi.getPropertyDisplayOptions(this.object.metaData.className,
				this.optionsArguments
			);
			optionsPromise.then((value)=>{
				this.options = value.data;

				if(this.selectType === 'object'
				){

					if(angular.isUndefined(this.object.data[this.property])){
						this.object.data[this.property] = this.$hibachi['new'+this.object.metaData[this.property].cfc]();
					}

					if(this.object.data[this.property].$$getID() === ''){
						this.$log.debug('no ID');
						this.$log.debug(this.object.data[this.property].$$getIDName());
						this.object.data['selected'+this.property] = this.options[0];
						this.object.data[this.property] = this.$hibachi['new'+this.object.metaData[this.property].cfc]();
						this.object.data[this.property]['data'][this.object.data[this.property].$$getIDName()] = this.options[0].value;
					}else{
						var found = false;
						for(var i in this.options){
							if(angular.isObject(this.options[i].value)){
								this.$log.debug('isObject');
								this.$log.debug(this.object.data[this.property].$$getIDName());
								if(this.options[i].value === this.object.data[this.property]){
									this.object.data['selected'+this.property] = this.options[i];
									this.object.data[this.property] = this.options[i].value;
									found = true;
									break;
								}
							}else{
								this.$log.debug('notisObject');
								this.$log.debug(this.object.data[this.property].$$getIDName());
								if(this.options[i].value === this.object.data[this.property].$$getID()){
									this.object.data['selected'+this.property] = this.options[i];
									this.object.data[this.property]['data'][this.object.data[this.property].$$getIDName()] = this.options[i].value;
									found = true;
									break;
								}
							}
							if(!found){
								this.object.data['selected'+this.property] = this.options[0];
							}
						}

					}
				}else if(this.selectType === 'string'){

					if(this.object.data[this.property] !== null){
						for(var i in this.options){
							if(this.options[i].value === this.object.data[this.property]){
								this.object.data['selected'+this.property] = this.options[i];
								this.object.data[this.property] = this.options[i].value;
							}
						}

					}else{

						this.object.data['selected'+this.property] = this.options[0];
						this.object.data[this.property] = this.options[0].value;
					}

				}

			});
		}
	}

	public yesnoStrategy = ()=>{
		//format value
		this.selectedRadioFormName = this.utilityService.createID(26);
		this.object.data[this.property] = (
			this.object.data[this.property]
			&& this.object.data[this.property].length
			&& this.object.data[this.property].toLowerCase().trim() === 'yes'
		) || this.object.data[this.property] == 1 ? 1 : 0;

		this.options = [
			{
				name:'Yes',
				value:1
			},
			{
				name:'No',
				value:0
			}
		];

		if(angular.isDefined(this.object.data[this.property])){

			for(var i in this.options){
				if(this.options[i].value === this.object.data[this.property]){
					this.selected = this.options[i];
					this.object.data[this.property] = this.options[i].value;
				}
			}
		}else{
			this.selected = this.options[0];
			this.object.data[this.property] = this.options[0].value;
		}

		this.$timeout(()=>{
			this.form[this.property].$dirty = this.isDirty;
		});
	}
}

class SWFormField{

	public restrict = "EA";
	public require = {
		swfPropertyDisplay:"^?swfPropertyDisplay",
		swPropertyDisplay:"^?swPropertyDisplay",
		form:"^?form",
		swForm:'^?swForm'
	};
	public controller = SWFormFieldController;
	public templateUrl;
	public controllerAs = "swFormField";
	public scope = {};
	public bindToController = {
		propertyIdentifier: "@?",
		name : "@?",
		class: "@?",
		errorClass: "@?",
		type: "@?",
		option: "=?",
		valueObject: "=?",
		object: "=?",
		label: 	"@?",
		labelText: "@?",
		labelClass: "@?",
		optionValues: "=?",
		edit: 	"=?",
		title: 	"@?",
		value: 	"=?",
		errorText: "@?",
		fieldType: "@?",
		property:"@?",
		inputAttributes:"@?",
		options:"=?",
        optionsArguments:"=?",
        eagerLoadOptions:"=?",
        isDirty:"=?",
        onChange:"=?",
		editable:"=?",
		eventHandlers:"@?",
		context:"@?"
	};

	//@ngInject
	constructor(
		 $log,
		 $templateCache,
		 $window,
		 $hibachi,
		 formService,
		 coreFormPartialsPath,
		 hibachiPathBuilder
	){
		this.templateUrl = hibachiPathBuilder.buildPartialsPath(coreFormPartialsPath)+'formfield.html';

	}

	public link= (scope, element: ng.IAugmentedJQuery, attrs: ng.IAttributes) =>{


	}

	public static Factory(){
		var directive = (
			$log,
			$templateCache,
			$window,
			$hibachi,
			formService,
			coreFormPartialsPath,
			hibachiPathBuilder
		)=>new SWFormField(
			$log,
			$templateCache,
			$window,
			$hibachi,
			formService,
			coreFormPartialsPath,
			hibachiPathBuilder
		);
		directive.$inject = [
			'$log',
			'$templateCache',
			'$window',
			'$hibachi',
			'formService',
			'coreFormPartialsPath',
			'hibachiPathBuilder'
		];
		return directive;
	}
}
export{
	SWFormField,
	SWFormFieldController
}


