/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWModalLauncherController {

    public showModal:boolean; 
    public modalName:string; 
    public title:string; 
    public hasSaveAction:boolean=false;
    public hasCancelAction:boolean=false;
    public hasDeleteAction:boolean=false; 

    public saveActionText:string; 
    public cancelActionText:string; 

    //callbacks
    public saveAction;
    public cancelAction;
    public deleteAction; 
    
    // @ngInject
    constructor(){
        if(angular.isUndefined(this.showModal)){
            this.showModal = false; 
        }
        if(angular.isUndefined(this.saveActionText)){
            this.saveActionText = "Save"; 
        }
        if(angular.isUndefined(this.cancelActionText)){
            this.cancelActionText = "Cancel"; 
        }
    }
    
    public launchModal = () =>{
        //activate the necessary modal
        this.showModal = true; 
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

    public templateUrl;
    transclude = {
        button: '?swModalButton',
        staticButton: '?swModalStaticButton',
        content: '?swModalContent'
    };
    public restrict = "EA";
    public scope = {};
    public bindToController = {
        showModal:"=?",
        modalName:"@", 
        title:"@",
        saveAction:"&?",
        deleteAction:"&?",
        cancelAction:"&?",
        saveActionText:"@?",
        cancelActionText:"@?"
    };
    public controller=SWModalLauncherController;
    public controllerAs="swModalLauncher";

    // @ngInject
    constructor(public $compile, private corePartialsPath,hibachiPathBuilder){
        this.templateUrl = hibachiPathBuilder.buildPartialsPath(corePartialsPath) + "modallauncher.html";
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

    public static Factory(){
        var directive:ng.IDirectiveFactory = (
            $compile
            ,corePartialsPath
            ,hibachiPathBuilder

        )=> new SWModalLauncher(
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
    SWModalLauncher,
    SWModalLauncherController
}