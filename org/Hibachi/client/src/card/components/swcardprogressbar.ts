/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

class SWCardProgressBarController {
    public valueMin:number = 0;
    public valueMax:number = 100;
    public valueNow:number = 0;

	//@ngInject
    constructor(private $log) {}

    public $onInit = function() {};

} 

class SWCardProgressBar implements ng.IDirective {
    public controller:any=SWCardProgressBarController;
    public scope = {};
    public controllerAs:string = 'SwCardProgressBarController';
    public bindToController:{[key: string]:string} = {
        valueMin: "@?",
        valueMax: "@?",
        valueNow: "@?"
    };
    public transclude:boolean = true;
    public require:string = "^SWCardView";
    /**
     * This is a wrapper class for the card components that allow you to define the columns.
     */
    public templateUrl:string = "";
    
    //@ngInject
    constructor(cardPartialsPath, hibachiPathBuilder) { 
        this.templateUrl = hibachiPathBuilder.buildPartialsPath(cardPartialsPath + '/cardprogressbar.html');
    }
    
    /**
     * Handles injecting the partials path into this class
     */
    public static Factory(){
        var component:ng.IDirectiveFactory=(cardPartialsPath,hibachiPathBuilder)=>new SWCardProgressBar(cardPartialsPath, hibachiPathBuilder);
        component.$inject = ['cardPartialsPath','hibachiPathBuilder']
        return component;
    }
}
export {SWCardProgressBarController, SWCardProgressBar};