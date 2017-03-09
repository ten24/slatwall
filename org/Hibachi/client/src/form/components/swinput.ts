/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
/**
 * This validate directive will look at the current element, figure out the context (save, edit, delete) and
 * validate based on that context as defined in the validation properties object.
 */
import {SWFormController} from "./swform";
import {SWPropertyDisplayController} from "./swpropertydisplay";
import {SWFPropertyDisplayController} from "./swfpropertydisplay";
import {SWFormFieldController} from "./swformfield";
import {ObserverService} from "../../core/services/observerService";
import {MetaDataService} from "../../core/services/metadataService";
//defines possible eventoptions
type EventHandler = "blur" |
	"change" |
	"click" |
	"copy" |
	"cut" |
	"dblclick" |
	"focus" |
	"keydown" |
	"keypress" |
	"keyup" |
	"mousedown" |
	"mouseenter" |
	"mouseleave" |
	"mousemove" |
	"mouseover" |
	"mouseup" |
	"paste";
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
	public name:string;
	public value:any;
	public context:string;
	public eventNameForObjectSuccess:string;

	public eventHandlers:string="";
	public eventHandlersArray:Array<EventHandler>;
	public eventHandlerTemplate:string;

	//@ngInject
	constructor(
		public $timeout,
        public $scope,
		public $log,
		public $compile,
        public $hibachi,
		public $injector,
		public utilityService,
        public rbkeyService,
		public observerService:ObserverService,
		public metadataService:MetaDataService
	){
		this.$timeout = $timeout;
        this.$scope = $scope;
		this.utilityService = utilityService;
		this.$hibachi = $hibachi;
		this.rbkeyService = rbkeyService;
		this.$log = $log;
		this.$injector = $injector;
		this.observerService = observerService;
		this.metadataService = metadataService;
        
        
	}

	public onSuccess = ()=>{
		this.utilityService.setPropertyValue(this.swForm.object,this.property,this.value);
		if(this.swPropertyDisplay){
			this.utilityService.setPropertyValue(this.swPropertyDisplay.object,this.property,this.value);
		}
		if(this.swfPropertyDisplay){
			this.utilityService.setPropertyValue(this.swfPropertyDisplay.object,this.property,this.value);
			this.swfPropertyDisplay.editing = false;
		}
		this.utilityService.setPropertyValue(this.swFormField.object,this.property,this.value);
	}

	public getValidationDirectives = ()=>{
		var spaceDelimitedList = '';
		var name = this.property;
		var form = this.form;
		this.$log.debug("Name is:" + name + " and form is: " + form);

		if(this.metadataService.isAttributePropertyByEntityAndPropertyIdentifier(this.object,this.propertyIdentifier)){
			this.object.validations.properties[name] = [];
			if(this.object.metaData[this.property].requiredFlag && this.object.metaData[this.property].requiredFlag.trim().toLowerCase()=="yes"){
				this.object.validations.properties[name].push({
					contexts:"save",
					required:true
				});
			}
			if(this.object.metaData[this.property].validationRegex){
				this.object.validations.properties[name].push({
					contexts:"save",regex:this.object.metaData[this.property].validationRegex
				});
			}
		}

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

		return spaceDelimitedList;
	};

	public onEvent = (event:Event,eventName:string):void=>{
		let customEventName = this.swForm.name+this.name+eventName;
		let data = {
			event:event,
			eventName:eventName,
			form:this.form,
			swForm:this.swForm,
			swInput:this,
			inputElement:$('input').first()[0]
		};
		this.observerService.notify(customEventName,data);
	}

	public getTemplate = ()=>{
		var template = '';
		var validations = '';
		var currency = '';
		var style = "";

		if(!this.class){
			this.class = "form-control";
		}

		if(!this.noValidate){
			validations = this.getValidationDirectives();
		}

		if(this.object.metaData && this.object.metaData.$$getPropertyFormatType(this.property) == "currency"){
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

		if(this.fieldType.toLowerCase() === 'json'){
			style = style += 'display:none';
		}
        
		var acceptedFieldTypes = ['email','text','password','number','time','date','datetime','json'];
        
		if(acceptedFieldTypes.indexOf(this.fieldType.toLowerCase()) >= 0){
            var inputType = this.fieldType.toLowerCase();
            if(this.fieldType === 'time'){
                inputType="text";
            }
			template = '<input type="'+inputType+'" class="'+this.class+'" '+
				' ng-model="swInput.value" '+
				' ng-disabled="swInput.editable === false" '+
				' ng-show="swInput.editing" '+
				' name="'+this.property+'" ' +
				' placeholder="'+placeholder+'" '+
				validations + currency +
				' id="swinput'+this.swForm.name+this.name+'" '+
				' style="' + style + '" ' + " " +
	            this.inputAttributes + " " +
				this.eventHandlerTemplate;
		}

		var dateFieldTypes = ['date','datetime','time'];
		if(dateFieldTypes.indexOf(this.fieldType.toLowerCase()) >= 0){
			template = template + 'datetime-picker ';
		}
		if(this.fieldType === 'time'){
			template = template + 'data-time-only="true" date-format="'+appConfig.timeFormat.replace('tt','a')+'" ng-blur="swInput.pushBindings()"';
		}
		if(this.fieldType === 'date'){
			template = template + 'data-date-only="true" future-only date-format="'+appConfig.dateFormat+'" ';
		}

		if(template.length){
			template = template + ' />';
		}


		return template;
	};
    
    public pullBindings = ()=>{
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
        this.value = this.utilityService.getPropertyValue(this.object,this.property);
    }
    
    public pushBindings = ()=>{
        this.observerService.notify('updateBindings').then(()=>{});    
    }

	public $onInit = ()=>{
        
        this.pullBindings();

		this.eventHandlersArray = <Array<EventHandler>>this.eventHandlers.split(',');

		this.eventHandlerTemplate = "";
		for(var i in this.eventHandlersArray){
			var eventName = this.eventHandlersArray[i];
            if(eventName.length){
                this.eventHandlerTemplate += ` ng-`+eventName+`="swInput.onEvent($event,'`+eventName+`')"`;
            }
		}

		if (angular.isDefined(this.object.metaData) && angular.isDefined(this.object.metaData.className)){
 			this.eventNameForObjectSuccess = this.object.metaData.className.split('_')[0]+this.context.charAt(0).toUpperCase()+this.context.slice(1)+'Success';
 		}else{
 			this.eventNameForObjectSuccess = this.context.charAt(0).toUpperCase()+this.context.slice(1)+'Success';
 		}
 		var eventNameForObjectSuccessID = this.eventNameForObjectSuccess+this.property;

		var eventNameForUpdateBindings = 'updateBindings';
		if (angular.isDefined(this.object.metaData) && angular.isDefined(this.object.metaData.className)){
 			var eventNameForUpdateBindingsID = this.object.metaData.className.split('_')[0]+this.property+'updateBindings';
 		}else{
 			var eventNameForUpdateBindingsID = this.property+'updateBindings';
 		}
        var eventNameForPullBindings = 'pullBindings';
        if (angular.isDefined(this.object.metaData) && angular.isDefined(this.object.metaData.className)){
         	var eventNameForPullBindingsID = this.object.metaData.className.split('_')[0]+this.property+'pullBindings';
 		}else{
 			var eventNameForPullBindingsID = this.property+'pullBindings'
 		}
		//attach a successObserver
		if(this.object){
			//update bindings on save success
			this.observerService.attach(this.onSuccess,this.eventNameForObjectSuccess,eventNameForObjectSuccessID);

			//update bindings manually
			this.observerService.attach(this.onSuccess,eventNameForUpdateBindings,eventNameForUpdateBindingsID);
            
            //pull bindings from higher binding level manually
            this.observerService.attach(this.pullBindings,eventNameForPullBindings,eventNameForPullBindingsID);

		}

		this.$scope.$on("$destroy",()=>{
			this.observerService.detachById(eventNameForUpdateBindings);
			this.observerService.detachById(eventNameForUpdateBindingsID )
		})
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
		editing:"=?",
		eventHandlers:"@?",
		context:"@?"
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
