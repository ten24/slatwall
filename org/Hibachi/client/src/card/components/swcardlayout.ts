/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

class SWCardLayoutController {
    
	//@ngInject
    constructor(private $log) {}

    public $onInit = function() {
    };

} 

class SWCardLayout implements ng.IComponentOptions {
    public controller:any=SWCardLayoutController;
    public controllerAs:string = 'SwCardLayoutController';
    public bindings = {
        cardClass: "@?"
    };
    
    public transclude:any = {
        cardView: '?swCardView',
    }
    
    /**
     * This is a wrapper class for the card components that allow you to define the columns.
     */
    public templateUrl:string = "";
    
    //@ngInject
    constructor(cardPartialsPath, hibachiPathBuilder) { 
        this.templateUrl = hibachiPathBuilder.buildPartialsPath(cardPartialsPath + '/cardlayout.html');
    }
    
    /**
     * Handles injecting the partials path into this class
     */
    public static Factory(){
        var component:ng.IDirectiveFactory=(cardPartialsPath,hibachiPathBuilder)=>new SWCardLayout(cardPartialsPath, hibachiPathBuilder);
        component.$inject = ['cardPartialsPath','hibachiPathBuilder']
        return component;
    }
}
export {SWCardLayoutController, SWCardLayout};