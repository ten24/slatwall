/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWOrderByControlsController {

    // @ngInject
    constructor(
        ){

    }
}

class SWOrderByControls implements ng.IDirective{

    public templateUrl;
    public transclude=true; 
    public restrict = "EA";
    public scope = {};

    public bindToController = {

    };
    public controller=SWOrderByControlsController;
    public controllerAs="swOrderByControls";

    // @ngInject
    constructor(public $compile, private scopeService, private corePartialsPath,hibachiPathBuilder){
        this.templateUrl = hibachiPathBuilder.buildPartialsPath(corePartialsPath) + "orderbycontrols.html";
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
            ,scopeService 
            ,corePartialsPath
            ,hibachiPathBuilder

        )=> new SWOrderByControls(
            $compile
            ,scopeService
            ,corePartialsPath
            ,hibachiPathBuilder
        );
        directive.$inject = ["$compile","scopeService","corePartialsPath",
            "hibachiPathBuilder"];
        return directive;
    }
}
export{
    SWOrderByControls,
    SWOrderByControlsController
}
