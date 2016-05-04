/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWFormFieldSingleEditController {
    
    public property:string;
    public object:any;
    public options:{};
    public edited:boolean; 
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
    

    public singleEditedObject:any; 

    // @ngInject
    constructor(private $hibachi
        ){
        /* init the object that will actually be saved 
         * (so we don't accidentily change other fields 
         * that have been changed on the past object)
         */
        angular.copy(this.object, this.singleEditedObject);
    }
    
    public save = () => {
        this.singleEditedObject.$$save().then((response)=>{
            //do anything?
        });
        this.edited = false;
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
        propertyDisplay:"=?"
    };
    public controller=SWFormFieldSingleEdit;
    public controllerAs="swFormFieldSingleEdit";

    // @ngInject
    constructor(public $compile, private coreFormPartialsPath,hibachiPathBuilder){
        this.templateUrl = hibachiPathBuilder.buildPartialsPath(coreFormPartialsPath) + "formfieldsingleedit.html";
    }

    public link:ng.IDirectiveLinkFn = ($scope, element: ng.IAugmentedJQuery, attrs:any, modelCtrl: ng.INgModelController) =>{
         if(angular.isDefined($scope.propertyDisplay)){
             angular.extend($scope.swFormFieldSingleEdit, $scope.propertyDisplay);
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