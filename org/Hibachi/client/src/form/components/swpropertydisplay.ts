/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
import {MetaDataService} from "../../core/services/metadataservice";

class SWPropertyDisplayController {
    private applyFilter;
    private setupFormController;
    public errors;
    public edited:boolean;
    public editing:boolean;
    public editable:boolean;//disabled
    public isHidden:boolean;
    public fieldType;
    public object;
    public property; //dominant over propertyIdentifier
    public propertyDisplayID:string;
    public title;
    public hint;
    public optionsArguments;
    public eagerLoadOptions:boolean;
    public noValidate:boolean;
    public binaryFileTarget;
    public inListingDisplay:boolean;
    public pageRecord:any;
    public pageRecordIndex:number;
    public placeholderRbKey:string;
    public placeholderText:string;
    public listingID:string;
    public rawFileTarget;
    public showLabel;
    public form;
	public saved:boolean=false;
    public onChangeEvent:string;
    public swInputOnChangeEvent:string;
    public hasOnChangeCallback:boolean;
    public onChangeCallback;
    public hasSaveCallback:boolean;
    public saveCallback;
    public initialValue:any;
    public inModal:boolean;
    public hasModalCallback:boolean;
    public rowSaveEnabled:boolean;
    public revertToValue:any;
    public revertText:string;
    public reverted:boolean;
    public modalCallback;
    public showRevert:boolean;
    public showSave:boolean;

    //swfproperty display properties
	public class;
    public hideErrors;
	public fieldAttributes;
	public valueObject;
	public label;
	public name;
    public errorName;
	public options;
	public valueObjectProperty;
    public valueOptions;
	public processObject;
	public optionValues:any;
	public propertyDisplay;
    public edit:boolean;
	public value;
	public submit;
	public labelText;
	public labelClass;
	public errorText;
	public errorClass;
	public propertyIdentifier; //dominant
	public loader;

    public swForm;
    public selected;

    //@ngInject
    constructor(
        public $filter,
        public utilityService,
        public $injector,
        public metadataService:MetaDataService,
        public observerService,
        public listingService?
    ){

	}

    public $onInit=()=>{
        var bindToControllerProps = this.$injector.get('swPropertyDisplayDirective')[0].bindToController;
        for(var i in bindToControllerProps){

			if(!this[i] && this.swForm && this.swForm[i]){
				this[i] = this.swForm[i];
			}
		}
        this.errors = {};
        this.edited = false;
        this.edit = this.edit || this.editing;
        this.editing = this.editing || this.edit;

        this.errorName = this.errorName || this.name;
        this.initialValue = this.object[this.property];
        this.propertyDisplayID = this.utilityService.createID(32);
        if(angular.isUndefined(this.showSave)){
            this.showSave = true;
        }
        if(angular.isUndefined(this.inListingDisplay)){
            this.inListingDisplay = false;
        }
        if(angular.isUndefined(this.rowSaveEnabled)){
            this.rowSaveEnabled = this.inListingDisplay;
        }
        if(angular.isDefined(this.revertToValue) && angular.isUndefined(this.showRevert)){
            this.showRevert = true;
        }
        if(angular.isDefined(this.revertToValue) && angular.isUndefined(this.revertText)){
            this.revertText = this.revertToValue;
        }
        if(angular.isUndefined(this.showRevert)){
            this.showRevert = false;
        }
        if(angular.isUndefined(this.rawFileTarget)){
            this.rawFileTarget = this.property;
        }
        if(angular.isUndefined(this.editing)){
            this.editing = false;
        }
        if(angular.isUndefined(this.editable)){
            this.editable = true;
        }
        if(angular.isUndefined(this.isHidden)){
            this.isHidden = false;
        }

        if(angular.isUndefined(this.noValidate)){
            this.noValidate = false;
        }
        if(angular.isUndefined(this.inModal)){
            this.inModal = false;
        }
        if(angular.isUndefined(this.optionsArguments)){
            this.optionsArguments = {};
        }
        if( (this.fieldType !== 'hidden' &&
            angular.isUndefined(this.inListingDisplay)) ||
            (angular.isDefined(this.inListingDisplay) && !this.inListingDisplay)
        ){
            this.showLabel = true;
        } else {
            this.showLabel = false;
        }
        if(angular.isDefined(this.pageRecord) && angular.isUndefined(this.pageRecord.edited)){
            this.pageRecord.edited = false;
        }

        this.applyFilter = (model, filter)=> {
            try{
                return this.$filter(filter)(model)
            }catch (e){
                return model;
            }
        };
        //swfproperty logic
        if(angular.isUndefined(this.fieldType) && this.object && this.object.metaData){
            this.fieldType = this.metadataService.getPropertyFieldType(this.object,this.propertyIdentifier);
        }

		if(angular.isUndefined(this.title) && this.object && this.object.metaData){

            this.labelText = this.metadataService.getPropertyTitle(this.object,this.propertyIdentifier);

        }

        this.labelText = this.labelText || this.title;
        this.title = this.title || this.labelText;

		this.fieldType                	= this.fieldType || "text" ;
		this.class			   	= this.class|| "form-control";
		this.fieldAttributes     	= this.fieldAttributes || "";
		this.label			    = this.label || "true";
		this.labelText			= this.labelText || "";
		this.labelClass			= this.labelClass || "";
		this.name			    	= this.name || "unnamed";
        this.value              = this.value || this.initialValue;


		this.object				= this.object || this.swForm.object; //this is the process object

		/** handle options */
		if (this.options && angular.isString(this.options)){
			let optionsArray = [];
			optionsArray = this.options.toString().split(",");

			angular.forEach(optionsArray, (o)=>{
				let newOption:any = {
					name:"",
					value:""
				};

                newOption.name = o;
				newOption.value= o;

				this.optionValues.push(newOption);
			});
		}

        /** handle turning the options into an array of objects */
		/** handle setting the default value for the yes / no element  */
		if (this.fieldType=="yesno" && (this.value && angular.isString(this.value))){
			this.selected == this.value;
		}

		if(angular.isUndefined(this.hint) && this.object && this.object.metaData){
            this.hint = this.metadataService.getPropertyHintByObjectAndPropertyIdentifier(this.object,this.propertyIdentifier);
        }

        if( (this.hasOnChangeCallback || this.inListingDisplay || this.onChangeEvent) &&
            (angular.isDefined(this.swForm) && angular.isDefined(this.name))
        ){
            this.swInputOnChangeEvent = this.swForm.name + this.name + 'change';
            this.observerService.attach(this.onChange, this.swInputOnChangeEvent);
        }

	}

