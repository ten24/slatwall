/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWModalWindowController {

    public modalName;
    public title; 
    
    public showExit:boolean;
    public hasSaveAction:boolean; 
    public hasCancelAction:boolean;
    public saveAction;
    public cancelAction;
    
    public saveDisabled:boolean;

    public saveActionText:string; 
    public cancelActionText:string; 
    
    public swModalLauncher;

    // @ngInject
    constructor(){
       
    }
    
    public $onInit = () =>{
        this.modalName = this.swModalLauncher.modalName;
        this.title = this.swModalLauncher.title;
        this.showExit = this.swModalLauncher.showExit;
        this.hasSaveAction = this.swModalLauncher.hasSaveAction;
        this.hasCancelAction = this.swModalLauncher.hasCancelAction;
        this.saveAction = this.swModalLauncher.saveAction;
        this.cancelAction = this.swModalLauncher.cancelAction; 
        this.saveActionText = this.swModalLauncher.saveActionText; 
        this.cancelActionText = this.swModalLauncher.cancelActionText;
        
        if(angular.isUndefined(this.modalName)){
            throw("You did not pass a modal title to SWModalWindowController");
        }
    }

}

class SWModalWindow implements ng.IDirective{

    public transclude={
        modalBody:"?swModalBody"
    }; 
    public restrict = "EA";
    public require = {
        swModalLauncher:"^^swModalLauncher"
    };
    public scope = {};

    public bindToController = {
        modalName:"@",
        title:"@",
        showExit:"=?",
        saveDisabled:"=?",
        hasSaveAction:"=?",
        saveAction:"&?",
        hasDeleteAction:"=?",
        deleteAction:"&?",
        hasCancelAction:"=?",
        cancelAction:"&?",
        saveActionText:"@", 
        cancelActionText:"@"
    };
    public controller=SWModalWindowController;
    public controllerAs="swModalWindow";
    
    public template = require("./modalwindow.html");

	public static Factory(){
		return /** @ngInject; */ ($compile) => new this($compile);
	}

    // @ngInject
    constructor(public $compile){}
}
export{
    SWModalWindow,
    SWModalWindowController
}