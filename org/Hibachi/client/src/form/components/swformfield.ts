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
	public option;
	public valueObject;
	public object;
	public label;
	public labelText;
	public labelClass;
	public optionValues;
	public title;
	public value;
	public errorText;
	public fieldType;
	public edit:boolean;
	public selectedRadioFormName;
	public form:ng.IFormController;
	public options:any;
	public selected:any;
	public isDirty:boolean;
	public inListingDisplay:boolean; 
	public selectType:string;
	public eagerLoadOptions:boolean;
	public rawFileTarget:string;
	public binaryFileTarget:string;
	public optionsArguments:any;
	public valueOptions:any;
	public eventListeners:any;

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
			this.object.data[this.propertyIdentifier] = option.value;

			this.form[this.propertyIdentifier].$dirty = true;
			this.form['selected'+this.object.metaData.className+this.propertyIdentifier+this.selectedRadioFormName].$dirty = false;
		}else if(this.fieldType == 'checkbox'){
			this.object.data[this.propertyIdentifier] = option.value;
			this.form[this.propertyIdentifier].$dirty = true;
		}else if(this.fieldType === 'select'){
			this.$log.debug('formfieldchanged');
			this.$log.debug(option);
			if(this.selectType === 'object' && typeof this.object.data[this.propertyIdentifier].$$getIDName == "function" ){
				this.object.data[this.propertyIdentifier]['data'][this.object.data[this.propertyIdentifier].$$getIDName()] = option.value;
				if(angular.isDefined(this.form[this.object.data[this.propertyIdentifier].$$getIDName()])){
					this.form[this.object.data[this.propertyIdentifier].$$getIDName()].$dirty = true;
				}
			}else if(this.selectType === 'string' && option && option.value != null){

				this.object.data[this.propertyIdentifier] = option.value;
				this.form[this.propertyIdentifier].$dirty = true;
			}

			this.observerService.notify(this.object.metaData.className+this.propertyIdentifier.charAt(0).toUpperCase()+this.propertyIdentifier.slice(1)+'OnChange', option);
		}else{
			this.object.data[this.propertyIdentifier] = option.value;

			this.form[this.propertyIdentifier].$dirty = true;
			this.form['selected'+this.object.metaData.className+this.propertyIdentifier+this.selectedRadioFormName].$dirty = false;
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
		let tempObject = [];
		if(typeof(this.optionValues) == "string"){
			let temp = this.optionValues.split(',');
			for(let value of temp){
				tempObject.push({
					"name":value,
					"value":value
				});
			}
			this.optionValues = tempObject;
		}

		this.edit = this.edit || true;
		this.fieldType = this.fieldType || "text";

		if(this.fieldType === 'yesno'){
			this.yesnoStrategy();
		}

		if(this.fieldType === 'select'){
			this.selectStrategy();
		}

		if(this.eventListeners){
            for(var key in this.eventListeners){
                this.observerService.attach(this.eventListeners[key], key)
            }
        }
	}

	public selectStrategy = ()=>{
		//this is specific to the admin because it implies loading of options via api
        if(angular.isDefined(this.object.metaData) && angular.isDefined(this.object.metaData[this.propertyIdentifier]) && angular.isDefined(this.object.metaData[this.propertyIdentifier].fieldtype)){
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
			if(!this.optionsArguments || !this.optionsArguments.hasOwnProperty('propertyIdentifier')){
				this.optionsArguments={
					'propertyIdentifier':this.propertyIdentifier
				};
			}

			var optionsPromise = this.$hibachi.getPropertyDisplayOptions(this.object.metaData.className,
				this.optionsArguments
			);
			optionsPromise.then((value)=>{
				this.options = value.data;

				if(this.selectType === 'object'
				){

					if(angular.isUndefined(this.object.data[this.propertyIdentifier])){
						this.object.data[this.propertyIdentifier] = this.$hibachi['new'+this.object.metaData[this.propertyIdentifier].cfc]();
					}

					if(this.object.data[this.propertyIdentifier].$$getID() === ''){
						this.$log.debug('no ID');
						this.$log.debug(this.object.data[this.propertyIdentifier].$$getIDName());
						this.object.data['selected'+this.propertyIdentifier] = this.options[0];
						this.object.data[this.propertyIdentifier] = this.$hibachi['new'+this.object.metaData[this.propertyIdentifier].cfc]();
						this.object.data[this.propertyIdentifier]['data'][this.object.data[this.propertyIdentifier].$$getIDName()] = this.options[0].value;
					}else{
						var found = false;
						for(var i in this.options){
							if(angular.isObject(this.options[i].value)){
								this.$log.debug('isObject');
								this.$log.debug(this.object.data[this.propertyIdentifier].$$getIDName());
								if(this.options[i].value === this.object.data[this.propertyIdentifier]){
									this.object.data['selected'+this.propertyIdentifier] = this.options[i];
									this.object.data[this.propertyIdentifier] = this.options[i].value;
									found = true;
									break;
								}
							}else{
								this.$log.debug('notisObject');
								this.$log.debug(this.object.data[this.propertyIdentifier].$$getIDName());
								if(this.options[i].value === this.object.data[this.propertyIdentifier].$$getID()){
									this.object.data['selected'+this.propertyIdentifier] = this.options[i];
									this.object.data[this.propertyIdentifier]['data'][this.object.data[this.propertyIdentifier].$$getIDName()] = this.options[i].value;
									found = true;
									break;
								}
							}
							if(!found){
								this.object.data['selected'+this.propertyIdentifier] = this.options[0];
							}
						}

					}
				}else if(this.selectType === 'string'){
					if(this.object.data[this.propertyIdentifier] !== null){
						for(var i in this.options){
							if(this.options[i].value === this.object.data[this.propertyIdentifier]){
								this.object.data['selected'+this.propertyIdentifier] = this.options[i];
								this.object.data[this.propertyIdentifier] = this.options[i].value;
							}
						}

					}else{

						this.object.data['selected'+this.propertyIdentifier] = this.options[0];
						this.object.data[this.propertyIdentifier] = this.options[0].value;
					}

				}

			});
		}
	}

	public yesnoStrategy = ()=>{
		//format value
		this.selectedRadioFormName = this.utilityService.createID(26);
		this.object.data[this.propertyIdentifier] = (
			this.object.data[this.propertyIdentifier]
			&& this.object.data[this.propertyIdentifier].length
			&& this.object.data[this.propertyIdentifier].toLowerCase().trim() === 'yes'
		) || this.object.data[this.propertyIdentifier] == 1 ? 1 : 0;

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

		if(angular.isDefined(this.object.data[this.propertyIdentifier])){

			for(var i in this.options){
				if(this.options[i].value === this.object.data[this.propertyIdentifier]){
					this.selected = this.options[i];
					this.object.data[this.propertyIdentifier] = this.options[i].value;
				}
			}
		}else{
			this.selected = this.options[0];
			this.object.data[this.propertyIdentifier] = this.options[0].value;
		}

		this.$timeout(()=>{
			this.form[this.propertyIdentifier].$dirty = this.isDirty;
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
		propertyIdentifier: "@?", property:"@?",
		name : "@?",
		class: "@?",
		errorClass: "@?",
		fieldType: "@?", type: "@?",
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
		inListingDisplay:"=?", 
		inputAttributes:"@?",
		options:"=?",
        optionsArguments:"=?",
        eagerLoadOptions:"=?",
		rawFileTarget:"@?",
		binaryFileTarget:"@?",
        isDirty:"=?",
        onChange:"=?",
		editable:"=?",
		eventListeners:"=?",
		context:"@?",
		eventAnnouncers:"@"
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

