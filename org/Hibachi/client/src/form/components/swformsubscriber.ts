/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
/**
 * This validate directive will look at the current element, figure out the context (save, edit, delete) and
 * validate based on that context as defined in the validation properties object.
 */
import {SWFormController} from "./swform";

class SWFormSubscriberController{
	public propertyDisplay:any;
	public form:ng.IFormController;
	public swForm:SWFormController;
	public class:string;
	public fieldType:string;
	public property:string;
	public object:any;
	public inputAttributes:string;
	public noValidate:boolean;
	public propertyIdentifier:string;
	public type:string;
	public edit:boolean;
	public editing:boolean;

	//@ngInject
	constructor(
		public $log,
		public $compile,
        public $hibachi,
		public utilityService,
        public rbkeyService,
		public $injector
	){
		this.utilityService = utilityService;
		this.$hibachi = $hibachi;
		this.rbkeyService = rbkeyService;
		this.$log = $log;
		this.$injector = $injector;
	}

	public $onInit = ()=>{
		var bindToControllerProps = this.$injector.get('swFormSubscriberDirective')[0].bindToController;
		for(var i in bindToControllerProps){
			if(!this[i]){
				if(!this[i] && this.swForm && this.swForm[i]){
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


		this.inputAttributes = this.inputAttributes || "";
	}
}

class SWFormSubscriber{

	public restrict = "A";
	public require = {
		swForm:"?^swForm",
		form:"?^form"
	};
	public $compile:ng.ICompileService;
	public scope={};
	public propertyDisplay;

	public bindToController = {
		propertyIdentifier: "@?",
		name : "@?",
		class: "@?",
		errorClass: "@?",
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
		type:"@?",
		editing:"=?"
	}
	public controller=SWFormSubscriberController;
	public controllerAs = "SWFormSubscriber";
	//ngInject
	constructor(

	){

	}
	public link:ng.IDirectiveLinkFn = (scope:any,element,attr)=>{

	}

	public static Factory(){
		var directive = (
		)=>new SWFormSubscriber(
		);
		directive.$inject = [
		];
		return directive
	}
}
export{
	SWFormSubscriber
}