    public onChange = (result?) =>{
        this.edited = true;
        if(this.saved){
            this.saved = false;
        }
        if(this.hasOnChangeCallback){
            this.onChangeCallback(result);
        }
        if(this.inListingDisplay && this.rowSaveEnabled){
            this.listingService.markEdited( this.listingID,
                                            this.pageRecordIndex,
                                            this.propertyDisplayID,
                                            this.save
                                          );
		}

        if(angular.isDefined(this.onChangeEvent)){
            this.observerService.notify(this.onChangeEvent,result);
        }
	}

    public clear = () =>{
        if(this.reverted){
            this.reverted = false;
            this.showRevert = true;
        }
        this.edited = false;
        this.object.data[this.property] = this.initialValue;
        if(this.inListingDisplay && this.rowSaveEnabled){
            this.listingService.markUnedited( this.listingID,
                                              this.pageRecordIndex,
                                              this.propertyDisplayID
                                            );
        }
    }

    public revert = () =>{
        this.showRevert = false;
        this.reverted = true;
        this.object.data[this.property] = this.revertToValue;
        this.onChange();
    }

    public save = () =>{
        this.observerService.notify('updateBindings');
        //do this eagerly to hide save will reverse if theres an error
        this.edited = false;
        this.saved = true;
        if(!this.inModal){
            this.object.$$save().then(
                (response)=>{
                    if(this.hasSaveCallback){
                        this.saveCallback(response);
                    }
                },
                (reason)=>{
                    this.edited = true;
                    this.saved = false;
                }
            );
        } else if (this.hasModalCallback) {
            this.modalCallback();
        }
    }


}

class SWPropertyDisplay implements ng.IDirective{

    public static $inject = ['coreFormPartialsPath', 'hibachiPathBuilder'];
    public templateUrl:string;
    public require = {swForm:"?^swForm",form:"?^form"};
    public restrict = 'AE';
    public scope = {};

