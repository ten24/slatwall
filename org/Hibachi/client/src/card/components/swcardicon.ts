/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

class SWCardIconController {
    public iconMultiplier:string = "1x";

	//@ngInject
    constructor(private $log) {}

    public $onInit = function() {
    };

} 

class SWCardIcon implements ng.IDirective {
    public controller:any=SWCardIconController;
    public controllerAs:string = 'SwCardIconController';
    public scope = {};
    public bindToController:{[key: string]:string} = {
        iconName: "@?",
        iconMultiplier: "@?"
    };
    public transclude:boolean = true;
    public require:string = "^SWCardView";
    /**
     * This is a wrapper class for the card components that allow you to define the columns.
     */
    public templateUrl:string = "";
    
    //@ngInject
    constructor(cardPartialsPath, hibachiPathBuilder) { 
        this.templateUrl = hibachiPathBuilder.buildPartialsPath(cardPartialsPath + '/cardicon.html');
    }
    
    /**
     * Handles injecting the partials path into this class
     */
    public static Factory(){
        var component:ng.IDirectiveFactory=(cardPartialsPath,hibachiPathBuilder)=>new SWCardIcon(cardPartialsPath, hibachiPathBuilder);
        component.$inject = ['cardPartialsPath','hibachiPathBuilder']
        return component;
    }
}
export {SWCardIconController, SWCardIcon};