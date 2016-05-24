/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWModalLauncherController {

    public showModal:boolean; 
    public modalName:string; 
    public title:string; 
    public saveAction;
    public cancelAction;
    
    // @ngInject
    constructor(){
        if(angular.isUndefined(this.showModal)){
            this.showModal = false; 
        }
    }
    
    public launchModal = () =>{
        //activate the necessary modal
        this.showModal = true; 
    }
}

class SWModalLauncher implements ng.IDirective{

    public templateUrl;
    transclude = {
        button: '?swModalButton',
        content: '?swModalContent'
    };
    public restrict = "EA";
    public scope = {};
    public bindToController = {
        showModal:"=?",
        modalName:"@", 
        title:"@",
        saveAction:"&?", 
        cancelAction:"&?"
    };
    public controller=SWModalLauncherController;
    public controllerAs="swModalLauncher";

    // @ngInject
    constructor(public $compile, private corePartialsPath,hibachiPathBuilder){
        this.templateUrl = hibachiPathBuilder.buildPartialsPath(corePartialsPath) + "modallauncher.html";
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