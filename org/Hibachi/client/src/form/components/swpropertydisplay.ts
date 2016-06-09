/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWPropertyDisplayController {
    private applyFilter;
    private setupFormController;
    public errors;
    public edited:boolean; 
    public editing:boolean;
    public editable:boolean;
    public isHidden:boolean;
    public fieldType;
    public object;
    public property;
    public title;
    public hint;
    public optionsArguments;
    public eagerLoadOptions:boolean;
    public noValidate:boolean;
    public binaryFileTarget; 
    public inListingDisplay:boolean; 
    public rawFileTarget; 
    public showLabel; 
    public form;
    public saved:boolean; 
    public onChangeCallback; 
    public hasOnChangeCallback:boolean; 
    public hasSaveCallback:boolean; 
    public initialValue:any; 
    public inModal:boolean; 
    public modalCallback;
    public hasModalCallback:boolean; 
    

    //@ngInject
    constructor(
        public $filter
    ){
        this.errors = {};
        this.edited = false; 
        this.initialValue = this.object.data[this.property]; 
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
        if(angular.isUndefined(this.eagerLoadOptions)){
            this.eagerLoadOptions = true;
        }
        if(angular.isUndefined(this.noValidate)){
            this.noValidate = false;
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

        this.applyFilter = function(model, filter) {
            try{
                return $filter(filter)(model)
            }catch (e){
                return model;
            }
        };
    }

    public $onInit=()=>{
        if(!angular.isDefined(this.object)){
            this.object = this.form.$$swFormInfo.object;
        }
        if(angular.isUndefined(this.object) || angular.isUndefined(this.object.metaData)){
            throw("swPropertyDisplayController for property: " + this.property + " must be passed an object which is a jsentities instance");
        }
        
        if(angular.isUndefined(this.fieldType)){
            this.fieldType = this.object.metaData.$$getPropertyFieldType(this.property);
        }

        if(angular.isUndefined(this.hint)){
            this.hint = this.object.metaData.$$getPropertyHint(this.property);
        }

        if(angular.isUndefined(this.title)){
            this.title = this.object.metaData.$$getPropertyTitle(this.property);
        }
    };


    public getNgClassObjectForInput = () => {
        return "{'form-control':propertyDisplay.inListingDisplay}";
    }

    //these could maybe be handled by a service
    public onChange = () =>{
        this.edited = true; 
        if(this.hasOnChangeCallback){
            this.onChangeCallback();
        } 
    }

    public clear = () =>{
        this.edited = false; 
        this.object.data[this.property] = this.initialValue; 
    }

    public save = () =>{
        if(!this.inModal){
            this.object.$$save().then((response)=>{
                this.edited = false;           
                this.saved = true; 
            });  
        } else if (this.hasModalCallback) { 
            this.modalCallback(); 
        }
    }
}

class SWPropertyDisplay implements ng.IDirective{
    public templateUrl;
    public require = {form:'^form'};
    public restrict = 'AE';
    public scope = {};

    public bindToController = {
        property:"@",
        object:"=?",
        options:"=?",
        editable:"=?",
        editing:"=?",
        isHidden:"=?",
        title:"=?",
        hint:"@?",
        optionsArguments:"=?",
        eagerLoadOptions:"=?",
        isDirty:"=?",
        onChangeCallback:"&?onChange",
        saveCallback:"&?", 
        fieldType:"@?",
        rawFileTarget:"@?",
        binaryFileTarget:"@?",
        noValidate:"=?",
        inListingDisplay:"=?",
        inModal:"=",
        modalCallback:"&?",
        hasModalCallback:"=?"
    };
    public controller=SWPropertyDisplayController;
    public controllerAs="swPropertyDisplay";

    public static Factory(){
        var directive = (
            $compile, 
            scopeService, 
            coreFormPartialsPath,
            hibachiPathBuilder
        )=>new SWPropertyDisplay(
            $compile, 
            scopeService, 
            coreFormPartialsPath,
            hibachiPathBuilder
        );
        directive.$inject = ['$compile','scopeService','coreFormPartialsPath', 'hibachiPathBuilder'];

        return directive;
    }

    constructor(
        public $compile, 
        public scopeService,
        public coreFormPartialsPath,
        public hibachiPathBuilder
    ){
        this.templateUrl = this.hibachiPathBuilder.buildPartialsPath(this.coreFormPartialsPath) + "propertydisplay.html";
    }
    
    
    public link:ng.IDirectiveLinkFn = ($scope, element: ng.IAugmentedJQuery, attrs, formController: any) =>{
        
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

        if(angular.isDefined($scope.swPropertyDisplay.inModal) && $scope.swPropertyDisplay.inModal){
            
            var modalScope = this.scopeService.locateParentScope($scope, "swModalLauncher");
            $scope.swPropertyDisplay.modalName = modalScope.swModalLauncher.modalName; 
            
            if(typeof modalScope.swModalLauncher.launchModal == "function"){
                 $scope.swPropertyDisplay.modalCallback = modalScope.swModalLauncher.launchModal;
                 $scope.swPropertyDisplay.hasModalCallback = true; 
            }
        }
    };
}
export{
    SWPropertyDisplay
}