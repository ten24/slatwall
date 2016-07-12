/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWTabContentController {

    public active:boolean; 
    public loaded:boolean;
    public name:string; 

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
        if(angular.isUndefined(this.loaded)){
            this.loaded = false; 
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
        active:"=?",
        loaded:"=?",
        name:"@?"
    };
    public controller=SWTabContentController;
    public controllerAs="swTabContent";

    // @ngInject
    constructor(public $compile, private scopeService, private corePartialsPath,hibachiPathBuilder){
        this.templateUrl = hibachiPathBuilder.buildPartialsPath(corePartialsPath) + "tabcontent.html";
    }

    public compile = (element: JQuery, attrs: angular.IAttributes, transclude: any) => {
        return {
            pre: ($scope: any, element: JQuery, attrs: angular.IAttributes) => {
                
            },
            post: ($scope: any, element: JQuery, attrs: angular.IAttributes) => {
                var parentDirective = this.scopeService.locateParentScope($scope,"swTabGroup")["swTabGroup"];
                if(angular.isDefined(parentDirective) && angular.isDefined(parentDirective.tabs)){
                    parentDirective.tabs.push($scope.swTabContent);
                    if(parentDirective.tabs.length == 1){
                        $scope.swTabContent.active = true; 
                        $scope.swTabContent.loaded = true;
                    }
                }
            }
        };
    }

    public static Factory(){
        var directive:ng.IDirectiveFactory = (
            $compile
            ,scopeService 
            ,corePartialsPath
            ,hibachiPathBuilder

        )=> new SWTabContent(
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
    SWTabContent,
    SWTabContentController
}
