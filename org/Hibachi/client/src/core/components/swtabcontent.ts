/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWTabContentController {

    public active; 
    public name; 

    // @ngInject
    constructor(private $scope, 
                private $q,
                private $transclude, 
                private $hibachi, 
                private $timeout:ng.ITimeoutService, 
                private utilityService, 
                private rbkeyService, 
                private collectionConfigService
        ){
        if(angular.isUndefined(this.active)){
            this.active = false; 
        }
        if(angular.isUndefined(this.name)){
            //generate a unique name
        }
        //make a tab service? 
    }

}

class SWTabContent implements ng.IDirective{

    public templateUrl;
    public transclude=true; 
    public restrict = "EA";
    public scope = {};

    public bindToController = {
        "active":"=?",
        "name":"@?"
    };
    public controller=SWTabContentController;
    public controllerAs="swTabGroup";

    // @ngInject
    constructor(public $compile, private corePartialsPath,hibachiPathBuilder){
        this.templateUrl = hibachiPathBuilder.buildPartialsPath(corePartialsPath) + "tabcontent.html";
    }

    public compile = (element: JQuery, attrs: angular.IAttributes, transclude: any) => {
        return {
            pre: ($scope: any, element: JQuery, attrs: angular.IAttributes) => {},
            post: ($scope: any, element: JQuery, attrs: angular.IAttributes) => {}
        };
    }

    public static Factory(){
        var directive:ng.IDirectiveFactory = (
            $compile
            ,corePartialsPath
            ,hibachiPathBuilder

        )=> new SWTabContent(
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
    SWTabContent,
    SWTabContentController
}