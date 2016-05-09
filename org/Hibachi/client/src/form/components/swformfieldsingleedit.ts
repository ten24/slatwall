/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWFormFieldSingleEditController {
    
    public property:string;
    public object:any;
    public options:{};
    public edited:boolean; 
    public saved:boolean; 
    public isHidden:boolean;
    public title:string;
    public hint:string;
    public optionsArguments:string;
    public eagerLoadOptions;
    public isDirty:boolean;
    public onChange;
    public fieldType:string;
    public noValidate:boolean;
    
    public valueToRevertTo:any; 
    public ngModelValue:any; 
    
    public indicatorCallback;
    public hasIndicatorCallback;
    
    public currencyCode:string; 

    public singleEditedObject:any; 

    // @ngInject
    constructor(private $hibachi
        ){
        if(angular.isDefined(this.object)){
            angular.copy(this.object, this.singleEditedObject);
        } else {
            throw("You must provide SWFormFieldSingleEditController an object!");
        }        
        if(angular.isUndefined(this.saved)){
            this.saved = false; 
        }
        if(angular.isUndefined(this.hasIndicatorCallback)){
            this.hasIndicatorCallback = false; 
        }
    }
    
    public clear = () => {
        //todo
        this.ngModelValue = "";
    }
    
    public save = () => {
        console.log("cpt", this.singleEditedObject);
        this.singleEditedObject.$$save().then((response)=>{
            this.edited = false;           
            //do anything else?
        });     
    }
    
    public revert = () => {
        angular.copy(this.valueToRevertTo, this.ngModelValue);
        //call save? 
    }

}

class SWFormFieldSingleEdit implements ng.IDirective{

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
        currencyCode:"@"
    };
    public controller=SWFormFieldSingleEditController;
    public controllerAs="swFormFieldSingleEdit";

    // @ngInject
    constructor(public $compile, private coreFormPartialsPath,hibachiPathBuilder){
        this.templateUrl = hibachiPathBuilder.buildPartialsPath(coreFormPartialsPath) + "formfieldsingleedit.html";
    }

    public link:ng.IDirectiveLinkFn = ($scope, element: ng.IAugmentedJQuery, attrs:any, modelCtrl: ng.INgModelController) =>{
         if(angular.isDefined(attrs.propertyDisplay) && angular.isDefined($scope.propertyDisplay)){
             //populate itself with propertyDisplay's properties
             angular.extend($scope.swFormFieldSingleEdit, $scope.propertyDisplay);
         }
         if(angular.isDefined(attrs.indicatorCallback)){
             $scope.swFormFieldSingleEdit.hasIndicatorCallback = true;    
         }
    }

    public static Factory(){
        var directive:ng.IDirectiveFactory = (
            $compile
            ,coreFormPartialsPath
            ,hibachiPathBuilder

        )=> new SWFormFieldSingleEdit(
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
    SWFormFieldSingleEdit,
    SWFormFieldSingleEditController
}