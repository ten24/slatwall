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
    
	public template = require("./tabgroup.html");

	public static Factory(){
		return /** @ngInject; */ () => new this();
	}

}
export{
    SWTabGroup,
    SWTabGroupController
}