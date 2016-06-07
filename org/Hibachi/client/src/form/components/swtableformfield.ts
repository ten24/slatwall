/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWTableFormFieldController {
    
    public property:string;
    public object:any;
    public options:{};
    public edited:boolean; 
    public saved:boolean; 
    public disabled:boolean;
    public revertSet:boolean; 
    public isHidden:boolean;
    public title:string;
    public hint:string;
    public optionsArguments:string;
    public eagerLoadOptions;
    public isDirty:boolean;
    public onChange;
    public fieldType:string;
    public noValidate:boolean;
    
    public formName:string; 

    public valueToRevertTo:any; 
    public ngModelValue:any; 
    
    public indicatorCallback;
    public hasIndicatorCallback;
    
    public currencyCode:string; 

    public singleEditedObject:any; 

    // @ngInject
    constructor(private $hibachi, 
                private utilityService
        ){
        this.formName = utilityService.createID(32);
        if(angular.isDefined(this.object)){
            this.singleEditedObject = angular.copy(this.object);
        } else {
            throw("You must provide SWTableFormFieldController an object!");
        }        
        if(angular.isUndefined(this.saved)){
            this.saved = false; 
        }
        if(angular.isUndefined(this.disabled)){
            this.disabled = false; 
        }
        if(angular.isUndefined(this.revertSet)){
            this.revertSet = false; 
        }
        if(angular.isUndefined(this.hasIndicatorCallback)){
            this.hasIndicatorCallback = false; 
        }
        if(angular.isDefined(this.singleEditedObject.data[this.property])){
            console.log("setting the prop", this.property, this.singleEditedObject.data[this.property])
            this.ngModelValue = this.singleEditedObject.data[this.property];
        }
    }
    
    public clear = () => {
        //todo
        this.ngModelValue = "";
    }
    
    public save = () => {
        this.singleEditedObject.$$save().then((response)=>{
            this.edited = false;           
            this.saved = true; 
        });     
    }
    
    public revert = () => {
        this.ngModelValue = this.valueToRevertTo;
        this.singleEditedObject.$$save().then((response)=>{
            this.edited = false; 
            this.saved = false; 
            this.revertSet = false; 
        });
    }

}

class SWTableFormField implements ng.IDirective{

    public templateUrl;
    public restrict = "EA";
    public scope = {};

    public bindToController = {
        property:"@",
        object:"=",
        options:"=?",
        edited:"=?",
        isHidden:"=?",
        title:"=?",
        hint:"@?",
        optionsArguments:"=?",
        eagerLoadOptions:"=?",
        isDirty:"=?",
        onChange:"=?",
        fieldType:"@?",
        noValidate:"=?",
        propertyDisplay:"=?",
        indicatorCallback:"&?", 
        currencyCode:"@",
        disabled:"=?"
    };
    public controller=SWTableFormFieldController;
    public controllerAs="swTableFormField";

    // @ngInject
    constructor(public $compile, private coreFormPartialsPath,hibachiPathBuilder){
        this.templateUrl = hibachiPathBuilder.buildPartialsPath(coreFormPartialsPath) + "tableformfield.html";
    }

    public link:ng.IDirectiveLinkFn = ($scope, element: ng.IAugmentedJQuery, attrs:any, modelCtrl: ng.INgModelController) =>{
         if(angular.isDefined(attrs.propertyDisplay) && angular.isDefined($scope.propertyDisplay)){
             //populate itself with propertyDisplay's properties
             angular.extend($scope.swTableFormField, $scope.propertyDisplay);
         }
         if(angular.isDefined(attrs.indicatorCallback)){
             $scope.swTableFormField.hasIndicatorCallback = true;    
         }
    }

    public static Factory(){
        var directive:ng.IDirectiveFactory = (
            $compile
            ,coreFormPartialsPath
            ,hibachiPathBuilder

        )=> new SWTableFormField(
            $compile
            ,coreFormPartialsPath
            ,hibachiPathBuilder
        );
        directive.$inject = [
            "$compile"
            ,"coreFormPartialsPath"
            ,'hibachiPathBuilder'
        ];
        return directive;
    }
}
export{
    SWTableFormField,
    SWTableFormFieldController
}