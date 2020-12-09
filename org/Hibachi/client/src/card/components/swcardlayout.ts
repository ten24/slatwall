/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

class SWCardLayoutController {
    public cardClass;
	//@ngInject
    constructor(private $log) {
        console.log("This card class", this.cardClass);
    }

    public $onInit = function() {
    };

} 

class SWCardLayout implements ng.IDirective {
    public controller:any=SWCardLayoutController;
    public controllerAs:string = 'SwCardLayoutController';
    public scope = {};
    public bindToController = {
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