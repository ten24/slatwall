/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWTabGroupController {
    public tabGroupID:string; 
    public name:string;
    public initTabEventName:string; 
    public resetTabEventName:string;
    public switchToTabEventName:string; //We listen to this event to switch tabs
    public switchTabEventName:string; //this event is fired when tabs are switched
    public switchTabGroupEventName:string;
    public tabs:any[]; 
    public hasActiveTab:boolean = false;

    // @ngInject
    constructor(private utilityService, 
                private rbkeyService, 
                private observerService
        ){
        if(angular.isUndefined(this.tabs)){
            this.tabs = []; 
        } 
        this.tabGroupID = "TG" + this.utilityService.createID(30);
        this.switchTabGroupEventName = "SwitchTabGroup" + this.tabGroupID;
        if(angular.isUndefined(this.initTabEventName)){
            this.initTabEventName = "InitTabForTabGroup" + this.tabGroupID
        }
        if(angular.isDefined(this.resetTabEventName)){
            this.observerService.attach(this.reset, this.resetTabEventName);
        }
        if(angular.isDefined(this.switchToTabEventName)){
            this.observerService.attach(this.switchToTab, this.switchToTabEventName);
        }
        this.observerService.attach(this.initTab, this.initTabEventName);
    }

    public initTab = () =>{
        for(var i = 0; i < this.tabs.length; i++){
            if(!this.tabs[i].hide){
                this.tabs[i].active = true;
                this.tabs[i].loaded = true; 
                break; 
            }
        }
    }

    public reset = () =>{
        var defaultSelected = false; 
        for(var i = 0; i < this.tabs.length; i++){
            this.tabs[i].loaded = false; 
            if(!this.tabs[i].hide && !defaultSelected){
                this.switchTab(this.tabs[i]);
                defaultSelected = true; 
            }
        }
    }
    
    public switchToTab = (tabName)=>{
        this.switchTab(this.getTabByName(tabName));
    }

    public switchTab = (tabToActivate) => {
        this.observerService.notify(this.switchTabGroupEventName);
        if(this.switchTabEventName){
            this.observerService.notify(this.switchTabEventName, tabToActivate);
        }
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
        switchTabEventName:"@?",
        switchToTabEventName:"@?",
        initTabEventName:"@?",
        resetTabEventName:"@?"
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