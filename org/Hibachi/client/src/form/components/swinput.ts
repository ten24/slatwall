/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
/**
 * This validate directive will look at the current element, figure out the context (save, edit, delete) and
 * validate based on that context as defined in the validation properties object.
 */
import {SWFormController} from "./swForm";
import {SWPropertyDisplayController} from "./swpropertydisplay";
import {SWFPropertyDisplayController} from "./swfpropertydisplay";
import {SWFormFieldController} from "./swformfield";

class SWInputController{
	public propertyDisplay:any;
	public form:ng.IFormController;
	public swForm:SWFormController;
	public swPropertyDisplay:SWPropertyDisplayController;
	public swfPropertyDisplay:SWFPropertyDisplayController;
	public swFormField:SWFormFieldController;
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

	public getValidationDirectives = ()=>{
		var spaceDelimitedList = '';
		var name = this.property;
		var form = this.form;
		this.$log.debug("Name is:" + name + " and form is: " + form);
		if(angular.isUndefined(this.object.validations )
			|| angular.isUndefined(this.object.validations.properties)
			|| angular.isUndefined(this.object.validations.properties[this.property])){
			return '';
		}
		var validations = this.object.validations.properties[this.property];
		this.$log.debug("Validations: ", validations);
		this.$log.debug(this.form);
		var validationsForContext = [];

		//get the form context and the form name.


		var formContext = this.swForm.context;
		var formName = this.swForm.name;
		this.$log.debug("Form context is: ");
		this.$log.debug(formContext);
		this.$log.debug("Form Name: ");
		this.$log.debug(formName);
		//get the validations for the current element.
		var propertyValidations = this.object.validations.properties[name];
		/*
		* Investigating why number inputs are not working.
		* */
		//check if the contexts match.
		if (angular.isObject(propertyValidations)){
			//if this is a procesobject validation then the context is implied
			if(angular.isUndefined(propertyValidations[0].contexts) && this.object.metaData.isProcessObject){
				propertyValidations[0].contexts = this.object.metaData.className.split('_')[1];
			}

			if (propertyValidations[0].contexts === formContext){
				this.$log.debug("Matched");
				for (var prop in propertyValidations[0]){
						if (prop != "contexts" && prop !== "conditions"){

							spaceDelimitedList += (" swvalidation" + prop.toLowerCase() + "='" + propertyValidations[0][prop] + "'");

						}
				}
			}
		this.$log.debug(spaceDelimitedList);
		}
		//loop over validations that are required and create the space delimited list
		this.$log.debug(validations);

		//get all validations related to the form context;
		this.$log.debug(form);

		angular.forEach(validations,(validation,key)=>{

			if(validation.contexts && this.utilityService.listFind(validation.contexts.toLowerCase(),this.swForm.context.toLowerCase()) !== -1){
				this.$log.debug("Validations for context");
				this.$log.debug(validation);
				validationsForContext.push(validation);
			}
		});

		//now that we have all related validations for the specific form context that we are working with collection the directives we need
		//getValidationDirectiveByType();


		return spaceDelimitedList;
	};

	public getTemplate = ()=>{
		var template = '';
		var validations = '';
		var currency = '';

		if(!this.class){
			this.class = "form-control";
		}

		if(!this.noValidate){
			validations = this.getValidationDirectives();
		}

		if(this.object.metaData.$$getPropertyFormatType(this.property) == "currency"){
			currency = 'sw-currency-formatter ';
			if(angular.isDefined(this.object.data.currencyCode)){
				currency = currency + 'data-currency-code="' + this.object.data.currencyCode + '" ';
			}
		}

		var appConfig = this.$hibachi.getConfig();

		var placeholder ='';
		if(this.object.metaData && this.object.metaData[this.property] && this.object.metaData[this.property].hb_nullrbkey){
			placeholder = this.rbkeyService.getRBKey(this.object.metaData[this.property].hb_nullrbkey);
		}
		var acceptedFieldTypes = ['email','text','password','number','time','date','dateTime'];
		if(acceptedFieldTypes.indexOf(this.fieldType.toLowerCase()) >= 0){
			template = '<input type="'+this.fieldType+'" class="'+this.class+'" '+
				'ng-model="swInput.object.data[swInput.property]" '+
				'ng-disabled="swInput.editable === false" '+
				'ng-show="swInput.editing" '+
				'name="'+this.property+'" ' +
				'placeholder="'+placeholder+'" '+
				validations + currency +
				'id="swinput'+this.utilityService.createID(26)+'" '+
				this.inputAttributes+
				
		}
		var dateFieldTypes = ['date','datetime','time'];
		if(dateFieldTypes.indexOf(this.fieldType.toLowerCase()) >= 0){
			template = template + 'datetime-picker ';
		}
		if(this.fieldType === 'time'){
			template = template + 'data-time-only="true" date-format="'+appConfig.timeFormat.replace('tt','a')+'" ';
		}
		if(this.fieldType === 'date'){
			template = template + 'data-date-only="true" future-only date-format="'+appConfig.dateFormat+'" ';
		}
		
		if(template.length){
			template = template + ' />';
		}


		return template;
	};

	public $onInit = ()=>{
		var bindToControllerProps = this.$injector.get('swInputDirective')[0].bindToController;
		for(var i in bindToControllerProps){
			if(!this[i]){
				if(!this[i] && this.swFormField && this.swFormField[i]){
					this[i] = this.swFormField[i];
				}else if(!this[i] && this.swPropertyDisplay && this.swPropertyDisplay[i]){
					this[i] = this.swPropertyDisplay[i];
				}else if(!this[i] && this.swfPropertyDisplay && this.swfPropertyDisplay[i]){
					this[i] = this.swfPropertyDisplay[i];
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


		this.inputAttributes = this.inputAttributes || "";

		this.inputAttributes = this.utilityService.replaceAll(this.inputAttributes,"'",'"');
	}
}

class SWInput{

	public restrict = "E";
	public require = {
		swForm:"?^swForm",
		form:"?^form",
		swFormField:"?^swFormField",
		swPropertyDisplay:"?^swPropertyDisplay",
		swfPropertyDisplay:"?^swfPropertyDisplay"
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
	public controller=SWInputController;
	public controllerAs = "swInput";
	//ngInject
	constructor(
		$compile
	){
		this.$compile = $compile;
	}
	public link:ng.IDirectiveLinkFn = (scope:any,element,attr)=>{

		//renders the template and compiles it
		element.html(scope.swInput.getTemplate());
		this.$compile(element.contents())(scope);

	}

	public static Factory(){
		var directive = (
			$compile
		)=>new SWInput(
			$compile
		);
		directive.$inject = [
			'$compile'
		];
		return directive
	}
}
export{
	SWInput
}
