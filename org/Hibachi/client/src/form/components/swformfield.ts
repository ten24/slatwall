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


	//@ngInject
	constructor(
		public $injector
	){
		this.$injector = $injector;
	}

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
		inputAttributes:"@?"
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


		// if(scope.swFormField.swPropertyDisplay){
		// 	scope.swFormField.propertyDisplay = scope.swFormField.swPropertyDisplay;
		// }else if(scope.swFormField.swfPropertyDisplay){
		// 	scope.swFormField = scope.swFormField.swfPropertyDisplay;
		// }

		// if(angular.isUndefined(scope.propertyDisplay.object.$$getID) || scope.propertyDisplay.object.$$getID() === ''){
		// 	scope.propertyDisplay.isDirty = true;
		// }

		// if(angular.isDefined(scope.swFormField.form[scope.propertyDisplay.property])){
		// 	scope.propertyDisplay.errors = scope.swFormField.form[scope.propertyDisplay.property].$error;
		// 	scope.swFormField.form[scope.propertyDisplay.property].formType = scope.propertyDisplay.fieldType;
		// }
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
//	angular.module('slatwalladmin').directive('swFormField',['$log','$templateCache', '$window', '$hibachi', 'formService', 'coreFormPartialsPath',($log, $templateCache, $window, $hibachi, formService, coreFormPartialsPath) => new swFormField($log, $templateCache, $window, $hibachi, formService, coreFormPartialsPath)]);