    public bindToController = {

        //swfproperty scope

        name: "@?",
        errorName: "@?",
        class: "@?",
        edit: "@?",
        valueObject: "=?",
        valueObjectProperty: "=?",
        propertyIdentifier: "@?",
        valueOptions: "=?",
        fieldAttributes: "@?",
        label:"@?",
        labelText: "@?",
        labelClass: "@?",
        errorText: "@?",
        errorClass: "@?",
        formTemplate: "@?",
        eventAnnouncers:"@",
        hideErrors:'=?',
        value:"@?",

        //swpropertyscope

        property:"@?",
        object:"=?",
        editable:"=?",
        editing:"=?",
        isHidden:"=?",
        title:"=?",
        hint:"@?",
        options:"=?",
        optionsArguments:"=?",
        eagerLoadOptions:"=?",
        isDirty:"=?",
        onChangeCallback:"&?onChange",
        onChangeEvent:"@?",
        saveCallback:"&?",
        fieldType:"@?",
        rawFileTarget:"@?",
        binaryFileTarget:"@?",
        noValidate:"=?",
        inListingDisplay:"=?",
        inModal:"=?",
        modalCallback:"&?",
        hasModalCallback:"=?",
        rowSaveEnabled:"=?",
        revertToValue:"=?",
        revertText:"@?",
        showRevert:"=?",
        showSave:"=?",
        placeholderText:"@",
        placeholderRbKey:"@",
        inputAttributes:"@?",
        optionValues:"=?",
        eventListeners:"=?",
        context:"@?"
    };
    public controller=SWPropertyDisplayController;
    public controllerAs="swPropertyDisplay";

    public templateUrlPath = "propertydisplay.html";

	//@ngInject
    constructor(
        public $compile,
		public scopeService,
        public coreFormPartialsPath,
        public hibachiPathBuilder,
        public swpropertyPartialPath

    ){
        this.templateUrl = this.hibachiPathBuilder.buildPartialsPath(this.coreFormPartialsPath) + swpropertyPartialPath;
    }

    public static Factory(swpropertyClass,swpropertyPartialPath?:string){

        var directive = (
            $compile,
            scopeService,
            coreFormPartialsPath,
            hibachiPathBuilder
        )=>new swpropertyClass(
            $compile,
			scopeService,
			coreFormPartialsPath,
            hibachiPathBuilder,
            //not an inejctable don't add to $inject. This is in the form.module Factory implementation
            swpropertyPartialPath
        );
        directive.$inject = ['$compile','scopeService','coreFormPartialsPath','hibachiPathBuilder'];

        return directive;
    }


    public link:ng.IDirectiveLinkFn = ($scope:any, element: ng.IAugmentedJQuery, attrs:any, formController: any) =>{

        $scope.frmController = formController;
        $scope.swfPropertyDisplay = $scope.swPropertyDisplay;

        if(angular.isDefined(attrs.onChange)){
            $scope.swPropertyDisplay.hasOnChangeCallback = true;
        } else {
            $scope.swPropertyDisplay.hasOnChangeCallback = false;
        }

        if(angular.isDefined(attrs.saveCallback)){
            $scope.swPropertyDisplay.hasSaveCallback = true;
        } else {
            $scope.swPropertyDisplay.hasSaveCallback = false;
        }

        if(angular.isDefined($scope.swPropertyDisplay.inListingDisplay) && $scope.swPropertyDisplay.inListingDisplay){

            var currentScope = this.scopeService.getRootParentScope($scope, "pageRecord");
            if(angular.isDefined(currentScope["pageRecord"])){
                $scope.swPropertyDisplay.pageRecord = currentScope["pageRecord"];
            }

            var currentScope = this.scopeService.getRootParentScope($scope, "pageRecordKey");
            if(angular.isDefined(currentScope["pageRecordKey"])){
                $scope.swPropertyDisplay.pageRecordIndex = currentScope["pageRecordKey"];
            }

            var currentScope = this.scopeService.getRootParentScope($scope, "swListingDisplay");
            if(angular.isDefined(currentScope["swListingDisplay"])){
                $scope.swPropertyDisplay.listingID = currentScope["swListingDisplay"].tableID;
            }
        }

        if(angular.isDefined($scope.swPropertyDisplay.inModal) && $scope.swPropertyDisplay.inModal){

            var modalScope = this.scopeService.getRootParentScope($scope, "swModalLauncher");
            $scope.swPropertyDisplay.modalName = modalScope.swModalLauncher.modalName;

            if(angular.isFunction(modalScope.swModalLauncher.launchModal)){
                 $scope.swPropertyDisplay.modalCallback = modalScope.swModalLauncher.launchModal;
                 $scope.swPropertyDisplay.hasModalCallback = true;
            }
        }
    };
}
export{
    SWPropertyDisplay,
    SWPropertyDisplayController
}