/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWSingleEditFieldController {
    
    public property;
    public object;
    public options;
    public editable;
    public editing;
    public isHidden;
    public title;
    public hint;
    public optionsArguments;
    public eagerLoadOptions;
    public isDirty;
    public onChange;
    public fieldType;
    public noValidate;

    // @ngInject
    constructor(private $scope, 
                private $q,
                private $hibachi, 
                private $timeout:ng.ITimeoutService, 
                private utilityService, 
                private rbkeyService, 
                private collectionConfigService
        ){

    }

}

class SWSingleEditField implements ng.IDirective{

    public templateUrl;
    public restrict = "EA";
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
        onChange:"=?",
        fieldType:"@?",
        noValidate:"=?"
    };
    public controller=SWSingleEditField;
    public controllerAs="swSingleEditField";

    // @ngInject
    constructor(public $compile, private corePartialsPath,hibachiPathBuilder){
        this.templateUrl = hibachiPathBuilder.buildPartialsPath(corePartialsPath) + "singleeditfield.html";
    }

    public compile = (element: JQuery, attrs: angular.IAttributes, transclude: any) => {
        return {
            pre: ($scope: any, element: JQuery, attrs: angular.IAttributes) => {
            },
            post: ($scope: any, element: JQuery, attrs: angular.IAttributes) => {
            }
        };
    }

    public static Factory(){
        var directive:ng.IDirectiveFactory = (
            $compile
            ,corePartialsPath
            ,hibachiPathBuilder

        )=> new SWSingleEditField(
            $compile
            ,corePartialsPath
            ,hibachiPathBuilder
        );
        directive.$inject = ["$compile","corePartialsPath",
            'hibachiPathBuilder'];
        return directive;
    }
}
export{
    SWSingleEditField,
    SWSingleEditFieldController
}