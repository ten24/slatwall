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
    public hasOnChangeCallback:boolean; 
    public onChangeCallback; 
    public hasSaveCallback:boolean; 
    public saveCallback; 
    public initialValue:any; 
    public inModal:boolean;
    public hasModalCallback:boolean; 
    public rowSaveEnabled:boolean; 
    public modalCallback;
    public showSave:boolean; 

    //@ngInject
    constructor(
        private listingService,
        private observerService,
        private utilityService,
        public $filter
    ){
        this.errors = {};
        this.edited = false; 
        this.initialValue = this.object.data[this.property]; 
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
        if(angular.isDefined(this.object.metaData[this.property])){
            if(angular.isUndefined(this.fieldType)){
                this.fieldType = this.object.metaData.$$getPropertyFieldType(this.property);
            }

            if(angular.isUndefined(this.hint)){
                this.hint = this.object.metaData.$$getPropertyHint(this.property);
            }

            if(angular.isUndefined(this.title)){
                this.title = this.object.metaData.$$getPropertyTitle(this.property);
            }
        }
    };


    public getNgClassObjectForInput = () => {
        return "{'form-control':propertyDisplay.inListingDisplay, 'input-xs':propertyDisplay.inListingDisplay}";
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
        this.edited = false; 
        this.object.data[this.property] = this.initialValue; 
        if(this.inListingDisplay && this.rowSaveEnabled){
            this.listingService.markUnedited( this.listingID, 
                                              this.pageRecordIndex, 
                                              this.propertyDisplayID
                                            );
        }
    }

    public save = () =>{
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
    public templateUrl;
    public require = {form:'^form'};
    public restrict = 'AE';
    public scope = {};

    public bindToController = {
        property:"@",
        object:"=?",
        options:"=?",
        edited:"=?",
        editable:"=?",
        editing:"=?",
        isHidden:"=?",
        title:"=?",
        hint:"@?",
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
        showSave:"=?",
        placeholderText:"@",
        placeholderRbKey:"@"
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

        if(angular.isDefined($scope.swPropertyDisplay.inListingDisplay) && $scope.swPropertyDisplay.inListingDisplay){
                
            var currentScope = this.scopeService.locateParentScope($scope, "pageRecord");
            if(angular.isDefined(currentScope["pageRecord"])){
                $scope.swPropertyDisplay.pageRecord = currentScope["pageRecord"];
            }
            
            var currentScope = this.scopeService.locateParentScope($scope, "pageRecordKey");
            if(angular.isDefined(currentScope["pageRecordKey"])){
                $scope.swPropertyDisplay.pageRecordIndex = currentScope["pageRecordKey"];
            }

            var currentScope = this.scopeService.locateParentScope($scope, "swMultiListingDisplay");
            if(angular.isDefined(currentScope["swMultiListingDisplay"])){
                $scope.swPropertyDisplay.listingID = currentScope["swMultiListingDisplay"].tableID;
            }
        }

        if(angular.isDefined($scope.swPropertyDisplay.inModal) && $scope.swPropertyDisplay.inModal){
            
            var modalScope = this.scopeService.locateParentScope($scope, "swModalLauncher");
            $scope.swPropertyDisplay.modalName = modalScope.swModalLauncher.modalName; 
            
            if(angular.isFunction(modalScope.swModalLauncher.launchModal)){
                 $scope.swPropertyDisplay.modalCallback = modalScope.swModalLauncher.launchModal;
                 $scope.swPropertyDisplay.hasModalCallback = true; 
            }
        }
    };
}
export{
    SWPropertyDisplay
}