/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWModalLauncherController {

    public showModal:boolean; 
    public showExit:boolean;
    
    public modalOptions;
    
    public launchEventName:string;
    public modalName:string; 
    public title:string; 
    
    public hasSaveAction:boolean=false;
    public hasCancelAction:boolean=false;
    public hasDeleteAction:boolean=false; 

    public saveActionText:string; 
    public cancelActionText:string;
    
    public saveDisabled:boolean;

    //callbacks
    public saveAction;
    public cancelAction;
    public deleteAction; 
    
    // @ngInject
    constructor(public observerService){
        this.hasSaveAction = typeof this.saveAction === 'function';
        this.hasDeleteAction = typeof this.deleteAction === 'function';
        
        if(angular.isUndefined(this.hasCancelAction)){
            this.hasCancelAction = true;
        }
        if(angular.isUndefined(this.saveDisabled)){
            this.saveDisabled = false; 
        }
        if(angular.isUndefined(this.showExit)){
            this.showExit = true; 
        }
        if(angular.isUndefined(this.showModal)){
            this.showModal = false; 
        }
        if(angular.isUndefined(this.saveActionText)){
            this.saveActionText = "Save"; 
        }
        if(angular.isUndefined(this.cancelActionText)){
            this.cancelActionText = "Cancel"; 
        }
        if(angular.isUndefined(this.modalOptions)){
           this.modalOptions =  {};
        }
        
        if(angular.isDefined(this.launchEventName)){
            this.observerService.attach(this.launchModal, this.launchEventName);
        }
    }
    
    public launchModal = () =>{
        //this.showModal is only for use with custom template
        this.showModal = true; 
        
        //trigger bootstrap event to show modal
        $("#" + this.modalName).modal(this.modalOptions);
    }
    
    public saveCallback = () =>{
        //the passed save action must return a promise
        if(this.hasSaveAction){
            var savePromise = this.saveAction()(); 
        }
        savePromise.then(
            (response)=>{
                //if the action was sucessful
                $("#" + this.modalName).modal('hide');
            },
            (reason)=>{
                //if the action failed
            }
        );
    }

     public deleteCallback = () =>{
        //the passed save action must return a promise
        if(this.hasDeleteAction){
            var deletePromise = this.saveAction()(); 
        }
        deletePromise.then(
            (response)=>{
                //if the action was sucessful
                $("#" + this.modalName).modal('hide');
            },
            (reason)=>{
                //if the action failed
            }
        );
    }

    public cancelCallback = () =>{
        if(this.hasCancelAction){
            this.cancelAction()(); 
        }
    }
}

class SWModalLauncher implements ng.IDirective{

    public transclude = {
        button: '?swModalButton',
        staticButton: '?swModalStaticButton',
        content: '?swModalContent'
    };
    public restrict = "EA";
    public scope = {};
    public bindToController = {
        modalOptions:"<?",
        showModal:"=?",
        showExit:"=?",
        launchEventName:"@?",
        modalName:"@", 
        title:"@",
        saveDisabled:"=?",
        saveAction:"&?",
        deleteAction:"&?",
        cancelAction:"&?",
        saveActionText:"@?",
        cancelActionText:"@?",
        hasCancelAction:"=?"
    };
    public controller=SWModalLauncherController;
    public controllerAs="swModalLauncher";
    
    public template = require("./modallauncher.html");

	public static Factory(){
		return /** @ngInject; */ () => new this();
	}

    public compile = (element: JQuery, attrs: angular.IAttributes, transclude: any) => {
        return {
            pre: ($scope: any, element: JQuery, attrs) => {      
                if(angular.isDefined(attrs.saveAction)){
                   $scope.swModalLauncher.hasSaveAction = true; 
                }
                if(angular.isDefined(attrs.deleteAction)){
                    $scope.swModalLauncher.hasDeleteAction = true; 
                }
                if(angular.isDefined(attrs.cancelAction)){
                    $scope.swModalLauncher.hasCancelAction = true; 
                }
            },
            post: ($scope: any, element: JQuery, attrs: angular.IAttributes) => {
            }
        };
    }
}
export{
    SWModalLauncher,
    SWModalLauncherController
}