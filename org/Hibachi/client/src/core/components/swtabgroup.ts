/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWTabGroupController {
    public tabGroupID:string; 
    public switchTabEventName:string; 
    public tabs:any[]; 

    // @ngInject
    constructor(private utilityService, 
                private rbkeyService, 
                private observerService
        ){
        if(angular.isUndefined(this.tabs)){
            this.tabs = []; 
        } 
        this.tabGroupID = "TG" + this.utilityService.createID(30);
        this.switchTabEventName = "SwitchTab:" + this.tabGroupID;
        this.observerService.attach(this.switchTab, this.switchTabEventName)
    }

    public switchTab = (tabToActivate) => {
        console.log("switchTab called", tabToActivate)
        for(var i = 0; i < this.tabs.length; i++){
            this.tabs[i].active = false; 
        }
        tabToActivate.active = true;  
        tabToActivate.loaded = true;  
    }

    public getTabByName = (name) =>{
        for(var i = 0; i < this.tabs.length; i++){
            if(this.tabs[i].name == name){
                return this.tabs[i]; 
            }
        }
    }
}

class SWTabGroup implements ng.IDirective{

    public templateUrl;
    public transclude=true; 
    public restrict = "EA";
    public scope = {};

    public bindToController = {

    };
    public controller=SWTabGroupController;
    public controllerAs="swTabGroup";

    // @ngInject
    constructor(public $compile, private corePartialsPath,hibachiPathBuilder){
        this.templateUrl = hibachiPathBuilder.buildPartialsPath(corePartialsPath) + "tabgroup.html";
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
        )=> new SWTabGroup(
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
    SWTabGroup,
    SWTabGroupController
}