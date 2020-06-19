/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWTabContentController {
    public id:string; 
    public name:string; 
    public active:boolean; 
    public hide:boolean; 
    public loaded:boolean;


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
        if(angular.isUndefined(this.hide)){
            this.hide = false; 
        }
        if(angular.isUndefined(this.id)){
            this.id = utilityService.createID(16); 
        }
        if(angular.isUndefined(this.name)){
            this.name = this.id;
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
        hide:"=?",
        name:"@?"
    };
    public controller=SWTabContentController;
    public controllerAs="swTabContent";

    // @ngInject
    constructor(public $compile, private scopeService, private observerService, private corePartialsPath,hibachiPathBuilder){
        this.templateUrl = hibachiPathBuilder.buildPartialsPath(corePartialsPath) + "tabcontent.html";
    }

    public compile = (element: JQuery, attrs: angular.IAttributes, transclude: any) => {
        return {
            pre: ($scope: any, element: JQuery, attrs: angular.IAttributes) => {
                
            },
            post: ($scope: any, element: JQuery, attrs: angular.IAttributes) => {
                var parentDirective = this.scopeService.getRootParentScope($scope,"swTabGroup")["swTabGroup"];
                if(angular.isDefined(parentDirective) && angular.isDefined(parentDirective.tabs)){
                    parentDirective.tabs.push($scope.swTabContent);
                    this.observerService.notify(parentDirective.initTabEventName);
                }
            }
        };
    }

    public static Factory(){
        var directive:ng.IDirectiveFactory = (
            $compile
            ,scopeService 
            ,observerService
            ,corePartialsPath
            ,hibachiPathBuilder

        )=> new SWTabContent(
            $compile
            ,scopeService
            ,observerService
            ,corePartialsPath
            ,hibachiPathBuilder
        );
        directive.$inject = ["$compile",
                             "scopeService",
                             "observerService",
                             "corePartialsPath",
                             "hibachiPathBuilder"];
        return directive;
    }
}
export{
    SWTabContent,
    SWTabContentController
}
