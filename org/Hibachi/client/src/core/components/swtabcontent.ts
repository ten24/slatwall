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
    public controllerAs="swTabContent";

    // @ngInject
    constructor(public $compile, private corePartialsPath,hibachiPathBuilder){
        this.templateUrl = hibachiPathBuilder.buildPartialsPath(corePartialsPath) + "tabcontent.html";
    }

    public compile = (element: JQuery, attrs: angular.IAttributes, transclude: any) => {
        return {
            pre: ($scope: any, element: JQuery, attrs: angular.IAttributes) => {
                
            },
            post: ($scope: any, element: JQuery, attrs: angular.IAttributes) => {
                var currentScope = $scope  
                for(var tries = 0; tries < 5; tries++){
                    currentScope = currentScope.$parent;
                    if(angular.isDefined(currentScope)){
                        var parentDirective = currentScope["swTabGroup"];
                    } 
                    if(angular.isDefined(parentDirective)){
                        break; 
                    }
                }
                if(angular.isDefined(parentDirective) && angular.isDefined(parentDirective.tabs)){
                    console.log("white whale", $scope.swTabContent, parentDirective);
                    parentDirective.tabs.push($scope.swTabContent);
                    if(parentDirective.tabs.length == 1){
                        $scope.swTabContent.active = true; 
                    }
                }
            }
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